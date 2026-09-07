---
name: erfolg-aus-anwendersicht
description: Erfolg wird daran gemessen, was Gregor danach tun kann; kein Crash ist keine Verbesserung
metadata:
  type: feedback
---

# Erfolg heißt: der Anwender kann etwas, was er vorher nicht konnte

**Gregor am 06.09.2026, 17:06 Uhr**, mit meiner eigenen Überschrift aus dem
`CHANGELOG.md` davor:

> *„7.2.0.18 / Paket 1.0.18 — 06.09.2026 · der Durchbruch*
>
> *für den anwender ist es kein durchbruch!"*

Elf Minuten zuvor, nachdem er das Paket selbst gestartet hatte:

> *„ich habe jetzt 0.18 selbst gestartet: ja, es crasht nicht, aber es passiert
> auch nichts.*
> *beenden kann ich es auch nicht.*
> *also kein großer fortschritt: nichts statt crash ist auch keine
> verbesserung!"*

## Was tatsächlich passiert ist

Technisch war der Tag ein guter: die Ursache des Strg-N-Absturzes war belegt —
`pg_time_t` war unter VS2022 acht Byte breit statt vier
(`Eudora71/PaigeDLL/PGHEADER/CPUDEFS.H`, Commit `ae0e165`, Beleg in
`Befunde/PAIGE.md`), nach sieben widerlegten Vermutungen.

Für Gregor sah dieselbe Fassung so aus: Strg-N zeigt kein Fenster, sondern eine
**modale** Meldung „An unhandled exception has occurred", und weil sie modal
ist, lässt sich Eudora danach **nicht mehr beenden**. Gegenüber 1.0.16 war das in
einem Punkt sogar schlechter: vorher stürzte es ab und war weg, jetzt bleibt es
stehen. Das habe ich in der Überschrift „der Durchbruch" genannt.

Denselben Maßstab habe ich am selben Nachmittag ein zweites Mal verfehlt, mit
dem Satz „Alle vier Kriterien aus `ZIEL.md` sind erfüllt (06.09.2026)" im
`CHANGELOG.md` — siehe
[doku-parallel-nicht-hinterher](doku-parallel-nicht-hinterher.md).

## Die Regel

1. **Die Überschrift eines Pakets ist ein Satz über Gregor**, nicht über den
   Quelltext: *„Strg-N öffnet das Verfassen-Fenster."* Lässt sich dieser Satz
   nicht schreiben, ist die Überschrift der **Befund** — *„Ursache des
   Strg-N-Absturzes belegt: `pg_time_t`"* — und nicht „Durchbruch".
2. **Die Wörter „Durchbruch", „gelöst", „erreicht", „funktioniert" gehören
   Gregor.** Vor seinem Testbericht heißt es „belegt", „Ursache gefunden",
   „behoben, ungetestet". Sein Testbericht ist das einzige belastbare
   Messergebnis des Projekts (siehe
   [version-eindeutig-machen](version-eindeutig-machen.md)).
3. **Einen Absturz zu entfernen ist keine Verbesserung, solange die Funktion
   nicht tut.** „Kein Crash" ist eine Zwischenmessung für mich, kein Ergebnis
   für ihn.
4. **Zu jedem Paket drei Zeilen im Vergleich zum vorigen**, in seinen Worten:
   was ging vorher, was geht jetzt, **was ist schlechter geworden**. Die dritte
   Zeile wird am ehesten weggelassen und ist die wichtigste — „nicht mehr
   beendbar" hätte in 1.0.18 dort stehen müssen, und zwar von mir, nicht von
   ihm.
5. **Eine Regression wird benannt, auch wenn sie ein Nebeneffekt eines
   Fortschritts ist.** Sonst prüft Gregor sie für mich — und das kostet ihn
   einen Testlauf.

Siehe [was-lauffaehig-heisst](was-lauffaehig-heisst.md),
[lauffaehiges-ergebnis-liefern](lauffaehiges-ergebnis-liefern.md) und
[version-eindeutig-machen](version-eindeutig-machen.md).
