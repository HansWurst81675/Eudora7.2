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
# Bilder, Bibliotheken, Programme, Office-Dokumente: alles, was ohnehin binaer
# ist. Die Schranke wuerde dort nur Rauschen erzeugen.
#
# Bewusst ebenfalls draussen, obwohl es Text ist - nachgemessen am 31.08.2026
# (Befund X-1, D4). Von 9151 verfolgten Dateien erfasst das Muster 6444; von den
# 2707 uebrigen sind 771 eindeutig Text, aber keine Quellen DIESES Projekts:
#
#   139 ohne Endung   z. B. BuildTools/DeltaReport - eine Endungsliste kann sie
#                     nicht sicher von Binaerdateien unterscheiden, und eine
#                     Namensliste waere Raten. Wer eine davon braucht, traegt
#                     sie unten bei @namen ein.
#   100 .pem  20 .cer Zertifikate und Schluessel des mitgelieferten OpenSSL
#    96 .r           Mac-Rez von QuickTime
#    48 .ssl 11 .unix 28 .com  Makefiles und Skripte des mitgelieferten OpenSSL
#    16 .t 13 .lnx 8 .nt      Messwerte des mitgelieferten OpenSSL
#    17 .cnt 14 .rtf 11 .rbh  Hilfe- und Handbuchbestaende
#    10 .mst          Testskripte von Visual Test
#
# Sie sind Fremdbestand oder Beiwerk; ihre Bytes anzufassen faellt nicht an. Wer
# das aendert, aendert es HIER - beide Werkzeuge ziehen dann mit.
#
use strict;
use warnings;

my @endungen = (
    # Quellen. ".ih" sind C-Header des Regex-Teils und werden mitkompiliert.
    qw(c cpp cxx cc h hpp hxx inl inc ih asm s),
    # Schnittstellen und Ressourcen. ".rgs" sind ATL-Registrar-Skripte und
    # landen als Ressource im Binary; ".mc" geht durch den Message Compiler.
    qw(idl odl def rc rc2 rgs mc),
    # Bau. ".user" sind die vcxproj.user-Dateien, hier verfolgt.
    qw(mak mk sln vcxproj vcproj filters props targets dsp dsw user),
    # Skripte - auch die Werkzeuge dieses Projekts
    qw(bat cmd ps1 psm1 pl pm py sh),
    # Text und Einstellungen. ".hh"/".hpj" gehoeren zum Hilfe-Bau.
    qw(txt md pod ini cnf manifest config xml json yml yaml hh hpj),
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
