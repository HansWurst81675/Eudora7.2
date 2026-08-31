use strict; use warnings;
#
# Sucht CString::ReleaseBuffer OHNE vorangehendes GetBuffer auf derselben
# Variablen - die Fehlerklasse hinter Befund E-11.
#
#   perl tools/releasebuffer-pruefen.pl                 # Baum Eudora71, nur Funde
#   perl tools/releasebuffer-pruefen.pl --alle          # auch die richtigen
#   perl tools/releasebuffer-pruefen.pl <pfad> [...]    # eigene Dateien/Ordner
#
# WARUM ES DIESES WERKZEUG GIBT
#
# eudora.cpp:3372 rief RegMailto.ReleaseBuffer(i) auf einem CRString, ohne
# vorher GetBuffer zu rufen. Unter VC6 war das gutmuetig: ReleaseBuffer(n)
# setzte einfach die Laenge. Bei MFC 14 ist CString ein referenzgezaehltes
# CStringT - ReleaseBuffer setzt einen exklusiv gesperrten Puffer voraus und
# schreibt in die gemeinsame Verwaltungsstruktur. Bei geteiltem Puffer zerstoert
# das fremde Daten. Der Absturz auf frischen Installationen kam von dort.
#
# Richtig ist ausschliesslich das Paar:
#     p = s.GetBuffer(n);  ...  s.ReleaseBuffer();
# Falsch ist jedes ReleaseBuffer ohne GetBuffer auf DERSELBEN Variablen. Am
# gefaehrlichsten sind die mit einer LAENGE als Argument: dort will jemand
# kuerzen, und das gehoert s = s.Left(n).
#
# EINSTUFUNG
#   ok           GetBuffer auf derselben Variablen steht vorher in derselben Funktion
#   falsch       kein GetBuffer, UND ein Argument uebergeben (kuerzt) - hoechste Prioritaet
#   lockbuffer   davor steht LockBuffer, nicht GetBuffer. Der richtige Partner von
#                LockBuffer ist UnlockBuffer, nicht ReleaseBuffer - eigener Fall
#   verdaechtig  kein GetBuffer, kein Argument
#   danach       GetBuffer steht erst NACH dem ReleaseBuffer - falsche Reihenfolge
#
# GRENZEN, damit niemand die Ausgabe fuer mehr nimmt als sie ist
#   * Der Funktionsanfang wird ueber die naechste schliessende Klammer in
#     Spalte 1 rueckwaerts geschaetzt (VC6-Stil, in diesem Baum durchgehend).
#     Fehlt sie, wird bei $MAX_RUECK Zeilen abgebrochen und das mit "?" in der
#     Spalte Funktion vermerkt.
#   * Der Empfaenger wird als Text verglichen, nicht semantisch: s und
#     m_str.s gelten als verschieden, GetBuffer ueber einen Zeiger auf dasselbe
#     Objekt wird nicht erkannt.
#   * Makros und Kommentare in /* */ werden uebersprungen, Zeichenketten nicht.
#   * Ein ReleaseBuffer OHNE Empfaenger laeuft auf this - der Empfaenger heisst
#     dann "this", und gesucht wird ein GetBuffer ebenfalls ohne Empfaenger.
#
# Rueckgabe: 1 wenn mindestens ein "falsch" gefunden wurde, sonst 0.
#
# Bewusst ohne Escape-Sequenzen fuer Steuerzeichen geschrieben.

my $CR = chr(13);
my $MAX_RUECK = 400;

my (@ziele, $alle);
for my $a (@ARGV) {
  if    ($a eq '--alle')  { $alle = 1 }
  elsif ($a =~ /^--/)     { die "unbekannte Option: $a\n" }
  else                    { push @ziele, $a }
}
@ziele = ('Eudora71') unless @ziele;

my @dateien;
for my $z (@ziele) {
  if (-d $z) { push @dateien, sammle($z) }
  elsif (-f $z) { push @dateien, $z }
  else { die "nicht gefunden: $z\n" }
}
die "keine Quelldateien gefunden\n" unless @dateien;

sub sammle {
  my ($ordner) = @_;
  my @gefunden;
  my @stapel = ($ordner);
  while (@stapel) {
    my $d = pop @stapel;
    opendir(my $dh, $d) or next;
    for my $e (readdir $dh) {
      next if $e eq '.' or $e eq '..';
      my $p = "$d/$e";
      if (-d $p) { push @stapel, $p unless $e =~ /^(?:Build|Debug|Release|out32|\.git)$/ }
      elsif ($e =~ /\.(?:cpp|c|h|hpp|inl)$/i) { push @gefunden, $p }
    }
    closedir $dh;
  }
  return sort @gefunden;
}

# ---------------------------------------------------------------- Untersuchung

my @funde;
my %zaehler;

for my $datei (@dateien) {
  open(my $fh, '<:raw', $datei) or do { warn "$datei: $!\n"; next };
  local $/ = "\n";
  my @z = <$fh>;
  close $fh;
  chomp @z;
  for (@z) { s/\Q$CR\E$// }

  # Kommentarbloecke /* */ ausblenden, damit sie nicht als Code zaehlen
  my @code = @z;
  my $imblock = 0;
  for my $i (0 .. $#code) {
    my $t = $code[$i];
    if ($imblock) {
      if ($t =~ m{\*/}) { $t =~ s{^.*?\*/}{}; $imblock = 0 } else { $t = '' }
    }
    $t =~ s{/\*.*?\*/}{}g;
    if ($t =~ m{/\*}) { $t =~ s{/\*.*$}{}; $imblock = 1 }
    $t =~ s{//.*$}{};
    $code[$i] = $t;
  }

  for my $i (0 .. $#code) {
    my $zeile = $code[$i];
    next unless $zeile =~ /ReleaseBuffer\s*\(/;

    # Empfaenger: Name, Feldzugriff und Punkt/Pfeil-Ketten - oder gar keiner
    my $muster = qr/([A-Za-z_][A-Za-z0-9_]*(?:\s*\[[^\]]*\]|\s*(?:\.|->)\s*[A-Za-z_][A-Za-z0-9_]*)*)\s*(?:\.|->)\s*ReleaseBuffer\s*\(([^;]*?)\)/;
    my @treffer;
    my $rest = $zeile;
    while ($rest =~ /$muster/g) { push @treffer, [ $1, $2 ] }
    # ReleaseBuffer( ohne Empfaenger davor - also auf this
    my $ohne = $zeile;
    $ohne =~ s/$muster//g;
    while ($ohne =~ /(?<![A-Za-z0-9_>.])ReleaseBuffer\s*\(([^;]*?)\)/g) { push @treffer, [ 'this', $1 ] }

    for my $t (@treffer) {
      my ($empf, $arg) = @$t;
      $empf =~ s/\s+//g;
      $arg  =~ s/^\s+|\s+$//g;

      # Funktionsanfang rueckwaerts schaetzen
      my ($start, $sicher) = ($i, 1);
      my $k = $i - 1;
      while ($k >= 0 and $i - $k <= $MAX_RUECK) {
        if ($code[$k] =~ /^\}/) { last }
        $k--;
      }
      if ($k < 0)                 { $start = 0;    $sicher = 1 }
      elsif ($i - $k > $MAX_RUECK) { $start = $i - $MAX_RUECK; $sicher = 0 }
      else                        { $start = $k + 1 }

      # GetBuffer auf derselben Variablen davor?
      my ($vorher, $nachher, $lock) = (0, 0, 0);
      for my $m ($start .. $i - 1) {
        $vorher = $m + 1 if passt($code[$m], $empf, 'GetBuffer(?:SetLength)?');
        $lock   = $m + 1 if passt($code[$m], $empf, 'LockBuffer');
      }
      unless ($vorher) {
        for my $m ($i .. ($i + 60 > $#code ? $#code : $i + 60)) {
          next if $m == $i and $code[$m] =~ /ReleaseBuffer/ and not passt($code[$m], $empf);
          if (passt($code[$m], $empf, 'GetBuffer(?:SetLength)?')) { $nachher = $m + 1; last }
        }
      }

      my $grad = $vorher            ? 'ok'
               : $lock              ? 'lockbuffer'
               : $nachher           ? 'danach'
               : length($arg)       ? 'falsch'
               :                      'verdaechtig';
      $zaehler{$grad}++;

      my $roh = $z[$i];
      $roh =~ s/^\s+|\s+$//g;
      push @funde, {
        grad => $grad, datei => $datei, zeile => $i + 1, empf => $empf,
        arg => $arg, roh => $roh, vorher => $vorher, nachher => $nachher,
        lock => $lock, sicher => $sicher,
      };
    }
  }
}

sub passt {
  my ($text, $empf, $ruf) = @_;
  return 0 unless $text =~ /$ruf\s*\(/;
  my $t = $text;
  $t =~ s/\s+//g;
  return $t =~ /(?<![A-Za-z0-9_>.])$ruf\(/ ? 1 : 0 if $empf eq 'this';
  return $t =~ /\Q$empf\E(?:\.|->)$ruf\(/ ? 1 : 0;
}

# ------------------------------------------------------------------- Ausgabe

my %rang = (falsch => 0, lockbuffer => 1, danach => 2, verdaechtig => 3, ok => 4);
@funde = sort { $rang{$a->{grad}} <=> $rang{$b->{grad}}
             || $a->{datei} cmp $b->{datei}
             || $a->{zeile} <=> $b->{zeile} } @funde;

my $gesamt = scalar @funde;
printf("%d Vorkommen von ReleaseBuffer in %d Dateien untersucht.\n\n",
       $gesamt, scalar @dateien);

for my $f (@funde) {
  next if $f->{grad} eq 'ok' and not $alle;
  my $wo = $f->{sicher} ? '' : '  [Funktionsanfang unsicher]';
  printf("%-11s %s:%d  %s%s\n", $f->{grad}, $f->{datei}, $f->{zeile}, $f->{empf}, $wo);
  printf("            %s\n", $f->{roh});
  printf("            GetBuffer davor in Zeile %d\n", $f->{vorher})  if $f->{vorher};
  printf("            LockBuffer in Zeile %d - richtig waere UnlockBuffer()\n", $f->{lock}) if $f->{lock};
  printf("            GetBuffer erst in Zeile %d - falsche Reihenfolge\n", $f->{nachher}) if $f->{nachher};
  print("\n");
}

print("Einstufung:\n");
for my $g (qw(falsch lockbuffer danach verdaechtig ok)) {
  printf("  %-11s %4d\n", $g, $zaehler{$g} || 0);
}
print("\nEin \"falsch\" gehoert einzeln angesehen. Kuerzen heisst  s.Truncate(n)\n");
print("(so ist E-11 in eudora.cpp:3372 behoben) oder  s = s.Left(n).\n");
print("Ein \"ok\" ist das richtige Paar GetBuffer/ReleaseBuffer und bleibt.\n");

exit((($zaehler{falsch} || 0) + ($zaehler{lockbuffer} || 0)) ? 1 : 0);
