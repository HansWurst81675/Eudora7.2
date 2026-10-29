#!/usr/bin/perl
# pruefe-abschnittsverweise.pl - zeigt jeder Textverweis "DATEI.md, Abschnitt *X*"
# auf eine Ueberschrift, die es in DATEI wirklich gibt?
#
#   perl tools/pruefe-abschnittsverweise.pl                # Bestand: alle .md im Repo
#   perl tools/pruefe-abschnittsverweise.pl --selbsttest   # beide Richtungen
#   perl tools/pruefe-abschnittsverweise.pl --hinweis      # meldet, weist nie ab
#
# Rueckgabe: 0 = alle Verweise treffen, 1 = MANGEL, 2 = Aufrufproblem.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 29.10.2026, nacheinander: "in der FAQ hatten wir auch ein paar
# themen, was es fuer default einstellungen gab ... steht es in readme?" und
# zu Intern/EINSTELLUNGEN.md 4.3: "README.md, Abschnitt Beim Start wird nach
# dem IMAP-Kennwort gefragt -> existiert nicht." Gemessen am selben Tag: 18
# Textverweise zeigten auf README-Abschnitte, die am 22.10.2026 nach
# Doku/ANWENDER.md gewandert waren; zwei davon bildeten einen Kreis
# (ANWENDER -> EINSTELLUNGEN -> README), und die Tabelle der abweichenden
# Einstellungen, auf die beide zeigten, gab es seit dem 14.09.2026 nirgends.
# Kein Link-Pruefer sah das: es waren keine Links, sondern Text
# ("[README.md](../README.md), Abschnitt *X*"). Auch der LEKTOR nicht - er
# prueft Aussagen, nicht ob ein Abschnittsname noch existiert.
#
# DIE REGEL
#
# Nach einem Dateinamen DATEI.md folgen innerhalb von 60 Zeichen (ueber
# Zeilenumbrueche hinweg) "Abschnitt", "Abschnitte" oder "unter" und ein
# kursiver Name *X*. Dann muss DATEI eine Ueberschrift haben, die X enthaelt
# (ohne Gross/Klein, Satzzeichen, Hervorhebung).
#
# AUSGENOMMEN
#
# * Verlaufsdokumente, die alte Staende woertlich zitieren: Befunde/,
#   Arbeitsweise/, Intern/LEKTORAT.md, Releases/PAKETE.md.
# * Ein Menuepfad statt eines Abschnitts (enthaelt "→").
# * Ein Postfachname, kein Abschnitt: *Recent*, *In*, *Out*, *Junk*, *Trash*.

use strict;
use warnings;

my $hinweis = 0;
for my $a (@ARGV) {
    if    ($a eq '--selbsttest') { exit selbsttest() }
    elsif ($a eq '--hinweis')    { $hinweis = 1 }
    else  { print "  pruefe-abschnittsverweise: unbekannt: $a\n"; exit 2 }
}

my @alle = grep { length } split /\n/, `git ls-files "*.md"`;
unless (@alle) { print "  pruefe-abschnittsverweise: keine .md gefunden - ist das das Repo?\n"; exit 2 }

my %kopf;
sub ueberschriften {
    my ($d) = @_;
    return $kopf{$d} if $kopf{$d};
    my @u;
    local $/ = "\n";
    if (open my $f, '<:raw', $d) {
        while (<$f>) { push @u, $1 if /^#+\s+(.*?)\s*$/; }
        close $f;
    }
    return $kopf{$d} = \@u;
}
sub lies { my ($d) = @_; open my $f, '<:raw', $d or return undef; local $/; my $t = <$f>; close $f; return $t; }

my @mangel;
my $geprueft = 0;
for my $d (@alle) {
    next if $d =~ m{^(Befunde|Arbeitsweise)/} or $d eq 'Intern/LEKTORAT.md' or $d eq 'Releases/PAKETE.md';
    my $t = lies($d);
    next unless defined $t;
    for my $v (verweise($t)) {
        $geprueft++;
        # "oben/unten unter *X*" meint eine Ueberschrift in DIESER Datei.
        my @kand = $v->{selbst} ? ($d) : grep { m{(^|/)\Q$v->{datei}\E$} } @alle;
        next unless @kand;
        next if grep { trifft(ueberschriften($_), $v->{abschnitt}) } @kand;
        push @mangel, "$d:$v->{zeile}  -> $v->{datei}, Abschnitt *$v->{abschnitt}* gibt es dort nicht";
    }
}

if (@mangel) {
    print "  ------------------------------------------------------------\n";
    print "  pruefe-abschnittsverweise: VERWEIS AUF EINEN ABSCHNITT, DEN ES NICHT GIBT\n";
    print "  ------------------------------------------------------------\n";
    print "    $_\n" for @mangel;
    print "\n  Den Abschnitt suchen (git grep -n '^#.*<Name>' -- '*.md') und den\n";
    print "  Verweis auf die Datei umhaengen, in der er heute steht.\n";
    exit($hinweis ? 0 : 1);
}
printf "  pruefe-abschnittsverweise: %d Verweise in %d Dateien, alle treffen eine Ueberschrift.\n",
       $geprueft, scalar @alle;
exit 0;

# ---------------------------------------------------------------------------

sub norm { my $s = lc shift; $s =~ s/[*`_„“"'»«—–\-]//g; $s =~ s/\s+/ /g; $s =~ s/^\s+|\s+$//g; return $s; }

sub trifft {
    my ($kopfliste, $abschnitt) = @_;
    my $a = norm($abschnitt);
    for my $h (@$kopfliste) { (my $x = $h) =~ s/<a id="[^"]*"><\/a>//; return 1 if index(norm($x), $a) >= 0; }
    return 0;
}

sub verweise {
    my ($t) = @_;
    my @v;
    # Codebloecke nicht pruefen.
    my $ohne = $t;
    $ohne =~ s/^(```|~~~).*?^\1//msg;
    my @nl; while ($ohne =~ /\n/g) { push @nl, pos($ohne); }
    (my $flach = $ohne) =~ s/\r?\n>?[ \t]*/ /g;
    while ($flach =~ /([A-Z][A-Za-z0-9_-]*\.md)\]?(?:\([^)]*\))?([^.|]{0,60}?)(?:Abschnitt|Abschnitte|unter)\s+\*([^*]{3,90})\*/g) {
        my ($datei, $mitte, $abs, $p) = ($1, $2, $3, $-[0]);
        next if $abs =~ /→/;
        next if $abs =~ /^(Recent|In|Out|Junk|Trash)$/;
        # Zeilennummer: jede eingeebnete Zeile hat ein Zeichen (das Leerzeichen) behalten
        my $z = 1; for my $n (@nl) { last if $n - ($z - 1) > $p; $z++; }
        push @v, { datei => $datei, abschnitt => $abs, zeile => $z, selbst => ($mitte =~ /\b(?:oben|unten)\b/ ? 1 : 0) };
    }
    return @v;
}

sub selbsttest {
    my %fremd = ('README.md' => ['Wo fange ich an?', 'Bekannte Fehler'],
                 'ANWENDER.md' => ['Beim Start wird nach dem IMAP-Kennwort gefragt: das Fenster schließen']);
    my @faelle = (
        [ 'DER ECHTE FEHLER (EINSTELLUNGEN 4.3)', "siehe [README.md](../README.md), Abschnitt *Beim\nStart wird nach dem IMAP-Kennwort gefragt*.\n", 1 ],
        [ 'Abschnitt gibt es',                     "siehe [README.md](../README.md), Abschnitt *Bekannte Fehler*.\n", 0 ],
        [ 'Abschnitt gewandert, Verweis richtig',  "siehe [ANWENDER.md](ANWENDER.md), Abschnitt *Beim Start wird nach dem IMAP-Kennwort gefragt*.\n", 0 ],
        [ 'unter *X*, fehlt',                      "steht in README.md unter *Herunterladen und starten*.\n", 1 ],
        [ 'Menuepfad ist kein Abschnitt',          "siehe README.md unter *Tools → Options*.\n", 0 ],
        [ 'Postfachname ist kein Abschnitt',       "README.md zeigt es unter *Recent*.\n", 0 ],
        [ 'Datei, die es nicht gibt',              "siehe GIBTESNICHT.md, Abschnitt *X Y Z*.\n", 0 ],
        [ 'im Codeblock nicht',                    "```\nREADME.md, Abschnitt *Gibt es nicht*\n```\n", 0 ],
        [ 'oben unter *X* meint die eigene Datei', "[E-52](BEFUNDE.md#e-52) - oben unter *Wo fange ich an?*\n", 0 ],
    );
    my ($gut, $schlecht) = (0, 0);
    print "  pruefe-abschnittsverweise --selbsttest\n";
    for my $f (@faelle) {
        my ($name, $text, $soll) = @$f;
        my $ist = 0;
        for my $v (verweise($text)) {
            my $h = $v->{selbst} ? $fremd{'README.md'} : $fremd{$v->{datei}};   # Selbsttext steht fuer README.md
            next unless $h;                       # Datei unbekannt -> wie im Bestand: nicht geprueft
            $ist++ unless trifft($h, $v->{abschnitt});
        }
        my $ok = $ist == $soll; $ok ? $gut++ : $schlecht++;
        printf "    [%s] %-42s soll %d, ist %d\n", ($ok ? ' ok ' : 'FEHL'), $name, $soll, $ist;
    }
    my $abw = grep { $_->[2] > 0 } @faelle;
    printf "    %d Faelle, %d richtig, %d falsch (%d muessen abweisen)\n", $gut + $schlecht, $gut, $schlecht, $abw;
    return $schlecht ? 1 : 0;
}
