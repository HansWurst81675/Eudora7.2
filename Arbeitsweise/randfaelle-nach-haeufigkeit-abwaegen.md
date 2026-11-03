---
name: randfaelle-nach-haeufigkeit-abwaegen
description: "Vor jeder Behebung abwägen - wie oft, wie wahrscheinlich, welcher Schaden, welcher Aufwand; hypothetische Randfälle zuletzt"
metadata:
  node_type: memory
  type: feedback
  originSessionId: f3d03714-d2ce-4d84-96d0-5244b9e265ce
  modified: 2026-11-03T09:22:55.982Z
---

Bevor ein Befund behoben wird (auch ein PRÜFER-Fund), steht eine kurze Abwägung: **Wie oft kommt es im Alltag vor? Wie wahrscheinlich trifft es Gregor? Was geht schlimmstenfalls schief? Wie aufwändig ist die Behebung?** Erst alles Wichtige und Kritische, das tatsächlich vorkommt; hypothetische Randfälle zuletzt oder nur dokumentiert.

Schranke: keine - Arbeitsweise; Ausloeser ist der SessionStart-Haken, der MEMORY.md laedt, und die Tabelle in jedem Vorschlag an Gregor.

**Why:** Gregor am 03.11.2026, nachdem bei E-170 Randfälle (Doppelzustellung in derselben Sekunde, laufender Abgleich während des Verschiebens) über mehrere Prüfrunden behoben wurden: *„bei den ganzen verschiebe aktionen und bugfixes müssen wir mal abwägen, wie oft sowas überhaupt vorkommen kann …“*; sinngemäß dazu: erst alles Wichtige und Kritische abarbeiten, danach hypothetische Fälle. (Gregors Veranschaulichung dazu bewusst nicht wiedergegeben — er wollte sie nicht im Repo.)
**How to apply:** jede Reihenfolge, die ich Gregor vorschlage, mit den vier Spalten; PRÜFER-Funde mit Schwere „gering/sehr gering“ und seltenem Auslöser nicht sofort beheben, sondern im Befund unter „Grenze“ vermerken; PRÜFER- und LEKTOR-Aufträge bitten, die Häufigkeit je Fund zu nennen ([[entscheidung-reihenfolge-nach-7-2-2-132]]).

**Nachtrag 03.11.2026 (PRÜFER-90 T3):** Ordnernamen gehören nicht in die `eudora.log`-Zeilen — Gregor auf die Frage, ob `ziel="<Ordner>"` in den E-170-Zeilen stehen bleiben soll: *„Weglassen (Recommended)“*. Gilt sinngemäß für neue Spurzeilen: keine Namen aus seinem Mailverzeichnis ins Protokoll, wenn eine Nummer oder Anzahl genügt.

**Nachtrag 03.11.2026 (PRÜFER-92 K5):** die älteren Logzeilen zu E-125 und E-142 (`quelle=<Postfach>`) bleiben, wie sie sind — Gregor: *„ordner namen trash und entwürfe sind ja unkritisch.“* Nicht wieder fragen; nur NEUE Spurzeilen ohne Namen, wo Nummer/Anzahl genügt.
