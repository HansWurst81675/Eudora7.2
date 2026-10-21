**Eudora 7.2.0.120 / Paket 1.0.120**

> **Nachgetragen am 21.10.2026 abends vom LEKTOR ([L-49.6](../../Befunde/LEKTOR-49.md#l-49.6)).**
> Zu `v1.0.120` gab es keine Notizen im Arbeitsbaum — derselbe Fall wie bei
> `v1.0.117` am Vormittag ([L-46.2](../../Befunde/LEKTOR-46.md#l-46.2)).
> Der **Text unten ist der Rumpf des veröffentlichten Releases, wörtlich**,
> geholt mit `gh release view v1.0.120 --json body`; er ist nicht
> nachträglich geschönt worden.

## Das Release

| | |
|---|---|
| Marke | `v1.0.120`, auf Commit `30feeae2` |
| Veröffentlicht | 21.10.2026, **19:07:37 UTC** (21:07:37 Ortszeit), auf GitHub *Latest* |
| URL | https://github.com/HansWurst81675/Eudora7.2/releases/tag/v1.0.120 |
| Anhang | `Eudora72-1.0.120-release.zip`, **9 381 870 Byte** |
| SHA-256 | `26fde41437ae159659675f73cef9037a87aff755e3f71ca5a4bc084a3af6a6a1` — am Anhang auf GitHub gemessen (`gh release view v1.0.120 --json assets`), byte-gleich mit dem ZIP im Arbeitsbaum |
| Enthält | **drei** Quellstände: 7.2.0.118 ([E-132](../../BEFUNDE.md#e-132), fehlgeschlagene Rückfrage), 7.2.0.119 ([E-134](../../BEFUNDE.md#e-134), Kurzname), 7.2.0.120 ([E-135](../../BEFUNDE.md#e-135), Vervollständigungsbox) |
| Freigabe | Gregor am 21.10.2026: *„ich habe ja schon alles getestet."* |
| Geschnürt | 21.10.2026 um 14:14 nach `C:\Users\Gregor\Eudora72-1.0.120-release`; Einzelheiten in [Releases/PAKETE.md](../PAKETE.md), Abschnitt 1.0.120 |

## Der veröffentlichte Text, wörtlich

> Diese Fassung bringt drei Behebungen: 7.2.0.118, 7.2.0.119 und 7.2.0.120.
> Die beiden mittleren wurden gebaut, aber nie veröffentlicht.
>
> ## 7.2.0.120 — die Vervollständigungsbox schrumpft nicht mehr ([E-135](https://github.com/HansWurst81675/Eudora7.2/blob/main/BEFUNDE.md#e-135))
>
> Beim Tippen einer Adresse und Blättern mit den Cursortasten wurde die
> Vorschlagsliste bei **jedem Schritt um acht Pixel kleiner** — nach fünf
> Schritten war nichts mehr davon übrig.
>
> Die Ursache stand seit 1996 im Code, mit dem Kommentar des Verfassers daneben:
> *„Why 6? I haven't a clue."* Es wurden Innenmaße gelesen und daraus Außenmaße
> gesetzt. Gemessen ist der Rand 14 Pixel, nicht 6 — die Differenz verlor die
> Liste bei jedem Aufruf.
>
> Gemessen am laufenden Programm: vorher 100×62 → 20×14 über fünf Schritte,
> jetzt stabil 108×70.
>
> ## 7.2.0.119 — der Kurzname eines neuen Adressbucheintrags kommt an ([E-134](https://github.com/HansWurst81675/Eudora7.2/blob/main/BEFUNDE.md#e-134))
>
> Ein neu angelegter Adressbucheintrag verlor seinen Kurznamen.
>
> ## 7.2.0.118 — eine fehlgeschlagene Rückfrage übernahm das fremde Verzeichnis ([E-132](https://github.com/HansWurst81675/Eudora7.2/blob/main/BEFUNDE.md#e-132))
>
> Seit 7.2.0.117 fragt Eudora, bevor es das Mailverzeichnis einer anderen
> Installation übernimmt. **Schlug diese Rückfrage selbst fehl**, wurde das
> fremde Verzeichnis stillschweigend doch genommen — also genau in der Lage,
> für die der Schutz gebaut war. Jetzt gilt im Fehlerfall die sichere Antwort.
>
> ## Wenn Sie bereits Eudora 7.1 oder Hermes benutzen
>
> **Sichern Sie vorher Ihre `Eudora.ini` und das komplette Mailverzeichnis.**
>
> Dieses Projekt startet mit einem **eigenen** Mailverzeichnis und fasst eine
> vorhandene Installation nicht an — `Eudora starten.cmd` hält sich daran. Wer
> `Eudora.exe` direkt startet, wird gefragt; die Vorgabe ist ein frischer
> Ordner, Enter kann nichts zerstören.
>
> Parallelbetrieb mit geteilter `Eudora.ini` oder geteiltem Mailverzeichnis
> geschieht **auf eigene Gefahr**: beide Programme schreiben denselben Satz
> Werkzeugleisten mit unterschiedlichen MFC-Fassungen in dieselbe Datei.
> Verträglichkeit der `Eudora.ini` mit fremden oder früheren Fassungen ist kein
> Ziel dieses Projekts — benutzen Sie getrennte Verzeichnisse.
>
> ## Hinweis zu Windows Defender
>
> Defender meldet unsere `Eudora.exe` derzeit als `Trojan:Win32/Bearfoos.A!ml`.
> Das ist ein Fehlalarm; er wurde am 20.10.2026 bei Microsoft eingereicht
> (Vorgang `a567fe2a-9f58-47e1-a675-a62733ec538f`). Gegebenenfalls muss die
> Datei aus der Quarantäne zurückgeholt werden.
>

## Was in diesen Notizen bewusst nicht steht

Die älteren Notizen tragen am Ende die Zeile *„Adressbuch, LDAP und S/MIME
fehlen weiterhin."* **Sie ist falsch und wird hier nicht fortgeschrieben.**
Das eigene Adressbuch ist in `Eudora.exe` übersetzt und arbeitet — in genau
diesem Release sind zwei Fehler darin behoben ([E-134](../../BEFUNDE.md#e-134),
[E-135](../../BEFUNDE.md#e-135)). Was aus [E-47](../../BEFUNDE.md#e-47) tatsächlich ausfällt, sind die
**Verzeichnisdienste**: LDAP, Ph, `EudoraBk` und S/MIME. Siehe
[L-49.4](../../Befunde/LEKTOR-49.md#l-49.4).
