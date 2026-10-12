# <a id="lektor-22"></a>LEKTOR-22 — Release v1.0.83 gegen GitHub nachgemessen (`35e80d4..f49a0d0`)

Lauf am 12.10.2026, nur lesend, aus dem Notizordner übernommen. **Alle vier Mängel sind im selben Commit wie dieser Bericht behoben:** `ZIEL.md:17` und `AUFGABEN.md` (Bei Gregor liegen …) datiert und nachgemessen, [E-94](../BEFUNDE.md#e-94) in CHANGELOG und BEFUNDE auf den Stand 12.10.2026, die v1.0.83-Zeile in `tools/RELEASES.md` in die Tabelle verschoben und auf UTC gesetzt.


## Bestätigt (gemessen)
- `gh release view v1.0.83`: isDraft=false, isPrerelease=false, publishedAt 2026-10-12T11:18:20Z, targetCommitish ec9f11d; `gh release list`: v1.0.83 *Latest*; `git ls-remote`: refs/tags/v1.0.83 -> ec9f11d.
- Asset von GitHub geladen: 9 361 416 Byte, SHA-256 7cef4852…f3eb (Soll getroffen); `Releases/Eudora72-1.0.83-release.zip` lokal identisch.
- ZIP: 34 EXE/DLL/OCX. Stichprobe Eudora.exe, QCUtils.dll, Imap.dll byteidentisch mit C:\Users\Gregor\Eudora72-1.0.83-release.
- WEITERMACHEN.md:27 „Bei Gregor liegen": stimmt mit `ls -d C:/Users/Gregor/Eudora72-*` (Verz. 1.0.72–1.0.76, 1.0.83; ZIPs 1.0.44/53/57).
- Keine Aussage mehr „v1.0.72 neuestes/Latest" oder „v1.0.83 nicht veröffentlicht" in README, WEITERMACHEN, AUFGABEN, ZIEL, PORTIERUNG, PAKETE (PORTIERUNG.md:54-67 ist als Stand 18.09.2026 gekennzeichnet).
- WEITERMACHEN.md:108-158 Nummern 1–6 lückenlos, Reihenfolge [E-94](../BEFUNDE.md#e-94), [E-112](../BEFUNDE.md#e-112), [E-113](../BEFUNDE.md#e-113), [E-77](../BEFUNDE.md#e-77) durchgehalten.

## Mängel
1. ZIEL.md:17 (Satzende, in f49a0d0 geänderte Zeile): „bei ihm liegen 1.0.65, 1.0.67, 1.0.68, 1.0.69, 1.0.71 und 1.0.72" – falsch, gemessen liegen 1.0.72–1.0.76 und 1.0.83 (+ ZIPs 44/53/57). Vorschlag: Wortlaut aus WEITERMACHEN.md:27 übernehmen oder „am 18.09.2026 lagen bei ihm …".
2. AUFGABEN.md:85-90: Gegenwart „Gebaut, geschnürt und veröffentlicht ist 7.2.0.72 / 1.0.72 … Bei Gregor liegen 1.0.65, 1.0.67 … 1.0.72" – direkt vor dem neuen Absatz Z.100 „Veröffentlicht ist v1.0.83". Vorschlag: „Am 17.09.2026 gebaut … veröffentlicht war 7.2.0.72; damals lagen bei Gregor …".
3. CHANGELOG.md:24 (Noch offen, [E-94](../BEFUNDE.md#e-94)): „Ursache NICHT gemessen … Zu messen: ob Encode2047 (sendmail.cpp:1188) …" (Sendeseite) widerspricht WEITERMACHEN.md:120-131 „Ursache am Quelltext belegt … lex822.cpp:685, ImapLex822.cpp:719, RFC 2047 6.2" (Leseseite, Leerraum zwischen gefalteten kodierten Wörtern). Vorschlag: Zeile nachziehen (Leseweg am Quelltext belegt, nicht gemessen; Sendeweg weiter offen) und in BEFUNDE.md [E-94](../BEFUNDE.md#e-94) fortschreiben.
4. tools/RELEASES.md:41: neue Zeile v1.0.83 steht direkt unter dem Zitatblock ohne Leerzeile – wird als Fortsetzung des Zitats gerendert, nicht als Tabellenzeile; außerdem Ortszeit 13:18:20, die Zeile v1.0.72 (Z.29) trägt UTC 20:07:49. Vorschlag: Zeile in die Tabelle (nach Z.30) verschieben, Zeitbasis einheitlich angeben (11:18:20 UTC).
