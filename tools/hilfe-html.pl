#!/usr/bin/perl
# hilfe-html.pl - erzeugt aus Doku/FUNKTIONEN.md die zwei HTML-Seiten, die
# Eudora ueber das Menue Help zeigt (Auftrag vom 02.11.2026: "das dann einfach
# als HTML im default browser anzeigen"):
#
#   Tastenkuerzel.html   Abschnitt "Tastenkuerzel auf einen Blick"
#                        (Help -> Keyboard Shortcuts)
#   Einstellungen.html   Abschnitte "Tools -> Options", "Eudora.ini-
#                        Schluessel ohne Optionsseite" und "Die Abschnitte
#                        der Eudora.ini" (Help -> Settings Reference)
#
#   perl tools/hilfe-html.pl <zielverzeichnis> [--fassung 7.2.2.N] [--quelle <md>]
#   perl tools/hilfe-html.pl --selbsttest
#
# ABBRUCH (Rueckgabe 1, keine Datei geschrieben), wenn
#   - ein Abschnitt fehlt oder doppelt vorkommt (erkannt an der UEBERSCHRIFT,
#     nicht an der Nummer),
#   - ein Abschnitt weniger als $MIN_ZEILEN Tabellenzeilen hat (PRUEFER-84
#     K2: ein leerer Abschnitt ergab vorher eine fast leere Seite mit
#     Rueckgabe 0),
#   - nach dem Ersetzen noch ein Personenname in der Seite steht (siehe
#     NEUTRAL unten).
# Ein Paket ohne Hilfeseite soll nicht still entstehen.
#
# Die Seiten sind fuer ANWENDER (Entscheidung vom 02.11.2026, PRUEFER-84 K6):
#   - Verweise auf interne Projektdateien (Intern/, Befunde/, Arbeitsweise/,
#     tools/, Eudora71/) werden reiner Text - die Befundkennung bzw. der
#     Linktext bleibt mit seinem Halbsatz stehen, nur ohne Link.
#   - Verweise auf oeffentliche Doku (Doku/*.md, README ...) zeigen auf den
#     COMMIT der Quelle (blob/<commit>/), wenn sie sauber committet ist,
#     sonst auf main. Nicht auf die Release-Marke: die gibt es beim Paketbau
#     und bei Gregors Test noch nicht, und fuer eine nie veroeffentlichte
#     Nummer nie (PRUEFER-84 N2, LEKTOR-130 L-130.9). --fassung setzt nur
#     die Nummer im Seitenkopf.
#   - Personennamen werden neutral ersetzt (Liste @NEUTRAL).
#
# Der Markdown-Umsetzer kann genau das, was FUNKTIONEN.md benutzt:
# Ueberschriften, Tabellen, Absaetze, Listen (*, -, 1.), Trennlinien,
# `code`, *kursiv*, **fett**, ***beides***, Links (auch mit Klammern im
# Ziel), Rueckstrich-Maskierung.
#   #anker            bleibt, wenn der Anker auf DIESER Seite steht; sonst
#                     -> GitHub-Adresse von Doku/FUNKTIONEN.md#anker
#   pfad.md[#anker]   (relativ zu Doku/) -> GitHub-Adresse oder Text (s. o.)
#   http(s)://...     bleibt
# Anker werden wie bei GitHub gebildet (Kleinbuchstaben, Satzzeichen ausser
# - und _ weg, Leerzeichen -> Bindestrich, Wiederholung -> -1, -2 ...), ueber
# die GANZE Datei gezaehlt, damit sie mit den Verweisen in FUNKTIONEN.md
# uebereinstimmen.
#
# Seitenkopf: Fassung, Datum und Commit der Quelle - der Commit nur, wenn die
# Datei sauber committet ist, sonst "nicht committet" (LEKTOR-130 L-130.8).
#
# Ausgabe: UTF-8 ohne BOM, LF, <meta charset="utf-8">, CSS eingebettet, keine
# externe Ressource. Kodierung dieser Datei: reines ASCII.
use strict;
use warnings;
use feature 'unicode_strings';
use File::Path qw(make_path);
use File::Spec;

my $REPO = 'https://github.com/HansWurst81675/Eudora7.2/blob/';
my $GITHUB = $REPO . 'main/';           # Basis fuer oeffentliche Doku; stand_der_quelle setzt <commit>/
my $QUELLPFAD = 'Doku/FUNKTIONEN.md';   # Pfad im Repository, fuer Links
my $QUELLNAME = $QUELLPFAD;             # fuer Meldungen (--quelle setzt den echten Pfad)
my $MIN_ZEILEN = 5;                     # Tabellenzeilen je Abschnitt mindestens

# Verzeichnisse, auf die eine Anwenderseite nicht verlinkt (K6).
my @INTERN = ('Intern/', 'Befunde/', 'Arbeitsweise/', 'tools/', 'Eudora71/');

# Personennamen neutral (K6). Steht danach noch einer in der Seite, bricht das
# Werkzeug ab - die Liste wird dann ergaenzt, nicht der Name ausgeliefert.
my @NEUTRAL = (
    [ 'hatte Gregors Serverpostfach geleert', 'hatte ein Serverpostfach geleert' ],
    [ 'Gregors Protokolle',                    "die Protokolle der Testl\x{e4}ufe" ],
    [ 'von Gregor best' . "\x{e4}" . 'tigt', 'am Programm best' . "\x{e4}" . 'tigt' ],
    [ 'Gregor hat es',                         'Es wurde' ],
    [ 'Von Gregor am',                         'Von einem Bearbeiter am' ],
);
my $NAME = qr/Gregor/;

my $ROOT = $0; $ROOT =~ s{[\\/]tools[\\/][^\\/]+$}{}; $ROOT = '.' if $ROOT eq $0;

# Die Seiten. 'teile' sind Muster auf den Text einer ##-Ueberschrift.
my @SEITEN = (
    { datei => 'Tastenkuerzel.html',
      titel => "Eudora \x{2014} Tastenk\x{fc}rzel",
      menue => "Help \x{2192} Keyboard Shortcuts",
      teile => [ qr/Tastenk\x{fc}rzel auf einen Blick/ ] },
    { datei => 'Einstellungen.html',
      titel => "Eudora \x{2014} Einstellungen und Eudora.ini-Schl\x{fc}ssel",
      menue => "Help \x{2192} Settings Reference",
      teile => [ qr/Tools \x{2192} Options/, qr/Eudora\.ini.*ohne Optionsseite/,
                 qr/Die Abschnitte der `?Eudora\.ini/ ] },
);

if (@ARGV && $ARGV[0] eq '--selbsttest') { exit selbsttest(); }

my ($ziel, $fassung, $quelle);
while (@ARGV) {
    my $a = shift @ARGV;
    if    ($a eq '--fassung') { $fassung = shift @ARGV; }
    elsif ($a eq '--quelle')  { $quelle  = shift @ARGV; }
    elsif ($a =~ /^-/)        { die "hilfe-html: unbekannter Schalter $a\n"; }
    else                      { $ziel = $a; }
}
unless (defined $ziel) {
    print STDERR "Aufruf: perl tools/hilfe-html.pl <zielverzeichnis> [--fassung N] [--quelle <md>]\n";
    print STDERR "        perl tools/hilfe-html.pl --selbsttest\n";
    exit 2;
}
if (defined $fassung) {
    unless ($fassung =~ /^\d+(?:\.\d+){1,3}$/) { print STDERR "hilfe-html: FEHLER --fassung '$fassung' ist keine Fassungsnummer\n"; exit 1; }
}
my $eigene_quelle = !defined $quelle;
$QUELLNAME = $quelle if defined $quelle;
$quelle  //= "$ROOT/$QUELLPFAD";
$fassung //= lies_fassung();

my $md = eval { lies_utf8($quelle) };
unless (defined $md) { print STDERR "hilfe-html: FEHLER $@hilfe-html: nichts geschrieben.\n"; exit 1; }
my $stand = stand_der_quelle($quelle, $eigene_quelle);
my @fertig;
for my $s (@SEITEN) {
    my $html = eval { seite_bauen($md, $s, $fassung, $stand) };
    unless (defined $html) {
        print STDERR "hilfe-html: FEHLER $s->{datei}: $@";
        print STDERR "hilfe-html: nichts geschrieben.\n";
        exit 1;
    }
    push @fertig, [$s->{datei}, $html];
}
unless (-d $ziel) {
    eval { make_path($ziel) }; -d $ziel or do { print STDERR "hilfe-html: FEHLER Verzeichnis $ziel: $!\n"; exit 1; };
}
for my $f (@fertig) {
    my $p = "$ziel/$f->[0]";
    open(my $fh, '>:raw', $p) or do { print STDERR "hilfe-html: FEHLER $p: $!\n"; exit 1; };
    my $bytes = $f->[1]; utf8::encode($bytes);
    print $fh $bytes; close $fh or do { print STDERR "hilfe-html: FEHLER $p: $!\n"; exit 1; };
    printf "hilfe-html: %s  %d Bytes\n", $p, -s $p;
}
exit 0;

# ---------------------------------------------------------------------------

sub lies_utf8 {
    my ($p) = @_;
    open(my $fh, '<:raw', $p) or die "hilfe-html: $p: $!\n";
    local $/; my $t = <$fh>; close $fh;
    $t = '' unless defined $t;
    $t =~ s/^\xEF\xBB\xBF//;
    utf8::decode($t) or die "hilfe-html: $p ist kein gueltiges UTF-8\n";
    $t =~ s/\r\n/\n/g;
    return $t;
}

sub lies_fassung {
    my $p = "$ROOT/VERSION";
    open(my $fh, '<', $p) or return 'unbekannt';
    my $v = <$fh>; close $fh;
    $v = '' unless defined $v; $v =~ s/\s+//g;
    return $v eq '' ? 'unbekannt' : $v;
}

sub git_ausgabe {
    my (@arg) = @_;
    # Listenform ohne Shell: "2>NUL" legte unter Git Bash eine Datei NUL an.
    my $r;
    if (open(my $g, '-|', 'git', '-C', $ROOT, @arg)) {
        local $/; $r = <$g> // ''; close $g;
        return undef if $? != 0;
    }
    return $r;
}

# Datum und Kurzkennung des letzten Commits der Quelle - der Commit nur, wenn
# die Datei unveraendert committet ist (L-130.8); ohne git: Dateidatum.
sub stand_der_quelle {
    my ($p, $eigene) = @_;
    my @t = localtime((stat $p)[9] // time);
    my $datei_datum = sprintf "%02d.%02d.%04d", $t[3], $t[4] + 1, $t[5] + 1900;
    return "$datei_datum (Dateidatum, $p)" unless $eigene;
    my $r = git_ausgabe('log', '-1', '--format=%cs_%h_%H', '--', $QUELLPFAD);
    my $st = git_ausgabe('status', '--porcelain', '--', $QUELLPFAD);
    return "$datei_datum (Dateidatum)" unless defined $r && defined $st;
    $r =~ s/\s+//g;
    return "$datei_datum (nicht committet)" if $st =~ /\S/;
    if ($r =~ /^(\d{4})-(\d\d)-(\d\d)_(\w+)_([0-9a-f]{40})$/) {
        $GITHUB = $REPO . "$5/";            # N2: Links auf den Commit der Quelle
        return "$3.$2.$1 (Commit $4)";
    }
    return "$datei_datum (nicht committet)";
}

sub html_esc {
    my ($t) = @_;
    $t =~ s/&/&amp;/g; $t =~ s/</&lt;/g; $t =~ s/>/&gt;/g; $t =~ s/"/&quot;/g;
    return $t;
}

# GitHub-Anker aus dem Text einer Ueberschrift (Markdown roh). GitHub laesst
# '_' stehen (PRUEFER-84 K3) und entfernt nur die Auszeichnung ` und *.
sub slug {
    my ($t) = @_;
    $t =~ s/\[([^\]]*)\]\([^)]*\)/$1/g;      # Link -> Text
    $t =~ s/[`*]//g;                          # Auszeichnung weg
    $t = lc $t;
    $t =~ s/[^\w\- ]//g;                      # Satzzeichen weg (Unicode-\w, mit _)
    $t =~ s/ /-/g;
    return $t;
}

# Alle Ueberschriften der Datei: [ebene, text, anker, zeilenindex]
sub ueberschriften {
    my ($zeilen) = @_;
    my (%n, @u, $zaun);
    for my $i (0 .. $#$zeilen) {
        my $z = $zeilen->[$i];
        if ($z =~ /^```/) { $zaun = !$zaun; next; }
        next if $zaun;
        next unless $z =~ /^(#{1,6})\s+(.*?)\s*#*\s*$/;
        my ($e, $t) = (length $1, $2);
        my $s = slug($t);
        my $a = exists $n{$s} ? "$s-" . (++$n{$s}) : do { $n{$s} = 0; $s };
        push @u, [$e, $t, $a, $i];
    }
    return @u;
}

# Tabellenzeilen eines Blocks (ohne Kopf- und Trennzeile).
sub tabellenzeilen {
    my ($zeilen) = @_;
    my $n = 0;
    for my $i (0 .. $#$zeilen) {
        next unless $zeilen->[$i] =~ /^\s*\|/;
        next if $zeilen->[$i] =~ /^\s*\|?\s*:?-{2,}/;                                   # Trennzeile
        next if $i + 1 <= $#$zeilen && $zeilen->[$i + 1] =~ /^\s*\|?\s*:?-{2,}/;     # Kopfzeile
        $n++;
    }
    return $n;
}

# Personennamen neutral ersetzen (K6).
sub neutral {
    my ($t) = @_;
    for my $p (@NEUTRAL) {
        my ($alt, $neu) = @$p;
        $t =~ s/\Q$alt\E/$neu/g;
    }
    return $t;
}

# Baut eine Seite: sucht die Abschnitte, setzt sie um, legt Kopf und Fuss an.
sub seite_bauen {
    my ($md, $s, $fassung, $stand) = @_;
    my @z = split /\n/, $md, -1;
    my @u = ueberschriften(\@z);
    my @bloecke;
    for my $muster (@{ $s->{teile} }) {
        my @treffer = grep { $_->[0] == 2 && $_->[1] =~ $muster } @u;
        die "Abschnitt /$muster/ nicht gefunden in $QUELLNAME\n" unless @treffer;
        die "Abschnitt /$muster/ steht " . scalar(@treffer) . "-mal in $QUELLNAME\n" if @treffer > 1;
        my $von = $treffer[0][3];
        my ($naechste) = grep { $_->[0] <= 2 && $_->[3] > $von } @u;
        my $bis = $naechste ? $naechste->[3] - 1 : $#z;
        my @block = @z[$von .. $bis];
        my $n = tabellenzeilen(\@block);
        die "Abschnitt /$muster/ in $QUELLNAME hat nur $n Tabellenzeilen (mindestens $MIN_ZEILEN) - leer oder abgeschnitten?\n"
            if $n < $MIN_ZEILEN;
        push @bloecke, [ map { neutral($_) } @block ];
    }
    # Anker auf dieser Seite: die Ueberschriften der uebernommenen Abschnitte.
    my %hier;
    my %anker_zu_zeile = map { $_->[3] => $_->[2] } @u;
    for my $muster (@{ $s->{teile} }) {
        my ($t) = grep { $_->[0] == 2 && $_->[1] =~ $muster } @u;
        my ($n) = grep { $_->[0] <= 2 && $_->[3] > $t->[3] } @u;
        my $bis = $n ? $n->[3] : 1e9;
        $hier{$_->[2]} = 1 for grep { $_->[3] >= $t->[3] && $_->[3] < $bis } @u;
    }
    my $koerper = '';
    for my $i (0 .. $#{ $s->{teile} }) {
        my ($t) = grep { $_->[0] == 2 && $_->[1] =~ $s->{teile}[$i] } @u;
        $koerper .= md_bloecke($bloecke[$i], \%hier, $t->[3], \%anker_zu_zeile);
    }
    if ($koerper =~ /(.{0,40}$NAME.{0,40})/) {
        die "Personenname in der Seite: '$1' - in \@NEUTRAL (tools/hilfe-html.pl) eine neutrale Fassung eintragen\n";
    }
    my $titel = html_esc($s->{titel});
    my $menue = html_esc($s->{menue});
    my $quelle_url = $GITHUB . $QUELLPFAD;
    return <<"HTML";
<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>$titel</title>
<style>
body { font-family: "Segoe UI", Tahoma, Arial, sans-serif; font-size: 15px; line-height: 1.45; color: #1d1d1d; background: #ffffff; margin: 0 auto; padding: 1em 1.5em 3em; max-width: 1200px; }
h1 { font-size: 1.6em; margin: 0.2em 0 0.3em; }
h2 { font-size: 1.35em; margin-top: 1.6em; border-bottom: 1px solid #ccc; padding-bottom: 0.2em; }
h3 { font-size: 1.12em; margin-top: 1.4em; }
.kopf { color: #555; font-size: 0.92em; border-left: 4px solid #4a78b5; padding: 0.3em 0.8em; background: #f3f6fa; }
table { border-collapse: collapse; margin: 0.6em 0 1em; width: 100%; }
th, td { border: 1px solid #c8c8c8; padding: 0.3em 0.5em; vertical-align: top; text-align: left; }
th { background: #eef1f5; }
tr:nth-child(even) td { background: #fafafa; }
code { font-family: Consolas, "Courier New", monospace; font-size: 0.92em; background: #f1f1f1; padding: 0 0.2em; border-radius: 3px; }
a { color: #1f5aa6; }
hr { border: 0; border-top: 1px solid #ddd; margin: 1.5em 0; }
\@media print { body { max-width: none; } .kopf { background: none; } }
</style>
</head>
<body>
<h1>$titel</h1>
<p class="kopf">Eudora $fassung &middot; <em>$menue</em><br>
Stand der Vorlage: $stand &middot; aus <a href="$quelle_url">$QUELLPFAD</a> erzeugt.
&bdquo;Vorlage&ldquo; in der letzten Spalte hei&szlig;t: aus dem Quelltext gelesen, nicht am Programm gepr&uuml;ft.</p>
$koerper</body>
</html>
HTML
}

# Setzt eine Liste von Markdown-Zeilen in HTML um.
sub md_bloecke {
    my ($zeilen, $hier, $erste_zeile, $anker_zu_zeile) = @_;
    my @z = @$zeilen;
    my $out = '';
    my $i = 0;
    while ($i < @z) {
        my $l = $z[$i];
        if ($l =~ /^\s*$/) { $i++; next; }
        if ($l =~ /^(#{1,6})\s+(.*?)\s*#*\s*$/) {
            my $e = length $1;
            my $id = defined $erste_zeile ? $anker_zu_zeile->{$erste_zeile + $i} : undef;
            $id //= slug($2);
            $out .= sprintf "<h%d id=\"%s\">%s</h%d>\n", $e, html_esc($id), inline($2, $hier), $e;
            $i++; next;
        }
        if ($l =~ /^\s*(?:-{3,}|\*{3,}|_{3,})\s*$/) { $out .= "<hr>\n"; $i++; next; }
        if ($l =~ /^\s*\|/ && $i + 1 < @z && $z[$i + 1] =~ /^\s*\|?\s*:?-{2,}/) {
            my @kopf = zellen($l);
            $i += 2;
            $out .= "<table>\n<thead><tr>" . join('', map { '<th>' . inline($_, $hier) . '</th>' } @kopf) . "</tr></thead>\n<tbody>\n";
            while ($i < @z && $z[$i] =~ /^\s*\|/) {
                my @c = zellen($z[$i]);
                push @c, '' while @c < @kopf;
                $out .= '<tr>' . join('', map { '<td>' . inline($_, $hier) . '</td>' } @c) . "</tr>\n";
                $i++;
            }
            $out .= "</tbody>\n</table>\n";
            next;
        }
        if ($l =~ /^(\s*)([*+-]|\d+\.)\s+/) {
            my $geordnet = $2 =~ /\d/;
            my @punkte;
            while ($i < @z) {
                my $x = $z[$i];
                if ($x =~ /^\s*(?:[*+-]|\d+\.)\s+(.*)$/) { push @punkte, $1; $i++; next; }
                if (@punkte && $x =~ /^\s+\S/) { $x =~ s/^\s+//; $punkte[-1] .= " $x"; $i++; next; }
                last;
            }
            my $tag = $geordnet ? 'ol' : 'ul';
            $out .= "<$tag>\n" . join('', map { '<li>' . inline($_, $hier) . "</li>\n" } @punkte) . "</$tag>\n";
            next;
        }
        if ($l =~ /^>\s?(.*)$/) {
            my @q;
            while ($i < @z && $z[$i] =~ /^>\s?(.*)$/) { push @q, $1; $i++; }
            $out .= '<blockquote><p>' . inline(join(' ', @q), $hier) . "</p></blockquote>\n";
            next;
        }
        my @p;
        while ($i < @z && $z[$i] !~ /^\s*$/ && $z[$i] !~ /^(#{1,6})\s/ && $z[$i] !~ /^\s*\|/
               && $z[$i] !~ /^\s*(?:[*+-]|\d+\.)\s+/ && $z[$i] !~ /^\s*-{3,}\s*$/) {
            push @p, $z[$i]; $i++;
        }
        unless (@p) { push @p, $z[$i]; $i++; }
        $out .= '<p>' . inline(join("\n", @p), $hier) . "</p>\n";
    }
    return $out;
}

# Zerlegt eine Tabellenzeile an '|' - nicht an '\|' und nicht in `code`.
sub zellen {
    my ($l) = @_;
    $l =~ s/^\s*\|//; $l =~ s/\|\s*$//;
    my @c; my $akt = ''; my $code = 0;
    for (my $k = 0; $k < length $l; $k++) {
        my $ch = substr($l, $k, 1);
        if ($ch eq '\\' && $k + 1 < length $l) { $akt .= $ch . substr($l, $k + 1, 1); $k++; next; }
        if ($ch eq '`') { $code = !$code; }
        if ($ch eq '|' && !$code) { push @c, $akt; $akt = ''; next; }
        $akt .= $ch;
    }
    push @c, $akt;
    s/^\s+|\s+$//g for @c;
    return @c;
}

# Hervorhebung auf schon maskiertem Text.
sub hervorhebung {
    my ($t) = @_;
    $t =~ s/\*\*\*(?=\S)(.+?)(?<=\S)\*\*\*/<strong><em>$1<\/em><\/strong>/gs;
    $t =~ s/\*\*(?=\S)(.+?)(?<=\S)\*\*/<strong>$1<\/strong>/gs;
    $t =~ s/(?<![\w*])\*(?=\S)(.+?)(?<=\S)\*(?![\w*])/<em>$1<\/em>/gs;
    return $t;
}

# Inline-Auszeichnung. Platzhalter \x{E000}n\x{E001} schuetzen Code, Masken
# und fertige Links vor den nachfolgenden Ersetzungen. Ein Platzhalter traegt
# immer FERTIGES HTML und wird nie ein zweites Mal maskiert (PRUEFER-84 K3).
sub inline {
    my ($t, $hier) = @_;
    my @ph;
    my $halte = sub { push @ph, $_[0]; return "\x{E000}" . $#ph . "\x{E001}"; };
    # 1. Code
    $t =~ s/(`+)(.+?)\1/$halte->('<code>' . html_esc($2) . '<\/code>')/ge;
    # 2. Rueckstrich-Maskierung (auch \&)
    $t =~ s/\\([\\`*_{}\[\]()#+\-.!|<>&])/$halte->(html_esc($1))/ge;
    # 3. Links; das Ziel darf ein Klammerpaar enthalten: [x](a_(b))
    $t =~ s/\[((?:[^\[\]]|\x{E000}\d+\x{E001})+)\]\(((?:[^()\s]|\([^()\s]*\))+)\)/$halte->(link_html($1, $2, $hier, \@ph))/ge;
    # 4. HTML maskieren (Platzhalterzeichen sind davon nicht betroffen)
    $t = html_esc($t);
    # 5. Hervorhebung
    $t = hervorhebung($t);
    # 6. Platzhalter zurueck (verschachtelt moeglich)
    1 while $t =~ s/\x{E000}(\d+)\x{E001}/$ph[$1]/g;
    return $t;
}

# Linktext: enthaelt noch Platzhalter (fertiges HTML) - nur den uebrigen Text
# maskieren, dann Hervorhebung, dann die Platzhalter einsetzen.
sub link_html {
    my ($text, $ziel, $hier, $ph) = @_;
    my $innen = hervorhebung(html_esc($text));
    1 while $innen =~ s/\x{E000}(\d+)\x{E001}/$ph->[$1]/g;
    my $href = link_ziel($ziel, $hier);
    return $innen unless defined $href;                  # intern: nur Text (K6)
    return '<a href="' . html_esc($href) . '">' . $innen . '</a>';
}

# Linkziel umschreiben (siehe Kopf). undef = kein Link, nur Text.
sub link_ziel {
    my ($ziel, $hier) = @_;
    return $ziel if $ziel =~ m{^(?:https?|mailto):}i;
    if ($ziel =~ /^#(.*)$/) {
        return $ziel if $hier->{$1};
        return $GITHUB . $QUELLPFAD . $ziel;
    }
    my ($pfad, $anker) = $ziel =~ /^([^#]*)(#.*)?$/;
    $anker //= '';
    my @teile = split m{/}, $QUELLPFAD; pop @teile;      # Verzeichnis der Quelle
    for my $s (split m{/}, $pfad) {
        next if $s eq '.' || $s eq '';
        if ($s eq '..') { pop @teile; } else { push @teile, $s; }
    }
    my $rel = join('/', @teile);
    for my $i (@INTERN) { return undef if index($rel, $i) == 0; }
    return $GITHUB . $rel . $anker;
}

# ---------------------------------------------------------------------------

sub selbsttest {
    my ($ok, $nok) = (0, 0);
    my $pruefe = sub {
        my ($was, $wahr) = @_;
        if ($wahr) { $ok++; print "  ok    $was\n"; } else { $nok++; print "  FEHLER $was\n"; }
    };
    my %hier = ('strg--buchstabe' => 1);
    my $h;

    # Inline, positive Richtung
    $pruefe->('**fett** -> <strong>', inline('a **fett** b', \%hier) eq 'a <strong>fett</strong> b');
    $pruefe->('*kursiv* -> <em>',     inline('*Help*', \%hier) eq '<em>Help</em>');
    $pruefe->('***beides***',         inline('***Find***', \%hier) eq '<strong><em>Find</em></strong>');
    $pruefe->('`code` maskiert <>&',  inline('`a<b>&c`', \%hier) eq '<code>a&lt;b&gt;&amp;c</code>');
    $pruefe->('Rueckstrich \\\\ -> \\', inline('Strg+\\\\', \%hier) eq 'Strg+\\');
    $pruefe->('Kursiv vor Code: *Delete*`\\tDel`', inline('*Delete*`\\tDel`', \%hier) eq '<em>Delete</em><code>\\tDel</code>');
    # Inline, negative Richtung
    $pruefe->('kein <em> im Code',    inline('`a *b* c`', \%hier) !~ /<em>/);
    $pruefe->('Strg+* allein ist kein Kursiv', inline('Strg+* und Strg+/', \%hier) !~ /<em>/);
    $pruefe->('<script> wird maskiert', inline('<script>x</script>', \%hier) !~ /<script>/);
    # K3: Maskierung im Linktext genau einmal, Klammern im Ziel, '_' im Anker
    $pruefe->('K3 Linktext [a \\< b] -> a &lt; b (nicht &amp;lt;)',
        inline('[a \\< b](FAQ.md)', \%hier) eq '<a href="' . $GITHUB . 'Doku/FAQ.md">a &lt; b</a>');
    $pruefe->('K3 Linktext [x \\& y] -> x &amp; y, ohne Rueckstrich',
        inline('[x \\& y](#strg--buchstabe)', \%hier) eq '<a href="#strg--buchstabe">x &amp; y</a>');
    $pruefe->('K3 Linktext mit `Code` und *kursiv*',
        inline('[*a* `<b>`](#strg--buchstabe)', \%hier) eq '<a href="#strg--buchstabe"><em>a</em> <code>&lt;b&gt;</code></a>');
    $pruefe->('K3 Linkziel mit Klammern bleibt ganz',
        inline('[foo](https://e.org/a_(b))', \%hier) eq '<a href="https://e.org/a_(b)">foo</a>');
    $pruefe->('K3 Gegenrichtung: Link in Klammern schliesst nicht mit der aeusseren Klammer',
        inline('(siehe [foo](https://e.org/a))', \%hier) eq '(siehe <a href="https://e.org/a">foo</a>)');
    $pruefe->('K3 slug laesst _ stehen wie GitHub', slug('`IDS_INI_X` Wert') eq 'ids_ini_x-wert');
    # Links
    $pruefe->('Anker auf der Seite bleibt',
        inline('[x](#strg--buchstabe)', \%hier) eq '<a href="#strg--buchstabe">x</a>');
    $pruefe->('Anker anderswo -> GitHub FUNKTIONEN.md',
        inline('[*Edit*](#edit)', \%hier) eq '<a href="' . $GITHUB . 'Doku/FUNKTIONEN.md#edit"><em>Edit</em></a>');
    $pruefe->('FAQ.md (gleiches Verzeichnis) -> GitHub Doku/FAQ.md',
        link_ziel('FAQ.md#12-x', \%hier) eq $GITHUB . 'Doku/FAQ.md#12-x');
    $pruefe->('http bleibt', link_ziel('https://example.org/a', \%hier) eq 'https://example.org/a');
    $pruefe->('kein relativer .md-Link bleibt stehen',
        inline('[a](ANWENDER.md) [b](../README.md#x)', \%hier) !~ /href="(?!https:)/);
    # K6: interne Verweise als Text, oeffentliche auf die Release-Marke
    $pruefe->('K6 ../Intern/BEFUNDE.md#e-75 -> nur Text "E-75"',
        inline('([E-75](../Intern/BEFUNDE.md#e-75), *Halbsatz*)', \%hier) eq '(E-75, <em>Halbsatz</em>)');
    $pruefe->('K6 Befunde/, Arbeitsweise/, tools/ -> kein Link',
        inline('[a](../Befunde/X.md) [b](../Arbeitsweise/y.md) [c](../tools/z.pl)', \%hier) !~ /<a /);
    $pruefe->('K6 Gegenrichtung: Doku/FAQ.md bleibt ein Link',
        inline('[FAQ 9](FAQ.md#9-x)', \%hier) =~ m{<a href="\Q$GITHUB\EDoku/FAQ\.md#9-x">});
    {
        my $vorher = $GITHUB;
        my $c = git_ausgabe('log', '-1', '--format=%H', '--', $QUELLPFAD) // '';
        $c =~ s/\s+//g;
        stand_der_quelle("$ROOT/$QUELLPFAD", 1);
        my $sauber = (git_ausgabe('status', '--porcelain', '--', $QUELLPFAD) // 'x') !~ /\S/;
        if ($sauber && $c =~ /^[0-9a-f]{40}$/) {
            $pruefe->('N2 saubere Quelle: Doku-Links zeigen auf blob/<commit der Quelle>/',
                link_ziel('ANWENDER.md', \%hier) eq "https://github.com/HansWurst81675/Eudora7.2/blob/$c/Doku/ANWENDER.md");
        } else {
            $pruefe->('N2 Quelle nicht committet: Doku-Links zeigen auf main',
                link_ziel('ANWENDER.md', \%hier) eq 'https://github.com/HansWurst81675/Eudora7.2/blob/main/Doku/ANWENDER.md');
        }
        $GITHUB = $vorher;
    }
    $pruefe->('K6 Name neutral: "hatte Gregors Serverpostfach geleert"',
        neutral('*hatte Gregors Serverpostfach geleert*') eq '*hatte ein Serverpostfach geleert*');
    # Anker
    $pruefe->('slug: 3. *Tools \x{2192} Options*',  slug("3. *Tools \x{2192} Options*") eq '3-tools--options');
    $pruefe->('slug: Umlaut bleibt', slug("2. Tastenk\x{fc}rzel auf einen Blick") eq "2-tastenk\x{fc}rzel-auf-einen-blick");
    $pruefe->('slug: `Eudora.ini`-Schluessel', slug("5. `Eudora.ini`-Schl\x{fc}ssel ohne Optionsseite") eq "5-eudoraini-schl\x{fc}ssel-ohne-optionsseite");
    # Tabelle
    my @c = zellen('| `a|b` | x \\| y | z |');
    $pruefe->('Tabelle: | in Code und \\| trennen nicht', @c == 3 && $c[0] eq '`a|b`' && $c[1] eq 'x \\| y');
    $h = md_bloecke(["| A | B |", "|---|---|", "| 1 | 2 |", "", "Text"], \%hier);
    $pruefe->('Tabelle -> <table> mit <th> und <td>', $h =~ m{<table>.*<th>A</th>.*<td>2</td>.*</table>.*<p>Text</p>}s);
    $h = md_bloecke(["* eins", "  weiter", "* zwei"], \%hier);
    $pruefe->('Liste mit Fortsetzungszeile', $h eq "<ul>\n<li>eins weiter</li>\n<li>zwei</li>\n</ul>\n");
    # Seite: Abschnitt gefunden / fehlt / leer
    my $zeilen = join('', map { "| z$_ | [S](#strg--buchstabe) |\n" } 1 .. 5);
    my $md = "# T\n\n## 1. Menues\n\nx\n\n### *Edit*\n\n## 2. Tastenk\x{fc}rzel auf einen Blick\n\n### Strg + Buchstabe\n\n| a | b |\n|---|---|\n| [E](#edit) | [S](#strg--buchstabe) |\n$zeilen\n## 3. Weiter\n\nnicht dabei\n";
    my $s = { datei => 't.html', titel => 'T', menue => 'M', teile => [ qr/Tastenk\x{fc}rzel auf einen Blick/ ] };
    $h = eval { seite_bauen($md, $s, '9.9', 'heute') };
    $pruefe->('Seite: Abschnitt gefunden, Folgeabschnitt nicht dabei', defined $h && $h =~ /Strg \+ Buchstabe/ && $h !~ /nicht dabei/);
    $pruefe->('Seite: Anker der Seite bleibt, fremder geht nach GitHub',
        defined $h && $h =~ /href="#strg--buchstabe"/ && $h =~ /href="\Q${GITHUB}\EDoku\/FUNKTIONEN.md#edit"/);
    $pruefe->('Seite: id an der Ueberschrift', defined $h && $h =~ /<h3 id="strg--buchstabe">/);
    $pruefe->('Seite: Kopf mit Fassung und Vorlage-Hinweis', defined $h && $h =~ /Eudora 9\.9/ && $h =~ /Vorlage/ && $h =~ /charset="utf-8"/);
    $pruefe->('Seite: keine externe Ressource', defined $h && $h !~ /<(?:script|link|img)\b/i && $h !~ /\@import/);
    my $s2 = { %$s, teile => [ qr/Gibt es nicht/ ] };
    $h = eval { seite_bauen($md, $s2, '9.9', 'heute') };
    $pruefe->('Seite: fehlender Abschnitt bricht ab', !defined $h && $@ =~ /nicht gefunden/);
    # K2: Abschnitt da, aber leer bzw. nur ein Satz -> Abbruch
    my $leer = "# T\n\n## 2. Tastenk\x{fc}rzel auf einen Blick\n\nfolgt\n\n## 3. Weiter\n\nx\n";
    $h = eval { seite_bauen($leer, $s, '9.9', 'heute') };
    $pruefe->('K2 leerer Abschnitt ("folgt") bricht ab', !defined $h && $@ =~ /nur 0 Tabellenzeilen/);
    my $vier = $md; $vier =~ s/\| z[2-5] \|[^\n]*\n//g;
    $h = eval { seite_bauen($vier, $s, '9.9', 'heute') };
    $pruefe->('K2 Abschnitt mit 2 Tabellenzeilen bricht ab', !defined $h && $@ =~ /nur 2 Tabellenzeilen/);
    # K6: unbekannter Name bricht ab, bekannter wird ersetzt
    (my $mitname = $md) =~ s/\| z1 \|/| Gregor sagt |/;
    $h = eval { seite_bauen($mitname, $s, '9.9', 'heute') };
    $pruefe->('K6 Name ohne neutrale Fassung bricht ab', !defined $h && $@ =~ /Personenname/);
    (my $bekannt = $md) =~ s/\| z1 \|/| Gregors Protokolle tragen |/;
    $h = eval { seite_bauen($bekannt, $s, '9.9', 'heute') };
    $pruefe->('K6 bekannter Name wird ersetzt, Seite entsteht',
        defined $h && $h =~ /die Protokolle der Testl\x{e4}ufe tragen/ && $h !~ /Gregor/);
    # Gegen die echte Datei, wenn vorhanden
    my $echt = "$ROOT/$QUELLPFAD";
    if (-f $echt) {
        my $m = lies_utf8($echt);
        for my $seite (@SEITEN) {
            my $x = eval { seite_bauen($m, $seite, 'T', 'T') };
            $pruefe->("echte Quelle: $seite->{datei} entsteht", defined $x && length($x) > 2000);
            my @tote = defined $x ? grep { my $a = $_; $x !~ /id="\Q$a\E"/ } ($x =~ /href="#([^"]+)"/g) : ('?');
            $pruefe->("echte Quelle: $seite->{datei} hat keinen toten Seitenanker (@tote)", !@tote);
            my @intern = defined $x ? ($x =~ m{href="[^"]*/(?:Intern|Befunde|Arbeitsweise|tools)/[^"]*"}g) : ('?');
            $pruefe->("echte Quelle: $seite->{datei} verlinkt nichts Internes (" . scalar(@intern) . ")", !@intern);
            if ($seite->{datei} eq 'Einstellungen.html') {
                # Gregor 02.11.2026: "ist denn alles im abschnitt [settings]?"
                # - der Abschnitt ueber die Abschnitte muss mit auf die Seite,
                # samt Sprungziel fuer die Kontoschluessel.
                $pruefe->('echte Quelle: Einstellungen.html enthaelt "Die Abschnitte der Eudora.ini" mit [Persona-&lt;Name&gt;]',
                    defined $x && $x =~ /Die Abschnitte der <code>Eudora\.ini<\/code>/ && $x =~ /\[Persona-&lt;Name&gt;\]/
                    && $x =~ /id="was-ein-zus\x{e4}tzliches-konto-eigens-haben-kann"/
                    && $x =~ /href="#was-ein-zus\x{e4}tzliches-konto-eigens-haben-kann"/);
            }
        }
        # N2, Gegenprobe am ganzen Lauf: mit --fassung 7.2.2.132 erzeugte
        # Seiten verlinken NICHT auf die Marke v7.2.2.132 (die es nicht gibt).
        my $tmp = File::Spec->catdir(File::Spec->tmpdir(), "hilfe-html-selbsttest-$$");
        my $rc = system($^X, $0, $tmp, '--fassung', '7.2.2.132') >> 8;
        my $alles = '';
        for my $d ('Tastenkuerzel.html', 'Einstellungen.html') {
            if (open(my $fh, '<:raw', "$tmp/$d")) { local $/; $alles .= <$fh> // ''; close $fh; unlink "$tmp/$d"; }
        }
        rmdir $tmp;
        $pruefe->('N2 Lauf mit --fassung 7.2.2.132: Seiten entstehen, Kopf nennt die Nummer',
            $rc == 0 && $alles =~ /Eudora 7\.2\.2\.132 &middot;/);
        $pruefe->('N2 Lauf mit --fassung 7.2.2.132: kein Link auf blob/v7.2.2.132/',
            $alles ne '' && $alles !~ m{blob/v7\.2\.2\.132/});
    }
    print "\nhilfe-html --selbsttest: $ok ok, $nok FEHLER\n";
    return $nok ? 1 : 0;
}
