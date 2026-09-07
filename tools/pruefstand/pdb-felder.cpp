// pdb-felder.cpp - liest den Feldaufbau von Strukturen AUS EINER PDB.
//
// Damit wird gemessen, welche Offsets die 2005 gebaute Paige32.dll
// tatsaechlich benutzt - statt sie zu vermuten.
//
//   pdb-felder <pfad.pdb> [<Strukturname> ...]
//
// Ohne Strukturnamen werden alle Strukturen mit Groesse gelistet.
// Mit Namen wird je Struktur jedes Feld mit Offset und Groesse gedruckt.
//
// Bauen (32-Bit, damit es zur DLL passt - fuer das Lesen der PDB aber egal):
//   cl /nologo /EHsc /MD pdb-felder.cpp /I"%DIASDK%\include" ^
//      /link "%DIASDK%\lib\diaguids.lib" ole32.lib oleaut32.lib

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <dia2.h>
#include <stdio.h>
#include <string.h>
#include <wchar.h>

static void schmal(const wchar_t* w, char* aus, size_t n)
{
    size_t i = 0;
    if (!w) { aus[0] = 0; return; }
    for (; w[i] && i + 1 < n; ++i) aus[i] = (w[i] < 128) ? (char)w[i] : '?';
    aus[i] = 0;
}

static const char* artName(DWORD k)
{
    switch (k) {
    case SymTagUDT: return "UDT";
    case SymTagEnum: return "enum";
    case SymTagTypedef: return "typedef";
    case SymTagBaseType: return "base";
    case SymTagPointerType: return "ptr";
    case SymTagArrayType: return "array";
    default: return "?";
    }
}

// Name des Typs eines Feldes, so gut es ohne Rekursion geht.
static void typName(IDiaSymbol* t, char* aus, size_t n)
{
    aus[0] = 0;
    if (!t) return;
    BSTR nm = 0;
    if (t->get_name(&nm) == S_OK && nm) { schmal(nm, aus, n); SysFreeString(nm); return; }
    DWORD tag = 0; t->get_symTag(&tag);
    ULONGLONG len = 0; t->get_length(&len);
    if (tag == SymTagPointerType) { _snprintf(aus, n, "ptr(%llu)", len); return; }
    if (tag == SymTagArrayType)   { _snprintf(aus, n, "array(%llu)", len); return; }
    if (tag == SymTagBaseType) {
        DWORD bt = 0; t->get_baseType(&bt);
        _snprintf(aus, n, "base%lu(%llu)", bt, len);
        return;
    }
    _snprintf(aus, n, "%s(%llu)", artName(tag), len);
}

static void felderDrucken(IDiaSymbol* udt, int tiefe, DWORD basis)
{
    IDiaEnumSymbols* e = 0;
    if (udt->findChildren(SymTagData, 0, nsNone, &e) != S_OK || !e) return;
    IDiaSymbol* k = 0; ULONG geholt = 0;
    while (e->Next(1, &k, &geholt) == S_OK && geholt == 1) {
        DWORD ort = 0; k->get_locationType(&ort);
        if (ort == LocIsThisRel || ort == LocIsBitField) {
            LONG off = 0; k->get_offset(&off);
            BSTR nm = 0; k->get_name(&nm);
            char n8[256]; schmal(nm, n8, sizeof n8); if (nm) SysFreeString(nm);
            IDiaSymbol* t = 0; k->get_type(&t);
            ULONGLONG len = 0; char tn[128] = "";
            if (t) { t->get_length(&len); typName(t, tn, sizeof tn); }
            printf("  %*s%-40s  Offset %5lu  Groesse %5llu  %s\n",
                   tiefe * 2, "", n8, (unsigned long)(basis + off), len, tn);
            // eingebettete Strukturen aufklappen (nur eine Ebene tiefer als verlangt)
            if (t && tiefe < 3) {
                DWORD tag = 0; t->get_symTag(&tag);
                if (tag == SymTagUDT) felderDrucken(t, tiefe + 1, basis + off);
            }
            if (t) t->Release();
        }
        k->Release(); k = 0;
    }
    e->Release();
}

int main(int argc, char** argv)
{
    if (argc < 2) { fprintf(stderr, "Aufruf: pdb-felder <pfad.pdb> [Strukturname ...]\n"); return 2; }

    if (FAILED(CoInitialize(0))) { fprintf(stderr, "CoInitialize gescheitert\n"); return 1; }

    // DIA ist auf dieser Maschine NICHT registriert (CoCreateInstance gibt
    // 0x80040154 REGDB_E_CLASSNOTREG). Deshalb wird msdia140.dll direkt
    // geladen und die Klassenfabrik von Hand geholt - das braucht kein
    // Administratorrecht und keine Registrierung.
    IDiaDataSource* q = 0;
    HRESULT hr = CoCreateInstance(CLSID_DiaSource, 0, CLSCTX_INPROC_SERVER,
                                  __uuidof(IDiaDataSource), (void**)&q);
    if (FAILED(hr)) {
        const char* kandidaten[] = {
            "C:/Program Files/Microsoft Visual Studio/2022/Professional/DIA SDK/bin/msdia140.dll",
            "C:/Program Files/Microsoft Visual Studio/2022/Professional/Common7/IDE/PrivateAssemblies/x86/msdia140.dll",
            "msdia140.dll", 0 };
        const char* genommen = 0;
        for (int i = 0; kandidaten[i] && !q; ++i) {
            HMODULE m = LoadLibraryA(kandidaten[i]);
            if (!m) continue;
            typedef HRESULT (WINAPI *HolFabrik)(REFCLSID, REFIID, void**);
            HolFabrik hol = (HolFabrik)GetProcAddress(m, "DllGetClassObject");
            if (!hol) continue;
            IClassFactory* f = 0;
            if (FAILED(hol(CLSID_DiaSource, IID_IClassFactory, (void**)&f)) || !f) continue;
            if (SUCCEEDED(f->CreateInstance(0, __uuidof(IDiaDataSource), (void**)&q)))
                genommen = kandidaten[i];
            f->Release();
        }
        if (!q) {
            fprintf(stderr, "DIA nicht ladbar (CoCreateInstance 0x%08lX, msdia140.dll auch nicht direkt)\n",
                    (unsigned long)hr);
            return 1;
        }
        fprintf(stderr, "Hinweis: DIA nicht registriert, geladen aus %s\n", genommen);
    }

    wchar_t pfad[1024];
    MultiByteToWideChar(CP_ACP, 0, argv[1], -1, pfad, 1024);
    hr = q->loadDataFromPdb(pfad);
    if (FAILED(hr)) { fprintf(stderr, "PDB nicht lesbar (0x%08lX)\n", (unsigned long)hr); return 1; }

    IDiaSession* s = 0;
    if (FAILED(q->openSession(&s))) { fprintf(stderr, "openSession gescheitert\n"); return 1; }
    IDiaSymbol* welt = 0;
    if (FAILED(s->get_globalScope(&welt))) { fprintf(stderr, "get_globalScope gescheitert\n"); return 1; }

    GUID g; DWORD alter = 0;
    if (welt->get_guid(&g) == S_OK) {
        welt->get_age(&alter);
        printf("PDB %s\n  GUID {%08lX-%04X-%04X-%02X%02X-%02X%02X%02X%02X%02X%02X}  Alter %lu\n",
               argv[1], g.Data1, g.Data2, g.Data3, g.Data4[0], g.Data4[1],
               g.Data4[2], g.Data4[3], g.Data4[4], g.Data4[5], g.Data4[6], g.Data4[7],
               (unsigned long)alter);
    }

    if (argc == 2) {
        IDiaEnumSymbols* e = 0;
        if (welt->findChildren(SymTagUDT, 0, nsNone, &e) == S_OK && e) {
            IDiaSymbol* k = 0; ULONG geholt = 0;
            while (e->Next(1, &k, &geholt) == S_OK && geholt == 1) {
                BSTR nm = 0; ULONGLONG len = 0;
                k->get_name(&nm); k->get_length(&len);
                char n8[256]; schmal(nm, n8, sizeof n8); if (nm) SysFreeString(nm);
                printf("%-50s  sizeof %6llu\n", n8, len);
                k->Release(); k = 0;
            }
            e->Release();
        }
        return 0;
    }

    for (int i = 2; i < argc; ++i) {
        wchar_t w[256];
        MultiByteToWideChar(CP_ACP, 0, argv[i], -1, w, 256);
        IDiaEnumSymbols* e = 0;
        int gefunden = 0;
        if (welt->findChildren(SymTagUDT, w, nsfCaseSensitive, &e) == S_OK && e) {
            IDiaSymbol* k = 0; ULONG geholt = 0;
            while (e->Next(1, &k, &geholt) == S_OK && geholt == 1) {
                ULONGLONG len = 0; k->get_length(&len);
                printf("\n=== %s  sizeof %llu ===\n", argv[i], len);
                felderDrucken(k, 0, 0);
                gefunden = 1;
                k->Release(); k = 0;
            }
            e->Release();
        }
        if (!gefunden) printf("\n=== %s: nicht in der PDB ===\n", argv[i]);
    }
    return 0;
}
