# Ausgelieferte Fassungen von QCSSL.dll

Jede Datei, die je unter `Releases/1.0/QCSSL.dll` stand — mit Prüfsumme, damit sich
im Nachhinein eindeutig sagen lässt, welche gemeint ist.

## Warum es diese Liste gibt

Die Versionskennung wurde erst spät eingebaut und dann einmal nicht mitgezogen.
Dadurch tragen **zwei verschiedene Binärdateien dieselbe Kennung „QCSSL 1.0.0"**.
Wer sagt „ich habe 1.0.0 getestet", meint also möglicherweise die eine oder die
andere — und die unterscheiden sich in fünf behobenen Befunden.

Die Prüfsumme ist eindeutig. So liest man sie ab:

```bash
certutil -hashfile QCSSL.dll SHA256
```

## Die Fassungen, neueste zuerst

| SHA256 (Anfang) | Kennung in der DLL | Commit | Zeitpunkt | Was dazukam |
|---|---|---|---|---|
| `ab55281a` | **QCSSL 1.0.1** | `17428a1` | 30.08. 15:31 | Kennung nachgezogen; inhaltlich gleich wie `5c7fcd50` |
| `5c7fcd50` | QCSSL 1.0.0 ⚠ | `e2c2608` | 30.08. 15:26 | **Fünf Befunde**: TLS-Untergrenze 1.2 für *alle* Einstellungen (M1), BIO-Struktur threadsicher (M2), Empfangspfad las Sendeeinstellung (M4), Zeigerschmuggel beseitigt (N1), Rückgabewerte ausgewertet (N3) |
| `9af89315` | QCSSL 1.0.0 ⚠ | `94e32c6` | 29.08. 22:03 | Versionskennung überhaupt erst eingebaut |
| `bee0a06e` | *keine* | `a7478b0` | 29.08. 21:49 | Regression behoben: ungültige Protokollversion verband, statt abzubrechen (H1) |
| `c875a750` | *keine* | `643305d` | 28.08. 20:02 | Fest verdrahtete Cipher-Liste von 2006 entfernt — sie hätte TLS 1.2 blockiert |
| `48b6b476` | *keine* | `a52beed` | 28.08. 19:05 | Erste Auslieferung: OpenSSL 3.5.8 statt 0.9.7l |

⚠ = mehrdeutige Kennung, nur über die Prüfsumme unterscheidbar.

## Welche Fassung wurde gegen einen echten Mailserver getestet?

Der Abruf gegen `pop.gmx.net` fand am **29.08. um 19:49:07** statt (TLS 1.3,
`TLS_AES_256_GCM_SHA384`, Aushandlung erfolgreich).

Zu diesem Zeitpunkt lag `c875a750` aus (`643305d`, 28.08. 20:02). Die nächste
Fassung `bee0a06e` entstand erst zwei Stunden später.

**Getestet wurde also `c875a750`** — die Fassung *ohne* Versionskennung, *ohne* den
Regressionsfix H1 und *ohne* WACHEs fünf Befunde. Alle vier späteren Fassungen sind
gegen die Komponententests geprüft, aber **nicht erneut gegen einen echten
Mailserver**.

## Was das für die aktuelle Fassung bedeutet

> ### Erledigt am 31.08.2026: der Servertest ist bestanden
>
> `ab55281a` (QCSSL 1.0.1) hat gegen `mx.freenet.de` auf **Port 110 mit
> STARTTLS** gearbeitet: **TLSv1.3**, `TLS_AES_256_GCM_SHA384`, 256 Bit,
> Status *Succeeded*, 08:09:43 Uhr. Danach 159 Nachrichten abgerufen.
> Abgelesen in *Tools → Last SSL Info*. Einzelheiten in `BEFUNDE.md`, E-3.
>
> Die Sorge, die strengeren Vorgaben aus M1 könnten etwas verschlechtern,
> hat sich **nicht** bestätigt.

`ab55281a` (QCSSL 1.0.1) ist die einzige, die man einsetzen sollte. Sie enthält
alles Genannte. Der Mailserver-Test steht für sie aus.

Wer sie gegen einen echten Server prüft: Eudoras eigener Dialog
*Tools → Last SSL Info* zeigt Protokoll und Verfahren an. Interessant ist, ob dort
weiterhin `TLSv1.3` und ein AEAD-Verfahren steht — mit den strengeren Vorgaben aus
M1 sollte sich nichts verschlechtert haben.
