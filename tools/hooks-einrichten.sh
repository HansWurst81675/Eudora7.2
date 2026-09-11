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

# BEFUND X-8 (09.09.2026): die Haken liegen in .git/hooks und gelten damit
# fuer ALLE Arbeitsbaeume - die Werkzeuge liegen aber je Arbeitsbaum. Ein
# neues Werkzeug im Hauptbaum machte deshalb JEDEN anderen Arbeitsbaum
# committierunfaehig: perl fand die Datei nicht, der Hook gab einen Fehler
# zurueck. Gemessen an LEKTOR, der eine halbe Stunde nicht committen konnte,
# obwohl seine Arbeit fertig und alle seine Schranken gruen waren.
#
# Also: fehlt ein Werkzeug in DIESEM Arbeitsbaum, wird es uebersprungen und
# gemeldet. Fehlt es im Hauptbaum, ist das ein Fehler des Hauptbaums und
# faellt dort auf. Ein Werkzeug, das noch in keinem Zweig liegt, darf keine
# fremde Arbeit blockieren.
schranke() {
  if [ ! -f "$WURZEL/tools/$1" ]; then
    echo "pre-commit: tools/$1 gibt es in diesem Arbeitsbaum nicht - uebersprungen."
    echo "  Die Haken gelten fuer alle Arbeitsbaeume, die Werkzeuge liegen je"
    echo "  Arbeitsbaum (Befund X-8). Im Hauptbaum laeuft die Schranke."
    return 0
  fi
  perl "$WURZEL/tools/$1"
}

# 1. Schranke gegen Commits auf einen toten Zweig: schon zusammengefuehrt,
#    Gegenstueck auf dem Server geloescht, oder abgeloester HEAD.
#
#    Steht ZUERST, weil die Frage "landet dieser Commit ueberhaupt irgendwo"
#    vor jeder Frage nach seinem Inhalt kommt. Am 31.08.2026 um 09:06 ist ein
#    Commit auf einen drei Minuten zuvor zusammengefuehrten Zweig gelegt worden
#    (Befund X-5).
schranke pruefe-branch.pl || exit $?

# 2. Lehren aus dem Gedaechtnis des Assistenten ins Repo spiegeln,
#    sonst gehen sie beim naechsten Abschalten verloren.
#
#    Der Rueckgabewert MUSS ausgewertet werden. Bis zum 31.08.2026 stand hier
#    nur der Aufruf: lehren-spiegeln.pl meldete "Der Commit wurde abgebrochen",
#    der Hook lief aber weiter und gab am Ende den Wert der Schranke zurueck.
#    Die Meldung war also unwahr, und die gespiegelten Lehren gingen weiterhin
#    lautlos aus dem Commit heraus (Befund X-1, Zusatzfund; NP3-4).
schranke lehren-spiegeln.pl || exit $?

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
schranke doku-pruefen.pl || exit $?

# 5. Fensterbau absichern (Befunde E-33/E-34/E-35/E-36): keine modale Meldung
#    in der Ersatzschicht, GetButton mit Indexschranke UND Ausnahmefang, jeder
#    GetButton-Aufruf prueft sein Ergebnis auf NULL.
#    Diese Schranke gibt es seit dem 07.09.2026 - sie hing bis zum 08.09.2026
#    aber NICHT im Hook, lief also nur, wenn jemand daran dachte. Genau das
#    soll ein Hook verhindern.
schranke pruefe-fensterbau.pl || exit $?

# 6. Das Beenden absichern (Kriterium 7, Befunde E-40/E-41/E-42). Gregor am
#    08.09.2026: "haben wir ein review? und neue tests fuer die neue version?
#    wenn nicht, nachholen!" Die Behebung besteht aus drei Teilen, und jeder
#    kann durch eine spaetere, gut gemeinte Aenderung lautlos verschwinden.
schranke pruefe-beenden.pl || exit $?

# 7. Include-Waechter: ein Header, der nur TEILWEISE ersetzt wird, darf den
#    Waechter des Originals NICHT setzen. Genau daran hing E-43 - SECControlBar
#    war zweimal definiert, acht Byte auseinander, und die Folge waren E-34,
#    E-37 und E-38. Die Schranke gab es seit dem 09.09.2026, hing aber nicht
#    im Hook; gefunden von tools/lehren-schranken.pl am 09.09.2026.
schranke pruefe-waechter.pl || exit $?

# 8. Jede Lehre in Arbeitsweise/ braucht eine Schranke-Zeile. Gregor am
#    08.09.2026: "mach dir aus lessons leared alles schranken, die dann
#    greifen." Eine Lehre ohne Ausloeser wirkt nicht - und dieses Werkzeug
#    prueft auch, ob die genannte Schranke wirklich in DIESER Datei steht.
#    Es hat sich damit am 09.09.2026 selbst gefunden: es fehlte hier.
schranke lehren-schranken.pl || exit $?

# 9. Eigene Nachrichtenschleifen: WM_QUIT darf nicht verschluckt werden, und
#    es darf nicht ohne Zeitschranke gewartet werden. Aus E-51 (meine eigene
#    Ziehschleife hat die Pruefinstanz zweimal eingefroren) und E-61 (dieselbe
#    Schleife nahm WM_QUIT heraus, ohne sie zurueckzustellen). Beim ersten
#    Lauf hat die Schranke sieben weitere Stellen in Eudoras eigenem Code
#    gefunden, zwei davon mit echter Haengegefahr (E-62).
schranke pruefe-nachrichtenschleife.pl || exit $?

# 10. Keine Filteraktion loescht Post auf dem SERVER, ohne den Rueckschalter
#     FilterMayDeleteFromServer zu fragen (E-73). Gregor am 10.09.2026: "ja,
#     1 auf jeden fall! Filteraktion darf nicht mehr vom Server loeschen".
#     E-73 war zuerst nur an EINER von DREI Stellen geschlossen - der
#     IMAP-Weg und die Junk-Filteraktion liefen daran vorbei. Genau das
#     findet diese Schranke; sie ist mit "--selbsttest" in beide Richtungen
#     gegengetestet.
schranke pruefe-filter-serverloeschung.pl || exit $?

# 11. Die Grenze beim Einlesen von Filters.pce (E-68): der Aktionszaehler in
#     CFiltersDoc::Read darf nicht ueber NUM_FILT_ACTS hinauslaufen, sonst
#     schreibt die sechste Aktion einer Regel hinter m_Actions[5] und hinter
#     elf gleich grosse Nachbarfelder. Die Grenze haengt an einer Liste von
#     Schluesselwoertern - diese Schranke haelt die Liste gegen die Zweige,
#     die wirklich hochzaehlen. Auch sie hat "--selbsttest".
schranke pruefe-filter-aktionsgrenze.pl || exit $?

# 12. Abschnittsangaben der Doku gegen GetSectionID. Eudora ordnet jeden
#     INI-Schluessel allein nach seiner Nummer einem Abschnitt zu
#     (rs.cpp:89-97); ein Eintrag im falschen Abschnitt wirkt nicht, ohne
#     jede Meldung. Am 11.09.2026 hat Gregor deshalb Zeit verloren -
#     UseMyFilterWindowPosition stand in [Settings] statt in
#     [Window Position], und die Anleitung war schuld. Beim Nachpruefen
#     stand derselbe Fehler ein zweites Mal in der README: LogLevel gehoert
#     nach [Debug]. Zweimal dieselbe Fehlerklasse ist der Zeitpunkt fuer
#     eine Schranke statt einer weiteren Korrektur.
schranke pruefe-ini-abschnitte.pl || exit $?

# 13. Schranke gegen lautlose Dateischaeden (Zeilenenden, Kodierung).
schranke pruefe-bytes.pl
exit $?
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

# Dieselbe Hilfsfunktion wie im pre-commit, aus demselben Grund (Befund X-8):
# die Haken gelten fuer alle Arbeitsbaeume, die Werkzeuge liegen je
# Arbeitsbaum.
schranke() {
  if [ ! -f "$WURZEL/tools/$1" ]; then
    echo "pre-push: tools/$1 gibt es in diesem Arbeitsbaum nicht - uebersprungen."
    return 0
  fi
  perl "$WURZEL/tools/$1"
}

echo "pre-push: Doku gegen sich selbst pruefen (alle MD-Dateien)"
schranke doku-pruefen.pl || exit $?

echo "pre-push: Zeilenenden und Kodierung"
schranke pruefe-bytes.pl || exit $?

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
echo "  7. tools/pruefe-waechter.pl  setzt ein nur teilweise ersetzter Header den"
echo "                               Waechter des Originals? (E-43)"
echo "  8. tools/lehren-schranken.pl hat jede Lehre eine greifende Schranke?"
echo "  9. tools/pruefe-nachrichtenschleife.pl"
echo "                               verschluckt eine eigene Schleife WM_QUIT?"
echo "                               (E-51, E-61, E-62)"
echo " 10. tools/pruefe-filter-serverloeschung.pl"
echo "                               loescht eine Filteraktion am Rueckschalter"
echo "                               vorbei auf dem Server? (E-73)"
echo " 11. tools/pruefe-filter-aktionsgrenze.pl"
echo "                               laeuft der Aktionszaehler beim Einlesen von"
echo "                               Filters.pce ueber das Feld hinaus? (E-68)"
echo " 12. tools/pruefe-ini-abschnitte.pl"
echo "                               steht ein INI-Schluessel in der Doku im"
echo "                               Abschnitt, den GetSectionID ihm gibt?"
echo " 13. tools/pruefe-bytes.pl     sind Zeilenenden und Kodierung heil?"
echo
echo "Abweisend sind alle ausser Schritt 3 - der meldet bloss."
echo "Jeder von ihnen wertet JEDEN Rueckgabewert aus -"
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
