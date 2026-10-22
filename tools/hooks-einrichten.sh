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
  perl "$WURZEL/tools/$1" || { rc=$?; echo "  -> alle Maengel auf einmal: perl tools/commit-bereit.pl (-push fuer den pre-push)"; return $rc; }
}

# 1. Schranke gegen Commits auf einen toten Zweig: schon zusammengefuehrt,
#    Gegenstueck auf dem Server geloescht, oder abgeloester HEAD.
#
#    Steht ZUERST, weil die Frage "landet dieser Commit ueberhaupt irgendwo"
#    vor jeder Frage nach seinem Inhalt kommt. Am 31.08.2026 um 09:06 ist ein
#    Commit auf einen drei Minuten zuvor zusammengefuehrten Zweig gelegt worden
#    (Befund X-5).
schranke pruefe-branch.pl || exit $?

# 1b. Rollenstand MELDEN - nicht abweisen, deshalb steht hier kein "|| exit".
#
#     Am 13.09.2026 um 18:57 fragte Gregor: "maschst du wieder alles allein?
#     magst du die anderen nicht so?" Gemessen im Transkript: die drei Rollen
#     wurden um 18:59, 18:59 und 19:00 gestartet - also NACH seiner Frage -
#     und tools/rollen-faellig.pl lief zum ersten Mal um 19:05, acht Minuten
#     danach. In den 43 Minuten davor (18:14 bis 18:57, 84 Werkzeugaufrufe)
#     ist die Schranke kein einziges Mal gelaufen.
#
#     Der Grund war der Zeitpunkt, nicht das Werkzeug: rollen-faellig.pl hing
#     bis dahin NUR in paket-bauen.ps1, also am allerletzten Schritt. Da ist
#     die Arbeit getan - eine Rolle haette sie aber BEGLEITEN sollen. Der
#     erste Commit eines Arbeitsblocks kommt frueh; das ist der richtige
#     Moment, um den Rollenstand zu sehen.
#
#     Bewusst nur meldend: eine faellige Rolle darf das Committen nicht
#     blockieren, sonst wird die Schranke umgangen und faengt dann auch
#     nichts mehr. Abweisend bleibt sie beim Paketbau.
if [ -f "$WURZEL/tools/rollen-faellig.pl" ]; then
  perl "$WURZEL/tools/rollen-faellig.pl" 2>/dev/null | grep -E "FAELLIG|ist faellig" | head -4
fi

# 1c. Vorgemerkte Quellen, die KEIN Projekt der Mappe baut, MELDEN - nicht
#     abweisen: eine Aenderung an Fremdquellen kann gewollt sein (Lesehilfe,
#     Spurmarke fuer spaeter). Am 13.10.2026 sass die Behebung E-112 F1 in
#     PaigeDLL/PGSOURCE/PGEMBED.C; Paige32.dll wird nicht aus dem Quelltext
#     gebaut, und das zeigte erst die Messung am laufenden Programm nach
#     einem vollen Bau (Arbeitsweise/quelle-muss-im-bau-stehen.md).
if [ -f "$WURZEL/tools/wer-baut.pl" ]; then
  perl "$WURZEL/tools/wer-baut.pl" --staged 2>/dev/null | sed 's/^/pre-commit: /'
fi

# 1d. Neue Suche ueber eine Nachrichtenkennung im Eudora-Quelltext MELDEN -
#     nicht abweisen. In E-121 traf dieselbe Annahme dreimal ("die Kennung
#     findet DIE Nachricht"): Kennung 0 aus Out (PRUEFER-28 P1), alte UID 13 =
#     fremde UID 13 im Ziel (1.0.95), N1 auf der Quellseite. Die Zeile fuer
#     1.0.95 stand schon in 8008f96e (1.0.91). Von 300 Commits unter Eudora71/
#     haetten 6 angeschlagen, alle zu E-121
#     (Arbeitsweise/funktion-bringt-ihre-vorbedingung-mit.md, Nachtrag 15.10.2026).
#     Gegenprobe: --selbsttest, 8 Faelle; --commit 8008f96e meldet.
if [ -f "$WURZEL/tools/pruefe-kennung-suche.pl" ]; then
  perl "$WURZEL/tools/pruefe-kennung-suche.pl" 2>/dev/null | sed 's/^/pre-commit: /'
fi

# 1e. Verweise nach aussen, die heute noch ins Leere zeigen, MELDEN - nicht
#     abweisen. Ein Entwurf darf einen Verweis tragen, dessen Ziel noch auf
#     dem Zweig liegt; abzuschicken ist er erst nach dem Merge. Eine
#     Abweisung hier wuerde das normale Arbeiten blockieren und die
#     Schranke damit entwaffnen (Arbeitsweise/schranke-gehoert-in-den-haken.md).
#
#     Am 21.10.2026 um 21:33 ging ein Beitrag an Issue 102 hinaus, der auf
#     blob/main/MELDUNGEN-VON-AUSSEN.md verwies. Die Datei kam erst um
#     21:36:59 mit dem Merge von PR 128 auf main an - drei Minuten 404,
#     gefunden hat es Gregor. Es war das ZWEITE Mal; dieselbe Falle steht in
#     Releases/ISSUE-102-ANTWORT.md Zeile 14 schon aufgeschrieben
#     (Arbeitsweise/verweis-erst-nach-dem-merge.md).
#
#     Der Commit mit dem Entwurf lief um 21:25, acht Minuten vor dem
#     Abschicken - dieser Hinweis waere also rechtzeitig gekommen.
#     Gegenprobe: --selbsttest, 16 Faelle; --stand 80b472aa (main um 21:33)
#     weist Releases/ISSUE-102-ABSCHLUSS.md ab, derselbe Lauf gegen
#     origin/main von heute nicht.
if [ -f "$WURZEL/tools/pruefe-aussenverweise.pl" ]; then
  perl "$WURZEL/tools/pruefe-aussenverweise.pl" --hinweis 2>/dev/null \
    | grep -E "MANGEL|  -> " | head -6 | sed 's/^/pre-commit: /'
fi

# 1b. Steht jede Markdown-Tabellenzeile auf EINER Zeile?
#
#     Abweisend, nicht nur meldend: der Fall ist eindeutig, die Gegenprobe
#     laeuft in beide Richtungen (--selbsttest, 18 Faelle, davon 13 die
#     durchgehen MUESSEN), und die Behebung ist zwei Zeilen zusammenziehen.
#
#     Am 22.10.2026 meldete Gregor zu WEITERMACHEN.md auf GitHub: "hat ein
#     darstellungsproblem: der text ist links, nicht rechts." Zwei
#     Tabellenzeilen waren ueber zwei physische Zeilen gebrochen (9/10 und
#     46/47). GFM liest eine Textzeile ohne Leerzeile hinter einer
#     Tabellenzeile als EIGENE Zeile ("lazy continuation"); weil ihr das
#     fuehrende "|" fehlt, faellt der Text in Spalte 1. Der Leser bekommt
#     Zeilen ohne Kennung und Saetze, die mittendrin abbrechen.
#
#     Gefunden hat es Gregor am gerenderten Dokument, nicht ich am Quelltext
#     - eine .md sieht im Editor heil aus (Arbeitsweise/anzeige-ist-kein-zustand.md).
schranke pruefe-tabellenzeilen.pl || exit $?

# 1c. Steht unter "Was es nicht kann" nur, was HEUTE fehlt?
#
#     Gregor am 22.10.2026: "das ist doch bullshit! hier steht unter der
#     ueberschrift 'was es nicht kann', entsteht also der eindruck, all das
#     kann unser eudora nicht!" - gemeint waren "Das neueste Release ist
#     v1.0.120" und "Beim Antworten und Weiterleiten fehlten Bilder ...
#     (E-110, behoben)".
#
#     Gemessen: 224 Zeilen, davon 37 ueber Behebungen, Bestaetigungen und
#     Veroeffentlichungen - samt vollstaendiger Fassungsgeschichte. Nach dem
#     Aufraeumen 86 Zeilen, 11 Punkte, alle heute zutreffend.
#
#     Gegenprobe: --selbsttest, 10 Faelle (6 muessen durchgehen); dazu die
#     alte Fassung des Abschnitts, die an genau den beiden von Gregor
#     genannten Zeilen abweist.
schranke pruefe-nicht-kann.pl || exit $?

# 2. Lehren aus dem Gedaechtnis des Assistenten ins Repo spiegeln,
#    sonst gehen sie beim naechsten Abschalten verloren.
#
#    Der Rueckgabewert MUSS ausgewertet werden. Bis zum 31.08.2026 stand hier
#    nur der Aufruf: lehren-spiegeln.pl meldete "Der Commit wurde abgebrochen",
#    der Hook lief aber weiter und gab am Ende den Wert der Schranke zurueck.
#    Die Meldung war also unwahr, und die gespiegelten Lehren gingen weiterhin
#    lautlos aus dem Commit heraus (Befund X-1, Zusatzfund; NP3-4).
schranke lehren-spiegeln.pl || exit $?

# 3. Release gegen den Quellstand pruefen. WEIST SEIT DEM 18.09.2026 AB.
#
#    Hier stand bis dahin:
#
#        perl release-pruefen.pl >/dev/null 2>&1 || perl release-pruefen.pl || true
#
#    Das "|| true" hat die Schranke vollstaendig entwaffnet: sie konnte auch
#    ein echtes Missverhaeltnis nicht mehr abweisen. Gregor am 18.09.2026:
#    "repariere deine schranken, so dass VOR dem commit und merge alles auf
#    github vorhanden ist."
#
#    Warum das "|| true" ueberhaupt dastand, ist nachvollziehbar und war der
#    eigentliche Mangel: das Werkzeug gab auch fuer einen blossen HINWEIS
#    (QCSSL-Quellen neuer als die ausgelieferte DLL) den Wert 1 zurueck und war
#    deshalb dauernd rot. Eine Schranke, die zu oft umsonst warnt, wird
#    abgeschaltet - genau das ist hier im Haken passiert
#    (Arbeitsweise/schranke-gegentesten.md).
#
#    Behoben wurde deshalb die URSACHE, nicht der Haken: release-pruefen.pl
#    trennt seit dem 18.09.2026 die Rueckgabewerte.
#      0 = stimmt          1 = MISSVERHAELTNIS, weist ab      3 = nur Hinweis
#    Gegenprobe am 18.09.2026 gemessen: der jetzige Baum liefert 3 (Hinweis,
#    laeuft durch); mit kuenstlich falscher Pruefsumme liefert er 1 (abgewiesen).
if [ -f "$WURZEL/tools/release-pruefen.pl" ]; then
  perl "$WURZEL/tools/release-pruefen.pl"
  rc=$?
  if [ "$rc" != 0 ] && [ "$rc" != 3 ]; then exit $rc; fi
fi

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
schranke lehren-uebersicht.pl || exit $?

# 8b. Jede Rolle, die eine Schranke kennt, muss in AGENTEN.md nachschlagbar
#     sein. Am 13.09.2026 um 19:33 beauftragte Gregor "den lektor" mit den
#     lessons learned - zustaendig ist CHRONIST. Er berichtigte es 59 Sekunden
#     spaeter selbst. Beim Nachmessen: AGENTEN.md enthielt das Wort CHRONIST
#     KEIN EINZIGES MAL; die Rolle war nur im Quelltext von rollen-faellig.pl
#     definiert. Weder Gregor noch ich konnten sie nachschlagen - das ist eine
#     fehlende Quelle, keine Unaufmerksamkeit.
#     Gegenprobe: --selbsttest, vier Faelle.
schranke pruefe-rollen-doku.pl || exit $?

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

# 13. Ziehen am schwebenden Fenster. CalcDynamicLayout bekommt beim Ziehen
#     LM_LENGTHY und nLength als Hoehe, beim ABSCHLIESSENDEN Aufruf aber
#     LM_COMMIT ohne LM_LENGTHY und nLength als BREITE. Der alte nackte
#     else-Zweig fing genau den ab und warf die gezogene Hoehe weg (E-76,
#     Gregor am 10.09.2026: "filter fenster laesst sich nicht nach unten
#     vergroessern, nur zur seite"). Gegenprobe:
#     pruefe-fenster-ziehen-tests.pl, 14 Faelle in beide Richtungen.
schranke pruefe-fenster-ziehen.pl || exit $?

# 14. Leistengroessen paarig. Was GroessenSichern schreibt, muss
#     GroessenLaden lesen - und beide muessen auf dem Weg liegen, den Eudora
#     wirklich geht. Zweimal dieselbe Fehlerklasse: bei E-70 fehlte das
#     Lesen (der Aufruf sass in einer Funktion, ueber der "Eudora ruft diese
#     Fassung nie auf" steht), bei E-84 das Schreiben (der erste Anlauf sass
#     in SECControlBarInfo::SaveState, die beim Speichern nicht durchlaufen
#     wird - er uebersetzte sauber und bewirkte nichts). Gegenprobe:
#     pruefe-leistengroessen-paar-tests.pl, 17 Faelle in beide Richtungen.
schranke pruefe-leistengroessen-paar.pl || exit $?

# 14b. Ein neues "behoben" muss sagen, WORAN es belegt ist. Gregor am
#      14.09.2026: "wenn eine aufgabe erledigt ist, dann sollte diese auch
#      als solche gekennzeichnet werden." Die Gegenrichtung ist die teurere:
#      am 13.09.2026 stand in BEFUNDE.md "Alle drei Maengel behoben in
#      7.2.0.51", waehrend Paket 1.0.51 unterwegs war, das den Fehler nicht
#      behob. Geprueft wird NUR der Zuwachs an BEFUNDE.md - im Bestand
#      stehen Dutzende alter Zeilen ohne Beleg, und eine Schranke, die
#      siebzigmal meckert, wird abgeschaltet.
#      Gegenprobe: --selbsttest, zehn Faelle; dazu am echten Stand
#      48c1ee2 abgewiesen, 26718ef und 34eba35 durch.
schranke pruefe-behoben-belegt.pl || exit $?

# 14c. Ein zitierter Oberflaechentext ist eine Behauptung des Programms ueber
#      sich selbst, kein Messwert. E-83 stand drei Tage unter der Ueberschrift
#      "wird nie gestartet" - gefolgert aus dem Wort "waiting". Die Aufgabe
#      wartete nie, sie war fertig; der Text kommt aus Register()
#      (QCTaskManager.cpp:191) und wurde fuer sie nie ueberschrieben. Alle
#      vier Verdaechte lagen daraufhin im Startweg, keiner dort, wo der
#      Fehler war. Auch hier nur der Zuwachs: im Bestand stehen vier alte
#      Zitate ohne Herkunft (E-16, E-33, E-34, E-47).
#      Gegenprobe: --selbsttest, sieben Faelle, darunter die beiden
#      gemessenen Fehlalarme (deutsches Zitat, Quelltextkommentar).
schranke pruefe-anzeigetext.pl || exit $?

# 14d. Kein Windows-Pfad ohne Rueckstrich im Zuwachs einer .md. Bis zum
#      14.10.2026 achtzehn Faelle in Arbeitsweise/text-nicht-durch-
#      schichten-schicken.md (C:TempAN5, C:Temp94-nachher, C:Temp105):
#      ein Pfad in einem Perl-String in doppelten Anfuehrungszeichen
#      verliert \T und \E. Die Lehre trug die Pruefung seit dem 13.10.2026
#      als "Offen". Nur der Zuwachs; Arbeitsweise/ und die Rollenberichte
#      sind ausgenommen, weil sie den Fehler zitieren.
#      Gegenprobe: --selbsttest, 16 Faelle; dazu die echte Zeile aus PAKETE.md
#      vom 14.10.2026 06:10 in einem Wegwerf-Repo (weist ab) und berichtigt
#      (laesst durch).
schranke pruefe-rueckstrich.pl || exit $?

# 14e. Kein Paket an Gregor ohne Nachstellung am eigenen Pruefstand. E-121
#      ging am 15.10.2026 durch sechs Pakete; fuenf trugen in PAKETE.md eine
#      Zeile "Gemessen" ohne roten alten Stand ("am Pruefstand nicht
#      gemessen", "summen=1" ohne Gegenprobe) und fielen alle bei Gregor
#      durch. Das erste mit "an 1.0.95 nachgestellt, an 1.0.96 gruen" hat er
#      beim ersten Anlauf bestaetigt. Nur der Zuwachs, nur Abschnitte mit
#      bereitgestelltem Testverzeichnis; Ausnahme "ohne Nachstellung" plus
#      Gregors woertliches Ja (Arbeitsweise/erst-nachstellen-dann-ausliefern.md).
#      Gegenprobe: --selbsttest, 13 Faelle; die fuenf echten Commits
#      8008f96e, 83337910, 7b95567a, 3731980c, 31afea0d weisen ab, 9578a1bf
#      (1.0.96) und die zehn Pakete davor lassen durch.
schranke pruefe-nachgestellt.pl || exit $?

# 14f. Keine Pruefung, die etwas Ausfuehrbares auf die Platte legt. GEMESSEN
#      am 20.10.2026 um 20:45:19: Defender zog die von
#      pruefe-behoben-ausgeliefert.pl ausgepackte Eudora.exe unter
#      Releases/.pruefe-behoben-1.0.113/ ein - ausgeloest von perl.exe, also
#      von der Schranke selbst -, und die Schranke meldete danach "Paket
#      1.0.113: in der Eudora.exe steht keine Fassung 7.2.0.NN": eine falsche
#      Aussage ueber ein richtiges Paket (E-124). Geprueft werden nur
#      tools/pruefe-*.pl/.ps1 und tools/*-pruefen.pl/.ps1; Bauwerkzeuge
#      duerfen auspacken. Ausnahme mit Begruendung: eine Zeile
#      "auspacken-erlaubt: <Grund>" im Werkzeug
#      (Arbeitsweise/pruefung-legt-nichts-ab.md).
#      Gegenprobe: --selbsttest, 14 Faelle in beide Richtungen; der echte
#      Stand 1d081b27^ von pruefe-behoben-ausgeliefert.pl weist ab, der
#      heutige Bestand (56 Pruefwerkzeuge) laesst durch.
schranke pruefe-auspacken.pl || exit $?

# 14g. Jeder eigene Eudora-Start gehoert ins Protokoll. GEMESSEN am
#      21.10.2026: 15 Pruefstaende unter C:\Temp\E134-*, 15 eigene Starts
#      zwischen 11:06 und 12:07, und NULL Zeilen in tools/TESTLAEUFE.md mit
#      diesem Datum - die letzte stammte vom 20.10. um 19:45:51. Gestartet
#      wurde mit eigenen PowerShell-Aufrufen; die Freigabe-Schranke in
#      testlauf.ps1 wurde nicht umgangen, sondern gar nicht erst aufgerufen,
#      und eine stumme Pruefung sieht aus wie eine bestandene. Gregor hat die
#      Fenster gesehen und gefragt. Geprueft wird nur HEUTE und nur C:\Temp;
#      gezaehlt wird nur, was nach der Eudora.exe des Pruefstands liegt,
#      sonst zaehlt die mitkopierte Startzeile aus Gregors Verzeichnis
#      fuenfzehnmal mit (Arbeitsweise/jeder-start-ins-protokoll.md).
#      Gegenprobe: --selbsttest, 11 Faelle in beide Richtungen; am echten
#      Bestand weist --tag 2026-10-21 ab (15 Starts, 0 Zeilen), und die
#      Messtage 2026-10-12, -13, -14, -17 sowie 2026-09-15 und -17 laufen
#      durch (0 ohne Zeile).
schranke pruefe-startwege.pl || exit $?

# 14h. "Originalfehler" ist eine Aussage ueber ein VERHALTEN. Am 21.10.2026
#      stand E-134 (Adressbuch nimmt den Kurznamen nicht an) als
#      "Originalverhalten" da; belegt war nur, dass die //FORNOW-Kommentare
#      in nickview.cpp aus dem initial commit stammen - eine Aussage ueber
#      den Kommentar (1315 Vorkommen in 44 Dateien). Gregor: "was ist denn
#      hier neu? in der alten hermes implementierung hat es ja
#      funktioniert." Danach gemessen: Quelltext original (je ein Commit,
#      der initial commit), Verhalten veraendert. Geprueft wird nur der
#      Zuwachs an BEFUNDE.md; als Beleg zaehlt eine aeltere eigene Fassung
#      mit demselben Bild, Hermes/7.1, Gregor am alten Programm - oder die
#      Einschraenkung "Quelltext original, Verhalten nicht gemessen"
#      (Arbeitsweise/original-ist-eine-messung.md).
#      Gegenprobe: --selbsttest, 14 Faelle in beide Richtungen; am Bestand
#      --datei BEFUNDE.md: 199 Befundzeilen, 6 Original-Urteile, 4 mit
#      Beleg (E-118, E-121, E-122, E-134) laufen durch, 2 ohne (E-133,
#      E-117) weisen ab.
schranke pruefe-original-belegt.pl || exit $?

# 14i. Ein Messskript erkennt sein Ziel an einem Merkmal DER SACHE, nicht
#      an einer Eigenschaft, die viele teilen. Am 21.10.2026 suchte der
#      erste Messlauf zu E-135 die Vervollstaendigungsbox nach ihrer
#      Fensterklasse "#32770" - der Klasse JEDES Windows-Dialogs - und fand
#      den Kontenassistenten: 453x341, ueber alle sechs Schritte
#      unveraendert. Sechs saubere Zeilen, das Bild eines behobenen
#      Fehlers, gemessen an einer Fassung mit dem Fehler. Erst die Suche
#      nach einem Dialog, der eine SysListView32 enthaelt, traf die Box.
#      Geflaggt wird eine Auswahl von GENAU EINEM Fenster nach einer
#      mehrdeutigen Klasse ohne unterscheidendes Merkmal; Sichtbarkeit
#      zaehlt nicht, ueber ALLE Kandidaten laufen ist erlaubt
#      (Arbeitsweise/messziel-am-merkmal-erkennen.md).
#      Gegenprobe: --selbsttest, 12 Faelle in beide Richtungen; am Bestand
#      26 Dateien, 0 Treffer; gegen die in messen-e135.ps1
#      wiederhergestellte historische Fehlzeile Rueckgabe 1.
schranke pruefe-messziel.pl || exit $?

# ---------------------------------------------------------------------------
# 16. bis 19.: DIE BUCHFUEHRUNG UEBER DAS RELEASE.
#
#     Gregor am 18.09.2026:
#
#       "dein commit gestern fuer 0.72 war unvollstaendig. nachdem ich gemerged
#        habe, wolltest du noch daten nachschieben. [...] repariere deine
#        schranken, so dass VOR dem commit und merge alles auf github vorhanden
#        ist."
#
#     Der Anlassfall, nachgemessen: v1.0.72 war am 17.09.2026 um 20:07 UTC
#     drauSSen (Merge 8da72c8). Danach nannten FUENF fuehrende Dokumente
#     weiterhin v1.0.64 als neuestes Release, und der berichtigende Commit kam
#     ERST NACH dem Merge. Auf main stand eine Luege.
#
#     WARUM KEINE SCHRANKE DAS FING - gemessen am 18.09.2026 (PRUEFER-17):
#     die fuenf Werkzeuge, die es haetten fangen koennen, standen in KEINEM
#     der beiden Haken. Sie liefen nur, wenn jemand daran dachte. Das ist
#     derselbe Fehler, den tools/lehren-schranken.pl am 09.09.2026 schon
#     einmal bei pruefe-fensterbau.pl gefunden hat: ein Werkzeug ohne
#     Aufrufstelle ist Text (Arbeitsweise/werkzeug-vor-eigenbau.md).
#
#     Laufzeiten am 18.09.2026 gemessen, damit der Haken nicht laestig wird
#     (eine laestige Schranke wird umgangen): 352 ms, 233 ms, 134 ms, 513 ms.
#     Zusammen unter 1,3 Sekunden - das gehoert in den pre-commit.
# ---------------------------------------------------------------------------

# 16. Was die Dokumente ueber das neueste Release sagen, gegen den Tag-Bestand.
#     Die eine Frage, die von auSSen kommt: WAS IST WIRKLICH VEROEFFENTLICHT?
#     doku-pruefen.pl haelt die Dokumente gegeneinander - als alle fuenf
#     einhellig v1.0.64 sagten, war das widerspruchsfrei und falsch. Einigkeit
#     ist kein Wahrheitsbeweis.
#     Gegenprobe: --tests, 19 Faelle; dazu am echten Stand 8da72c8 gefahren
#     (weist mit 7 Maengeln ab) und am Arbeitsbaum vom 18.09.2026.
schranke pruefe-release-buchfuehrung.pl || exit $?

# 17. Steht jeder Befund der neuesten Fassung in allen fuehrenden Dokumenten?
#     Diese Schranke war beim ersten echten Lauf BLIND (E-109): sie holte
#     ihren Umfang nur aus den UEBERSCHRIFTEN des CHANGELOG-Abschnitts, und
#     7.2.0.70 nennt seine vier Befunde nur im Fliesstext - Umfang 0, Meldung
#     "nichts zu pruefen", Rueckgabe 0. Seit dem 18.09.2026 kommt der Umfang
#     zusaetzlich aus BEFUNDE.md, und Umfang 0 weist ab statt gruen zu melden.
schranke pruefe-befund-verbreitung.pl || exit $?

# 18. Ist die Fassung ueberhaupt beschrieben - CHANGELOG-Abschnitt, "Noch
#     offen", VERSION und Version.h im Takt?
schranke pruefe-doku-takt.pl || exit $?

# 19. Hinkt ein Stand-Kopf hinterher, und nennt jede Rollenhistorie ihre
#     Berichte? Die zweite Frage ist seit dem 18.09.2026 dabei: bis dahin
#     verglich die Schranke NUR Datum gegen Datum und meldete LEKTORAT.md
#     gruen, waehrend die Datei Befunde/LEKTOR-13.md kein einziges Mal nannte.
schranke pruefe-stand-md.pl || exit $?
# Haelt jedes Dokument gegen die Urteilszeilen in BEFUNDE.md - kein
# Text darf einen Befund fuer erledigt erklaeren, den BEFUNDE.md offen
# fuehrt. Hing bis zum 12.10.2026 in KEINEM Haken und war auf main rot.
schranke pruefe-befundurteile.pl || exit $?
schranke befunde-verlinken.pl || exit $?

# 19c. Vergibt niemand eine Fassungsnummer zweimal? VERSION, Version.h,
#      Releases/PAKETE.md und der Tag-Bestand gegeneinander. Zwei gleichzeitig
#      laufende Sitzungen koennen dieselbe naechste Nummer vergeben - der
#      CHANGELOG fuehrt den Fall unter "Warum es zwei Fassungsnummern 1.0.68
#      gab", und es gab dafuer keine Schranke. Eine Luecke in der Nummernfolge
#      ist dabei ausdruecklich ERLAUBT (1.0.70 und 1.0.71 wurden gebaut und
#      nie veroeffentlicht); geprueft wird auf Doppelvergabe, nicht auf
#      Lueckenlosigkeit. Gegenprobe: --tests, 11 Faelle. Gemessen 361 ms.
schranke pruefe-fassungsnummer.pl || exit $?

# 19d. Steckt das, was als behoben UND als von Gregor bestaetigt dasteht,
#      wirklich in einem Paket? Gemessen an der Versionsressource der
#      ausgelieferten Eudora.exe, NICHT an VERSION - VERSION ist eine
#      Absichtserklaerung. Der Anlass: "behoben" gemeldet, waehrend die
#      Behebung nur in Eudora71/Bin/Release/ lag; Gregor startete 1.0.63, es
#      stuerzte wieder ab, seine Antwort war "idiot!".
#      Gegenprobe: --tests, 11 Faelle, darunter "Paket 1.0.68, Eudora.exe
#      7.2.0.67". Gemessen 237 ms (liest nur das letzte Megabyte je EXE;
#      die entfernteste Fundstelle aller 21 Pakete liegt 285.036 Byte vor
#      dem Dateiende).
schranke pruefe-behoben-ausgeliefert.pl || exit $?

# 19b. Den Bestand an offenen Befunden MELDEN - nicht abweisen, deshalb steht
#      hier kein "|| exit". CLAUDE.md verlangt diesen Blick zu Sitzungsbeginn;
#      der erste Commit eines Arbeitsblocks ist der zweite gute Zeitpunkt
#      (Arbeitsweise/ausloeser-an-den-anfang.md).
if [ -f "$WURZEL/tools/offene-befunde.pl" ]; then
  perl "$WURZEL/tools/offene-befunde.pl" 2>/dev/null | grep -E "offen|OFFEN" | head -5
fi

# 15b. Keine persoenlichen Daten in Testdaten/. Gregor am 18.09.2026, als er
#      das Verzeichnis angeordnet hat: "aber: keine persoenlichen inhalte
#      (mail adresse oder namen)." Die Testnachrichten stammen aus seinem
#      eigenen Postfach; anonymisiert wurden 38 Adressen, eine Heim-IP, zwei
#      Impressen, Kunden- und Artikelnummern. Eine spaeter hinzugefuegte
#      Datei geht diesen Weg nicht von selbst - deshalb eine Schranke und
#      keine Regel. Sie meldet bei NULL geprueften Dateien ausdruecklich ROT
#      (Rueckgabe 2): ein Freispruch ueber die leere Menge ist in diesem
#      Projekt schon zweimal vorgekommen (Befund E-109).
schranke pruefe-testdaten-anonym.pl || exit $?

# 15. E-123: die Wache beim Beenden muss JEDE Uebertragungsart sehen. Am
#      20.10.2026 meldete Gregors Protokoll "eintraege=1 ... uebertragungen=0"
#      - eine Verschiebung innerhalb desselben IMAP-Kontos wurde nicht
#      gezaehlt, das Fenster war sofort weg. Gezaehlt wird die Basisklasse.
schranke pruefe-e123-zaehlung.pl || exit $?

# 16. Datumsangaben gegen die Uhr. Am 17.10.2026 stand in vier Dokumenten
#      "18.10.2026" - ein Tag, den es noch nicht gab. Gefunden hat das kein
#      Werkzeug, sondern der Zeitstempel der gebauten EXE. Geprueft werden
#      nur HINZUGEFUEGTE Zeilen in gestageten .md, Fenster 31 Tage.
schranke pruefe-datum.pl || exit $?

# 17. Schranke gegen lautlose Dateischaeden (Zeilenenden, Kodierung).
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
  perl "$WURZEL/tools/$1" || { rc=$?; echo "  -> alle Maengel auf einmal: perl tools/commit-bereit.pl (-push fuer den pre-push)"; return $rc; }
}

# Ist der Zweigname mit Gregor abgestimmt? Beim COMMIT meldet pruefe-branch.pl
# das nur; HIER weist es ab (--streng, neu am 18.09.2026, PRUEFER-17).
#
# Warum erst hier: der Hinweis beim Commit war da und hat nichts bewirkt.
# Gemessen am 18.09.2026 steht der Zweig, auf dem diese Zeile entsteht, selbst
# nicht in tools/ZWEIGE.md - die Meldung lief bei jedem Commit mit. In
# derselben Sitzungsreihe sind VIER Zweignamen an der Regel vorbeigegangen;
# den letzten hat Gregor geloescht und "illegal" genannt.
#
# Ein Zweig, der auf den Server geht, soll gemergt werden. Lokales Arbeiten
# bleibt frei, abgewiesen wird der Schritt, der andere betrifft. Aufzuloesen
# mit einer Zeile in tools/ZWEIGE.md.
echo "pre-push: ist der Zweigname mit Gregor abgestimmt?"
if [ -f "$WURZEL/tools/pruefe-branch.pl" ]; then
  perl "$WURZEL/tools/pruefe-branch.pl" --streng || exit $?
fi

echo "pre-push: Doku gegen sich selbst pruefen (alle MD-Dateien)"
schranke doku-pruefen.pl || exit $?

echo "pre-push: Zeilenenden und Kodierung"
# 15b. Keine persoenlichen Daten in Testdaten/. Gregor am 18.09.2026, als er
#      das Verzeichnis angeordnet hat: "aber: keine persoenlichen inhalte
#      (mail adresse oder namen)." Die Testnachrichten stammen aus seinem
#      eigenen Postfach; anonymisiert wurden 38 Adressen, eine Heim-IP, zwei
#      Impressen, Kunden- und Artikelnummern. Eine spaeter hinzugefuegte
#      Datei geht diesen Weg nicht von selbst - deshalb eine Schranke und
#      keine Regel. Sie meldet bei NULL geprueften Dateien ausdruecklich ROT
#      (Rueckgabe 2): ein Freispruch ueber die leere Menge ist in diesem
#      Projekt schon zweimal vorgekommen (Befund E-109).
schranke pruefe-testdaten-anonym.pl || exit $?

schranke pruefe-bytes.pl || exit $?

# ---------------------------------------------------------------------------
# DIE BUCHFUEHRUNG UEBER DAS RELEASE - hier ein zweites Mal, gegen den
# FERTIGEN ZWEIG.
#
# Warum beides, obwohl dieselben Werkzeuge schon im pre-commit haengen:
# gemergt wird ein ZWEIG, nicht ein Commit. Ein Zweig kann aus lauter gruenen
# Commits bestehen und am Ende trotzdem veraltet sein, wenn zwischendurch ein
# Tag gesetzt oder VERSION weitergezogen wurde - und genau das ist am
# 17.09.2026 passiert: das Tag v1.0.72 entstand NACH den Commits, die die
# Dokumente geschrieben haben.
#
# Gregor am 07.09.2026: "waere vor dem mergen wichtig, dass keine luegen im
# main stehen!" - und am 18.09.2026: "so dass VOR dem commit und merge alles
# auf github vorhanden ist." Der Push ist der letzte Punkt, an dem das noch
# in meiner Hand liegt; danach merged er.
# ---------------------------------------------------------------------------

echo "pre-push: Release-Buchfuehrung gegen den Tag-Bestand"
schranke pruefe-release-buchfuehrung.pl || exit $?

echo "pre-push: stehen die Befunde dieser Fassung in allen fuehrenden Dokumenten?"
schranke pruefe-befund-verbreitung.pl || exit $?

echo "pre-push: ist die Fassung beschrieben?"
schranke pruefe-doku-takt.pl || exit $?

echo "pre-push: hinkt ein Stand-Kopf hinterher?"
schranke pruefe-stand-md.pl || exit $?
# Haelt jedes Dokument gegen die Urteilszeilen in BEFUNDE.md - kein
# Text darf einen Befund fuer erledigt erklaeren, den BEFUNDE.md offen
# fuehrt. Hing bis zum 12.10.2026 in KEINEM Haken und war auf main rot.
schranke pruefe-befundurteile.pl || exit $?
schranke befunde-verlinken.pl || exit $?

echo "pre-push: ist eine Fassungsnummer zweimal vergeben?"
schranke pruefe-fassungsnummer.pl || exit $?

echo "pre-push: steckt jedes bestaetigte 'behoben' in einem Paket?"
schranke pruefe-behoben-ausgeliefert.pl || exit $?

# Auch hier abweisend, anders als im pre-commit: siehe die Begruendung dort.
# 0 = stimmt, 1 = Missverhaeltnis, 3 = nur ein Hinweis.
echo "pre-push: Release gegen den Quellstand"
if [ -f "$WURZEL/tools/release-pruefen.pl" ]; then
  perl "$WURZEL/tools/release-pruefen.pl"
  rc=$?
  if [ "$rc" != 0 ] && [ "$rc" != 3 ]; then exit $rc; fi
fi

# Laesst sich die Testsammlung ueberhaupt noch bauen? Vom 10.09.2026 bis zum
# 13.09.2026 nicht - und drei Tage lang hat es niemand gemerkt. Die Spurmarke
# zu E-76 hatte PutDebugLog aus QCUtils in OTShim.cpp gebracht, und OTShim.cpp
# wird von Tests.vcxproj mituebersetzt: LNK2019, kein EudoraTests.exe. Folge:
# die Schranken vom 13.09.2026 sind nie gegen die Tests gefahren, und zwei
# rote Tests blieben drei Tage unsichtbar.
#
# Hier im pre-push und nicht im pre-commit, weil der Bau Zeit kostet: am
# 13.09.2026 gemessen 17,7 Sekunden fuer Bau UND Lauf der ganzen Sammlung.
# Einmal je Zweig ist das billig, einmal je Commit waere es laestig - und eine
# laestige Schranke wird umgangen.
#
# Die Schranke weist NUR beim Baufehler ab, NICHT bei roten Tests. Ein roter
# Test ist ein Ergebnis, kein Grund, einen Push zu verweigern.
echo "pre-push: laesst sich die Testsammlung bauen?"
schranke pruefe-testbau.pl || exit $?

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
echo "  9. tools/lehren-uebersicht.pl deckt die Tabelle in Arbeitsweise/README.md den Bestand?"
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
echo " 13. tools/pruefe-fenster-ziehen.pl"
echo "                               rechnet der abschliessende Aufruf von"
echo "                               CalcDynamicLayout wieder aus nLength? (E-76)"
echo " 14. tools/pruefe-leistengroessen-paar.pl"
echo "                               kennt einen Groessenschluessel nur EINE der"
echo "                               beiden Seiten? (E-70, E-84)"
echo " 14b. tools/pruefe-behoben-belegt.pl"
echo "                               nennt ein neues \"behoben\" in BEFUNDE.md,"
echo "                               WORAN es belegt ist?"
echo " 14c. tools/pruefe-anzeigetext.pl"
echo "                               nennt ein zitierter Oberflaechentext seine"
echo "                               Herkunft? (E-83)"
echo " 14d. tools/pruefe-rueckstrich.pl"
echo "                               steht ein Windows-Pfad ohne Rueckstrich"
echo "                               (C:Temp105) in einer neuen MD-Zeile?"
echo " 14e. tools/pruefe-nachgestellt.pl"
echo "                               nennt ein neues Paket an Gregor einen roten"
echo "                               alten Stand am eigenen Pruefstand? (E-121)"
echo " 14f. tools/pruefe-auspacken.pl"
echo "                               packt eine Pruefung etwas Ausfuehrbares"
echo "                               auf die Platte? (E-124, Defender)"
echo " 14g. tools/pruefe-startwege.pl"
echo "                               steht jeder eigene Eudora-Start von heute"
echo "                               in tools/TESTLAEUFE.md? (21.10.2026: 15/0)"
echo " 14h. tools/pruefe-original-belegt.pl"
echo "                               nennt ein neues \"Originalfehler\" seine"
echo "                               Messung am Verhalten? (E-134, E-133)"
echo " 14i. tools/pruefe-messziel.pl"
echo "                               erkennt ein Messskript sein Fenster an"
echo "                               einem Merkmal der Sache? (E-135, #32770)"
echo " 15. tools/pruefe-bytes.pl     sind Zeilenenden und Kodierung heil?"
echo
echo
echo "Der pre-push prueft zusaetzlich, gegen den fertigen Zweig:"
echo "  tools/doku-pruefen.pl        alle MD-Dateien noch einmal gegen sich selbst"
echo "  tools/pruefe-bytes.pl        Zeilenenden und Kodierung"
echo "  tools/pruefe-rollen-doku.pl  ist jede Rolle aus rollen-faellig.pl in"
echo "                               AGENTEN.md nachschlagbar? (pre-commit)"
echo "  tools/pruefe-testbau.pl      laesst sich EudoraTests.exe ueberhaupt bauen?"
echo ""
echo " Seit dem 18.09.2026 zusaetzlich, in BEIDEN Haken abweisend (Befund E-109):"
echo "  tools/pruefe-release-buchfuehrung.pl  nennen die Dokumente das neueste Tag?"
echo "  tools/pruefe-befund-verbreitung.pl    steht jeder Befund der Fassung ueberall?"
echo "  tools/pruefe-doku-takt.pl             ist die Fassung im CHANGELOG beschrieben?"
echo "  tools/pruefe-stand-md.pl              hinkt ein Stand-Kopf hinterher?"
echo "  tools/pruefe-fassungsnummer.pl        ist eine Nummer zweimal vergeben?"
echo "  tools/pruefe-behoben-ausgeliefert.pl  sagt die AUSGELIEFERTE Eudora.exe dasselbe?"
echo "  tools/pruefe-testdaten-anonym.pl      keine persoenlichen Daten unter Testdaten/"
echo "  tools/offene-befunde.pl               deckt WEITERMACHEN.md die offenen Befunde?"
echo "                               Vom 10.09. bis 13.09.2026 drei Tage lang NICHT,"
echo "                               ohne dass es jemand gemerkt hat. Weist nur beim"
echo "                               Baufehler ab, nicht bei roten Tests."
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
