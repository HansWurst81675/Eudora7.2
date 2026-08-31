use strict; use warnings;
# Sucht: ein Zeiger wird auf NULL geprueft und danach ausserhalb des
# geschuetzten Blocks dereferenziert, ohne dass dazwischen erneut geprueft wird.
my $FENSTER = 40;

for my $datei (@ARGV) {
  open(my $fh, '<:raw', $datei) or die "$datei: $!\n";
  local $/ = "\n";
  my @z = <$fh>; close $fh;
  chomp @z; s/\r$// for @z;

  for my $i (0 .. $#z) {
    my $zeile = $z[$i];
    my ($name, $negiert);
    if ($zeile =~ /^\s*(?:\}\s*)?(?:else\s+)?if\s*\(\s*([A-Za-z_]\w*)\s*(?:!=\s*NULL\s*)?\)/) {
      ($name, $negiert) = ($1, 0);
    } elsif ($zeile =~ /^\s*(?:\}\s*)?(?:else\s+)?if\s*\(\s*!\s*([A-Za-z_]\w*)\s*\)/
          or $zeile =~ /^\s*(?:\}\s*)?(?:else\s+)?if\s*\(\s*([A-Za-z_]\w*)\s*==\s*NULL\s*\)/) {
      ($name, $negiert) = ($1, 1);
    } else { next; }

    next unless $name =~ /^(?:p[A-Z]|p[a-z]|m_p|fn|g_fn|q_fn|lp)/;

    if ($negiert) {
      my $abbruch = 0;
      for my $k ($i+1 .. $i+6) {
        last if $k > $#z;
        $abbruch = 1 if $z[$k] =~ /\b(return|continue|break|goto|throw|ThrowError)\b/;
        last if $z[$k] =~ /^\s*\}/ && $k > $i+1;
      }
      next if $abbruch;
    }

    my ($tiefe, $gestartet, $ende) = (0, 0, $i);
    for my $k ($i .. $i+$FENSTER) {
      last if $k > $#z;
      my $t = $z[$k]; $t =~ s{//.*$}{};
      $tiefe += ($t =~ tr/{//); $gestartet = 1 if $tiefe > 0;
      $tiefe -= ($t =~ tr/}//);
      $ende = $k;
      last if $gestartet && $tiefe <= 0;
    }
    $ende = $i unless $gestartet;

    for my $k ($ende+1 .. $ende+$FENSTER) {
      last if $k > $#z;
      my $t = $z[$k]; $t =~ s{//.*$}{};
      last if $t =~ /^[A-Za-z_][\w:~]*.*\(/ && $t !~ /^\s/;
      if ($t =~ /\b\Q$name\E\s*->/ || ($name =~ /^(?:fn|g_fn|q_fn)/ && $t =~ /\b\Q$name\E\s*\(/)) {
        my $erneut = 0;
        for my $m ($ende+1 .. $k) { $erneut = 1 if $z[$m] =~ /(?:if|while)\s*\([^)]*\b\Q$name\E\b/; }
        next if $erneut;
        printf("%s:%d geprueft '%s' -> benutzt :%d\n", $datei, $i+1, $name, $k+1);
        my ($a,$b) = ($z[$i], $t); s/^\s+// for ($a,$b);
        printf("    %s\n    %s\n", $a, $b);
        last;
      }
    }
  }
}
