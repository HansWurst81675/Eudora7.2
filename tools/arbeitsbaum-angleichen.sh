#!/bin/bash
# arbeitsbaum-angleichen.sh - einen Arbeitsbaum auf den Zielzweig bringen,
# OHNE die Commits zu verlieren, die schon darin liegen.
#
# WARUM ES DAS GIBT
#
# Am 13.09.2026 um 20:24:44 und 20:25:12 Uhr - 28 Sekunden auseinander -
# gingen zwei Agentenauftraege hinaus, die beide dieselbe Zeile trugen:
#
#   ZUERST: git -C <Arbeitsbaum> fetch origin \
#           && git -C <Arbeitsbaum> reset --hard origin/fix-imap_utf8
#
# Auf wt/pruefer lagen zu diesem Zeitpunkt vier eigene Commits, darunter eine
# Behebung an der Speichersicherheit. PRUEFER hat es bemerkt und statt dessen
# cherry-gepickt. Haette er gehorcht, waere die Arbeit weg gewesen - die ich
# selbst beauftragt hatte.
#
# Der Nachfolger dieser Zeile war "merge --ff-only", und der ist am
# 14.09.2026 im ersten Einsatz gescheitert:
#
#   fatal: Not possible to fast-forward, aborting.
#
# Genau in der Lage, fuer die er geschrieben wurde: ein eigener Commit auf
# dem Zweig. Eine Anweisung, die nicht ausfuehrbar ist, ist keine Behebung -
# sie verlagert die Entscheidung nur zurueck an den Beauftragten, mitten in
# seinen ersten Arbeitsschritt.
#
# WAS DIESES WERKZEUG TUT
#
#   1. fetch
#   2. schon auf dem Stand? -> fertig
#   3. vorspulbar? -> vorspulen (merge --ff-only)
#   4. sonst rebase --autostash: die eigenen Commits bleiben, sie wandern
#      nur nach oben
#   5. Konflikt im rebase? -> rebase --abort, NICHTS geaendert, Bericht mit
#      der Liste der eigenen Commits
#
# Es gibt keinen Weg durch dieses Werkzeug, der einen Commit verwirft.
#
# Aufruf:
#   bash tools/arbeitsbaum-angleichen.sh <arbeitsbaum> <zielzweig>
#   bash tools/arbeitsbaum-angleichen.sh . fix-imap_utf8
#   bash tools/arbeitsbaum-angleichen.sh <baum> <zweig> --nur-melden
#
# Kodierung: reines ASCII, kein BOM, reine LF.

set -u

BAUM="${1:-}"
ZIEL="${2:-}"
MODUS="${3:-}"

if [ -z "$BAUM" ] || [ -z "$ZIEL" ]; then
    echo "Aufruf: bash tools/arbeitsbaum-angleichen.sh <arbeitsbaum> <zielzweig>"
    exit 2
fi

if ! git -C "$BAUM" rev-parse --git-dir >/dev/null 2>&1; then
    echo "arbeitsbaum-angleichen: '$BAUM' ist kein Arbeitsbaum."
    exit 2
fi

ZWEIG=$(git -C "$BAUM" rev-parse --abbrev-ref HEAD 2>/dev/null)
echo "arbeitsbaum-angleichen: $BAUM (Zweig $ZWEIG) auf origin/$ZIEL"

if ! git -C "$BAUM" fetch origin >/dev/null 2>&1; then
    echo "  fetch fehlgeschlagen - nichts geaendert."
    exit 1
fi

if ! git -C "$BAUM" rev-parse --verify --quiet "origin/$ZIEL" >/dev/null; then
    echo "  origin/$ZIEL gibt es nicht - nichts geaendert."
    exit 1
fi

VORAUS=$(git -C "$BAUM" rev-list --count "origin/$ZIEL..HEAD")
ZURUECK=$(git -C "$BAUM" rev-list --count "HEAD..origin/$ZIEL")
echo "  eigene Commits: $VORAUS    vom Ziel fehlen: $ZURUECK"

if [ "$VORAUS" -gt 0 ]; then
    echo "  diese Commits liegen nur hier und duerfen nicht verlorengehen:"
    git -C "$BAUM" log --oneline "origin/$ZIEL..HEAD" | sed 's/^/      /'
fi

if [ "$ZURUECK" -eq 0 ]; then
    echo "  nichts zu tun - der Zielstand ist schon enthalten."
    exit 0
fi

if [ "$MODUS" = "--nur-melden" ]; then
    echo "  --nur-melden: es wurde nichts geaendert."
    exit 0
fi

SCHMUTZ=$(git -C "$BAUM" status --porcelain --untracked-files=no | wc -l)

if [ "$VORAUS" -eq 0 ]; then
    if git -C "$BAUM" merge --ff-only "origin/$ZIEL" >/dev/null 2>&1; then
        echo "  vorgespult auf origin/$ZIEL."
        exit 0
    fi
    echo "  vorspulen ging nicht, obwohl kein eigener Commit gezaehlt wurde."
    echo "  Nichts geaendert - das ist ein Fall fuer eine Hand."
    exit 1
fi

echo "  nicht vorspulbar - rebase, damit die $VORAUS eigenen Commits bleiben."
if [ "$SCHMUTZ" -gt 0 ]; then
    echo "  ($SCHMUTZ geaenderte Dateien werden mit --autostash beiseitegelegt)"
fi

if git -C "$BAUM" rebase --autostash "origin/$ZIEL" >/dev/null 2>&1; then
    NEU=$(git -C "$BAUM" rev-list --count "origin/$ZIEL..HEAD")
    echo "  rebase durch. eigene Commits vorher $VORAUS, nachher $NEU."
    if [ "$NEU" -lt "$VORAUS" ]; then
        echo "  ACHTUNG: es sind weniger geworden. Nachsehen, bevor weitergearbeitet wird."
        exit 1
    fi
    exit 0
fi

git -C "$BAUM" rebase --abort >/dev/null 2>&1
echo "  rebase hat Konflikte - ABGEBROCHEN, es wurde nichts geaendert."
echo
echo "  Der Arbeitsbaum steht unveraendert da, mit allen $VORAUS eigenen Commits."
echo "  Von Hand aufloesen, zum Beispiel:"
echo "      git -C $BAUM rebase origin/$ZIEL     # und die Konflikte klaeren"
echo "      git -C $BAUM merge origin/$ZIEL      # oder zusammenfuehren"
echo "  Was NICHT geht: reset --hard. Das wirft die $VORAUS Commits weg."
exit 1
