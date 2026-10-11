---
name: zwei-werte-in-eine-ausgabe
description: "Zwei Werte, deren Widerspruch geklaert werden soll, gehoeren in denselben Aufruf - zwei Protokollzeilen lassen die Erklaerung 'zu verschiedenen Zeitpunkten' immer offen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-08T07:54:39.291Z
---

Schranke: keine - ob zwei widersprüchliche Werte in derselben Ausgabe stehen, entscheidet der Entwurf der Messung; im Repo bleibt nur das Ergebnis, nicht seine Form

# Wer zwei Werte vergleichen will, schreibt sie in eine Ausgabe

Der Widerspruch aus E-34 stand vom 06.09. bis zum 08.09.2026 offen:
`QCCustomToolBar::SaveCustomInfo` meldete `GetBtnCount=24`, und der Zugriff auf
`m_btns[0]` warf trotzdem *„Encountered an improper argument"* — obwohl
`GetBtnCount()` laut Kopfdatei nichts anderes tut als `m_btns.GetSize()`
zurückzugeben.

Zwei Tage lang habe ich das aus **zwei getrennten Protokollzeilen** gelesen und
Erklärungen gebaut, die auf dem Abstand zwischen ihnen beruhen: die Leiste
werde zwischendurch abgeräumt, ein Nebenläufer greife ein, die Klasse sei
zweimal mit verschiedenem Aufbau übersetzt (ODR-Verstoß über `tbarcust.h` gegen
`OTShim_Werkzeugleiste.h`). Die ODR-Vermutung hat PRUEFER bereits verworfen;
belegt widerlegt hat sie erst `stdafx.h:52`, das `OTShimAll.h` einbindet und
damit `__TBARCUST_H__` setzt — `tbarcust.h` ist in jeder Eudora-Übersetzungs-
einheit wirkungslos.

Entschieden hat es dann **eine** Spurmarke, am 08.09.2026 um 06:47:

    E-33 SaveCustomInfo: this=06283F80 GetBtnCount=24 m_btns.GetSize=0 m_btns@06284168

Beide Werte aus **demselben** `Format`-Aufruf, dieselbe Mikrosekunde, dasselbe
`this`. Damit war jede Erklärung erledigt, die zwei Zeitpunkte braucht.

**Warum:** Zwei Protokollzeilen sind zwei Messungen. Zwischen ihnen liegt Zeit,
und Zeit ist die bequemste Erklärung für jeden Widerspruch — sie lässt sich
nicht widerlegen und kostet nichts zu behaupten. Solange die Werte getrennt
ausgegeben werden, bleibt der Vermutungsraum offen; in einer Zeile ist er leer.
Das ist derselbe Gedanke wie in [[gegenprobe-umdrehen]]: nicht den erwarteten
Zustand bestätigen, sondern die Alternativen ausschließen.

**Wie anwenden:**

- **Ein Widerspruch zwischen zwei Werten wird mit einer Ausgabe geklärt, die
  beide enthält** — ein `Format`, ein `printf`, eine Zeile. Zusätzlich das
  `this` und die Adresse des Feldes, damit auch „ein anderes Objekt" ausfällt.
- **Bevor ich eine Erklärung baue, die auf einem Zeitabstand beruht, prüfe ich,
  ob der Abstand überhaupt existiert.** Zwei Zeilen aus derselben Funktion sind
  kein Beleg für einen Zwischenzustand.
- **Diese Messung kostet einen Bau.** Sie ist trotzdem billiger als jede weitere
  Vermutungsrunde — hier zwei Tage gegen einen Bau.
- **Zwei Werte, die laut Quelltext gleich sein müssen, aber nicht sind,** sind
  ein Befund über die **Übersetzung**, nicht über die Logik: gleicher Name,
  verschiedener Aufbau, versetzte Felder. Die Feldadresse in derselben Zeile
  zeigt das sofort.

Siehe [[pruefen-statt-vermuten]], [[widerlegte-vermutungen-aufschreiben]],
[[messung-muss-den-weg-treffen]] und [[gegenprobe-umdrehen]].
