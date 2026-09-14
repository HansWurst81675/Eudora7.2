#!/bin/bash
# Gegenproben fuer tools/arbeitsbaum-angleichen.sh in einem Wegwerf-Repo.
# Vier Faelle in beide Richtungen. Kein Zugriff auf das echte Projekt.
set -u

W="$1"                      # Spielwiese
T="$2"                      # Pfad zu arbeitsbaum-angleichen.sh
rm -rf "$W"; mkdir -p "$W"

FEHL=0
melde() {
    if [ "$2" = "$3" ]; then echo "[ok  ] $1 (soll=$2 ist=$3)";
    else echo "[FEHL] $1 (soll=$2 ist=$3)"; FEHL=$((FEHL+1)); fi
}

# Ein "Server" und zwei Klone daraus.
git init -q --bare "$W/server.git"
git clone -q "$W/server.git" "$W/quelle" 2>/dev/null
cd "$W/quelle"
git config user.email t@t; git config user.name t
echo eins > a.txt; git add a.txt; git commit -q -m "eins"
git branch -M fix-imap_utf8
git push -q origin fix-imap_utf8

# --- Fall 1: eigener Commit, Ziel ist weitergelaufen -------------------------
git clone -q -b fix-imap_utf8 "$W/server.git" "$W/baum1" 2>/dev/null
cd "$W/baum1"; git config user.email t@t; git config user.name t
git checkout -q -b wt/pruefer
echo meins > meins.txt; git add meins.txt; git commit -q -m "MEIN COMMIT"
cd "$W/quelle"; echo zwei > b.txt; git add b.txt; git commit -q -m "zwei"; git push -q origin fix-imap_utf8
bash "$T" "$W/baum1" fix-imap_utf8 > "$W/log1.txt" 2>&1
R1=$?
HAT=$(git -C "$W/baum1" log --oneline | grep -c "MEIN COMMIT")
HAT_ZIEL=$(git -C "$W/baum1" log --oneline | grep -c "zwei")
melde "eigener Commit ueberlebt das Angleichen" 1 "$HAT"
melde "Zielstand ist danach da"                 1 "$HAT_ZIEL"
melde "Rueckgabe 0 bei sauberem Rebase"         0 "$R1"

# --- Fall 2: kein eigener Commit, nur hinterher ------------------------------
git clone -q -b fix-imap_utf8 "$W/server.git" "$W/baum2" 2>/dev/null
cd "$W/baum2"; git config user.email t@t; git config user.name t
git checkout -q -b wt/lektor
git reset -q --hard HEAD~1          # absichtlich zurueck: nur hinterher
cd "$W/quelle"; echo drei > c.txt; git add c.txt; git commit -q -m "drei"; git push -q origin fix-imap_utf8
bash "$T" "$W/baum2" fix-imap_utf8 > "$W/log2.txt" 2>&1
R2=$?
VORSPUL=$(grep -c "vorgespult" "$W/log2.txt")
melde "ohne eigenen Commit wird vorgespult" 1 "$VORSPUL"
melde "Rueckgabe 0 beim Vorspulen"          0 "$R2"

# --- Fall 3: schon auf dem Stand --------------------------------------------
bash "$T" "$W/baum2" fix-imap_utf8 > "$W/log3.txt" 2>&1
R3=$?
NICHTS=$(grep -c "nichts zu tun" "$W/log3.txt")
melde "schon auf dem Stand: nichts zu tun" 1 "$NICHTS"
melde "Rueckgabe 0, wenn nichts zu tun"    0 "$R3"

# --- Fall 4: Konflikt - es darf NICHTS verlorengehen -------------------------
git clone -q -b fix-imap_utf8 "$W/server.git" "$W/baum4" 2>/dev/null
cd "$W/baum4"; git config user.email t@t; git config user.name t
git checkout -q -b wt/chronist
echo MEINE_ZEILE > streit.txt; git add streit.txt; git commit -q -m "MEIN STREITCOMMIT"
cd "$W/quelle"; echo ANDERE_ZEILE > streit.txt; git add streit.txt; git commit -q -m "fremd"; git push -q origin fix-imap_utf8
VOR=$(git -C "$W/baum4" rev-parse HEAD)
bash "$T" "$W/baum4" fix-imap_utf8 > "$W/log4.txt" 2>&1
R4=$?
NACH=$(git -C "$W/baum4" rev-parse HEAD)
HAT4=$(git -C "$W/baum4" log --oneline | grep -c "MEIN STREITCOMMIT")
ABGE=$(grep -c "ABGEBROCHEN" "$W/log4.txt")
melde "Konflikt: eigener Commit ist noch da"      1 "$HAT4"
melde "Konflikt: HEAD unveraendert"               "$VOR" "$NACH"
melde "Konflikt: wird als Abbruch gemeldet"       1 "$ABGE"
melde "Konflikt: Rueckgabe 1"                     1 "$R4"

echo
if [ "$FEHL" -gt 0 ]; then echo "$FEHL Gegenprobe(n) fehlgeschlagen."; exit 1; fi
echo "Alle Gegenproben halten."
exit 0
