#!/usr/bin/perl
#
# Testsammlung fuer tools/absturz-auswerten.pl.
#
#   perl tools/absturz-auswerten-tests.pl          # alle Faelle
#   perl tools/absturz-auswerten-tests.pl -v       # zusaetzlich die Ausgabe
#
# WARUM ES DIESE SAMMLUNG GIBT
#
# Das Werkzeug hat genau eine Aufgabe, an der es scheitern kann, ohne dass es
# auffaellt: einen FALSCHEN Funktionsnamen ausgeben. Am 06.09.2026 ist genau
# das passiert - gerechnet wurde gegen die vorgesehene Ladeadresse statt gegen
# die tatsaechliche, und heraus kam ein Name aus dem Ressourcenbereich, der
# ueberzeugend aussah. Ein falscher Name schickt die Fehlersuche in die
# falsche Datei; kein Name schickt sie wenigstens nirgendwohin.
#
# Deshalb prueft jeder Fall hier zweierlei: dass das Richtige DASTEHT und -
# ebenso wichtig - dass das Falsche NICHT dasteht.
#
# WIE SIE ARBEITET
#
# Jeder Fall baut sich seine eigene kuenstliche Karte und seinen eigenen
# kuenstlichen Bericht in einem Wegwerf-Verzeichnis. Es wird nichts gebaut,
# nichts gestartet und nichts im Arbeitsbaum angefasst. Geprueft werden der
# Rueckgabewert und der Text der Ausgabe.
#
#   0 = etwas aufgeloest    1 = Aufruf-/Dateifehler    2 = nichts aufloesbar
#
use strict;
use warnings;
use FindBin;
use File::Temp qw(tempdir);
use File::Spec;

my $laut     = grep { $_ eq '-v' } @ARGV;
my $WERKZEUG = "$FindBin::Bin/absturz-auswerten.pl";
-f $WERKZEUG or die "Werkzeug nicht gefunden: $WERKZEUG\n";

my $CRLF = chr(13) . chr(10);

# ---------------------------------------------------------------- Bausteine

sub schreib {
  my ($pfad, $bytes) = @_;
  open(my $f, '>:raw', $pfad) or die "schreiben $pfad: $!\n";
  print $f $bytes;
  close $f;
}

# Eine kuenstliche Zuordnungsdatei im Format von MSVC. Absichtlich mit dabei:
#   - ein absolutes Symbol in Abschnitt 0000 (darf NIE als Treffer erscheinen)
#   - zwei Namen an derselben Adresse (der Binder faltet gleiche Rumpfe)
#   - ein Datensymbol ohne 'f'
sub karte_bauen {
  my ($pfad) = @_;
  my @z = (
    ' Eudora',
    '',
    ' Timestamp is 6a9d3c9b (Sun Sep  6 12:12:43 2026)',
    '',
    ' Preferred load address is 00400000',
    '',
    ' Start         Length     Name                   Class',
    ' 0001:00000000 0000e390H .text                   CODE',
    ' 0002:00000000 000027acH .idata$5                DATA',
    '',
    '  Address         Publics by Value              Rva+Base       Lib:Object',
    '',
    ' 0000:00000000       ___AbsoluteZero            00000000     <absolute>',
    ' 0000:00000000       ___guard_eh_cont_count     00000000     <absolute>',
    ' 0001:00001000       ?Alpha@@YAXXZ              00401000 f   alpha.obj',
    ' 0001:00001100       ?Beta@@YAXXZ               00401100 f   beta.obj',
    ' 0001:00001100       ?BetaZwilling@@YAXXZ       00401100 f   beta.obj',
    ' 0001:00002000       ?Gamma@@YAXXZ              00402000 f   gamma.obj',
    ' 0002:00000000       ?DatenTopf@@3HA            00412000     daten.obj',
    '',
    ' entry point at        0001:00001000',
    '',
  );
  schreib($pfad, join($CRLF, @z) . $CRLF);
}

# Ein kuenstlicher Absturzbericht. $module ist eine Liste von Zeilen fuer die
# Modultabelle (leere Liste = keine Tabelle, wie in jedem Bericht bis 7.2.0.12),
# @adressen sind die Zeilen des Aufrufstapels.
sub bericht_bauen {
  my (%p) = @_;
  my @z = (
    '//=====================================================',
    'Sun Sep  6 00:32:43 2026',
    ($p{fassung} || '7.2.0.12'),
    '',
  );
  if ($p{module} and @{$p{module}}) {
    push @z,
      'Loaded modules - subtract the load address from a stack address to get',
      'the offset listed in the .map file of that module:',
      'Load address  Size      Module',
      @{$p{module}},
      '';
  }
  push @z,
    'Eudora.exe caused an EXCEPTION_ACCESS_VIOLATION in module',
    '<UNKNOWN> at 0023:' . ($p{eip} || '00921110'),
    '',
    'Registers:',
    'EAX=05E471A0  EBX=6FB509B0  ECX=0622DE58  EDX=05D06AC0  ESI=05FF8D58',
    '',
    'Call stack (Extended Info):',
    'Address       Possible Params                               Location';
  push @z, @{$p{stapel}};
  push @z, '';
  schreib($p{pfad}, join($CRLF, @z) . $CRLF);
}

# Ruft das Werkzeug ohne Shell auf und faengt seine Ausgabe ein.
sub lauf {
  my (@arg) = @_;
  my $tmp = File::Spec->catfile(p_temp(), 'ausgabe.txt');
  open(my $alt, '>&', \*STDOUT) or die "dup: $!\n";
  open(STDOUT, '>', $tmp)       or die "umlenken: $!\n";
  my $rueck = system($^X, $WERKZEUG, @arg);
  open(STDOUT, '>&', $alt);
  open(my $f, '<', $tmp) or return (-1, '');
  local $/;
  my $text = <$f>;
  close $f;
  return ($rueck >> 8, defined $text ? $text : '');
}

my $TEMP;
sub p_temp { return $TEMP }

# ----------------------------------------------------------------- die Faelle
#
# muss     = diese Zeichenketten MUESSEN in der Ausgabe stehen
# darf_nie = diese duerfen NICHT darin stehen (Schutz gegen geratene Namen)

$TEMP = tempdir('absturz-tests-XXXXXX', TMPDIR => 1, CLEANUP => 1);
my $KARTE = File::Spec->catfile($TEMP, 'Eudora.map');
karte_bauen($KARTE);

my $KAPUTTE_KARTE = File::Spec->catfile($TEMP, 'kaputt.map');
schreib($KAPUTTE_KARTE, "das ist keine Zuordnungsdatei$CRLF");

my $LEER = File::Spec->catfile($TEMP, 'leer.log');
schreib($LEER, '');

# Eudora.exe liegt bei 00920000 (verschoben, ASLR), also
#   Versatz = Adresse - 00920000,  Kartenadresse = Versatz + 00400000.
# ?Beta@@YAXXZ steht bei 00401100, also Versatz 00001100, also Adresse
# 00921100. Plus 0x10 ergibt 00921110.
my @TABELLE = (
  '00920000      00010000  Eudora.exe',
  '6FB00000      00200000  mfc140.dll',
  '77390000      001A0000  USER32.dll',
);
my @STAPEL_EUDORA = (
  '0023:00921110 (0x05D06AD0 0x00000000 0x05F8B010 0x00000000) Eudora.exe',
  '0023:00922005 (0x00000001 0x00000000 0x011A0135 0x00000000) Eudora.exe',
);

my @faelle;

# --- 1: Bericht MIT Modultabelle. Der Normalfall ab 7.2.0.13.
{
  my $log = File::Spec->catfile($TEMP, 'mit-tabelle.log');
  bericht_bauen(pfad => $log, fassung => '7.2.0.13', module => \@TABELLE,
                eip => '00921110', stapel => \@STAPEL_EUDORA);
  push @faelle, {
    schl => '1', name => 'mit Modultabelle - Namen werden aufgeloest',
    arg  => [ $log, $KARTE, '--kein-undname' ], rueck => 0,
    muss => [ 'Eudora.exe geladen an 00920000',
              'Verschiebung gegenueber der Karte: +00520000',
              '?Beta@@YAXXZ + 0x10',
              '?BetaZwilling@@YAXXZ',          # gefaltete Zwillinge nennen
              '?Gamma@@YAXXZ + 0x5' ],
    darf_nie => [ '___AbsoluteZero', 'MODULTABELLE FEHLT' ],
  };
}

# --- 2: Bericht OHNE Modultabelle. Der Fall 7.2.0.12 - hier darf KEIN Name
#        fallen. Das ist der wichtigste Fall der ganzen Sammlung.
{
  my $log = File::Spec->catfile($TEMP, 'ohne-tabelle.log');
  bericht_bauen(pfad => $log, module => [], eip => '00921110',
                stapel => \@STAPEL_EUDORA);
  push @faelle, {
    schl => '2', name => 'ohne Modultabelle - klare Meldung, kein geratener Name',
    arg  => [ $log, $KARTE, '--kein-undname' ], rueck => 2,
    muss => [ 'MODULTABELLE FEHLT', 'ASLR', '7.2.0.13',
              '--ladeadresse', '00921110' ],
    darf_nie => [ '?Alpha@', '?Beta@', '?BetaZwilling@', '?Gamma@', '?DatenTopf@' ],
  };
}

# --- 3: Adresse aus einem Fremdmodul.
{
  my $log = File::Spec->catfile($TEMP, 'fremd.log');
  bericht_bauen(pfad => $log, module => \@TABELLE, eip => '6FB9A3E6',
                stapel => [
    '0023:6FB9A3E6 (0x05F8B010 0x00000000 0x6FB99B6D 0x00000000) mfc140.dll',
    '0023:773C1C0B (0x6FA77300 0x00000000 0x003402FE 0x00000000) USER32.dll',
  ]);
  push @faelle, {
    schl => '3', name => 'nur Fremdmodule - als fremd gekennzeichnet, nicht zugeordnet',
    arg  => [ $log, $KARTE, '--kein-undname' ], rueck => 2,
    muss => [ 'Fremdmodul', 'mfc140.dll  Versatz 0009A3E6',
              'USER32.dll  Versatz 00031C0B' ],
    darf_nie => [ '?Alpha@', '?Beta@', '?Gamma@' ],
  };
}

# --- 4: Adresse VOR dem ersten Namen der Karte (Kopf des Bildes).
{
  my $log = File::Spec->catfile($TEMP, 'vor-erstem.log');
  bericht_bauen(pfad => $log, module => \@TABELLE, eip => '00920500',
                stapel => [
    '0023:00920500 (0x00000000 0x00000000 0x00000000 0x00000000) Eudora.exe',
  ]);
  push @faelle, {
    schl => '4', name => 'Adresse vor dem ersten Namen - gemeldet, kein Absturz',
    arg  => [ $log, $KARTE, '--kein-undname' ], rueck => 2,
    muss => [ 'VOR dem ersten Namen der Karte', 'Versatz 00000500' ],
    darf_nie => [ '?Alpha@', '___AbsoluteZero' ],
  };
}

# --- 5: Adresse in gar keinem geladenen Modul (der echte Fall vom 06.09.2026:
#        EIP 414E3345 zeigte ins Leere).
{
  my $log = File::Spec->catfile($TEMP, 'kein-modul.log');
  bericht_bauen(pfad => $log, module => \@TABELLE, eip => '414E3345',
                stapel => [
    '0023:414E3345 (0x00000000 0x00000000 0x00000000 0x00000000) ',
    @STAPEL_EUDORA,
  ]);
  push @faelle, {
    schl => '5', name => 'Adresse ausserhalb aller Module - benannt, nicht zugeordnet',
    arg  => [ $log, $KARTE, '--kein-undname' ], rueck => 0,
    muss => [ 'Keinem geladenen Modul zuzuordnen', '414E3345', '?Beta@@YAXXZ + 0x10' ],
    darf_nie => [ '___AbsoluteZero' ],
  };
}

# --- 6: Bericht fehlt.
push @faelle, {
  schl => '6a', name => 'Bericht nicht vorhanden - verstaendliche Meldung, Rueckgabe 1',
  arg  => [ File::Spec->catfile($TEMP, 'gibtsnicht.log'), $KARTE ], rueck => 1,
  muss => [ 'FEHLER', 'nicht gefunden' ], darf_nie => [ '?Beta@' ],
};

# --- 6b: Karte fehlt.
{
  my $log = File::Spec->catfile($TEMP, 'mit-tabelle.log');
  push @faelle, {
    schl => '6b', name => 'Karte nicht vorhanden - verstaendliche Meldung, Rueckgabe 1',
    arg  => [ $log, File::Spec->catfile($TEMP, 'gibtsnicht.map') ], rueck => 1,
    muss => [ 'FEHLER', 'Zuordnungsdatei nicht gefunden' ], darf_nie => [ '?Beta@' ],
  };
}

# --- 6c: Karte unbrauchbar (kein Kopf).
{
  my $log = File::Spec->catfile($TEMP, 'mit-tabelle.log');
  push @faelle, {
    schl => '6c', name => 'Karte ohne Kopfzeile - Meldung statt falscher Rechnung',
    arg  => [ $log, $KAPUTTE_KARTE ], rueck => 1,
    muss => [ 'nicht auswertbar', 'Preferred load address' ], darf_nie => [ '?Beta@' ],
  };
}

# --- 6d: Bericht leer.
push @faelle, {
  schl => '6d', name => 'Bericht ist leer - Meldung, Rueckgabe 1',
  arg  => [ $LEER, $KARTE ], rueck => 1,
  muss => [ 'ist leer' ], darf_nie => [ '?Beta@' ],
};

# --- 7: Notbehelf --ladeadresse. Ohne Tabelle, aber mit belegter Ladeadresse
#        von der Aufrufzeile - dann ist es kein Raten mehr.
{
  my $log = File::Spec->catfile($TEMP, 'ohne-tabelle.log');
  push @faelle, {
    schl => '7', name => '--ladeadresse ersetzt die fehlende Tabelle',
    arg  => [ $log, $KARTE, '--ladeadresse=00920000', '--kein-undname' ], rueck => 0,
    muss => [ '?Beta@@YAXXZ + 0x10', 'Aufrufzeile' ],
    darf_nie => [ 'MODULTABELLE FEHLT' ],
  };
}

# --- 8: mehrere Berichte in einer Datei (Eudora haengt jeden Absturz an).
{
  my $a = File::Spec->catfile($TEMP, 'zwei.log');
  my $eins = File::Spec->catfile($TEMP, 'mit-tabelle.log');
  my $zwei = File::Spec->catfile($TEMP, 'ohne-tabelle.log');
  my $t = '';
  for my $q ($eins, $zwei) {
    open(my $f, '<:raw', $q) or die; local $/; $t .= <$f>; close $f;
  }
  schreib($a, $t);
  push @faelle, {
    schl => '8', name => 'zwei Berichte in einer Datei - beide ausgewertet',
    arg  => [ $a, $KARTE, '--kein-undname' ], rueck => 0,
    muss => [ 'Bericht 1 von 2', 'Bericht 2 von 2', '?Beta@@YAXXZ + 0x10',
              'MODULTABELLE FEHLT' ],
    darf_nie => [],
  };
  push @faelle, {
    schl => '8b', name => '--letzter wertet nur den letzten Bericht aus',
    arg  => [ $a, $KARTE, '--letzter', '--kein-undname' ], rueck => 2,
    muss => [ 'Bericht 1 von 1', 'MODULTABELLE FEHLT' ],
    darf_nie => [ '?Beta@@YAXXZ + 0x10' ],
  };
}

# --- 9: Hilfe.
push @faelle, {
  schl => '9', name => '--hilfe erklaert den Aufruf', arg => [ '--hilfe' ], rueck => 0,
  muss => [ 'Exception.log', 'Eudora.map', '--ladeadresse' ], darf_nie => [],
};

# --- 10: unbekannter Schalter.
push @faelle, {
  schl => '10', name => 'unbekannter Schalter - Meldung, Rueckgabe 1',
  arg  => [ '--gibtsnicht' ], rueck => 1, muss => [ 'unbekannte Angabe' ], darf_nie => [],
};

# --- 11: lesbare C++-Namen. Nur wenn undname.exe da ist; sonst uebersprungen,
#         denn das Werkzeug muss auch ohne Visual Studio brauchbar bleiben.
{
  my $log = File::Spec->catfile($TEMP, 'mit-tabelle.log');
  my ($r, $t) = lauf($log, $KARTE);
  my $hat_undname = ($t !~ /undname\.exe nicht gefunden/) ? 1 : 0;
  push @faelle, {
    schl => '11', name => 'undname.exe macht lesbare Namen daraus',
    arg  => [ $log, $KARTE ], rueck => 0,
    muss => [ 'lesbar: void __cdecl Beta(void)' ], darf_nie => [],
    ueberspringen => (!$hat_undname
      ? 'undname.exe nicht vorhanden - Zugabe, kein Muss' : undef),
  };
}

# ------------------------------------------------------------------ Ausfuehren

my ($gruen, $rot, $weg) = (0, 0, 0);
my @rote;

for my $f (@faelle) {
  if ($f->{ueberspringen}) {
    $weg++;
    printf("%-4s %-6s %-58s %s\n", $f->{schl}, 'WEG', $f->{name}, $f->{ueberspringen});
    next;
  }
  my ($rueck, $text) = lauf(@{$f->{arg}});
  my @maengel;
  push @maengel, "Rueckgabe $rueck statt $f->{rueck}" if $rueck != $f->{rueck};
  for my $m (@{$f->{muss}})     { push @maengel, "fehlt: $m"       if index($text, $m) < 0 }
  for my $m (@{$f->{darf_nie}}) { push @maengel, "steht drin: $m"  if index($text, $m) >= 0 }

  my $ok = @maengel ? 0 : 1;
  $ok ? $gruen++ : ($rot++, push @rote, $f);

  printf("%-4s %-6s %-58s Rueckgabe %d\n",
         $f->{schl}, $ok ? 'GRUEN' : 'ROT', $f->{name}, $rueck);
  print "       * $_\n" for @maengel;
  if ($laut or not $ok) {
    my $a = $text; $a =~ s/\s+$//; $a =~ s/^/       | /mg;
    print "$a\n";
  }
}

print '-' x 92, "\n";
printf("%d Faelle: %d gruen, %d rot, %d uebersprungen\n",
       scalar(@faelle), $gruen, $rot, $weg);
if ($rot) {
  print "\nROT: ", join(', ', map { $_->{schl} } @rote), "\n";
  print "Das Werkzeug entscheidet in diesen Faellen falsch. Solange ein Fall rot ist,\n";
  print "ist keiner seiner Namen zu glauben - ein falscher Name ist schlimmer als\n";
  print "gar keiner.\n";
  exit 1;
}
print "Das Werkzeug entscheidet in allen Faellen richtig.\n";
exit 0;
