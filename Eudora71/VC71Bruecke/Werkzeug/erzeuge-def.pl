#!/usr/bin/perl
#
# erzeuge-def.pl - erzeugt msvcr71.def aus zwei gemessenen Namenslisten.
#
# WARUM es diesen Erzeuger gibt: die .def hat ueber 1400 Zeilen. Von Hand
# gepflegt waere sie nach der ersten Aenderung nicht mehr nachvollziehbar.
# So laesst sich jede Zeile auf eine Messung zurueckfuehren.
#
# Eingaben (beide in ..\Messung, beide mit dumpbin erzeugt):
#
#   msvcrt-exporte.txt      alle benannten Exporte von C:\Windows\SysWOW64\msvcrt.dll
#                           dumpbin -exports C:\Windows\SysWOW64\msvcrt.dll
#
#   benoetigt-msvcr71.txt   alle Namen, die irgendeine der mitgelieferten
#                           Fremd-DLLs aus MSVCR71.dll importiert
#                           dumpbin -imports <jede DLL in Eudora71\Bin\Release>
#
# Ausgaben:
#
#   ..\msvcr71.def          die Weiterleitungstabelle der zu bauenden DLL
#   ..\msvcrt-stub.def      Hilfsdatei, aus der lib.exe vor dem Binden eine
#                           Stub-Importbibliothek erzeugt
#
# WARUM es die Stub-Importbibliothek braucht (gemessen, siehe BEFUND.md,
# Abschnitt "Die Stolperstelle beim Binden"): link.exe aus VS2022 loest bei
# einer Zeile "malloc = msvcrt.malloc" trotzdem den Namen "malloc" als
# gewoehnliches externes Symbol auf und bricht sonst mit LNK2001 ab. Sobald
# irgendeine Bibliothek den Namen anbietet, ist es zufrieden UND erzeugt den
# Forwarder-Export - nicht etwa einen Verweis auf das Stub-Symbol. Die
# Stub-Bibliothek wird also nur waehrend des Bindens gebraucht; im fertigen
# PE steht davon nichts (nachgemessen mit dumpbin -dependents).
#
# Aufruf (aus diesem Verzeichnis):  perl erzeuge-def.pl
#
use strict;
use warnings;

my $hier    = $0; $hier =~ s![^/\\]+$!!; $hier = '.' if $hier eq '';
my $messung = "$hier/../Messung";
my $ziel    = "$hier/../msvcr71.def";
my $ziel2   = "$hier/../msvcrt-stub.def";

# Namen, die msvcrt.dll NICHT hat und die deshalb in vc71bruecke.c
# selbst umgesetzt sind. Beleg: Messung/BEFUND.md, Abschnitt "Was fehlt".
my %selbst = ( '__security_error_handler' => 1 );

sub lies {
    my ($datei) = @_;
    open(my $fh, '<', $datei) or die "$datei: $!";
    my @n;
    while (my $z = <$fh>) { $z =~ s/\s+$//; push @n, $z if length $z; }
    close $fh;
    return @n;
}

my @msvcrt    = lies("$messung/msvcrt-exporte.txt");
my @benoetigt = lies("$messung/benoetigt-msvcr71.txt");

my %hat_msvcrt = map { $_ => 1 } @msvcrt;
my %ist_noetig = map { $_ => 1 } @benoetigt;

# Pruefung: jeder benoetigte Name muss entweder in msvcrt stehen oder
# hier selbst umgesetzt sein. Sonst bricht der Erzeuger ab - lieber ein
# Fehler beim Erzeugen als eine DLL, die still einen Export vermissen laesst.
my @luecke = grep { !$hat_msvcrt{$_} && !$selbst{$_} } @benoetigt;
die "Nicht abgedeckt (weder in msvcrt.dll noch selbst umgesetzt):\n  "
  . join("\n  ", @luecke) . "\n" if @luecke;

open(my $out, '>', $ziel) or die "$ziel: $!";
$out->autoflush(1) if $out->can('autoflush');

my $anz_noetig = scalar @benoetigt;
my $anz_extra  = scalar(grep { !$ist_noetig{$_} } @msvcrt);

print $out <<"KOPF";
; msvcr71.def - ERZEUGT von Werkzeug\\erzeuge-def.pl, nicht von Hand aendern.
;
; Ersatz fuer die Laufzeitbibliothek von Visual C++ 7.1 (2003). Fuer die
; sieben vorgebauten Fremd-DLLs von 2006 (DirServ, EudoraBk, EuMemMgr, ISock,
; Ldap, Ph, Paige32) gibt es keine Quellen; sie sind fest gegen MSVCR71.dll
; gebunden, fuer die Microsoft nie ein eigenstaendiges Redistributable
; herausgegeben hat.
;
; Fast alles davon kann an C:\\Windows\\SysWOW64\\msvcrt.dll weitergeleitet
; werden - die von Windows selbst mitgelieferte Laufzeit derselben Generation.
; "name = msvcrt.name" erzeugt einen echten Forwarder-Export im PE; der Lader
; loest ihn beim Binden auf, es laeuft keine eigene Zeile Code.
;
; Block 1: $anz_noetig Namen, die nachweislich importiert werden.
; Block 2: $anz_extra weitere Namen, die msvcrt.dll ohnehin anbietet.
;          Zugabe fuer Nachruester (fremde Eudora-Plugins). Ein Forwarder,
;          den niemand importiert, wird vom Lader nie aufgeloest und kostet
;          nichts ausser Platz im Exportverzeichnis.
;
LIBRARY MSVCR71
EXPORTS
KOPF

print $out "\n; ---- Block 1: gemessen benoetigt ----\n";
for my $n (sort @benoetigt) {
    if ($selbst{$n}) {
        print $out "  $n                    ; eigene Umsetzung, siehe vc71bruecke.c\n";
    } else {
        print $out "  $n = msvcrt.$n\n";
    }
}

print $out "\n; ---- Block 2: uebrige Exporte von msvcrt.dll ----\n";
for my $n (sort @msvcrt) {
    next if $ist_noetig{$n};
    print $out "  $n = msvcrt.$n\n";
}
close $out;

# --- Hilfsdatei fuer lib.exe ---
# Enthaelt genau die Namen, die weitergeleitet werden. Die selbst
# umgesetzten stehen NICHT drin: sonst koennte link.exe sie aus der
# Stub-Bibliothek statt aus vc71bruecke.obj nehmen.
open(my $stub, '>', $ziel2) or die "$ziel2: $!";
print $stub <<'STUBKOPF';
; msvcrt-stub.def - ERZEUGT von Werkzeug\erzeuge-def.pl, nicht von Hand aendern.
;
; Nur Beiwerk zum Bauen. lib.exe macht daraus eine Importbibliothek, die
; link.exe braucht, um die Namen auf der rechten Seite von msvcr71.def
; ueberhaupt anzunehmen (siehe Kopf von erzeuge-def.pl). In die fertige
; msvcr71.dll geht davon nichts ein.
;
LIBRARY msvcrt.dll
EXPORTS
STUBKOPF
for my $n (sort @msvcrt) { print $stub "  $n\n"; }
close $stub;

printf "%s geschrieben: %d gemessen + %d Zugabe = %d Exporte\n",
       $ziel, $anz_noetig, $anz_extra, $anz_noetig + $anz_extra;
printf "%s geschrieben: %d Namen\n", $ziel2, scalar @msvcrt;
