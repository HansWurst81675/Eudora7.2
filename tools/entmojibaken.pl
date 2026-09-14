#!/usr/bin/perl
# Repariert doppelt (oder einfach) nach Latin-1 umkodierten UTF-8-Text.
#
# Das ist das Gegenstueck zu Regel 5 in pruefe-bytes.pl: die Schranke
# verhindert, dass der Schaden NEU entsteht, dieses Werkzeug macht ihn
# rueckgaengig, nachdem er eingetreten ist.
#
# Verfahren: jeder zusammenhaengende Lauf von Bytes >= 0x80 wird einzeln
# betrachtet. Fuer sich wird versucht, zwei Umkodierrunden zurueckzunehmen,
# dann eine. Nur wenn ein Rueckweg vollstaendig aufgeht UND lauter Zeichen
# ergibt, die in deutschem Fliesstext vorkommen duerfen, wird ersetzt.
# Ein sauberer Lauf - etwa das "ue" in "ueberholt" als echter Umlaut - geht
# auf keinem Rueckweg auf und bleibt damit unangetastet. Das ist die
# Eigenschaft, auf der die Sicherheit des Werkzeugs beruht.
#
# ACHTUNG, an BEFUNDE.md gemessen: manche Stellen zeigen kaputten Text
# ABSICHTLICH, als Beleg. In BEFUNDE.md sind das fuenf Zeilen zu E-85 und
# NP3-8 - eine steht woertlich hinter dem Wort "falsch", eine andere sagt,
# dort stuenden "zwei Zeichen". Wer die berichtigt, loescht den Beweis und
# macht den Satz sinnlos. Vor -schreiben darum immer erst den Probelauf
# ansehen und die Trefferzeilen lesen.
#
# Aufruf:  perl tools/entmojibaken.pl [-schreiben] <datei> ...
#          ohne -schreiben wird nur gezaehlt (Probelauf).
#
# Als Modul:  require 'tools/entmojibaken.pl';
#             my ($text, $treffer) = entmojibake_text($text);

use strict;
use warnings;
use Encode qw(decode encode);

# Nimmt eine Umkodierrunde zurueck: Bytes -> UTF-8-Text -> Latin-1-Bytes.
# Liefert undef, wenn der Weg nicht aufgeht.
sub entmojibake_runde_zurueck {
    my ($bytes) = @_;
    my $text = eval { decode('UTF-8', $bytes, Encode::FB_CROAK) };
    return undef unless defined $text;
    my $roh = eval { encode('ISO-8859-1', $text, Encode::FB_CROAK) };
    return undef unless defined $roh;
    return $roh;
}

# Prueft, ob die Bytes als UTF-8 lesbar sind und dabei nur Zeichen ergeben,
# die in deutschem Fliesstext vorkommen duerfen. Was hier durchfaellt, wird
# nicht angefasst - lieber eine Stelle stehen lassen als Text erfinden.
sub entmojibake_brauchbar {
    my ($bytes) = @_;
    my $text = eval { decode('UTF-8', $bytes, Encode::FB_CROAK) };
    return 0 unless defined $text;
    for my $z (split //, $text) {
        my $o = ord($z);
        next if $o < 0x80;
        next if $o >= 0xA0 && $o <= 0xFF;         # Umlaute, Akzente, ss
        next if $o >= 0x2010 && $o <= 0x203A;     # Striche, Anfuehrung, Auslassung
        next if $o == 0x20AC;                      # Eurozeichen
        next if $o >= 0x2190 && $o <= 0x21FF;      # Pfeile
        next if $o >= 0x2200 && $o <= 0x22FF;      # Minuszeichen, ungefaehr
        next if $o >= 0x2713 && $o <= 0x2718;      # Haken und Kreuze
        return 0;
    }
    return 1;
}

# Berichtigt einen ganzen Text. Liefert (neuer Text, Zahl der Laeufe).
sub entmojibake_text {
    my ($inhalt) = @_;
    return ($inhalt, 0) unless defined $inhalt;
    my $treffer = 0;

    $inhalt =~ s{([\x80-\xff]+)}{
        my $lauf = $1;
        my $neu  = $lauf;

        my $zwei = entmojibake_runde_zurueck($lauf);
        $zwei = entmojibake_runde_zurueck($zwei) if defined $zwei;

        if (defined $zwei && entmojibake_brauchbar($zwei)) {
            $neu = $zwei;
            $treffer++;
        } else {
            my $eins = entmojibake_runde_zurueck($lauf);
            if (defined $eins && entmojibake_brauchbar($eins)) {
                $neu = $eins;
                $treffer++;
            }
        }
        $neu;
    }ge;

    return ($inhalt, $treffer);
}

# Filtert aus den hinzugefuegten Zeilen eines Diffs alles heraus, was sich
# gegenueber einer entfernten Zeile NUR in der Kodierung unterscheidet.
#
# Wird von den pre-commit-Schranken gebraucht, die nur den ZUWACHS pruefen
# wollen. Am 14.09.2026 hat die Berichtigung von 1517 doppelt umkodierten
# Zeilen in BEFUNDE.md gleich zwei dieser Schranken ausgeloest
# (pruefe-behoben-belegt.pl 46-mal, pruefe-anzeigetext.pl 3-mal), obwohl
# kein einziges Urteil und kein einziges Zitat neu geschrieben wurde.
sub entmojibake_nur_kodierung_gefiltert {
    my ($alt, $neu) = @_;
    return @$neu unless @$alt && @$neu;
    my %war_schon;
    for my $a (@$alt) {
        my ($berichtigt) = entmojibake_text($a);
        $war_schon{$berichtigt} = 1;
    }
    return grep { !$war_schon{$_} } @$neu;
}

# ---------------------------------------------------------------------------
# Hauptlauf - nur, wenn direkt aufgerufen und nicht per require geladen
# ---------------------------------------------------------------------------
unless (caller) {
    my $schreiben = 0;
    my @dateien;
    for my $a (@ARGV) {
        if ($a eq '-schreiben') { $schreiben = 1 } else { push @dateien, $a }
    }
    die "Aufruf: perl tools/entmojibaken.pl [-schreiben] <datei> ...\n" unless @dateien;

    my $gesamt = 0;
    my $dateien_geschrieben = 0;

    for my $datei (@dateien) {
        open my $ein, '<:raw', $datei or die "kann $datei nicht lesen: $!\n";
        local $/;
        my $inhalt = <$ein>;
        close $ein;

        my $cr_vorher  = () = $inhalt =~ /\r/g;
        my $len_vorher = length $inhalt;

        my ($neu, $treffer) = entmojibake_text($inhalt);

        my $cr_nachher = () = $neu =~ /\r/g;

        printf "%-28s Laeufe %4d  CR %d->%d  Bytes %d->%d\n",
            $datei, $treffer, $cr_vorher, $cr_nachher, $len_vorher, length($neu);

        # Byte-Regel: die Zeilenenden duerfen sich nicht veraendern.
        die "  ABBRUCH: CR-Anzahl veraendert - nichts geschrieben\n"
            if $cr_vorher != $cr_nachher;

        if ($schreiben && $treffer) {
            open my $aus, '>:raw', $datei or die "kann $datei nicht schreiben: $!\n";
            print $aus $neu;
            close $aus;
            $dateien_geschrieben++;
        }
        $gesamt += $treffer;
    }

    printf "\n  %d Laeufe berichtigt%s\n", $gesamt,
        $schreiben ? sprintf(" in %d Dateien", $dateien_geschrieben)
                   : " (Probelauf, nichts geschrieben)";
}

1;
