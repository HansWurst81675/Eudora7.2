# Issue #102 — der Beitrag, der nach dem Release abgeschickt wird

**Stand 20.10.2026.** Gehört zu [E-132](../BEFUNDE.md#e-132) und
[E-131](../BEFUNDE.md#e-131). Ziel:
[Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102),
Adressat `@rjsdotorg`.

**Von Gregor am 20.10.2026 freigegeben**, mit einer Änderung: *„statt »lives«
schreib lieber »is located«"*. Der Text unten trägt sie bereits.

**Noch nicht abgeschickt.** Er nennt `v1.0.114`; abgeschickt wird er erst,
wenn es diese Fassung als Release gibt — sonst zeigt der Hinweis ins Leere.

**Warum dieser Text hier liegt und nicht nur im Chat:** ein Chat überlebt kein
Abschalten, und ein freigegebener Wortlaut, der danach aus dem Gedächtnis
nachgebaut wird, ist nicht mehr derselbe.

---

Hi @rjsdotorg — we found the mechanism behind this and fixed it in **v1.0.114**.

**What was happening.** If you start `Eudora.exe` directly instead of via
`Eudora starten.cmd`, and there is no `Eudora.ini` next to the executable —
which is the case in our packages, ours is located in `Mailverzeichnis\` —
Eudora falls back to
`HKEY_CURRENT_USER\Software\Qualcomm\Eudora\CommandLine\Current` and silently
adopts the data folder of whichever Eudora or Hermes ran last. That is exactly
the *"found the existing one in another folder and modified its ini"* you
reported.

**What changed.** Before adopting such a folder, Eudora now asks, offering
three choices: use it anyway / start with a fresh folder next to this program
/ quit without changing anything. The default is the middle one, so pressing
Enter cannot damage an existing installation.

**What we measured**, with a second installation standing in for yours:

* *No* → a fresh folder is used, and the other installation's `Eudora.ini` is
  byte-identical afterwards (SHA-256 compared).
* *Yes* → the other folder is used and its `Eudora.ini` does change — the
  original damage, reproduced on purpose.
* *Cancel* → Eudora exits, nothing is touched.

**What we could not test: whether your Hermes 7.1 starts again afterwards.**
We have no Hermes here. If you can try v1.0.114 alongside your existing
installation, that closes the last gap.

Also new: *Help → About Eudora* now shows the INI path, the log path with its
log level, and **where the mail folder came from**, plus a **Copy info**
button — useful for any follow-up report.

One warning: Windows Defender currently flags our executable as
`Trojan:Win32/Bearfoos.A!ml`. It is a false positive; we submitted it to
Microsoft on 2026-10-20 (submission
`a567fe2a-9f58-47e1-a675-a62733ec538f`). You may need to restore the file from
quarantine.
