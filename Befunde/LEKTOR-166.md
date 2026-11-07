# <a id="lektor-166"></a>LEKTOR-166 — Zweig `e241_vorschau_tasten` nach acc87f6c: Nachlauf zu LEKTOR-165 vor dem PR

**Urteil:** Alle sechs Funde aus [LEKTOR-165](LEKTOR-165.md) sind eingearbeitet. Der Abbruch von `tools/gesichert.pl` an einem sauberen Arbeitsbaum ([L-165.1](LEKTOR-165.md#l-165.1)) ist behoben, gemessen am echten Lauf und mit Gegenprobe. **1 neuer Fund, gering.** **Nichts hält den PR auf.**

Umfang: nur `git diff d3de62e4..HEAD` (6 Dateien, 25 Zeilen hinzu, 13 weg).

## Erledigungsstand

| Fund | Stand | Beleg |
|---|---|---|
| [L-165.1](LEKTOR-165.md#l-165.1) | **erledigt (gemessen)** | `tools/gesichert.pl:142`: *„return (\@alle, [], []) unless @alle;“*. Selbsttest `:254-258` prüft jetzt *„ref($ueberholt) eq 'ARRAY'“*. Messungen siehe unten. |
| [L-165.2](LEKTOR-165.md#l-165.2) | erledigt (gemessen am Text) | `tools/WERKZEUGE.md:64`: *„**11** (seit 07.11.2026, vorher 9)“*; Punkt nach *„in beide Richtungen).“* gesetzt. |
| [L-165.3](LEKTOR-165.md#l-165.3) | erledigt (belegt am Code) | `tools/gesichert.pl:383-392` nimmt den dritten Wert auch im eigenen Baum an und meldet *„… schon in %s steht (ueberholt, nichts geht verloren)“*; `:402` unterdrückt den Satz „Byte fuer Byte“, wenn alle offenen überholt sind. Die Grenze der Mengenprüfung steht in `tools/WERKZEUGE.md:64`: *„nicht Reihenfolge oder Anzahl“*. Rest siehe [L-166.1](#l-166.1). |
| [L-165.4](LEKTOR-165.md#l-165.4) | erledigt (gemessen am Text) | `Intern/WEITERMACHEN.md:19`: *„seit 07.11.2026 geklärt: die Vorschau blättert mit Alt+Pfeil, durch die Doku erledigt (Zweig `e241_vorschau_tasten`)“*. |
| [L-165.5](LEKTOR-165.md#l-165.5) | erledigt (gemessen am Text) | `Intern/BEFUNDE.md:410`: *„(Überholt durch das Urteil oben: die Vorschau blättert mit Alt+Pfeil.)“* und *„**Damals fehlte (erledigt, siehe Urteil):**“*. Das verbliebene *„Was noch fehlt:“* steht im Teil hinter *„Vorher:“* und ist damit gekennzeichnet. |
| [L-165.6](LEKTOR-165.md#l-165.6) | erledigt (gemessen am Text) | `Doku/FAQ.md:543`: *„dort gelten seine Tasten, nicht die von Eudora.“*; `Doku/FUNKTIONEN.md:453-454`: *„Eudoras Tastenbelegung wirkt dort nicht“*; `Intern/BEFUNDE.md:410`: *„eine Umbelegung ist nicht versucht“*. `git grep "nicht umbelegen"` außerhalb von `Befunde/` trifft nur noch den LEKTORAT-Eintrag zu [LEKTOR-165](LEKTOR-165.md#lektor-165). |

### Messungen zu L-165.1

* **Eigener Baum (gemessen):** `perl tools/gesichert.pl; echo rc=$?` → kein Absturz, *„rc=1“* (die beiden anderen Bäume haben je eine ungesicherte Datei; das ist ein echter Befund des Werkzeugs, keiner dieses Zweigs).
* **Selbsttest (gemessen):** *„Selbsttest: 11 von 11 Faellen, 0 rot.“*, rc=0.
* **Gegenprobe (gemessen):** Kopie mit der alten Zeile `:142` im Scratchpad → *„[ROT] sauberer Baum: nichts geaendert, nichts verloren“*, *„10 von 11 Faellen, 1 rot“*. Die Behauptung der Commit-Nachricht stimmt.
* **Der eigentliche Weg (gemessen):** Werkzeug aus diesem Baum mit `--ohne-holen` und `GIT_OPTIONAL_LOCKS=0` im Baum `.wt/stand` gestartet; dort ist dieser saubere LEKTOR-Baum ein fremder Baum. Neu: *„…/.wt/lektor sauber“*, Mängelliste wird gedruckt, rc=1. Alte Zeile: *„Can't use an undefined value as an ARRAY reference at … line 514.“*, rc=255.

## Neue Funde

### <a id="l-166.1"></a>L-166.1 — Der Hinweis „Byte fuer Byte“ zählt die überholten Dateien mit

**Gewicht: gering.** Belegt am Code.

* `tools/gesichert.pl:402-405`: *„elsif (@offen > @ueberholt) { push @hinweis, sprintf("%d geaenderte Datei(en) - ihr Inhalt steht Byte fuer Byte " … scalar @offen);“*. Sind z. B. 3 Dateien offen und 1 davon überholt, meldet `:388-391` die eine als überholt, und `:403` meldet dann *„3 geaenderte Datei(en) … Byte fuer Byte“*. Die überholte Datei steht damit in beiden Hinweisen, und für sie stimmt „Byte fuer Byte“ gerade nicht (Anlass von [L-165.3](LEKTOR-165.md#l-165.3)).
* Es geht nichts verloren, beide Hinweise sagen „kein Verlust“. Nur die Zahl ist falsch.

**Soll:** in `:405` `scalar(@offen) - scalar(@ueberholt)` statt `scalar @offen`.

## Hält etwas den PR auf?

**Nein.** [L-165.1](LEKTOR-165.md#l-165.1) ist behoben und am echten Weg gemessen, mit Gegenprobe. [L-166.1](#l-166.1) ist gering und kann mit dem nächsten Commit am Werkzeug mitgehen.
