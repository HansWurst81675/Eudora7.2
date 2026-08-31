#
# Gemeinsame Liste der Dateiarten, die als TEXT gelten und deren Bytes deshalb
# erhalten bleiben muessen. Wird von tools/pruefe-bytes.pl (Schranke vor jedem
# Commit) und tools/zeilenenden-angleichen.pl geladen.
#
#   my $D = do "$FindBin::Bin/dateiendungen.pl";
#   next unless $pfad =~ $D->{muster};
#
# WARUM DIE LISTE GETEILT WIRD
#
# Bis 31.08.2026 hatte jedes der beiden Werkzeuge eine eigene Liste. Sie waren
# verschieden: ".def" stand nur in einem, ".vcxproj"/".filters" nur im anderen,
# und ".sln", ".bat", ".cmd", ".ps1", ".pl" in keinem - also ausgerechnet die
# Bauwerkzeuge dieses Projekts selbst. Eine .def-Datei komplett von CRLF auf LF
# umzuschreiben lief lautlos durch (Befund PR-3). Zwei Listen, die dasselbe
# meinen, laufen auseinander; eine kann es nicht.
#
# WAS NICHT DRIN STEHT
#
# Bilder, Bibliotheken, Programme, Hilfedateien, Office-Dokumente: alles, was
# ohnehin binaer ist. Die Schranke wuerde dort nur Rauschen erzeugen. Bewusst
# ebenfalls draussen: ".r" (Mac-Rez), ".rtf", ".doc" - Textformate, aber keine
# Quellen dieses Projekts.
#
use strict;
use warnings;

my @endungen = (
    # Quellen
    qw(c cpp cxx cc h hpp hxx inl inc asm s),
    # Schnittstellen und Ressourcen
    qw(idl odl def rc rc2),
    # Bau
    qw(mak mk sln vcxproj vcproj filters props targets dsp dsw),
    # Skripte - auch die Werkzeuge dieses Projekts
    qw(bat cmd ps1 psm1 pl pm py sh),
    # Text und Einstellungen
    qw(txt md pod ini cnf manifest config xml json yml yaml),
);

# Dateien ohne Endung, die trotzdem Text sind und Schaden nehmen koennen.
my @namen = qw(.gitattributes .gitignore .editorconfig Makefile makefile);

my $e = join '|', @endungen;
my $n = join '|', map { quotemeta } @namen;

{
    endungen => \@endungen,
    namen    => \@namen,
    muster   => qr{(?:\.(?:$e)$)|(?:(?:^|/)(?:$n)$)}i,
};
