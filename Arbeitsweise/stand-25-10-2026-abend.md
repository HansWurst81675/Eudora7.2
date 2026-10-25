---
name: stand-25-10-2026-abend
description: Was nach agenten-befunde-25-10b als Naechstes kommt - E-132 als Pruefstandsfall, TESTPLAN M1, LEKTOR-61-Funde, Logzeile rootcerts; noch nicht im Repo
metadata:
  type: project
---

Stand 25.10.2026 abends, Zweig `agenten-befunde-25-10b` wartet auf PRUEFER-53 und LEKTOR-62, dann PR.

**Als Naechstes (naechster Zweig, Name bei Gregor erfragen):**
1. **E-132 als Pruefstandsfall** - Gregor: *„e-132: ich teste nur bis schritt 4. schritt 5 geht nicht."* Schritt 5 ist ohne Ruecksetzen unmoeglich: Schritt 4 (No) schreibt `E132Abgelehnt=<dir>` in die `DEudora.ini` neben der EXE (`eudora.cpp:4176-4232`), der naechste Start fragt nicht mehr. Messskript: Rueckfrage per Fensterbotschaft (Merkmal: Text "belongs to another installation", Knoepfe Yes/No/Cancel, No vorgewaehlt), gemerkte Antwort zwischen den Schritten loeschen, SHA256 der fremden Eudora.ini, Protokollzeilen. `HKCU\Software\Qualcomm\Eudora\CommandLine\Current` vorher sichern, danach IMMER wiederherstellen, nur auf C:\Temp zeigen lassen. TESTPLAN M1: Schritte 1-4 fuer Gregor, Knopfnamen Yes/No/Cancel statt "Eigenes anlegen/Vorhandenes benutzen", Schritt 5 -> automatischer Fall.
2. **Logzeile rootcerts.p7b** ([[entscheidung-rootcerts-logzeile]]).
3. **LEKTOR-61** einarbeiten (11 Funde): ZIEL "19 von 19" vs. "fast" bei Kriterium 2/4 (improper argument ohne Befund), README "Bekannte Fehler" unvollstaendig, Ort fuer Gregors Testergebnisse fehlt (pruefbericht.pl:389-391 schliesst sie aus), E-150 fehlt im CHANGELOG, TESTPLAN 277 statt 301 Tests, "ab 7.2.0.123" in README.
4. **PRUEFER-52 K3-K6** (Werkzeugluecken), E-146 fortschreiben (Server lehnt Umbenennen ab).
5. Danach Testpaket 7.2.0.123 -> Gregors Test -> Release 7.2.1.<n> ([[entscheidung-marke-v7-2-1]]).

Schranke: keine - Uebergabenotiz fuer die naechste Sitzung; sie wird mit dem Einarbeiten erledigt.
