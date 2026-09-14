#!/bin/sh
#
# arbeitsbaum-angleichen-tests.sh - Gegenprobe zu tools/arbeitsbaum-angleichen.sh
#
#   bash tools/arbeitsbaum-angleichen-tests.sh
#
# Baut vier Wegwerf-Repos in einem temporaeren Verzeichnis und faehrt elf
# Proben. Das Verzeichnis wird danach geloescht; am echten Repo wird NICHTS
# angefasst.
#
# Die vierte Lage ist die eigentliche Probe: nicht "kommt das gewuenschte
# Ergebnis heraus", sondern "bleibt der Stand unangetastet, wenn es
# schiefgeht" (Lehre: gegenprobe-umdrehen).

set -u

WERKZEUG="$(cd "$(dirname "$0")" && pwd)/arbeitsbaum-angleichen.sh"
TMP="$(mktemp -d 2>/dev/null || mktemp -d -t aat)"
BESTANDEN=0
FEHLER=0

aufraeumen() { rm -rf "$TMP" 2>/dev/null || true; }
trap aufraeumen EXIT

probe() {
    name="$1"; ist="$2"; soll="$3"
    if [ "$ist" = "$soll" ]; then
        BESTANDEN=$((BESTANDEN + 1))
        printf '    ok   %s\n' "$name"
    else
        FEHLER=$((FEHLER + 1))
        printf '    FEHL %s\n         erwartet [%s], bekommen [%s]\n' "$name" "$soll" "$ist"
    fi
}

# --- ein Wegwerf-Repo mit Fernstelle und Arbeitsbaum bauen ------------------
#
# $1 = Name der Lage. Legt an:
#   $TMP/$1/fern    (bare)
#   $TMP/$1/baum    (Arbeitsbaum auf Zweig "arbeit", verfolgt origin/ziel)
baue() {
    lage="$1"
    mkdir -p "$TMP/$lage"
    git init --quiet --bare "$TMP/$lage/fern"

    git init --quiet "$TMP/$lage/saat"
    (
        cd "$TMP/$lage/saat" || exit 1
        git config user.email t@t; git config user.name T
        printf 'Zeile 1\n' > gemeinsam.txt
        git add -A; git commit --quiet -m "Grundstand"
        git branch -M ziel
        git remote add origin "$TMP/$lage/fern"
        git push --quiet origin ziel
    )

    git clone --quiet "$TMP/$lage/fern" "$TMP/$lage/baum" 2>/dev/null
    (
        cd "$TMP/$lage/baum" || exit 1
        git config user.email t@t; git config user.name T
        git checkout --quiet -b arbeit origin/ziel
    )
}

# das Ziel auf der Fernstelle weiterlaufen lassen
ziel_weiter() {
    lage="$1"; datei="$2"; inhalt="$3"
    (
        cd "$TMP/$lage/saat" || exit 1
        printf '%s\n' "$inhalt" > "$datei"
        git add -A; git commit --quiet -m "Ziel: $datei"
        git push --quiet origin ziel
    )
}

# einen eigenen Commit im Arbeitsbaum
eigener_commit() {
    lage="$1"; datei="$2"; inhalt="$3"
    (
        cd "$TMP/$lage/baum" || exit 1
        printf '%s\n' "$inhalt" > "$datei"
        git add -A; git commit --quiet -m "Eigen: $datei"
    )
}

printf '\n  %s\n  arbeitsbaum-angleichen-tests\n  %s\n' \
    '------------------------------------------------------------------' \
    '------------------------------------------------------------------'

# ===========================================================================
# Lage 1: eigener Commit, Ziel weitergelaufen, KEIN Konflikt
# ===========================================================================
baue lage1
eigener_commit lage1 meins.txt "mein Text"
ziel_weiter   lage1 ziel.txt  "Ziel-Text"
EIGEN_VORHER=$(git -C "$TMP/lage1/baum" log --format=%s -1)

bash "$WERKZEUG" "$TMP/lage1/baum" ziel >/dev/null 2>&1
RC=$?
probe "Lage 1: Rueckgabe 0" "$RC" "0"
probe "Lage 1: eigener Commit ist noch da" \
    "$(git -C "$TMP/lage1/baum" log --format=%s -1)" "$EIGEN_VORHER"
probe "Lage 1: der Zielstand ist jetzt drin" \
    "$(git -C "$TMP/lage1/baum" cat-file -e HEAD:ziel.txt 2>/dev/null && echo da)" "da"

# ===========================================================================
# Lage 2: kein eigener Commit, nur Rueckstand -> vorspulen
# ===========================================================================
baue lage2
ziel_weiter lage2 ziel.txt "Ziel-Text"

bash "$WERKZEUG" "$TMP/lage2/baum" ziel >/dev/null 2>&1
RC=$?
probe "Lage 2: Rueckgabe 0" "$RC" "0"
probe "Lage 2: vorgespult, HEAD gleich origin/ziel" \
    "$(git -C "$TMP/lage2/baum" rev-parse HEAD)" \
    "$(git -C "$TMP/lage2/baum" rev-parse origin/ziel)"

# ===========================================================================
# Lage 3: schon auf dem Stand -> nichts zu tun
# ===========================================================================
baue lage3
HEAD_VORHER=$(git -C "$TMP/lage3/baum" rev-parse HEAD)

bash "$WERKZEUG" "$TMP/lage3/baum" ziel >/dev/null 2>&1
RC=$?
probe "Lage 3: Rueckgabe 0" "$RC" "0"
probe "Lage 3: HEAD bitgenau unveraendert" \
    "$(git -C "$TMP/lage3/baum" rev-parse HEAD)" "$HEAD_VORHER"

# ===========================================================================
# Lage 4: KONFLIKT - die eigentliche Probe
# ===========================================================================
baue lage4
eigener_commit lage4 gemeinsam.txt "meine Fassung"
ziel_weiter   lage4 gemeinsam.txt "fremde Fassung"
HEAD_VORHER=$(git -C "$TMP/lage4/baum" rev-parse HEAD)
EIGEN_VORHER=$(git -C "$TMP/lage4/baum" log --format=%s -1)

AUSGABE=$(bash "$WERKZEUG" "$TMP/lage4/baum" ziel 2>&1)
RC=$?
probe "Lage 4: Rueckgabe 1 (Abbruch gemeldet)" "$RC" "1"
probe "Lage 4: HEAD BITGENAU UNVERAENDERT" \
    "$(git -C "$TMP/lage4/baum" rev-parse HEAD)" "$HEAD_VORHER"
probe "Lage 4: eigener Commit ist da" \
    "$(git -C "$TMP/lage4/baum" log --format=%s -1)" "$EIGEN_VORHER"
probe "Lage 4: mein Text steht noch in der Datei" \
    "$(git -C "$TMP/lage4/baum" show HEAD:gemeinsam.txt)" "meine Fassung"
probe "Lage 4: kein Rebase haengt in der Luft" \
    "$(test -d "$TMP/lage4/baum/.git/rebase-merge" -o -d "$TMP/lage4/baum/.git/rebase-apply" && echo haengt || echo sauber)" \
    "sauber"

printf '\n    %d von %d Proben bestanden.\n\n' "$BESTANDEN" "$((BESTANDEN + FEHLER))"
[ "$FEHLER" -eq 0 ] || exit 1
exit 0
