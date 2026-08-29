#!/bin/sh
#
# Richtet die git-Hooks dieses Projekts ein.
#
#   sh tools/hooks-einrichten.sh
#
# Muss einmal nach jedem frischen Klon laufen. Hooks liegen unter .git/hooks und
# werden von git NICHT mitversioniert - ohne diesen Schritt fehlen beide Schranken
# und die Fehler, gegen die sie schuetzen, treten lautlos wieder auf.
#
set -e

WURZEL="$(git rev-parse --show-toplevel)"
HOOK="$WURZEL/.git/hooks/pre-commit"

cat > "$HOOK" <<'HOOKENDE'
#!/bin/sh
# 1. Lehren aus dem Gedaechtnis des Assistenten ins Repo spiegeln,
#    sonst gehen sie beim naechsten Abschalten verloren.
perl "$(git rev-parse --show-toplevel)/tools/lehren-spiegeln.pl"
# 2. Schranke gegen lautlose Dateischaeden (Zeilenenden, Kodierung).
exec perl "$(git rev-parse --show-toplevel)/tools/pruefe-bytes.pl"
HOOKENDE

chmod +x "$HOOK"

echo "pre-commit eingerichtet: $HOOK"
echo
echo "Ausserdem empfohlen - der Arbeitsbaum darf nicht auf CRLF umgeschrieben werden:"
echo "  git config core.autocrlf false"
echo
echo "Pruefen, wie weit Pruefung und Doku hinter dem Code sind:"
echo "  perl tools/pruefstand-melden.pl"
