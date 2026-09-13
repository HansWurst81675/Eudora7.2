#!/usr/bin/perl
use strict;
use warnings;

# pruefe-stand-md.pl - keine Datei, die einen Stand behauptet, den sie nicht hat.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Gregor am 11.09.2026, auf LEKTORAT.md zeigend:
#
#   "ist eins von MDs, ich fragte, ob alles aktualisiert ist, du sagst, ja.
#    war es der letzte 'Siebter Durchgang - 07.09.2026'? danach nichts mehr?"
#
# Meine Antwort "ja, alles aktualisiert" war falsch. Gemessen hatte ich die
# 21 Dateien, die doku-pruefen.pl kennt - im Repo liegen 47 MDs. Genau der
# Fehler, gegen den Arbeitsweise/pruefumfang-nicht-von-hand.md geschrieben
# wurde. Die Lehre stand da und hat nicht gewirkt, weil ihr das Werkzeug
# fehlte.
#
# Dazu Gregors Regel vom selben Tag:
#
#   "fuer mich ist es wichtig, dass es am ende (vor dem mergen) alles stimmt.
#    hinterher nachzuarbeiten ist bloed, musst du selbst machen."
#
# ---------------------------------------------------------------------------
# WAS ES PRUEFT
# ---------------------------------------------------------------------------
#
# 1. STANDDATEIEN. Jede .md, die in ihren ersten 20 Zeilen "Stand <Datum>"
#    schreibt, behauptet damit einen Gueltigkeitsanspruch. Ist dieses Datum
#    aelter als der juengste Vorgang im CHANGELOG, hinkt sie hinterher.
#
#    AUSGENOMMEN sind Verzeichnisse, in denen Vergangenes festgehalten wird:
#    Befunde/ (Berichte zu einem bestimmten Tag), Arbeitsweise/ (Lehren mit
#    ihrem Auslassdatum) und Eudora71/ (Befunde am Quelltext). Die duerfen
#    alt sein - sie beschreiben, was war, nicht was ist.
#
# 2. ROLLENHISTORIEN. LEKTORAT.md sammelt die Durchgaenge des Lektors,
#    PRUEFBERICHT.md die des Pruefers. Hat die Rolle seither in Befunde/
#    berichtet, ohne ihre Historie fortzuschreiben, faellt das hier auf.
#    Genau das war der Fall: LEKTORAT.md stand beim "Siebten Durchgang -
#    07.09.2026", waehrend LEKTOR am 09.09. zuletzt in Befunde/ berichtet
#    und danach noch dreimal gearbeitet hatte.
#
# Was es NICHT prueft: ob der Inhalt stimmt. Das kann kein Skript. Es prueft,
# dass jemand hingesehen hat.
#
# ---------------------------------------------------------------------------
# AUFRUF
# ---------------------------------------------------------------------------
#
#   perl tools/pruefe-stand-md.pl             aus dem Wurzelverzeichnis
#   perl tools/pruefe-stand-md.pl -leise      nur im Fehlerfall etwas sagen
#
# Rueckgabe: 0 = in Ordnung, 1 = Mangel, 2 = Aufrufproblem.

my $leise = grep { $_ eq '-leise' } @ARGV;

my $wurzel = -f 'VERSION' ? '.' : '..';
unless (-f "$wurzel/CHANGELOG.md") {
    print "  pruefe-stand-md: CHANGELOG.md nicht gefunden - bitte aus dem\n";
    print "  Wurzelverzeichnis aufrufen.\n";
    exit 2;
}

sub lies {
    my ($d) = @_;
    open my $h, '<:raw', $d or return undef;
    local $/;
    my $t = <$h>;
    close $h;
    return $t;
}

# Ein Datum TT.MM.JJJJ als vergleichbare Zahl JJJJMMTT.
sub zahl {
    my ($t, $m, $j) = @_;
    return sprintf('%04d%02d%02d', $j, $m, $t);
}
sub lesbar {
    my ($z) = @_;
    my ($j, $m, $t) = $z =~ /^(\d{4})(\d{2})(\d{2})$/;
    return "$t.$m.$j";
}

# --- Der Massstab: das juengste Datum im CHANGELOG -------------------------
my $cl = lies("$wurzel/CHANGELOG.md");
my $massstab = '';
while ($cl =~ /(\d{2})\.(\d{2})\.(\d{4})/g) {
    my $z = zahl($1, $2, $3);
    $massstab = $z if $z gt $massstab;
}
unless ($massstab) {
    print "  pruefe-stand-md: im CHANGELOG steht kein Datum - nichts zu vergleichen.\n";
    exit 2;
}

my (@mangel, @gut);

# Der zweite Massstab: Quellstand und Paketnummer, so wie der Baum sie fuehrt.
# Eine Datei, die im Kopf andere nennt, behauptet einen Stand, den sie nicht
# hat - auch wenn ihr Datum von heute ist.
my $vh = lies("$wurzel/Eudora71/Version.h");
my ($quellstand) = defined $vh ? $vh =~ /EUDORA_BUILD_VERSION\s+"([0-9.]+)"/ : ();
my $paket = lies("$wurzel/VERSION");
if (defined $paket) { $paket =~ s/\s+//g; } else { $paket = ''; }

# --- 1. Standdateien -------------------------------------------------------
my @dateien = split /\n/, `git -C "$wurzel" ls-files "*.md" 2>/dev/null`;
unless (@dateien) {
    print "  pruefe-stand-md: git ls-files hat nichts geliefert.\n";
    exit 2;
}

my $geprueft = 0;
for my $f (@dateien) {
    # Verzeichnisse, in denen Vergangenes steht - die duerfen alt sein.
    next if $f =~ m{^(Befunde|Arbeitsweise|Eudora71)/};

    my $t = lies("$wurzel/$f") or next;
    my @kopf = (split /\n/, $t)[0 .. 19];
    my $kopf = join "\n", grep { defined } @kopf;

    next unless $kopf =~ /Stand[^\n]{0,20}?(\d{2})\.(\d{2})\.(\d{4})/;
    my $z = zahl($1, $2, $3);
    $geprueft++;

    if ($z lt $massstab) {
        push @mangel,
          "$f behauptet 'Stand " . lesbar($z) . "', der juengste Vorgang im "
        . "CHANGELOG ist vom " . lesbar($massstab);
    }

    # Nennt der Kopf ausserdem einen QUELLSTAND oder eine PAKETNUMMER, muss
    # sie stimmen. Am 13.09.2026 gefunden: AUFGABEN.md trug "Stand 11.09.2026"
    # - das Datum war frisch - und dahinter "gemessen an Quellstand 7.2.0.48 /
    # Paket 1.0.48", waehrend der Baum auf 7.2.0.50 stand. Die Datumspruefung
    # allein liess das durch, und genau so entsteht die gefaehrlichste Sorte
    # Doku: eine, die frisch aussieht und es nicht ist.
    #
    # Gregor am 13.09.2026: "keine luegen auf dem main, gilt immer noch."
    # NUR die Zeile mit dem Stand, nicht der ganze Kopf. Der erste Anlauf
    # suchte in zwanzig Zeilen und schlug bei Releases/PAKETE.md an, wo
    # "1.0.4" mitten im Fliesstext steht - ein Fehlalarm, gefunden beim
    # Gegentest vor der Auslieferung.
    my ($standzeile) = grep { /Stand/ } split /\n/, $kopf;
    $standzeile = '' unless defined $standzeile;

    if ($quellstand and $standzeile =~ /Quellstand[^\n]{0,12}?(\d+\.\d+\.\d+\.\d+)/) {
        my $genannt = $1;
        if ($genannt ne $quellstand) {
            push @mangel,
              "$f nennt in der Stand-Zeile Quellstand $genannt, "
            . "Eudora71/Version.h sagt $quellstand";
        }
    }
    if ($paket and $standzeile =~ /Paket[^\n]{0,12}?(\d+\.\d+\.\d+)/) {
        my $genannt = $1;
        if ($genannt ne $paket) {
            push @mangel,
              "$f nennt in der Stand-Zeile Paket $genannt, VERSION sagt $paket";
        }
    }
}
push @gut, sprintf('%d Datei(en) mit Stand-Kopf geprueft, Massstab %s',
                   $geprueft, lesbar($massstab));

# --- 2. Rollenhistorien ----------------------------------------------------
# Die Historie einer Rolle darf nicht aelter sein als ihr juengster Bericht
# in Befunde/.
my %rolle = (
    'LEKTORAT.md'     => { muster => 'Befunde/LEKTOR-*.md',  name => 'LEKTOR'  },
    'PRUEFBERICHT.md' => { muster => 'Befunde/PRUEFER-*.md', name => 'PRUEFER' },
);

for my $datei (sort keys %rolle) {
    next unless -f "$wurzel/$datei";
    my $t = lies("$wurzel/$datei") or next;

    # Das juengste Datum in einer UEBERSCHRIFT - nicht irgendwo im Text.
    #
    # Der Unterschied ist genau der Fall, den Gregor gefunden hat: LEKTORAT.md
    # nennt im Fliesstext den 09.09.2026, die letzte Durchgangsueberschrift
    # heisst aber "Siebter Durchgang - 07.09.2026". Wer nur das juengste
    # Datum irgendwo sucht, haelt die Datei faelschlich fuer fortgeschrieben.
    # Was zaehlt, ist der letzte EINTRAG, und der steht in einer Ueberschrift.
    # Eine Datei, die sich selbst ausdruecklich als abgeschlossen erklaert,
    # ist keine laufende Historie mehr - dann ist das Fehlen neuer Eintraege
    # kein Mangel, sondern die Aussage. PRUEFBERICHT.md ist so ein Fall: ein
    # Bericht zum Stand 371c1e3 vom 30.08.2026, waehrend PRUEFER seither in
    # Befunde/PRUEFER-*.md berichtet.
    if ($t =~ /wird nicht fortgeschrieben/) {
        push @gut, "$datei erklaert sich als abgeschlossen und verweist weiter";
        next;
    }

    my $historie = '';
    for my $zeile (split /\n/, $t) {
        next unless $zeile =~ /^#/;
        next unless $zeile =~ /(\d{2})\.(\d{2})\.(\d{4})/;
        my $z = zahl($1, $2, $3);
        $historie = $z if $z gt $historie;
    }
    unless ($historie) {
        push @gut, "$datei fuehrt keine datierten Eintraege - nicht geprueft";
        next;
    }

    # Der juengste Commit auf einen Bericht dieser Rolle.
    my $muster = $rolle{$datei}{muster};
    my $datum = `git -C "$wurzel" log -1 --format=%ad --date=format:%Y%m%d -- "$muster" 2>/dev/null`;
    chomp $datum;
    next unless $datum =~ /^\d{8}$/;

    if ($historie lt $datum) {
        push @mangel,
          "$datei endet am " . lesbar($historie) . ", aber "
        . $rolle{$datei}{name} . " hat zuletzt am " . lesbar($datum)
        . " in $muster berichtet - die Historie ist nicht fortgeschrieben";
    } else {
        push @gut, "$datei ist so neu wie der juengste Bericht des "
                 . $rolle{$datei}{name};
    }
}

# --- Ausgabe ---------------------------------------------------------------
unless ($leise and not @mangel) {
    print "\n  ------------------------------------------------------------\n";
    print "  pruefe-stand-md\n";
    print "  ------------------------------------------------------------\n";
    print "    $_\n" for @gut;
}

if (@mangel) {
    print "\n  MANGEL:\n\n";
    print "    - $_\n\n" for @mangel;
    print <<'ENDE';
  Eine Datei, die einen Stand behauptet, den sie nicht hat, ist
  schlimmer als eine ohne Datum: man glaubt ihr. Gregor am
  11.09.2026, nachdem ich "ja, alles aktualisiert" gesagt hatte
  und er LEKTORAT.md beim 07.09. fand: "hinterher nachzuarbeiten
  ist bloed, musst du selbst machen."

  Also: nachziehen - VOR dem Merge, nicht auf Nachfrage danach.

ENDE
    exit 1;
}

print "\n  Kein Stand-Kopf hinkt hinterher.\n\n" unless $leise;
exit 0;
