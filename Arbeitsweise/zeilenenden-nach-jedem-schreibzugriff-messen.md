---
name: zeilenenden-nach-jedem-schreibzugriff-messen
description: "Nach jedem Skript, das Dateien schreibt, die CR-Anzahl gegen HEAD messen - der Fehler ist lautlos"
metadata:
  type: feedback
---

Nach **jedem** Skript, das Dateien im Repo schreibt, und **vor** `git add`:
CR-Anzahl der Arbeitskopie gegen `git show HEAD:<datei>` vergleichen. Weicht sie
ab, zurueckwandeln, bevor irgendetwas gestaget wird.

**Why:** Am 28.08.2026 zweimal passiert. Einmal wurden vier reine LF-Dateien
(statbar.cpp, header.cpp, BossProtector.cpp, TridentPreviewView.cpp) auf CRLF
umgestellt - 2194 Scheinaenderungen allein in statbar.cpp, Ursache bis heute
ungeklaert. Einmal landete ein echtes CR-Byte im Text von PORTIERUNG.md.
Gregor hat beides bemerkt und gefragt, wo die Schwierigkeit liege.

Die Schwierigkeit ist, dass der Fehler **lautlos** ist: kein Abbruch, keine
Warnung, der fachliche Inhalt stimmt. Sichtbar wird er erst im Diff, und dann
sieht eine Einzeilenaenderung wie ein Totalumbau aus. Eine Regel im Kopf reicht
dagegen nicht, nur eine Messung.

**How to apply:**

- Pruefbefehl: `tr -cd '\r' < datei | wc -c` gegen
  `git show HEAD:datei | tr -cd '\r' | wc -c`.
- **Nie ein Steuerzeichen-Escape in einen Heredoc schreiben.** Getestet und
  bestaetigt: ein doppelt geschriebenes Backslash-r kommt bei Perl als einfaches
  an und wird zum CR-Byte - auch bei `<<'MARKE'` in Anfuehrungszeichen. Wenn im
  Text von Zeilenenden die Rede sein soll, umschreiben ("CR-Anzahl per tr")
  statt das Escape zu setzen.
- Entlastet: Lesen mit `:raw`, `split /(?<=\n)/`, `join`, Schreiben mit `:raw`
  ist byte-erhaltend (getestet, 0 CR bei einer LF-Datei). Der Roundtrip ist
  nicht die Ursache.
- Bei gemischten Zeilenenden im Repo (hier der Normalfall) nie pauschal
  konvertieren, sondern nur die Dateien zuruecksetzen, deren CR-Zahl abweicht.

Siehe auch [[pruefen-statt-vermuten]] und
[[doku-bei-jedem-commit-mitziehen]].
