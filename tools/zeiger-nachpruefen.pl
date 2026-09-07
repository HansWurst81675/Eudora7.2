use strict; use warnings;
#
# zeiger-nachpruefen.pl - sucht die Fehlerklasse von E-18, E-22 und E-32:
# ein Zeiger wird an EINER Stelle auf NULL geprueft und an der NAECHSTEN
# ungeprueft benutzt.
#
#   perl tools/zeiger-nachpruefen.pl <datei|verzeichnis> [...]
#   perl tools/zeiger-nachpruefen.pl -kurz <...>     nur Datei:Zeile:Name
#
# Rueckgabe: 0 = kein Treffer, 1 = Treffer, 2 = Aufrufproblem.
# Selbsttests: perl tools/zeiger-nachpruefen-tests.pl
#
# WARUM NOCH EIN WERKZEUG NEBEN tools/suche-zeiger.pl
#
# suche-zeiger.pl gibt es schon und ist gegen Fehlalarme gehaertet
# (Befund X-1). Es hat aber E-32 NICHT gefunden, obwohl E-32 genau seine
# Fehlerklasse ist. Nachgemessen an der Fassung von headervw.cpp VOR der
# Behebung (git show HEAD~2:Eudora71/Eudora/headervw.cpp): suche-zeiger.pl
# meldet dort nur Zeile 560, nicht die E-32-Stelle bei 287/294.
# Zwei Ursachen, beide hier abgestellt:
#
# 1. EIN ZUGRIFF IN EINER BEDINGUNG IST KEINE PRUEFUNG.
#    suche-zeiger.pl zaehlt (Filter 6 seiner eigenen Beschreibung) "jede
#    Pruefung des Namens in einer Bedingung" als erneute Absicherung. Bei
#    E-32 steht der ungepruefte Zugriff aber SELBST in einer Bedingung:
#        if (GetIniShort(...) && pField->IsKindOf(...))
#    Das ist ein ZUGRIFF, wurde aber als Pruefung gewertet - und hat den
#    echten Treffer verschluckt.
#    Hier gilt als Pruefung nur der NACKTE Name als Wahrheitswert:
#    X, !X, X == NULL, X != NULL, X == 0, X != 0. Folgt auf den Namen ein
#    -> oder ein . oder eine Klammer, ist es ein Zugriff, keine Pruefung.
#
# 2. KOMMENTARE UND ZEICHENKETTEN WERDEN AUSGEBLENDET.
#    In headervw.cpp steht heute ein Kommentarblock, der "if (pField && ...)"
#    im Klartext zitiert. Ein Werkzeug, das den Text nicht ausblendet, liest
#    daraus eine Pruefung. Hier werden Kommentare und Zeichenketten vor der
#    Auswertung zeilentreu durch Leerzeichen ersetzt.
#
# WIE FEHLALARME VERMIEDEN WERDEN
#
# Die Regeln sind absichtlich streng - lieber wenige belegte Treffer als
# eine lange Liste, die niemand mehr liest. Gemeldet wird nur, wenn ALLES
# zutrifft:
#
#   a) Der Name wird in DERSELBEN Funktion mindestens einmal nackt auf NULL
#      geprueft. Ein Zeiger, der nirgends geprueft wird, ist kein Treffer
#      DIESER Klasse (er kann trotzdem falsch sein - anderer Fund).
#   b) Der Zugriff steht NICHT im geschuetzten Bereich einer Pruefung. Der
#      geschuetzte Bereich ist bei "if (X) {...}" der Block, bei
#      "if (X) einzeiler;" die eine folgende Anweisung.
#   c) Nach "if (!X) return|break|continue|goto|throw|exit" gilt X fuer den
#      Rest der Funktion als geprueft - danach kein Treffer mehr.
#   d) Wird X zwischen Pruefung und Zugriff etwas ZUGEWIESEN (X = ...), ist
#      die Pruefung gegenstandslos. Ein Schreibzugriff DURCH X (X->y = ...)
#      zaehlt nicht als Zuweisung.
#   e) Zugriffe in ASSERT/VERIFY/TRACE/PutDebugLog zaehlen nicht - das sind
#      Diagnosemakros, die im Release verschwinden oder nichts anfassen.
#   f) Im else-Zweig eines NEGIERTEN Waechters ("if (!X) ... else ...") ist
#      X belegt - kein Treffer. Im else-Zweig eines POSITIVEN Waechters ist
#      X NULL, dort bleibt der Zugriff gemeldet.
#   g) Nur der Pfeilzugriff X-> zaehlt als Zugriff. sizeof(X), &X, f(X) und
#      X[i] zaehlen nicht - das haelt die Trefferliste belegbar.
#   h) Je Name und Funktionsrumpf wird nur der ERSTE Treffer gemeldet.
#
# WAS DAS WERKZEUG NICHT KANN
#
# Es liest Text, nicht Bedeutung. Eine Pruefung ueber einen anderen Namen,
# eine Pruefung in einer gerufenen Funktion, eine Zusicherung durch die
# Umgebung - alles unsichtbar. Ein Treffer ist ein Hinweis zum Nachlesen,
# kein Befund. Und es findet Zeiger NICHT, die nie geprueft werden; dafuer
# ist es nicht gebaut.

my $KURZ = 0;

# ---------------------------------------------------------------------------
# Kommentare und Zeichenketten zeilentreu ausblenden.
# ---------------------------------------------------------------------------
sub ausblenden {
    my ($text) = @_;
    my $aus = '';
    my $n   = length $text;
    my $i   = 0;
    my $hoch = chr(39);          # einfaches Anfuehrungszeichen
    while ($i < $n) {
        my $c = substr($text, $i, 1);
        my $z = substr($text, $i, 2);
        if ($z eq '/*') {                       # Blockkommentar
            $i += 2; $aus .= '  ';
            while ($i < $n && substr($text, $i, 2) ne '*/') {
                $aus .= (substr($text, $i, 1) eq "\n") ? "\n" : ' ';
                $i++;
            }
            if ($i < $n) { $aus .= '  '; $i += 2 }
            next;
        }
        if ($z eq '//') {                       # Zeilenkommentar
            while ($i < $n && substr($text, $i, 1) ne "\n") { $aus .= ' '; $i++ }
            next;
        }
        if ($c eq '"' || $c eq $hoch) {          # Zeichenkette / Zeichen
            my $ende = $c;
            $aus .= ' '; $i++;
            while ($i < $n) {
                my $d = substr($text, $i, 1);
                if ($d eq chr(92)) { $aus .= '  '; $i += 2; next }   # Gegenschraegstrich
                if ($d eq "\n")    { $aus .= "\n"; $i++; last }      # unbeendet
                $aus .= ' '; $i++;
                last if $d eq $ende;
            }
            next;
        }
        $aus .= $c; $i++;
    }
    return $aus;
}

# ---------------------------------------------------------------------------
# Funktionsrumpf finden: jede Klammer, die auf Tiefe 0 aufgeht.
# Liefert Paare [erste_zeile, letzte_zeile], 0-basiert.
# ---------------------------------------------------------------------------
sub rumpfgrenzen {
    my (@z) = @_;
    my @r;
    my $tiefe = 0;
    my $start;
    for my $i (0 .. $#z) {
        for my $c (split //, $z[$i]) {
            if ($c eq '{') {
                $tiefe++;
                $start = $i if $tiefe == 1;
            }
            elsif ($c eq '}') {
                $tiefe-- if $tiefe > 0;
                if ($tiefe == 0 && defined $start) {
                    push @r, [$start, $i];
                    undef $start;
                }
            }
        }
    }
    return @r;
}

# ---------------------------------------------------------------------------
# Ist $name in dieser Bedingung NACKT geprueft?
# Liefert 'positiv' (im Rumpf ist X belegt), 'negativ' (im Rumpf ist X NULL)
# oder undef.
# ---------------------------------------------------------------------------
sub pruefung_art {
    my ($bedingung, $name) = @_;
    return 'negativ' if $bedingung =~ /!\s*\Q$name\E(?![\w:.\[(>-])/;
    return 'negativ' if $bedingung =~ /(?<![\w:.>])\Q$name\E\s*==\s*(?:NULL|nullptr|0)(?![\w.])/;
    return 'positiv' if $bedingung =~ /(?<![\w:.>])\Q$name\E\s*!=\s*(?:NULL|nullptr|0)(?![\w.])/;
    # nackter Name als Wahrheitswert
    return 'positiv'
        if $bedingung =~ /(?:^|\(|&&|\|\||\?|,)\s*\Q$name\E\s*(?:\)|&&|\|\||\?|$)/;
    return undef;
}

# Zugriff X-> in dieser Zeile?
sub hat_zugriff {
    my ($zeile, $name) = @_;
    return $zeile =~ /(?<![\w:.>])\Q$name\E\s*->/ ? 1 : 0;
}

# Zuweisung AN den Zeiger (nicht durch ihn)?
sub zuweisung {
    my ($zeile, $name) = @_;
    return $zeile =~ /(?<![\w:.>])\Q$name\E\s*=(?!=)/ ? 1 : 0;
}

sub ist_diagnose {
    my ($zeile) = @_;
    return $zeile =~ /\b(?:ASSERT|ASSERT_VALID|VERIFY|TRACE\d?|_ASSERTE|PutDebugLog)\s*\(/ ? 1 : 0;
}

# ---------------------------------------------------------------------------
# Ende des geschuetzten Bereichs einer if-Zeile.
# Liefert (letzte_rumpfzeile, hat_else, else_ende), alle 0-basiert.
# ---------------------------------------------------------------------------
sub schutzbereich {
    my ($zref, $if_zeile, $rumpf_ende) = @_;
    my @z = @$zref;

    # Klammern der Bedingung auszaehlen
    my $offen = 0; my $gesehen = 0;
    my ($pos, $rest);
    ZEILE: for (my $i = $if_zeile; $i <= $rumpf_ende; $i++) {
        my $s = $z[$i];
        my $k = 0;
        if ($i == $if_zeile) {
            my $j = index($s, '(');
            $k = ($j < 0) ? 0 : $j;
        }
        for (; $k < length($s); $k++) {
            my $c = substr($s, $k, 1);
            if    ($c eq '(') { $offen++; $gesehen = 1 }
            elsif ($c eq ')') {
                $offen--;
                if ($gesehen && $offen <= 0) { $pos = $i; $rest = substr($s, $k + 1); last ZEILE }
            }
        }
    }
    return ($if_zeile, 0, $if_zeile) unless defined $pos;

    # Geschweifte Klammer hinter der Bedingung oder auf der naechsten Zeile?
    my $blockstart;
    if ($rest =~ /^\s*\{/) { $blockstart = $pos }
    elsif ($rest =~ /^\s*$/) {
        my $m = $pos + 1;
        $m++ while $m <= $rumpf_ende && $z[$m] =~ /^\s*$/;
        $blockstart = $m if $m <= $rumpf_ende && $z[$m] =~ /^\s*\{/;
    }

    if (defined $blockstart) {
        my $tiefe = 0; my $an = 0;
        for (my $m = $blockstart; $m <= $rumpf_ende; $m++) {
            my $s = ($m == $pos) ? $rest : $z[$m];
            for my $c (split //, $s) {
                if    ($c eq '{') { $tiefe++; $an = 1 }
                elsif ($c eq '}') {
                    $tiefe--;
                    if ($an && $tiefe == 0) { return ($m, elsezweig($zref, $m, $rumpf_ende)) }
                }
            }
        }
        return ($rumpf_ende, 0, $rumpf_ende);
    }

    # klammerloser Rumpf: bis zum Semikolon, hoechstens 12 Zeilen weit
    my $m = $pos;
    my $s = $rest;
    for (my $t = 0; $t < 12; $t++) {
        return ($m, elsezweig($zref, $m, $rumpf_ende)) if $s =~ /;/;
        $m++;
        last if $m > $rumpf_ende;
        $s = $z[$m];
    }
    $m = $rumpf_ende if $m > $rumpf_ende;
    return ($m, elsezweig($zref, $m, $rumpf_ende));
}

# Folgt auf Zeile $ende ein else-Zweig? Liefert (hat_else, else_ende).
sub elsezweig {
    my ($zref, $ende, $rumpf_ende) = @_;
    my @z = @$zref;

    my $start;
    my $rest = $z[$ende];
    $rest =~ s/^.*\}//;
    if ($rest =~ /\belse\b/) { $start = $ende }
    else {
        my $m = $ende + 1;
        $m++ while $m <= $rumpf_ende && $z[$m] =~ /^\s*$/;
        return (0, $ende) unless $m <= $rumpf_ende && $z[$m] =~ /^\s*\}?\s*else\b/;
        $start = $m;
    }

    my $tiefe = 0; my $an = 0;
    for (my $k = $start; $k <= $rumpf_ende; $k++) {
        my $s = $z[$k];
        $s =~ s/^.*\belse\b// if $k == $start;
        for my $c (split //, $s) {
            if    ($c eq '{') { $tiefe++; $an = 1 }
            elsif ($c eq '}') { $tiefe--; if ($an && $tiefe == 0) { return (1, $k) } }
        }
        return (1, $k) if !$an && $s =~ /;/;
    }
    return (1, $rumpf_ende);
}

# ---------------------------------------------------------------------------
# Eine Datei (oder einen Text) untersuchen.
# ---------------------------------------------------------------------------
sub datei_pruefen {
    my ($pfad, $inhalt) = @_;
    unless (defined $inhalt) {
        open my $f, '<', $pfad or do { warn "$pfad: $!\n"; return () };
        local $/; $inhalt = <$f>; close $f;
    }
    $inhalt =~ s/\r\n/\n/g;
    my @roh = split /\n/, $inhalt, -1;
    my @z   = split /\n/, ausblenden($inhalt), -1;
    my @treffer;

    for my $g (rumpfgrenzen(@z)) {
        my ($von, $bis) = @$g;
        next if $bis - $von < 2;

        # Kandidaten: Namen, die in diesem Rumpf mit -> benutzt werden
        my %kandidat;
        for my $i ($von .. $bis) {
            my $s = $z[$i];
            while ($s =~ /(?<![\w:.>])([A-Za-z_]\w*)\s*->/g) { $kandidat{$1} = 1 }
        }
        next unless %kandidat;

        for my $name (sort keys %kandidat) {
            # Pruefzeilen finden
            my @pruef;
            for my $i ($von .. $bis) {
                next unless $z[$i] =~ /(?<![\w:.>])\Q$name\E\b/;
                my $bed;
                if    ($z[$i] =~ /\b(?:if|while)\s*\((.*)$/)  { $bed = $1 }
                elsif ($z[$i] =~ /^\s*(?:&&|\|\|)(.*)$/)      { $bed = $1 }
                next unless defined $bed;
                my $art = pruefung_art($bed, $name);
                push @pruef, [$i, $art] if $art;
            }
            next unless @pruef;

            my @schutz;
            my $sicher_ab;
            for my $p (@pruef) {
                my ($zi, $art) = @$p;
                my ($ende, $hat_else, $else_ende) = schutzbereich(\@z, $zi, $bis);
                if ($art eq 'positiv') {
                    push @schutz, [$zi, $ende];
                }
                else {
                    my $raus = 0;
                    for my $k ($zi .. $ende) {
                        $raus = 1 if $z[$k] =~ /\b(?:return|break|continue|goto|throw|exit)\b/;
                    }
                    if ($raus && (!defined $sicher_ab || $ende < $sicher_ab)) { $sicher_ab = $ende }
                    push @schutz, [$zi, $else_ende] if $hat_else;
                }
            }

            my $erste = $pruef[0][0];
            for my $i ($von .. $bis) {
                next if $i <= $erste;
                next unless hat_zugriff($z[$i], $name);
                next if ist_diagnose($z[$i]);
                next if defined $sicher_ab && $i > $sicher_ab;
                my $drin = 0;
                for my $s (@schutz) { $drin = 1 if $i >= $s->[0] && $i <= $s->[1] }
                next if $drin;
                my $letzte = -1;
                for my $p (@pruef) { $letzte = $p->[0] if $p->[0] < $i && $p->[0] > $letzte }
                next if $letzte < 0;
                my $neu = 0;
                for my $k ($letzte .. $i - 1) { $neu = 1 if zuweisung($z[$k], $name) }
                next if $neu;
                push @treffer, {
                    Datei    => $pfad,
                    Zeile    => $i + 1,
                    Name     => $name,
                    Pruefung => $letzte + 1,
                    Text     => ($roh[$i]      // ''),
                    PText    => ($roh[$letzte] // ''),
                };
                last;
            }
        }
    }
    return @treffer;
}

# Einstieg fuer die Selbsttests
sub pruefe_text { my ($text) = @_; return datei_pruefen('(text)', $text) }

# ---------------------------------------------------------------------------
# Hauptteil
# ---------------------------------------------------------------------------
unless (caller) {
    my @ziele;
    for my $a (@ARGV) {
        if    ($a eq '-kurz') { $KURZ = 1 }
        elsif ($a =~ /^-/)    { print STDERR "unbekannte Angabe: $a\n"; exit 2 }
        else                  { push @ziele, $a }
    }
    unless (@ziele) {
        print STDERR "Aufruf: perl tools/zeiger-nachpruefen.pl [-kurz] <datei|verzeichnis> ...\n";
        exit 2;
    }
    my @dateien;
    for my $t (@ziele) {
        if (-d $t) { push @dateien, grep { -f } (glob("$t/*.cpp"), glob("$t/*.c"), glob("$t/*.h")) }
        else       { push @dateien, $t }
    }
    my @alle;
    push @alle, datei_pruefen($_) for @dateien;
    for my $t (@alle) {
        if ($KURZ) { printf "%s:%d:%s\n", $t->{Datei}, $t->{Zeile}, $t->{Name}; next }
        printf "%s:%d  %s geprueft in Zeile %d, hier ungeprueft benutzt\n",
               $t->{Datei}, $t->{Zeile}, $t->{Name}, $t->{Pruefung};
        for my $paar ([$t->{Pruefung}, $t->{PText}], [$t->{Zeile}, $t->{Text}]) {
            my $s = $paar->[1]; $s =~ s/^\s+//; $s =~ s/\s+$//;
            printf "    %5d  %s\n", $paar->[0], $s;
        }
    }
    printf "\n%d Treffer in %d Dateien.\n", scalar(@alle), scalar(@dateien);
    exit(@alle ? 1 : 0);
}

1;
