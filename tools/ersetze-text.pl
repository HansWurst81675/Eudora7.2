#!/usr/bin/perl
# ersetze-text.pl - ersetzt Textstellen byte-erhaltend, Paare aus einer Datei.
#
#   perl tools/ersetze-text.pl <paare-datei> [--probe]
#   perl tools/ersetze-text.pl --selbsttest
#
# Paare-Datei (Kodierung = Kodierung der Zieldateien, gelesen mit :raw):
#
#   @@@ DATEI pfad/zur/datei.md
#   <<< ALT [n]          n = erwartete Trefferzahl, Vorgabe 1
#   alter Text, beliebig viele Zeilen
#   === NEU
#   neuer Text
#   >>>
#
# Mehrere Paare und mehrere Dateien in einer Paare-Datei. Der Zeilenumbruch
# vor "=== NEU" und vor ">>>" gehoert NICHT zum Text; soll der Text mit einem
# Zeilenumbruch enden, eine Leerzeile davor lassen. Zeilenenden der
# Paare-Datei werden wie geschrieben uebernommen (CRLF bleibt CRLF).
#
# ALLES ODER NICHTS: erst werden alle Paare in Reihenfolge im Speicher
# angewandt und gezaehlt; stimmt eine Trefferzahl nicht, wird KEINE Datei
# geschrieben (Rueckgabe 1). --probe zaehlt nur. Nach dem Schreiben: je Datei
# CRLF/nur-LF/Bytes>127 vorher und nachher.
#
# WARUM ES DAS GIBT. Zweimal hing ein Wegwerf-Ersetzer endlos, weil der neue
# Text den alten enthielt und die Schleife ab Anfang weitersuchte (29.10. und
# 01.11.2026, Arbeitsweise/text-nicht-durch-schichten-schicken.md Faelle 38
# und 40); dazu gingen Rueckstriche eines Windows-Pfads im Heredoc verloren
# (Fall 41). Hier wird jede Stelle genau einmal ersetzt (Suche laeuft hinter
# dem Ersatz weiter), und der Text kommt aus einer Datei, nicht durch eine
# Shell. Regel 1 von Arbeitsweise/fehlerklassen-abstellen.md: beim zweiten
# Auftreten Werkzeug und Selbsttest.
#
# Kodierung: reines ASCII.
use strict;
use warnings;

sub lies_roh {
    my ($p) = @_;
    open(my $fh, '<:raw', $p) or die "$p: $!\n";
    local $/; my $t = <$fh>; close $fh;
    return defined $t ? $t : '';
}

sub schreib_roh {
    my ($p, $t) = @_;
    open(my $fh, '>:raw', $p) or die "$p: $!\n";
    print $fh $t; close $fh or die "$p: $!\n";
}

sub mass {
    my ($t) = @_;
    my $crlf = () = $t =~ /\r\n/g;
    my $lf   = () = $t =~ /\n/g;
    my $hoch = () = $t =~ /[\x80-\xff]/g;
    return sprintf "CRLF %d nur-LF %d >127 %d", $crlf, $lf - $crlf, $hoch;
}

# Paare lesen. Rueckgabe: Liste von {datei, alt, neu, soll, zeile}
sub lies_paare {
    my ($text) = @_;
    my @paare; my ($datei, $zust, $cur) = (undef, 'aussen', undef);
    my @zeilen = split /(?<=\n)/, $text;
    my $nr = 0;
    for my $z (@zeilen) {
        $nr++;
        (my $kern = $z) =~ s/\r?\n\z//;
        if ($zust eq 'aussen') {
            next if $kern =~ /^\s*$/ || $kern =~ /^#/;
            if ($kern =~ /^\@\@\@ DATEI (.+?)\s*$/) { $datei = $1; next }
            if ($kern =~ /^<<< ALT(?:\s+(\d+))?\s*$/) {
                die "Zeile $nr: <<< ALT ohne vorheriges \@\@\@ DATEI\n" unless defined $datei;
                $cur = { datei => $datei, alt => '', neu => '', soll => (defined $1 ? $1 : 1), zeile => $nr };
                $zust = 'alt'; next;
            }
            die "Zeile $nr: unerwartet ausserhalb eines Paares: $kern\n";
        } elsif ($zust eq 'alt') {
            if ($kern eq '=== NEU') { $zust = 'neu'; next }
            $cur->{alt} .= $z;
        } else {
            if ($kern eq '>>>') {
                $cur->{alt} =~ s/\r?\n\z//; $cur->{neu} =~ s/\r?\n\z//;
                die "Zeile $cur->{zeile}: leerer alter Text\n" if $cur->{alt} eq '';
                push @paare, $cur; $cur = undef; $zust = 'aussen'; next;
            }
            $cur->{neu} .= $z;
        }
    }
    die "Paare-Datei endet mitten in einem Paar (ab Zeile $cur->{zeile})\n" if $zust ne 'aussen';
    die "keine Paare gefunden\n" unless @paare;
    return @paare;
}

# Zaehlt nicht-ueberlappende Treffer und ersetzt jede Stelle genau einmal.
sub ersetze_alle {
    my ($t, $alt, $neu) = @_;
    my ($n, $p, $aus) = (0, 0, '');
    while ((my $i = index($t, $alt, $p)) >= 0) {
        $aus .= substr($t, $p, $i - $p) . $neu;
        $p = $i + length $alt; $n++;
    }
    $aus .= substr($t, $p);
    return ($n, $aus);
}

# Kern: wendet Paare an. Rueckgabe (fehlerzahl, \%neu, \%alt, @meldungen)
sub anwenden {
    my ($paare, $lader) = @_;
    my (%vorher, %jetzt, @m); my $fehl = 0;
    for my $pr (@$paare) {
        my $d = $pr->{datei};
        unless (exists $jetzt{$d}) { $vorher{$d} = $lader->($d); $jetzt{$d} = $vorher{$d} }
        my ($n, $aus) = ersetze_alle($jetzt{$d}, $pr->{alt}, $pr->{neu});
        my $kurz = substr($pr->{alt}, 0, 50); $kurz =~ s/[\r\n]+/ /g;
        if ($n == $pr->{soll}) {
            $jetzt{$d} = $aus; push @m, "  ok   $d (Paar ab Zeile $pr->{zeile}): $n Treffer  [$kurz]";
        } else {
            $fehl++;
            my $hinweis = '';
            if ($n == 0 && $pr->{alt} =~ /\n/ && $pr->{alt} !~ /\r\n/ && $jetzt{$d} =~ /\r\n/) {
                $hinweis = ' (die Datei hat CRLF, der alte Text nur LF?)';
            }
            push @m, "  FEHL $d (Paar ab Zeile $pr->{zeile}): $n Treffer, erwartet $pr->{soll}$hinweis  [$kurz]";
        }
    }
    return ($fehl, \%jetzt, \%vorher, @m);
}

sub selbsttest {
    my $ok = 0; my $f = 0;
    my $pruef = sub { my ($name, $bed) = @_; if ($bed) { $ok++; print "  ok   $name\n" } else { $f++; print "  FEHL $name\n" } };
    my %mem;
    my $lader = sub { my $d = shift; die "fehlt: $d\n" unless exists $mem{$d}; return $mem{$d} };

    # 1. neu enthaelt alt (der Endlosfall)
    %mem = (a => "x Testpaket y\n");
    my @p = lies_paare("\@\@\@ DATEI a\n<<< ALT\nTestpaket\n=== NEU\nTestpaket 7.2.1.130\n>>>\n");
    my ($fe, $neu) = anwenden(\@p, $lader);
    $pruef->('neu enthaelt alt: genau einmal ersetzt, kein Haengen', $fe == 0 && $neu->{a} eq "x Testpaket 7.2.1.130 y\n");

    # 2. Windows-Pfad mit Rueckstrichen bleibt
    %mem = (a => "Ort: X\n");
    @p = lies_paare("\@\@\@ DATEI a\n<<< ALT\nOrt: X\n=== NEU\nOrt: C:\\Users\\Gregor\\Eudora72-7.2.1.130-release\n>>>\n");
    ($fe, $neu) = anwenden(\@p, $lader);
    $pruef->('Windows-Pfad: Rueckstriche bleiben', $fe == 0 && $neu->{a} eq "Ort: C:\\Users\\Gregor\\Eudora72-7.2.1.130-release\n");

    # 3. Trefferzahl falsch -> Fehler, nichts geaendert
    %mem = (a => "ab ab\n");
    @p = lies_paare("\@\@\@ DATEI a\n<<< ALT\nab\n=== NEU\ncd\n>>>\n");
    ($fe, $neu) = anwenden(\@p, $lader);
    $pruef->('zwei Treffer bei Soll 1: abgewiesen', $fe == 1);
    @p = lies_paare("\@\@\@ DATEI a\n<<< ALT 2\nab\n=== NEU\ncd\n>>>\n");
    ($fe, $neu) = anwenden(\@p, $lader);
    $pruef->('zwei Treffer bei Soll 2: angenommen', $fe == 0 && $neu->{a} eq "cd cd\n");

    # 4. Latin-1-Bytes und gemischte Zeilenenden bleiben
    %mem = (a => "Gr\xfc\xdfe\r\nalt\nende\xe4\r\n");
    @p = lies_paare("\@\@\@ DATEI a\n<<< ALT\nalt\n=== NEU\nneu\n>>>\n");
    ($fe, $neu) = anwenden(\@p, $lader);
    $pruef->('Latin-1 und gemischte Zeilenenden byte-genau', $fe == 0 && $neu->{a} eq "Gr\xfc\xdfe\r\nneu\nende\xe4\r\n");

    # 5. mehrzeilig, Ende mit Zeilenumbruch ueber Leerzeile
    %mem = (a => "eins\nzwei\ndrei\n");
    @p = lies_paare("\@\@\@ DATEI a\n<<< ALT\neins\nzwei\n\n=== NEU\nEINS\n\n>>>\n");
    ($fe, $neu) = anwenden(\@p, $lader);
    $pruef->('mehrzeilig mit End-Umbruch', $fe == 0 && $neu->{a} eq "EINS\ndrei\n");

    # 6. CRLF-Datei, alter Text mit LF -> Hinweis
    %mem = (a => "eins\r\nzwei\r\n");
    @p = lies_paare("\@\@\@ DATEI a\n<<< ALT\neins\nzwei\n=== NEU\nx\n>>>\n");
    my @m; ($fe, $neu, undef, @m) = anwenden(\@p, $lader);
    $pruef->('CRLF-Datei, LF-Muster: abgewiesen mit Hinweis', $fe == 1 && grep { /CRLF/ } @m);

    # 7. zweites Paar sieht das Ergebnis des ersten; Fehler im zweiten -> ganzer Lauf abgewiesen
    %mem = (a => "A\n");
    @p = lies_paare("\@\@\@ DATEI a\n<<< ALT\nA\n=== NEU\nB\n>>>\n<<< ALT\nB\n=== NEU\nC\n>>>\n");
    ($fe, $neu) = anwenden(\@p, $lader);
    $pruef->('Paare in Reihenfolge', $fe == 0 && $neu->{a} eq "C\n");
    @p = lies_paare("\@\@\@ DATEI a\n<<< ALT\nA\n=== NEU\nB\n>>>\n<<< ALT\nZ\n=== NEU\nC\n>>>\n");
    ($fe) = anwenden(\@p, $lader);
    $pruef->('Fehler im zweiten Paar: Lauf abgewiesen', $fe == 1);

    # 8. kaputte Paare-Datei
    $pruef->('unvollstaendiges Paar: abgewiesen', !eval { lies_paare("\@\@\@ DATEI a\n<<< ALT\nx\n"); 1 });
    $pruef->('Paar ohne DATEI: abgewiesen', !eval { lies_paare("<<< ALT\nx\n=== NEU\ny\n>>>\n"); 1 });

    # 9. Ende zu Ende ueber echte Dateien im Temp-freien Ort neben dem Werkzeug: entfaellt bewusst
    #    (schreib_roh/lies_roh sind dieselben Aufrufe wie in ersetze-bereich.pl)
    print "Ergebnis: ", $ok + $f, " Faelle, $ok bestanden, $f fehlgeschlagen\n";
    return $f ? 1 : 0;
}

# --- Hauptteil
if (@ARGV && $ARGV[0] eq '--selbsttest') { exit selbsttest() }
my ($pdatei, $schalter) = @ARGV;
die "Aufruf: perl tools/ersetze-text.pl <paare-datei> [--probe] | --selbsttest\n" unless defined $pdatei;
my $probe = defined $schalter && $schalter eq '--probe';
die "unbekannter Schalter: $schalter\n" if defined $schalter && !$probe;

my @paare = lies_paare(lies_roh($pdatei));
my ($fehl, $jetzt, $vorher, @m) = anwenden(\@paare, \&lies_roh);
print "$_\n" for @m;
if ($fehl) { print "$fehl Paar(e) mit falscher Trefferzahl - NICHTS geschrieben.\n"; exit 1 }
if ($probe) { print "Probe: alle ", scalar(@paare), " Paare stimmen, nichts geschrieben.\n"; exit 0 }
for my $d (sort keys %$jetzt) {
    next if $jetzt->{$d} eq $vorher->{$d};
    schreib_roh($d, $jetzt->{$d});
    die "$d: nach dem Schreiben anders als berechnet\n" unless lies_roh($d) eq $jetzt->{$d};
    print "$d: vorher ", mass($vorher->{$d}), "\n", (' ' x length $d), "  nachher ", mass($jetzt->{$d}), "\n";
}
exit 0;
