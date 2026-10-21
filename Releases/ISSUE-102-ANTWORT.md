# Issue #102 — der Beitrag, der nach dem Release abgeschickt wird

**Stand 21.10.2026.** Weiterhin **nicht abgeschickt**.

> **Die Fassungsnummer steht jetzt auf `v1.0.117`** — vier Stellen, geändert am
> 21.10.2026 ([LEKTOR-46](../Befunde/LEKTOR-46.md#l-46.6)). Vorher stand
> viermal `v1.0.114` da; diese Fassung ist nie veröffentlicht worden, Gregor
> hat beim Testen einen Fehler gefunden (Eudora hielt sein eigenes
> Mailverzeichnis für fremd), behoben in 7.2.0.115, und darauf folgten
> 7.2.0.116 und 7.2.0.117. **Nur die Nummer ist geändert** — eine
> Fassungsnummer ist eine Tatsache, kein Wortlaut; alles andere steht, wie
> Gregor es am 20.10.2026 freigegeben hat.
>
> **Abgeschickt wird der Beitrag erst, wenn `v1.0.117` wirklich
> veröffentlicht ist** — gemessen am 21.10.2026 gibt es das Tag noch nicht,
> veröffentlicht ist `v1.0.113`. Vorher zeigen alle vier Verweise ins Leere.

Gehört zu [E-132](../BEFUNDE.md#e-132) und
[E-131](../BEFUNDE.md#e-131). Ziel:
[Issue #102](https://github.com/HansWurst81675/Eudora7.2/issues/102),
Adressat `@rjsdotorg`.

**Von Gregor am 20.10.2026 freigegeben**, mit einer Änderung: *„statt »lives«
schreib lieber »is located«"*. Der Text unten trägt sie bereits.

**Noch nicht abgeschickt.** Er nennt `v1.0.117`; abgeschickt wird er erst,
wenn es diese Fassung als Release gibt — sonst zeigt der Hinweis ins Leere.

**Warum dieser Text hier liegt und nicht nur im Chat:** ein Chat überlebt kein
Abschalten, und ein freigegebener Wortlaut, der danach aus dem Gedächtnis
nachgebaut wird, ist nicht mehr derselbe.

**Was ich am 20.10.2026 Satz für Satz gegen [E-132](../BEFUNDE.md#e-132),
[E-131](../BEFUNDE.md#e-131), [E-124](../BEFUNDE.md#e-124) und
[CHANGELOG 7.2.0.114](../CHANGELOG.md) gehalten habe
([LEKTOR-44](../Befunde/LEKTOR-44.md#l-44.8)).** **Belegt ist jeder Satz**: der
Registry-Weg und die drei Antworten samt Vorgabe stehen so in E-132, die drei
Messungen (*No* → fremde INI SHA-256 unverändert, *Yes* → `LastKnownCrashInfo`
ändert sich, *Cancel* → nichts angefasst) ebenso, die vier neuen Zeilen im
Über-Dialog und der Knopf *Copy info* stehen im CHANGELOG-Abschnitt 7.2.0.114,
und die Defender-Angaben (Erkennungsname, Datum, Vorgangsnummer) decken sich
mit E-124 und [DEFENDER-FEHLALARM.md](DEFENDER-FEHLALARM.md).

**Drei Dinge sagt der Text nicht. Ob sie hinein sollen, entscheidet Gregor —
den freigegebenen Wortlaut unten habe ich nicht angefasst.**

1. **Seine vorhandene `Eudora.ini` wird dadurch nicht heil.** Unsere Behebung
   zu [E-131](../BEFUNDE.md#e-131) berichtigt die Leistenwerte erst beim
   **Sichern**; eine INI, die sie schon trägt, bleibt, wie sie ist. Er hat
   seine aus der Sicherung zurückgespielt, also trifft es ihn nicht mehr — ein
   anderer Leser desselben Beitrags aber schon.
2. **Die Ursache seines Absturzes ist weiterhin nicht belegt.**
   [PRÜFER-40](../Befunde/PRUEFER-40.md#k1) K1: `-2147483648` ist `CW_USEDEFAULT`, das MFC
   selbst setzt und beim Lesen wieder abfängt. Dieselbe Richtigstellung steht
   schon als eigener Beitrag im Issue (20.10.2026); *„we found the mechanism
   behind this and fixed it"* ganz oben kann so gelesen werden, als sei auch
   das erledigt.
3. **Die Bitte, `v1.0.117` neben seiner Installation zu probieren, nennt keine
   Vorsichtsmaßnahme.** Solange die Ursache offen ist
   ([PRÜFER-40](../Befunde/PRUEFER-40.md#k14) K14 nennt mit `Docking=1` ohne Andockkontext
   einen zweiten, ungemessenen Weg zu genau seinem Null-Zeiger), gehört ein
   *„back up your `Eudora.ini` first"* dazu — dasselbe, was wir in der README
   von jedem Anwender verlangen.

---

Hi @rjsdotorg — we found the mechanism behind this and fixed it in **v1.0.117**.

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
We have no Hermes here. If you can try v1.0.117 alongside your existing
installation, that closes the last gap.

Also new: *Help → About Eudora* now shows the INI path, the log path with its
log level, and **where the mail folder came from**, plus a **Copy info**
button — useful for any follow-up report.

One warning: Windows Defender currently flags our executable as
`Trojan:Win32/Bearfoos.A!ml`. It is a false positive; we submitted it to
Microsoft on 2026-10-20 (submission
`a567fe2a-9f58-47e1-a675-a62733ec538f`). You may need to restore the file from
quarantine.
