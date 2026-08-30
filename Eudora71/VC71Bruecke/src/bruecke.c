/*
 * bruecke.c  --  der handgeschriebene Teil der VC7.1-Bruecke.
 *
 * WOFUER
 * ------
 * Das Auslieferungspaket enthaelt zehn vorgebaute Fremd-DLLs von 2006, fuer
 * die es keine Quellen gibt (DirServ, EudoraBk, EuMemMgr, ISock, Ldap, Ph,
 * Paige32 sowie die drei Zusatzmodule SMIME, SpamHeaders, SpamWatch). Sie sind
 * an MSVCR71.dll gebunden - die Laufzeit von Visual C++ 7.1. Microsoft hat
 * dafuer nie ein eigenstaendiges Redistributable veroeffentlicht.
 *
 * Windows liefert aber selbst eine msvcrt.dll derselben Generation mit.
 * Gemessen (tools/vc71-bruecke-messen.pl, 30.08.2026): von den 118 Namen, die
 * die zehn DLLs aus MSVCR71.dll ziehen, exportiert msvcrt.dll 117. Diese 117
 * werden in src/msvcr71.def als echte PE-Forwarder weitergeleitet; dafuer ist
 * keine Zeile Code noetig.
 *
 * Uebrig bleiben elf Namen, die eine echte msvcr71.dll exportiert und
 * msvcrt.dll nicht. Genau die stehen in dieser Datei. Nur einer davon wird
 * tatsaechlich gebraucht - __security_error_handler, von allen zehn DLLs. Die
 * anderen zehn sind hier, damit die Bruecke ein vollstaendiger Ersatz ist und
 * nicht beim naechsten Modul wieder aufgemacht werden muss
 * (Arbeitsweise/dummy-statt-weglassen.md).
 *
 * KEINE LAUFZEIT
 * --------------
 * Diese DLL wird mit /NODEFAULTLIB gebaut und bindet nur kernel32.dll. Wuerde
 * sie die moderne CRT brauchen, waere das Problem nur verschoben statt
 * geloest. Darum:
 *   - keine CRT-Aufrufe, kein statischer Anfangswert, der Code braucht
 *   - kein /GS (sonst __security_check_cookie aus der CRT)
 *   - eigener Einsprungpunkt BrueckeDllEntry statt _DllMainCRTStartup
 *   - was aus msvcrt.dll gebraucht wird, wird zur Laufzeit ueber
 *     GetProcAddress geholt, nicht ueber eine Importbibliothek
 *
 * Nachzumessen mit:  dumpbin -dependents Eudora71/Bin/Release/msvcr71.dll
 */

#include <windows.h>
#include <stddef.h>     /* size_t, wchar_t - reine Kopfdatei, keine Laufzeit */
#include <stdarg.h>     /* va_list - dito */

/* ------------------------------------------------------------------ */
/*  Zugriff auf msvcrt.dll zur Laufzeit                                */
/* ------------------------------------------------------------------ */

/*
 * msvcrt.dll ist zu dem Zeitpunkt, an dem eine dieser Funktionen laufen kann,
 * bereits geladen: der Lader hat die Forwarder aus msvcr71.def aufgeloest,
 * bevor irgendein Aufruf ankommt. GetModuleHandleA reicht also. LoadLibraryA
 * steht nur als Rueckfallebene daneben, fuer den Fall, dass ein Modul die
 * Bruecke laedt, ohne einen einzigen Forwarder zu benutzen.
 */
static HMODULE bruecke_msvcrt(void)
{
    static HMODULE h;           /* kein Konstruktor noetig - Nullseite */
    if (h == NULL)
    {
        h = GetModuleHandleA("msvcrt.dll");
        if (h == NULL)
            h = LoadLibraryA("msvcrt.dll");
    }
    return h;
}

static FARPROC bruecke_aus_msvcrt(const char *name)
{
    HMODULE h = bruecke_msvcrt();
    return h ? GetProcAddress(h, name) : NULL;
}

/*
 * Meldung auf die Standardfehlerausgabe und in den Debugger. Ohne CRT, also
 * mit WriteFile statt fputs. Wird nur auf Absturzwegen benutzt.
 */
static void bruecke_melden(const char *text)
{
    HANDLE  h;
    DWORD   n = 0, len = 0;

    while (text[len] != '\0')
        len++;

    OutputDebugStringA(text);

    h = GetStdHandle(STD_ERROR_HANDLE);
    if (h != NULL && h != INVALID_HANDLE_VALUE)
        WriteFile(h, text, len, &n, NULL);
}

static void bruecke_abbrechen(void)
{
    /*
     * Bei einem Pufferueberlauf ist der Stapel bereits beschaedigt. Kein
     * Aufraeumen, kein Entladen, kein Dialog - nur weg. RaiseFailFastException
     * gibt es seit Windows 7; TerminateProcess steht als Rueckfall dahinter.
     * 0xC0000409 ist STATUS_STACK_BUFFER_OVERRUN, derselbe Code, den auch die
     * moderne CRT an dieser Stelle setzt.
     */
    RaiseFailFastException(NULL, NULL, 0);
    TerminateProcess(GetCurrentProcess(), (UINT)0xC0000409);
}

/* ------------------------------------------------------------------ */
/*  /GS - der Ueberlaufmelder von VC7.1                                */
/* ------------------------------------------------------------------ */

/*
 * Von allen zehn Fremd-DLLs importiert (gemessen). Der von /GS erzeugte
 * Prolog/Epilog-Code ruft ihn, wenn das Stapelplaetzchen beim Verlassen einer
 * Funktion nicht mehr stimmt. Signatur wie in der VC7.1-CRT (seccook.c):
 *
 *     void __cdecl __security_error_handler(int code, void *data);
 *
 * code ist _SECERR_BUFFER_OVERRUN (1), data zeigt auf den Rahmen. Der Weg
 * hierher wird nur bei einem echten Ueberlauf betreten; er endet immer im
 * Prozessende.
 */
typedef void (__cdecl *BRUECKE_SECERR)(int code, void *data);

static BRUECKE_SECERR bruecke_secerr_handler;   /* Nullseite = keiner gesetzt */

void __cdecl bruecke_security_error_handler(int code, void *data)
{
    BRUECKE_SECERR eigener = bruecke_secerr_handler;

    if (eigener != NULL)
    {
        /*
         * VC7.1 laesst ein Programm ueber _set_security_error_handler einen
         * eigenen Melder einhaengen. Der darf zurueckkehren; danach beendet
         * die CRT den Prozess trotzdem. Genau so hier.
         */
        eigener(code, data);
    }
    else
    {
        bruecke_melden("msvcr71 (VC71Bruecke): Pufferueberlauf erkannt (/GS). "
                       "Der Prozess wird beendet.\r\n");
    }

    bruecke_abbrechen();
}

/*
 * _set_security_error_handler (VC7.1) und __set_buffer_overrun_handler (VC7.0)
 * sind in der echten msvcr71.dll dieselbe Funktion: beide Exporte zeigen auf
 * RVA 0x7CEC (gemessen mit dumpbin -exports an Releases/msvcr71.dll). Deshalb
 * hier nur ein Rumpf, den msvcr71.def unter beiden Namen ausgibt.
 */
BRUECKE_SECERR __cdecl bruecke_set_security_error_handler(BRUECKE_SECERR neu)
{
    BRUECKE_SECERR alt = bruecke_secerr_handler;
    bruecke_secerr_handler = neu;
    return alt;
}

/*
 * __buffer_overrun - der aeltere Name desselben Wegs aus VC7.0. Wird von
 * keiner DLL des Pakets importiert (gemessen: 0 Verwendungen). Als cdecl
 * raeumt der Aufrufer auf, also ist ein Rumpf ohne Argumente auch dann
 * richtig, wenn ein Aufrufer welche uebergibt.
 */
void __cdecl bruecke_buffer_overrun(void)
{
    bruecke_security_error_handler(1 /* _SECERR_BUFFER_OVERRUN */, NULL);
}

/* ------------------------------------------------------------------ */
/*  _purecall                                                          */
/* ------------------------------------------------------------------ */

/*
 * _purecall selbst exportiert msvcrt.dll und koennte weitergeleitet werden.
 * Dann liefe aber _set_purecall_handler ins Leere: msvcrt.dll kennt diesen
 * Einhaengepunkt nicht, ein gesetzter Melder wuerde still nie gerufen. Ein
 * Dummy, der schweigend das Falsche tut, ist schlechter als ein kurzer eigener
 * Rumpf - also hier der eigene, der msvcrt._purecall nur als Rueckfall nutzt.
 *
 * Gebraucht wird _purecall von DirServ, ISock, Ldap und Ph (gemessen).
 */
typedef void (__cdecl *BRUECKE_PURECALL)(void);

static BRUECKE_PURECALL bruecke_purecall_handler;

void __cdecl bruecke_purecall(void)
{
    BRUECKE_PURECALL eigener = bruecke_purecall_handler;
    BRUECKE_PURECALL ausMsvcrt;

    if (eigener != NULL)
    {
        eigener();
        /* Kehrt der Melder zurueck, gilt derselbe Vertrag wie in der CRT:
           der Aufruf einer rein virtuellen Funktion ist nicht fortsetzbar. */
    }

    ausMsvcrt = (BRUECKE_PURECALL)bruecke_aus_msvcrt("_purecall");
    if (ausMsvcrt != NULL)
        ausMsvcrt();

    bruecke_melden("msvcr71 (VC71Bruecke): Aufruf einer rein virtuellen "
                   "Funktion. Der Prozess wird beendet.\r\n");
    bruecke_abbrechen();
}

BRUECKE_PURECALL __cdecl bruecke_set_purecall_handler(BRUECKE_PURECALL neu)
{
    BRUECKE_PURECALL alt = bruecke_purecall_handler;
    bruecke_purecall_handler = neu;
    return alt;
}

/* ------------------------------------------------------------------ */
/*  swprintf / vswprintf mit Laengenangabe                             */
/* ------------------------------------------------------------------ */

/*
 * VC7.1 exportiert vier C++-Ueberladungen mit einem zusaetzlichen
 * Laengenargument:
 *
 *     int swprintf (wchar_t *puf, size_t n, const wchar_t *fmt, ...);
 *     int vswprintf(wchar_t *puf, size_t n, const wchar_t *fmt, va_list ap);
 *
 * je einmal fuer wchar_t als eigenen Typ (_W) und als unsigned short (G).
 * msvcrt.dll hat nur das alte swprintf OHNE Laengenargument - eine
 * Weiterleitung darauf wuerde die Argumente verschieben und in den Puffer
 * hineinschreiben, was eigentlich das Format ist. Deshalb hier ein eigener
 * Rumpf ueber _vsnwprintf, das msvcrt.dll exportiert.
 *
 * Von keiner DLL des Pakets importiert (gemessen: 0 Verwendungen).
 */
typedef int (__cdecl *BRUECKE_VSNWPRINTF)(wchar_t *, size_t, const wchar_t *, va_list);

int __cdecl bruecke_vswprintf(wchar_t *puf, size_t n, const wchar_t *fmt, va_list ap)
{
    BRUECKE_VSNWPRINTF f = (BRUECKE_VSNWPRINTF)bruecke_aus_msvcrt("_vsnwprintf");
    int ergebnis;

    if (f == NULL)
        return -1;

    ergebnis = f(puf, n, fmt, ap);

    /* _vsnwprintf schliesst bei genau passender Laenge nicht ab, swprintf
       schon. Der Unterschied ist der haeufigste Fehler bei diesem Ersatz. */
    if (n > 0 && (ergebnis < 0 || (size_t)ergebnis >= n))
        puf[n - 1] = L'\0';

    return ergebnis;
}

int __cdecl bruecke_swprintf(wchar_t *puf, size_t n, const wchar_t *fmt, ...)
{
    va_list ap;
    int ergebnis;

    va_start(ap, fmt);
    ergebnis = bruecke_vswprintf(puf, n, fmt, ap);
    va_end(ap);

    return ergebnis;
}

/*
 * DIESE BEIDEN RUEMPFE WERDEN DERZEIT NICHT EXPORTIERT - und zwar nicht aus
 * Nachlaessigkeit, sondern weil der Binder von VS2022 es nicht hergibt.
 *
 * Gemessen am 30.08.2026, alle vier Wege durchprobiert:
 *   - in der .def als  ?swprintf@@YAHPAGIPBGZZ=bruecke_swprintf
 *   - dasselbe in Anfuehrungszeichen
 *   - als #pragma comment(linker, "/EXPORT:...") aus dieser Datei
 *   - als /EXPORT auf der Befehlszeile, auch mit ausdruecklicher Ordinalzahl
 * In jedem Fall schneidet LINK den Exportnamen beim ersten '@' ab und legt
 * "?swprintf" ins Exportverzeichnis - fuer BEIDE Ueberladungen denselben
 * Namen. Das waere schlechter als gar kein Export: ein Verzeichnis mit zwei
 * gleichen Namen ist nicht mehr nach Namen durchsuchbar.
 * (Bei einer reinen Weiterleitung tritt der Fehler nicht auf; dort stehen die
 * vollen C++-Namen korrekt drin - siehe ??2@YAPAXI@Z in der .def.)
 *
 * Auswirkung: keine. Gemessen ueber alle 44 PE-Dateien des Pakets importiert
 * KEINE einzige diese vier Namen. Sie sind reine Vollstaendigkeit.
 *
 * Die Rueempfe bleiben trotzdem stehen (Arbeitsweise/dummy-statt-weglassen.md):
 * wer einen Weg findet, den Namen unverstuemmelt auszugeben, traegt nur die
 * Exportzeile nach und muss nichts neu schreiben.
 */

/* ------------------------------------------------------------------ */
/*  Reste                                                              */
/* ------------------------------------------------------------------ */

/*
 * _CRT_RTC_INIT richtet die Laufzeitpruefungen (/RTC) ein und wird nur von
 * Uebersetzungseinheiten gerufen, die mit /RTC gebaut wurden. Keine der zehn
 * Fremd-DLLs tut das (gemessen: 0 Verwendungen). Leerer Rumpf statt
 * Weglassen - so bleibt die Bruecke ladbar, falls doch einmal ein solches
 * Modul dazukommt; es liefe dann ohne Laufzeitpruefung, aber es liefe.
 */
void * __cdecl bruecke_CRT_RTC_INIT(void *res0, void **res1, int res2, int res3, int res4)
{
    (void)res0; (void)res1; (void)res2; (void)res3; (void)res4;
    return NULL;
}

/*
 * __lc_clike ist in msvcr71.dll ein Datenexport (RVA 0x4D7A8 liegt im
 * Datenabschnitt - gemessen) und sagt, ob die eingestellte Landessprache
 * "C"-artig ist. Beim Programmstart ist sie das immer.
 *
 * UNGEPRUEFT: wechselt ein Modul die Landessprache ueber msvcrt.setlocale,
 * merkt diese Kopie das nicht - sie gehoert zur Bruecke, nicht zu msvcrt.
 * Da keine der zehn Fremd-DLLs __lc_clike importiert (gemessen: 0
 * Verwendungen), hat das heute keine Wirkung. Wer den Namen doch einmal
 * braucht, muss ihn ueber msvcrt.__lc_handle nachziehen.
 */
int bruecke_lc_clike = 1;

/* ------------------------------------------------------------------ */
/*  Einsprungpunkt                                                     */
/* ------------------------------------------------------------------ */

/*
 * Ersetzt _DllMainCRTStartup. Es gibt nichts einzurichten: alle Zustaende
 * dieser Datei liegen auf der Nullseite und sind damit schon richtig
 * vorbelegt. DisableThreadLibraryCalls spart die Benachrichtigung bei jedem
 * Thread - die Bruecke hat keinen threadgebundenen Zustand.
 */
BOOL WINAPI BrueckeDllEntry(HINSTANCE modul, DWORD grund, LPVOID reserviert)
{
    (void)reserviert;

    if (grund == DLL_PROCESS_ATTACH)
        DisableThreadLibraryCalls(modul);

    return TRUE;
}
