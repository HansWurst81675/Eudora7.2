//
// OTShimProbe.h - gemeinsame Hilfsmittel der Tests gegen die OT501-Ersatzschicht
//
// Die Ersatzschicht unter Eudora71/OTShim uebersetzt eigenstaendig: jede .cpp
// bindet nur <afxwin.h> und ihre eigene Kopfdatei ein. Deshalb koennen
// OTShim_Bild.cpp, OTShim_Palette.cpp und OTShim_Reiter.cpp unmittelbar in
// dieses Testprogramm gebunden werden - es wird nichts abgeschrieben und
// nichts geschnitten, geprueft wird der Produktivcode selbst.
//
// EINE Ausnahme gibt es: OTShimNichtUmgesetzt. Die Sammelmeldung liegt in
// OTShim.cpp (Stufe 1), und OTShim.cpp zieht ueber OTShim.h die halbe
// Stingray-Welt nach. Vor allem aber oeffnet die Originalfassung ein
// AfxMessageBox - genau das, was ein Testlauf niemals tun darf. Diese Datei
// stellt deshalb eine Fassung bereit, die die Meldung nur zaehlt und
// aufbewahrt. Das ist kein Ausweichen: die Tests koennen damit ausdruecklich
// PRUEFEN, dass ein Rumpf sich meldet.
//
#ifndef EUDORA_TESTS_OTSHIMPROBE_H
#define EUDORA_TESTS_OTSHIMPROBE_H

// Zahl der bisher abgesetzten Meldungen seit dem letzten Zuruecksetzen.
int  OTShimProbeMeldungen(void);

// Die zuletzt abgesetzte Meldung (leere Zeichenkette, wenn keine kam).
const char* OTShimProbeLetzteMeldung(void);

// Zaehler und letzte Meldung zuruecksetzen.
void OTShimProbeZuruecksetzen(void);

#endif
