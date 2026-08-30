#!/usr/bin/perl
#
# Prueft, ob das ausgelieferte Release zum Quellstand passt.
#
#   perl tools/release-pruefen.pl
#
# Rueckgabe 1, wenn etwas nicht stimmt.
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Am 30.08.2026 wurde Releases/1.0/QCSSL.dll neu gebaut, nachdem fuenf Befunde in
# den QCSSL-Quellen behoben waren - die Versionskennung in der DLL blieb aber auf
# "QCSSL 1.0.0". Damit war sie wertlos: zwei verschiedene Binaerdateien mit
# derselben Kennung. Gregor musste danach fragen.
#
# Die Ursache war eine halbe Regel: dokumentiert war, WIE man die Kennung liest,
# nicht WANN sie hochzuzaehlen ist. Ein Werkzeug, das nachsieht, braucht keine
# Regel.
#
use strict;
use warnings;

my $fehler = 0;

# --- 1. Kennung in der Quelle und in der ausgelieferten DLL vergleichen ---------

my $rc  = 'Eudora71/QCSSL/src/qcssl.rc';
my $dll = 'Releases/1.0/QCSSL.dll';

unless (-f $rc && -f $dll) {
    print "release-pruefen: $rc oder $dll fehlt - nichts zu pruefen.\n";
    exit 0;
}

my $version_quelle;
open(my $fh, '<:raw', $rc) or die "Kann $rc nicht lesen: $!\n";
while (my $z = <$fh>) {
    if ($z =~ /QCSSL\s+(\d+\.\d+\.\d+)/) { $version_quelle = $1; last; }
}
close $fh;

my $version_dll;
{
    local $/;
    open(my $b, '<:raw', $dll) or die "Kann $dll nicht lesen: $!\n";
    my $inhalt = <$b>;
    close $b;
    # Die Versionsressource liegt als UTF-16 vor: Nullbytes zwischen den Zeichen.
    (my $flach = $inhalt) =~ s/\x00//g;
    if ($flach =~ /QCSSL\s+(\d+\.\d+\.\d+)/) { $version_dll = $1; }
}

if (!defined $version_quelle) {
    print "release-pruefen: keine Versionskennung in $rc gefunden.\n";
    $fehler = 1;
} elsif (!defined $version_dll) {
    print "release-pruefen: keine Versionskennung in $dll gefunden.\n";
    $fehler = 1;
} elsif ($version_quelle ne $version_dll) {
    print "MISSVERHAELTNIS: $rc sagt $version_quelle, $dll sagt $version_dll.\n";
    print "  Die ausgelieferte DLL stammt aus einem anderen Quellstand.\n";
    print "  Neu bauen und nach Releases/1.0/ kopieren.\n\n";
    $fehler = 1;
}

# --- 2. Pruefsumme gegen die Datei --------------------------------------------

my $sha_datei = "$dll.sha256";
if (-f $sha_datei) {
    open(my $s, '<', $sha_datei) or die;
    my $zeile = <$s>; close $s;
    my ($erwartet) = $zeile =~ /^([0-9a-f]{64})/;
    my $ist = `sha256sum "$dll" 2>/dev/null`;
    ($ist) = $ist =~ /^([0-9a-f]{64})/ if $ist;
    if ($erwartet && $ist && $erwartet ne $ist) {
        print "MISSVERHAELTNIS: $sha_datei passt nicht zur Datei.\n";
        print "  erwartet $erwartet\n  gemessen $ist\n";
        print "  Pruefsumme erneuern:  sha256sum QCSSL.dll > QCSSL.dll.sha256\n\n";
        $fehler = 1;
    }
}

# --- 3. Sind die Quellen neuer als die ausgelieferte DLL? ---------------------

my $dll_commit = `git log -1 --format=%H -- "$dll" 2>/dev/null`;
chomp $dll_commit;
if ($dll_commit) {
    my @neuer = grep { length }
                split /\n/,
                `git log --format=%H $dll_commit..HEAD -- Eudora71/QCSSL/src 2>/dev/null`;
    if (@neuer) {
        printf "HINWEIS: %d Commit(s) haben die QCSSL-Quellen geaendert, seit die\n",
               scalar(@neuer);
        print  "  ausgelieferte DLL zuletzt eingecheckt wurde. Wenn eine Aenderung\n";
        print  "  das Verhalten betrifft: neu bauen, Version hochzaehlen, Pruefsumme\n";
        print  "  erneuern, und in Releases/1.0/README.md vermerken.\n\n";
        $fehler = 1;
    }
}

if ($fehler) {
    print "Release und Quellstand stimmen nicht ueberein.\n";
    exit 1;
}

print "Release stimmt zum Quellstand (QCSSL $version_quelle).\n";
exit 0;
