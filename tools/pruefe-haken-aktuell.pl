#!/usr/bin/perl
use strict;
use warnings;

# pruefe-haken-aktuell.pl - kennt der INSTALLIERTE Haken die Schranken, die
# im Quelltext stehen?
#
#   perl tools/pruefe-haken-aktuell.pl              # Bestand
#   perl tools/pruefe-haken-aktuell.pl --selbsttest # 9 Faelle, beide Richtungen
#   perl tools/pruefe-haken-aktuell.pl --knapp      # nur das Urteil
#
# Rueckgabe: 0 = der Haken kennt alle Schranken, 1 = es fehlen welche,
#            2 = Aufrufproblem.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Die Haken liegen unter .git/hooks und sind NICHT versioniert. Wer eine neue
# Schranke in tools/hooks-einrichten.sh eintraegt, hat sie damit noch nicht
# eingerichtet - dazu muss "sh tools/hooks-einrichten.sh" laufen. Vergisst man
# das, steht die Schranke im Repo, laeuft aber nie, und alle Zaehlungen melden
# weiter gruen.
#
# GEMESSEN am 21.10.2026 abends, im Hauptbaum:
#
#   .git/hooks/pre-commit        20.10.2026 12:55, 22313 Bytes
#   darin "pruefe-startwege"     0 Treffer   (Schranke 14g, gebaut 21.10. frueh)
#   darin "pruefe-original-belegt" 0 Treffer (Schranke 14h, gebaut 21.10. frueh)
#   darin "pruefe-messziel"      0 Treffer   (Schranke 14i, gebaut 21.10. mittags)
#
# Drei Schranken aus drei CHRONIST-Laeufen desselben Tages, keine davon
# eingerichtet. Der Bericht vom Mittag (Arbeitsweise/CHRONIST-2026-10-21b.md)
# hat es bemerkt und als offenen Punkt notiert - zum zweiten Mal. Beim
# zweiten Mal wird ein Werkzeug gebaut und nicht ermahnt
# (Arbeitsweise/fehlerklassen-abstellen.md).
#
# ---------------------------------------------------------------------------
# WARUM DIESE PRUEFUNG NICHT IM HAKEN SITZEN KANN
# ---------------------------------------------------------------------------
#
# Weil sie genau dann gebraucht wird, wenn der Haken veraltet ist - und ein
# veralteter Haken kennt auch diese Pruefung nicht. Eine Schranke, die ihren
# Umfang aus derselben Quelle nimmt wie das, was sie pruefen soll, prueft
# nichts (Arbeitsweise/schranke-teilt-nicht-die-annahme.md).
#
# Ihr Platz ist deshalb tools/commit-bereit.pl und tools/paket-bereit.pl: die
# laufen aus dem Arbeitsbaum, lesen ihre Liste aus dem QUELLTEXT und sind
# damit vom Haken unabhaengig.

my $selbsttest = grep { $_ eq '--selbsttest' } @ARGV;
my $knapp      = grep { $_ eq '--knapp' } @ARGV;

# --- Die Schrankennamen aus einem Hakentext ziehen -------------------------
#
# Dieselbe Lesart wie tools/commit-bereit.pl: "schranke X.pl" am Zeilenanfang,
# dazu die zwei Sonderfaelle mit eigenem Aufruf. Kommentarzeilen zaehlen
# nicht - sonst liest die Pruefung ihre eigene Begruendung
# (Arbeitsweise/schranke-liest-nur-code.md).

sub schranken_aus {
    my ($text) = @_;
    my (@liste, %schon);
    return @liste unless defined $text;
    for my $z (split /\n/, $text) {
        next if $z =~ /^\s*#/;
        my $werk;
        if    ($z =~ /^\s*schranke\s+(\S+\.pl)\b/)              { $werk = $1 }
        elsif ($z =~ m{\$WURZEL/tools/([a-z0-9-]+\.pl)"})       { $werk = $1 }
        else { next }
        next if $schon{$werk}++;
        push @liste, $werk;
    }
    return @liste;
}

sub vergleich {                 # (\@quelle, \@installiert) -> (\@fehlt, \@zuviel)
    my ($q, $i) = @_;
    my %im_haken = map { $_ => 1 } @$i;
    my %im_quell = map { $_ => 1 } @$q;
    my @fehlt  = grep { !$im_haken{$_} } @$q;
    my @zuviel = grep { !$im_quell{$_} } @$i;
    return (\@fehlt, \@zuviel);
}

# ---------------------------------------------------------------------------
# SELBSTTEST
# ---------------------------------------------------------------------------

if ($selbsttest) {
    my @faelle = (
        ['deckungsgleich: nichts fehlt',
         "schranke a.pl || exit \$?\nschranke b.pl || exit \$?\n",
         "schranke a.pl || exit \$?\nschranke b.pl || exit \$?\n", 0, 0],
        ['der echte Fall: eine neue Schranke im Quelltext, nicht im Haken',
         "schranke a.pl || exit \$?\nschranke pruefe-messziel.pl || exit \$?\n",
         "schranke a.pl || exit \$?\n", 1, 0],
        ['drei neue Schranken, keine eingerichtet (21.10.2026)',
         "schranke pruefe-startwege.pl\nschranke pruefe-original-belegt.pl\n"
       . "schranke pruefe-messziel.pl\n",
         "schranke a.pl\n", 3, 1],
        ['Gegenrichtung: der Haken kennt eine, die es nicht mehr gibt',
         "schranke a.pl\n",
         "schranke a.pl\nschranke alt.pl\n", 0, 1],
        ['gar kein Haken installiert: alles fehlt',
         "schranke a.pl\nschranke b.pl\n", undef, 2, 0],
        ['eine auskommentierte Schranke zaehlt nicht als vorhanden',
         "schranke a.pl\n",
         "# schranke a.pl - vorerst stillgelegt\n", 1, 0],
        ['eine auskommentierte Schranke zaehlt auch im Quelltext nicht',
         "# schranke neu.pl\nschranke a.pl\n",
         "schranke a.pl\n", 0, 0],
        ['Sonderfall mit eigenem Aufruf (pruefe-branch.pl --streng)',
         "perl \"\$WURZEL/tools/pruefe-branch.pl\" --streng || exit \$?\n",
         "", 1, 0],
        ['nur Kommentare und Leerzeilen unterschiedlich: nichts fehlt',
         "# ein neuer Absatz Begruendung\nschranke a.pl\n",
         "schranke a.pl\n\n", 0, 0],
    );

    my ($gut, $schlecht) = (0, 0);
    for my $f (@faelle) {
        my ($name, $quell, $inst, $e_fehlt, $e_zuviel) = @$f;
        my @q = schranken_aus($quell);
        my @i = schranken_aus($inst);
        my ($fehlt, $zuviel) = vergleich(\@q, \@i);
        my $ok = (@$fehlt == $e_fehlt and @$zuviel == $e_zuviel);
        printf "  [%s] %s\n", ($ok ? 'ok ' : 'ROT'), $name;
        printf "        erwartet fehlt=%d zuviel=%d, bekommen %d / %d (%s | %s)\n",
            $e_fehlt, $e_zuviel, scalar @$fehlt, scalar @$zuviel,
            join(',', @$fehlt), join(',', @$zuviel) unless $ok;
        $ok ? $gut++ : $schlecht++;
    }
    printf "\n  Selbsttest: %d von %d Faellen, %d rot.\n", $gut, scalar @faelle, $schlecht;
    print "  Beide Richtungen: der fehlende Eintrag wird gemeldet, der\n";
    print "  deckungsgleiche Haken und der reine Kommentarunterschied nicht.\n\n";
    exit($schlecht ? 1 : 0);
}

# ---------------------------------------------------------------------------
# BESTAND
# ---------------------------------------------------------------------------

my $wurzel = -f 'VERSION' ? '.' : '..';
my $quelle = "$wurzel/tools/hooks-einrichten.sh";
unless (-f $quelle) {
    print "  pruefe-haken-aktuell: tools/hooks-einrichten.sh nicht gefunden -\n";
    print "  bitte aus dem Wurzelverzeichnis aufrufen.\n";
    exit 2;
}

sub lies { my ($p) = @_; open my $h, '<:raw', $p or return undef;
           local $/; my $i = <$h>; close $h; return $i; }

my $sh = lies($quelle);
sub block {
    my ($marke) = @_;
    return $1 if $sh =~ /<<'\Q$marke\E'\n(.*?)\n\Q$marke\E\n/s;
    return undef;
}

my $gitdir = `git rev-parse --path-format=absolute --git-common-dir 2>&1`;
$gitdir = '' unless defined $gitdir;
$gitdir =~ s/\s+\z//;
unless (length $gitdir and -d $gitdir) {
    print "  pruefe-haken-aktuell: das gemeinsame git-Verzeichnis ist nicht\n";
    print "  zu ermitteln - UNGEPRUEFT.\n";
    exit 2;
}

my @teile = (
    ['pre-commit', block('HOOKENDE'),     "$gitdir/hooks/pre-commit"],
    ['pre-push',   block('HOOKPUSHENDE'), "$gitdir/hooks/pre-push"],
);

print "\n  Kennt der installierte Haken die Schranken aus dem Quelltext?\n"
    . "  " . ("-" x 68) . "\n\n" unless $knapp;

my @mangel;
for my $t (@teile) {
    my ($name, $quelltext, $pfad) = @$t;
    unless (defined $quelltext) {
        print "  $name: der Block in hooks-einrichten.sh ist nicht zu finden.\n";
        exit 2;
    }
    my $inst = lies($pfad);
    my @q = schranken_aus($quelltext);
    my @i = schranken_aus($inst);
    my ($fehlt, $zuviel) = vergleich(\@q, \@i);

    my @zeit = defined $inst ? (stat($pfad))[9] : ();
    my $datum = @zeit ? scalar(localtime($zeit[0])) : 'nicht installiert';

    unless ($knapp) {
        printf "  %-12s %-34s %s\n", $name, $datum,
            defined $inst ? sprintf("%d Schranke(n)", scalar @i) : '';
        printf "  %-12s %-34s %d Schranke(n)\n", '', 'im Quelltext', scalar @q;
    }

    if (@$fehlt) {
        push @mangel, "$name kennt " . scalar(@$fehlt) . " Schranke(n) nicht: "
                    . join(', ', @$fehlt);
    }
    if (@$zuviel and !$knapp) {
        print "      nur im Haken, nicht mehr im Quelltext: "
            . join(', ', @$zuviel) . "\n";
    }
    print "\n" unless $knapp;
}

unless (@mangel) {
    print "  Der installierte Haken kennt jede Schranke aus dem Quelltext.\n\n";
    exit 0;
}

print "  MANGEL:\n\n";
print "    - $_\n" for @mangel;
print <<'ENDE';

  Eine Schranke zaehlt erst ab dem Lauf, in dem sie im Haken steht. Bis
  dahin steht sie nur im Repo und meldet nichts - und die Tage, an denen
  sie gefehlt hat, erscheinen in jeder Zaehlung als gruen.

  Einrichten (gilt fuer alle Arbeitsbaeume auf einmal):

      sh tools/hooks-einrichten.sh

  Am 21.10.2026 waren drei Schranken aus drei CHRONIST-Laeufen desselben
  Tages nicht eingerichtet; der installierte pre-commit war vom 20.10.

ENDE
exit 1;
