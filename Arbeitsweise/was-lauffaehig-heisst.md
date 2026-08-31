---
name: was-lauffaehig-heisst
description: "Gregors drei Kriterien für „lauffähig" — und dass ein erscheinendes, aber unbedienbares Fenster keines davon erfüllt"
metadata:
  type: project
---

Gregor hat am 30.08.2026 festgelegt, was „lauffähig" bei Eudora 7.2 heißt,
nachdem ich ein Paket so genannt hatte, das zwar startete, aber nicht bedienbar
war:

> * es genügt nicht, daß das programm startet
> * die darstellung sollte korrekt sein
> * ich möchte damit einen mail server verbinden und mails abrufen.

**Alle drei müssen erfüllt sein.** Vorher heißt eine Fassung, was sie ist — etwa
„startet" oder „Vorabfassung".

> **Nachtrag vom 31.08.2026: es sind vier.** Gregor hat ein **Kriterium 0**
> davorgesetzt, nachdem Paket 1.0.2 mit `0xc000007b` scheiterte: *„zip
> runterladen, entpacken, starten - läuft. keine fehlenden DLLs, keine
> fehlermeldungen, daß etwas nicht gefunden werden kann oder nachinstalliert
> werden muß"*. Es steht **vor** den anderen dreien, weil ohne lauffähiges
> Paket niemand die anderen prüfen kann. Maßgeblich ist die Tabelle in
> `ZIEL.md`.
>
> **Achtung, diese Datei ist ein Spiegel** (`tools/lehren-spiegeln.pl` kopiert
> aus dem Gedächtnisverzeichnis ins Repo, nicht umgekehrt). Dieser Nachtrag
> geht beim nächsten Spiegeln verloren, solange die **Quelle im Gedächtnis**
> nicht nachgezogen wird — das ist Befund NP3-4. Wer mit dem Gedächtnis
> arbeitet, zieht ihn dort nach.

## Und Kriterium 1 ist strenger, als ich es gelesen habe

Ich hatte Kriterium 1 als erfüllt geführt, weil ein Fenster erscheint. Gregors
Antwort noch am selben Abend:

> *„halte ich für ein gerücht ... das hauptfenster ist ja kaputt!"*

Er hatte recht. Das Fenster war nicht bedienbar: Menüs ließen sich nicht öffnen,
Bereiche überlagerten sich, Werkzeugleisten-Knöpfe waren leer.

**„Zeigt sein Hauptfenster" heißt: man kann damit arbeiten — nicht: es sind
Pixel auf dem Schirm.**

**Why:** Ich habe an einem einzigen Tag **dreimal** denselben Fehler gemacht —
den Zustand beschönigt. Paket 1.0.1 als „lauffähig" ausgeliefert, obwohl es gar
nicht startete. Paket 1.0.2 als „lauffähig", obwohl nur ein Fenster erschien.
Und dann Kriterium 1 als erfüllt geführt, obwohl das Fenster kaputt war. Jedes
Mal musste Gregor es selbst herausfinden.

**How to apply:** Vor jeder Aussage über den Stand die Frage stellen: *Könnte
Gregor damit arbeiten?* Wenn nein, ist es nicht erfüllt — egal wie viel
technischer Fortschritt dahintersteckt. Fortschritt darf man „Meilenstein"
nennen; „erfüllt" ist reserviert für das, was benutzbar ist. Was nicht geprüft
ist, heißt „nicht geprüft", nicht „funktioniert vermutlich".

Steht ausführlich in `ZIEL.md` im Repo, mit derselben Begründung.

Siehe [[lauffaehiges-ergebnis-liefern]] und [[pruefen-statt-vermuten]].
