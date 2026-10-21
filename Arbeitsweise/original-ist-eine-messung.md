---
name: original-ist-eine-messung
description: "„Originalfehler\" ist eine Aussage über ein Verhalten, nicht über Quelltext - in einer Portierung ist die unveränderte Quelle gerade der Ort, an dem Verhalten lautlos umkippt"
metadata:
  type: feedback
---

Schranke: tools/pruefe-original-belegt.pl (pre-commit) - ein neues „Originalfehler"/„Originalverhalten" im Zuwachs von BEFUNDE.md muss eine Messung am Verhalten nennen (ältere eigene Fassung, Hermes/7.1, Gregor am alten Programm) oder die Einschränkung „Quelltext original, Verhalten nicht gemessen". Gegengetestet in beide Richtungen: `--selbsttest` (14 Fälle), am Bestand `--datei BEFUNDE.md` 199 Befundzeilen, 6 Original-Urteile, 4 mit Beleg, 2 ohne (E-133, E-117).

# „Original" ist eine Messung

**Regel.** Wer schreibt, ein Fehler sei *Originalverhalten* oder ein
*Originalfehler von QUALCOMM*, behauptet etwas über ein **anderes Programm**
— über Eudora 7.1, das hier niemand laufen hat. Diese Behauptung braucht eine
Messung am **Verhalten**: an Hermes, an einer älteren eigenen Fassung, oder
von Gregor. Wer sie nicht hat, schreibt stattdessen: *„Quelltext original,
Verhalten nicht gemessen."*

Der Quelltext allein belegt sie nicht. In einer Portierung ist die
**unveränderte** Quelle gerade der Ort, an dem Verhalten lautlos umkippt:
Compiler, MFC, Common Controls und Manifest sind mitgewandert, der Quelltext
nicht.

## Was passiert ist (21.10.2026, E-134)

Gregor meldete mit Bildschirmfoto: *„adressbuch übernimmt nichts."* Im
Formular steht `hans`, im Baum weiter `Untitled`
([E-134](../BEFUNDE.md#e-134)).

Der erste Entwurf stufte das als **Originalverhalten** ein. Was dafür
tatsächlich gemessen war: die `//FORNOW`-Kommentare in `nickview.cpp` stammen
aus dem initial commit. Das ist eine Aussage über den **Kommentar**. Nachgezählt
am 21.10.2026 im Zweig `wt/chronist-20261021`: `//FORNOW` steht **1315**-mal in
**44** Dateien unter `Eudora71/` — es ist ein Allerweltszeichen des Originals
und trägt kein einziges Urteil über ein Verhalten.

Gregor hat den Entwurf mit einer Frage umgeworfen:

> *„was ist denn hier neu? in der alten hermes implementierung hat es ja
> funktioniert."*

Erst danach wurde nachgesehen, und zwar an zwei Stellen:

| gemessen | Ergebnis |
|---|---|
| `git log` auf `nickview.cpp`, `nickview.h`, `nicktree.cpp`, `nicktree.h` | je **genau ein** Commit vor `14786286` — der initial commit `567a5d87`. Der Quelltextbefund war **richtig**. |
| QUALCOMMs eigener Weg: `CNicknameFile::AddNickname` → `NICKNAME_HINT_ADDED_NEW_NICKNAME` (`nickdoc.cpp:1759`) → `AddNewNickname` → `DoDeselectAll(); SelectItem(h_nickname);` | der Entwurf **wählt** den neuen Eintrag aus. Er war nie darauf angelegt, das Eingetippte zu verwerfen. |
| am laufenden Programm, drei Läufe je Fassung, Prüfgröße `NNdbase.txt` | ausgeliefert 1.0.118: 3 × `alias Untitled`; mit der Behebung: 3 × `alias hans` |

Also: **Quelltext original, Verhalten verändert** — eine Portierungsfolge,
obwohl keine Zeile dieser Dateien von uns stammt. `CTreeCtrl::SelectItem()`
setzt in diesem Bau die Karette, aber nicht `TVIS_SELECTED`; genau das liest
`IsItemSelected()`. **Warum** es das nicht mehr tut, ist bis heute **nicht
gemessen** — und steht in BEFUNDE.md auch so da.

Der Schaden der falschen Einordnung ist nicht theoretisch: *„Originalfehler"*
ist im Bestand die Begründung, mit der ein Befund liegenbleibt. Hätte Gregor
nicht gefragt, wäre E-134 als Altlast abgelegt worden statt als Fehler, den
drei Zeilen beheben.

## Was die Schranke am Bestand gefunden hat

`perl tools/pruefe-original-belegt.pl --datei BEFUNDE.md`, gemessen am
21.10.2026: **199** Befundzeilen, **6** mit einem Original-Urteil, **4**
davon mit Messung, **2** ohne.

- **[E-133](../BEFUNDE.md#e-133)** (aufgenommen am 20.10.2026, einen Tag vor
  E-134): *„**Originalverhalten, nicht von uns eingebaut** — der Registryweg
  ist **unverändert**"*. Wieder derselbe Schluss: unveränderter Quelltext,
  daraus Originalverhalten. Dieselbe Lücke, zum zweiten Mal in zwei Tagen.
- **[E-117](../BEFUNDE.md#e-117)**: *„`resolve_URL` entschlüsselt nur `%XX`
  … Originalfehler von QUALCOMM"*. Hier ist der Quelltextbeleg zwingend — der
  Entschlüssler **kennt** den Fall nicht —, es fehlt nur der Satz, der das
  sagt. Grenzfall; die Schranke verlangt zu Recht, dass er dasteht.

Die vier mit Beleg zeigen, wie es aussieht, wenn es stimmt:
*„auch an 7.2.0.88 (`C:\Temp\E118-0088`), also ein Originalfehler von
QUALCOMM, kein Rückfall durch E-118."*

## How to apply

1. Bevor *„Originalfehler"* in eine Befundzeile, eine Commit-Nachricht oder
   einen Agentenauftrag geschrieben wird: **woran ist das gemessen?** Drei
   Antworten zählen — eine ältere eigene Fassung mit demselben Bild, Hermes
   oder Eudora 7.1, oder Gregor am alten Programm.
2. Ist keine davon da, steht dort: *„Quelltext original, Verhalten nicht
   gemessen."* Das ist kein Eingeständnis, sondern die genauere Aussage.
3. *„Die Datei ist seit dem initial commit unverändert"* ist ein Befund über
   **uns**, nicht über das Programm. Er beantwortet die Frage *„haben wir das
   kaputtgemacht?"* mit nein — und die Frage *„war es in 7.1 auch so?"* gar
   nicht.
4. Beim Gegenlesen: der Entwurf des Originals ist selbst eine Quelle. Wer
   `AddNewNickname` liest und sieht, dass dort `SelectItem` steht, weiß, dass
   QUALCOMM auswählen **wollte** — also kann das Ausbleiben kein Entwurf
   sein.

## Lücke

Eine ältere **eigene** Fassung ist auch schon unsere: *„an 7.2.0.88 gleich"*
schließt einen frischen Rückfall aus, nicht die Portierung. Für die echte
Antwort bräuchte es ein laufendes Hermes 7.1 zum Gegenmessen; das steht hier
nicht. Solange es fehlt, ist *„Originalfehler"* immer höchstens
*„mindestens seit unserer Fassung N"* — und so sollte es auch formuliert
werden.

Siehe [[ursache-nur-gemessen-behaupten]], [[pruefen-statt-vermuten]],
[[anzeige-ist-kein-zustand]], [[widerlegte-vermutungen-aufschreiben]].
