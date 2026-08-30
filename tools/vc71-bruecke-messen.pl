#!/usr/bin/perl
#
# vc71-bruecke-messen.pl  --  misst die Bindung an die Laufzeit von Visual C++ 7.1
#                             und erzeugt daraus die .def-Datei der Bruecke.
#
# WARUM es dieses Werkzeug gibt
# -----------------------------
# Im Auslieferungspaket liegen vorgebaute Fremd-DLLs von 2006, fuer die es keine
# Quellen gibt. Sie sind an MSVCR71.dll / MSVCP71.dll / MFC71.DLL gebunden, und
# Microsoft hat dafuer nie ein eigenstaendiges Redistributable veroeffentlicht.
# Statt eine Fremdbinaerdatei aus dem Netz beizulegen, bauen wir eine eigene
# msvcr71.dll, die ihre Exporte an die von Windows selbst mitgelieferte
# msvcrt.dll weiterleitet (Eudora71/VC71Bruecke).
#
# Welche Namen dafuer noetig sind, darf nicht geraten werden - dieses Werkzeug
# misst sie mit dumpbin und schreibt das Ergebnis maschinell in die .def-Datei.
# Wer die Paketzusammenstellung aendert, laesst es erneut laufen und sieht
# sofort, ob eine Luecke entstanden ist.
#
# AUFRUF
# ------
#   perl tools/vc71-bruecke-messen.pl [Optionen]
#
#     --ziel <verz>       Verzeichnisse/Dateien, deren Importe gemessen werden.
#                         Mehrfach angebbar. Voreinstellung: Eudora71/Bin/Release
#                         und Eudora71/Bin/Debug samt Plugins.
#     --msvcrt <datei>    Partner-DLL, an die weitergeleitet wird.
#                         Voreinstellung: C:/Windows/SysWOW64/msvcrt.dll
#     --referenz <datei>  Optional eine echte msvcr71.dll. Ist sie da, deckt die
#                         .def die volle Schnittmenge ihrer Exporte mit msvcrt.dll
#                         ab statt nur der gemessenen Mindestmenge. Die Datei
#                         wird nur als Namensliste gelesen, nichts davon landet
#                         im Erzeugnis.
#     --def <datei>       Zieldatei. Voreinstellung:
#                         Eudora71/VC71Bruecke/src/msvcr71.def
#     --nur-bericht       Nichts schreiben, nur messen und berichten.
#     --pruefe <datei>    SCHRANKE: nimmt eine fertig gebaute msvcr71.dll und
#                         prueft, ob sie jeden gemessenen Namen ausgibt und ob
#                         sie ausser KERNEL32 nichts braucht. Rueckgabewert 1,
#                         wenn etwas fehlt. Schreibt nichts.
#     --dumpbin <datei>   Pfad zu dumpbin.exe (wird sonst gesucht).
#
# ACHTUNG bei dumpbin aus der Git-Bash: die Argumente MUESSEN mit Bindestrich
# geschrieben werden (-imports, nicht /imports), sonst haelt die Shell sie fuer
# einen Pfad und wandelt sie um.
#
use strict;
use warnings;
use File::Find;
use File::Basename;

my @ziele;
my $msvcrt   = 'C:/Windows/SysWOW64/msvcrt.dll';
my $referenz = '';
my $defziel  = '';
my $nurbericht = 0;
my $dumpbin  = '';
my $pruefling = '';

while (@ARGV) {
    my $a = shift @ARGV;
    if    ($a eq '--ziel')        { push @ziele, shift @ARGV }
    elsif ($a eq '--msvcrt')      { $msvcrt   = shift @ARGV }
    elsif ($a eq '--referenz')    { $referenz = shift @ARGV }
    elsif ($a eq '--def')         { $defziel  = shift @ARGV }
    elsif ($a eq '--dumpbin')     { $dumpbin  = shift @ARGV }
    elsif ($a eq '--nur-bericht') { $nurbericht = 1 }
    elsif ($a eq '--pruefe')      { $pruefling = shift @ARGV }
    else { die "unbekannte Option: $a\n" }
}

# Wurzel des Arbeitsbaums: dieses Skript liegt in tools/.
my $wurzel = dirname(dirname(_abs($0)));
$wurzel =~ s{\\}{/}g;

@ziele = ("$wurzel/Eudora71/Bin/Release", "$wurzel/Eudora71/Bin/Debug") unless @ziele;
$defziel = "$wurzel/Eudora71/VC71Bruecke/src/msvcr71.def" unless $defziel;

$dumpbin = finde_dumpbin() unless $dumpbin;
die "dumpbin.exe nicht gefunden - mit --dumpbin angeben\n" unless $dumpbin && -f $dumpbin;
die "Partner-DLL nicht gefunden: $msvcrt\n" unless -f $msvcrt;

# ---------------------------------------------------------------- Messung ---

my @pe = sammle_pe(@ziele);
printf("gemessen werden %d PE-Dateien\n", scalar @pe);

my %braucht;   # Modul -> Name -> { Datei => 1 }
for my $p (@pe) {
    my $txt = lauf($dumpbin, '-imports', $p);
    my $kurz = $p; $kurz =~ s{^\Q$wurzel\E/}{};
    my $modul = '';
    for my $l (split /\r?\n/, $txt) {
        if ($l =~ /^\s{4}(\S+\.(?:dll|DLL|Dll))\s*$/) { $modul = uc $1; next }
        next unless $modul =~ /^(?:MSVCR71|MSVCP71|MFC71)D?\.DLL$/;
        if    ($l =~ /^\s{10,}[0-9A-Fa-f]+\s+(\S+)\s*$/)  { $braucht{$modul}{$1}{$kurz} = 1 }
        elsif ($l =~ /^\s{10,}Ordinal\s+(\d+)\s*$/i)      { $braucht{$modul}{"Ordinal $1"}{$kurz} = 1 }
    }
}

my %msvcrt_hat = map { $_ => 1 } exportnamen($dumpbin, $msvcrt);
printf("%s exportiert %d Namen\n", basename($msvcrt), scalar keys %msvcrt_hat);

my @noetig = sort keys %{ $braucht{'MSVCR71.DLL'} || {} };
my @noetig_d = sort keys %{ $braucht{'MSVCR71D.DLL'} || {} };
printf("MSVCR71.dll:  %d verschiedene Namen gebraucht\n", scalar @noetig);
printf("MSVCR71D.dll: %d verschiedene Namen gebraucht\n", scalar @noetig_d);

my (@weiter, @selbst);
for my $n (@noetig) { $msvcrt_hat{$n} ? push(@weiter, $n) : push(@selbst, $n) }
printf("  davon weiterleitbar: %d, selbst zu schreiben: %d\n",
       scalar @weiter, scalar @selbst);
print "  selbst zu schreiben: @selbst\n" if @selbst;

# Volle Abdeckung, wenn eine echte msvcr71.dll als Namensquelle vorliegt.
my @voll;
my @luecke;
if ($referenz && -f $referenz) {
    my @ref = exportnamen($dumpbin, $referenz);
    printf("Referenz %s exportiert %d Namen\n", basename($referenz), scalar @ref);
    for my $n (@ref) { $msvcrt_hat{$n} ? push(@voll, $n) : push(@luecke, $n) }
    printf("  Schnittmenge mit %s: %d, nur in der Referenz: %d\n",
           basename($msvcrt), scalar @voll, scalar @luecke);
    print "  nur in der Referenz: @luecke\n" if @luecke;
} else {
    @voll = @weiter;
}

# Die gemessene Mindestmenge muss in jedem Fall drin sein.
my %in_voll = map { $_ => 1 } @voll;
for my $n (@weiter) { next if $in_voll{$n}; push @voll, $n; $in_voll{$n} = 1 }
@voll = sort @voll;

my %ist_noetig = map { $_ => 1 } @noetig;

# Diese Namen erzeugt Eudora71/VC71Bruecke/src/bruecke.c selbst; sie duerfen
# nicht weitergeleitet werden. Die Zuordnung steht dort im Kopf begruendet.
my %eigen = (
    '__security_error_handler'     => 'bruecke_security_error_handler',
    '_set_security_error_handler'  => 'bruecke_set_security_error_handler',
    '__set_buffer_overrun_handler' => 'bruecke_set_security_error_handler',
    '__buffer_overrun'             => 'bruecke_buffer_overrun',
    '_set_purecall_handler'        => 'bruecke_set_purecall_handler',
    '_purecall'                    => 'bruecke_purecall',
    '_CRT_RTC_INIT'                => 'bruecke_CRT_RTC_INIT',
);
my %eigen_daten = ( '__lc_clike' => 'bruecke_lc_clike' );

# Diese vier bekommt die Bruecke NICHT ausgegeben. Der Rumpf steht in
# bruecke.c, aber LINK verstuemmelt den Exportnamen beim ersten '@', sobald
# rechts ein eigenes Symbol steht - auf jedem der vier probierten Wege
# (Stolperstelle 3 unten). Gemessen: keine der PE-Dateien des Pakets importiert
# einen davon, die Luecke ist also ohne Wirkung.
my %eigen_nicht_ausgebbar = (
    '?swprintf@@YAHPAGIPBGZZ'      => 'bruecke_swprintf',
    '?swprintf@@YAHPA_WIPB_WZZ'    => 'bruecke_swprintf',
    '?vswprintf@@YAHPAGIPBGPAD@Z'  => 'bruecke_vswprintf',
    '?vswprintf@@YAHPA_WIPB_WPAD@Z'=> 'bruecke_vswprintf',
);

# ----------------------------------------------------------------- Schranke --

if ($pruefling) {
    die "Pruefling nicht gefunden: $pruefling\n" unless -f $pruefling;
    my %hat = map { $_ => 1 } exportnamen($dumpbin, $pruefling);
    printf("\nSCHRANKE gegen %s\n", $pruefling);
    printf("  gibt %d Namen aus\n", scalar keys %hat);

    my @fehlt = grep { !$hat{$_} } @noetig;
    if (@fehlt) {
        printf("  FEHLT (%d): %s\n", scalar @fehlt, join(" ", @fehlt));
    } else {
        printf("  alle %d gemessenen Namen sind da\n", scalar @noetig);
    }

    # Doppelte Namen im Exportverzeichnis waeren der lautlose Schaden aus
    # Stolperstelle 3: die Namenssuche des Laders arbeitet mit binaerer Suche
    # ueber eine sortierte Namensliste und findet dann nur einen davon.
    my $txt = lauf($dumpbin, '-exports', $pruefling);
    my (%zahl, @doppelt);
    for my $l (split /\r?\n/, $txt) {
        next unless $l =~ /^\s+\d+\s+[0-9A-Fa-f]+\s+(?:[0-9A-Fa-f]{8}\s+)?(\S+)/;
        push @doppelt, $1 if ++$zahl{$1} == 2;
    }
    printf("  doppelte Exportnamen: %s\n", @doppelt ? join(" ", @doppelt) : "keine");

    my @dep;
    my $dtxt = lauf($dumpbin, '-dependents', $pruefling);
    my $an = 0;
    for my $l (split /\r?\n/, $dtxt) {
        $an = 1 if $l =~ /following dependencies/;
        $an = 0 if $l =~ /^\s*Summary/;
        push @dep, $1 if $an && $l =~ /^\s{4}(\S+\.(?:dll|DLL))\s*$/;
    }
    printf("  braucht: %s\n", join(" ", @dep));
    my @fremd = grep { !/^KERNEL32\.dll$/i } @dep;

    if (@fehlt || @fremd || @doppelt) {
        print "\nSCHRANKE ZU: die Bruecke ist nicht einsetzbar.\n";
        print "  fehlende Namen: @fehlt\n"     if @fehlt;
        print "  doppelte Namen: @doppelt\n"   if @doppelt;
        print "  unerwuenschte Abhaengigkeit: @fremd\n" if @fremd;
        exit 1;
    }
    print "\nSCHRANKE OFFEN.\n";
    exit 0;
}

exit 0 if $nurbericht;

# ----------------------------------------------------------- .def schreiben --

my $partner = basename($msvcrt); $partner =~ s/\.dll$//i;

my @zeilen;
push @zeilen, "; msvcr71.def - Exportliste der VC7.1-Bruecke";
push @zeilen, ";";
push @zeilen, "; ERZEUGT von tools/vc71-bruecke-messen.pl - nicht von Hand aendern.";
push @zeilen, "; Wer etwas aendern will, aendert das Werkzeug und laesst es neu laufen.";
push @zeilen, ";";
push @zeilen, "; Jede Zeile der Form   name = $partner.name   wird vom Binder zu einem";
push @zeilen, "; echten Forwarder-Export im PE. Der Lader loest sie beim Laden auf; es";
push @zeilen, "; entsteht kein Code und kein Sprungbrett.";
push @zeilen, ";";
push @zeilen, sprintf("; Gemessen: %d Namen aus MSVCR71.dll werden von den Fremd-DLLs des Pakets",
                      scalar @noetig);
push @zeilen, sprintf("; gebraucht; %d davon exportiert %s selbst, %d nicht.",
                      scalar @weiter, basename($msvcrt), scalar @selbst);
push @zeilen, sprintf("; Diese Datei deckt %d Namen ab.", scalar(@voll) + scalar(keys %eigen) + scalar(keys %eigen_daten));
push @zeilen, ";";
push @zeilen, "";
push @zeilen, "EXPORTS";
push @zeilen, "";
push @zeilen, "; ZWEI STOLPERSTELLEN DES BINDERS, beide gemessen am 30.08.2026:";
push @zeilen, ";";
push @zeilen, "; 1. Um das Gleichheitszeichen darf KEIN Leerzeichen stehen.";
push @zeilen, ";";
push @zeilen, "; 2. Auch bei einer Weiterleitung verlangt LINK, dass die RECHTE Seite als";
push @zeilen, ";    Symbol aufloesbar ist - obwohl sie erst der Lader aufloest. Fehlt sie,";
push @zeilen, ";    bricht er mit LNK2001 ab und nennt dabei den undekorierten Namen.";
push @zeilen, ";    Deshalb entsteht neben dieser Datei msvcrt-namen.def; daraus baut das";
push @zeilen, ";    Projekt mit lib.exe eine Namensbibliothek, die genau diese Symbole";
push @zeilen, ";    bereitstellt. Aus demselben Grund stehen die eigenen Rumpfnamen unten";
push @zeilen, ";    OHNE fuehrenden Unterstrich: LINK dekoriert sie selbst.";
push @zeilen, ";";
push @zeilen, "; 3. Steht rechts ein eigenes Symbol und enthaelt der Exportname ein '\@',";
push @zeilen, ";    schneidet der Binder den Namen dort ab: aus '?swprintf\@\@YAHPAGIPBGZZ'";
push @zeilen, ";    wird lautlos '?swprintf', und das zweimal (gemessen). Weder";
push @zeilen, ";    Anfuehrungszeichen noch /EXPORT auf der Befehlszeile noch eine";
push @zeilen, ";    ausdrueckliche Ordinalzahl helfen. Bei einer Weiterleitung tritt der";
push @zeilen, ";    Fehler nicht auf - dort stehen die vollen C++-Namen korrekt drin.";
push @zeilen, ";    Deshalb fehlen die folgenden vier Exporte ganz; ihre Ruempfe stehen";
push @zeilen, ";    in bruecke.c und warten auf einen Weg:";
push @zeilen, ";        " . join("  ", sort keys %eigen_nicht_ausgebbar);
push @zeilen, ";    Gemessen: keine PE-Datei des Pakets importiert einen davon.";
push @zeilen, ";";
push @zeilen, "; --- selbst geschrieben (bruecke.c), weil $partner sie nicht hat ---";
for my $n (sort keys %eigen) {
    push @zeilen, sprintf("    %s=%s", $n, $eigen{$n});
}
for my $n (sort keys %eigen_daten) {
    push @zeilen, sprintf("    %s=%s   DATA", $n, $eigen_daten{$n});
}
push @zeilen, "";
push @zeilen, "; --- weitergeleitet an $partner.dll ---";
push @zeilen, "; Ein  (*)  markiert die Namen, die im Paket tatsaechlich gebraucht werden.";
for my $n (@voll) {
    next if $eigen{$n} || $eigen_daten{$n};
    my $mark = $ist_noetig{$n} ? '   ; (*)' : '';
    push @zeilen, sprintf("    %s=%s.%s%s", $n, $partner, $n, $mark);
}
push @zeilen, "";

open(my $fh, '>', $defziel) or die "kann $defziel nicht schreiben: $!\n";
binmode $fh;
print $fh join("\r\n", @zeilen);
close $fh;
printf("geschrieben: %s (%d Zeilen)\n", $defziel, scalar @zeilen);

# Zweite Datei: die Namensliste fuer die Hilfsbibliothek. Siehe Stolperstelle 2
# im Kopf der erzeugten .def.
my $namenziel = $defziel;
$namenziel =~ s{[^/\\]+$}{$partner-namen.def};

my @nzeilen;
push @nzeilen, "; $partner-namen.def - Namensliste fuer die Hilfsbibliothek";
push @nzeilen, ";";
push @nzeilen, "; ERZEUGT von tools/vc71-bruecke-messen.pl - nicht von Hand aendern.";
push @nzeilen, ";";
push @nzeilen, "; Daraus baut das Projekt mit";
push @nzeilen, ";     lib /DEF:$partner-namen.def /MACHINE:X86";
push @nzeilen, "; eine Importbibliothek, deren einziger Zweck es ist, dem Binder die";
push @nzeilen, "; rechten Seiten der Weiterleitungen aus msvcr71.def aufloesbar zu machen.";
push @nzeilen, "; Kein Code der Bruecke ruft eine dieser Funktionen auf.";
push @nzeilen, ";";
push @nzeilen, "LIBRARY $partner";
push @nzeilen, "EXPORTS";
for my $n (@voll) {
    next if $eigen{$n} || $eigen_daten{$n};
    push @nzeilen, "    $n";
}
push @nzeilen, "";

open(my $nf, '>', $namenziel) or die "kann $namenziel nicht schreiben: $!\n";
binmode $nf;
print $nf join("\r\n", @nzeilen);
close $nf;
printf("geschrieben: %s (%d Zeilen)\n", $namenziel, scalar @nzeilen);

# ------------------------------------------------------------ Hilfsroutinen --

sub _abs {
    my $p = shift;
    return $p if $p =~ m{^[A-Za-z]:};
    require Cwd;
    return Cwd::abs_path($p);
}

sub finde_dumpbin {
    my @wurzeln = (
        'C:/Program Files/Microsoft Visual Studio/2022',
        'C:/Program Files (x86)/Microsoft Visual Studio/2022',
    );
    my @treffer;
    for my $w (@wurzeln) {
        next unless -d $w;
        find(sub { push @treffer, $File::Find::name if $_ eq 'dumpbin.exe' }, $w);
    }
    # Hostx64/x64 zuerst - laeuft auf dieser Maschine ohne Umweg.
    for my $t (@treffer) { return $t if $t =~ m{Hostx64/x64}i || $t =~ m{Hostx64\\x64}i }
    return $treffer[0];
}

sub sammle_pe {
    my @aus;
    for my $z (@_) {
        if (-f $z) { push @aus, $z; next }
        next unless -d $z;
        find(sub {
            return unless -f $_ && /\.(dll|exe|ocx)$/i;
            # Die Laufzeiten selbst sind keine Verbraucher - insbesondere nicht
            # die Bruecke, die in dasselbe Verzeichnis gebaut wird.
            return if /^(msvcr71d?|msvcp71d?|mfc71u?d?)\.dll$/i;
            push @aus, $File::Find::name;
        }, $z);
    }
    my %seen; return grep { !$seen{lc $_}++ } sort @aus;
}

sub lauf {
    my ($exe, @arg) = @_;
    my $cmd = join(' ', map { qq{"$_"} } ($exe, @arg));
    my $out = `$cmd 2>&1`;
    return defined $out ? $out : '';
}

sub exportnamen {
    my ($exe, $datei) = @_;
    my $txt = lauf($exe, '-exports', $datei);
    my %n;
    for my $l (split /\r?\n/, $txt) {
        # "        736  2DF 00002F93 malloc"   bzw. mit " = internername".
        # Bei einer Weiterleitung FEHLT die RVA-Spalte:
        # "          1    0          malloc (forwarded to msvcrt.malloc)".
        # Genau daran hat die erste Fassung dieser Pruefung 829 von 837 Namen
        # uebersehen - deshalb ist die RVA hier ausdruecklich wahlfrei.
        next unless $l =~ /^\s+\d+\s+[0-9A-Fa-f]+\s+(?:[0-9A-Fa-f]{8}\s+)?(\S+)/;
        $n{$1} = 1;
    }
    return sort keys %n;
}
