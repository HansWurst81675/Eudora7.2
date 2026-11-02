---
name: kein-squash-im-repo
description: "Daten von Gregors Rechner gar nicht erst schreiben, auch nicht in die Commit-Nachricht - eine Merge-Art ist keine Abhilfe; berichtigt 02.11.: das Repo ERLAUBT Squash (allow_squash_merge true, gemessen), und mit COMMIT_MESSAGES hätte es den Pfad aus der Nachricht mitgenommen"
metadata:
  node_type: memory
  type: project
  originSessionId: 25e03584-872c-4e92-943a-2e540eaef311
  modified: 2026-11-02T07:16:16.520Z
---

Schranke: keine — Lehre gilt beim Schreiben, bevor gepusht wird (pruefe-testdaten-anonym.pl kennt keine Pfade).

Gregor am 02.11.2026 nach #199: *„es gab keinen squash and merge button."* Der PR wurde als normaler Merge übernommen; der Zwischen-Commit `1c75f5c3` mit seinem VM-Freigabepfad und Testmail-Betreff steht damit in der Geschichte von `main`. Gregor: *„ja, so lassen."*

**Why:** Ich hatte „Squash and merge" als Abhilfe angeboten, ohne zu prüfen, ob das Repo es zulässt.
**How to apply:** Daten von Gregors Rechner (Pfade, Betreffs, Dateinamen, Bildnamen) gar nicht erst in Befunde schreiben — „Gregors Testdateien vom <Datum>" genügt. Keine Abhilfe über die Merge-Art versprechen. Siehe [[gedaechtnis-ist-oeffentlich]].

## Berichtigung 02.11.2026 (CHRONIST): Squash ist erlaubt, und es hätte nicht geholfen

Gemessen um 08:40 MEZ mit `gh api repos/HansWurst81675/Eudora7.2`:

    allow_squash_merge: true   allow_merge_commit: true   allow_rebase_merge: true
    squash_merge_commit_message: COMMIT_MESSAGES

1. **Das Repo erlaubt „Squash and merge“.** Die Überschrift dieser Lehre ist deshalb falsch. Bei GitHub steht die Wahl im Pfeil neben dem grünen Knopf, nicht als eigener Knopf (Vermutung zur Ursache von Gregors *„es gab keinen squash and merge button“*, nicht an seinem Bildschirm geprüft). Die Notiz von 08:16 hat Gregors Beobachtung als Eigenschaft des Repos aufgeschrieben, ohne sie zu messen. Der Fehler von 07:51 (nicht geprüft, bevor angeboten) wiederholte sich damit beim Aufschreiben ([[rueckfrage-ist-keine-messung]]).
2. **Squash hätte den Pfad nicht ferngehalten.** Mit `COMMIT_MESSAGES` schreibt GitHub die Nachrichten aller Einzelcommits in die Nachricht des Squash-Commits, und der Freigabepfad stand in der **Nachricht** von `1c75f5c3`. Außerdem trifft `git log origin/main -G vmware-host` schon Commits vom 26.10. bis 30.10.
3. **LEKTOR-123 hat L-123.4 als *„erledigt durch Entscheidung“* (Squash) abgehakt**, auf die Nachricht der Hauptsitzung hin, vor dem Merge. Seit dem normalen Merge stimmt das nicht mehr ([[CHRONIST-2026-11-02]]).

**How to apply, berichtigt:** Die Regel oben bleibt: Daten von Gregors Rechner gar nicht erst schreiben, auch nicht in die Commit-Nachricht. Eine Abhilfe, die Gregor ausführen soll, wird vorher am Repo gemessen (`gh api repos/<repo> --jq .allow_squash_merge,.squash_merge_commit_message`), und der Weg dahin wird genannt (*„Pfeil neben ‚Merge pull request‘ → ‚Squash and merge‘“*). Ein LEKTOR hakt einen Fund erst nach der Handlung ab, nicht auf ihre Ankündigung hin.
