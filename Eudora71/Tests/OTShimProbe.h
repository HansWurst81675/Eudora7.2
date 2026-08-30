//
// OTShimProbe.h - gemeinsame Hilfsmittel der Tests gegen die OT501-Ersatzschicht
//
// Die Ersatzschicht unter Eudora71/OTShim uebersetzt eigenstaendig: jede .cpp
// bindet nur <afxwin.h> (und fuer die Stufen 2 und 3 die Originalheader aus
// OT501/Include) ein. Deshalb koennen OTShim.cpp, OTShim_Werkzeugleiste.cpp,
// OTShim_Reiter.cpp, OTShim_Palette.cpp und OTShim_Bild.cpp unmittelbar in
// dieses Testprogramm gebunden werden - es wird nichts abgeschrieben und
// nichts geschnitten, geprueft wird der Produktivcode selbst.
//
// EIN PROBLEM BLEIBT: OTShimNichtUmgesetzt (OTShim.cpp:154) oeffnet ein
// AfxMessageBox. Ein Testlauf darf kein Fenster oeffnen - ein modaler Dialog
// aus einem unbeaufsichtigten Lauf haelt alles an.
//
// Geloest wird das NICHT durch eine eigene Fassung der Funktion, sondern
// eine Ebene tiefer: das Testprogramm bringt ein CWinApp-Objekt mit, dessen
// DoMessageBox die Meldung nur mitschreibt. AfxMessageBox geht ueber
// AfxGetApp()->DoMessageBox (MFC, appui1.cpp:136-147), landet also dort. Der
// Vorteil gegenueber einem Ersatz der Funktion: geprueft wird der echte
// OTShimNichtUmgesetzt samt seinem Merkverhalten, und JEDE Meldung des
// Programms wird abgefangen, nicht nur die aus dieser einen Funktion.
//
#ifndef EUDORA_TESTS_OTSHIMPROBE_H
#define EUDORA_TESTS_OTSHIMPROBE_H

// Zahl der abgefangenen Meldungsfenster seit dem letzten Zuruecksetzen.
int  OTShimProbeMeldungen(void);

// Der Text der zuletzt abgefangenen Meldung (leer, wenn keine kam).
const char* OTShimProbeLetzteMeldung(void);

// Zaehler und letzte Meldung zuruecksetzen.
void OTShimProbeZuruecksetzen(void);

#endif
