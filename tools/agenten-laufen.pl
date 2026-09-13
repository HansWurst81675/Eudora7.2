#!/usr/bin/perl
use strict;
use warnings;

# agenten-laufen.pl - kein Agent ohne Spur im Repo.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 13.09.2026, mit der Auswertung von 474 meiner Nachrichten vor
# sich - maschinell gezaehlt, nicht geschaetzt:
#
#     1. Zwischenstand nicht gesichert, Wissen geht verloren    45
#     2. Mannschaft nicht gefuehrt                              41
#     3. Doku steht auf altem Stand                             32
#     ...
#
# Sein Satz dazu: "das habe ich mir als deine aussage notiert, aber 1
# passiert trotzdem!" Und kurz darauf: "die anderen uebrigens auch."
#
# Er hat recht. Am 11.09.2026 habe ich zwei Agenten gestartet, NACHDEM er
# "wir machen jetzt schluss" gesagt hatte. Beide liefen noch, als die Sitzung
# endete. Gemessen am naechsten Tag: null geaenderte Dateien, null Commits -
# zwei Auftraege von je zwanzig Minuten restlos verloren.
#
# WAS AN DIESER KLASSE ANDERS IST. Alles, was bisher gegen Punkt 1 gebaut
# wurde, sichert MEINE Arbeit: ein Skript liegt als Datei, sobald ich es
# schreibe, und die Schranken erzwingen Commits. Ein Agent dagegen ist ein
# Prozess OHNE SPUR IM REPO, bis er selbst committet. Faellt er aus, merkt es
# niemand - bis Gregor am naechsten Tag nach dem Stand fragt.
#
# Nach Gregors eigener Zaehlung ist Punkt 3 der einzige mit Schranken - und
# der einzige, bei dem die Fehler inzwischen von einem Werkzeug gefunden
# werden statt von ihm. Das ist der Grund, warum hier ein Werkzeug steht und
# keine weitere Lehre.
#
# ---------------------------------------------------------------------------
# WIE ES BENUTZT WIRD
# ---------------------------------------------------------------------------
#
# BEIM START eines Agenten, vor dem Aufruf:
#
#     perl tools/agenten-laufen.pl --start PRUEFER "Schranken zu E-76/E-84"
#
# Das traegt ihn in tools/AGENTEN-LAUFEN.md ein, mit Zeit und Auftrag.
#
# WENN ER GELIEFERT HAT - Commits sind auf seinem Zweig angekommen:
#
#     perl tools/agenten-laufen.pl --fertig PRUEFER
#
# OHNE SCHALTER prueft es nur und weist ab, wenn ein Eintrag offen steht:
#
#     perl tools/agenten-laufen.pl
#
# Rueckgabe: 0 = kein Agent offen, 1 = mindestens einer, 2 = Aufrufproblem.
#
# GEDACHT FUER paket-bauen.ps1 und den Sitzungsabschluss. Ein Paket, das
# gebaut wird, waehrend ein Auftrag unerledigt in der Luft haengt, liefert
# einen Stand aus, von dem niemand weiss, was noch dazugehoert haette.

my $wurzel = -f 'VERSION' ? '.' : '..';
my $datei  = "$wurzel/tools/AGENTEN-LAUFEN.md";

sub lies {
    my ($d) = @_;
    open my $h, '<:raw', $d or return undef;
    local $/;
    my $t = <$h>;
    close $h;
    return $t;
}

sub schreib {
    my ($d, $t) = @_;
    open my $o, '>:raw', $d or die "$d: $!\n";
    print $o $t;
    close $o;
}

my $kopf = <<'ENDE';
# Agenten, die gerade laufen

Wird von `tools/agenten-laufen.pl` gepflegt — **nicht von Hand ändern.**

Jede Zeile ist ein Auftrag, der angestoßen und noch nicht als geliefert
gemeldet wurde. Steht hier etwas, ist entweder ein Agent noch unterwegs oder
einer ist ausgefallen, ohne etwas zu hinterlassen. Beides muss vor dem
nächsten Paket geklärt sein.

| Rolle | seit | Auftrag |
|---|---|---|
ENDE

my $t = lies($datei);
$t = $kopf unless defined $t;

# --- --start ---------------------------------------------------------------
if (@ARGV >= 2 and $ARGV[0] eq '--start') {
    my $rolle = uc $ARGV[1];
    my $was   = $ARGV[2] || '(ohne Beschreibung)';
    my @z = localtime;
    my $zeit = sprintf('%04d-%02d-%02d %02d:%02d',
                       $z[5] + 1900, $z[4] + 1, $z[3], $z[2], $z[1]);

    if ($t =~ /^\| \Q$rolle\E \|/m) {
        print "  $rolle steht schon als laufend eingetragen.\n";
        exit 0;
    }
    $t .= "| $rolle | $zeit | $was |\n";
    schreib($datei, $t);
    print "  $rolle eingetragen ($zeit).\n";
    exit 0;
}

# --- --fertig --------------------------------------------------------------
if (@ARGV >= 2 and $ARGV[0] eq '--fertig') {
    my $rolle = uc $ARGV[1];
    unless ($t =~ s/^\| \Q$rolle\E \|[^\n]*\n//m) {
        print "  $rolle stand nicht als laufend eingetragen - nichts zu tun.\n";
        exit 0;
    }
    schreib($datei, $t);
    print "  $rolle ausgetragen.\n";
    exit 0;
}

if (@ARGV and $ARGV[0] =~ /^--/) {
    print "  Aufruf: agenten-laufen.pl [--start <ROLLE> \"<Auftrag>\" | --fertig <ROLLE>]\n";
    exit 2;
}

# --- Pruefen ---------------------------------------------------------------
my @offen;
for my $zeile (split /\n/, $t) {
    next unless $zeile =~ /^\|\s*([A-Z]+)\s*\|\s*([^|]+?)\s*\|\s*([^|]*?)\s*\|/;
    next if $1 eq 'ROLLE';
    push @offen, [$1, $2, $3];
}

print "\n  ------------------------------------------------------------\n";
print "  agenten-laufen\n";
print "  ------------------------------------------------------------\n";

unless (@offen) {
    print "    kein Agent offen\n\n";
    exit 0;
}

printf "\n  OFFEN (%d):\n\n", scalar @offen;
printf "    - %s, angestossen %s: %s\n", @$_ for @offen;

print <<'ENDE';

  Ein Agent ist ein Prozess ohne Spur im Repo, bis er selbst
  committet. Steht er hier, hat er entweder noch nicht geliefert
  oder ist ausgefallen - am 11.09.2026 sind so zwei Auftraege
  restlos verlorengegangen.

  Hat er geliefert?   perl tools/agenten-laufen.pl --fertig <ROLLE>
  Ist er ausgefallen? Auftrag neu stellen, dann austragen.

ENDE
exit 1;
