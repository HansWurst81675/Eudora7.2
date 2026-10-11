#!/bin/sh
#
# arbeitsbaum-angleichen.sh - den Arbeitsbaum eines Agenten auf den Zielstand
# bringen, OHNE je einen Commit zu verwerfen.
#
#   bash tools/arbeitsbaum-angleichen.sh <arbeitsbaum> <zielzweig>
#
# Beispiel:
#   bash tools/arbeitsbaum-angleichen.sh ../Eudora7.2-wt-lektor fix-imap_utf8
#
# -----------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# -----------------------------------------------------------------------------
#
# Am 13.09.2026 stand in einem Agentenauftrag als erster Schritt ein
# "git reset --hard". Der Beauftragte hat es bemerkt und stattdessen
# cherry-gepickt - sonst waeren seine eigenen Commits weg gewesen.
#
# Daraufhin wurde der Auftragstext auf "merge --ff-only, falls das nicht
# vorspult: merge normal, aber NIEMALS reset --hard" geaendert. Am 14.09.2026
# bin ich als erster damit losgelaufen und bekam
#
#   fatal: Not possible to fast-forward, aborting.
#
# und zwar genau in der Lage, fuer die der Satz geschrieben war: ein eigener
# Commit auf dem Zweig, 19 Commits Rueckstand. Eine vorsichtige Anweisung tut
# in der Normallage dasselbe und bricht in der Ausnahmelage ab - der Schaden
# ist vermieden, das Problem verschoben. Der Beauftragte steht mit einem
# abgebrochenen Befehl da, im ersten Arbeitsschritt, ohne Kontext.
#
# Ein Befehl kennt nur einen Fall. Ein Werkzeug kennt alle.
#
# Lehre: Arbeitsweise/auftrag-darf-nicht-loeschen.md
# Gegenprobe: tools/arbeitsbaum-angleichen-tests.sh (11 Proben im Wegwerf-Repo)
#
# -----------------------------------------------------------------------------
# WAS ES TUT
# -----------------------------------------------------------------------------
#
#   1. holen
#   2. die EIGENEN Commits beim Namen nennen, damit sichtbar ist, was auf dem
#      Spiel steht
#   3. schon auf dem Stand          -> nichts zu tun,           Rueckgabe 0
#   4. vorspulbar                   -> merge --ff-only,         Rueckgabe 0
#   5. eigene Commits, kein Konflikt-> rebase --autostash,      Rueckgabe 0
#   6. Konflikt                     -> rebase --abort, HEAD bitgenau
#                                      unveraendert, gemeldet,  Rueckgabe 1
#
# Es gibt keinen Weg hindurch, der einen Commit verwirft.

set -u

BAUM="${1:-}"
ZIEL="${2:-}"
FERN="${3:-origin}"

if [ -z "$BAUM" ] || [ -z "$ZIEL" ]; then
    echo "Aufruf: bash tools/arbeitsbaum-angleichen.sh <arbeitsbaum> <zielzweig> [fernname]" >&2
    exit 2
fi

if [ ! -d "$BAUM" ]; then
    echo "FEHLER: '$BAUM' ist kein Verzeichnis." >&2
    exit 2
fi

G="git -C $BAUM"

if ! $G rev-parse --git-dir >/dev/null 2>&1; then
    echo "FEHLER: '$BAUM' ist kein git-Arbeitsbaum." >&2
    exit 2
fi

ZWEIG=$($G rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ "$ZWEIG" = "HEAD" ]; then
    echo "FEHLER: abgeloester HEAD in '$BAUM'. Von Hand klaeren -" >&2
    echo "        dieses Werkzeug fasst einen abgeloesten HEAD nicht an." >&2
    exit 2
fi

echo "  ------------------------------------------------------------"
echo "  arbeitsbaum-angleichen"
echo "  ------------------------------------------------------------"
echo "    Arbeitsbaum   $BAUM"
echo "    Zweig         $ZWEIG"
echo "    Ziel          $FERN/$ZIEL"

VORHER=$($G rev-parse HEAD)

# --- 1. holen ---------------------------------------------------------------
if ! $G fetch "$FERN" >/dev/null 2>&1; then
    echo
    echo "  FEHLER: '$G fetch $FERN' ist fehlgeschlagen." >&2
    exit 2
fi

if ! $G rev-parse --verify --quiet "$FERN/$ZIEL" >/dev/null 2>&1; then
    echo
    echo "  FEHLER: $FERN/$ZIEL gibt es nicht." >&2
    exit 2
fi

NACHHER=$($G rev-parse "$FERN/$ZIEL")

# --- 2. die eigenen Commits beim Namen nennen -------------------------------
EIGEN=$($G log --oneline "$FERN/$ZIEL..HEAD" 2>/dev/null)
ANZAHL_EIGEN=$(printf '%s' "$EIGEN" | grep -c . || true)
RUECKSTAND=$($G rev-list --count "HEAD..$FERN/$ZIEL" 2>/dev/null || echo 0)

echo "    eigene Commits  $ANZAHL_EIGEN"
echo "    Rueckstand      $RUECKSTAND"

if [ "$ANZAHL_EIGEN" -gt 0 ]; then
    echo
    echo "    Was auf dem Spiel steht:"
    printf '%s\n' "$EIGEN" | sed 's/^/      /'
fi
echo

# --- 3. schon auf dem Stand -------------------------------------------------
if [ "$RUECKSTAND" -eq 0 ]; then
    echo "  Nichts zu tun - $FERN/$ZIEL ist bereits enthalten."
    exit 0
fi

# --- 4. vorspulbar ----------------------------------------------------------
if [ "$ANZAHL_EIGEN" -eq 0 ]; then
    if $G merge --ff-only "$FERN/$ZIEL" >/dev/null 2>&1; then
        echo "  Vorgespult auf $FERN/$ZIEL ($RUECKSTAND Commit(s))."
        exit 0
    fi
    echo "  FEHLER: kein eigener Commit, und trotzdem nicht vorspulbar." >&2
    echo "          Das sollte nicht vorkommen - von Hand ansehen." >&2
    exit 2
fi

# --- 5./6. eigene Commits obendrauf setzen ----------------------------------
#
# --autostash, damit auch ein nicht gespeicherter Arbeitsstand nicht im Weg
# steht. Bei Konflikt wird abgebrochen und NICHTS geaendert - das ist die
# eigentliche Probe dieses Werkzeugs (siehe gegenprobe-umdrehen: nicht
# pruefen, ob das gewuenschte Ergebnis erscheint, sondern ob der Stand
# unangetastet bleibt, wenn es schiefgeht).
if $G rebase --autostash "$FERN/$ZIEL" >/dev/null 2>&1; then
    echo "  $ANZAHL_EIGEN eigene(r) Commit(s) auf $FERN/$ZIEL gesetzt."
    echo "  Alle sind noch da:"
    $G log --oneline "$FERN/$ZIEL..HEAD" | sed 's/^/      /'
    exit 0
fi

# Konflikt: zurueckdrehen, damit der Baum bitgenau so bleibt wie vorher.
$G rebase --abort >/dev/null 2>&1
JETZT=$($G rev-parse HEAD)

echo "  ABGEBROCHEN - Konflikt zwischen deinen Commits und $FERN/$ZIEL."
echo
if [ "$JETZT" = "$VORHER" ]; then
    echo "    Nichts wurde geaendert. HEAD steht unveraendert auf $VORHER."
else
    echo "    ACHTUNG: HEAD steht jetzt auf $JETZT statt $VORHER." >&2
    echo "    Das darf nicht passieren - bitte melden." >&2
fi
echo "    Deine $ANZAHL_EIGEN Commit(s) sind unangetastet."
echo
echo "  Das ist kein Fehler des Werkzeugs, sondern eine Entscheidung, die"
echo "  ein Mensch treffen muss: dieselbe Datei ist auf beiden Seiten"
echo "  geaendert worden. Ueblich ist"
echo
echo "      git -C $BAUM merge $FERN/$ZIEL"
echo
echo "  und die Konflikte einzeln aufloesen. Ein Merge verwirft nichts."
exit 1
