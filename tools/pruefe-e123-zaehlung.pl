#
# pruefe-e123-zaehlung.pl - die Wache beim Beenden muss JEDE Uebertragung sehen.
#
# WARUM ES DAS GIBT
#
# Gregor am 20.10.2026 an Paket 1.0.110: "verschoben und beendet. fenster ging
# gleich weg". Sein Protokoll:
#
#   E-123 Warteschlange: konto=1 eintraege=1 zustand=0 nur-belegt=0
#                        laeuft=0 uebertragungen=0
#
# Ein Eintrag in der Warteschlange, gezaehlt als NULL. In actionqueue.dat stand
# <ActionType>transfersame</ActionType> mit fuenf Nachrichten - eine
# Verschiebung INNERHALB desselben IMAP-Kontos. Gezaehlt wurde aber nur
# CImapFromLocalTransferMsgAction, also der Weg aus einem LOKALEN Postfach.
# Drei Viertel der Uebertragungsarten waren blind.
#
# Dasselbe war schon einmal da: PRUEFER-36 P2 fand, dass der Hochladezaehler
# in einer Funktion stand, die die gemeinte Unterklasse gar nicht ruft. Beim
# zweiten Auftreten einer Fehlerklasse gehoert eine Schranke her
# (Arbeitsweise/fehlerklassen-abstellen.md).
#
# WAS GEPRUEFT WIRD
#
# In ImapActionQueue.cpp duerfen die drei E-123-Stellen - die Zaehlschleife in
# E123OffeneUebertragungen, der Merker m_bE123UebertragungLaeuft und ein
# etwaiger weiterer dynamic_cast im selben Umfeld - NICHT auf eine Unterklasse
# von CImapTransferMsgAction pruefen. Erlaubt ist allein die Basisklasse.
#
# GEGENPROBE: --selbsttest fuehrt beide Faelle an erfundenem Text vor.
#
use strict; use warnings;
use FindBin;

my $quelle = "$FindBin::Bin/../Eudora71/EuImap/src/ImapActionQueue.cpp";

# Die Unterklassen, die hier nicht stehen duerfen.
my @unterklassen = qw(
    CImapFromLocalTransferMsgAction
    CImapToLocalTransferMsgAction
    CImapSameServerTransferMsgAction
    CImapCrossServerTransferMsgAction
);

sub pruefe_text {
    my ($text) = @_;
    my @mangel;
    my @zeilen = split /\n/, $text;
    my $in_zaehlung = 0;
    for my $i (0 .. $#zeilen) {
        my $z = $zeilen[$i];
        $in_zaehlung = 1 if $z =~ /E123OffeneUebertragungen/;
        $in_zaehlung = 0 if $in_zaehlung && $z =~ /^\}/;
        my $trifft = $in_zaehlung || $z =~ /m_bE123UebertragungLaeuft\s*=/;
        next unless $trifft;
        next if $z =~ m{^\s*//};                 # Kommentare zaehlen nicht
        for my $u (@unterklassen) {
            push @mangel, sprintf('Zeile %d: dynamic_cast auf %s statt auf CImapTransferMsgAction', $i + 1, $u)
                if $z =~ /dynamic_cast\s*<\s*\Q$u\E\s*\*/;
        }
    }
    return @mangel;
}

if (@ARGV and $ARGV[0] eq '--selbsttest') {
    my $schlecht = join("\n",
        'int CActionQueue::E123OffeneUebertragungen(bool &b, bool &c)',
        '{',
        '    if (dynamic_cast<CImapFromLocalTransferMsgAction*>(x)) { ++n; }',
        '}',
        '    m_bE123UebertragungLaeuft = (dynamic_cast<CImapSameServerTransferMsgAction*>(p) != NULL);',
    );
    my $gut = join("\n",
        'int CActionQueue::E123OffeneUebertragungen(bool &b, bool &c)',
        '{',
        '    // frueher stand hier CImapFromLocalTransferMsgAction',
        '    if (dynamic_cast<CImapTransferMsgAction*>(x)) { ++n; }',
        '}',
        '    m_bE123UebertragungLaeuft = (dynamic_cast<CImapTransferMsgAction*>(p) != NULL);',
    );
    my @r = pruefe_text($schlecht);
    my @g = pruefe_text($gut);
    my $fehler = 0;
    unless (@r == 2) { print "  FEHLER: schlechter Text ergibt " . scalar(@r) . " Mangel, erwartet 2\n"; $fehler++ }
    unless (@g == 0) { print "  FEHLER: guter Text ergibt " . scalar(@g) . " Mangel, erwartet 0\n"; $fehler++ }
    printf "pruefe-e123-zaehlung --selbsttest: 2 Faelle, %d Fehler\n", $fehler;
    exit($fehler ? 1 : 0);
}

unless (-f $quelle) {
    print "\nABBRUCH: $quelle nicht gefunden - die Schranke prueft sonst nichts.\n\n";
    exit 2;
}
open(my $f, '<:raw', $quelle) or die "$quelle: $!\n";
local $/; my $text = <$f>; close $f;

my @mangel = pruefe_text($text);
if (@mangel) {
    print "\n  E-123: die Wache beim Beenden sieht nicht jede Uebertragung\n\n";
    print "    - $_\n" for @mangel;
    print "\n  Gregor am 20.10.2026 an 1.0.110: \"verschoben und beendet. fenster\n";
    print "  ging gleich weg\". Sein Protokoll sagte eintraege=1 und zugleich\n";
    print "  uebertragungen=0 - eine Verschiebung innerhalb desselben IMAP-Kontos\n";
    print "  (transfersame) wurde nicht gezaehlt.\n\n";
    print "  Gezaehlt wird die BASISKLASSE CImapTransferMsgAction: jede\n";
    print "  Uebertragungsaufgabe muss noch mit dem Server reden, gleich aus\n";
    print "  welcher Richtung.\n\n";
    exit 1;
}
print "  ok  E-123-Zaehlung prueft die Basisklasse, keine Uebertragungsart ist blind.\n";
exit 0;
