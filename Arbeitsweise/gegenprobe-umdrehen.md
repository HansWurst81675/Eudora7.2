---
name: gegenprobe-umdrehen
description: "Nicht pruefen, ob der gewuenschte Zustand erscheint, sondern ob der umgekehrte Wert durchkommt; Gregors Technik vom 07.09.2026"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-07T12:44:49.139Z
---

# Den Wert umdrehen, nicht bestaetigen

Am 07.09.2026 hatte ich `tools/DEudora.ini` mit `CheckMailByDefault=1`
angelegt und Gregor gesagt, das Haekchen *Check Mail* sei damit gesetzt. Er
antwortete: *„greift nicht"* — und hatte dafuer den besseren Test gefahren als
ich: er hat den Wert auf

    CheckMailByDefault=0

gesetzt. Das Haekchen blieb **trotzdem** an. Damit war in einem Zug bewiesen,
dass die Datei an dieser Stelle **gar nicht gelesen** wird — nicht nur, dass
der Wunschwert fehlte.

Mein Test dagegen war nicht unterscheidbar: `1` ist zufaellig auch die
eingebaute Vorgabe aus `EudoraRes.rc` (`IDS_INI_PERSONA_CHECK_MAIL
"CheckMailByDefault\n1"`). Haette die Datei gewirkt oder nicht — ich haette
beides Mal ein gesetztes Haekchen gesehen und beides Mal „wirkt" gemeldet.

Die Ursache lag dann an einer ganz anderen Stelle: zwei fast gleich benannte
Funktionen, von denen nur eine die Datei liest
(`GetDefaultIniSetting`, `rs.cpp:357` gegen `CPersonality::GetIniDefaultValue`,
`persona.cpp:606` — siehe [[erst-pruefen-dann-anweisen]]). Gefunden habe ich
das erst, **nachdem** seine umgedrehte Probe die Frage entschieden hatte.

**Warum:** Eine Probe, die den erwarteten Zustand bestaetigt, unterscheidet
nicht zwischen „mein Eingriff wirkt" und „es war sowieso schon so". Genau diese
Verwechslung erzeugt die Meldung „erledigt", die Gregor spaeter widerlegt — und
sie ist der Grund fuer seinen Satz *„ich traue dir nicht ganz"*. Ein
umgedrehter Wert hat dagegen nur einen moeglichen Ausgang, wenn der Weg
funktioniert.

**Wie anwenden — bei jeder Zusage „dieser Wert/Schalter wirkt jetzt":**

1. **Erst den Vorgabewert nachsehen.** Steht mein Wunschwert schon als Default
   in der Ressource, im Quelltext oder in der bestehenden Datei, ist die
   Bestaetigungsprobe wertlos. Dann **muss** umgedreht werden.
2. **Den Gegenwert setzen und den Gegen-Zustand erwarten.** Erscheint der
   Gegen-Zustand nicht, wird die Datei/der Schalter nicht gelesen — und das ist
   der Befund, nicht „hat nicht geklappt".
3. **Danach zurueckstellen**, mit gemessenem Beleg (Zeitstempel, Inhalt,
   Pruefsumme), damit kein Testwert im Auslieferungsstand liegen bleibt.
4. **Fuer Schranken gilt dasselbe in beide Richtungen:** den echten Fehler
   einbauen (muss rot werden) *und* den erlaubten Nachbarfall vorlegen (muss
   gruen bleiben) — [[schranke-gegentesten]].
5. **Und die Probe muss den Weg treffen**, sonst ist auch die umgedrehte
   wertlos — [[messung-muss-den-weg-treffen]].

Gregors Technik uebernehmen heisst: **die Frage so stellen, dass nur eine
Antwort moeglich ist.** Wenn ich die Probe so bauen kann, dass beide Faelle
gleich aussehen, habe ich sie falsch gebaut.

Siehe [[pruefen-statt-vermuten]] und [[erfolg-aus-anwendersicht]].
