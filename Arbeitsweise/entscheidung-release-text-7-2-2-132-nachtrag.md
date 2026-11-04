---
name: entscheidung-release-text-7-2-2-132-nachtrag
description: "Gregor 04.11.2026: Release-Text v7.2.2.132 bekommt den Rat, scheinbare Doppel nach dem Verschieben zwischen Konten nicht zu löschen (E-188d); den Satz zum Testrückstand (L-142.7) nicht nachträglich, ab dem nächsten Release in der Vorlage"
metadata:
  type: project
---

Schranke: keine - eine Entscheidung zu einem veröffentlichten Text; geprüft wird sie beim Nachtragen (Release-Text vom Server gegen Releases/7.2.2.132/RELEASE-NOTIZEN.md).

Gregor am 04.11.2026 auf zwei Fragen aus [LEKTOR-145](../Befunde/LEKTOR-145.md) (L-145.4) und LEKTOR-142 (L-142.7):

1. **Ja, nachtragen:** Der veröffentlichte Release-Text v7.2.2.132 bekommt unter „Bekannte Fehler" den Rat, scheinbar doppelte Einträge im Zielordner nach dem Verschieben zwischen zwei IMAP-Konten nicht zu löschen (gemessen, Fall `E-188d`: das Löschen trifft auf dem Server eine fremde Mail). Ein zusätzlicher Rat „den Ordner neu abgleichen“ stand im ersten Entwurf und wurde verworfen: gemessen standen die Doppel auch nach erneutem Öffnen noch da (Commit `ea65447e`, LEKTOR-146 L-146.5). Die ZIP bleibt unverändert.
2. **Nein, nicht nachträglich:** Der Satz zum Rückstand an Regressionstests (vier kritische Befunde ohne jede Prüfung: E-123, E-124, E-126, E-129) kommt erst ab dem nächsten Release, dann fest in die Vorlage der Release-Notizen.

**Why:** Der Rat zu 1. kann Mail retten, solange 7.2.2.132 das neueste Release ist; der Satz zu 2. ändert für den Anwender nichts an der Bedienung.
**How to apply:** 1. in `Releases/7.2.2.132/RELEASE-NOTIZEN.md` nachtragen, dann `gh release edit v7.2.2.132 --notes-file …` und den Text vom Server zurücklesen. 2. beim nächsten Release in die Vorlage. Verwandt: [[entscheidung-e188-release-7-2-2-132]].
