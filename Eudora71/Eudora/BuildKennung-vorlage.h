// BuildKennung-vorlage.h - Notfassung, wenn die Kennung nicht erzeugt werden kann
//
// Diese Datei ist in git verfolgt. Die echte BuildKennung.h ist es NICHT
// (.gitignore) - sie wird vor jedem Bau von tools/kennung-erzeugen.pl neu
// geschrieben.
//
// WARUM DAS SO GETRENNT IST (Befund PR-4/W-1)
//
// Solange BuildKennung.h selbst verfolgt war, stand nach einem frischen Klon
// die zuletzt eingecheckte Kennung darin - mit fremdem Commit und fremdem
// Zeitstempel. Faellt perl beim Bau aus, bricht der Bau richtigerweise nicht
// ab; das Fenster zeigte dann aber die Kennung eines ganz anderen Baus. Genau
// den Fehler sollte die Kennung verhindern.
//
// Jetzt kopiert der PreBuildEvent bei fehlendem perl diese Vorlage ueber
// BuildKennung.h. Das Fenster sagt dann ehrlich "unbekannt", und ein frischer
// Klon ohne perl uebersetzt trotzdem.

#ifndef __BUILDKENNUNG_H__
#define __BUILDKENNUNG_H__

#include <tchar.h>

#define EUDORA_BAU_KENNUNG _T("unbekannt")

#endif // __BUILDKENNUNG_H__
