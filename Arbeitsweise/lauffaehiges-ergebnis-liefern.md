---
name: lauffaehiges-ergebnis-liefern
description: "Ziel ist eine einsetzbare Eudora-Version, nicht ein Zwischenstand — pragmatisch priorisieren, mit Prüfanleitung übergeben"
metadata: 
  node_type: memory
  type: project
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-08-29T19:56:50.708Z
---

Gregor baut nicht mit, er **benutzt** Eudora. Sein Massstab ist eine Version, die
er produktiv einsetzen kann — nicht die Zahl der baubaren Projekte.

> „mir geht es nicht um teilschritte, sondern um eine fertige version. die ich
> produktiv einsetzen kann. jetzt habe ich noch gar nichts." (28.08.2026, 16:44)
>
> „ich möchte eine lauffähige version (.exe / zip) in der repo als release 1.0
> einchecken. wie weit sind wir davon noch entfernt? wann bist du damit fertig?"

**Priorisieren wie er es vorgegeben hat:** „wir gehen eher pragmatisch vor: was ist
wichtig, was kostet wenig aufwand und was bringt wenig bei viel aufwand?" Also
immer zuerst das, was in seiner laufenden Installation ankommt. Austauschbare DLLs
(QCSSL, QCUtils, QCSocket, imap) schlagen alles, was einen vollständigen
`Eudora.exe`-Bau voraussetzt — die statisch gelinkten Teile (EuImap, SearchEngine,
DirectoryServicesUI, AccountWizard) hängen an der EXE und damit am OT501-Blocker.

**Jede Übergabe braucht drei Dinge**, sonst ist sie keine:

1. **Was genau zu tun ist** — welche Datei wohin, was vorher zu sichern ist.
2. **Woran er die Verbesserung misst** — ein konkreter Handgriff mit erwartetem
   Ergebnis. Am 28.08.2026 fragte er: „wie kann ich die neue DLL testen? was muß
   ich machen? austauschen und dann? mail empfangen? irgendeine? eine spezielle?"
   Diese Fragen hätten in meiner Übergabe schon beantwortet sein müssen.
3. **Der ehrliche Vergleich gegen seinen Ist-Zustand.** Seine Rückmeldung nach dem
   ersten DLL-Tausch: „es funktioniert wie bisher, keine änderung. auch keine
   verbesserung." Ursache: seine Installation hatte bereits HermesSSL 7.8 mit
   OpenSSL 1.0.2p. Der Nutzen war real (TLS 1.3 statt 1.2), aber unsichtbar und
   ungemessen. **Vor** der Übergabe prüfen, ob das Neue gegenüber dem, was bei ihm
   läuft, überhaupt ein Fortschritt ist — und wie man das sieht.

**Ungeschönt berichten.** Die Zwischenbilanz „Gegenüber deiner patch2-Version:
bisher nichts" hat Gregor akzeptiert; beschönigte Teilerfolge hat er jedes Mal
zerlegt. Was noch fehlt, gehört genauso in den Bericht wie das Erreichte —
einschliesslich der Zeit, die durch meine eigenen Fehler verlorenging.

Siehe auch [[nie-stillstehen]] und [[doku-bei-jedem-commit-mitziehen]].
