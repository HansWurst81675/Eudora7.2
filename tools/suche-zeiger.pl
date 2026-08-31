use strict; use warnings;
#
# Sucht: ein Zeiger wird auf NULL geprueft und danach AUSSERHALB des
# geschuetzten Blocks dereferenziert, ohne dass dazwischen erneut geprueft wird.
#
#   perl tools/suche-zeiger.pl <datei> [...]
#
# Damit wurde Befund P-2 gefunden (QCWorkerSocket.cpp:2050).
#
# DREI FILTER, GEMESSEN STATT GERATEN (Befund X-1 -> behoben 31.08.2026)
#
# X-1 hat dem Werkzeug 345 Treffer und in einer Stichprobe von 15 genau 15
# Fehlalarme nachgewiesen und drei strukturelle Ursachen benannt. Nachgemessen
# an 3295 Dateien: 347 Treffer, und die Verteilung der Abstaende zeigt die
# Ursachen unmittelbar:
#
#   Abstand 1 Zeile   212     Abstand 11-20   29
#   Abstand 3-5         8     Abstand 21-40   28
#   Abstand 6-10       24     Abstand >40     46
#
# 1. DER KLAMMERLOSE if-RUMPF (212 Treffer, Abstand genau 1).
#    Bei "if (p)" ohne geschweifte Klammern ist die naechste Anweisung der
#    Rumpf - also genau der geschuetzte Bereich. Die alte Fassung setzte in
#    diesem Fall das Blockende auf die if-Zeile selbst und meldete damit den
#    Rumpf als ungeschuetzten Zugriff. Jetzt reicht der geschuetzte Bereich bis
#    zum Semikolon der folgenden Anweisung.
#
# 2. DER EINZEILIGE WAECHTER (16 Treffer).
#    "if (!p) return;" auf EINER Zeile: danach ist p garantiert nicht NULL, jeder
#    spaetere Zugriff ist in Ordnung. Die alte Fassung suchte das return nur in
#    den FOLGENDEN sechs Zeilen, nicht auf der if-Zeile selbst.
#
# 3. DIE ABGESCHNITTENE BLOCKENDE-SUCHE (der Grossteil der 46 weiten Treffer).
#    X-1 nennt als Ursache "Abstand groesser als das Fenster von 40 Zeilen".
#    Nachgesehen ist es genauer: die Suche nach dem Blockende lief nur 40 Zeilen
#    weit. Ist der geschuetzte Block laenger, landete das vermeintliche Blockende
#    MITTEN darin, und der gemeldete Zugriff stand in Wahrheit noch INNERHALB des
#    Blocks (nachgesehen an WizardImportPage.cpp:126 und ImapAccount.cpp:3152).
#    Die Blockende-Suche hat jetzt keine Fenstergrenze mehr, nur eine Notbremse.
#
#    ACHTUNG, nicht jeder weite Treffer ist falsch: WizardImportPage.cpp:379
#    schliesst seinen Block bei 411 und greift bei 420 wirklich ungeschuetzt zu.
#    Solche Faelle sollen gemeldet werden - deshalb kein Abstandsfilter.
#
# DREI WEITERE FILTER, aus einer Stichprobe von 15 am 31.08.2026 abgeleitet
#
# Nach den ersten drei Filtern blieben 88 Treffer, und in einer Stichprobe von
# 15 (dieselbe Methode wie X-1) waren 11 Fehlalarm. Von Hand nachgelesen hatten
# sie genau drei Ursachen:
#
# 4. DER else-ZWEIG NACH EINEM NEGIERTEN WAECHTER (4 der 11).
#    "if (!p) { ... } else { hier ist p garantiert nicht NULL }". Bei einem
#    NEGIERTEN Waechter wird der else-Zweig deshalb uebersprungen.
#    Beim POSITIVEN Waechter gilt das Gegenteil - dort ist p im else-Zweig
#    NULL, und ein Zugriff waere ein echter Fehler. Der bleibt gemeldet.
#
# 5. ZUWEISUNG AN DEN ZEIGER (4 der 11).
#    "if (!pCDC) { pCDC = &dc; }" - danach ist der Zeiger belegt. Wird dem
#    Zeiger zwischen Pruefung und Zugriff etwas zugewiesen, ist die Pruefung
#    gegenstandslos. Ein Schreibzugriff DURCH den Zeiger (p->feld = x) zaehlt
#    nicht als Zuweisung.
#
# 6. ERNEUTE PRUEFUNG, DIE DER ALTE AUSDRUCK NICHT SAH (2 der 11).
#    "return (pWnd) ? pWnd->WndProc(...)" - ternaer, kein if.
#    "if ( (n > 0) && pTocDoc && pTocDoc->IsImapToc() )" - der alte Ausdruck
#    verlangte [^)]* zwischen "if (" und dem Namen und scheiterte an der
#    ersten inneren Klammer. Jetzt zaehlt jede Pruefung des Namens in einer
#    Bedingung, auch nach && und vor ?.
#
# WAS DAS WERKZEUG NICHT KANN
#
# Es liest Text, nicht Semantik. Ein Zeiger, der ueber einen anderen Namen
# geprueft wurde, eine Pruefung in einer aufgerufenen Funktion, ein
# ASSERT/VERIFY als Pruefung - alles unsichtbar. Ein Treffer ist ein Hinweis
# zum Nachlesen, kein Befund.
#
my $FENSTER   = 40;      # Suchfenster NACH dem geschuetzten Bereich
my $MAX_BLOCK = 3000;    # Notbremse der Blockende-Suche
my $MAX_STMT  = 8;       # so weit wird das Semikolon des klammerlosen Rumpfs gesucht

for my $datei (@ARGV) {
  open(my $fh, '<:raw', $datei) or die "$datei: $!\n";
  local $/ = "\n";
  my @z = <$fh>; close $fh;
  chomp @z; s/\r$// for @z;

  # FILTER 8: Blockkommentare ausblenden. Ohne das meldete pngerror.c:255 einen
  # Zugriff, der in einem /* */-Kommentar steht. @z bleibt fuer die Ausgabe
  # unangetastet, gearbeitet wird auf @c.
  my @c = @z;
  my $imblock = 0;
  for my $k (0 .. $#c) {
    my $t = $c[$k];
    if ($imblock) {
      if ($t =~ m{\*/}) { $t =~ s{^.*?\*/}{}; $imblock = 0 } else { $t = '' }
    }
    $t =~ s{/\*.*?\*/}{}g;
    if ($t =~ m{/\*}) { $t =~ s{/\*.*$}{}; $imblock = 1 }
    # UND die Zeilenkommentare. Ohne das zaehlt eine geschweifte Klammer IM
    # KOMMENTAR als Blockende - ImapAccount.cpp:3123 schreibt "(\noselect}" in
    # einen // -Kommentar, und der Block schien dort zu schliessen. Beim
    # Nachlesen aller Treffer aufgefallen.
    $t =~ s{//.*$}{};
    $c[$k] = $t;
  }

  for my $i (0 .. $#c) {
    my $zeile = $c[$i];
    my ($name, $negiert);
    if ($zeile =~ /^\s*(?:\}\s*)?(?:else\s+)?if\s*\(\s*([A-Za-z_]\w*)\s*(?:!=\s*NULL\s*)?\)/) {
      ($name, $negiert) = ($1, 0);
    } elsif ($zeile =~ /^\s*(?:\}\s*)?(?:else\s+)?if\s*\(\s*!\s*([A-Za-z_]\w*)\s*\)/
          or $zeile =~ /^\s*(?:\}\s*)?(?:else\s+)?if\s*\(\s*([A-Za-z_]\w*)\s*==\s*NULL\s*\)/) {
      ($name, $negiert) = ($1, 1);
    } else { next; }

    next unless $name =~ /^(?:p[A-Z]|p[a-z]|m_p|fn|g_fn|q_fn|lp)/;

    if ($negiert) {
      # FILTER 2: der Ausstieg steht auf DERSELBEN Zeile - "if (!p) return;"
      my $rest = $zeile;
      $rest =~ s{//.*$}{};
      $rest =~ s/^.*?\)//;                      # alles bis zur schliessenden Klammer weg
      next if $rest =~ /\b(return|continue|break|goto|throw|ThrowError)\b/;

      my $abbruch = 0;
      for my $k ($i+1 .. $i+6) {
        last if $k > $#z;
        $abbruch = 1 if $z[$k] =~ /\b(return|continue|break|goto|throw|ThrowError)\b/;
        last if $z[$k] =~ /^\s*\}/ && $k > $i+1;
      }
      next if $abbruch;
    }

    # Ende des geschuetzten Bereichs bestimmen. ZUERST entscheiden, ob der Rumpf
    # ueberhaupt eine geschweifte Klammer hat - sonst laeuft die Klammersuche in
    # die naechste Funktion hinein und liefert ein Blockende, das es nicht gibt.
    # (Selbst eingebaut, als die 40-Zeilen-Grenze fiel, und beim Nachlesen aller
    # 25 Treffer am 31.08.2026 aufgefallen: ImapConnection.cpp:1916 meldete einen
    # Zugriff 95 Zeilen spaeter in einer ANDEREN Funktion.)
    my $rest = $c[$i]; $rest =~ s{//.*$}{}; $rest =~ s/^.*?\)//;
    my $mit_block;
    if    ($rest =~ /\{/)  { $mit_block = 1 }
    # FILTER 9: der klammerlose Rumpf ist selbst eine Steueranweisung -
    # "if (m_pcip) for (a=atts;*a;a++) { ... }". Dann gehoert der folgende Block
    # zu ihr, und alles darin ist geschuetzt (plist_parser.cpp:216).
    elsif ($rest =~ /^\s*(?:for|while|if|switch)\b/) { $mit_block = 1 }
    elsif ($rest =~ /\S/)  { $mit_block = 0 }      # Anweisung auf derselben Zeile
    else {
      my $j = $i + 1;
      $j++ while $j <= $#c and $c[$j] =~ /^\s*$/;
      $mit_block = ($j <= $#c and $c[$j] =~ /^\s*\{/) ? 1 : 0;
    }

    my $ende = $i;
    if ($mit_block) {
      my ($tiefe, $gestartet) = (0, 0);
      for my $k ($i .. $i + $MAX_BLOCK) {       # FILTER 3: keine Fenstergrenze
        last if $k > $#c;
        my $t = $c[$k];
        $tiefe += ($t =~ tr/{//); $gestartet = 1 if $tiefe > 0;
        $tiefe -= ($t =~ tr/}//);
        $ende = $k;
        last if $gestartet && $tiefe <= 0;
      }
      unless ($gestartet) {                     # keine Klammer gefunden: zurueck
        $ende = $i;
        for my $k ($i+1 .. $i + $MAX_STMT) {
          last if $k > $#c;
          $ende = $k;
          last if $c[$k] =~ /;/;
        }
      }
    }
    else {
      # FILTER 1: klammerloser Rumpf. Die folgende Anweisung IST der geschuetzte
      # Bereich - sie reicht bis zu ihrem Semikolon.
      unless ($rest =~ /;/) {
        for my $k ($i+1 .. $i + $MAX_STMT) {
          last if $k > $#c;
          $ende = $k;
          last if $c[$k] =~ /;/;
        }
      }
    }

    # FILTER 4: der else-Zweig eines NEGIERTEN Waechters. Dort ist der Zeiger
    # garantiert belegt. Beim positiven Waechter gilt das Gegenteil - dort wird
    # nicht uebersprungen.
    my $ueberspringen = 0;
    if ($negiert) {
      # Die GANZE else-Kette ueberspringen, nicht nur den ersten Zweig:
      # "if (!p) {..} else if (..) {..} else if (..) { hier steckte der
      # Fehlalarm }" - nachgemessen an TridentReadMessageView.cpp:1719.
      while (1) {
        my $j = $ende + 1;
        $j++ while $j <= $#c and $c[$j] =~ /^\s*$/;
        last if $j > $#c;
        last unless $c[$j] =~ /^\s*\}?\s*else\b/;
        my ($t2, $g2) = (0, 0);
        for my $k ($j .. $j + $MAX_BLOCK) {
          last if $k > $#c;
          my $t = $c[$k];
          $t2 += ($t =~ tr/{//); $g2 = 1 if $t2 > 0;
          $t2 -= ($t =~ tr/}//);
          $ende = $k;
          last if $g2 && $t2 <= 0;
        }
        unless ($g2) { $ueberspringen = 1; last }   # klammerloses else
      }
    }
    next if $ueberspringen;

    # Einrueckung des Waechters - Grundlage von Filter 7 und 10.
    my ($einr) = $c[$i] =~ /^(\s*)/;
    my $tief = length $einr;

    for my $k ($ende+1 .. $ende+$FENSTER) {
      last if $k > $#c;
      my $t = $c[$k];
      last if $t =~ /^[A-Za-z_][\w:~]*.*\(/ && $t !~ /^\s/;
      my ($e2) = $t =~ /^(\s*)/;
      # FILTER 7: ein else, das WENIGER tief steht als der Waechter, gehoert zu
      # einem AEUSSEREN if - was darin steht, hat mit unserem Zeiger nichts zu
      # tun. Genau daran scheiterten app.cpp:274-277 (vier Fehlalarme in einem
      # Rutsch: "if(m_pTimerList) ..." und der else des umgebenden if).
      #
      # ABSICHTLICH NICHT: jedes "}" auf geringerer Ebene als Abbruch nehmen.
      # Das war der erste Versuch und hat vier ECHTE Kandidaten mitgenommen
      # (ImapChecker.cpp:945, nickview.cpp:316/329, ImapStream.cpp:4002) - dort
      # laeuft der Weg nach dem Ende des umgebenden Bereichs weiter und greift
      # wirklich ungeschuetzt zu. Gemessen am Korpus der 29 nachgelesenen Faelle.
      last if $t =~ /^\s*\}?\s*else\b/ and length($e2) < $tief;
      # KEIN FILTER auf return/break/continue. Erster Versuch war: "ein return
      # auf oder ueber der Ebene des Waechters beendet den Weg". Gemessen falsch -
      # ImapChecker.cpp:945 hat sein "return hResult;" INNERHALB des umgebenden
      # Blocks, den man danach verlaesst; der Weg zum ungeschuetzten Zugriff in
      # Zeile 953 laeuft sehr wohl weiter. Der Filter entfernte einen Fehlalarm
      # (OLImportClass.cpp:2948) und toetete einen echten Fund. Ein Waechter, der
      # den echten Fall verliert, ist schlechter als einer, der einmal zu oft
      # ruft - deshalb bleibt er draussen.
      if ($t =~ /\b\Q$name\E\s*->/ || ($name =~ /^(?:fn|g_fn|q_fn)/ && $t =~ /\b\Q$name\E\s*\(/)) {
        my $erneut = 0;
        for my $m ($i .. $k) {
          my $u = $c[$m];
          # FILTER 6: jede erneute Pruefung, auch ternaer und in
          # zusammengesetzten Bedingungen
          $erneut = 1 if $m > $ende and $u =~ /(?:if|while|for)\s*\(.*\b\Q$name\E\b/;
          $erneut = 1 if $m > $ende and $u =~ /\b\Q$name\E\s*(?:&&|\?)/;
          # FILTER 5: dem Zeiger wurde etwas zugewiesen - die Pruefung ist
          # gegenstandslos. Ein Schreibzugriff DURCH den Zeiger zaehlt nicht.
          $erneut = 1 if $m > $i and $u =~ /\b\Q$name\E\s*=[^=]/;
        }
        next if $erneut;
        printf("%s:%d geprueft '%s' -> benutzt :%d (Abstand %d)\n",
               $datei, $i+1, $name, $k+1, $k - $i);
        my ($a,$b) = ($z[$i], $t); s/^\s+// for ($a,$b);
        printf("    %s\n    %s\n", $a, $b);
        last;
      }
    }
  }
}
