#!/bin/sh
# Gegentest fuer die Summenpruefung in tools/doku-pruefen.pl (Pruefung 3).
#
# Baut ein eigenes kleines git-Repo, damit "git ls-files" die Pruefdateien
# sieht - das Werkzeug holt seinen Umfang von dort. Nur so trifft die Messung
# den Weg, den das Werkzeug im Ernstfall geht
# (Arbeitsweise/messung-muss-den-weg-treffen.md).
#
# Sechs Faelle, in BEIDE Richtungen:
#   1  "N von M Kriterien", Summe richtig      -> MUSS still sein
#   2  "N von M Kriterien", Summe falsch       -> MUSS gemeldet werden
#   3  "M Kriterien: ...",  Summe richtig      -> MUSS still sein
#   4  "M Kriterien: ...",  Summe falsch       -> MUSS gemeldet werden
#   5  fett "**N** von **M** Kriterien", richtig -> MUSS still sein
#   6  fett "**N** von **M** Kriterien", falsch  -> MUSS gemeldet werden
#
# Fall 6 ist der wichtigste: der richtige Satz (5) war auch VOR der Behebung
# still - nur weil die Pruefung an der fetten Schreibweise gar nicht anlief.
# Erst der umgekehrte Wert zeigt, ob die Pruefung ueberhaupt laeuft
# (Arbeitsweise/gegenprobe-umdrehen.md).
#
# Aufruf: sh summe-gegentest.sh [pfad-zu-doku-pruefen.pl]

set -e
# Ohne Argument das Werkzeug neben diesem Skript nehmen.
WERKZEUG="$1"
[ -n "$WERKZEUG" ] || WERKZEUG=$(dirname "$0")/doku-pruefen.pl
[ -f "$WERKZEUG" ] || { echo "Nicht gefunden: $WERKZEUG"; exit 2; }
WERKZEUG=$(cd "$(dirname "$WERKZEUG")" && pwd)/$(basename "$WERKZEUG")

PROBE=$(mktemp -d)
trap 'rm -rf "$PROBE"' EXIT
cd "$PROBE"

git init -q .
git config user.email probe@example.invalid
git config user.name Probe

# ZIEL.md: die Quelle der Kriterienzahl. Neun Zeilen "| N |" = neun Kriterien.
{
  echo '# Ziel'
  echo
  echo '| # | | Stand |'
  echo '|---|---|---|'
  i=0
  while [ $i -le 8 ]; do
    echo "| $i | **Kriterium $i** | erfuellt |"
    i=$((i + 1))
  done
} > ZIEL.md

mkdir -p Eudora71
printf '#define EUDORA_BUILD_VERSION "7.2.0.29"\n' > Eudora71/Version.h
printf '1.0.29\n' > VERSION

schreibe() {   # schreibe <datei> <satz>
  { echo '# Probe'; echo; echo "$2"; } > "$1"
}

schreibe FALL1.md '**Sieben von neun Kriterien sind belegt (0, 1, 3, 5, 6, 7, 8), zwei sind fast erfuellt (2, 4).**'
schreibe FALL2.md '**Drei von neun Kriterien sind belegt (0, 1, 3), zwei sind fast erfuellt (2, 4).**'
schreibe FALL3.md '**neun Kriterien: sieben sind belegt (0, 1, 3, 5, 6, 7, 8), zwei sind fast erfuellt (2, 4).**'
schreibe FALL4.md '**neun Kriterien: drei sind belegt (0, 1, 3), zwei sind fast erfuellt (2, 4).**'

schreibe FALL5.md '**Sieben** von **neun** Kriterien sind belegt (0, 1, 3, 5, 6, 7, 8), **zwei** sind fast erfuellt (2, 4).**'
schreibe FALL6.md '**Drei** von **neun** Kriterien sind belegt (0, 1, 3), **zwei** sind fast erfuellt (2, 4).**'

git add -A >/dev/null
git commit -qm probe >/dev/null 2>&1 || true

AUSGABE=$(perl "$WERKZEUG" 2>&1 || true)

pruefe() {   # pruefe <datei> <erwartet: still|gemeldet> <was>
  if echo "$AUSGABE" | grep -q "^.*$1.*Aufteilung ergibt"; then
    ist=gemeldet
  else
    ist=still
  fi
  if [ "$ist" = "$2" ]; then
    echo "  OK       $1  $ist   ($3)"
  else
    echo "  FEHLER   $1  $ist statt $2   ($3)"
    echo "$AUSGABE" | grep "$1" || true
    FEHLGESCHLAGEN=1
  fi
}

FEHLGESCHLAGEN=0
echo "Gegentest Summenpruefung, sechs Faelle:"
pruefe FALL1.md still    '"Sieben von neun", 7+2=9 - richtig'
pruefe FALL2.md gemeldet '"Drei von neun", 3+2=5 - falsch'
pruefe FALL3.md still    '"neun Kriterien: sieben ... zwei", 7+2=9 - richtig'
pruefe FALL4.md gemeldet '"neun Kriterien: drei ... zwei", 3+2=5 - falsch'

pruefe FALL5.md still    'fett: "**Sieben** von **neun**", 7+2=9 - richtig'
pruefe FALL6.md gemeldet 'fett: "**Drei** von **neun**", 3+2=5 - falsch'

echo
echo "--- volle Ausgabe des Werkzeugs ---"
echo "$AUSGABE" | sed 's/^/    /'

exit $FEHLGESCHLAGEN
