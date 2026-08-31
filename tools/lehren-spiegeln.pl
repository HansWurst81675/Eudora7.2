#!/usr/bin/perl
#
# Spiegelt das Gedaechtnisverzeichnis des Assistenten nach Arbeitsweise/ im Repo.
#
#   perl tools/lehren-spiegeln.pl          - spiegeln und die Kopien stagen
#   perl tools/lehren-spiegeln.pl --pruefen - nur melden, nichts aendern (Rueckgabe 1
#                                             wenn etwas auseinanderlaeuft)
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Die Regeln und Befunde des Assistenten liegen unter
#   C:\Users\<Nutzer>\.claude\projects\<Projekt>\memory\
# Dieses Verzeichnis ist nicht versioniert: es ueberlebt keine Neuinstallation,
# laesst sich nicht teilen und niemand ausser dem Assistenten sieht hinein.
#
# Am 29.08.2026 hat ein Pruef-Agent festgestellt, dass auf diesem Weg wiederholt
# Wissen verlorenging - und noch in derselben Sitzung wurde der Fehler erneut
# gemacht: die Auswertung wurde wieder nur ins Gedaechtnis geschrieben. Deshalb
# haengt dieses Werkzeug im pre-commit-Hook und laeuft, ohne dass jemand daran
# denken muss.
#
use strict;
use warnings;
use File::Basename;
use File::Copy;

my $nur_pruefen = (@ARGV && $ARGV[0] eq '--pruefen');

# Repo-Wurzel ueber git ermitteln
my $wurzel = `git rev-parse --show-toplevel 2>/dev/null`;
chomp $wurzel;
exit 0 unless $wurzel && -d $wurzel;

# Gedaechtnisverzeichnis: aus dem Repo-Pfad abgeleitet, wie Claude Code es bildet
# (Laufwerksbuchstabe und Trenner werden zu Bindestrichen).
my $projektname = $wurzel;
$projektname =~ s{:}{-}g;   # C: -> C-
$projektname =~ s{[/.]}{-}g;   # Trenner und Punkte werden zu Bindestrichen

my $heim = $ENV{USERPROFILE} || $ENV{HOME} || '';
my $gedaechtnis = "$heim/.claude/projects/$projektname/memory";

unless (-d $gedaechtnis) {
    # Kein Gedaechtnis gefunden - das ist kein Fehler (anderer Rechner, anderer
    # Nutzer, anderes Betriebssystem). Der Hook wird deshalb nicht aufgehalten.
    #
    # ABER NICHT STUMM: bis zum 31.08.2026 endete das Werkzeug hier wortlos mit
    # 0, und ein Aufrufer konnte "es gibt nichts zu tun" nicht von "ich habe gar
    # nicht erst hingesehen" unterscheiden (Befund NP3-5). Der abgeleitete Pfad
    # gehoert in die Meldung, sonst sucht niemand den Fehler in der Ableitung.
    print STDERR "lehren-spiegeln: kein Gedaechtnis gefunden, nichts gespiegelt.\n";
    print STDERR "  erwartet unter: $gedaechtnis\n";
    exit($nur_pruefen ? 2 : 0);
}

my $ziel = "$wurzel/Arbeitsweise";
unless (-d $ziel) {
    mkdir $ziel or die "Kann $ziel nicht anlegen: $!\n";
}

opendir(my $dh, $gedaechtnis) or die "Kann $gedaechtnis nicht lesen: $!\n";
my @quellen = grep { /\.md$/i } readdir($dh);
closedir($dh);

my @geaendert;
for my $datei (@quellen) {
    my $q = "$gedaechtnis/$datei";
    my $z = "$ziel/$datei";

    my $gleich = 0;
    if (-f $z) {
        local $/;
        open(my $a, '<:raw', $q) or next;
        open(my $b, '<:raw', $z) or next;
        $gleich = (<$a> eq <$b>);
        close $a; close $b;
    }
    next if $gleich;

    push @geaendert, $datei;
    next if $nur_pruefen;
    copy($q, $z) or warn "Kopieren von $datei fehlgeschlagen: $!\n";
}

exit 0 unless @geaendert;

if ($nur_pruefen) {
    print "Arbeitsweise/ ist nicht auf dem Stand des Gedaechtnisses:\n";
    print "  $_\n" for @geaendert;
    print "Abgleichen mit:  perl tools/lehren-spiegeln.pl\n";
    exit 1;
}

# NICHT stagen. Ein "git add" an dieser Stelle hinterlaesst bei Commits mit
# Pfadangabe (git commit -- <pfad>) eine Loeschung im Index: die Kopien kommen
# zwar in den Commit, im Index steht danach "geloescht", und der naechste
# gewoehnliche Commit fuehrt das aus - die gespiegelten Lehren waeren wieder weg.
# Nachgewiesen in einem Testrepo (Befund NP3-4).
#
# Stattdessen wird der Commit abgebrochen. Ein Schritt mehr, dafuer kann nichts
# lautlos verlorengehen - und genau darum geht es bei diesem Werkzeug.

print "Arbeitsweise/ wurde aktualisiert (" . scalar(@geaendert) . " Datei(en)):\n";
print "  $_\n" for @geaendert;
print "\nDie Kopien liegen jetzt im Arbeitsverzeichnis, sind aber nicht gestaget.\n";
print "Bitte mit committen, dann erneut versuchen:\n";
print "  git add Arbeitsweise\n";
print "Der Commit wurde abgebrochen.\n";

exit 1;
