# Issue #102 — separate Nachfrage zum Unicode-Plug-in

**ENTWURF, noch nicht abgeschickt.** Warten auf Gregors Freigabe.

**Als eigener Beitrag abzuschicken**, nicht zusammen mit dem Abschlussbeitrag
([ISSUE-102-ABSCHLUSS.md](ISSUE-102-ABSCHLUSS.md)). Gregors Vorgabe vom
21.10.2026: *„frag nochmal vorsichtig nach seinem plug-in, ob wir es
uebernehmen koennen. allerdings im separaten posting, damit es sich nicht
vermischt."*

## Warum „nochmal"

Wir haben am 20.10.2026 schon gefragt (Kommentar 7 im Issue): ob wir das
Plug-in mitliefern dürfen, zu welchen Bedingungen, und ob wir die Liste der
Bytefolgen lesen können, die es als kaputt behandelt. Darauf ist er nicht
eingegangen — stattdessen kam die Leisten-Untersuchung. Vermutlich ist die
Frage im technischen Detail untergegangen; ein Vorwurf ist es nicht und darf
im Text auch nicht so klingen.

## Was wir heute nachgemessen haben

* Sein Repo [`rjsdotorg/EudoraUnicodeFix-releases`](https://github.com/rjsdotorg/EudoraUnicodeFix-releases)
  enthält **nur eine `README.md`** — keinen Quelltext, keine Release-Dateien
  über die GitHub-API, und **keine Lizenzdatei**. Ohne Lizenz dürfen wir die
  DLL nicht mitliefern, auch wenn er mündlich zustimmt. Das ist der Punkt, an
  dem die Frage hängt.
* Seine eigene Beschreibung nennt als Beispiel `â€™` und `Ã©`. Das ist genau
  die Mojibake-Klasse, um die es bei unseren Zeichensatzbefunden geht.
* Letzte Änderung am Repo: 04.08.2026.

## Drei Wege, damit er leicht nein sagen kann

Der Text bietet absteigende Stufen an, damit ein Nein nicht das Ende der Sache
ist: mitliefern — oder nur verlinken — oder nur die Liste der Bytefolgen.

---

> Separate from the toolbar discussion, one question that got lost in the
> technical detail last time — no hurry, and no obligation either way.
>
> You mentioned your [EudoraUnicodeFix](https://github.com/rjsdotorg/EudoraUnicodeFix-releases)
> plug-in. We are interested, because the examples in your description —
> `â€™`, `Ã©` — are exactly the class of damage we are chasing on the
> receiving side. Where your plug-in repairs it on display, we are trying to
> stop it from being stored that way in the first place.
>
> There are three levels here, and any of them would help us. Please pick
> whichever suits you, including none:
>
> 1. **May we ship the DLL with our packages?** It is an EMSAPI plug-in like
>    the ones we already include, so it would need no code changes on our
>    side. For this we would need a licence: the repository currently has
>    none, and without one we cannot redistribute it even with your
>    permission in writing. Any permissive licence would do — MIT, BSD,
>    Apache-2.0 — or simply a line in the README stating what you allow.
> 2. **Or may we just link to it** from our README, as a recommended
>    companion? That needs nothing from you but a yes.
> 3. **Or, independently of either:** would you share **which byte sequences
>    you treat as broken**? Not the code — just the list. For us that is a
>    ready-made set of test cases, and it is the part we would otherwise have
>    to rediscover one message at a time.
>
> Whatever you choose, we would credit you and link the repository.
>
> One thing we noticed while reading your description, in case it is useful
> to you: *"Unicode byte sequences interrupted by HTML entities"* is a case
> we had not considered at all. If your plug-in handles that, it is solving a
> harder problem than we assumed.
