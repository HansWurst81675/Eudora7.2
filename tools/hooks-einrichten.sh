#!/bin/sh
#
# Richtet die git-Hooks dieses Projekts ein.
#
#   sh tools/hooks-einrichten.sh
#
# Muss einmal nach jedem frischen Klon laufen. Hooks liegen unter .git/hooks und
# werden von git NICHT mitversioniert - ohne diesen Schritt fehlen alle Schranken
# und die Fehler, gegen die sie schuetzen, treten lautlos wieder auf.
#
# Geschrieben wird in das GEMEINSAME git-Verzeichnis (--git-common-dir), nicht in
# "$WURZEL/.git". In einem Arbeitsbaum ist ".git" eine DATEI, kein Verzeichnis -
# der frueher hier stehende Pfad "$WURZEL/.git/hooks" war dort nicht beschreibbar,
# und das Einrichten aus einem Arbeitsbaum heraus scheiterte. Das gemeinsame
# Verzeichnis gilt fuer alle Arbeitsbaeume auf einmal, und das ist hier genau
# richtig: die Schranken sollen ueberall greifen.
#
set -e

GITDIR="$(git rev-parse --path-format=absolute --git-common-dir)"
HOOK="$GITDIR/hooks/pre-commit"

mkdir -p "$GITDIR/hooks"

cat > "$HOOK" <<'HOOKENDE'
#!/bin/sh
WURZEL="$(git rev-parse --show-toplevel)"

# 1. Schranke gegen Commits auf einen toten Zweig: schon zusammengefuehrt,
#    Gegenstueck auf dem Server geloescht, oder abgeloester HEAD.
#
#    Steht ZUERST, weil die Frage "landet dieser Commit ueberhaupt irgendwo"
#    vor jeder Frage nach seinem Inhalt kommt. Am 31.08.2026 um 09:06 ist ein
#    Commit auf einen drei Minuten zuvor zusammengefuehrten Zweig gelegt worden
#    (Befund X-5).
perl "$WURZEL/tools/pruefe-branch.pl" || exit $?

# 2. Lehren aus dem Gedaechtnis des Assistenten ins Repo spiegeln,
#    sonst gehen sie beim naechsten Abschalten verloren.
#
#    Der Rueckgabewert MUSS ausgewertet werden. Bis zum 31.08.2026 stand hier
#    nur der Aufruf: lehren-spiegeln.pl meldete "Der Commit wurde abgebrochen",
#    der Hook lief aber weiter und gab am Ende den Wert der Schranke zurueck.
#    Die Meldung war also unwahr, und die gespiegelten Lehren gingen weiterhin
#    lautlos aus dem Commit heraus (Befund X-1, Zusatzfund; NP3-4).
perl "$WURZEL/tools/lehren-spiegeln.pl" || exit $?

# 3. Release gegen den Quellstand pruefen. Meldet nur, weist NICHT ab - deshalb
#    steht hier bewusst kein "|| exit". Erst still laufen lassen; nur wenn etwas
#    nicht stimmt, ein zweites Mal laut.
perl "$WURZEL/tools/release-pruefen.pl" >/dev/null 2>&1 || \
  perl "$WURZEL/tools/release-pruefen.pl" || true

# 4. Doku gegen sich selbst pruefen. Laeuft IMMER und weist IMMER ab.
#
#    Bis zum 07.09.2026 stand hier ein "if": die Pruefung lief nur, wenn der
#    Commit selbst eine .md, VERSION oder Version.h anfasste. Genau daran ist
#    sie vorbeigelaufen - eine veraltete Datei, die NIEMAND anfasst, steht in
#    keinem Diff und wurde deshalb nie geprueft. Gregor fand am selben Tag drei
#    Widersprueche selbst (Paketnummer 1.0.18 statt 1.0.21 im README, ein ZIP,
#    das es nicht mehr gibt, und eine Kriterientabelle in AUFGABEN.md, die zwei
#    erfuellte Kriterien als offen fuehrte) und sagte: "waere vor dem mergen
#    wichtig, dass keine luegen im main stehen!" und "ich moechte dir nicht jede
#    einzelne MD datei nennen, es betrifft ALLE!".
#
#    Das Werkzeug holt sich seine Dateiliste seit dem selbst aus
#    git ls-files "*.md" und laeuft in unter einer Sekunde - es gibt keinen
#    Grund mehr, es an eine Bedingung zu haengen.
perl "$WURZEL/tools/doku-pruefen.pl" || exit $?

# 5. Fensterbau absichern (Befunde E-33/E-34/E-35/E-36): keine modale Meldung
#    in der Ersatzschicht, GetButton mit Indexschranke UND Ausnahmefang, jeder
#    GetButton-Aufruf prueft sein Ergebnis auf NULL.
#    Diese Schranke gibt es seit dem 07.09.2026 - sie hing bis zum 08.09.2026
#    aber NICHT im Hook, lief also nur, wenn jemand daran dachte. Genau das
#    soll ein Hook verhindern.
perl "$WURZEL/tools/pruefe-fensterbau.pl" || exit $?

# 6. Das Beenden absichern (Kriterium 7, Befunde E-40/E-41/E-42). Gregor am
#    08.09.2026: "haben wir ein review? und neue tests fuer die neue version?
#    wenn nicht, nachholen!" Die Behebung besteht aus drei Teilen, und jeder
#    kann durch eine spaetere, gut gemeinte Aenderung lautlos verschwinden.
perl "$WURZEL/tools/pruefe-beenden.pl" || exit $?

# 7. Die Include-Waechter der Ersatzschicht (Lehre teilweise-ersetzte-header).
#
#    Der staerkste Beleg dieses Projekts dafuer, dass eine Lehre ohne Ausloeser
#    nichts verhindert: die Lehre lag seit dem 30.08.2026 im Gedaechtnis und
#    hat neun Tage lang nichts abgewehrt. Genau der Fehler, den sie beschreibt
#    - ein Include-Waechter fuer einen nur teilweise ersetzten Header - war die
#    Wurzel von E-34, E-37, E-38 und E-43. Das Werkzeug gibt es seit dem
#    08.09.2026; ab hier haengt es an einem Moment, den jeder Commit durchlaeuft.
perl "$WURZEL/tools/pruefe-waechter.pl" || exit $?

# 8. Jede Lehre in Arbeitsweise/ muss ihre Schranke nennen.
#
#    Gregor am 08.09.2026: "mach dir aus lessons leared alles schranken, die
#    dann greifen." Ohne diese Pruefung entsteht die naechste Lehre wieder als
#    reiner Text - und Text wird nicht gelesen, wenn es eilig ist.
perl "$WURZEL/tools/lehren-schranken.pl" || exit $?

# 9. Schranke gegen lautlose Dateischaeden (Zeilenenden, Kodierung).
exec perl "$WURZEL/tools/pruefe-bytes.pl"
HOOKENDE

chmod +x "$HOOK"


# --- pre-push: die Schranke vor dem Merge ------------------------------------
# Gregor am 07.09.2026: "waere vor dem mergen wichtig, dass keine luegen im main
# stehen!" - der pre-commit greift je Commit, aber gemergt wird ein ZWEIG. Ein
# Zweig kann aus lauter gruenen Commits bestehen und am Ende trotzdem eine
# veraltete Datei tragen, wenn zwischendurch VERSION oder Version.h weitergezogen
# wurde. Deshalb hier noch einmal, gegen den fertigen Stand.
HOOK_PUSH="$GITDIR/hooks/pre-push"
cat > "$HOOK_PUSH" <<'HOOKPUSHENDE'
#!/bin/sh
# Erzeugt von tools/hooks-einrichten.sh - nicht von Hand aendern.
WURZEL="$(git rev-parse --show-toplevel)"

echo "pre-push: Doku gegen sich selbst pruefen (alle MD-Dateien)"
perl "$WURZEL/tools/doku-pruefen.pl" || exit $?

echo "pre-push: Zeilenenden und Kodierung"
perl "$WURZEL/tools/pruefe-bytes.pl" || exit $?

exit 0
HOOKPUSHENDE
chmod +x "$HOOK_PUSH"
echo "pre-push eingerichtet: $HOOK_PUSH"
echo "pre-commit eingerichtet: $HOOK"
echo
echo "Der Hook prueft in dieser Reihenfolge:"
echo "  1. tools/pruefe-branch.pl    lebt der Zweig, auf den hier committet wird?"
echo "  2. tools/lehren-spiegeln.pl  sind die Lehren im Repo?"
echo "  3. tools/release-pruefen.pl  meldet nur, weist nicht ab"
echo "  4. tools/doku-pruefen.pl     stimmt die Doku mit sich selbst? (IMMER, alle"
echo "                               MD-Dateien aus git ls-files, immer abweisend)"
echo "  5. tools/pruefe-fensterbau.pl haelt der Fensterbau? (E-33..E-36)"
echo "  6. tools/pruefe-beenden.pl   haelt das Beenden? (E-40..E-42)"
echo "  7. tools/pruefe-waechter.pl  stehen die Include-Waechter richtig?"
echo "  8. tools/lehren-schranken.pl nennt jede Lehre ihre Schranke?"
echo "  9. tools/pruefe-bytes.pl     sind Zeilenenden und Kodierung heil?"
echo
echo "Abweisend sind alle Schritte ausser 3, und sie werten JEDEN"
echo "Rueckgabewert aus -"
echo "genau das fehlte bis zum 31.08.2026 bei Schritt 2 (Befund X-2), und im"
echo "eingerichteten Hook fehlte es bis zum 05.09.2026 immer noch (X-5)."
echo
echo "Ausserdem empfohlen - der Arbeitsbaum darf nicht auf CRLF umgeschrieben werden:"
echo "  git config core.autocrlf false"
echo
echo "Vor einem Merge durch Gregor, und bevor ein Chat endet:"
echo "  perl tools/gesichert.pl"
echo
echo "Pruefen, wie weit Pruefung und Doku hinter dem Code sind:"
echo "  perl tools/pruefstand-melden.pl"
