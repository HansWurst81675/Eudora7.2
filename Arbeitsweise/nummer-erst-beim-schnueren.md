---
name: nummer-erst-beim-schnueren
description: Ein Paketeintrag heisst "gebaut", bevor es ein Paket gibt - 1.0.107, .108 und .109 mussten alle drei nachtraeglich in "nie geschnuert" umgeschrieben werden
metadata:
  type: feedback
---

Schranke: keine - noch zu bauen: tools/pruefe-fassungsnummer.pl um eine fuenfte Frage erweitern (steht zu dieser Nummer ein ZIP in Releases/? wenn nein, muss der Eintrag "nur uebersetzt" heissen)

Der Eintrag in `Releases/PAKETE.md` entsteht in dem Zustand, der **jetzt**
wahr ist: *„nur übersetzt am …"*. Hochgestuft auf *„geschnürt am …"* wird er
von dem Werkzeug, das die Zustandsänderung herbeiführt — nicht von Hand,
nicht im Voraus.

**Why:** Drei Nummern hintereinander am 17. und 19.10.2026 bekamen einen Bau,
einen CHANGELOG-Abschnitt und einen PAKETE-Eintrag *„gebaut am"* — und nie ein
ZIP. Jedes Mal musste der Eintrag zurückgenommen werden, damit nicht zwei
verschiedene `Eudora.exe` dieselbe Kennung tragen. Was dazwischenkam, war
jedes Mal etwas Richtiges: ein Rollenlauf, ein Prüfbericht, die nächste
Behebung. Die Reihenfolge ist nicht falsch — der **Text ist zu früh wahr**.
*„Gebaut am"* liest sich als *„es gibt ein Paket"*, und das entscheidet sich
erst nach den Schranken in `paket-bauen.ps1`.

**How to apply:** `bauen.ps1` schreibt *„nur übersetzt am …"*, `paket-bauen.ps1`
macht *„geschnürt am …"* daraus. Bis das gebaut ist: beim Bau von Hand
*„nur übersetzt"* schreiben. Wer zuerst *„nur übersetzt"* schreibt, muss nie
etwas zurücknehmen. Siehe [[version-eindeutig-machen]],
[[paket-gegen-den-bau-messen]], [[erfolgsmeldung-aus-dem-ergebnis]].
