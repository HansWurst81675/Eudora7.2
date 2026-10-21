# Issue #102 — der Beitrag, mit dem das Issue geschlossen wird

**ABGESCHICKT am 21.10.2026** auf Gregors Freigabe *„beide abschicken und das issue schliessen“*: [Kommentar in #102](https://github.com/HansWurst81675/Eudora7.2/issues/102#issuecomment-6324764209). Der Wortlaut ging unverändert hinaus. **Issue #102 ist danach geschlossen worden** (Grund: completed), mit dem Hinweis, dass die verbliebenen Punkte in [MELDUNGEN-VON-AUSSEN.md](../MELDUNGEN-VON-AUSSEN.md) weitergeführt werden und er jederzeit wieder öffnen kann, falls seine Hermes weiterhin nicht startet.

Gehört zu [E-131](../BEFUNDE.md#e-131), [E-132](../BEFUNDE.md#e-132) und dem
neuen Register [MELDUNGEN-VON-AUSSEN.md](../MELDUNGEN-VON-AUSSEN.md).
Adressat `@rjsdotorg`.

**Was dieser Beitrag tut:** er meldet `v1.0.120`, beantwortet seine fünf
Vorschläge zur Leisten-Serialisierung einzeln, nennt ihm einen Punkt, den er
übersehen hat, zieht die Grenze bei der INI-Verträglichkeit und schlägt vor,
das Issue zu schließen.

**Was er ausdrücklich nicht tut:** behaupten, wir hätten die Absturzursache
bewiesen. Sie ist weiterhin unbelegt — belegt ist nur, was wir geschrieben
haben und dass wir es nicht mehr tun.

**Zwei Dinge darin sind heute gemessen worden**, nicht übernommen: dass beide
Ladewege nur bis `Bars` lesen (`CDockState::LoadState` in MFC 14.38), und dass
`Bar11` und `Bar12` in seiner angehängten INI zeichengleich sind bis auf zwei
Pixel. Die Zuordnung „stammt von uns" bleibt ein **Indiz**, keine Messung —
`Bar13` und `Bar15` haben keinen solchen Zwilling.

---

> Thank you — that is a thorough piece of work, and the disassembly of
> ordinal 3952 in particular saved us time.
>
> **First, the release.** `v1.0.120` is out. It carries three fixes:
>
> * **7.2.0.118** — when the folder-adoption prompt itself *failed*, the
>   foreign folder was adopted anyway. That was precisely the situation the
>   prompt had been built for. It now takes the safe answer on failure.
> * **7.2.0.119** — a new address-book entry kept its nickname.
> * **7.2.0.120** — the auto-complete box no longer shrinks on every cursor
>   step.
>
> Together with 7.2.0.117 this closes the path that damaged your
> installation: Eudora asks before adopting another installation's mail
> folder, and the default is a fresh folder, so pressing Enter cannot do
> harm.
>
> **Your five suggestions, one by one.** We checked each against our code
> rather than against the original, because our toolbar state is written by
> MFC 14, not by Stingray:
>
> 1. *Keep `Bars` consistent with the sections written* — already guaranteed.
>    `CDockState::SaveState` writes `Bars=nIndex`, where `nIndex` counts
>    exactly the sections it just wrote. It cannot drift.
> 2. *Remove obsolete `[ToolBar-BarN]` when saving a smaller layout* — a real
>    gap, but an inert one. `CDockState::LoadState` reads `Bars` first and
>    loads only `Bar0`…`Bar(Bars-1)`. Orphans beyond that are never looked
>    at — which is exactly what your own experiment showed when deleting them
>    changed nothing.
> 3. – 5. *Validate references, preserve customizations, handle unknown IDs*
>    — these concern MFC's own loader and Eudora's `QCToolBarManager`, not
>    our replacement layer.
>
> **One thing in your INI deserves more attention than the orphans.** You
> flagged `MRUFloatYPos=-682908189` as merely "suspicious" and then spent the
> investigation on `Bar12`–`Bar15`. But that value sits in
> **`[ToolBar-Bar10]`**, which is *inside* `Bars=12` — so unlike the orphans
> it is loaded on every start. `Bar10` is the search bar (`IDC_SEARCH_BAR`,
> ID 1068). If anything in that file is worth looking at, it is that record,
> not the four that both loaders ignore.
>
> A second observation from the same file: `Bar11` and `Bar12` are
> character-for-character identical except for `XPos`/`YPos`, which differ by
> exactly two pixels. That looks like the same bar serialized twice by two
> programs whose frame metrics differ — which would make `Bar12` ours rather
> than historical accumulation in your installation. We cannot prove it:
> `Bar13` and `Bar15` have no such twin.
>
> **Where we draw the line.** Keeping `Eudora.ini` compatible with other or
> earlier versions is **not a goal** of this project. Our build and an
> existing Eudora or Hermes write the same set of toolbars, with different
> MFC versions, into the same file. The supported arrangement is **separate
> directories** — that is how the package ships, and `Eudora starten.cmd`
> keeps to it. Sharing one INI or one mail folder is at your own risk, and
> the README now says so at the top.
>
> What we *do* take responsibility for is that careful use breaks nothing.
> That is what failed in your case — you unpacked into your own folder and
> started the program, and it reached into your installation anyway. That
> part is fixed.
>
> **Closing this issue.** Your report is now recorded in
> [MELDUNGEN-VON-AUSSEN.md](https://github.com/HansWurst81675/Eudora7.2/blob/main/MELDUNGEN-VON-AUSSEN.md),
> split into four separate items with their own priority and status, each
> linking to the finding that carries the measurement. Two are fixed and
> released, one we will not fix (the orphans, for the reason above), and one
> is still unmeasured (`Bar10`). Nothing is lost by closing the issue — the
> open item stays visible there.
>
> **One question still open from our last message:** does your Hermes 7.1.0.9
> start again after running `v1.0.120` alongside it? That is the one thing we
> cannot test here — we have no Hermes. If it does, the matter is settled; if
> it does not, please reopen.
>
> On the earlier `MRUFloatXPos=-2147483648`: we stopped writing it in
> 7.2.0.113, but we never established that it caused your crash.
> `-2147483648` is `CW_USEDEFAULT`, which MFC sets itself and catches again
> on read. What is proven is that we wrote it; the causal link is not.
