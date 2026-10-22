# Issue #102 — Antwort auf die Plug-in-Freigabe

**ABGESCHICKT am 22.10.2026** auf Gregors Freigabe *"ja, entwuerfe sehen gut aus"*: [Kommentar in #102](https://github.com/HansWurst81675/Eudora7.2/issues/102#issuecomment-6333237823). Der Wortlaut ging unveraendert hinaus.

**Nachtrag, ebenfalls abgeschickt** (*"ja, schick den nachtrag"*): [Kommentar](https://github.com/HansWurst81675/Eudora7.2/issues/102#issuecomment-6333264895). Nachgemessen: `EudoraUnicodeFix-releases` enthaelt nur eine README - **0 Releases, 0 Tags, keine DLL**. Wir haben also auch kein Binaerpaket. Der Nachtrag schlaegt deshalb den kuerzeren Weg vor: die gebaute DLL an ein Release dort anhaengen, dann braucht es den Quellzugang fuer den Test gar nicht.

Gehört zu [Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102),
Adressat `@rjsdotorg`. Das Issue ist geschlossen; ein Beitrag ist trotzdem
möglich und sichtbar.

**Vorgeschichte.** Auf unsere Nachfrage vom 21.10.2026 hat er am selben Abend
geantwortet und **alle drei Stufen bewilligt**: *„Feel free to use the
methods/code … Ship the DLL or a link as you like."* Dazu hat er Punkt 3
ausführlich beantwortet — die Indikatoren seines Rückwärtstests.

**Zwei Dinge, die heute nachgemessen sind:**

* Das von ihm verlinkte Quell-Repo `rjsdotorg/EudoraUnicodeFix` (ohne
  `-releases`) liefert **404** — geprüft über die GitHub-API. Öffentlich ist
  nur `EudoraUnicodeFix-releases`, und das enthält allein eine `README.md`.
* Auch dieses Repo hat **keine Lizenzdatei** (`license: null`). Ohne eine
  dürfen wir die DLL nicht weitergeben, auch nicht mit seinem schriftlichen Ja
  im Issue. Das ist der eigentliche Grund für diesen Beitrag.

Gregors Vorgabe vom 22.10.2026: *„a) nach dem zugriff fragen, daß er mich
freischaltet und b) die fertige DLL oder plug-in nutzen bei uns, dann kann ich
es übernehmen und testen."*

---

> Thank you — that is generous, and the scoring details in particular are
> exactly what we were missing.
> 
> **One snag:** the source repository you linked,
> `github.com/rjsdotorg/EudoraUnicodeFix` (without `-releases`), returns **404**
> for us. Only `EudoraUnicodeFix-releases` is reachable, and that one contains
> just the README. Is it still private? If you could open it up — or add
> @HansWurst81675 as a reader — we would like to take you up on the offer.
> 
> **What we would like to do, concretely:**
> 
> 1. **Ship the DLL** with our packages, so people get the repair without
>    hunting for it. Our maintainer wants to install and test it alongside a
>    real mailbox first.
> 2. **Link your repository** from our README either way, with credit.
> 3. Once we can read `repair.cpp`, work towards doing it at the source — your
>    *"if it can be baked in so much the better"* is exactly our intention. The
>    plug-in repairs on display; we want the message not to be stored damaged in
>    the first place.
> 
> For (1) we still need one small thing: **a licence in the repository.** There
> is none at the moment, and without one we cannot redistribute the DLL even
> with your permission here in writing — package maintainers and users need
> something they can point at. Any permissive licence does: MIT, BSD-3-Clause,
> Apache-2.0. A single `LICENSE` file is enough.
> 
> (We are fixing the same gap on our side, by the way — you prompted it. Our
> repository had no licence either. It will carry the same BSD-3-Clause as the
> 2016 Computer History Museum release, so the whole tree stays under one
> licence.)
> 
> **On your scoring logic** — thank you for spelling it out. Two things we had
> not appreciated:
> 
> * That there is **no fixed list**, and that eligibility is simply *"invalid
>   UTF-8"*. That is a better criterion than the table we were about to build.
> * That `F0` counts only when `ð` appears as a *decoded* mojibake character,
>   not whenever a valid four-byte sequence begins. Mathematical letters like
>   `F0 9D 90 87` (`𝐇`) going through the direct NFKC path is a distinction we
>   would have got wrong on the first attempt.
> 
> We will come back to you once we have read `IsIndicator()` and `Plausible()`.
> 
> On your last point: we recognise the experience. The documentation help is
> real; the deep debugging in a large codebase is where it still takes a careful
> human reading every measurement. This port has had its share of confidently
> wrong first attempts — several of them in this very issue.

---

## Nachtrag, Wortlaut

> One addendum, so you are not waiting on us while we wait on you.
> 
> Looking again at `EudoraUnicodeFix-releases`: it currently holds **only the
> README** — no releases, no tags, no DLL. So we do not have a binary either,
> and the install instructions point at `build\Release\EudoraUnicodeFix.dll`,
> which only exists for someone who has already built it.
> 
> That makes the easiest path probably this one: **attach the built
> `EudoraUnicodeFix.dll` to a release in that repository.** Then our maintainer
> can install and test it straight away, without the source repository being
> opened at all. Opening the source would still be welcome — for the
> "baked in" part — but it is the slower of the two.
> 
> Either way a one-line `LICENSE` file would settle the redistribution
> question. Your other projects carry them (MIT, GPL-3.0, CC0), so this one
> looks like it simply slipped through.
> 
> No rush on any of it.
