---
name: dummy-statt-weglassen
description: "Nicht benutzte Funktionen, Methoden und Klassen als Dummy implementieren, statt sie auszubauen"
metadata:
  type: project
---

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

Ausgenommen sind Faelle, in denen ein Dummy stillschweigend falsches Verhalten
erzeugen wuerde. Dann keinen Dummy bauen, sondern die Stelle als Blocker
dokumentieren. Beispiel: `CTBarStaticBtn::AdjustSize` wird in
`ReadMessageFrame.cpp:425` wirklich aufgerufen - ein leerer Rumpf saehe richtig
aus und wuerde das Layout still zerstoeren.

Siehe auch [[quelldateien-nur-byte-erhaltend-aendern]].
