/*
 * vc71bruecke.c - der Code-Anteil der Ersatz-msvcr71.dll.
 *
 * Der weitaus groesste Teil dieser DLL ist gar kein Code: msvcr71.def
 * leitet 1430 Exporte an C:\Windows\SysWOW64\msvcrt.dll weiter. Nur ein
 * einziger gemessener Name fehlt dort, und der steht hier.
 *
 * Diese Datei wird bewusst OHNE C-Laufzeitbibliothek uebersetzt und
 * gebunden (/NODEFAULTLIB, eigener Einsprungpunkt). Sonst haette die
 * Ersatz-msvcr71.dll selbst eine Abhaengigkeit auf die moderne CRT
 * (vcruntime140.dll / api-ms-win-crt-*.dll) und das Problem waere nur
 * verschoben statt geloest. Nachzumessen mit
 *
 *     dumpbin -dependents msvcr71.dll
 *
 * Es duerfen nur KERNEL32.dll und USER32.dll dastehen.
 */

#define WIN32_LEAN_AND_MEAN
#include <windows.h>

/*
 * __security_error_handler - der /GS-Ueberlaufmelder von Visual C++ 7.1.
 *
 * Warum er hier stehen muss: er ist der EINZIGE der 118 gemessenen
 * MSVCR71-Namen, den C:\Windows\SysWOW64\msvcrt.dll nicht exportiert.
 * Alle sieben Fremd-DLLs importieren ihn (gemessen mit dumpbin -imports;
 * Liste in Messung/benoetigt-msvcr71.txt).
 *
 * Wann er laeuft: nie im Normalbetrieb. Der Uebersetzer legt bei /GS vor
 * die Ruecksprungadresse einen Wachwert und prueft ihn beim Verlassen der
 * Funktion. Stimmt er nicht mehr, ist der Stapelrahmen ueberschrieben -
 * ein echter Pufferueberlauf. Erst dann wird hierher gesprungen.
 *
 * Vertrag (Visual C++ 7.1, crt/src/gs_report.c):
 *     void __cdecl __security_error_handler(int code, void *data);
 * code ist _SECERR_BUFFER_OVERRUN (== 1), data ist bei diesem Code die
 * Adresse der betroffenen Stelle. Die Originalfassung ruft einen vom
 * Programm gesetzten Melder auf und beendet danach den Prozess.
 *
 * Warum hier keine Meldung im Fenster erscheint: der Stapel ist an dieser
 * Stelle bereits beschaedigt. Alles, was noch Speicher anfasst oder
 * zurueckspringt, kann den Schaden vergroessern. OutputDebugStringA und
 * TerminateProcess sind das Wenigste, was noch geht.
 *
 * Warum nicht ExitProcess: ExitProcess laesst DllMain(DLL_PROCESS_DETACH)
 * und die atexit-Kette laufen - beides auf einem kaputten Stapel. Der
 * Ausgangscode 0xC0000409 ist STATUS_STACK_BUFFER_OVERRUN, derselbe, den
 * neuere Windows-Fassungen in diesem Fall melden.
 */
void __cdecl __security_error_handler(int code, void *data)
{
    (void)code;
    (void)data;

    OutputDebugStringA(
        "msvcr71.dll (VC71Bruecke): __security_error_handler - "
        "Pufferueberlauf erkannt, Prozess wird beendet.\r\n");

    TerminateProcess(GetCurrentProcess(), 0xC0000409u);

    /* TerminateProcess kehrt nicht zurueck. Die Schleife ist nur da,
       damit auch bei einem verhinderten Abbruch nichts weiterlaeuft. */
    for (;;)
        Sleep(1000);
}

/*
 * Eigener Einsprungpunkt. Er ersetzt _DllMainCRTStartup, das ohne
 * Laufzeitbibliothek nicht zur Verfuegung steht. Es gibt nichts
 * einzurichten: die DLL haelt keinen Zustand, sie besteht praktisch nur
 * aus Weiterleitungen.
 *
 * DisableThreadLibraryCalls spart die DLL_THREAD_ATTACH-Aufrufe; Eudora
 * legt zur Laufzeit viele Faeden an (THREADED ist in Eudora.vcxproj:67
 * gesetzt).
 */
BOOL WINAPI VC71BrueckeEinsprung(HINSTANCE hInstanz, DWORD nGrund, LPVOID pReserviert)
{
    (void)pReserviert;

    if (nGrund == DLL_PROCESS_ATTACH)
        DisableThreadLibraryCalls(hInstanz);

    return TRUE;
}
