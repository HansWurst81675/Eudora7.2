#!/usr/bin/perl
# testplan-voraussetzungen.pl - nennt der Handtest fuer Gregor jede
# Einstellung, die das Messskript am Pruefstand selbst stellt?
#
# WARUM ES DAS GIBT. Testplan 7.2.2.136, Schritt 2/3 (E-239): "den Hinweis
# nach dem Abruf offen lassen". tools/messen-e239.ps1 -Vorbereiten setzt
# selbst Alert=1 - ohne den Hinweis gibt es keinen Weg in den Fehler. Im
# Schritt fuer Gregor stand es nicht; seine Eudora.ini hatte Alert=0, der
# Schritt war unerreichbar. Gregor am 06.11.2026: "deine anweisungen waren
# und sind immer noch unvollstaendig ... dummerweise hast du es wieder
# nicht geprueft, sondern mich testen lassen." Die Lehre dazu
# (erst-pruefen-dann-anweisen) stand seit dem 31.08.2026 da - mit
# "Schranke: keine". Dies ist die Schranke.
#
# WAS ES PRUEFT.
#   1. Der aktuelle (oberste) Testabschnitt in Intern/TESTPLAN.md: jede dort
#      genannte Kennung E-NNN.
#   2. Zu jeder Kennung jedes tools/messen-eNNN*.ps1. Stellt das Skript die
#      Eudora.ini (schreibt $ini), MUSS es seine Voraussetzungen fuer einen
#      Handtest erklaeren - eine oder mehrere Zeilen
#          # VORAUSSETZUNG-HANDTEST: Alert=1
#          # VORAUSSETZUNG-HANDTEST: keine
#      (Kontodaten des Pruefservers sind keine Voraussetzung fuer Gregor.)
#   3. Jede erklaerte Voraussetzung Schluessel=Wert muss woertlich im
#      Testabschnitt stehen.
#   4. Mit --ini <Eudora.ini oder Mailverzeichnis.zip>: jede Voraussetzung
#      gegen Gregors zuletzt geschickte INI ([Settings]); ein anderer Wert
#      oder ein fehlender Schluessel wird gemeldet - der Schritt geht dann
#      nicht so an ihn, sondern mit dem Handgriff zum Umstellen.
#
# AUFRUF
#   perl tools/testplan-voraussetzungen.pl
#   perl tools/testplan-voraussetzungen.pl --ini "//vmware-host/Shared Folders/Win10_VM/test_2.136/Mailverzeichnis.zip"
#   perl tools/testplan-voraussetzungen.pl --selbsttest
#
# Rueckgabe: Zahl der Maengel (0 = frei), 2 bei Aufrufproblem (mindestens).
#
# Kodierung: reines ASCII, kein BOM.
use strict;
use warnings;

my $wurzel = -f 'VERSION' ? '.' : '..';
my ($iniPfad, $selbst);
for (my $i = 0; $i < @ARGV; $i++) {
    if ($ARGV[$i] eq '--ini') { $iniPfad = $ARGV[++$i]; }
    elsif ($ARGV[$i] eq '--selbsttest') { $selbst = 1; }
    else { print "  testplan-voraussetzungen: unbekannt: $ARGV[$i]\n"; exit 2; }
}

sub lies { my ($p) = @_; open my $h, '<:raw', $p or return undef; local $/; my $t = <$h>; close $h; return $t; }

# Aktueller Testabschnitt: vom ersten '## <a id="test-' bis zum naechsten.
sub abschnitt {
    my ($tp) = @_;
    return undef unless $tp =~ /(^## <a id="test-[^"]*"><\/a>.*?)(?=^## <a id="test-|\z)/ms;
    return $1;
}

# Erklaerte Voraussetzungen und ob das Skript die INI stellt.
sub skript_lesen {
    my ($text) = @_;
    my @v;
    while ($text =~ /^\s*#\s*VORAUSSETZUNG-HANDTEST:\s*(.+?)\s*$/mg) {
        push @v, grep { $_ ne '' } split /[\s,]+/, $1;
    }
    # WriteAllText UND WriteAllBytes: messen-e169.ps1 schreibt mit Bytes -
    # die erste Fassung (nur WriteAllText) war dafuer blind (Gegenprobe
    # 06.11.2026).
    my $stellt = ($text =~ /WriteAll\w*\(\s*\$ini\b/
               || $text =~ /(?:Set|Add)-Content\b[^\n]*\$ini\b/
               || $text =~ /Out-File\b[^\n]*\$ini\b/) ? 1 : 0;
    return (\@v, $stellt);
}

sub ini_settings {
    my ($t) = @_;
    my %w; my $ab = '';
    for my $z (split /\r?\n/, $t) {
        if ($z =~ /^\[(.+)\]\s*$/) { $ab = lc $1; next; }
        next unless $ab eq 'settings';
        $w{lc $1} = $2 if $z =~ /^([^=;]+)=(.*)$/;
    }
    return \%w;
}

# Kern: liefert Liste von Maengeln (Strings) und Liste von Meldungen.
sub pruefen {
    my ($abs, $skripte, $ini) = @_;   # $skripte: { name => text }
    my (@mangel, @info);
    my %ken; $ken{$1} = 1 while $abs =~ /\bE-(\d+)\b/g;
    for my $n (sort { $a <=> $b } keys %ken) {
        my @namen = sort grep { /^messen-e\Q$n\E(?:[^0-9].*)?\.ps1$/ } keys %$skripte;
        for my $s (@namen) {
            my ($v, $stellt) = skript_lesen($skripte->{$s});
            if (!@$v) {
                if ($stellt) { push @mangel, "E-$n: tools/$s stellt die Eudora.ini, erklaert aber keine '# VORAUSSETZUNG-HANDTEST:'-Zeile"; }
                else { push @info, "E-$n: tools/$s stellt die INI nicht - nichts zu pruefen"; }
                next;
            }
            for my $kv (@$v) {
                next if lc $kv eq 'keine';
                unless ($kv =~ /^([A-Za-z0-9_]+)=(.*)$/) { push @mangel, "E-$n: tools/$s: Voraussetzung '$kv' ist nicht Schluessel=Wert"; next; }
                my ($k, $w) = ($1, $2);
                if (index($abs, "$k=$w") < 0) { push @mangel, "E-$n: der Testabschnitt nennt '$k=$w' nicht (tools/$s stellt es am Pruefstand selbst)"; }
                else { push @info, "E-$n: '$k=$w' steht im Testabschnitt"; }
                if ($ini) {
                    my $ist = $ini->{lc $k};
                    if (!defined $ist) { push @mangel, "E-$n: in Gregors INI fehlt $k (Vorgabe gilt) - verlangt $k=$w"; }
                    elsif ($ist ne $w) { push @mangel, "E-$n: Gregors INI hat $k=$ist - der Schritt verlangt $k=$w"; }
                    else { push @info, "E-$n: Gregors INI hat $k=$w"; }
                }
            }
        }
    }
    return (\@mangel, \@info);
}

if ($selbst) {
    my $f = 0; my $nr = 0;
    my $sk = { 'messen-e239.ps1' => "# VORAUSSETZUNG-HANDTEST: Alert=1\n[IO.File]::WriteAllText(\$ini, \$x)\n",
               'messen-e5.ps1'   => "[IO.File]::WriteAllText(\$ini, \$x)\n",
               'messen-e50.ps1'  => "Write-Output 'liest nur'\n",
               'messen-e7.ps1'   => "[IO.File]::WriteAllBytes(\$ini, \$b)\n" };
    my @faelle = (
        [ 'Schritt ohne Alert=1 (Stand vor dem 06.11.)', "## <a id=\"test-1\"></a>T\n| 2 | E-239 Hinweis offen lassen |\n", undef, 1 ],
        [ 'Schritt mit Alert=1',                         "## <a id=\"test-1\"></a>T\nVoraussetzung `Alert=1`. E-239\n", undef, 0 ],
        [ 'Skript stellt INI ohne Erklaerung',           "## <a id=\"test-1\"></a>T\nE-5\n", undef, 1 ],
        [ 'Skript liest nur',                            "## <a id=\"test-1\"></a>T\nE-50\n", undef, 0 ],
        [ 'Gregors INI Alert=0',                         "## <a id=\"test-1\"></a>T\nAlert=1 E-239\n", { alert => '0' }, 1 ],
        [ 'Gregors INI Alert=1',                         "## <a id=\"test-1\"></a>T\nAlert=1 E-239\n", { alert => '1' }, 0 ],
        [ 'Gregors INI ohne Alert',                      "## <a id=\"test-1\"></a>T\nAlert=1 E-239\n", {}, 1 ],
        [ 'nur oberster Abschnitt zaehlt',               "## <a id=\"test-2\"></a>T\nnichts\n\n## <a id=\"test-1\"></a>T\nE-239\n", undef, 0 ],
        [ 'E-2390 ist nicht E-239',                      "## <a id=\"test-1\"></a>T\nE-2390\n", undef, 0 ],
        [ 'WriteAllBytes ohne Erklaerung',               "## <a id=\"test-1\"></a>T\nE-7\n", undef, 1 ],
    );
    for my $c (@faelle) {
        $nr++;
        my $abs = abschnitt($c->[1]);
        my ($m) = pruefen($abs, $sk, $c->[2]);
        my $ok = (scalar(@$m) >= 1 ? 1 : 0) == $c->[3];
        printf "  [%s] %d %s (Maengel %d, erwartet %s)\n", $ok ? ' ok ' : 'FEHL', $nr, $c->[0], scalar @$m, $c->[3] ? '>=1' : '0';
        $f++ unless $ok;
    }
    print "  Selbsttest: $nr Faelle, $f fehlgeschlagen\n";
    exit $f;
}

my $tp = lies("$wurzel/Intern/TESTPLAN.md");
unless (defined $tp) { print "  testplan-voraussetzungen: Intern/TESTPLAN.md fehlt\n"; exit 2; }
my $abs = abschnitt($tp);
unless (defined $abs) { print "  testplan-voraussetzungen: kein Abschnitt '## <a id=\"test-...' in Intern/TESTPLAN.md\n"; exit 2; }
my ($titel) = $abs =~ /^##\s*<a[^>]*><\/a>\s*(.+)$/m;

my %sk;
opendir my $d, "$wurzel/tools" or die "tools: $!\n";
for my $n (readdir $d) { next unless $n =~ /^messen-e\d+.*\.ps1$/; $sk{$n} = lies("$wurzel/tools/$n"); }
closedir $d;

my $ini;
if (defined $iniPfad) {
    my $t;
    if ($iniPfad =~ /\.zip$/i) { $t = `unzip -p "$iniPfad" Eudora.ini 2>/dev/null`; }
    else { $t = lies($iniPfad); }
    unless (defined $t && $t ne '') { print "  testplan-voraussetzungen: keine Eudora.ini in $iniPfad\n"; exit 2; }
    $ini = ini_settings($t);
}

my ($m, $info) = pruefen($abs, \%sk, $ini);
print "  testplan-voraussetzungen: Abschnitt \"$titel\"", (defined $iniPfad ? ", gegen $iniPfad" : ", ohne Gregors INI (--ini)"), "\n";
print "    $_\n" for @$info;
if (@$m) {
    printf "  MAENGEL (%d) - so geht der Schritt nicht an Gregor:\n", scalar @$m;
    print "    $_\n" for @$m;
} else {
    print "  frei: jede Voraussetzung der Messskripte steht im Testabschnitt", (defined $iniPfad ? " und ist in Gregors INI erfuellt" : ""), ".\n";
}
exit scalar @$m;
