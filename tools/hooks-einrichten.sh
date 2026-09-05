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

# 4. Schranke gegen lautlose Dateischaeden (Zeilenenden, Kodierung).
exec perl "$WURZEL/tools/pruefe-bytes.pl"
HOOKENDE

chmod +x "$HOOK"

echo "pre-commit eingerichtet: $HOOK"
echo
echo "Der Hook prueft in dieser Reihenfolge:"
echo "  1. tools/pruefe-branch.pl    lebt der Zweig, auf den hier committet wird?"
echo "  2. tools/lehren-spiegeln.pl  sind die Lehren im Repo?"
echo "  3. tools/release-pruefen.pl  meldet nur, weist nicht ab"
echo "  4. tools/pruefe-bytes.pl     sind Zeilenenden und Kodierung heil?"
echo
echo "Die abweisenden Schritte 1, 2 und 4 werten JEDEN Rueckgabewert aus -"
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
