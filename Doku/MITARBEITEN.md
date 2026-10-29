# Mitarbeiten

Zurück zum [Einstieg](../README.md).

## Mitarbeiten

### Was liegt wo

```
Eudora7.2/
├─ Eudora71/                 der Quellbaum, eine Projektmappe (Eudora.sln)
│  ├─ Eudora/                das Programm selbst — hier liegt das meiste
│  ├─ OTShim/                die Ersatzschicht für Stingray OT501
│  ├─ OT501/                 was von Stingray übrig ist: 127 Header, keine Quellen
│  ├─ QCSSL/ QCSocket/ QCUtils/ EuImap/ Imapdll/ EuLang/ …
│  │                         die einzelnen DLLs
│  ├─ AccountWizard/ Importers/ DirectoryServices/ SearchEngine/
│  │                         Assistent, Importer, Verzeichnisdienste, Suche
│  ├─ PaigeDLL/              der Textsatz von 2005 (Paige32.dll)
│  ├─ OpenSSL3/              OpenSSL 3.5.8 LTS: Header und .lib, im Repo
│  ├─ OpenSSL/               OpenSSL 0.9.7l von 2006 — Altbestand, niemand linkt es
│  ├─ VC71Bruecke/           Nachbau der MSVCR71.dll als Weiterleitung
│  ├─ Tests/                 Unit- und Komponententests (RunTests.cmd)
│  ├─ Bin/<Konfiguration>/   hierhin baut alles (nicht versioniert)
│  └─ Lib/<Konfiguration>/   die .lib (nicht versioniert)
├─ tools/                    Bauskripte, Prüfschranken, Messwerkzeuge
├─ Releases/                 ausgelieferte Pakete, Prüfsummen, PAKETE.md
├─ Befunde/                  je Agent eine Datei; BEFUNDE.md ist die Zusammenführung
├─ Pruefung/                 abgeschlossene Prüfberichte
├─ Arbeitsweise/             Spiegel der Lehren (tools/lehren-spiegeln.pl)
├─ InstallersForEudora/      Originaldateien von QUALCOMM: INI-Vorlagen, Zertifikate
├─ OnlineHelp/ Documents/    Altbestand aus der CHM-Freigabe von 2018
├─ Sandbox/ BuildTools/      Altbestand aus dem ersten Import, nicht im Bau
└─ *.md                      die Dokumentation, siehe darunter
```

### Welche Datei welche Frage beantwortet

| Frage | Datei |
|---|---|
| Woran wird „fertig" gemessen? | [ZIEL.md](../ZIEL.md) — die Quelle für Kriterien und Anforderungen |
| Was hat sich je Fassung geändert? | [CHANGELOG.md](../CHANGELOG.md) |
| Wie funktionieren Filter und Junk, und welche INI-Schlüssel gehören dazu? | [FILTER.md](../Intern/FILTER.md) |
| Welche Schalter gibt es ohne Menüpunkt, und was überrascht beim Betrieb? | [EINSTELLUNGEN.md](../Intern/EINSTELLUNGEN.md) |
| Was wurde gefunden, mit Messung und Fundstelle? | [BEFUNDE.md](../Intern/BEFUNDE.md), Einzelbefunde in `Befunde/` |
| Was ist als Nächstes zu tun? | [AUFGABEN.md](../Intern/AUFGABEN.md), Einstieg in [WEITERMACHEN.md](../Intern/WEITERMACHEN.md) |
| Wie teste ich, was auf mein Urteil wartet? | [TESTPLAN.md](../Intern/TESTPLAN.md) — die vierzehn, die frischen Behebungen, und was im Protokoll zu sehen sein muss |
| Wie wurde von VC6 auf VS2022 portiert, und warum so? | [PORTIERUNG.md](../Intern/PORTIERUNG.md) |
| Welche Werkzeuge gibt es in `tools/`? | [tools/WERKZEUGE.md](../tools/WERKZEUGE.md) |
| Was muss neben `Eudora.exe` liegen, damit sie startet? | [STARTUMGEBUNG.md](../Intern/STARTUMGEBUNG.md) |
| Welches ZIP gehört zu welchem Commit? | [Releases/PAKETE.md](../Releases/PAKETE.md) |
| Wie arbeiten mehrere Agenten nebeneinander? | [AGENTEN.md](../Intern/AGENTEN.md) |
| Wonach wird gebaut, geprüft, abgenommen? | [PRUEFUNG-BAU.md](../Intern/PRUEFUNG-BAU.md), [PRUEFUNG-CODE.md](../Intern/PRUEFUNG-CODE.md), [PRUEFUNG-BRANCH.md](../Intern/PRUEFUNG-BRANCH.md) |
| Warum steht die Doku so, wie sie steht? | [LEKTORAT.md](../Intern/LEKTORAT.md) |

### Fassungen und Pakete

Zwei Nummern, und sie bedeuten Verschiedenes:

| Nummer | steht in | bedeutet |
|---|---|---|
| **Quellstand**, z. B. `7.2.1.128` | `Eudora71/Version.h` | die Produktversion, die ein Bau in die `Eudora.exe` schreibt. Sie steht in der Dateiinfo und in der Titelzeile |
| **Paketnummer**, z. B. `7.2.1.128` | die Datei `VERSION` | benennt das ausgelieferte ZIP |

Seit 7.2.0.128 sind beide Nummern **gleich**: `7.2.0.N` für ein Testpaket,
`7.2.1.N` für ein Release. Bis 1.0.127 hieß die Paketnummer `1.0.N` und
teilte mit dem Quellstand nur die letzte Stelle; die Endnummer zählt über
beide Formen weiter. Beide Dateien gehen gemeinsam hoch, und zwar **bevor**
gebaut wird — sonst tragen zwei verschiedene Bauten dieselbe Kennung, und ein
Fehlerbericht ist keinem Stand mehr zuzuordnen (Befund
[**V-1**](../Intern/BEFUNDE.md#v-1)).

Die Titelzeile nennt die Nummer plus den Commit; ein Bildschirmfoto ist
damit eindeutig. Welches ZIP zu welcher Marke und welchem Commit gehört, führt
[Releases/PAKETE.md](../Releases/PAKETE.md) mit Prüfsumme.

### Werkzeuge und Schranken

In `tools/` liegen die Bauskripte, die Messwerkzeuge und die Schranken, die vor
jedem Commit laufen. Die vollständige Übersicht mit einer Zeile je Werkzeug:
**[tools/WERKZEUGE.md](../tools/WERKZEUGE.md)**.

Was man als Erstes wissen muss:

* **Der `pre-commit`-Hook läuft immer.** Er prüft Zweigwahl
  (`tools/pruefe-branch.pl`), Zeilenenden und Kodierung
  (`tools/pruefe-bytes.pl`) und — sobald eine `.md`, `VERSION` oder
  `Eudora71/Version.h` im Commit steht — die Doku gegen sich selbst
  (`tools/doku-pruefen.pl`). `--no-verify` ist keine Lösung, sondern das
  Umgehen der Antwort.
* **Zeilenenden und Kodierung sind heikel.** Die Quellen von 1996–2006 sind
  **Latin-1** mit absichtlich gemischten Zeilenenden, teils innerhalb einer
  Datei. Wer eine Quelldatei ändert, nimmt `tools/aendere-zeile.pl` oder
  `tools/ersetze-bereich.pl` — beide schreiben byte-erhaltend. Die MD-Dateien
  sind dagegen reines LF ohne BOM.
* **Nichts starten, was ein Fenster öffnet**, ohne Absprache — dafür gibt es
  `tools/testlauf.ps1` als einzigen Weg.

### Wie hier gearbeitet wird

Jede Änderung läuft über einen eigenen Zweig; `main` wird nicht direkt
beschrieben. Mehrere Agenten arbeiten in getrennten Arbeitsbäumen, jeder
schreibt seine Befunde in eine **eigene** Datei unter `Befunde/`, und
`tools/befunde-einsammeln.pl` führt sie am Ende in [BEFUNDE.md](../Intern/BEFUNDE.md)
zusammen — zwei Agenten fassen so nie dieselbe Datei an. Das Verfahren steht
in [AGENTEN.md](../Intern/AGENTEN.md).

