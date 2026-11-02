#!/usr/bin/perl
# funktionen-auslesen.pl - liest Menues, Optionsseiten und INI-Vorgaben aus
# Eudora71/Eudora/EudoraRes.rc (mit resource.h) und gibt sie als Tabellen aus.
# Quelle fuer Doku/FUNKTIONEN.md ("Was Eudora kann und wo man es findet").
#
#   perl tools/funktionen-auslesen.pl --menues            alle MENU-Ressourcen
#   perl tools/funktionen-auslesen.pl --menue IDR_MAINFRAME  nur eine
#   perl tools/funktionen-auslesen.pl --optionen          Tools > Options, Seiten 2..33
#   perl tools/funktionen-auslesen.pl --ini Name|IDS_INI_X ...   Schluessel nachsehen
#   perl tools/funktionen-auslesen.pl --kuerzel           alle Tastenkuerzel, mit Behandlern
#   perl tools/funktionen-auslesen.pl --zaehlen           nur die Zahlen
#   perl tools/funktionen-auslesen.pl --selbsttest
#
# Was gelesen wird (jede Regel aus dem Code, nicht geraten):
# * Statuszeilentext: STRINGTABLE "Beschreibung\nKurz" - der Teil vor \n.
# * Tastenkuerzel: der Teil hinter \t im Menuetext, dazu die Eintraege der
#   Tabelle IDR_MAINFRAME ACCELERATORS fuer dieselbe Kennung.
# * Optionsseiten: CSettingsDialog::OnInitDialog (settings.cpp) laedt die
#   Dialoge mit Ressourcennummer 2, 3, ... (IDD_SETTINGS_FIRST_CAT + 1) bis zur
#   ersten fehlenden; die Liste ist unsortiert, also Reihenfolge = Nummer.
#   Ein Steuerelement gehoert zu einem INI-Schluessel, wenn (Kennung & 0x7FFF)
#   zwischen 10000 und 19999 liegt; ist Bit 0x8000 gesetzt, zeigt das
#   Haekchen das Gegenteil des gespeicherten Werts (settings.cpp, "If the high
#   bit of the ID is set").
# * INI-Abschnitt aus der Nummer: GetSectionID (rs.cpp): bis 10800 [Settings],
#   10801-10900 [Debug], 10901-11100 [Window Position], darueber [Settings].
#
# Ausgabe UTF-8 (die .rc ist Latin-1).
use strict;
use warnings;
use utf8;

my $ROOT = $0; $ROOT =~ s{[\\/]tools[\\/][^\\/]+$}{}; $ROOT = '.' if $ROOT eq $0;
my $RC   = "$ROOT/Eudora71/Eudora/EudoraRes.rc";
my $RH   = "$ROOT/Eudora71/Eudora/resource.h";

binmode STDOUT, ':encoding(UTF-8)';

if (@ARGV && $ARGV[0] eq '--selbsttest') { exit selbsttest(); }

my (%val, %str, %strzeile, @rc);
lade_rh($RH);
lade_rc($RC);

my $modus = shift @ARGV // '--zaehlen';
if    ($modus eq '--menues')   { menues(undef) }
elsif ($modus eq '--menue')    { menues($ARGV[0]) }
elsif ($modus eq '--optionen') { optionen() }
elsif ($modus eq '--ini')      { ini_zeigen(@ARGV) }
elsif ($modus eq '--zaehlen')  { zaehlen() }
elsif ($modus eq '--kuerzel')  { kuerzel() }
else { die "unbekannt: $modus\n" }
exit 0;

sub lade_rh {
    my ($f) = @_;
    open my $h, '<:raw', $f or die "$f: $!\n";
    while (<$h>) { $val{$1} = $2 if /^#define\s+(\w+)\s+(\d+)/; }
}

sub rc_text {   # Latin-1 -> Perl-Text, "" -> ", \" bleibt
    my ($s) = @_;
    $s =~ s/""/"/g;
    return $s;
}

sub lade_rc {
    my ($f) = @_;
    open my $h, '<:raw:encoding(latin1)', $f or die "$f: $!\n";
    @rc = map { s/\r?\n\z//r } <$h>;
    # STRINGTABLE: ID "text" oder ID allein und Text in der naechsten Zeile
    my $in = 0;
    for (my $i = 0; $i < @rc; $i++) {
        my $l = $rc[$i];
        if ($l =~ /^STRINGTABLE/) { $in = 1; next }
        next unless $in;
        if ($l =~ /^END/) { $in = 0; next }
        if ($l =~ /^\s+(\w+)\s+"((?:[^"]|"")*)"\s*$/) {
            $str{$1} = rc_text($2); $strzeile{$1} = $i + 1;
        } elsif ($l =~ /^\s+(\w+)\s*$/ && $i + 1 < @rc && $rc[$i+1] =~ /^\s+"(?:[^"]|"")*"\s*$/) {
            my ($id) = $l =~ /^\s+(\w+)/;
            my ($tx) = $rc[$i+1] =~ /"((?:[^"]|"")*)"/;
            $str{$id} = rc_text($tx); $strzeile{$id} = $i + 1;
            $i++;
        }
    }
}

sub beschreibung {   # Teil vor \n
    my ($id) = @_;
    return '' unless defined $str{$id};
    my ($b) = split /\\n/, $str{$id}, 2;
    return $b;
}

sub tasten {         # aus IDR_MAINFRAME ACCELERATORS
    my ($id) = @_;
    our %acc;
    unless (%acc) {
        my $in = 0; my $buf = ''; my $nr = 0; my $start;
        for my $l (@rc) {
            $nr++;
            if ($l =~ /^IDR_MAINFRAME ACCELERATORS/) { $in = 1; next }
            next unless $in;
            last if $l =~ /^END/;
            next if $l =~ /^BEGIN/;
            $start //= $nr;
            $buf .= $l;
            next if $buf =~ /,\s*$/;
            my @f = map { s/^\s+|\s+$//gr } split /,/, $buf; $buf = '';
            my ($k, $cmd, @mod) = @f;
            $k =~ s/"//g;
            my %m = map { $_ => 1 } @mod;
            my %vk = (VK_OEM_COMMA => ',', VK_OEM_PERIOD => '.', VK_OEM_5 => '\\',
                      VK_OEM_7 => "'", VK_DELETE => 'Entf', VK_INSERT => 'Einfg',
                      VK_RETURN => 'Enter', VK_BACK => 'Rück', VK_TAB => 'Tab',
                      VK_SPACE => 'Leertaste', VK_ESCAPE => 'Esc');
            $k = $vk{$k} // ($k =~ /^VK_(F\d+)$/ ? $1 : $k =~ s/^VK_//r);
            my $t = join '+', ($m{CONTROL} ? 'Strg' : ()), ($m{SHIFT} ? 'Umschalt' : ()),
                              ($m{ALT} ? 'Alt' : ()), $k;
            push @{ $acc{$cmd} }, $t;
            our @accliste; push @accliste, [$t, $cmd, $start]; undef $start;
        }
    }
    return @{ $acc{$id} // [] };
}

our (%menupfad, @menukuerzel, $STILL);

sub menues {
    my ($nur) = @_;
    local *STDOUT if $STILL;
    if ($STILL) { open STDOUT, '>', \my $wegwerf; binmode STDOUT, ':encoding(UTF-8)'; }
    for (my $i = 0; $i < @rc; $i++) {
        next unless $rc[$i] =~ /^(\w+)\s+MENU\s*$/;
        my $name = $1;
        next if defined $nur && $name ne $nur;
        print "\n## $name (EudoraRes.rc:", $i + 1, ")\n\n";
        print "| Pfad | Eintrag | Kürzel | Kennung | Statuszeile | Zeile |\n|---|---|---|---|---|---|\n";
        my @pfad; my $tiefe = 0;
        for ($i++; $i < @rc; $i++) {
            my $l = $rc[$i];
            if ($l =~ /^\s*BEGIN/) { $tiefe++; next }
            if ($l =~ /^\s*END/) { $tiefe--; pop @pfad if @pfad > $tiefe - 1 && @pfad; last if $tiefe == 0; next }
            if ($l =~ /^\s*POPUP\s+"((?:[^"]|"")*)"/) {
                my $t = menutext($1);
                splice @pfad, $tiefe - 1; push @pfad, $t;
                printf "| %s | **%s** ▸ | | | | %d |\n", join(' → ', @pfad[0..$#pfad-1]) || '—', $t, $i + 1;
                next;
            }
            if ($l =~ /^\s*MENUITEM\s+"((?:[^"]|"")*)",\s*(\w+)?/) {
                my ($t, $id) = ($1, $2);
                if (!defined $id && $i + 1 < @rc && $rc[$i+1] =~ /^\s+(\w+)/) { $id = $1 }
                my ($txt, $k) = split /\\t/, $t, 2;
                $txt = menutext($txt);
                my @k = map { s/Ctrl/Strg/r =~ s/Shift/Umschalt/r } grep { defined && length } ($k);
                for my $a (tasten($id)) { push @k, $a unless grep { norm($_) eq norm($a) } @k }
                my $pfad = join(' → ', @pfad[0..$tiefe-2], $txt);
                push @{ $menupfad{$id} }, "$name: $pfad";
                push @menukuerzel, [ $k =~ s/Ctrl/Strg/gr =~ s/Shift/Umschalt/gr, $id, "$name: $pfad", $i + 1 ] if defined $k && length $k;
                printf "| %s | %s | %s | `%s` | %s | %d |\n",
                    join(' → ', @pfad[0..$tiefe-2]) || '—', $txt, join(', ', @k), $id,
                    beschreibung($id), $i + 1;
            }
        }
    }
}

# --kuerzel: jede Zeile der Tastentabelle und jedes Kuerzel aus einem
# Menuetext, mit Statuszeilentext, Menueort und den Quelldateien, in denen
# die Kennung per ON_COMMAND behandelt wird (daraus folgt, in welchem Fenster
# das Kuerzel wirkt; die Tabelle selbst haengt am Rahmenfenster und gilt
# ueberall, MFC leitet den Befehl an das aktive Fenster weiter).
sub behandler {
    my ($id) = @_;
    our %beh;
    unless (%beh) {
        my $dir = "$ROOT/Eudora71/Eudora";
        opendir my $d, $dir or die "$dir: $!\n";
        for my $f (sort grep { /\.cpp$/i } readdir $d) {
            open my $h, '<:raw', "$dir/$f" or next;
            while (<$h>) {
                push @{ $beh{$1} }, $f if /ON_COMMAND(?:_EX)?\s*\(\s*(\w+)\s*,/;
                if (/ON_COMMAND(?:_EX)?_RANGE\s*\(\s*(\w+)\s*,\s*(\w+)/) { push @{ $beh{"$1..$2"} }, $f }
            }
        }
    }
    my %u; my @f = grep { !$u{$_}++ } @{ $beh{$id} // [] };
    for my $r (grep { /\.\./ } keys %beh) {
        my ($a, $b) = split /\.\./, $r;
        next unless defined $val{$a} && defined $val{$b} && defined $val{$id};
        push @f, grep { !$u{$_}++ } @{ $beh{$r} } if $val{$id} >= $val{$a} && $val{$id} <= $val{$b};
    }
    return @f;
}

sub kuerzel {
    our @accliste;
    { local $STILL = 1; menues(undef); }
    tasten('');
    print "| Kürzel | Kennung | Statuszeile | Menü | behandelt in | Quelle |\n|---|---|---|---|---|---|\n";
    for my $a (@accliste) {
        my ($t, $id, $z) = @$a;
        printf "| %s | `%s` | %s | %s | %s | Tastentabelle :%d |\n", $t, $id, beschreibung($id) || '(ohne)',
            join('; ', @{ $menupfad{$id} // [] }) || '—', join(', ', behandler($id)) || '—', $z;
    }
    for my $m (@menukuerzel) {
        my ($t, $id, $wo, $z) = @$m;
        next if grep { norm($_->[0]) eq norm($t) && $_->[1] eq $id } @accliste;
        printf "| %s | `%s` | %s | %s | %s | nur Menütext :%d |\n", $t, $id, beschreibung($id) || '(ohne)', $wo,
            join(', ', behandler($id)) || '—', $z;
    }
    printf "\nTastentabelle %d Zeilen, Menütext-Kürzel ohne Tabellenzeile siehe oben\n", scalar @accliste;
}

sub norm { my $s = lc shift; $s =~ s/ctrl/strg/; $s =~ s/shift/umschalt/; $s =~ s/\s//g; $s }

sub menutext { my $t = shift; $t =~ s/&&/\x{1}/g; $t =~ s/&//g; $t =~ s/\x{1}/&/g; $t }

sub ini_eintrag {    # IDS_INI_X -> (Name, Vorgabe, Abschnitt, Zeile)
    my ($id) = @_;
    my $s = $str{$id};
    return () unless defined $s;
    my ($n, $v) = split /\\n/, $s, 2;
    $v //= '';
    my $nr = $val{$id} // 0;
    my $ab = $nr <= 10800 ? 'Settings' : $nr <= 10900 ? 'Debug' : $nr <= 11100 ? 'Window Position' : 'Settings';
    return ($n, $v, $ab, $strzeile{$id});
}

sub dialog_zeile {
    my ($name) = @_;
    for my $i (0..$#rc) { return $i if $rc[$i] =~ /^\Q$name\E\s+DIALOG/ }
    return undef;
}

sub optionen {
    my %nachnr = reverse map { $_ => $val{$_} } grep { /^IDD_SETTINGS_/ } keys %val;
    for my $nr (2..99) {
        my $name = $nachnr{$nr} or last;
        my $z = dialog_zeile($name);
        last unless defined $z;   # settings.cpp bricht bei der ersten Luecke ab
        seite($name, $z);
    }
}

sub seite {
    my ($name, $z) = @_;
    my ($cap) = map { /^CAPTION\s+"(.*)"/ ? $1 : () } @rc[$z..$z+5];
    print "\n## $cap ($name, Nr. $val{$name}, EudoraRes.rc:", $z + 1, ")\n\n";
    print "| Beschriftung | Art | INI-Schlüssel | Abschnitt | Vorgabe | umgekehrt | Kennung | Zeile |\n|---|---|---|---|---|---|---|---|\n";
    my $i = $z; $i++ until $rc[$i] =~ /^BEGIN/;
    my $buf = ''; my $start; my $letzter = '';
    for ($i++; $rc[$i] !~ /^END/; $i++) {
        $start //= $i;
        $buf .= ' ' . ($rc[$i] =~ s/^\s+//r);
        next if $buf =~ /[,|]\s*$/;
        my $l = $buf; $buf = ''; my $zeile = $start + 1; undef $start;
        my ($art, $rest) = $l =~ /^\s*(\w+)\s+(.*)$/ or next;
        my ($text, $id);
        if ($rest =~ /^"((?:[^"]|"")*)",\s*(\w+)/) { ($text, $id) = ($1, $2) }
        elsif ($rest =~ /^(\w+)/) { ($text, $id) = ('', $1) }
        else { next }
        if ($art eq 'CONTROL') {
            my ($cls) = $rest =~ /,"(\w+)",/; my $sty = $rest;
            $art = ($sty // '') =~ /RADIO/ ? 'Auswahlknopf' : ($sty // '') =~ /CHECKBOX/ ? 'Häkchen'
                 : ($cls // 'CONTROL');
        }
        $text = menutext($text);
        if ($art =~ /^(LTEXT|RTEXT|CTEXT|GROUPBOX)$/) { $letzter = $text; next if $art ne 'GROUPBOX' || $id !~ /^IDS_INI/ }
        my %deutsch = (EDITTEXT => 'Feld', COMBOBOX => 'Auswahl', PUSHBUTTON => 'Knopf', LISTBOX => 'Liste',
                       GROUPBOX => 'Rahmen', DEFPUSHBUTTON => 'Knopf');
        $art = $deutsch{$art} // $art;
        # Beschriftung ohne eigenen Text: nur die UNMITTELBAR davor stehende
        # LTEXT-Zeile, in Klammern - die Reihenfolge in der .rc ist nicht die
        # raeumliche Anordnung, also bleibt sonst leer statt geraten.
        my $beschr = length $text ? $text : $letzter ? "($letzter)" : '';
        $letzter = '';
        my $nr = $val{$id};
        if (defined $nr && ($nr & 0x7FFF) >= 10000 && ($nr & 0x7FFF) < 20000) {
            my $inv = $nr & 0x8000 ? 'ja' : '';
            my %r = reverse map { $_ => $val{$_} } grep { /^IDS_INI_/ } keys %val;
            my $ini = $r{$nr & 0x7FFF} // $id;
            my ($n, $v, $ab, $sz) = ini_eintrag($ini);
            printf "| %s | %s | `%s` | %s | %s | %s | `%s` | %d |\n", $beschr, $art, $n // '?', $ab // '?',
                (defined $v && length $v ? "`$v`" : '(leer)'), $inv, $ini, $zeile;
        } else {
            printf "| %s | %s | — | | | | `%s` | %d |\n", $beschr, $art, $id, $zeile;
        }
    }
}

sub ini_zeigen {
    my @w = @_;
    my %nachname;
    for my $id (grep { /^IDS_INI_/ } keys %str) { my ($n) = ini_eintrag($id); $nachname{lc $n} = $id if defined $n }
    print "| Schlüssel | Abschnitt | Vorgabe | Kennung | Nr. | Zeile |\n|---|---|---|---|---|---|\n";
    for my $w (@w) {
        my $id = $w =~ /^IDS_/ ? $w : $nachname{lc $w};
        unless ($id && defined $str{$id}) { print "| $w | — | nicht gefunden | | | |\n"; next }
        my ($n, $v, $ab, $sz) = ini_eintrag($id);
        printf "| `%s` | [%s] | %s | `%s` | %s | %d |\n", $n, $ab, (length $v ? "`$v`" : '(leer)'), $id, $val{$id} // '?', $sz;
    }
}

sub zaehlen {
    my ($m, $e, $p) = (0, 0, 0);
    for (@rc) { $m++ if /^\w+\s+MENU\s*$/; $e++ if /^\s*MENUITEM\s+"/ }
    my %nachnr = reverse map { $_ => $val{$_} } grep { /^IDD_SETTINGS_/ } keys %val;
    for my $nr (2..99) { my $n = $nachnr{$nr} or last; defined dialog_zeile($n) or last; $p++ }
    my $ini = grep { /^IDS_INI_/ } keys %str;
    print "MENU-Ressourcen $m, MENUITEM mit Text $e, Optionsseiten $p, IDS_INI-Zeichenketten $ini\n";
}

sub selbsttest {
    my $f = 0;
    my $ok = sub { my ($c, $t) = @_; print(($c ? "  ok   " : "  ROT  "), "$t\n"); $f++ unless $c };
    $ok->(menutext('Payment && &Registration') eq 'Payment & Registration', 'menutext: && bleibt &');
    $ok->(menutext('E&xit') eq 'Exit', 'menutext: & faellt weg');
    $ok->(norm('Ctrl+M') eq norm('Strg+M'), 'norm: Ctrl = Strg');
    %str = (IDS_INI_A => 'TidyAttach\n0', IDS_INI_B => 'LogLevel\n25759', IDS_INI_C => 'X\n1');
    %val = (IDS_INI_A => 10132, IDS_INI_B => 10802, IDS_INI_C => 10950);
    my @a = ini_eintrag('IDS_INI_A'); my @b = ini_eintrag('IDS_INI_B'); my @c = ini_eintrag('IDS_INI_C');
    $ok->($a[0] eq 'TidyAttach' && $a[1] eq '0' && $a[2] eq 'Settings', 'ini: Name, Vorgabe, [Settings]');
    $ok->($b[2] eq 'Debug', 'ini: 10802 -> [Debug] (Gegenprobe zu LogLevel)');
    $ok->($c[2] eq 'Window Position', 'ini: 10950 -> [Window Position]');
    print $f ? "$f ROT\n" : "alle gruen\n";
    return $f ? 1 : 0;
}
