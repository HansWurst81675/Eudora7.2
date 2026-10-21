# Reports from outside

> **Diese Datei ist bewusst auf Englisch** — als einzige im Projekt. Sie ist
> das Dokument, auf das wir Melder von außen per Link stoßen; eine deutsche
> Tabelle wäre für sie eine Geste ohne Inhalt. Die Tiefe bleibt deutsch:
> [BEFUNDE.md](BEFUNDE.md) trägt die Messungen, hierher gehört nur das
> Verzeichnis. Bitte nicht „zurückkorrigieren".

**As of 21 October 2026.** Every report that reaches us from outside the
project is listed here, with its date, who reported it, how urgent we consider
it, and what became of it.

**Why this file exists.** Reports from users are valuable and should not
disappear into an issue thread. At the same time we cannot fix everything at
once. This file is the visible middle ground: a report is recorded, assessed
and traceable — and the issue can be closed without the matter being lost.
Anyone wondering what happened to their report looks here.

**What is *not* here:** the measurements and the reasoning. Those live in
[BEFUNDE.md](BEFUNDE.md), which the rows link to wherever a measurement
exists. This file is the table of contents, not the case file. `BEFUNDE.md`
is in German, as is the rest of the project documentation — this register is
the single exception.

## Priority

| Level | Meaning |
|---|---|
| **high** | Mail can be lost, or an existing foreign installation is made unusable |
| **medium** | Visible malfunction, but nothing is lost |
| **low** | Cosmetic, pre-existing in the original, or outside our stated goals |

## Open

| Report | Date | Reporter | Priority | What it is about | Status |
|---|---|---|---|---|---|
| [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102)-3 | 2026-10-21 | `rjsdotorg` | low | **Orphaned `[ToolBar-BarN]` sections.** His `Eudora.ini` declares `Bars=12` but contains `Bar0`–`Bar15`. Suggestion: delete the surplus sections when saving | **Will not be fixed.** Measured at source on 2026-10-21: neither load path ever looks at the orphans. `CDockState::LoadState` reads `Bars` first and then loads only `Bar0`…`Bar(Bars-1)` (MFC 14.38, `dockstat.cpp:327-351`); Eudora's second loader, `QCToolBarManager::LoadState`, does not read `[ToolBar-BarN]` at all — it reads `[ToolBar-ToolBarManager]` plus one `[ToolBar-BarID<control id>]` section per toolbar that actually exists. The reporter confirmed the effect himself — he deleted the orphans and nothing changed. `CDockState::SaveState` writes `Bars=nIndex`, where `nIndex` counts exactly the sections it just wrote, so the count cannot drift. Backward compatibility of `Eudora.ini` is **not a goal** of this project |

## Resolved

| Report | Date | Reporter | Priority | What it is about | Status |
|---|---|---|---|---|---|
| [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102)-4 | 2026-10-21 | `rjsdotorg` | medium | **`MRUFloatYPos=-682908189` in `[ToolBar-Bar10]`.** Unlike the orphans this section lies *inside* `Bars=12` and is therefore loaded on every start. `Bar10` is the search bar (`IDC_SEARCH_BAR`) | **Measured on 2026-10-21: the rule already catches it.** `E131PositionIstBrauchbar` rejects the value and replaces the position — the upper bound on a 1294-pixel screen is y = −1194. Two test cases were added (`Eudora71/Tests/TestE131.cpp`), and the counter-test proves they bite: with the upper y bound removed, all five pre-existing cases stay green and only the two new ones turn red. That direction had never been tested. 245 tests, 245 passed. **Caveat unchanged:** this only applies when *our* Eudora saves; a foreign `Eudora.ini` that already carries the value is not repaired until then — the known open read path of [E-131](BEFUNDE.md#e-131) |
| [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102)-1 | 2026-10-18 | `rjsdotorg` | high | **After running our build, his Hermes 7.1.0.9 would no longer start** (`EXCEPTION_ACCESS_VIOLATION` in `MFC71.DLL`). Our build had silently adopted his mail folder via the registry and modified its `Eudora.ini` | **Fixed** in 7.2.0.117 and 7.2.0.118, released in [`v1.0.120`](https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.120). Eudora now asks before adopting a foreign mail folder, defaulting to a fresh one; a *failed* prompt no longer adopts it either. See [E-132](BEFUNDE.md#e-132). **Still open:** whether his Hermes starts again afterwards — he has not reported back |
| [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102)-2 | 2026-10-18 | `rjsdotorg` | high | **`MRUFloatXPos=-2147483648` written into the shared `Eudora.ini`** — his hypothesis for the crash | **Fixed** in 7.2.0.113. We no longer write the value; measured red and green on the test bench. **That it caused the crash is not established** — `-2147483648` is `CW_USEDEFAULT`, which MFC sets itself and catches again on read ([PRÜFER-40 K1](Befunde/PRUEFER-40.md#k1)). What is proven is only that we wrote it. See [E-131](BEFUNDE.md#e-131) |

## What we do not take on

So that reports do not fail against an expectation we never had:

* **`Eudora.ini` does not stay backward compatible.** Our build and an
  existing Eudora or Hermes write the same set of toolbars, with different
  MFC versions, into the same file. Anyone wanting to use both should use
  **separate directories** — that is how the package ships, and
  `Eudora starten.cmd` keeps to it.
* **Running in parallel with a shared `Eudora.ini` or a shared mail folder is
  at your own risk.**
* What we *do* take responsibility for: that **careful use destroys nothing.**
  That is exactly what failed in
  [#102](https://github.com/HansWurst81675/Eudora7.2/issues/102)-1 — the
  reporter had done nothing wrong — and exactly why it was fixed.

## How a report gets here

1. Read the issue and **separate** the individual points — one issue often
   contains several reports of very different urgency.
2. Before adding anything to `BEFUNDE.md`, search first:
   `perl tools/befund-suchen.pl <file or function>`. Search by the **place in
   the source**, not by the description.
3. Add the row here, linking to the finding that carries the measurement.
4. Reply in the issue, link to this file, close the issue.
