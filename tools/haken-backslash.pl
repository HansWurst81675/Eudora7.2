#!/usr/bin/perl
# haken-backslash.pl - PreToolUse-Haken (Bash und PowerShell): kein Ersatztext
# mit Backslash ueber die Shell.
#
# WARUM ES DAS GIBT. Die Lehre Arbeitsweise/text-nicht-durch-schichten-
# schicken.md sagt seit Wochen: Ersatztext mit Backslashes nie inline durch die
# Shell, sondern mit dem Write-Werkzeug in eine Datei und von dort einsetzen.
# Am 06.11.2026 ging es trotzdem viermal schief, jedes Mal ohne Fehlermeldung:
# zwei Pfadschranken (aus '\\E239' wurde '\E239', E-239 nahm danach jeden Pfad
# an), ein Perl-Skript aus einem Heredoc, ein maskierter Punkt in einer
# perl -i -Ersetzung und zuletzt der Nachtrag der Lehre selbst. Gregor: "du
# kannst dir immer noch nicht merken, welche tools du fuer welche zwecke
# nimmst?" Die Lehre hatte nur tools/pruefe-rueckstrich.pl (Windows-Pfade
# ohne Rueckstrich); einen verlorenen Backslash in einem Suchausdruck sieht
# die nicht. Dieser Haken steht davor: am Befehl, bevor geschrieben wird.
#
# WAS ES ABWEIST.
#   1. Ein Heredoc (<<EOF, <<'EOF', <<-EOF ...), dessen Text einen DOPPELTEN
#      Backslash enthaelt - ausser er geht an git commit / gh (Commit- und
#      PR-Texte, kein Quelltext).
#   2. perl mit -i (Datei an Ort und Stelle aendern), wenn im Ersatzteil eines
#      s/.../.../ ein doppelter Backslash steht.
#   Verloren ging am 06.11.2026 jedes Mal ein doppelter Backslash (aus \\ wurde
#   \). Einfache Backslashes - \. im Suchmuster, \/ \n \$ im Ersatz - wirkten
#   richtig (gemessen am Verlauf: 651 Befehle der Sitzung durch den Haken
#   gefahren) und bleiben erlaubt.
#
# Aufruf als Haken: JSON auf STDIN (tool_input.command), Rueckgabe 2 = abweisen.
# Gegenprobe: perl tools/haken-backslash.pl --selbsttest
#
# Kodierung: reines ASCII.
use strict;
use warnings;
use JSON::PP;

selbsttest() if ($ARGV[0] // '') eq '--selbsttest';

local $/;
my $ein = <STDIN> // '';
my $j = eval { decode_json($ein) } || {};
# Unlesbares JSON oeffnet die Schranke nicht: dann wird der Rohtext geprueft.
my $kommando = defined $j->{tool_input}{command} ? $j->{tool_input}{command} : $ein;
my $grund = pruefen($kommando);
exit 0 unless defined $grund;

print STDERR <<"TEXT";
KEIN ERSATZTEXT MIT BACKSLASH UEBER DIE SHELL: $grund
Den Text mit dem Write-Werkzeug in eine Datei schreiben und von dort einsetzen
(Zeilenanker, Trefferzahl pruefen) - oder den Backslash als chr(92) erzeugen.
Danach die Zeile mit grep -o zuruecklesen. Am 06.11.2026 viermal ohne
Fehlermeldung Backslashes verloren (Arbeitsweise/text-nicht-durch-schichten-schicken.md).
TEXT
exit 2;

# Liefert einen Grund (Text) oder undef.
sub pruefen {
    my ($k) = @_;
    # --- 1. Heredocs ---------------------------------------------------
    while ($k =~ /<<-?\s*(['"]?)([A-Za-z_][A-Za-z0-9_]*)\1/g) {
        my $marke = $2;
        my $start = pos($k);
        my $vor = substr($k, 0, $start);
        my ($kopfzeile) = $vor =~ /([^\n]*)\z/;
        my $nach = substr($k, $start);
        $nach =~ s/^[^\n]*\n//;    # Rest der Kopfzeile
        my ($text) = $nach =~ /\A(.*?)^\s*\Q$marke\E\s*$/ms;
        $text = $nach unless defined $text;
        next unless $text =~ /\\\\/;
        next if $kopfzeile =~ /\bgit\s+(-C\s+\S+\s+)?commit\b/ || $kopfzeile =~ /\bgh\s+(pr|issue|release)\b/;
        return "Heredoc <<$marke enthaelt einen doppelten Backslash";
    }
    # --- 2. perl -i mit Backslash im Ersatzteil -------------------------
    while ($k =~ /\bperl(\s+-[A-Za-z0-9]+)*\s+-[A-Za-z]*i[A-Za-z]*\b/g) {
        my $rest = substr($k, pos($k));
        # das Programm in einfachen Anfuehrungszeichen hinter -e/-pe/-ne
        my ($prog) = $rest =~ /-[A-Za-z]*e\s+'([^']*)'/;
        next unless defined $prog;
        while ($prog =~ m{\bs/((?:\\.|[^/\\])*)/((?:\\.|[^/\\])*)/}g) {
            return "perl -i: doppelter Backslash im Ersatzteil von s/.../.../" if $2 =~ /\\\\/;
        }
        while ($prog =~ m#\bs\{((?:\\.|[^\\\}])*)\}\{((?:\\.|[^\\\}])*)\}#g) {
            return "perl -i: doppelter Backslash im Ersatzteil von s{...}{...}" if $2 =~ /\\\\/;
        }
    }
    return undef;
}

sub selbsttest {
    my $f = 0; my $n = 0;
    my @rot = (
        [ 'Heredoc mit Pfadschranke (06.11.2026)',
          qq{cat > "\$S/n239.txt" <<'EOF'\nif (\$voll -notmatch '^C:\\\\Temp\\\\E239[^\\\\]*\$') { exit 2 }\nEOF\n} ],
        [ 'Heredoc mit Perl-Skript (06.11.2026)',
          qq{cat > "\$S/vz.pl" <<'EOF'\nmy \@p = split /\\\\/, \$d;\nEOF\nperl "\$S/vz.pl"} ],
        [ 'Heredoc an eine Lehre angehaengt (06.11.2026)',
          qq{cat >> \$M/lehre.md <<'EOF'\naus `'\\\\E239'` wurde ...\nEOF} ],
        [ 'perl -i mit maskiertem Punkt im Ersatzteil (06.11.2026)',
          q{perl -i -pe '$n += s/\[a-z0-9-\]\+\\\\\.\(de/[a-z0-9.-]+\\\\.(de/' tools/x.ps1} ],
        [ 'perl -i mit s{}{} und Backslash im Ersatz',
          q{perl -i -pe 's{alt}{neu\\\\pfad}' x.txt} ],
    );
    my @gruen = (
        [ 'grep mit Backslash, schreibt nichts',      q{grep -n -E "a\|b" datei.txt} ],
        [ 'perl -ne liest nur',                       q{perl -ne 'print if /\d+\.\d+/' x.txt} ],
        [ 'perl -i mit Backslash nur im Suchmuster',  q{perl -i -pe 's/7\.2\.2\.136/7.2.2.137/' x.md} ],
        [ 'perl -i ohne Backslash',                   q{perl -i -pe 's/alt/neu/' x.md} ],
        [ 'perl -i mit \/, \n und \$ im Ersatz (wirkte am 06.11. richtig)', q{perl -i -pe 's/^Schranke: keine/Schranke: tools\/x.pl\n\$n/' x.md} ],
        [ 'Commit-Nachricht im Heredoc',              qq{git commit -q -F - <<'EOF'\nPfad C:\\\\Users\\\\x\nEOF} ],
        [ 'gh pr create im Heredoc',                  qq{gh pr create --body-file - <<'EOF'\nC:\\\\Temp\nEOF} ],
        [ 'Heredoc ohne Backslash',                   qq{cat > x.txt <<'EOF'\nnur Text\nEOF} ],
    );
    for my $c (@rot)   { $n++; my $r = pruefen($c->[1]); my $ok = defined $r; $f++ unless $ok; printf "  [%s] abgewiesen: %s\n", $ok ? ' ok ' : 'FEHL', $c->[0]; }
    for my $c (@gruen) { $n++; my $r = pruefen($c->[1]); my $ok = !defined $r; $f++ unless $ok; printf "  [%s] erlaubt:    %s%s\n", $ok ? ' ok ' : 'FEHL', $c->[0], $ok ? '' : " ($r)"; }
    print "  Selbsttest: $n Faelle, $f fehlgeschlagen\n";
    exit($f ? 1 : 0);
}
