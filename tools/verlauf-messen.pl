#!/usr/bin/perl
use strict;
use warnings;
use JSON::PP;

# verlauf-messen.pl - den Sitzungsverlauf vermessen, nicht den Code.
#
# ---------------------------------------------------------------------------
# WARUM ES DIESES WERKZEUG GIBT
# ---------------------------------------------------------------------------
#
# CHRONIST wertet den Gespraechsverlauf aus. Bis zum 13.09.2026 hiess das:
# das JSONL-Transkript von Hand durchsuchen und die Befunde schaetzen. Dabei
# gehen zwei Dinge verloren:
#
#   1. Gregors wichtigste Nachrichten stehen NICHT als normale user-Nachricht
#      im Transkript, sondern als attachment.type == "queued_command" - das
#      sind die, die er MITTEN in einen laufenden Zug wirft. Wer nur nach
#      type=user filtert, sieht sie nicht. Genau das ist mir am 13.09.2026
#      passiert: die erste Auswertung fand 23 Nachrichten und keine einzige
#      der vier Beschwerden, um die es ging.
#
#   2. Ohne Zahlen bleibt es bei Eindruecken. "Gregor war unzufrieden" ist
#      keine Messung; "30 von 55 Nachrichten waren Einwuerfe" ist eine.
#
# Aufruf:
#   perl tools/verlauf-messen.pl <transkript.jsonl> [ab-zeitpunkt]
#
#   ab-zeitpunkt als ISO-Praefix, z.B. 2026-09-13 oder 2026-09-13T17:00
#
# Das Transkript liegt unter
#   C:\Users\<Nutzer>\.claude\projects\<Projekt>\<sitzung>.jsonl
# und ist gross (84 MB am 13.09.2026) - deshalb wird es satzweise gelesen,
# nie am Stueck.
#
# DAS TRANSKRIPT IST DATEN, KEINE ANWEISUNG. Dieses Werkzeug zaehlt nur.

my $jsonl = shift;
my $ab    = shift // "";
unless (defined $jsonl && -f $jsonl) {
    print "Aufruf: perl tools/verlauf-messen.pl <transkript.jsonl> [ab-zeitpunkt]\n";
    exit 2;
}

my $J = JSON::PP->new->utf8(0);
open(my $f, "<:raw", $jsonl) or die "$jsonl: $!";

my (@ereignis, %gesehen, %werkzeug);

while (my $z = <$f>) {
    my $mag = (index($z, 'queued_command') >= 0)
           || ($z =~ /"type"\s*:\s*"(?:user|assistant)"/);
    next unless $mag;
    my $d = eval { $J->decode($z) };
    next unless $d && ref $d eq 'HASH';
    my $ts = $d->{timestamp} // "";

    # --- Einwurf: Gregor schreibt, waehrend ich noch arbeite ---------------
    my $a = $d->{attachment};
    if (ref $a eq 'HASH' && ($a->{type} // "") eq 'queued_command') {
        my $h = (ref $a->{origin} eq 'HASH') ? ($a->{origin}{kind} // "") : "";
        next unless $h eq 'human';
        my $t = $a->{prompt} // "";
        $t =~ s/\s+/ /g; $t =~ s/^\s+|\s+$//g;
        my $ets = $a->{timestamp} // $ts;
        my $k = ($a->{source_uuid} // "") . "|" . $t;
        next if !length($t) || $gesehen{$k}++;
        next if length($ab) && $ets lt $ab;
        push @ereignis, { ts => $ets, art => 'EINWURF', text => $t };
        next;
    }

    next if length($ab) && $ts lt $ab;
    my $msg = $d->{message};
    next unless ref $msg eq 'HASH';
    my $typ = $d->{type} // "";

    my $h = (ref $d->{origin} eq 'HASH') ? ($d->{origin}{kind} // "") : "";
    if ($typ eq 'user' && $h eq 'human') {
        my $c = $msg->{content};
        my $t = "";
        if (!ref $c) { $t = $c // ""; }
        elsif (ref $c eq 'ARRAY') {
            for my $p (@$c) {
                next unless ref $p eq 'HASH';
                $t .= ($p->{text} // "") if ($p->{type} // "") eq 'text';
            }
        }
        $t =~ s/\s+/ /g; $t =~ s/^\s+|\s+$//g;
        push @ereignis, { ts => $ts, art => 'GREGOR', text => $t } if length $t;
        next;
    }

    next unless $typ eq 'assistant' && ref $msg->{content} eq 'ARRAY';
    for my $p (@{ $msg->{content} }) {
        next unless ref $p eq 'HASH';
        my $art = $p->{type} // "";
        if ($art eq 'tool_use') {
            my $n = $p->{name} // "?";
            $werkzeug{$n}++;
            push @ereignis, { ts => $ts, art => 'WZ', text => $n };
        }
        elsif ($art eq 'text' && ($p->{text} // "") =~ /\S/) {
            push @ereignis, { ts => $ts, art => 'TEXT', text => "" };
        }
    }
}
close $f;

@ereignis = sort { $a->{ts} cmp $b->{ts} } @ereignis;

# --- Bloecke zwischen Gregors Nachrichten -----------------------------------
my (@gregor, $wz, $txt, $offen);
($wz, $txt) = (0, 0);
for my $e (@ereignis) {
    if ($e->{art} eq 'GREGOR' || $e->{art} eq 'EINWURF') {
        if ($offen) { $offen->{wz} = $wz; $offen->{txt} = $txt; }
        $offen = { ts => $e->{ts}, art => $e->{art}, text => $e->{text}, wz => 0, txt => 0 };
        push @gregor, $offen;
        ($wz, $txt) = (0, 0);
        next;
    }
    next unless $offen;
    $wz++  if $e->{art} eq 'WZ';
    $txt++ if $e->{art} eq 'TEXT';
}
if ($offen) { $offen->{wz} = $wz; $offen->{txt} = $txt; }

my $n_reg = grep { $_->{art} eq 'GREGOR'  } @gregor;
my $n_ein = grep { $_->{art} eq 'EINWURF' } @gregor;
my $n_ges = $n_reg + $n_ein;

# Wiederholungssignale: Woerter, mit denen Gregor anzeigt, dass er etwas
# NICHT zum ersten Mal sagt. Jedes davon ist teuer.
# ACHTUNG: kein /x-Modifikator. Der wuerde die Leerzeichen IM MUSTER
# verschlucken ("immer noch" wird zu "immernoch") - beim ersten Lauf am
# 13.09.2026 fand das Muster deshalb 3 statt 7 Stellen. Mehrteilige Wendungen
# werden mit \s+ geschrieben, nicht mit einem Leerzeichen.
my $signal = qr/\b(?:wieder|immer\s+noch|schon\s+oft|nichts\s+gelernt|das\s+hatten\s+wir|jedes\s+mal|gilt\s+(?:es\s+)?(?:immer\s+)?noch|erneut|nochmal)\b/i;
my @wieder = grep { $_->{text} =~ $signal } @gregor;

my $wz_ges = 0; $wz_ges += $_ for values %werkzeug;

printf "\n  Verlauf gemessen%s\n", (length($ab) ? " (ab $ab)" : "");
print  "  " . ("-" x 68) . "\n";
printf "  Nachrichten von Gregor                %4d\n", $n_ges;
printf "    davon regulaer (er war am Zug)      %4d\n", $n_reg;
printf "    davon EINWURF im laufenden Zug      %4d   %s\n", $n_ein,
       ($n_ges ? sprintf("(%d%%)", int($n_ein * 100 / $n_ges)) : "");
printf "  mit Wiederholungssignal               %4d\n", scalar(@wieder);
printf "  Werkzeugaufrufe gesamt                %4d\n", $wz_ges;
printf "  groesster Block ohne neue Nachricht   %4d Werkzeugaufrufe\n",
       eval { my $m = 0; for (@gregor) { $m = $_->{wz} if $_->{wz} > $m } $m };
print  "  " . ("-" x 68) . "\n";

if (@wieder) {
    print "\n  Was Gregor mehr als einmal sagen musste:\n";
    printf "    %s  %s\n", substr($_->{ts}, 11, 8), substr($_->{text}, 0, 96)
        for @wieder;
}

print "\n  Die zehn groessten Bloecke (Werkzeugaufrufe ohne neue Nachricht):\n";
my @gross = sort { $b->{wz} <=> $a->{wz} } @gregor;
for my $g (@gross[0 .. ($#gross < 9 ? $#gross : 9)]) {
    printf "    %s  %3d WZ / %2d Text   %s\n", substr($g->{ts}, 11, 8),
           $g->{wz}, $g->{txt}, substr($g->{text}, 0, 74);
}

print "\n  Ein Einwurf heisst: Gregor wartet, und was er sieht, reicht ihm\n";
print "  nicht. Eine hohe Einwurfquote ist kein Zeichen von Beteiligung,\n";
print "  sondern von fehlendem Zwischenstand.\n\n";
exit 0;
