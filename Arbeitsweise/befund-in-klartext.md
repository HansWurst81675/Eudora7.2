---
name: befund-in-klartext
description: Gregor versteht die Befundzeilen in BEFUNDE.md nicht mehr - jede braucht vorn drei Saetze Klartext (was der Anwender merkte, Stand, was noch fehlt), die Herleitung dahinter
metadata:
  type: feedback
---

Schranke: keine - noch kein Werkzeug; Kandidat fuer eine Pruefung im pre-commit (Form des ersten Satzes je Befundzeile). Bis dahin beim Fortschreiben jeder Zeile pruefen.

Gregor am 23.10.2026 zu E-101: *"im befunde ist es einfach nicht mehr zu verstehen, was du da alles zusammen geschrieben hast."* Die Zeile E-101 ist ein einziger Tabellenabsatz mit Messungen, Prueferkennungen (P-22, P-28, F1-F9), Zeilennummern und Zwischenstaenden aus fuenf Tagen.

**Why:** BEFUNDE.md ist Gregors Nachschlagewerk; wenn er eine Zeile nicht versteht, kann er weder entscheiden noch testen. Fortschreiben hat jede Zeile laenger gemacht, nie klarer.

**How to apply:** Jede Befundzeile beginnt mit hoechstens drei Saetzen ohne Kuerzel: was der Anwender gemerkt hat, wie der Stand ist (behoben in welcher Fassung, von wem bestaetigt), was noch fehlt und ob Gregor etwas tun muss. Die Herleitung folgt danach oder gehoert in den Pruefbericht. Beim naechsten Anfassen einer Zeile diese Form herstellen, zuerst bei den offenen und den release-relevanten. Siehe [[kuerzel-im-chat-uebersetzen]], [[chat-knapp-halten]].

Dazu am selben Tag: *"ich habe keine solche mails, kann es also nicht testen."* - Faelle, fuer die Gregor keine passende Post hat (z. B. kyrillischer Zeichensatz bei E-101), stelle ICH mit Pruefnachrichten unter `Testdaten/` am Pruefstand nach; sie gehoeren nicht in seinen Testplan.

**Nachtrag 24./25.10.2026 (CHRONIST):** Zweimal wieder, beide Male nach dieser Lehre. 24.10. 22:33 MESZ zu meiner Fragenliste: *„ich verstehe nicht, was E-113 alles bedeutet, zu viel infos, durcheinander. was fehlt? was ist B?"* — „Variante B" war eine Bezeichnung aus Frage 3 von LEKTOR-55, die ich ohne Erklärung weitergab. 25.10. 16:49 MEZ, nach dem Merge von PR #173: *„e-150: welche spalte? welche liste?"* und um 16:51 *„ich dachte, es geht um mails mit spalten und listen."* — der Befund hieß dort „Spalte löschen schreibt hinter das Feld", ohne den Namen des Fensters (*Task Status*). Die Klartextform gilt also auch für **PR-Titel, Commit-Betreffs und Fragelisten**, nicht nur für Befundzeilen: erster Satz nennt Fenster oder Menü, in dem der Anwender es merkt.

**Nachtrag 25.10.2026 abends (CHRONIST): Arbeitskürzel in Überschriften.** Gregor um 19:12:32 MEZ zur CHANGELOG-Überschrift *„Seit 7.2.0.122, noch ohne Paket"*: *„was heißt hier "ohne paket"? sind wir bei der post?"*. „Paket" ist mein Wort für das ZIP zum Herunterladen. Für einen Leser von außen heißt es etwas anderes. Die Berichtigung (19:13, Commit „'noch ohne Paket' durch Klartext ersetzt") schreibt jetzt *„auf `main`, aber noch in keinem Paket zum Herunterladen … Das Programm meldet deshalb weiter die Fassung 7.2.0.122"*. Eine Antwort im Chat bekam Gregor nicht, nur den Commit ([[chat-knapp-halten]], Nachtrag 25.10.). Und die neue Überschrift „auf `main`" war um 19:53 schon wieder ungenau, weil E-137 darunter stand, bevor es auf `main` war (LEKTOR-64 L-64.3). Eine Überschrift, die einen **Ort** behauptet („auf main"), veraltet mit jedem Zweig. Eine, die den **Inhalt** nennt („noch in keinem Paket zum Herunterladen"), veraltet nicht.
