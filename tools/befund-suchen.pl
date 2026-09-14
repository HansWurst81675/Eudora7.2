#!/usr/bin/perl
use strict;
use warnings;

# befund-suchen.pl - steht der Befund schon da, bevor ich ihn neu suche?
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 14.09.2026, nachdem E-85 ueber zwei Tage, zwei Fehlfassungen und
# eine ausgelieferte Zwischenfassung hinweg gesucht worden war:
#
#     NP3-8  der IMAP-Empfang uebersetzt keinen Zeichensatz (Originalfehler)  offen
#     NP3-9  Rueckgabewert von ISOTranslate an zwei Stellen verworfen         teilweise
#
#     "das hat jemand auf dem schirm?"
#
# Beide standen in BEFUNDE.md - der Datei, in die ich E-85 als NEUEN Befund
# eingetragen habe. NP3-8 trug den Vermerk "Sicherheit: nachgewiesen.
# Originalfehler von QUALCOMM", eine Tabelle mit beiden Zaehlweisen
# nebeneinander, die Zeilennummern und am Ende die Handlungsanweisung:
#
#     "Zu tun: in ImapDownload.cpp:4644 denselben Aufruf verwenden wie
#      mime.cpp:382-390, am besten durch Aufruf von FindMIMECharset selbst,
#      und die Abfrage in Zeile 4657 auf > 2 ziehen."
#
# Genau so wurde es am Ende behoben. Die Antwort lag fertig im Repo, mit
# Zeilennummern, und wurde nicht gelesen.
#
# WAS DARAN SCHWER WIEGT: BEFUNDE.md ist ueber 7800 Zeilen lang und fuehrt
# mehrere Nummernkreise nebeneinander (E-, NP-, PR-, P-, X-, Z-, R-). Wer
# einen neuen Fehler meldet, nennt ihn mit SEINEN Worten - "Umlaute kommen
# falsch an" - und findet damit einen Eintrag nicht, der "uebersetzt keinen
# Zeichensatz" heisst. Gesucht werden muss nach dem ORT im Quelltext, nicht
# nach der Beschreibung.
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/befund-suchen.pl ImapDownload.cpp
#   perl tools/befund-suchen.pl ISOTranslate
#   perl tools/befund-suchen.pl "Eudora71/EuImap/src/ImapDownload.cpp:4644"
#
# Sucht in BEFUNDE.md nach jedem Abschnitt, der diesen Ort nennt, und gibt
# Nummer, Ueberschrift und Urteil aus. Mehrere Suchbegriffe sind erlaubt; ein
# Abschnitt gilt als Treffer, wenn er einen davon nennt.
#
# GEDACHT FUER DEN MOMENT, in dem ein neuer Befund angelegt werden soll. Erst
# suchen, dann anlegen.
#
# Rueckgabe: 0 = nichts gefunden (neuer Befund ist berechtigt),
#            1 = Treffer (erst lesen, dann entscheiden),
#            2 = Aufrufproblem.

my $wurzel = -f 'VERSION' ? '.' : '..';
my $datei  = "$wurzel/BEFUNDE.md";

unless (@ARGV) {
    print <<'ENDE';
  Aufruf: perl tools/befund-suchen.pl <Ort> [<Ort> ...]

  Sucht in BEFUNDE.md nach Abschnitten, die diesen Ort im Quelltext nennen.
  Gedacht fuer den Moment, BEVOR ein neuer Befund angelegt wird.

  Beispiele:
      perl tools/befund-suchen.pl ImapDownload.cpp
      perl tools/befund-suchen.pl ISOTranslate FindMIMECharset
ENDE
    exit 2;
}

unless (-f $datei) {
    print "  befund-suchen: BEFUNDE.md nicht gefunden - bitte aus dem\n";
    print "  Wurzelverzeichnis aufrufen.\n";
    exit 2;
}

open my $h, '<:raw', $datei or die "$datei: $!\n";
my $text = do { local $/; <$h> };
close $h;

# --- In Abschnitte zerlegen ------------------------------------------------
#
# Ein Abschnitt beginnt mit "### <Nummer>" oder "## <Nummer>". Die Tabellen
# am Anfang der Datei fallen damit heraus - sie tragen das Urteil, aber nicht
# die Fundstellen, und ein Treffer dort waere nur eine Wiederholung.
my @abschnitte;
my $aktuell;
for my $zeile (split /\n/, $text) {
    if ($zeile =~ /^#{2,3}\s+([A-Z]+[0-9]*-[0-9]+[a-z]?)\b\s*[-\x{2014}]?\s*(.*)$/) {
        push @abschnitte, $aktuell if $aktuell;
        $aktuell = { nummer => $1, titel => $2, zeilen => [], text => '' };
    }
    elsif ($aktuell) {
        push @{ $aktuell->{zeilen} }, $zeile;
        $aktuell->{text} .= "$zeile\n";
    }
}
push @abschnitte, $aktuell if $aktuell;

unless (@abschnitte) {
    print "  befund-suchen: in BEFUNDE.md steht kein Abschnitt mit Kennung -\n";
    print "  entweder hat sich der Aufbau geaendert oder die Datei ist leer.\n";
    exit 2;
}

# --- Suchen ----------------------------------------------------------------
my @treffer;
for my $a (@abschnitte) {
    my @gefunden;
    for my $begriff (@ARGV) {
        push @gefunden, $begriff if index($a->{text}, $begriff) >= 0;
    }
    next unless @gefunden;

    # Das Urteil steht meist in den ersten Zeilen, als "Sicherheit:" oder
    # fettgedruckt. Die erste Zeile mit einem dieser Worte tut es.
    my $urteil = '';
    for my $z (@{ $a->{zeilen} }) {
        next unless $z =~ /Sicherheit:|\*\*(behoben|offen|teilweise|nachgewiesen|widerlegt)/i;
        $urteil = $z;
        $urteil =~ s/^\s+//;
        $urteil =~ s/\s+$//;
        $urteil = substr($urteil, 0, 110) . '...' if length($urteil) > 110;
        last;
    }

    push @treffer, {
        nummer   => $a->{nummer},
        titel    => $a->{titel},
        urteil   => $urteil,
        begriffe => \@gefunden,
    };
}

printf "\n  ------------------------------------------------------------\n";
printf "  befund-suchen: %s\n", join(', ', @ARGV);
printf "  ------------------------------------------------------------\n";
printf "  %d Abschnitt(e) in BEFUNDE.md durchsucht\n\n", scalar @abschnitte;

unless (@treffer) {
    print "  Kein bestehender Befund nennt diesen Ort.\n";
    print "  Ein neuer Eintrag ist berechtigt.\n\n";
    exit 0;
}

printf "  ES GIBT SCHON %d BEFUND(E) ZU DIESEM ORT:\n\n", scalar @treffer;
for my $t (@treffer) {
    printf "    %-8s %s\n", $t->{nummer}, $t->{titel};
    printf "             %s\n", $t->{urteil} if $t->{urteil};
    printf "             gefunden ueber: %s\n", join(', ', @{ $t->{begriffe} });
    print "\n";
}

print <<'ENDE';
  ERST LESEN, DANN ENTSCHEIDEN. Am 13.09.2026 wurde E-85 als neuer Befund
  angelegt, waehrend NP3-8 dieselbe Ursache schon beschrieb - mit
  Zeilennummern und fertiger Handlungsanweisung. Gekostet hat es zwei Tage,
  zwei Fehlfassungen und eine ausgelieferte Zwischenfassung.

  Gehoert der neue Fall zu einem dieser Befunde, wird dort fortgeschrieben
  statt neu angelegt.

ENDE
exit 1;
