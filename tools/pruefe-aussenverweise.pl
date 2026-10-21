#!/usr/bin/perl
use strict;
use warnings;

# pruefe-aussenverweise.pl - zeigt ein Verweis aus einem oeffentlichen Beitrag
# heute schon irgendwohin, oder erst nach dem naechsten Merge?
#
#   perl tools/pruefe-aussenverweise.pl                 # Bestand: alle .md
#   perl tools/pruefe-aussenverweise.pl <datei> ...     # nur diese Dateien
#   perl tools/pruefe-aussenverweise.pl --selbsttest    # 16 Faelle, beide Richtungen
#   perl tools/pruefe-aussenverweise.pl --hinweis       # meldet, weist nie ab
#   perl tools/pruefe-aussenverweise.pl --stand <ref>   # anderer Serverstand
#
# --stand dient der Gegenprobe an der Geschichte: mit dem Stand, den main am
# 21.10.2026 um 21:33 hatte (80b472aa), muss der Beitrag abgewiesen werden,
# mit dem heutigen nicht.
#
# Rueckgabe: 0 = kein toter Verweis, 1 = MANGEL, 2 = Aufrufproblem.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# Am 21.10.2026 um 21:33 ging ein Beitrag an Issue #102 hinaus, der auf
# .../blob/main/MELDUNGEN-VON-AUSSEN.md verwies. Diese Datei kam erst um
# 21:36:59 mit dem Merge von PR 128 auf main an (gemessen:
# "git log --diff-filter=A -- MELDUNGEN-VON-AUSSEN.md" nennt f0d6ef73, und
# dieser Commit lag bis 21:36:59 nur auf dem Zweig). Der Leser des Beitrags
# bekam drei Minuten lang 404. Gefunden hat es Gregor, nicht ich.
#
# Das war das ZWEITE Mal. Die Falle stand bereits in
# Releases/ISSUE-102-ANTWORT.md, Zeile 14-16, aufgeschrieben:
#
#     "Abgeschickt wird der Beitrag erst, wenn v1.0.117 wirklich
#      veroeffentlicht ist - gemessen am 21.10.2026 gibt es das Tag noch
#      nicht ... Vorher zeigen alle vier Verweise ins Leere."
#
# Beim zweiten Mal wird gebaut und nicht ermahnt
# (Arbeitsweise/fehlerklassen-abstellen.md). Ein aufgeschriebener Vorsatz hat
# genau einen Leser, und der hat ihn beim zweiten Mal nicht gelesen.
#
# ---------------------------------------------------------------------------
# WAS ES PRUEFT
# ---------------------------------------------------------------------------
#
# Jeden Verweis der Form
#
#     https://github.com/<eigner>/<repo>/blob/<ref>/<pfad>
#     https://github.com/<eigner>/<repo>/tree/<ref>/<pfad>
#
# auf UNSER eigenes Repository (ermittelt aus "git remote get-url origin",
# nicht von Hand eingetragen). Geprueft wird gegen den SERVERSTAND:
#
#     git rev-parse --verify --quiet origin/<ref>:<pfad>
#
# Also gegen das, was der Leser sieht - nicht gegen den Arbeitsbaum. Genau
# darin lag der Fehler: die Datei lag auf der Platte und im Zweig, und beides
# sieht der Leser nicht (Arbeitsweise/einigkeit-ist-kein-beweis.md - der
# Massstab muss von aussen kommen).
#
# Kein Netz, kein "git fetch": das Werkzeug laeuft im pre-commit mit und darf
# nicht haengen. Der Serverstand kann also alt sein; er ist fuer diese Frage
# trotzdem der richtige Massstab, denn zu alt heisst hoechstens "zeigt noch
# ins Leere" - und das ist die Richtung, in der ein Fehlalarm nicht schadet.
#
# WAS ES NICHT PRUEFT
#
#   * Verweise auf FREMDE Repositories - die kann niemand hier beeinflussen.
#   * Anker (#abschnitt) - sie werden abgeschnitten, geprueft wird die Datei.
#   * Einen <ref>, den dieser Klon nicht kennt (z.B. ein Tag, das es noch
#     nicht gibt): das meldet es als UNGEPRUEFT und nennt den Grund. Eine
#     Pruefung, die nichts lesen konnte, behauptet nichts
#     (Arbeitsweise/pruefung-legt-nichts-ab.md).

my $selbsttest = grep { $_ eq '--selbsttest' } @ARGV;
my $nur_hinweis = grep { $_ eq '--hinweis' } @ARGV;
my $stand = '';
for my $i (0 .. $#ARGV) {
    next unless $ARGV[$i] eq '--stand';
    $stand = defined $ARGV[$i + 1] ? $ARGV[$i + 1] : '';
    $ARGV[$i] = '--';
    $ARGV[$i + 1] = '--' if $i + 1 <= $#ARGV;
}
my @dateien = grep { !/^--/ } @ARGV;

# --- Verweise aus einem Text ziehen ----------------------------------------
#
# Die Grenze des Pfades ist heikel: in Markdown steht der Verweis fast immer
# als [Text](URL) - das schliessende ")" gehoert NICHT zum Pfad. Dasselbe gilt
# fuer Satzzeichen hinter einer blanken URL. Der echte Fall vom 21.10. stand
# in einer Zitatzeile (">") mit einem Komma dahinter.

sub verweise_aus_text {
    my ($text, $eigner, $repo) = @_;
    my @gefunden;
    my $nr = 0;
    for my $zeile (split /\n/, $text, -1) {
        $nr++;
        my $rest = $zeile;
        while ($rest =~ m{https?://github\.com/([^/\s]+)/([^/\s]+)/(blob|tree)/([^/\s]+)/([^\s\)\]\>"']+)}g) {
            my ($e, $r, $art, $ref, $pfad) = ($1, $2, $3, $4, $5);
            $pfad =~ s/#.*$//;                 # Anker weg
            $pfad =~ s/\?.*$//;                # Parameter weg
            $pfad =~ s/[.,;:!]+$//;            # Satzzeichen hinter blanker URL
            next unless length $pfad;
            my $fremd = (lc($e) ne lc($eigner) or lc($r) ne lc($repo)) ? 1 : 0;
            push @gefunden, {
                zeile => $nr, art => $art, ref => $ref,
                pfad  => entschluesseln($pfad), fremd => $fremd,
                eigner => $e, repo => $r,
            };
        }
    }
    return @gefunden;
}

sub entschluesseln {                       # %20 und Verwandte
    my ($p) = @_;
    $p =~ s/%([0-9A-Fa-f]{2})/chr(hex($1))/ge;
    return $p;
}

# --- Urteil ueber eine Liste von Verweisen ---------------------------------
#
# $sieht ist eine Funktion ($ref, $pfad) -> 'ja' | 'nein' | 'ref-unbekannt'.
# Sie wird im Selbsttest durch eine Tabelle ersetzt; so laeuft die Gegenprobe
# ohne git und ohne Server (Arbeitsweise/schranke-gegentesten.md).

sub beurteilen {
    my ($verweise, $sieht) = @_;
    my (@tot, @frei, @ungeprueft, @fremd);
    for my $v (@$verweise) {
        if ($v->{fremd}) { push @fremd, $v; next; }
        my $urteil = $sieht->($v->{ref}, $v->{pfad});
        if    ($urteil eq 'ja')   { push @frei, $v }
        elsif ($urteil eq 'nein') { push @tot,  $v }
        else                      { push @ungeprueft, $v }
    }
    return (\@tot, \@frei, \@ungeprueft, \@fremd);
}

# ---------------------------------------------------------------------------
# SELBSTTEST
# ---------------------------------------------------------------------------

if ($selbsttest) {
    my ($eigner, $repo) = ('HansWurst81675', 'Eudora7.2');

    # Der Server kennt: README.md, BEFUNDE.md, tools (Baum). Nicht:
    # MELDUNGEN-VON-AUSSEN.md. Der Ref "v1.0.117" ist unbekannt.
    my %da = map { $_ => 1 } ('README.md', 'BEFUNDE.md', 'tools',
                              'Arbeitsweise/README.md', 'ein Pfad.md');
    my $sieht = sub {
        my ($ref, $pfad) = @_;
        return 'ref-unbekannt' unless $ref eq 'main';
        return $da{$pfad} ? 'ja' : 'nein';
    };

    my @faelle = (
        # [Name, Text, erwartet tot, erwartet frei, erwartet ungeprueft, erwartet fremd]
        ['der echte Fall vom 21.10.2026, in einer Zitatzeile mit Komma',
         "> [MELDUNGEN-VON-AUSSEN.md](https://github.com/HansWurst81675/Eudora7.2/blob/main/MELDUNGEN-VON-AUSSEN.md),\n",
         1, 0, 0, 0],
        ['derselbe Pfad, nachdem er auf main liegt (Gegenrichtung)',
         "[README](https://github.com/HansWurst81675/Eudora7.2/blob/main/README.md)\n",
         0, 1, 0, 0],
        ['blanke URL mit Punkt am Satzende',
         "Siehe https://github.com/HansWurst81675/Eudora7.2/blob/main/README.md.\n",
         0, 1, 0, 0],
        ['blanke URL auf eine fehlende Datei',
         "Siehe https://github.com/HansWurst81675/Eudora7.2/blob/main/MELDUNGEN-VON-AUSSEN.md.\n",
         1, 0, 0, 0],
        ['Anker an vorhandener Datei zaehlt nicht als tot',
         "[E-85](https://github.com/HansWurst81675/Eudora7.2/blob/main/BEFUNDE.md#e-85)\n",
         0, 1, 0, 0],
        ['Anker an fehlender Datei bleibt tot',
         "[x](https://github.com/HansWurst81675/Eudora7.2/blob/main/MELDUNGEN-VON-AUSSEN.md#open)\n",
         1, 0, 0, 0],
        ['tree-Verweis auf ein vorhandenes Verzeichnis',
         "[tools](https://github.com/HansWurst81675/Eudora7.2/tree/main/tools)\n",
         0, 1, 0, 0],
        ['tree-Verweis auf ein fehlendes Verzeichnis',
         "[x](https://github.com/HansWurst81675/Eudora7.2/tree/main/Gibtsnicht)\n",
         1, 0, 0, 0],
        ['fremdes Repository wird nicht beurteilt',
         "[mfc](https://github.com/microsoft/VCSamples/blob/main/Gibtsnicht.md)\n",
         0, 0, 0, 1],
        ['derselbe Eigner, anderes Repo, ist auch fremd',
         "[x](https://github.com/HansWurst81675/Hermes/blob/main/Gibtsnicht.md)\n",
         0, 0, 0, 1],
        ['unbekannter Ref (Tag, das es noch nicht gibt) ist UNGEPRUEFT, nicht tot',
         "[x](https://github.com/HansWurst81675/Eudora7.2/blob/v1.0.117/README.md)\n",
         0, 0, 1, 0],
        ['Pfad mit Unterverzeichnis',
         "[x](https://github.com/HansWurst81675/Eudora7.2/blob/main/Arbeitsweise/README.md)\n",
         0, 1, 0, 0],
        ['prozentkodiertes Leerzeichen im Pfad',
         "[x](https://github.com/HansWurst81675/Eudora7.2/blob/main/ein%20Pfad.md)\n",
         0, 1, 0, 0],
        ['issues-Verweis ist kein Dateiverweis und wird uebergangen',
         "[#102](https://github.com/HansWurst81675/Eudora7.2/issues/102)\n",
         0, 0, 0, 0],
        ['zwei Verweise in einer Zeile, einer tot',
         "[a](https://github.com/HansWurst81675/Eudora7.2/blob/main/README.md) und "
       . "[b](https://github.com/HansWurst81675/Eudora7.2/blob/main/MELDUNGEN-VON-AUSSEN.md)\n",
         1, 1, 0, 0],
        ['Grossschreibung im Eignernamen ist derselbe Eigner',
         "[x](https://github.com/hanswurst81675/eudora7.2/blob/main/MELDUNGEN-VON-AUSSEN.md)\n",
         1, 0, 0, 0],
    );

    my ($gut, $schlecht) = (0, 0);
    for my $f (@faelle) {
        my ($name, $text, $e_tot, $e_frei, $e_ung, $e_fremd) = @$f;
        my @v = verweise_aus_text($text, $eigner, $repo);
        my ($tot, $frei, $ung, $fremd) = beurteilen(\@v, $sieht);
        my $ok = (@$tot == $e_tot and @$frei == $e_frei
                  and @$ung == $e_ung and @$fremd == $e_fremd);
        printf "  [%s] %s\n", ($ok ? 'ok ' : 'ROT'), $name;
        printf "        erwartet tot=%d frei=%d ungeprueft=%d fremd=%d, "
             . "bekommen tot=%d frei=%d ungeprueft=%d fremd=%d\n",
             $e_tot, $e_frei, $e_ung, $e_fremd,
             scalar @$tot, scalar @$frei, scalar @$ung, scalar @$fremd
            unless $ok;
        $ok ? $gut++ : $schlecht++;
    }
    printf "\n  Selbsttest: %d von %d Faellen, %d rot.\n",
        $gut, scalar @faelle, $schlecht;
    print "  Beide Richtungen: der echte tote Verweis wird gemeldet, der\n";
    print "  vorhandene Pfad und das fremde Repository nicht.\n\n";
    exit($schlecht ? 1 : 0);
}

# ---------------------------------------------------------------------------
# BESTAND
# ---------------------------------------------------------------------------

my $wurzel = -f 'VERSION' ? '.' : '..';
unless (-f "$wurzel/VERSION") {
    print "  pruefe-aussenverweise: bitte aus dem Wurzelverzeichnis aufrufen.\n";
    exit 2;
}

sub git {
    my @arg = @_;
    my $pid = open(my $fh, '-|');
    return '' unless defined $pid;
    if (!$pid) {
        open(STDERR, '>', '/dev/null') or open(STDERR, '>', 'NUL');
        exec('git', @arg) or exit 127;
    }
    local $/;
    my $a = <$fh>;
    close $fh;
    $a = '' unless defined $a;
    $a =~ s/\s+\z//;
    return $a;
}

# --- Wessen Repository ist das hier? (nicht von Hand eingetragen) ----------
my $url = git('remote', 'get-url', 'origin');
my ($eigner, $repo);
if ($url =~ m{github\.com[:/]+([^/]+)/([^/\s]+?)(?:\.git)?$}) {
    ($eigner, $repo) = ($1, $2);
} else {
    print "  pruefe-aussenverweise: aus 'git remote get-url origin' laesst sich\n";
    print "  kein GitHub-Repository lesen (war: '$url'). Ungeprueft.\n";
    exit 2;
}

# --- Welche Dateien? -------------------------------------------------------
unless (@dateien) {
    @dateien = grep { length } split /\n/, git('ls-files', '*.md');
}

my %ref_bekannt;
sub sieht_der_leser {
    my ($ref, $pfad) = @_;
    unless (exists $ref_bekannt{$ref}) {
        my $k;
        if (length $stand and ($ref eq 'main' or $ref eq 'master')) {
            # Gegenprobe an der Geschichte: ein anderer Stand spielt "main".
            $k = length git('rev-parse', '--verify', '--quiet', "$stand^{commit}")
               ? $stand : '';
        } else {
            $k = length git('rev-parse', '--verify', '--quiet', "origin/$ref^{commit}")
               ? "origin/$ref"
               : (length git('rev-parse', '--verify', '--quiet', "$ref^{commit}") ? $ref : '');
        }
        $ref_bekannt{$ref} = $k;
    }
    my $k = $ref_bekannt{$ref};
    return 'ref-unbekannt' unless length $k;
    return length git('rev-parse', '--verify', '--quiet', "$k:$pfad") ? 'ja' : 'nein';
}

my (@tot_alle, @ung_alle);
my ($geprueft, $frei_alle) = (0, 0);

for my $d (@dateien) {
    my $pfad = -f $d ? $d : "$wurzel/$d";
    next unless -f $pfad;
    open my $h, '<:raw', $pfad or next;
    my $text = do { local $/; <$h> };
    close $h;
    my @v = verweise_aus_text($text, $eigner, $repo);
    next unless @v;
    my ($tot, $frei, $ung, undef) = beurteilen(\@v, \&sieht_der_leser);
    $geprueft += @$tot + @$frei + @$ung;
    $frei_alle += @$frei;
    push @tot_alle, map { { %$_, datei => $d } } @$tot;
    push @ung_alle, map { { %$_, datei => $d } } @$ung;
}

print "\n  Zeigen die Verweise nach aussen heute schon irgendwohin?\n";
print "  " . ("-" x 68) . "\n\n";
printf "  %-34s %s\n", "Repository", "$eigner/$repo";
printf "  %-34s %d\n", "Dateien", scalar @dateien;
printf "  %-34s %d\n", "eigene Verweise geprueft", $geprueft;
printf "  %-34s %d\n", "davon vorhanden", $frei_alle;

if (@ung_alle) {
    print "\n  UNGEPRUEFT (den Ref kennt dieser Klon nicht - kein Urteil):\n";
    printf "    %s:%d  %s/%s\n", $_->{datei}, $_->{zeile}, $_->{ref}, $_->{pfad}
        for @ung_alle;
}

unless (@tot_alle) {
    print "\n  Kein toter Verweis.\n\n";
    exit 0;
}

print "\n  MANGEL - diese Verweise zeigen fuer einen Leser von aussen ins Leere:\n\n";
for my $t (@tot_alle) {
    printf "    %s:%d\n", $t->{datei}, $t->{zeile};
    printf "        %s/%s/%s/%s  -> in %s gibt es das nicht\n",
        "https://github.com/$eigner/$repo", $t->{art}, $t->{ref}, $t->{pfad},
        ($ref_bekannt{ $t->{ref} } || "origin/$t->{ref}");
}
print <<"ENDE";

  Ein Verweis auf blob/main zeigt auf den SERVERSTAND, nicht auf den Zweig
  und nicht auf die Platte. Solange der Merge nicht durch ist, sieht der
  Leser 404 - am 21.10.2026 um 21:33 drei Minuten lang in Issue #102, und
  es war das zweite Mal (Releases/ISSUE-102-ANTWORT.md, Zeile 14).

  Also: erst mergen, dann abschicken. Oder den Verweis auf den Zweig
  zeigen lassen, auf dem die Datei schon liegt.

ENDE
exit($nur_hinweis ? 0 : 1);
