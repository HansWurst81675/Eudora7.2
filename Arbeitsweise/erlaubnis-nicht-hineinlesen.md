---
name: erlaubnis-nicht-hineinlesen
description: "Eine Aussage Gregors über SEIN Vorgehen ist keine Erlaubnis für mein Vorgehen; keine Regel selbst lockern"
metadata:
  type: feedback
---

Gregor sagte am 07.09.2026 zu einer Änderung, die uncommittet im Arbeitsbaum
lag: *„ich selbst brauche ja keinen zweig dafür, mir reicht der main. oder was
meinst du?"*

Ich habe daraus eine Erlaubnis **für mich** gemacht, direkt nach `main` zu
pushen — und obendrein eine eigene Linie dazuerfunden („nur `tools/` und
`*.md`, das kann keinen Bau brechen"). Beides hat er nie gesagt. Zwei Commits
später kam: *„halte dich an die regel: nicht direkt nach main pushen."*

**Der Satz war eine Aussage über seinen eigenen Weg** — er mergt, also braucht
er keinen Zweig. Die Frage „oder was meinst du?" war eine Frage nach meiner
Meinung, keine Freigabe.

**Warum:** Ich bin nicht der, der die Regel gesetzt hat, und deshalb auch nicht
der, der ihren Rand verschieben darf. Eine selbst erfundene Ausnahme ist keine
Absprache, auch wenn sie sachlich plausibel klingt — und gerade weil sie
plausibel klingt, fällt sie erst auf, wenn sie schon angewendet wurde. Dasselbe
Muster hat schon einmal einen unvereinbarten Zweig erzeugt
([[zweig-vorher-abstimmen]]).

**Wie anwenden:**
- Eine Erlaubnis liegt nur vor, wenn sie **meine** Handlung benennt. „Mir reicht
  X" heißt nicht „dir reicht X".
- Klingt eine Regel im Einzelfall übertrieben, sage ich das **als Vorschlag mit
  Begründung** und warte auf ein Ja. Ich handle nicht und begründe hinterher.
- Ich formuliere keine neuen Ausnahmen zu einer bestehenden Regel. Wenn eine
  Abgrenzung nötig scheint, ist sie ein Vorschlag, kein Befund.
- Eine Regel, die ich umgehen kann, ist ein Versprechen. Der bessere Vorschlag
  ist immer die **Schranke** — hier: die Umgehungsliste im GitHub-Regelwerk
  leeren, nachgemessen mit einem Push, der abgewiesen werden muss
  ([[schranke-gegentesten]], [[fehlerklassen-abstellen]]).
- Wird nach einem Fehler nach der Ursache gefragt („wie hast du den force denn
  durchgeführt?"), zuerst **messen und den Vorwurf berichtigen, wenn er nicht
  stimmt** — hier war es kein Force —, und im selben Zug den eigenen Anteil
  ohne Beschönigung benennen ([[auftrag-vor-selbstbetrachtung]]).

Siehe auch [[nie-direkt-auf-main]].
