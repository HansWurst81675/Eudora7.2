# Eudora 7.2

**[Deutsch](README.md) | English**

> **Back up before the first start.** If you already use Eudora 7.1 or Hermes, back up your `Eudora.ini` and the complete mail folder **first**. This project starts with its **own** mail folder and does not touch an existing installation — `Eudora starten.cmd` respects that, and if you start `Eudora.exe` directly, it asks you first. A backup takes two minutes; a lost mail archive cannot be restored.
>
> **Use separate folders.** The `Eudora.ini` is **not** backward compatible — our build and an existing Eudora or Hermes write the same set of toolbars into the same file using different MFC versions. If you share **one** INI or **one** mail folder, expect the other installation to show errors afterwards. Running them in parallel is **at your own risk**.

**The Eudora 7.1 mail client, buildable again — with Visual Studio 2022 on Windows 10 and 11.**

From 1988 to 2006, Eudora was one of the most widely used mail clients of all. In 2018 the [Computer History Museum](https://computerhistory.org/blog/the-eudora-email-client-source-code/) released the source code with Qualcomm's permission — as an archive, not as a buildable project: it requires Visual C++ 6 and 7.1 from 1998 and 2003, plus the commercial library *Stingray Objective Toolkit*, which can no longer be bought.

**This repo turns it back into a program you can build and use.** From a fresh clone, a single command produces an `Eudora.exe` that starts on a current Windows and fetches and sends mail over TLS 1.3.

> **Note on languages:** The detailed documentation (`Doku/`, `Intern/`, `CHANGELOG.md`, …) is written in German. Links in this file point to those German documents.

---

## Update information

**Current release: [`v7.2.2.136`](https://github.com/HansWurst81675/Eudora7.2/releases/latest)** of 06 Nov 2026.
Newer test packages (7.2.2.137, 7.2.2.138) are built but **not published**.

### Version overview (newest first)

| Version | Type | Date | Contents |
|---|---|---|---|
| **7.2.2.138** | Test package, not published | — | Hourglass on the first print preview ([E-240](Intern/BEFUNDE.md#e-240)); own release ZIP buildable from a fresh clone ([E-248](Intern/BEFUNDE.md#e-248)) |
| **7.2.2.137** | Test package, not published | — | Fix for the print preview built for [E-242](Intern/BEFUNDE.md#e-242) (finding still open: path of the temporary file); printing via *Microsoft Print to PDF* passed by Gregor |
| **7.2.2.136** | **Release** | 06 Nov 2026 | No crash on exit while the notice is open ([E-239](Intern/BEFUNDE.md#e-239)); `PrintBackground` for print preview ([E-169](Intern/BEFUNDE.md#e-169)); "Remember password" works the first time ([E-223](Intern/BEFUNDE.md#e-223)); attachment icon on S/MIME-signed mail ([E-222](Intern/BEFUNDE.md#e-222)). Full test-bench run 110/110 on build `2a8fd4d7`, unit tests 428/428, tested and approved by Gregor |
| 7.2.2.135 | Test package | 05 Nov 2026 | Remainder of [E-193](Intern/BEFUNDE.md#e-193) (Edit → Find). Test report passed (425 unit tests, 19 gates, 103 test-bench cases; in the full run 3 cases were red, green when repeated individually, including the crash [E-239](Intern/BEFUNDE.md#e-239)) |
| 7.2.2.134 | Test package | 05 Nov 2026 | [E-223](Intern/BEFUNDE.md#e-223), [E-222](Intern/BEFUNDE.md#e-222); 424 unit tests, 19 gates, 102 test-bench cases |
| **7.2.2.133** | **Release** | 05 Nov 2026 (assembled 04 Nov) | [E-188](Intern/BEFUNDE.md#e-188), [E-192](Intern/BEFUNDE.md#e-192), [E-193](Intern/BEFUNDE.md#e-193), [E-199](Intern/BEFUNDE.md#e-199), [E-220](Intern/BEFUNDE.md#e-220), [E-221](Intern/BEFUNDE.md#e-221). Gregor's test found three new bugs inherited from the original ([E-222](Intern/BEFUNDE.md#e-222), [E-223](Intern/BEFUNDE.md#e-223), remainder of [E-193](Intern/BEFUNDE.md#e-193)) |
| **7.2.2.132** | **Release** | 03 Nov 2026 | First version of the 7.2.2 series: Help menu ([A-5](Intern/BEFUNDE.md#a-5)), About dialog with Latest Release ([E-216](Intern/BEFUNDE.md#e-216)), Save As with matching extension ([E-128](Intern/BEFUNDE.md#e-128)); personalities ([E-39](Intern/BEFUNDE.md#e-39), [E-203](Intern/BEFUNDE.md#e-203), [E-204](Intern/BEFUNDE.md#e-204)), saving ([E-194](Intern/BEFUNDE.md#e-194)–[E-196](Intern/BEFUNDE.md#e-196), [E-205](Intern/BEFUNDE.md#e-205), [E-207](Intern/BEFUNDE.md#e-207)), missing mail folder ([E-133](Intern/BEFUNDE.md#e-133)), IMAP label ([E-170](Intern/BEFUNDE.md#e-170)). 408 unit tests, 19 gates, 81 test-bench cases; test steps: [TESTPLAN](Intern/TESTPLAN.md#test-7-2-2-132) |
| **7.2.1.131** | **Release** | 02 Nov 2026 | Includes the unpublished test packages 7.2.1.129 and 7.2.1.130 (among others [E-72](Intern/BEFUNDE.md#e-72) filter with negated condition, [E-122](Intern/BEFUNDE.md#e-122) arrival date on IMAP). Test steps: [TESTPLAN](Intern/TESTPLAN.md#test-7-2-1-131) |
| **7.2.1.128** | **Release** | 29 Oct 2026 | First 7.2.1 release; includes test packages 7.2.0.123–7.2.0.127 (among others removed eMudhra root certificates [E-148](Intern/BEFUNDE.md#e-148), IMAP folder names with umlauts [E-77](Intern/BEFUNDE.md#e-77), images in HTML mail [E-113](Intern/BEFUNDE.md#e-113), [E-119](Intern/BEFUNDE.md#e-119)) |
| `v1.0.120` | Release | 21 Oct 2026 | Eudora no longer silently adopts a foreign mail folder but asks first ([E-132](Intern/BEFUNDE.md#e-132)); further fixes [E-131](Intern/BEFUNDE.md#e-131), [E-134](Intern/BEFUNDE.md#e-134), [E-135](Intern/BEFUNDE.md#e-135) |

What exactly changed in each version is in the [CHANGELOG](CHANGELOG.md); the test steps for a version are in the [TESTPLAN](Intern/TESTPLAN.md).

**About version numbers:** Up to 7.2.1.128, published packages had their own numbering (`v1.0.x`) that differed from the number in the source tree. Since 7.2.1.128, source tree, `VERSION`, ZIP and tag carry the same number ([PAKETE](Releases/PAKETE.md#drei-z%C3%A4hlungen-und-wie-sie-zusammenh%C3%A4ngen)).

### Important when updating

- **Back up first:** copy `Eudora.ini` and the mail folder before a new version runs for the first time.
- **Adopting a new version:** see [Doku/FAQ.md](Doku/FAQ.md) (question about adopting a new version).
- **If you use 7.2.1.128 or older:** filters with a negated condition ("doesn't appear", "doesn't contain", "is not") match every message there and, with the action *transfer*, can move your entire inbox ([E-72](Intern/BEFUNDE.md#e-72)). Fixed from 7.2.1.129, included in release 7.2.1.131.
- **If you use `v1.0.117` or older:** these versions touch an existing Eudora/Hermes mail folder without asking. Please heed the notice at the top.
- **Certificates:** versions up to package 1.0.122 trust four eMudhra root certificates, for which compromised intermediate certificates became known on 20 Oct 2026. Fixed from release 7.2.1, see [below](#compromised-emudhra-certificates-october-2026).
- **Your own `rootcerts.p7b` in the mail folder** takes precedence over the bundled one and is **not** replaced by an update.

---

## Where do I start?

| I want to … | … then go here |
|---|---|
| **just try it out** | [Download the latest package](https://github.com/HansWurst81675/Eudora7.2/releases/latest) — unblock the ZIP before extracting (see [Mark of the Web](#when-windows-blocks-the-start-mark-of-the-web)), then double-click `Eudora starten.cmd`. Nothing to install |
| **know what works and what doesn't** | [What works](#what-works) and [Known bugs](#known-bugs) right here; in detail in [Doku/ANWENDER.md](Doku/ANWENDER.md) |
| **use it** (filters, Defender, IMAP password, log) | [Doku/ANWENDER.md](Doku/ANWENDER.md) |
| **a quick answer** | [Doku/FAQ.md](Doku/FAQ.md) — frequently asked questions, numbered |
| **know which settings differ from the original Eudora — and why** | [Intern/EINSTELLUNGEN.md](Intern/EINSTELLUNGEN.md#abweichungen) |
| **build it myself** | [Doku/BAUEN.md](Doku/BAUEN.md) — Visual Studio 2022 with "Desktop development with C++", one command; up to your own release ZIP: [Building your own release ZIP](Doku/BAUEN.md#ein-eigenes-release-zip-bauen--aus-einem-frischen-klon) (since 7.2.2.138, [E-248](Intern/BEFUNDE.md#e-248)) |
| **check my own changes** | [Test bench](#checking-your-own-changes-test-bench) — `Pruefstand starten.cmd`, guide in [Doku/PRUEFSTAND.md](Doku/PRUEFSTAND.md) |
| **report a bug** | [Reporting a bug](Doku/ANWENDER.md#einen-fehler-melden) |
| **contribute** | [Doku/MITARBEITEN.md](Doku/MITARBEITEN.md) |
| **know how it was ported** | [Doku/HINTERGRUND.md](Doku/HINTERGRUND.md) and [Intern/PORTIERUNG.md](Intern/PORTIERUNG.md) |

### If someone — or an AI — is to continue the work here

The order matters, and it is short:

1. [**CLAUDE.md**](CLAUDE.md) — what to do *before* the first step.
2. **`perl tools/offene-befunde.pl`** — what is open. The generated table in [Intern/WEITERMACHEN.md](Intern/WEITERMACHEN.md) states for each item **what is still missing**, not just how it is classified.
3. [**ZIEL.md**](ZIEL.md) — what "done" is measured by: nine criteria, plus the generated list of what is still missing for the next version. **ZIEL.md is the source**; if another file contradicts it, `tools/doku-pruefen.pl` rejects the commit.

### Which file is for what

The root directory holds what is meant **for readers**. Our working material lives under [`Intern/`](Intern) — to **look things up**, not to read.

| For readers | |
|---|---|
| [README.md](README.md) / [README.en.md](README.en.md) | this file: entry point, update information, signpost |
| [Doku/](Doku) | usage, building, contributing, technical background |
| [ZIEL.md](ZIEL.md) | what "done" is measured by, and what is still missing (generated) |
| [CHANGELOG.md](CHANGELOG.md) | what changed in each version, and the generated list of open findings |
| [Releases/PRUEFBERICHT.md](Releases/PRUEFBERICHT.md) | **every test** with result, time and build. After your own change, `perl tools/pruefbericht.pl --vergleich` compares against this state and names what is newly red |
| [MELDUNGEN-VON-AUSSEN.md](MELDUNGEN-VON-AUSSEN.md) | externally reported bugs, with status (in English) |
| [LICENSE](LICENSE) | who may use it and how |
| [CLAUDE.md](CLAUDE.md) | what an agent does **before** the first step |

| `Intern/` — look up, don't read | |
|---|---|
| [BEFUNDE.md](Intern/BEFUNDE.md) | every finding with measurement, verdict and **what is still missing**; jump to it by ID (`#e-nnn`). Legend of abbreviations at the top |
| [WEITERMACHEN.md](Intern/WEITERMACHEN.md) | what is to be done (generated list) |
| [AUFGABEN.md](Intern/AUFGABEN.md), [TESTPLAN.md](Intern/TESTPLAN.md) | work packages and test points |
| [PORTIERUNG.md](Intern/PORTIERUNG.md) | porting diary |
| [LEKTORAT.md](Intern/LEKTORAT.md), [PRUEFBERICHT.md](Intern/PRUEFBERICHT.md) | reports of the roles LEKTOR and PRÜFER (archive up to 30 Aug 2026 — not to be confused with the test report `Releases/PRUEFBERICHT.md`) |
| [PRUEFUNG-BAU.md](Intern/PRUEFUNG-BAU.md), [PRUEFUNG-CODE.md](Intern/PRUEFUNG-CODE.md), [PRUEFUNG-BRANCH.md](Intern/PRUEFUNG-BRANCH.md) | review guides |
| [FILTER.md](Intern/FILTER.md), [EINSTELLUNGEN.md](Intern/EINSTELLUNGEN.md), [STARTUMGEBUNG.md](Intern/STARTUMGEBUNG.md), [ABRUF-PRUEFEN.md](Intern/ABRUF-PRUEFEN.md) | individual topics in detail |
| [AGENTEN.md](Intern/AGENTEN.md) | how agents are used here |
| [BEFUNDE-ALTBESTAND.md](Intern/BEFUNDE-ALTBESTAND.md) | closed findings from the early days |

Also [`Befunde/`](Befunde) (LEKTOR and PRÜFER reports), [`Arbeitsweise/`](Arbeitsweise) (lessons learned from mistakes) and [`tools/`](tools) (tools and gates). *Count as of 02 Nov 2026 via `git ls-files`: 219 reports, 124 lessons, over 100 tools — the numbers change continuously.*

---

## What works

- **Fetch and send mail** over POP3, IMAP and SMTP with **TLS 1.3** — also on today's servers (tested with GMX and freenet). The 2006 original only supports SSL 3.0 / TLS 1.0 and can no longer reach any current mail server.
- **Reading** text and HTML messages, with images at the right size.
- **Writing, replying, forwarding**, attachments with full name and extension, multiple personalities, filters, mailbox management.
- **Moving to an IMAP folder** — including HTML messages with embedded images and sent mail; the message only disappears from the local mailbox once it is on the server.
- **No installation:** extract the ZIP, double-click `Eudora starten.cmd`. The package installs nothing and puts nothing into `C:\Program Files`.
- **Keep building on it:** the source tree compiles completely with MSVC v143 and MFC 14, without the Stingray library — a replacement implementation in [`Eudora71/OTShim`](Eudora71/OTShim) stands in for it (see [The replacement layer for Stingray OT501](Doku/HINTERGRUND.md#die-ersatzschicht-f%C3%BCr-stingray-ot501)).

**Do not start `Eudora.exe` directly.** Without a mail folder given, Eudora looks for one itself and, via the registry, finds the one of an **existing** Eudora or Hermes installation, even in a completely different folder, and then writes into its `Eudora.ini` ([E-132](Intern/BEFUNDE.md#e-132)). `Eudora starten.cmd` passes the folder as an argument and prevents this; if you create a shortcut, give the path: `Eudora.exe "C:\…\Mailverzeichnis"`. From 7.2.0.114 Eudora asks first and creates its own folder without further action (on all start paths since 7.2.0.116, also for a foreign folder without `Eudora.ini` since 7.2.0.117); published since `v1.0.120`. For `v1.0.117` and older, the notice above applies unchanged.

**What is still missing for the next version** is stated, generated, at the top of [ZIEL.md](ZIEL.md) — there and only there, with the name of who checks it.

---

## Known bugs

Status: release **7.2.2.136**. Fixed bugs are in the [update information](#update-information) and the [CHANGELOG](CHANGELOG.md); here is what is **still open or only partly fixed in the release**. Measurement, verdict and source location for each item are in [Intern/BEFUNDE.md](Intern/BEFUNDE.md) under the ID given.

**Back up your mail.** Eudora keeps everything in the `Mailverzeichnis` folder next to the program. If you copy it before the first start of a new version, you can always go back.

### Printing

| Finding | What happens | Workaround | Status |
|---|---|---|---|
| [E-242](Intern/BEFUNDE.md#e-242) | Print and print preview show the path of the temporary file at the bottom (`file:///C:/Users/<Windows user>/…`) instead of *"Printed for …"*; the Windows login name ends up on the printout | check the printout before passing it on | Fix for the print preview built in test package 7.2.2.137, finding still open (not published); printing via *Microsoft Print to PDF* passed by Gregor on 7.2.2.137 |
| [E-240](Intern/BEFUNDE.md#e-240) | *File → Print Preview* takes long on the first call after start (about 38 s timed) with no feedback | wait, don't click again | Hourglass in test package 7.2.2.138 (not published) |

### Missing features

| Finding | What happens | Workaround |
|---|---|---|
| [E-47](Intern/BEFUNDE.md#e-47) | **Directory services** (LDAP, Ph, EudoraBk), **S/MIME** and the **junk filter** are missing — dialog *"Directory Services unavailable"*. Your own address book is not affected | They need `MFC71.DLL` and `msvcp71.dll` (Microsoft, 2003) next to `Eudora.exe`, e.g. from an existing Eudora 7.1, Hermes or Visual Studio 2003; there is no official redistributable, and **we advise against DLL download sites**. Without them Eudora runs, only these add-ons are missing. The 2003 libraries may not be bundled ([FILTER.md](Intern/FILTER.md#warum-die-junk-bewertung-hier-nicht-arbeitet)) |
| [E-90](Intern/BEFUNDE.md#e-90) | Emoji in subject lines do not appear — they are dropped without replacement on fetch | — |
| [E-98](Intern/BEFUNDE.md#e-98) | The save dialog lacks *Include headers* and *Guess paragraphs* | the most recently chosen setting applies |
| [E-139](Intern/BEFUNDE.md#e-139) | Spell checking is missing in this version; the notice appears at every start | dismiss with *OK* (fixed in 7.2.1.129, see CHANGELOG) |

### Saving, character sets, search

| Finding | What happens | Workaround |
|---|---|---|
| [E-198](Intern/BEFUNDE.md#e-198) | A multipart received message in a character set that Eudora does not translate on receipt (`windows-1251`, `koi8-r`, `iso-8859-2`) gets the label `ISO-8859-1` on *Save As* and with the filter action *Notify Application*; the saved file then shows garbled text (the message in the mailbox does not) | — |
| [E-207](Intern/BEFUNDE.md#e-207) | *File → Save As* in the **signature window**: writes the content since 7.2.2.132, but the window does not ask on closing afterwards, the change is only in the copy; the dialog still offers *Rtf Files* and writes text | save the signature with *File → Save*; save as `.txt` instead of `.rtf` |
| [E-136](Intern/BEFUNDE.md#e-136), [E-178](Intern/BEFUNDE.md#e-178), [E-179](Intern/BEFUNDE.md#e-179) | Emoji and characters outside the Western European character set can turn into `?` when saving or editing. Fixed for *Ctrl+S*, link, fixed-width (7.2.1.129–130, measured on the test bench); **not measured:** *Save As* as `.htm`, reply to selected text, the text part next to the HTML part, and search | do not edit and save affected messages; back up the mailbox first |
| [E-193](Intern/BEFUNDE.md#e-193) | Search with umlauts or `€`: *Find Messages* fixed in 7.2.2.133; remainder (*Edit → Find* reports *"not found"*) in test package 7.2.2.135. Exact search in IMAP mailboxes is not measured on the test bench | if *Edit → Find* does not find a word that *Find Messages* reports: click once at the top of the text and search again |
| [E-71](Intern/BEFUNDE.md#e-71) | The filter report stays empty — not a bug, it is off by default (as in the original) | *Tools → Options → Getting Attention → Generate filter report*, see [FAQ 23](Doku/FAQ.md#23-warum-ist-der-filterbericht-leer) |
| [E-220](Intern/BEFUNDE.md#e-220) | A new mailbox with an umlaut in its name (*Prüfung*) gets a file without the umlaut (`Prfung.mbx`); in Eudora it is named correctly | left that way on purpose; [issue](https://github.com/HansWurst81675/Eudora7.2/issues) or PR welcome |

### IMAP

| Finding | What happens | Workaround |
|---|---|---|
| [E-188](Intern/BEFUNDE.md#e-188) | **If an IMAP server permanently refuses part of a message** (attachment, embedded image), Eudora re-fetches the message on every display; mailbox file and attachment folder can grow. When moving, the message stays in the source (Gregor's decision of 04 Nov 2026: *safety over space*), and an empty entry appears in the target. Rare | If a mailbox file grows noticeably, check the message on the server; do not delete the source by hand after moving; do not mistake the empty entry in the target for the moved message |
| [E-184](Intern/BEFUNDE.md#e-184), [E-189](Intern/BEFUNDE.md#e-189) | Moving between IMAP folders of the same account when the target already holds another message with the same internal number: display corrected in 7.2.1.131. Without UIDPLUS, the message appears in the target under the old number next to the other one | **do not delete apparent duplicates in the target** — on the server this probably hits the other message |
| [E-142](Intern/BEFUNDE.md#e-142) | A draft dragged from an IMAP folder to `Out` produces an **empty** message; the original stays in the IMAP folder. From 7.2.1 Eudora asks first. For the message *"No messages were transferred!"* see [E-141](Intern/BEFUNDE.md#e-141) | keep drafts in the local `Out` (*Ctrl+S*); delete the original only after checking the copy |
| [E-129](Intern/BEFUNDE.md#e-129) | Moved to IMAP without a server connection and exited immediately: the target folder shows only some of the messages | *Right-click the mailbox → Show Deleted Messages*, then *Message → UnDelete*; do **not** use *Purge Messages* |
| [E-126](Intern/BEFUNDE.md#e-126) | Rare, suspected: a **sent** message moved exactly while the folder is being synchronized does not reach the server and lies only in the local trash | briefly check the IMAP folder after moving; do not empty the trash right away |
| [E-123](Intern/BEFUNDE.md#e-123) | After a crash, power failure or forced shutdown in the middle of a move, embedded images may be missing (on a normal exit Eudora waits since 7.2.0.104) | wait until the move has finished before exiting |
| [E-127](Intern/BEFUNDE.md#e-127) | If an IMAP folder had never been opened since start, moved messages could be missing from the list. Last no longer seen on 23 Oct 2026, **cause never found** | close and reopen the folder; please report |
| [E-233](Intern/BEFUNDE.md#e-233) | An IMAP message whose subject wraps right after `Subject:` probably appears without a subject in the list (established from source, not measured) | open the message; the subject is in the header |
| [AN-1](Intern/BEFUNDE.md#an-1) | An attachment with no extension at all in its file name gets no extension over IMAP (over POP it does) | rename the file in the attachment folder |
| [E-77](Intern/BEFUNDE.md#e-77) | Messages saved with *Fcc* into an IMAP folder with an umlaut before the update to 7.2.1 are sent but **not filed, without any message** | choose the Fcc target anew before sending |

### Other

| Finding | What happens | Workaround |
|---|---|---|
| [E-173](Intern/BEFUNDE.md#e-173) | When creating a filter with *Make Label*, the labels may be greyed out once (suspected, not reproduced) | delete the filter and create it anew |
| [E-222](Intern/BEFUNDE.md#e-222) | After opening an S/MIME-signed message via the attachment icon, two lines of header text appear above the content (harmless, open) | — |
| [E-124](Intern/BEFUNDE.md#e-124) | Microsoft Defender may wrongly classify a version as a trojan and terminate the program without a message | [Windows Defender reports Eudora as a trojan](Doku/ANWENDER.md#windows-defender-meldet-eudora-als-trojaner) |

For every bug: in the cases named, the mail itself is not lost; *Workaround* describes how to get around display and usage problems. Where passwords, foreign servers or certificates are concerned, it says so explicitly (see [E-204](Intern/BEFUNDE.md#e-204), fixed in 7.2.2.132, and [eMudhra](#compromised-emudhra-certificates-october-2026)).

---

## When Windows blocks the start (*Mark of the Web*)

When you download a ZIP from the net, Windows remembers its origin in an alternate data stream `Zone.Identifier` — and Explorer passes it on to **every** single file when extracting. An `.exe` is blocked, a `.cmd` is not; that is why `Eudora starten.cmd` runs but `Eudora.exe` does not on double-click. **This is not a bug of Eudora 7.2**, but a Windows safeguard ([E-138](Intern/BEFUNDE.md#e-138)).

**Best beforehand:** right-click the downloaded `.zip` → *Properties* → tick *Unblock* at the bottom → *OK* — **then** extract. That way none of the files gets the mark.

**Already extracted?** In PowerShell:

```
Get-ChildItem -Recurse 'C:\path\to\Eudora72-folder' | Unblock-File
```

**Check whether that is really the cause:**

```
Get-Item 'C:\path\to\Eudora72-folder\Eudora.exe' -Stream *
```

If a `Zone.Identifier` stream is listed, that is the mark; `Get-Content ... -Stream Zone.Identifier` even shows the source URL. After unblocking, the stream is gone and the double-click starts.

> The *Unblock* checkbox in the properties dialog of a **single** file only helps that one file — the DLLs next to it keep the mark.

> **Not to be confused with the Defender false alarm** ([E-124](Intern/BEFUNDE.md#e-124)): that removes the file and reports `Trojan:Win32/Bearfoos.A!ml`. Here nothing is removed, the start is merely refused.

---

## Compromised eMudhra certificates (October 2026)

**What it is about.** On 20 Oct 2026 it became known that eight intermediate certificates of the Indian certificate authority **eMudhra** had been generated with keys of only 3 to 8 bits — anyone who knows them can issue a certificate for **any** server on the internet that programs trusting the eMudhra roots will accept ([Ars Technica](https://arstechnica.com/security/2026/10/the-internet-goes-on-high-alert-after-discovery-of-8-compromised-tls-certs/)). Browsers revoked the certificates the same day. The article explicitly warns about programs that ship **their own list** of root certificates — Eudora is one of them.

**Why Eudora was affected.** Eudora does not check server certificates against Windows, but against the file `rootcerts.p7b` — first in the mail folder, otherwise in the program folder — and does not query revocation lists. The list up to package 1.0.122 contained four eMudhra roots (*emSign Root CA – G1*, *– C1*, *emSign ECC Root CA – G3*, *– C3*). This can only be exploited if someone redirects the network traffic between Eudora and the mail server, for example on public Wi-Fi; they could then present Eudora with a fake mail server and read the password and mail.

**What is fixed (from release 7.2.1).** The four roots are removed from the bundled list: [`Releases/1.0/rootcerts.p7b`](Releases/1.0/rootcerts.p7b) now contains 117 instead of 121 certificates, generated by [`rootcerts-erzeugen.ps1`](Releases/1.0/rootcerts-erzeugen.ps1) with an exclusion list; the package build puts this file into every package. GMX and freenet (IMAP, POP3, SMTP) were measured against the new list with OpenSSL and are accepted — their certificates come from Telekom (T-TeleSec). With Eudora itself, Gregor measured it on test package 7.2.0.123: fetch without certificate errors. That Eudora rejects an eMudhra chain remains a calculation. A regression test turns red as soon as an eMudhra root comes back ([E-148](Intern/BEFUNDE.md#e-148)).

**With an older package:** quit Eudora, rename the existing `rootcerts.p7b` in the program folder to `rootcerts.p7b.alt` and put the new file from `Releases/1.0/` in its place — or use Eudora only on your own network until then. After the swap, fetch mail once. If Eudora reports a certificate error, delete the new file and rename `rootcerts.p7b.alt` back; then, however, the four eMudhra roots are back too.

**Also check the mail folder.** If you ever copied a `rootcerts.p7b` into the mail folder yourself, you keep **that** list, even with the new package: delete it there or replace it with the new file (found by [PRÜFER-51](Befunde/PRUEFER-51.md#pruefer-51), K6).

**Which list applies is in the log** — provided `LogLevel` in the `[Debug]` group of `Eudora.ini` contains the switch 32768 (the package sets `LogLevel=58527`, your own `Eudora.ini` often does not; see [Doku/ANWENDER.md](Doku/ANWENDER.md)). On the first encrypted fetch or send after start, Eudora writes a line like `rootcerts.p7b geladen aus: C:\…\Mailverzeichnis\rootcerts.p7b (vorhanden)` to `eudora.log` in the mail folder. *"FEHLT"* means: no `rootcerts.p7b` lies in either folder, and Eudora has no list to check server certificates against.

---

## Checking your own changes (test bench)

If you change Eudora in a clone or fork, use the test bench to check whether something that worked before has broken. It starts Eudora about sixty times with prepared test mails and its own test servers on your own machine (nothing goes to the internet) and checks a good hundred cases.

1. Build Eudora: `powershell -File tools\bauen.ps1` ([Doku/BAUEN.md](Doku/BAUEN.md)).
2. Double-click **`Pruefstand starten.cmd`** in the main folder, answer the question with `j`.
3. Wait — measured 60 to 91 minutes for the full run (as of 06 Nov 2026) — and do not use the computer; Eudora windows open and close. The starter states the expected duration beforehand and the actual one at the end.
4. At the end: `ERGEBNIS: alle Fälle bestanden` or the list of red cases.

**Just trying it, without Visual Studio:** install Git for Windows, clone the repo, double-click `Pruefstand starten.cmd`, answer `j` — the most recently published release is then tested (one-time download, about 9 MB).

**Requirements in short:** own Windows account or VM · Git for Windows · Visual Studio 2022 only for your own changes · free ports 11110, 1143, 1144, 1025, 18169 · clone in a folder without spaces · a good 700 MB plus 1.6 GB · one to one and a half hours · internet on the first run.

Requirements, switches, reading the result and failure patterns: [**Doku/PRUEFSTAND.md**](Doku/PRUEFSTAND.md). The test directories are created under `C:\Temp\Eudora72-Pruefstand` (another folder with `-Wurzel`); the test bench only touches directories it created and marked itself — your own Eudora folders with real mail stay untouched. Because of the registry, on a machine with a real Eudora setup it is still better to use a separate Windows account or a VM.

---

## Status

The yardstick is in [ZIEL.md](ZIEL.md): nine criteria that decide whether a version is ready for acceptance, plus individual requirements `A-n`. **ZIEL.md is the source** — `tools/doku-pruefen.pl` rejects every commit in which another file claims something different about a criterion.

In short: Eudora builds from a fresh clone, the package starts on a machine without Visual Studio, mail is fetched and sent over TLS, replies and forwards work, the program exits cleanly, and the open windows appear as tabs at the bottom edge. What a user still notices today is above under [Known bugs](#known-bugs) and in [Doku/ANWENDER.md](Doku/ANWENDER.md#was-es-nicht-kann); the complete list with measurement and source location is kept in the [CHANGELOG](CHANGELOG.md) under *Noch offen* and *Erreicht*.

**The test guide for the current package is not here**, but in the CHANGELOG at the entry of the version — a guide in the README goes stale with the next build without anyone noticing.

## Related projects

- [HermesMail](https://sourceforge.net/projects/hermesmail/) — retrofits an installed Eudora 7.1 with newer TLS DLLs in binary form (OpenSSL 1.0.2)
- [Eudora_patches](https://github.com/HansWurst81675/Eudora_patches) — binary patches for umlaut display

## License

[**LICENSE**](LICENSE) — the full text. In short:

The Eudora source code is under the BSD-3-Clause license with a patent exclusion, under which the Computer History Museum released it in 2018 (copyright line of 2016, see the header of the source files). **Everything newly created in this project** — the replacement layer under `Eudora71/OTShim`, the tools under `tools/` and the documentation — is under the **same** license. Almost all changes lie within files carrying this license header; a second license would create a boundary nobody can maintain.

Using, modifying and redistributing is thereby permitted, also commercially, as long as the copyright notice and license text go along. No warranty, no patent rights, and our names not for advertising.

**Two restrictions**, which [LICENSE](LICENSE) lists in detail: third-party components such as OpenSSL, expat and libpng keep their own licenses — and some things in the tree belong **neither to us nor to the Computer History Museum**: the Stingray headers under `Eudora71/OT501`, `Paige32.dll`, `SMIME.dll` and the directory-service libraries from 2003. We cannot grant anyone rights to those.
