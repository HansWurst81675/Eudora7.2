#!/usr/bin/perl
#
# pruefe-aussenstand.pl - haelt die Papiere gegen die WIRKLICHKEIT, nicht
# gegeneinander.
#
#   perl tools/pruefe-aussenstand.pl              # Bestand pruefen
#   perl tools/pruefe-aussenstand.pl --selbsttest # 14 Faelle, beide Richtungen
#   perl tools/pruefe-aussenstand.pl --ausfuehrlich
#
# Rueckgabe: 0 = nichts zu beanstanden, 1 = MANGEL, 2 = Aufrufproblem.
#
# WARUM ES DAS GIBT
#
# LEKTOR-44 L-44.11, am 20.10.2026 gemessen: 32 Schranken meldeten gruen,
# waehrend vier Dokumente unwahr waren - PAKETE.md fuehrte ein Paket, das es
# nicht gab, WEITERMACHEN.md gab einem Release die Pruefsumme eines anderen,
# README nannte einen behobenen Fehler offen. Jede Schranke war fuer sich zu
# Recht gruen, denn alle messen Dokumente gegen Dokumente.
#
# Einigkeit ist kein Beweis. Der Massstab muss von AUSSEN kommen - vom Tag
# auf GitHub und von der Datei auf der Platte.
#
# Dieselbe Empfehlung steht in LEKTOR-44, -45, -46, -47 und -48. Beim
# fuenften Mal wird sie gebaut (Arbeitsweise/fehlerklassen-abstellen.md).
#
# WAS GEPRUEFT WIRD
#
#   1. "veroeffentlicht ist vX" gegen `gh release list` - welche Marke ist
#      wirklich die neueste? Eine Aussage im Praesens, die eine ANDERE
#      Fassung nennt, ist falsch. L-47.3 und L-48.2: dreimal in Folge stand
#      da, ein laengst veroeffentlichtes Release sei noch nicht draussen.
#   2. Ein Abschnitt in Releases/PAKETE.md, der "geschnuert" sagt, braucht
#      ein ZIP oder ein Verzeichnis Releases/<nr>/. (L-44.5, L-47.1)
#   3. Ein Abschnitt, der "noch nicht geschnuert" sagt, darf KEIN ZIP haben -
#      sonst steht die Anleitung still, waehrend das Paket schon da ist.
#
# WAS ES NICHT PRUEFT
#
# Ob ein Satz sinngemaess etwas Falsches behauptet. Geprueft werden Nummern
# und Vorhandensein, nicht Bedeutung. Das bleibt Handarbeit.
#
use strict;
use warnings;

my $AUSFUEHRLICH = 0;
my $SELBSTTEST   = 0;
for my $a (@ARGV) {
    $AUSFUEHRLICH = 1 if $a eq '--ausfuehrlich';
    $SELBSTTEST   = 1 if $a eq '--selbsttest';
}

# Praesens-Aussagen ueber den Veroeffentlichungsstand. Vergangenheitsformen
# ("wurde am ... veroeffentlicht", "davor v1.0.112") sagen nichts darueber,
# was JETZT draussen ist, und werden nicht geprueft.
my $VEROEFFENTLICHT = qr/
    \bver (?:\xc3\xb6|oe) ffentlicht \s+ ist \s+
    (?: inzwischen \s+ | weiterhin \s+ | jetzt \s+ )?
    \**\s* `? (v?1\.0\.\d+) `?
/xi;

# "noch nicht", "nie" und "nicht geschnuert" behaupten alle KEIN Paket.
# 1.0.107 bis 1.0.109 stehen als "nie geschnuert" in der Buchfuehrung - der
# erste Entwurf dieser Schranke hat sie angeschwaerzt, weil er nur auf
# "noch nicht" sah (Arbeitsweise/schranke-gegentesten.md).
my $NICHT_GESCHNUERT = qr/(?:noch\s+nicht|nie|nicht)\s+geschn(?:\xc3\xbc|ue)rt/i;
my $GESCHNUERT       = qr/\bgeschn(?:\xc3\xbc|ue)rt\b/i;

sub normnr { my $v = shift; $v =~ s/^v//; return $v }
sub nummer { my $v = normnr(shift); return $v =~ /(\d+)$/ ? $1 : 0 }

# Nur die juengsten Paketabschnitte werden auf ihr ZIP geprueft: die alten
# sind bewusst aufgeraeumt worden, Releases/ ging am 21.10.2026 von 745 auf
# 229 MB. Nur die juengsten sagen etwas ueber den heutigen Stand.
our $JUENGSTE_AB;

# ---------------------------------------------------------------------------
# Der Kern, ohne Dateisystem und ohne gh - damit der Selbsttest ihn fahren
# kann. $neueste ist die wirklich neueste Marke ohne "v", $hat_zip eine
# Funktion Nummer -> wahr/falsch.
# ---------------------------------------------------------------------------
sub pruefe_text {
    my ($text, $neueste, $hat_zip, $ist_pakete, $ab) = @_;
    local $JUENGSTE_AB = $ab;
    my @funde;

    for my $zeile (split /^/, $text) {

        # Zitate sind fremde Rede, meist aus einem alten Bericht. Sie
        # behaupten nichts ueber heute.
        next if $zeile =~ /^\s*>/;

        if (defined $neueste) {
            while ($zeile =~ /$VEROEFFENTLICHT/g) {
                my $genannt = normnr($1);
                push @funde,
                    "nennt v$genannt als veroeffentlicht, draussen ist v$neueste"
                    if $genannt ne $neueste;
            }
        }

        next unless $ist_pakete;
        next unless $zeile =~ /^##\s+(1\.0\.\d+)\s/;
        my $nr = $1;
        next if defined $JUENGSTE_AB && nummer($nr) < $JUENGSTE_AB;
        my $da = $hat_zip->($nr) ? 1 : 0;

        if ($zeile =~ /$NICHT_GESCHNUERT/) {
            push @funde, "Abschnitt $nr sagt 'noch nicht geschnuert', das ZIP ist aber da"
                if $da;
        }
        elsif ($zeile =~ /$GESCHNUERT/) {
            push @funde, "Abschnitt $nr sagt 'geschnuert', es gibt aber weder ZIP noch Releases/$nr/"
                unless $da;
        }
    }
    return @funde;
}

# ---------------------------------------------------------------------------
if ($SELBSTTEST) {
    my $zip = sub { return $_[0] eq '1.0.119' };
    my @faelle = (
        ['Praesens, richtige Nummer',     'Veroeffentlicht ist `v1.0.119`.',              '1.0.119', 0, 0],
        ['Praesens, falsche Nummer',      'Veroeffentlicht ist `v1.0.113`.',              '1.0.119', 0, 1],
        ['Praesens mit Fettdruck',        '**Veroeffentlicht ist `v1.0.113`**',           '1.0.119', 0, 1],
        ['Praesens mit weiterhin',        'veroeffentlicht ist weiterhin `v1.0.113`',     '1.0.119', 0, 1],
        ['Praesens mit inzwischen',       'veroeffentlicht ist inzwischen **v1.0.119**',  '1.0.119', 0, 0],
        ['ohne v davor',                  'Veroeffentlicht ist 1.0.113.',                 '1.0.119', 0, 1],
        ['Vergangenheit zaehlt nicht',    'wurde am 20.10. als v1.0.113 veroeffentlicht', '1.0.119', 0, 0],
        ['davor zaehlt nicht',            'davor `v1.0.112` am selben Tag',               '1.0.119', 0, 0],
        ['geschnuert, ZIP da',            "## 1.0.119 - geschnuert am 21.10.2026\n",      '1.0.119', 1, 0],
        ['geschnuert, ZIP fehlt',         "## 1.0.120 - geschnuert am 21.10.2026\n",      '1.0.119', 1, 1],
        ['nicht geschnuert, kein ZIP',    "## 1.0.120 - noch nicht geschnuert\n",         '1.0.119', 1, 0],
        ['nicht geschnuert, ZIP aber da', "## 1.0.119 - noch nicht geschnuert\n",         '1.0.119', 1, 1],
        ['nie geschnuert zaehlt auch',    "## 1.0.108 - uebersetzt, nie geschnuert\n",    '1.0.119', 1, 0],
        ['Zitat zaehlt nicht',            "> Veroeffentlicht ist `v1.0.113`.\n",          '1.0.119', 0, 0],
        ['Ueberschrift ohne Urteil',      "## 1.0.120 - Quellstand 7.2.0.120\n",          '1.0.119', 1, 0],
        ['ohne gh-Stand nichts pruefen',  'Veroeffentlicht ist `v1.0.113`.',              undef,     0, 0],
    );
    my ($ok, $n) = (0, 0);
    for my $t (@faelle) {
        my ($name, $text, $neu, $pak, $erwartet) = @$t;
        my @g = pruefe_text($text, $neu, $zip, $pak, undef);
        $n++;
        my $ist = @g ? 1 : 0;
        if ($ist == $erwartet) {
            $ok++;
            printf "  ok    %s\n", $name if $AUSFUEHRLICH;
        }
        else {
            printf "  FEHL  %-32s erwartet %d, bekommen %d (%s)\n",
                   $name, $erwartet, $ist, join('; ', @g);
        }
    }
    printf "\n  Selbsttest: %d von %d Faellen bestanden.\n", $ok, $n;
    exit($ok == $n ? 0 : 1);
}

# --- der echte Lauf --------------------------------------------------------
print "  ------------------------------------------------------------\n";
print "  pruefe-aussenstand\n";
print "  ------------------------------------------------------------\n";

my $neueste;
my $gh = `gh release list --limit 1 2>&1`;
if ($? == 0 && $gh =~ /\bv?(1\.0\.\d+)\b/) {
    $neueste = $1;
    printf "    neueste Marke laut gh:   v%s\n", $neueste;
}
else {
    print "    gh nicht erreichbar - die Release-Pruefung wird uebersprungen\n";
    print "    (Muster X-8: ein fehlendes Werkzeug weist nicht ab)\n";
}

my %da;
for my $z (glob 'Releases/Eudora72-1.0.*-release.zip') {
    $da{$1} = 1 if $z =~ /Eudora72-(1\.0\.\d+)-release\.zip/;
}
for my $v (glob 'Releases/1.0.*') {
    $da{$1} = 1 if -d $v && $v =~ m{Releases/(1\.0\.\d+)$};
}
printf "    ZIPs/Verzeichnisse:      %d\n", scalar keys %da;
my $hat = sub { return exists $da{ $_[0] } };

# Die sechs juengsten Paketabschnitte - nur sie sagen etwas ueber heute.
my @nummern = sort { $b <=> $a } map { nummer($_) } keys %da;
my $ab_nummer = @nummern >= 6 ? $nummern[5] : 0;
printf "    geprueft ab Paket:       1.0.%d\n", $ab_nummer;

# LEKTORAT.md ist ein Verzeichnis alter Berichte - jede Zeile beschreibt,
# was EIN Bericht damals sagte. Ein Archiv behauptet nichts ueber heute,
# genauso wenig wie Befunde/ und Arbeitsweise/.
my %ARCHIV = map { $_ => 1 } ('LEKTORAT.md', 'PRUEFBERICHT.md');

my @dateien = grep { -f && !$ARCHIV{$_} }
              (glob('*.md'), glob('Releases/*.md'), glob('tools/*.md'));
my @alle;
for my $f (@dateien) {
    open(my $h, '<:raw', $f) or next;
    local $/;
    my $t = <$h>;
    close $h;
    push @alle, "$f: $_"
        for pruefe_text($t, $neueste, $hat, ($f eq 'Releases/PAKETE.md'), $ab_nummer);
}
printf "    Dateien geprueft:        %d\n\n", scalar @dateien;

if (@alle) {
    print "  MANGEL:\n\n";
    print "    - $_\n" for @alle;
    print "\n  Diese Schranke misst gegen gh und gegen die Platte, nicht gegen\n";
    print "  andere Dokumente. Wer hier abgewiesen wird, hat etwas behauptet,\n";
    print "  was draussen nicht so ist.\n";
    exit 1;
}
print "  Kein Dokument widerspricht dem, was draussen wirklich steht.\n";
exit 0;
