/*
 * pruefe-bruecke.c - Pruefprogramm fuer die Ersatz-msvcr71.dll.
 *
 * Konsolenprogramm ohne Fenster. Es beantwortet die eine Frage, die eine
 * reine PE-Untersuchung offenlaesst: loest der Lader die 1429
 * Forwarder-Exporte zur Laufzeit wirklich auf?
 *
 * Was es tut:
 *   1. laedt die uebergebene msvcr71.dll
 *   2. schlaegt jeden Namen aus einer Namensliste mit GetProcAddress nach
 *      (GetProcAddress folgt Forwardern und laedt dabei msvcrt.dll nach)
 *   3. ruft malloc/strlen/free ueber die so geholten Zeiger wirklich auf
 *
 * Uebersetzen (32 Bit, aus einer VS-Eingabeaufforderung fuer x86):
 *     cl /nologo /W4 pruefe-bruecke.c
 *
 * Aufruf:
 *     pruefe-bruecke.exe ..\..\Bin\Release\msvcr71.dll ..\Messung\benoetigt-msvcr71.txt
 *
 * Rueckgabe: 0 wenn alles aufloest, sonst die Zahl der Fehlstellen.
 */

#include <windows.h>
#include <stdio.h>

typedef void * (__cdecl *malloc_t)(size_t);
typedef void   (__cdecl *free_t)(void *);
typedef size_t (__cdecl *strlen_t)(const char *);

int main(int argc, char **argv)
{
    HMODULE hDll;
    FILE   *fListe;
    char    zeile[512];
    int     nGesamt = 0, nFehlt = 0;
    malloc_t pMalloc;
    free_t   pFree;
    strlen_t pStrlen;
    char    *pBlock;

    if (argc < 3) {
        printf("Aufruf: pruefe-bruecke.exe <msvcr71.dll> <namensliste.txt>\n");
        return 2;
    }

    hDll = LoadLibraryA(argv[1]);
    if (!hDll) {
        printf("FEHLER: LoadLibrary(%s) scheiterte, GetLastError=%lu\n",
               argv[1], (unsigned long)GetLastError());
        return 2;
    }
    printf("geladen: %s\n", argv[1]);

    fListe = fopen(argv[2], "r");
    if (!fListe) {
        printf("FEHLER: %s nicht lesbar\n", argv[2]);
        return 2;
    }

    while (fgets(zeile, sizeof(zeile), fListe)) {
        char *p = zeile + strlen(zeile);
        while (p > zeile && (p[-1] == '\n' || p[-1] == '\r' || p[-1] == ' '))
            *--p = '\0';
        if (zeile[0] == '\0')
            continue;

        ++nGesamt;
        if (!GetProcAddress(hDll, zeile)) {
            printf("  FEHLT: %s (GetLastError=%lu)\n",
                   zeile, (unsigned long)GetLastError());
            ++nFehlt;
        }
    }
    fclose(fListe);
    printf("nachgeschlagen: %d Namen, davon nicht aufloesbar: %d\n", nGesamt, nFehlt);

    /* Nicht nur nachschlagen, sondern auch benutzen: erst damit ist
       bewiesen, dass hinter dem Forwarder wirklich der Code von msvcrt.dll
       steht und nicht bloss ein gueltig aussehender Zeiger. */
    pMalloc = (malloc_t)GetProcAddress(hDll, "malloc");
    pFree   = (free_t)  GetProcAddress(hDll, "free");
    pStrlen = (strlen_t)GetProcAddress(hDll, "strlen");
    if (pMalloc && pFree && pStrlen) {
        pBlock = (char *)pMalloc(64);
        if (pBlock) {
            memcpy(pBlock, "Bruecke", 8);
            printf("malloc/strlen/free ueber die Bruecke: strlen=%u (erwartet 7)\n",
                   (unsigned)pStrlen(pBlock));
            pFree(pBlock);
        } else {
            printf("FEHLER: malloc ueber die Bruecke lieferte NULL\n");
            ++nFehlt;
        }
    } else {
        printf("FEHLER: malloc/free/strlen nicht auffindbar\n");
        ++nFehlt;
    }

    FreeLibrary(hDll);
    return nFehlt;
}
