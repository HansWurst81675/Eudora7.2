#!/usr/bin/perl
# haken-eudora-start.pl - PreToolUse-Haken von Claude Code (.claude/settings.json):
# kein direkter Aufruf einer Eudora.exe aus Bash oder PowerShell. Gestartet
# wird Eudora nur ueber tools/testlauf.ps1 (oder die Werkzeuge, die es rufen:
# pruefstand-lauf.ps1, stapel-untersuchen.ps1) - die protokollieren jeden
# Start, filtern nach Pfad und verlangen Gregors Freigabe des Tages.
#
# WARUM ES DAS GIBT. Am 01.11.2026 um 17:18:55 stand im selben Bash-Aufruf wie
# ein "cp -r" ein '"/c/Temp/E184/Eudora.exe" --version' - als harmlose
# Versionsabfrage gedacht. Eudora kennt keinen solchen Schalter, startete,
# fand ueber die Registry Gregors Mailverzeichnis von 7.2.1.128 und zeigte den
# E-132-Dialog auf seinem Bildschirm. Gregor: "meldung von dir?". Die Regel
# stand seit Wochen in Arbeitsweise/nichts-auf-gregors-bildschirm-starten.md;
# tools/pruefe-startwege.pl war blind, weil ein Start ohne Mailverzeichnis
# keine eudora.log schreibt. Vorschlag des CHRONIST (CHRONIST-2026-11-01d).
#
# WIE. Liest den Werkzeugaufruf als JSON von stdin. Heredocs, PowerShell-Here-
# Strings und Kommentare werden entfernt (sie werden nicht ausgefuehrt), der
# Rest an ; && || | & Zeilenenden und $( zerlegt. In jedem Abschnitt wird das
# Wort an Befehlsstelle betrachtet - ohne Anfuehrungszeichen, auch hinter
# "&", "Start-Process", "start", "cmd /c", "Invoke-Item"/"ii", "exec", "call" und
# hinter -FilePath. Endet es auf Eudora.exe, Rueckgabe 2 mit Begruendung.
# Zeichenketten in Anfuehrungszeichen bleiben stehen: genau so stand der Pfad
# beim Ausrutscher da. Dateizugriffe (cp, grep, Get-Item, FileVersionInfo)
# haben Eudora.exe nicht an Befehlsstelle und gehen durch.
#
# Gegenprobe: perl tools/haken-eudora-start.pl --selbsttest (beide Richtungen).
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
my $treffer = eudora_aufruf($kommando);
exit 0 unless defined $treffer;

print STDERR <<"TEXT";
KEIN DIREKTER EUDORA-START: "$treffer" stuende an Befehlsstelle.
Eudora wird nur ueber tools/testlauf.ps1 gestartet (Pfadfilter, Protokoll in
tools/TESTLAEUFE.md, Gregors Freigabe des Tages) - oder ueber
tools/pruefstand-lauf.ps1, das es ruft. Die Fassung einer EXE liest man aus der
Versionsressource ([Diagnostics.FileVersionInfo]::GetVersionInfo(...)) oder mit
grep -a nach der Baukennung, nie durch Starten.
Anlass: 01.11.2026 17:18:55, '"/c/Temp/E184/Eudora.exe" --version' zeigte einen
Dialog auf Gregors Bildschirm (Arbeitsweise/nichts-auf-gregors-bildschirm-starten.md).
TEXT
exit 2;

# Liefert das erste Wort an Befehlsstelle, das auf Eudora.exe endet, sonst undef.
sub eudora_aufruf {
    my ($t) = @_;
    # Heredocs (bash) und Here-Strings (PowerShell) werden nicht ausgefuehrt.
    $t =~ s/<<-?[ \t]*(['"]?)(\w+)\1([^\n]*)\n.*?^[ \t]*\2[ \t]*$/$3/msg;
    $t =~ s/@(['"])[ \t]*\n.*?^\1@//msg;
    # Kommentarzeilen.
    $t =~ s/^[ \t]*#[^\n]*//mg;
    for my $abschnitt (abschnitte($t)) {
        my $w = befehlswort($abschnitt);
        return $w if defined $w && $w =~ /eudora\.exe['"]?$/i;
    }
    return undef;
}

# Zerlegt an ; && || | Zeilenende $( und ` - aber nur AUSSERHALB von
# Anfuehrungszeichen. Erster Stand zerlegte auch darin: ein perl -e '...' mit
# einer Markdown-Tabelle ("| ... `Eudora.exe` ...") wurde abgewiesen
# (gemessen 01.11.2026, beim Commit dieses Hakens selbst).
sub abschnitte {
    my ($t) = @_;
    my @aus; my $cur = ''; my $q = '';
    my @z = split //, $t;
    for (my $i = 0; $i < @z; $i++) {
        my $c = $z[$i];
        if ($q) {
            $cur .= $c;
            if ($q eq '"' && $c eq '\\' && $i + 1 < @z) { $cur .= $z[++$i]; next }
            $q = '' if $c eq $q;
            next;
        }
        if ($c eq "'" || $c eq '"') { $q = $c; $cur .= $c; next }
        my $zwei = $c . ($i + 1 < @z ? $z[$i + 1] : '');
        if ($zwei eq '&&' || $zwei eq '||' || $zwei eq '$(') { push @aus, $cur; $cur = ''; $i++; next }
        if ($c eq ';' || $c eq '|' || $c eq "\n" || $c eq '`') { push @aus, $cur; $cur = ''; next }
        $cur .= $c;
    }
    push @aus, $cur;
    return @aus;
}

sub befehlswort {
    my ($s) = @_;
    my @wort;
    while ($s =~ /\G\s*('[^']*'|"(?:\\.|[^"\\])*"|[^\s'"]+)/gc) { push @wort, $1 }
    # Vorgestellte Umgebungszuweisungen (VAR=x cmd) ueberspringen.
    shift @wort while @wort && $wort[0] =~ /^\w+=/;
    my $i = 0;
    while ($i < @wort) {
        my $w = $wort[$i];
        if ($w eq '&' or $w =~ /^(?:exec|call|start|Start-Process|saps|Invoke-Item|ii|nohup|time)$/i) { $i++; next }
        if ($w =~ /^cmd(?:\.exe)?$/i) { $i++; $i++ while $i < @wort && $wort[$i] =~ m{^/[a-z]$}i; next }
        if ($w =~ /^-FilePath$/i) { $i++; next }
        if ($w eq '""' or $w eq "''") { $i++; next }   # Fenstertitel von cmd "start"
        if ($w =~ /^-/ && $i > 0) { $i++; next }   # Schalter von start/Start-Process
        (my $nackt = $w) =~ s/^['"]|['"]$//g;
        return $nackt;
    }
    return undef;
}

sub selbsttest {
    my @f = (
        # [erwartet abgewiesen?, Befehl]
        [1, 'cp -r /c/Temp/E77 /c/Temp/E184 && ls /c/Temp/E184 | wc -l; "/c/Temp/E184/Eudora.exe" --version >/dev/null 2>&1; echo'],
        [1, '/c/Temp/E184/Eudora.exe'],
        [1, '& "C:\\Temp\\E184\\Eudora.exe" "C:\\Temp\\E184\\Mailverzeichnis"'],
        [1, 'Start-Process C:\\Temp\\E184\\Eudora.exe'],
        [1, 'Start-Process -FilePath "C:\\Temp\\E184\\Eudora.exe" -ArgumentList x'],
        [1, 'cmd /c "C:\\Temp\\E184\\Eudora.exe"'],
        [1, 'start "" C:\\Users\\Gregor\\Eudora72-7.2.1.130-release\\Eudora.exe'],
        [1, 'cd /c/Temp/E184 && ./Eudora.exe'],
        [1, 'Invoke-Item C:\\Temp\\E184\\EUDORA.EXE'],
        [1, 'x=$(/c/Temp/E184/Eudora.exe --help)'],
        [0, 'cp Eudora71/Bin/Release/Eudora.exe /c/Temp/E184/'],
        [0, 'grep -a -o -E "Eudora 7" /c/Temp/E184/Eudora.exe | head -1'],
        [0, 'for f in Eudora.exe EudoraRes.dll; do cp "$B/$f" /c/Temp/E184/; done'],
        [0, 'powershell -NoProfile -ExecutionPolicy Bypass -File tools\\testlauf.ps1 -Verzeichnis C:\\Temp\\E184 -Freigabe x'],
        [0, "git commit -q -F - <<'EOF'\n\"/c/Temp/E184/Eudora.exe\" --version protokolliert\nEOF"],
        [0, "\$m = \@'\n& C:\\Temp\\Eudora.exe\n'\@; git commit -m \$m"],
        [0, 'Get-Process Eudora | Where-Object { $_.Path -ieq "C:\\Temp\\E184\\Eudora.exe" }'],
        [0, '[Diagnostics.FileVersionInfo]::GetVersionInfo("C:\\Temp\\E184\\Eudora.exe").FileVersion'],
        [0, "# \"/c/Temp/E184/Eudora.exe\" --version\nls"],
        [0, 'ls -l /c/Temp/E184/Eudora.exe'],
        # Fehlalarm des ersten Stands: | und ` innerhalb von Anfuehrungszeichen.
        [0, q{perl -e 'print "| `tools/x` | einer `Eudora.exe` | Anlass `\"/c/Temp/E184/Eudora.exe\" --version` |\n"' > x.txt}],
        [0, q{git commit -m "Anlass '\"/c/Temp/E184/Eudora.exe\" --version' im Kopierbefehl"}],
        [1, q{echo "a | b"; /c/Temp/E184/Eudora.exe}],
    );
    my ($ok, $f) = (0, 0);
    for my $fall (@f) {
        my ($soll, $cmd) = @$fall;
        my $ist = defined eudora_aufruf($cmd) ? 1 : 0;
        my $kurz = substr($cmd, 0, 70); $kurz =~ s/\n/ \\n /g;
        if ($ist == $soll) { $ok++; print "  ok   ", ($soll ? 'abgewiesen ' : 'durch      '), $kurz, "\n" }
        else               { $f++;  print "  FEHL ", ($soll ? 'durchgelassen ' : 'abgewiesen  '), $kurz, "\n" }
    }
    print "Ergebnis: ", $ok + $f, " Faelle, $ok bestanden, $f fehlgeschlagen\n";
    exit($f ? 1 : 0);
}
