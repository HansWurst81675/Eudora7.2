#!/usr/bin/perl
#
# Uebersetzt die Adressen aus einer Eudora-Absturzmeldung (Exception.log) in
# Funktionsnamen aus der Zuordnungsdatei Eudora71/Bin/Release/Eudora.map.
#
#   perl tools/absturz-auswerten.pl
#   perl tools/absturz-auswerten.pl <Exception.log>
#   perl tools/absturz-auswerten.pl <Exception.log> <Eudora.map>
#
# WARUM ES DIESES WERKZEUG GIBT
#
# Eudora schreibt bei einem Absturz von selbst einen Bericht nach
# <Mailverzeichnis>\Exception.log. Darin steht der Aufrufstapel, aber nur als
# nackte Adressen. Am 06.09.2026 wurde ein solcher Bericht der Fassung 7.2.0.12
# von Hand ausgewertet, indem gegen die im Kopf der Karte genannte VORGESEHENE
# Ladeadresse 00400000 gerechnet wurde. Heraus kam ein Name aus dem
# Ressourcenbereich - sichtbarer Unsinn. Ursache: Windows laedt Eudora.exe
# verschoben (ASLR), die vorgesehene Ladeadresse gilt also gerade nicht, und
# die tatsaechliche stand nirgends im Bericht (Befund E-26).
#
# Seither schreibt QCExceptionHandler::WriteModuleTable() in
# Eudora71/Eudora/ExceptionHandler.cpp vor dem Aufrufstapel eine Modultabelle
# mit den Ladeadressen mit. Dieses Werkzeug liest genau die.
#
# DIE WICHTIGSTE REGEL: ES WIRD NICHT GERATEN.
#
# Fehlt die Modultabelle (jeder Bericht bis einschliesslich 7.2.0.12), sagt das
# Werkzeug das, erklaert warum, und gibt KEINEN Namen aus. Ein geratener Name
# ist schlimmer als gar keiner - er schickt die Fehlersuche in die falsche
# Datei. Genau daran ist der erste Versuch gescheitert.
#
# RUECKGABEWERTE
#
#   0   mindestens eine Adresse aufgeloest
#   1   Aufruffehler, fehlende oder unlesbare Datei
#   2   nichts aufloesbar (z. B. Modultabelle fehlt) - kein Fehler des
#       Werkzeugs, sondern eine Aussage ueber den Bericht
#
# GEGENPROBE: tools/absturz-auswerten-tests.pl. Wer diese Datei anfasst, laesst
# die Sammlung laufen.
#
# Befund E-29.
#
use strict;
use warnings;
use FindBin;
use File::Glob qw(bsd_glob);
use File::Temp qw(tempfile);

my $SELBST = 'tools/absturz-auswerten.pl';

# ---------------------------------------------------------------- Aufrufzeile

my ($pfad_bericht, $pfad_karte, $ladeadresse_von_hand);
my $mit_undname = 1;
my $nur_letzter = 0;
my @frei;

for my $a (@ARGV) {
  if    ($a eq '--hilfe' or $a eq '--help' or $a eq '-h') { hilfe(); exit 0 }
  elsif ($a eq '--kein-undname')                          { $mit_undname = 0 }
  elsif ($a eq '--letzter')                               { $nur_letzter = 1 }
  elsif ($a =~ /^--karte=(.+)$/)                          { $pfad_karte = $1 }
  elsif ($a =~ /^--ladeadresse=(.+)$/) {
    my $h = $1; $h =~ s/^0x//i;
    unless ($h =~ /^[0-9A-Fa-f]{1,8}$/) {
      print "FEHLER: --ladeadresse braucht eine Hexadezimalzahl, z. B. --ladeadresse=00920000\n";
      exit 1;
    }
    $ladeadresse_von_hand = hex($h);
  }
  elsif ($a =~ /^-/) {
    print "FEHLER: unbekannte Angabe \"$a\".\n\n"; hilfe(); exit 1;
  }
  else { push @frei, $a }
}
$pfad_bericht = shift @frei if @frei;
$pfad_karte   = shift @frei if @frei and not defined $pfad_karte;
if (@frei) {
  print "FEHLER: zu viele Angaben (" . join(', ', @frei) . ").\n\n"; hilfe(); exit 1;
}

sub hilfe {
  print <<"ENDE";
$SELBST - Adressen aus einer Eudora-Absturzmeldung in Funktionsnamen uebersetzen

  perl $SELBST [Exception.log] [Eudora.map] [Schalter]

  Exception.log   der Absturzbericht. Ohne Angabe wird gesucht:
                    - Umgebungsvariable EUDORA_EXCEPTION_LOG
                    - <Mailverzeichnis aus EUDORA_MAILVERZEICHNIS>
                    - %USERPROFILE%\\Eudora72-*-release\\Mailverzeichnis
                    - %APPDATA%\\Qualcomm\\Eudora
  Eudora.map      die Zuordnungsdatei aus demselben Bau. Ohne Angabe:
                    <Arbeitsbaum>/Eudora71/Bin/Release/Eudora.map

Schalter
  --karte=PFAD          Zuordnungsdatei ausdruecklich benennen
  --ladeadresse=HEX     tatsaechliche Ladeadresse von Eudora.exe von Hand
                        setzen. Nur benutzen, wenn sie aus derselben Sitzung
                        BELEGT ist (z. B. Process Explorer). Sonst kommt
                        Unsinn heraus - dann lieber gar kein Ergebnis.
  --letzter             nur den letzten Bericht der Datei auswerten
  --kein-undname        keine lesbaren C++-Namen versuchen
  --hilfe               diese Uebersicht

Rueckgabe: 0 = etwas aufgeloest, 1 = Aufruf-/Dateifehler, 2 = nichts aufloesbar
ENDE
}

# ------------------------------------------------------------------ Bausteine

sub lies {
  my ($pfad) = @_;
  open(my $fh, '<', $pfad) or return (undef, "$!");
  binmode($fh);
  local $/;
  my $t = <$fh>;
  close $fh;
  return (defined $t ? $t : '', undef);
}

sub h8 { return sprintf('%08X', $_[0]) }

# ------------------------------------------------------- Bericht: Standardpfad

sub bericht_suchen {
  my @kandidaten;
  push @kandidaten, $ENV{EUDORA_EXCEPTION_LOG} if $ENV{EUDORA_EXCEPTION_LOG};
  push @kandidaten, $ENV{EUDORA_MAILVERZEICHNIS} . '/Exception.log'
    if $ENV{EUDORA_MAILVERZEICHNIS};
  if (my $u = $ENV{USERPROFILE}) {
    $u =~ s{\\}{/}g;
    push @kandidaten, sort { $b cmp $a }
      bsd_glob("$u/Eudora72-*-release/Mailverzeichnis/Exception.log");
  }
  if (my $a = $ENV{APPDATA}) {
    $a =~ s{\\}{/}g;
    push @kandidaten, "$a/Qualcomm/Eudora/Exception.log";
  }
  for my $k (@kandidaten) { return $k if -f $k }
  return (undef, @kandidaten);
}

sub karte_suchen {
  my @kandidaten = ("$FindBin::Bin/../Eudora71/Bin/Release/Eudora.map");
  push @kandidaten, $ENV{EUDORA_MAP} if $ENV{EUDORA_MAP};
  for my $k (@kandidaten) { return $k if -f $k }
  return (undef, @kandidaten);
}

# ------------------------------------------------------------- Karte einlesen
#
# Aufbau einer MSVC-Zuordnungsdatei:
#
#    Preferred load address is 00400000
#    ...
#     0001:0004a1b0       ?Funktion@@YAXXZ      0044a1b0 f   Datei.obj
#     ^ Abschnitt:Versatz ^ Name                ^ Adresse bei der VORGESEHENEN
#                                                 Ladeadresse
#
# Gebraucht wird Spalte 3 minus vorgesehene Ladeadresse: das ist der Versatz im
# Bild, und genau den liefert Stapeladresse minus tatsaechliche Ladeadresse.
# Die vorgesehene Ladeadresse wird gelesen und nicht fest eingebaut - ein
# anderer Bau kann sie aendern.
#
# Die Abschnittstabelle am Anfang (" 0001:00000000 0000e390H .text CODE") faellt
# durch, weil ihre dritte Spalte auf H endet und die vierte kein Hexwort ist.
# Der Abschnitt "Static symbols" hat dasselbe Format und wird bewusst
# mitgenommen - dort stehen die dateilokalen Funktionen.

sub karte_lesen {
  my ($pfad) = @_;
  open(my $fh, '<', $pfad) or return (undef, "$pfad: $!");
  my (@namen, $basis, $zeit, $bild);
  while (my $z = <$fh>) {
    $z =~ s/[\r\n]+$//;
    if (not defined $basis and $z =~ /Preferred load address is\s+([0-9A-Fa-f]+)/) {
      $basis = hex($1); next;
    }
    if (not defined $zeit and $z =~ /^\s*Timestamp is \S+\s+\((.+)\)\s*$/) {
      $zeit = $1; next;
    }
    if (not defined $bild and $z =~ /^\s*(\S+)\s*$/ and not defined $bild and $. <= 2) {
      $bild = $1; next;
    }
    next unless $z =~ /^\s*([0-9A-Fa-f]{4}):([0-9A-Fa-f]{8})\s+(\S+)\s+([0-9A-Fa-f]{8})\s*(.*)$/;
    my ($abschnitt, $name, $va, $rest) = (hex($1), $3, hex($4), $5);
    # Abschnitt 0000 sind absolute Symbole (<absolute>, <linker-defined>). Ihre
    # dritte Spalte ist KEINE Adresse - in dieser Karte stehen dort 2757 Stueck,
    # die allermeisten mit 00000000. Wer sie mitnimmt, holt sich einen Namen wie
    # ___AbsoluteZero fuer jede kleine Adresse ein.
    next if $abschnitt == 0;
    my $funktion = ($rest =~ /^\s*f\b/) ? 1 : 0;
    my ($obj) = $rest =~ /(\S+)\s*$/;
    push @namen, [ $va, $name, $funktion, (defined $obj ? $obj : ''), $abschnitt ];
  }
  close $fh;
  return (undef, "$pfad: kein \"Preferred load address\" im Kopf - ist das wirklich eine .map-Datei?")
    unless defined $basis;
  return (undef, "$pfad: kein einziger Name gefunden - Datei leer oder abgeschnitten?")
    unless @namen;
  @namen = sort { $a->[0] <=> $b->[0] } @namen;
  return ({ basis => $basis, namen => \@namen, zeit => $zeit, bild => $bild,
            erste => $namen[0][0], letzte => $namen[-1][0] }, undef);
}

# Groesster Eintrag mit Adresse <= $va. Rueckgabe: Index oder undef.
sub suche {
  my ($namen, $va) = @_;
  return undef unless @$namen;
  return undef if $va < $namen->[0][0];
  my ($lo, $hi) = (0, $#$namen);
  while ($lo < $hi) {
    my $m = int(($lo + $hi + 1) / 2);
    if ($namen->[$m][0] <= $va) { $lo = $m } else { $hi = $m - 1 }
  }
  return $lo;
}

# Alle Namen an derselben Adresse. Der Binder faltet gleiche Rumpfe zusammen
# (COMDAT folding), deshalb stehen dort oft mehrere - das ist kein Fehler,
# sondern eine echte Mehrdeutigkeit, und sie gehoert in die Ausgabe.
sub gleichadressig {
  my ($namen, $i) = @_;
  my $va = $namen->[$i][0];
  my $a = $i; $a-- while $a > 0 and $namen->[$a - 1][0] == $va;
  my $b = $i; $b++ while $b < $#$namen and $namen->[$b + 1][0] == $va;
  return @{$namen}[$a .. $b];
}

# ---------------------------------------------------------- Bericht zerlegen

sub berichte_trennen {
  my ($text) = @_;
  my @zeilen = split /\r?\n/, $text, -1;
  my (@berichte, @jetzt);
  for my $z (@zeilen) {
    if ($z =~ m{^//=====}) {
      push @berichte, [ @jetzt ] if grep { /\S/ } @jetzt;
      @jetzt = (); next;
    }
    push @jetzt, $z;
  }
  push @berichte, [ @jetzt ] if grep { /\S/ } @jetzt;
  return @berichte;
}

# Liest die Modultabelle, die WriteModuleTable() schreibt:
#
#   Loaded modules - subtract the load address from a stack address to get
#   the offset listed in the .map file of that module:
#   Load address  Size      Module
#   00400000      002CD000  Eudora.exe
#
# Rueckgabe: (Liste der Module, Hinweis). Der Hinweis ist gesetzt, wenn die
# Tabelle zwar da war, aber Eudora sie nicht fuellen konnte.
sub modultabelle {
  my ($zeilen) = @_;
  my (@module, $hinweis, $im_block);
  for my $z (@$zeilen) {
    if ($z =~ /^Loaded modules: not available \(error (\d+)\)/) {
      $hinweis = "Eudora konnte die Modultabelle nicht erstellen (Fehler $1).";
      next;
    }
    if ($z =~ /^Load address\s+Size\s+Module\s*$/) { $im_block = 1; next }
    if ($z =~ /^\s*\(Module32First failed, error (\d+)\)/) {
      $hinweis = "Module32First ist fehlgeschlagen (Fehler $1) - die Tabelle ist leer.";
      next;
    }
    next unless $im_block;
    if ($z =~ /^([0-9A-Fa-f]{8})\s+([0-9A-Fa-f]{8})\s+(\S.*?)\s*$/) {
      push @module, { basis => hex($1), groesse => hex($2), name => $3 };
      next;
    }
    $im_block = 0 unless $z =~ /^\s*$/ and not @module;
  }
  return (\@module, $hinweis);
}

# Aufrufstapel. Bevorzugt wird "Call stack (Extended Info)" - dort nennt Eudora
# neben der Adresse auch das Modul, was als Gegenprobe zur Modultabelle dient.
# Fehlt der Abschnitt, wird "Call stack (CrashFinder)" mit den nackten Adressen
# genommen.
sub stapel_lesen {
  my ($zeilen) = @_;
  my (@erweitert, @einfach);
  my $modus = '';
  for my $z (@$zeilen) {
    if ($z =~ /^Call stack \(Extended Info\)/) { $modus = 'e'; next }
    if ($z =~ /^Call stack \(CrashFinder\)/)   { $modus = 'c'; next }
    if ($z =~ /^Registers:/ or $z =~ /^Loaded modules/) { $modus = ''; next }
    next unless $modus;
    next if $z =~ /^Address/;
    if ($modus eq 'e'
        and $z =~ /^([0-9A-Fa-f]{4}):([0-9A-Fa-f]{8})\s*(?:\(([^)]*)\))?\s*(.*?)\s*$/) {
      push @erweitert, { seg => $1, adr => hex($2), modul => ($4 || ''), roh => $z };
      next;
    }
    if ($modus eq 'c' and $z =~ /^([0-9A-Fa-f]{8})\s*$/) {
      push @einfach, { seg => '', adr => hex($1), modul => '', roh => $z };
      next;
    }
    $modus = '' if $z =~ /^\S/ and $z !~ /^[0-9A-Fa-f]{4}:/ and $z !~ /^[0-9A-Fa-f]{8}\s*$/;
  }
  return @erweitert ? @erweitert : @einfach;
}

sub kopfdaten {
  my ($zeilen) = @_;
  my %k;
  for my $i (0 .. $#$zeilen) {
    my $z = $zeilen->[$i];
    $k{zeit}    = $z if not $k{zeit} and $z =~ /^\w{3} \w{3} [ \d]\d \d\d:\d\d:\d\d \d{4}$/;
    $k{fassung} = $z if not $k{fassung} and $z =~ /^\d+\.\d+\.\d+\.\d+$/;
    $k{grund}   = $1 if not $k{grund} and $z =~ /caused an (\S+)/;
    if (not defined $k{eip} and $z =~ /at ([0-9A-Fa-f]{4}):([0-9A-Fa-f]{8})/) {
      $k{eip} = hex($2); $k{eip_seg} = $1;
    }
  }
  return \%k;
}

# ------------------------------------------------------------------- undname
#
# undname.exe kommt mit Visual Studio und macht aus "?Foo@CBar@@QAEXH@Z" die
# lesbare Form. Es ist eine Zugabe: fehlt es, wird nur der verstuemmelte Name
# ausgegeben, und das Werkzeug bleibt vollstaendig brauchbar.
#
# Aufgerufen wird es OHNE Shell (system in Listenform) und mit umgelenkter
# Ein- und Ausgabe. Damit kann weder ein Anfuehrungszeichen im Namen etwas
# anrichten noch der Aufruf auf eine Eingabe warten.

sub undname_pfad {
  if ($ENV{UNDNAME} and -f $ENV{UNDNAME}) { return $ENV{UNDNAME} }
  my @muster;
  for my $pf ('C:/Program Files/Microsoft Visual Studio',
              'C:/Program Files (x86)/Microsoft Visual Studio') {
    push @muster, "$pf/*/*/VC/Tools/MSVC/*/bin/Hostx64/x86/undname.exe";
    push @muster, "$pf/*/*/VC/Tools/MSVC/*/bin/Hostx86/x86/undname.exe";
  }
  for my $m (@muster) {
    my @t = sort { $b cmp $a } bsd_glob($m);
    return $t[0] if @t and -f $t[0];
  }
  return undef;
}

sub undname_fragen {
  my ($exe, @namen) = @_;
  my %ergebnis;
  return \%ergebnis unless $exe and @namen;
  @namen = grep { /^[\x21-\x7E]+$/ and not /["%]/ } @namen;
  return \%ergebnis unless @namen;

  my $null = ($^O =~ /MSWin32|cygwin|msys/i) ? 'NUL' : '/dev/null';
  $null = '/dev/null' if -e '/dev/null';

  while (@namen) {
    my @stapel = splice(@namen, 0, 20);
    my ($fh, $tmp) = tempfile('undname-XXXXXX', TMPDIR => 1, UNLINK => 1);
    close $fh;
    my ($alt_aus, $alt_ein);
    open($alt_aus, '>&', \*STDOUT) or last;
    open($alt_ein, '<&', \*STDIN);
    my $ok = open(STDOUT, '>', $tmp);
    open(STDIN, '<', $null);
    system($exe, @stapel) if $ok;
    open(STDOUT, '>&', $alt_aus);
    open(STDIN,  '<&', $alt_ein) if $alt_ein;
    next unless $ok;
    my ($text) = lies($tmp);
    next unless defined $text;
    my $letzter;
    for my $z (split /\r?\n/, $text) {
      if ($z =~ /^Undecoration of :- "(.*)"\s*$/) { $letzter = $1; next }
      if ($z =~ /^is :- "(.*)"\s*$/ and defined $letzter) {
        $ergebnis{$letzter} = $1 unless $1 eq $letzter;
        $letzter = undef;
      }
    }
  }
  return \%ergebnis;
}

# ================================================================== Hauptlauf

unless (defined $pfad_bericht) {
  my ($gefunden, @versucht) = bericht_suchen();
  if (defined $gefunden) { $pfad_bericht = $gefunden }
  else {
    print "FEHLER: keine Exception.log gefunden und keine angegeben.\n\n";
    print "Gesucht wurde an diesen Stellen:\n";
    print "  $_\n" for @versucht;
    print "  (keine)\n" unless @versucht;
    print "\nDie Datei liegt im Mailverzeichnis der abgestuerzten Eudora, neben\n";
    print "Eudora.ini. Aufruf mit Pfad:\n";
    print "  perl $SELBST \"C:\\Pfad\\Mailverzeichnis\\Exception.log\"\n";
    exit 1;
  }
}
unless (-f $pfad_bericht) {
  print "FEHLER: Absturzbericht nicht gefunden: $pfad_bericht\n";
  print "Pfad pruefen. Die Datei entsteht erst, wenn Eudora wirklich abgestuerzt ist.\n";
  exit 1;
}
my ($bericht_text, $lesefehler) = lies($pfad_bericht);
if (defined $lesefehler) {
  print "FEHLER: Absturzbericht nicht lesbar: $pfad_bericht\n  $lesefehler\n";
  exit 1;
}
unless (length $bericht_text) {
  print "FEHLER: Absturzbericht ist leer: $pfad_bericht\n";
  exit 1;
}

unless (defined $pfad_karte) {
  my ($gefunden, @versucht) = karte_suchen();
  if (defined $gefunden) { $pfad_karte = $gefunden }
  else {
    print "FEHLER: keine Zuordnungsdatei (Eudora.map) gefunden.\n\n";
    print "Gesucht wurde an diesen Stellen:\n";
    print "  $_\n" for @versucht;
    print "\nDie Datei entsteht beim Bau der Release-Fassung neben Eudora.exe. Sie muss\n";
    print "aus GENAU dem Bau stammen, der abgestuerzt ist - eine Karte von einem anderen\n";
    print "Bau liefert falsche Namen. Aufruf mit Pfad:\n";
    print "  perl $SELBST <Exception.log> <Eudora.map>\n";
    exit 1;
  }
}
unless (-f $pfad_karte) {
  print "FEHLER: Zuordnungsdatei nicht gefunden: $pfad_karte\n";
  exit 1;
}
my ($karte, $kartenfehler) = karte_lesen($pfad_karte);
if (defined $kartenfehler) {
  print "FEHLER: Zuordnungsdatei nicht auswertbar.\n  $kartenfehler\n";
  exit 1;
}

print "Absturzbericht auswerten (Befund E-29)\n\n";
print "  Bericht : $pfad_bericht\n";
printf("  Karte   : %s\n", $pfad_karte);
printf("            vorgesehene Ladeadresse %s, %d Namen, Bereich %s..%s\n",
       h8($karte->{basis}), scalar(@{$karte->{namen}}),
       h8($karte->{erste}), h8($karte->{letzte}));
printf("            erzeugt %s\n", $karte->{zeit}) if $karte->{zeit};
print "\n";

my $undname = $mit_undname ? undname_pfad() : undef;
print "  Hinweis : undname.exe nicht gefunden - es werden nur die verstuemmelten\n"
    . "            C++-Namen ausgegeben. Das ist kein Fehler.\n\n"
  if $mit_undname and not $undname;

my @berichte = berichte_trennen($bericht_text);
unless (@berichte) {
  print "FEHLER: in $pfad_bericht steht kein auswertbarer Bericht.\n";
  exit 1;
}
@berichte = ($berichte[-1]) if $nur_letzter and @berichte;

my $gesamt = scalar(@berichte);
my $aufgeloest_gesamt = 0;
my $nr = 0;

for my $zeilen (@berichte) {
  $nr++;
  my $kopf = kopfdaten($zeilen);
  my ($module, $modul_hinweis) = modultabelle($zeilen);
  my @rahmen = stapel_lesen($zeilen);

  print "===== Bericht $nr von $gesamt =====\n";
  printf("  Zeit    : %s\n", $kopf->{zeit})    if $kopf->{zeit};
  printf("  Fassung : %s\n", $kopf->{fassung}) if $kopf->{fassung};
  printf("  Grund   : %s\n", $kopf->{grund})   if $kopf->{grund};
  printf("  Fehleradresse: %s\n", h8($kopf->{eip})) if defined $kopf->{eip};
  print "\n";

  # ---- Ladeadresse von Eudora.exe bestimmen. Hier entscheidet sich alles.
  my $eudora;
  for my $m (@$module) { $eudora = $m if lc($m->{name}) eq 'eudora.exe' }
  my $quelle = 'Modultabelle des Berichts';

  if (defined $ladeadresse_von_hand) {
    my $g = $eudora ? $eudora->{groesse} : 0;
    if ($eudora and $eudora->{basis} != $ladeadresse_von_hand) {
      printf("  ACHTUNG: --ladeadresse=%s weicht von der Modultabelle (%s) ab.\n"
           . "           Es gilt die Angabe von der Aufrufzeile.\n\n",
             h8($ladeadresse_von_hand), h8($eudora->{basis}));
    }
    $eudora = { basis => $ladeadresse_von_hand, groesse => $g, name => 'Eudora.exe' };
    $quelle = 'Angabe --ladeadresse auf der Aufrufzeile';
  }

  if (@$module) {
    printf("  Modultabelle: %d Eintraege.\n", scalar(@$module));
  }
  elsif ($modul_hinweis) {
    print "  Modultabelle: vorhanden, aber leer. $modul_hinweis\n";
  }

  unless ($eudora) {
    print "\n";
    if (@$module) {
      print "  In der Modultabelle steht KEIN Eintrag fuer Eudora.exe. Ohne dessen\n";
      print "  Ladeadresse laesst sich keine Adresse zuordnen, und es wird nicht geraten.\n";
    }
    else {
      print "  DIE MODULTABELLE FEHLT IN DIESEM BERICHT.\n\n";
      print "  Die Adressen im Aufrufstapel lassen sich deshalb KEINEM Funktionsnamen\n";
      print "  zuordnen. Geraten wird nicht.\n\n";
      print "  Warum es ohne sie nicht geht: Windows laedt Eudora.exe verschoben (ASLR).\n";
      print "  Die Karte nennt die Adressen fuer die vorgesehene Ladeadresse "
           . h8($karte->{basis}) . ";\n";
      print "  ohne die tatsaechliche Ladeadresse fehlt der Bezugspunkt. Wer trotzdem\n";
      print "  gegen " . h8($karte->{basis}) . " rechnet, bekommt einen falschen Namen "
           . "heraus - genau das ist\n";
      print "  am 06.09.2026 passiert (Befund E-26).\n\n";
      print "  Berichte bis einschliesslich Fassung 7.2.0.12 haben die Tabelle nicht.\n";
      print "  Ab 7.2.0.13 schreibt Eudora sie selbst mit\n";
      print "  (QCExceptionHandler::WriteModuleTable, Eudora71/Eudora/ExceptionHandler.cpp).\n";
      print "  Diesen Absturz mit 7.2.0.13 oder neuer noch einmal ausloesen, dann laesst\n";
      print "  er sich auswerten.\n\n";
      print "  Notbehelf, falls die Ladeadresse aus DERSELBEN Sitzung belegt ist (etwa\n";
      print "  aus Process Explorer): perl $SELBST <Bericht> --ladeadresse=HEX\n";
    }
    print "\n";
    print "  Der Aufrufstapel unaufgeloest, damit er wenigstens festgehalten ist:\n";
    printf("    %s\n", $_->{roh}) for @rahmen;
    print "    (kein Aufrufstapel im Bericht)\n" unless @rahmen;
    print "\n";
    next;
  }

  printf("  Eudora.exe geladen an %s, Groesse %s  (%s)\n",
         h8($eudora->{basis}), h8($eudora->{groesse}), $quelle);
  printf("  Verschiebung gegenueber der Karte: %s%s\n",
         ($eudora->{basis} >= $karte->{basis} ? '+' : '-'),
         h8(abs($eudora->{basis} - $karte->{basis})));
  print "\n";

  unless (@rahmen) {
    print "  Im Bericht steht kein Aufrufstapel.\n\n";
    next;
  }

  # ---- Aufloesen
  my (@zeilen_aus, @zum_undname);
  my $i = 0;
  my @arbeit = @rahmen;
  my $eip_vorn = 0;
  if (defined $kopf->{eip} and not (@rahmen and $rahmen[0]{adr} == $kopf->{eip})) {
    unshift @arbeit, { seg => ($kopf->{eip_seg} || ''), adr => $kopf->{eip},
                       modul => '', roh => '(Fehleradresse)', eip => 1 };
    $eip_vorn = 1;
  }

  for my $r (@arbeit) {
    $i++;
    my $marke = $r->{eip} ? 'EIP' : sprintf('#%02d', $i - $eip_vorn);
    my $kopfzeile = sprintf('  %-4s %s', $marke, h8($r->{adr}));

    # Welchem Modul gehoert die Adresse? Die Tabelle entscheidet, nicht der
    # Text im Bericht - der nennt bei unbekannten Adressen gern <UNKNOWN>.
    my $treffer;
    for my $m (@$module) {
      next unless $m->{groesse};
      $treffer = $m if $r->{adr} >= $m->{basis} and $r->{adr} < $m->{basis} + $m->{groesse};
    }
    my $ist_eudora = ($treffer and lc($treffer->{name}) eq 'eudora.exe') ? 1 : 0;
    # Ohne Tabelleneintrag (etwa bei --ladeadresse ohne Groesse) hilft der
    # Bereich der Karte weiter.
    if (not $treffer and not @$module) {
      my $spanne = $karte->{letzte} - $karte->{basis} + 0x10000;
      $ist_eudora = 1 if $r->{adr} >= $eudora->{basis}
                     and $r->{adr} <  $eudora->{basis} + ($eudora->{groesse} || $spanne);
    }

    unless ($ist_eudora) {
      if ($treffer) {
        push @zeilen_aus, sprintf("%s  %s  Versatz %s\n%s",
          $kopfzeile, $treffer->{name}, h8($r->{adr} - $treffer->{basis}),
          "       Fremdmodul - dafuer liegt hier keine Karte vor, nicht aufgeloest.\n");
      }
      else {
        my $laut = $r->{modul} ? " Der Bericht nennt dazu: $r->{modul}." : '';
        push @zeilen_aus, sprintf("%s  ---\n%s",
          $kopfzeile,
          "       Keinem geladenen Modul zuzuordnen (freigegebener Speicher, JIT-Code\n"
        . "       oder ein zerstoerter Stapel).$laut Nicht aufgeloest.\n");
      }
      next;
    }

    my $versatz = $r->{adr} - $eudora->{basis};
    my $va      = $karte->{basis} + $versatz;
    my $idx     = suche($karte->{namen}, $va);

    if (not defined $idx) {
      push @zeilen_aus, sprintf("%s  Eudora.exe  Versatz %s\n%s",
        $kopfzeile, h8($versatz),
        "       Liegt VOR dem ersten Namen der Karte (" . h8($karte->{erste} - $karte->{basis})
        . ") - im Kopf des Bildes.\n"
        . "       Nicht aufloesbar. Passt die Karte zu diesem Bau?\n");
      next;
    }

    my @kandidaten = gleichadressig($karte->{namen}, $idx);
    my $abstand    = $va - $kandidaten[0][0];
    my $erster     = $kandidaten[0];
    push @zum_undname, map { $_->[1] } @kandidaten;

    my $text = sprintf("%s  Eudora.exe  Versatz %s\n", $kopfzeile, h8($versatz));
    $text .= sprintf("       %s + 0x%X   [%s]\n", $erster->[1], $abstand, $erster->[3]);
    if (@kandidaten > 1) {
      $text .= sprintf("       an derselben Adresse zusammengefaltet: %s\n",
                       join(', ', map { $_->[1] } @kandidaten[1 .. $#kandidaten]));
    }
    if ($va > $karte->{letzte}) {
      $text .= "       ACHTUNG: hinter dem letzten Namen der Karte - der Name oben ist\n"
             . "       nur der naechstliegende und vermutlich falsch. Karte pruefen.\n";
    }
    elsif ($abstand > 0x10000) {
      $text .= sprintf("       ACHTUNG: %d Bytes hinter dem Namen - das ist zu weit fuer eine\n"
                     . "       Funktion. Stammt die Karte wirklich aus diesem Bau?\n", $abstand);
    }
    elsif (not $erster->[2]) {
      $text .= "       ACHTUNG: das ist kein Funktionssymbol (kein 'f' in der Karte),\n"
             . "       sondern Daten. Die Zuordnung ist damit fragwuerdig.\n";
    }
    else { $aufgeloest_gesamt++ }
    push @zeilen_aus, $text;
  }

  my $lesbar = $undname ? undname_fragen($undname, do { my %s; grep { !$s{$_}++ } @zum_undname }) : {};

  print "  Aufrufstapel:\n\n";
  for my $t (@zeilen_aus) {
    if (%$lesbar) {
      $t =~ s{^(       )(\S+)( \+ 0x[0-9A-F]+   \[[^\]]*\]\n)}
             { my $l = $lesbar->{$2};
               "$1$2$3" . (defined $l ? "       lesbar: $l\n" : '') }gme;
    }
    print $t;
  }
  print "\n";
}

if ($aufgeloest_gesamt) {
  print "$aufgeloest_gesamt Adresse(n) einem Funktionsnamen zugeordnet.\n";
  print "Gegenprobe nicht vergessen: die Karte muss aus demselben Bau stammen wie die\n";
  print "abgestuerzte Eudora.exe. Sonst stimmen die Namen nur zufaellig.\n";
  exit 0;
}
print "KEINE Adresse aufgeloest. Siehe die Begruendung oben - geraten wird nicht.\n";
exit 2;
