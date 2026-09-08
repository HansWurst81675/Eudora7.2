---
name: dummy-statt-weglassen
description: "Nicht benutzte Funktionen, Methoden und Klassen als Dummy implementieren, statt sie auszubauen"
metadata: 
  node_type: memory
  type: project
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-07T08:30:06.510Z
---

Schranke: tools/bauen.ps1 (nach jeder Änderung an der Ersatzschicht — ein ausgebautes Symbol meldet sich als Binderfehler)

Gregors Vorgabe vom 28.08.2026: "fuer nicht genutzte funktionen, methoden und
klassen einfach einen dummy implementieren, wenn er nicht gebraucht wird."

Gilt fuer die ganze Portierung, besonders fuer die OT501-Ersatzschicht: alles,
was die Analyse als Kategorie C eingestuft hat (deklariert, aber von Eudora nie
aufgerufen), bekommt einen leeren Rumpf - keinen Ausbau aus Projektdateien,
keine geloeschten Deklarationen.

**Warum das besser ist als Weglassen:** Die Struktur des Originals bleibt
erhalten und damit vergleichbar mit den Stingray-Headern. Wird eine Funktion
spaeter doch gebraucht, ist der Platz dafuer da und die Signatur schon richtig.
Ein Ausbau muesste dagegen rueckgaengig gemacht werden und faellt beim Lesen
des Codes nicht auf.

**Wie:** Leerer Rumpf, dazu ein deutscher Kommentar, der sagt WARUM er leer ist
und woran man merkt, dass es stimmt - also die Belegstelle, dass Eudora die
Funktion nicht aufruft. Bei Rueckgabewerten den unverfaenglichsten Wert waehlen
und ihn begruenden (z. B. TRUE bei AcceptDrop, weil die Basisversion im Original
zustimmt).

**Sichtbare Meldung statt stillem Nichtstun.** Gregors Ergaenzung vom 28.08.2026:
Ein Dummy, den der Anwender ueber die Oberflaeche erreichen kann, muss sagen, dass
die Funktion nicht implementiert ist - kein stiller Rumpf. Ein still nichts tuender
Menuepunkt sieht aus wie ein Fehler und kostet spaeter Stunden bei der Fehlersuche.
Bei rein internen Methoden, die nie am Anwender ankommen, genuegt der leere Rumpf
mit Kommentar.

**Die Meldung darf das Programm nicht anhalten — Nachtrag 07.09.2026.** Genau
diese Vorgabe hat einen ganzen Testtag gekostet. Die Ersatzschicht meldete
*„Diese Funktion steht in dieser Fassung nicht zur Verfuegung: Die Leiste am
unteren Fensterrand … Eudora bleibt bedienbar."* — mit `AfxMessageBox`, also
**modal**, und aus einem Pfad, der beim **Fensteraufbau** durchlaufen wird
(Eintrag des Verfassen-Fensters in die Registerkartenleiste). Folge: der Dialog
schob sich vor das neue Fenster, die naechste Meldung kam sofort hinterher,
Eudora liess sich nicht mehr beenden. Gregors Befund am 06.09.2026, 16:55:
*„ja, es crasht nicht, aber es passiert auch nichts. beenden kann ich es auch
nicht. also kein grosser fortschritt: nichts statt crash ist auch keine
verbesserung!"* Die Meldung verhinderte genau das, was ihr eigener Text zusagte.

Daraus die Regel (Befund E-33): Ein Hinweis aus einem Dummy geht nach
`OutputDebugString` bzw. `PutDebugLog`, **nie** in eine modale Box — es sei
denn, der Dummy sitzt nachweislich in einem vom Anwender ausgeloesten
Befehlspfad (Menuepunkt, Knopfdruck) und **nicht** in einem Konstruktions-,
Aufbau- oder Zeichenpfad. Die Probe vor dem Einbau: *Kann diese Stelle waehrend
`OnCreate`, `LoadFrame`, `OnPaint` oder einer Schleife durchlaufen werden?* Wenn
ja, keine Box. Siehe [[erfolg-aus-anwendersicht]].

Ausgenommen sind Faelle, in denen ein Dummy stillschweigend falsches Verhalten
erzeugen wuerde. Dann keinen Dummy bauen, sondern die Stelle als Blocker
dokumentieren. Beispiel: `CTBarStaticBtn::AdjustSize` wird in
`ReadMessageFrame.cpp:425` wirklich aufgerufen - ein leerer Rumpf saehe richtig
aus und wuerde das Layout still zerstoeren.

Siehe auch [[quelldateien-nur-byte-erhaltend-aendern]].
