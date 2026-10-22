# Fehlalarm bei Microsoft melden — fertig ausgefüllt

**Stand 22.10.2026** — zuletzt am 21.10.2026 bei Microsoft nachgesehen, der Vorgang stand auf *pending*; am 22.10.2026 nicht erneut abgefragt; am Text ist nichts geändert, er ist eingereicht. Gehört zu [E-124](../Intern/BEFUNDE.md#e-124). Auf Gregors
Ansage vom 20.10.2026: *„ja, melde den fehlalarm bei microsoft"*.

**Warum das hier als Datei liegt und nicht erledigt ist.** Das Formular
verlangt ein **CAPTCHA**. Das darf ich nicht lösen — also kann ich die Meldung
nicht absenden. Alles andere ist vorbereitet: unten steht jedes Feld mit der
Antwort, die hineingehört, aus dem Baum gemessen und nicht erinnert. Es bleibt
Hochladen, Einfügen, CAPTCHA, Absenden.

**Adresse:** <https://www.microsoft.com/en-us/wdsi/filesubmission>
Eine Anmeldung ist **nicht** nötig („Skip" wählen). Sie bringt nur die
Verfolgung früherer Meldungen.

---

## Die Datei

**Hochladen:** `Releases/Eudora72-1.0.113-release.zip` (9.378.205 Byte,
SHA-256 `0D1D4BF43EAB8323F2CE3AD2FF1C78F44AF5C7ADF7A84E979334AAB5687F4772`).

Das ganze ZIP, nicht die einzelne EXE — die liegt bei dir in der Quarantäne
und wäre beim Entpacken sofort wieder weg. Die Grenze liegt bei 50 MB, das ZIP
ist weit darunter. Ein Kennwort braucht es nicht; Microsoft verlangt
`infected` nur, wenn man selbst eines setzt.

Die beanstandete Datei darin: `Eudora.exe`, 3.012.608 Byte, SHA-256
`6243D4B6432412D52DE3CE1B7BE59EECE9449B40A903B4AEE72171EEA9EEF1AE`,
Versionsressource 7.2.0.113.

## Die Felder

| Feld | Antwort |
|---|---|
| Submitter type | **Software developer** |
| Product | **Microsoft Defender Antivirus** |
| Company name | Eudora7.2 (Open-Source-Projekt) |
| Affected organization | dasselbe |
| Found on Microsoft corporate network | **No** |
| Customer contact email | deine Adresse — nur so kommt das Ergebnis zurück |
| Number of affected devices | **1–100** |
| Priority | **Medium** |
| Classification | **Incorrectly detected as malware/malware-related** |
| Detection name | `Trojan:Win32/Bearfoos.A!ml` |
| Definition version | `1.461.115.0` |

## „Additional information" — zum Einfügen

Englisch, höchstens 1900 Zeichen; der Text unten hat rund 1500.

```
Eudora 7.2 is an open-source port of the historical Qualcomm Eudora 7.1 email
client to Visual Studio 2022 (MFC 14, x86). Source, build scripts and every
release are public at https://github.com/HansWurst81675/Eudora7.2 — the
detected Eudora.exe is built from that source with Eudora71/Eudora.sln,
Release|Win32. It is not packed, not obfuscated, and contains no downloader,
no injection and no network code beyond the mail protocols (POP3, IMAP, SMTP)
the program has used since 1997.

Microsoft Defender quarantines Eudora.exe as Trojan:Win32/Bearfoos.A!ml. The
verdict is machine-learning based and fires when the program is STARTED, not
on an on-demand scan: a targeted scan of the same binary reports nothing. We
have now seen it on three separate builds — 1.0.98 on 2026-10-16, 1.0.111 and
1.0.113 on 2026-10-20 — each a different compile of the same source, so this
is not one corrupted file.

Detected file: Eudora.exe, 3,012,608 bytes, SHA-256
6243D4B6432412D52DE3CE1B7BE59EECE9449B40A903B4AEE72171EEA9EEF1AE, version
resource 7.2.0.113. It is the mail client executable inside the attached
release archive Eudora72-1.0.113-release.zip, SHA-256
0D1D4BF43EAB8323F2CE3AD2FF1C78F44AF5C7ADF7A84E979334AAB5687F4772.

Impact: the file is removed from the machine while the user is working in it,
which ends the running program and leaves the installation unusable. The
project has external users who download these releases from GitHub and hit the
same detection.

We believe this is a false positive and ask for the detection to be reviewed.
We can provide build logs or a reproducible build on request.
```

## Eingereicht am 20.10.2026 — und was daraus geworden ist

| | |
|---|---|
| Vorgangsnummer | `a567fe2a-9f58-47e1-a675-a62733ec538f` |
| Eingereicht | 20.10.2026, 20:57:52, von Gregor |
| Hochgeladen | `Eudora72-1.0.113-release.zip` |
| Einstufung | *Incorrect detection* |
| Status | **Submitted** → *pending* (Stand 20.10.2026, 21:00) |
| Gutachten | — *(hier eintragen, sobald es da ist)* |

Der Stand steht auf der Seite des Vorgangs und ändert sich, ohne dass jemand
etwas tut; *pending* heißt, dass die Datei in der Warteschlange der Analyse
liegt. **Das Ergebnis gehört hierher und nach
[E-124](../Intern/BEFUNDE.md#e-124)** — auch ein ablehnendes. Fällt der Fehlalarm
weg, ist es der erste Fall, in dem eine Fehlerklasse dieses Projekts
**außerhalb** des Projekts abgestellt wurde.

**Kommt nichts oder kommt eine Ablehnung**, bleibt als nächster Schritt die
Code-Signatur — ein Zertifikat kostet Geld und ist deshalb Gregors
Entscheidung, nicht meine.

**Bis dahin unverändert:** jedes Paket kann wieder eingezogen werden. Der
Scan vor der Auslieferung ist **kein** Freispruch — der Fund vom 20.10.2026
um 20:33 kam beim Ausführen, während ein gezielter Scan derselben Datei nichts
meldete.
