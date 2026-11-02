# messen-e204.ps1 - Befund E-204: erbt eine gleichnamige neue Persoenlichkeit
# das Kennwort einer geloeschten, und schickt Eudora es ohne Rueckfrage an
# ihren Server?
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript bzw. als Schalter
# messen=tools\messen-e204.ps1 in tools\pruefstand-faelle.txt, Pruefstand
# C:\Temp\E204 (Kopie von C:\Temp\E39; fuer die Gegenprobe am alten Bau
# C:\Temp\E204-alt).
#
# WARUM ES DAS GIBT. E-204 stand seit PRUEFER-85 K3 nur am Quelltext:
# SavePassInfo legt bei jedem Umschalten weg von einer Persoenlichkeit ihr
# Kennwort unter m_Passwords["Persona-<Name>"] ab, CPersonality::Remove
# vergass es nur bei der aktuellen. Ob das alte Kennwort tatsaechlich an den
# Server einer neuen gleichnamigen Persoenlichkeit geht, war Vermutung. Dieser
# Lauf nimmt den Weg des Anwenders und liest am POP-Pruefserver mit, welches
# PASS ankommt.
#
#   -Vorbereiten  [Settings]: CheckMailByDefault=0 (die Hauptpersoenlichkeit
#                 ruft nicht ab), POPPort=11110; [Personalities]
#                 Persona0=Persona-E204Zwei und [Persona-E204Zwei] mit Konto
#                 e204alt@127.0.0.1, SavePassword=0 (das Kennwort steht nur im
#                 Speicher). Startet den POP-Pruefserver
#                 (tools\anhang-pruefdaten.pl --pop --nur-eml, leeres
#                 Postfach), Ausgabe nach <Pruefstand>\pop-protokoll.txt.
#   Messen        1. File > Check Mail (32772): Kennwortfrage fuer E204Zwei,
#                    "e204-alt-kennwort" ins Feld (WM_SETTEXT), OK.
#                 2. noch einmal Check Mail: KEINE Frage, dasselbe PASS -
#                    das Kennwort steht im Speicher (Positivprobe).
#                 3. Personalities > Delete E204Zwei > Yes (wie messen-e39.ps1).
#                 4. Personalities > New (33036): der Assistent, Seite fuer
#                    Seite per WM_SETTEXT und ID_WIZNEXT (12324), am Ende
#                    ID_WIZFINISH (12325): E204Zwei, Konto e204neu@127.0.0.1.
#                 5. Check Mail: kommt eine Kennwortfrage? Welches PASS kommt
#                    am Server an? Wenn eine Frage kommt: "e204-neu-kennwort".
#
# Nur Botschaften an gemessene Handles, kein Tastendruck
# (Arbeitsweise/keine-tastendruecke-verschicken.md). Die Kennwoerter sind
# erfunden und gehen nur an 127.0.0.1.
#
# Ausgabe:
#   E204 ERGEBNIS rueckfrage=<0|1> user=<name|-> pass=<alt|neu|leer|anderes|keins> lebt=<0|1>
# Vorher (Bau 7.2.1.131+f31dbff9): rueckfrage=0 user=e204neu pass=alt.
# Positivprobe (E204 PROBE ok): Spurzeile war-aktuell=0 (PRUEFER-88 K3; sonst
# naehme schon der E-39-Block das Kennwort weg), Abruf 1 mit Frage und PASS alt, Abruf 2 ohne
# Frage mit PASS alt, nach Yes Abschnitt und Listeneintrag weg, nach dem
# Assistenten [Persona-E204Zwei] mit LoginName=e204neu da - sonst hat der Lauf
# den Weg nicht getroffen, und pass=neu waere nichts wert.
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten,
    [int] $WarteSekunden = 20
)
$ErrorActionPreference = 'Stop'
$NAME   = 'E204Zwei'
$ABSCHN = 'Persona-' + $NAME
$ALT    = 'e204-alt-kennwort'
$NEU    = 'e204-neu-kennwort'
$PORT   = 11110
$repo   = Split-Path -Parent $PSScriptRoot

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\E204[^\\]*$') { Write-Output "E204 ABGEWIESEN: $voll ist kein Pruefstand C:\Temp\E204*"; exit 2 }
$md  = Join-Path $voll 'Mailverzeichnis'
$ini = Join-Path $md 'Eudora.ini'
if (-not (Test-Path -LiteralPath $ini)) { Write-Output "E204 FEHLER: keine Eudora.ini in $md"; exit 1 }
$ansi = [Text.Encoding]::Default
$pidDatei  = Join-Path $voll 'pop-pruefserver.pid'
$protokoll = Join-Path $voll 'pop-protokoll.txt'

function PopBeenden {
    if (-not (Test-Path -LiteralPath $pidDatei)) { return }
    $altPid = [int](Get-Content -LiteralPath $pidDatei)
    $p = Get-Process -Id $altPid -ErrorAction SilentlyContinue
    if ($p -and $p.ProcessName -eq 'perl') { $p.Kill(); Write-Output "E204 POP-Pruefserver $altPid beendet" }
    Remove-Item -LiteralPath $pidDatei -Force
}

function Lies-Ini {
    $text = [IO.File]::ReadAllText($ini, $ansi)
    $abschnitte = New-Object System.Collections.ArrayList
    $akt = @{ Name = ''; Zeilen = (New-Object System.Collections.ArrayList) }
    [void]$abschnitte.Add($akt)
    foreach ($z in ($text -split "`r?`n")) {
        if ($z -match '^\[(.+)\]\s*$') {
            $akt = @{ Name = $Matches[1]; Zeilen = (New-Object System.Collections.ArrayList) }
            [void]$abschnitte.Add($akt)
        } elseif ($z -ne '') { [void]$akt.Zeilen.Add($z) }
    }
    return ,$abschnitte
}
function Abschnitt($abschnitte, $name) {
    foreach ($a in $abschnitte) { if ($a.Name -ieq $name) { return $a } }
    return $null
}
function Wert($abschnitt, $schluessel) {
    if ($null -eq $abschnitt) { return $null }
    foreach ($z in $abschnitt.Zeilen) { if ($z -match ('^' + [regex]::Escape($schluessel) + '=(.*)$')) { return $Matches[1] } }
    return $null
}

if ($Vorbereiten) {
    PopBeenden
    $abschnitte = Lies-Ini
    $rest = @($abschnitte | Where-Object { $_.Name -ine 'Personalities' -and $_.Name -notlike 'Persona-*' })
    $sb = New-Object Text.StringBuilder
    foreach ($a in $rest) {
        if ($a.Name -ne '') { [void]$sb.Append('[' + $a.Name + ']' + "`r`n") }
        foreach ($z in $a.Zeilen) {
            if ($a.Name -ieq 'Settings' -and $z -match '^(SavePasswordText|CheckMailByDefault|POPPort|WarnValidateHost)=') { continue }
            [void]$sb.Append($z + "`r`n")
        }
        # WarnValidateHost=0: der Assistent prueft sonst den SMTP-Server
        # (Port 25, hier ohne Dienst) und bleibt auf der Seite stehen
        # (am 02.11.2026 so gemessen).
        if ($a.Name -ieq 'Settings') { [void]$sb.Append("CheckMailByDefault=0`r`nPOPPort=$PORT`r`nWarnValidateHost=0`r`n") }
    }
    [void]$sb.Append("[Personalities]`r`nPersona0=$ABSCHN`r`n")
    [void]$sb.Append("[$ABSCHN]`r`nRealName=E204 Alt`r`nReturnAddress=e204alt@127.0.0.1`r`n" +
                     "POPAccount=e204alt@127.0.0.1`r`nLoginName=e204alt`r`nPopServer=127.0.0.1`r`n" +
                     "SMTPServer=127.0.0.1`r`nSavePassword=0`r`nSavePasswordText=`r`nCheckMailByDefault=1`r`n" +
                     "UsesPOP=1`r`nUsesIMAP=0`r`nSSLReceiveUse=0`r`nSSLSendUse=0`r`n")
    [IO.File]::WriteAllText($ini, $sb.ToString(), $ansi)
    # DEudora.ini des Pruefstands: SSL aus fuer neue Konten. Die Vorgabe des
    # Pakets ist SSLReceiveUse=2 (eigener Port 995); der Assistent fragt nicht
    # danach, und der Pruefserver spricht kein TLS (am 02.11.2026 gemessen:
    # "Open 127.0.0.1:995", connection refused). Fuer E-204 gleichgueltig.
    $dini = Join-Path $voll 'DEudora.ini'
    if (Test-Path -LiteralPath $dini) {
        $dt = [IO.File]::ReadAllText($dini, $ansi)
        $dt = [regex]::Replace($dt, '(?m)^(SSLReceiveUse|SSLSendUse)=\d+', '$1=0')
        [IO.File]::WriteAllText($dini, $dt, $ansi)
    }
    $spool = Join-Path $md ('spool\' + $NAME)
    if (Test-Path -LiteralPath $spool) { Remove-Item -LiteralPath $spool -Recurse -Force }
    foreach ($f in @($protokoll, ($protokoll + '.err'))) { if (Test-Path -LiteralPath $f) { Remove-Item -LiteralPath $f -Force } }
    $belegt = Get-NetTCPConnection -LocalPort $PORT -State Listen -ErrorAction SilentlyContinue
    if ($belegt) { Write-Output "E204 FEHLER: Port $PORT ist belegt (PID $($belegt.OwningProcess))"; exit 1 }
    $perl = 'C:\Program Files\Git\usr\bin\perl.exe'
    # Ohne -RedirectStandardOutput: sonst erbt der Server die Ausgabe-Pipe
    # dieses Skripts, und pruefstand-lauf.ps1 (Vorbereiten | Out-Null) wartet
    # auf sein Ende (am 02.11.2026 so gehangen). Die Datei oeffnet er selbst.
    $p = Start-Process $perl -ArgumentList @("$repo\tools\anhang-pruefdaten.pl", '--pop', "$PORT", '--nur-eml', '--protokoll', $protokoll) `
         -WorkingDirectory $repo -WindowStyle Hidden -PassThru
    Set-Content -Path $pidDatei -Value $p.Id -Encoding ascii
    $frist = (Get-Date).AddSeconds(10)
    while ((Get-Date) -lt $frist -and -not (Get-NetTCPConnection -LocalPort $PORT -State Listen -ErrorAction SilentlyContinue)) { Start-Sleep -Milliseconds 300 }
    if (-not (Get-NetTCPConnection -LocalPort $PORT -State Listen -ErrorAction SilentlyContinue)) { Write-Output "E204 FEHLER: POP-Pruefserver lauscht nicht auf $PORT"; PopBeenden; exit 1 }
    Write-Output "E204 vorbereitet: [$ABSCHN] mit e204alt@127.0.0.1, POP-Pruefserver PID $($p.Id) auf Port $PORT"
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Collections.Generic; using System.Runtime.InteropServices;
public class E204W {
  public delegate bool EP(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP p, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr w, EP p, IntPtr l);
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int GetClassName(IntPtr h, StringBuilder s, int m);
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int m);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool IsWindowEnabled(IntPtr h);
  [DllImport("user32.dll")] public static extern bool IsWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetDlgCtrlID(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr PostMessage(IntPtr h, uint m, IntPtr w, IntPtr l);
  public static List<IntPtr> Fenster(uint ziel) {
    List<IntPtr> r = new List<IntPtr>();
    EnumWindows(delegate(IntPtr h, IntPtr l) {
      uint pid; GetWindowThreadProcessId(h, out pid);
      if (pid == ziel && IsWindowVisible(h)) r.Add(h);
      return true; }, IntPtr.Zero);
    return r;
  }
  public static List<IntPtr> Kinder(IntPtr w) {
    List<IntPtr> r = new List<IntPtr>();
    EnumChildWindows(w, delegate(IntPtr h, IntPtr l) { r.Add(h); return true; }, IntPtr.Zero);
    return r;
  }
  public static string Klasse(IntPtr h) { StringBuilder s = new StringBuilder(256); GetClassName(h, s, 256); return s.ToString(); }
  public static string Titel(IntPtr h)  { StringBuilder s = new StringBuilder(1024); GetWindowText(h, s, 1024); return s.ToString(); }
  [DllImport("user32.dll")] public static extern IntPtr SendMessageTimeoutA(IntPtr h, uint m, IntPtr w, IntPtr l, uint fl, uint ms, out IntPtr r);
  [DllImport("kernel32.dll")] public static extern IntPtr OpenProcess(uint a, bool i, uint pid);
  [DllImport("kernel32.dll")] public static extern IntPtr VirtualAllocEx(IntPtr p, IntPtr a, uint n, uint t, uint pr);
  [DllImport("kernel32.dll")] public static extern bool VirtualFreeEx(IntPtr p, IntPtr a, uint n, uint t);
  [DllImport("kernel32.dll")] public static extern bool WriteProcessMemory(IntPtr p, IntPtr a, byte[] b, uint n, out IntPtr w);
  [DllImport("kernel32.dll")] public static extern bool ReadProcessMemory(IntPtr p, IntPtr a, byte[] b, uint n, out IntPtr r);
  [DllImport("kernel32.dll")] public static extern bool CloseHandle(IntPtr h);
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern IntPtr SendMessage(IntPtr h, uint m, IntPtr w, string l);
  public static IntPtr Senden(IntPtr h, uint m, IntPtr w, IntPtr l) { IntPtr r; SendMessageTimeoutA(h, m, w, l, 2, 3000, out r); return r; }
  static byte[] Lvitem(int mask, int item, int state, int stateMask, int text, int cch) {
    byte[] b = new byte[64];
    BitConverter.GetBytes(mask).CopyTo(b, 0);  BitConverter.GetBytes(item).CopyTo(b, 4);
    BitConverter.GetBytes(0).CopyTo(b, 8);     BitConverter.GetBytes(state).CopyTo(b, 12);
    BitConverter.GetBytes(stateMask).CopyTo(b, 16); BitConverter.GetBytes(text).CopyTo(b, 20);
    BitConverter.GetBytes(cch).CopyTo(b, 24);
    return b;
  }
  public static List<string> Texte(IntPtr liste, uint pid) {
    List<string> r = new List<string>();
    IntPtr hp = OpenProcess(0x0038, false, pid);
    if (hp == IntPtr.Zero) return r;
    IntPtr fern = VirtualAllocEx(hp, IntPtr.Zero, 4096, 0x3000, 0x04);
    int n = (int)Senden(liste, 0x1004, IntPtr.Zero, IntPtr.Zero);
    for (int i = 0; i < n; i++) {
      IntPtr w; byte[] it = Lvitem(1, i, 0, 0, (int)fern.ToInt64() + 128, 256);
      WriteProcessMemory(hp, fern, it, 64, out w);
      Senden(liste, 0x102D, (IntPtr)i, fern);
      byte[] t = new byte[256]; ReadProcessMemory(hp, (IntPtr)(fern.ToInt64() + 128), t, 256, out w);
      int z = Array.IndexOf(t, (byte)0); if (z < 0) z = 256;
      r.Add(Encoding.Default.GetString(t, 0, z));
    }
    VirtualFreeEx(hp, fern, 0, 0x8000); CloseHandle(hp);
    return r;
  }
  public static void Waehle(IntPtr liste, uint pid, int idx) {
    IntPtr hp = OpenProcess(0x0038, false, pid);
    IntPtr fern = VirtualAllocEx(hp, IntPtr.Zero, 4096, 0x3000, 0x04);
    IntPtr w;
    WriteProcessMemory(hp, fern, Lvitem(8, 0, 0, 3, 0, 0), 64, out w);
    Senden(liste, 0x102B, (IntPtr)(-1), fern);
    WriteProcessMemory(hp, fern, Lvitem(8, idx, 3, 3, 0, 0), 64, out w);
    Senden(liste, 0x102B, (IntPtr)idx, fern);
    VirtualFreeEx(hp, fern, 0, 0x8000); CloseHandle(hp);
  }
}
"@

$proz = @(Get-Process -Name Eudora -ErrorAction SilentlyContinue |
          Where-Object { $_.Path -and $_.Path.StartsWith($voll + '\', [StringComparison]::OrdinalIgnoreCase) })
if ($proz.Count -ne 1) { Write-Output ('E204 FEHLER: ' + $proz.Count + ' Eudora-Prozesse unter ' + $voll + ', erwartet 1'); PopBeenden; exit 1 }
$p = $proz[0]
$pid32 = [uint32]$p.Id

$haupt = [IntPtr]::Zero
foreach ($h in [E204W]::Fenster($pid32)) { if ([E204W]::Klasse($h) -eq 'EudoraMainWindow') { $haupt = $h } }
if ($haupt -eq [IntPtr]::Zero) { Write-Output 'E204 FEHLER: kein EudoraMainWindow'; PopBeenden; exit 1 }

function Kind([IntPtr] $d, [int] $id) {
    foreach ($k in [E204W]::Kinder($d)) { if ([E204W]::GetDlgCtrlID($k) -eq $id) { return $k } }
    return [IntPtr]::Zero
}
function Dialoge { @([E204W]::Fenster($pid32) | Where-Object { [E204W]::Klasse($_) -eq '#32770' }) }
function DialogText([IntPtr] $d) {
    (@([E204W]::Kinder($d) | Where-Object { [E204W]::Klasse($_) -eq 'Static' } | ForEach-Object { [E204W]::Titel($_) } | Where-Object { $_ -ne '' }) -join ' / ') -replace "`r?`n", ' '
}
# Protokoll des POP-Pruefservers, waehrend er noch hineinschreibt
function Protokoll {
    if (-not (Test-Path -LiteralPath $protokoll)) { return @() }
    $fs = [IO.File]::Open($protokoll, 'Open', 'Read', 'ReadWrite')
    try { $t = (New-Object IO.StreamReader($fs, $ansi)).ReadToEnd() } finally { $fs.Close() }
    return @($t -split "`r?`n" | Where-Object { $_ -ne '' })
}

# Ein Abruf: Check Mail ans Hauptfenster; jede Kennwortfrage (Dialog mit dem
# Feld IDC_PASSWORD 1188) bekommt $kennwort; fertig, wenn der Pruefserver
# QUIT oder "getrennt" sieht. Gibt rueckfrage, user, pass, meldungen zurueck.
function Abruf([string] $kennwort, [string] $wer) {
    $vorher = (Protokoll).Count
    $bekannt = Dialoge
    $r = @{ rueckfrage = 0; user = '-'; pass = $null; meldungen = @(); fertig = 0 }
    [void][E204W]::PostMessage($haupt, 0x0111, [IntPtr]32772, [IntPtr]::Zero)      # ID_FILE_CHECKMAIL
    $frist = (Get-Date).AddSeconds($WarteSekunden)
    while ((Get-Date) -lt $frist) {
        Start-Sleep -Milliseconds 400
        foreach ($d in (Dialoge)) {
            if ($bekannt -contains $d) { continue }
            $feld = Kind $d 1188
            if ($feld -ne [IntPtr]::Zero) {
                $r.rueckfrage = 1
                Write-Host ('E204 ' + $wer + ': Kennwortfrage fuer [' + [E204W]::Titel((Kind $d 1189)) + '] Benutzer [' + [E204W]::Titel((Kind $d 1190)) + ']')
                [void][E204W]::SendMessage($feld, 0x000C, [IntPtr]::Zero, $kennwort)  # WM_SETTEXT
                [void][E204W]::PostMessage($d, 0x0111, [IntPtr]1, (Kind $d 1))         # IDOK
            } else {
                $txt = DialogText $d
                $r.meldungen += $txt
                Write-Host ('E204 ' + $wer + ': Meldung [' + $txt + ']')
                [void][E204W]::PostMessage($d, 0x0111, [IntPtr]1, (Kind $d 1))
            }
            $bekannt += $d
        }
        $zeilenNeu = @(Protokoll | Select-Object -Skip $vorher)
        if (@($zeilenNeu | Where-Object { $_ -match '> QUIT' -or $_ -match '\] getrennt' }).Count -gt 0) { $r.fertig = 1; break }
    }
    $zeilenNeu = @(Protokoll | Select-Object -Skip $vorher)
    foreach ($z in $zeilenNeu) {
        if ($z -match '> USER (.*)$') { $r.user = $Matches[1] }
        if ($z -match '> PASS ?(.*)$') { $r.pass = $Matches[1] }
    }
    Start-Sleep -Seconds 1
    return $r
}
function PassName($pw) {
    if ($null -eq $pw) { return 'keins' }
    if ($pw -eq $ALT) { return 'alt' }
    if ($pw -eq $NEU) { return 'neu' }
    if ($pw -eq '') { return 'leer' }
    return 'anderes'
}

# Personalities-Fenster und seine Liste (wie messen-e39.ps1)
function Liste-Finden {
    [void][E204W]::PostMessage($haupt, 0x0111, [IntPtr]32947, [IntPtr]::Zero)   # IDM_VIEW_PERSONALITIES
    $frist = (Get-Date).AddSeconds($WarteSekunden)
    while ((Get-Date) -lt $frist) {
        Start-Sleep -Milliseconds 700
        foreach ($l in @([E204W]::Fenster($pid32) | ForEach-Object { [E204W]::Kinder($_) } |
                         Where-Object { [E204W]::Klasse($_) -eq 'SysListView32' -and [E204W]::IsWindowVisible($_) })) {
            $texte = @([E204W]::Texte($l, $pid32))
            if ($texte -contains '<Dominant>') { return @($l, $texte) }
        }
    }
    return @([IntPtr]::Zero, @())
}

$probe = New-Object System.Collections.ArrayList
$ergebnis = $null
try {
    # 1. und 2. - das alte Kennwort kommt in den Speicher
    $a1 = Abruf $ALT 'Abruf1'
    Write-Output ('E204 Abruf1: rueckfrage=' + $a1.rueckfrage + ' user=' + $a1.user + ' pass=' + (PassName $a1.pass) + ' fertig=' + $a1.fertig)
    if (-not ($a1.rueckfrage -eq 1 -and (PassName $a1.pass) -eq 'alt')) { [void]$probe.Add('abruf1') }
    $a2 = Abruf $ALT 'Abruf2'
    Write-Output ('E204 Abruf2: rueckfrage=' + $a2.rueckfrage + ' user=' + $a2.user + ' pass=' + (PassName $a2.pass) + ' fertig=' + $a2.fertig)
    if (-not ($a2.rueckfrage -eq 0 -and (PassName $a2.pass) -eq 'alt')) { [void]$probe.Add('abruf2') }

    # 3. Loeschen
    $lt = Liste-Finden; $liste = $lt[0]; $texte = $lt[1]
    Write-Output ('E204 Liste ' + $liste + ': [' + ($texte -join '|') + ']')
    $eintrag = [array]::IndexOf($texte, $NAME)
    $geloescht = 0
    if ($liste -ne [IntPtr]::Zero -and $eintrag -ge 0) {
        [E204W]::Waehle($liste, $pid32, $eintrag)
        Start-Sleep -Milliseconds 500
        $bekannt = Dialoge
        [void][E204W]::PostMessage($liste, 0x0111, [IntPtr]33038, [IntPtr]::Zero)   # IDM_DELETE_PERSONALITY
        $dlg = [IntPtr]::Zero
        $frist = (Get-Date).AddSeconds($WarteSekunden)
        while ((Get-Date) -lt $frist -and $dlg -eq [IntPtr]::Zero) {
            Start-Sleep -Milliseconds 500
            foreach ($d in (Dialoge)) { if ($bekannt -notcontains $d -and (DialogText $d) -like ('*' + $NAME + '*')) { $dlg = $d } }
        }
        if ($dlg -ne [IntPtr]::Zero) {
            Write-Output ('E204 Rueckfrage: [' + (DialogText $dlg) + ']')
            [void][E204W]::PostMessage($dlg, 0x0111, [IntPtr]6, (Kind $dlg 6))     # IDYES
            Start-Sleep -Seconds 2
            $i1 = Lies-Ini
            $pl = Abschnitt $i1 'Personalities'
            $inListe = ($null -ne $pl -and @($pl.Zeilen | Where-Object { $_ -match ('=' + [regex]::Escape($ABSCHN) + '\s*$') }).Count -gt 0)
            if ($null -eq (Abschnitt $i1 $ABSCHN) -and -not $inListe) { $geloescht = 1 }
        }
    }
    Write-Output ('E204 geloescht=' + $geloescht)
    if ($geloescht -ne 1) { [void]$probe.Add('loeschen') }

    # PRUEFER-88 K3: war E204Zwei beim Loeschen die aktuelle, naehme schon
    # der E-39-Block das Kennwort weg, und pass=neu sagte nichts ueber E-204.
    # Die Spurzeile "E-39 Remove E204Zwei: war-aktuell=<0|1>" (persona.cpp)
    # muss war-aktuell=0 melden.
    $warAktuell = '-'
    $log = Join-Path $md 'eudora.log'
    $frist = (Get-Date).AddSeconds(10)
    while ((Get-Date) -lt $frist -and $warAktuell -eq '-') {
        if (Test-Path -LiteralPath $log) {
            $fs = [IO.File]::Open($log, 'Open', 'Read', 'ReadWrite')
            try { $lt = (New-Object IO.StreamReader($fs, $ansi)).ReadToEnd() } finally { $fs.Close() }
            $m = [regex]::Matches($lt, ('E-39 Remove ' + [regex]::Escape($NAME) + ': war-aktuell=(\d)'))
            if ($m.Count -gt 0) { $warAktuell = $m[$m.Count - 1].Groups[1].Value }
        }
        if ($warAktuell -eq '-') { Start-Sleep -Milliseconds 500 }
    }
    Write-Output ('E204 Spur: war-aktuell=' + $warAktuell)
    if ($warAktuell -ne '0') { [void]$probe.Add('war-aktuell-' + $warAktuell) }

    # 4. Neu anlegen ueber den Assistenten
    $angelegt = 0
    if ($geloescht -eq 1) {
        $bekannt = Dialoge
        [void][E204W]::PostMessage($liste, 0x0111, [IntPtr]33036, [IntPtr]::Zero)   # IDM_NEW_PERSONALITY
        $blatt = [IntPtr]::Zero
        $frist = (Get-Date).AddSeconds($WarteSekunden)
        while ((Get-Date) -lt $frist -and $blatt -eq [IntPtr]::Zero) {
            Start-Sleep -Milliseconds 500
            foreach ($d in (Dialoge)) { if ($bekannt -notcontains $d -and (Kind $d 12324) -ne [IntPtr]::Zero) { $blatt = $d } }
        }
        Write-Output ('E204 Assistent ' + $blatt + ' [' + [E204W]::Titel($blatt) + ']')
        $felder = @{ 26100 = $NAME; 26102 = 'E204 Neu'; 26104 = 'e204neu@127.0.0.1'; 26113 = 'e204neu'; 26117 = '127.0.0.1'; 26130 = '127.0.0.1' }
        $seiten = @()
        for ($schritt = 0; $blatt -ne [IntPtr]::Zero -and [E204W]::IsWindow($blatt) -and $schritt -lt 15; $schritt++) {
            $seite = [E204W]::Senden($blatt, 0x0476, [IntPtr]::Zero, [IntPtr]::Zero)   # PSM_GETCURRENTPAGEHWND
            $gesetzt = @()
            foreach ($id in $felder.Keys) {
                $k = Kind $seite $id
                if ($k -ne [IntPtr]::Zero -and [E204W]::IsWindowVisible($k)) {
                    [void][E204W]::SendMessage($k, 0x000C, [IntPtr]::Zero, $felder[$id]); $gesetzt += $id
                }
            }
            $seiten += ('' + ($gesetzt -join '+'))
            $fertigKnopf = Kind $blatt 12325
            $bekannt = Dialoge
            if ($fertigKnopf -ne [IntPtr]::Zero -and [E204W]::IsWindowVisible($fertigKnopf) -and [E204W]::IsWindowEnabled($fertigKnopf)) {
                [void][E204W]::PostMessage($blatt, 0x0111, [IntPtr]12325, $fertigKnopf)  # ID_WIZFINISH
                Start-Sleep -Seconds 3
                break
            }
            [void][E204W]::PostMessage($blatt, 0x0111, [IntPtr]12324, (Kind $blatt 12324))  # ID_WIZNEXT
            Start-Sleep -Milliseconds 1200
            $fehler = @(Dialoge | Where-Object { $bekannt -notcontains $_ -and $_ -ne $blatt })
            if ($fehler.Count -gt 0) {
                foreach ($f in $fehler) { Write-Host ('E204 Assistent: Meldung [' + (DialogText $f) + ']'); [void][E204W]::PostMessage($f, 0x0111, [IntPtr]1, (Kind $f 1)) }
                Start-Sleep -Seconds 1
                [void][E204W]::PostMessage($blatt, 0x0111, [IntPtr]2, (Kind $blatt 2))   # IDCANCEL
                break
            }
        }
        Write-Output ('E204 Assistent-Seiten: ' + ($seiten -join ',') + ' noch-offen=' + [int]([E204W]::IsWindow($blatt)))
        $i2 = Lies-Ini
        $s2 = Abschnitt $i2 $ABSCHN
        Write-Output ('E204 neu: abschnitt=' + [int]($null -ne $s2) + ' LoginName=' + (Wert $s2 'LoginName') + ' POPAccount=' + (Wert $s2 'POPAccount') + ' SavePassword=' + (Wert $s2 'SavePassword') + ' UsesPOP=' + (Wert $s2 'UsesPOP'))
        if ($null -ne $s2 -and (Wert $s2 'LoginName') -eq 'e204neu') { $angelegt = 1 }
    }
    if ($angelegt -ne 1) { [void]$probe.Add('anlegen') }

    # 5. Der Abruf, um den es geht
    if ($angelegt -eq 1) {
        $a3 = Abruf $NEU 'Abruf3'
        Write-Output ('E204 Abruf3: rueckfrage=' + $a3.rueckfrage + ' user=' + $a3.user + ' pass=' + (PassName $a3.pass) + ' fertig=' + $a3.fertig)
        if ($a3.fertig -ne 1) { [void]$probe.Add('abruf3') }
        $ergebnis = $a3
    }
} finally {
    # Die Meldung "Sorry, you don't have any new mail." kommt erst nach dem
    # QUIT; offen stehen gelassen haelt sie das Beenden auf (am 02.11.2026:
    # nach WM_CLOSE abgeschossen). Neue Meldungen der naechsten Sekunden
    # mit IDOK schliessen.
    $frist = (Get-Date).AddSeconds(4)
    while ((Get-Date) -lt $frist) {
        Start-Sleep -Milliseconds 500
        foreach ($d in (Dialoge)) {
            Write-Host ('E204 Aufraeumen: Meldung [' + (DialogText $d) + ']')
            [void][E204W]::PostMessage($d, 0x0111, [IntPtr]1, (Kind $d 1))
        }
    }
    $p.Refresh()
    $lebt = [int](-not $p.HasExited)
    PopBeenden
}

if ($probe.Count -eq 0) { Write-Output 'E204 PROBE ok' } else { Write-Output ('E204 PROBE ' + ($probe -join ',')) }
if ($null -ne $ergebnis) {
    Write-Output ('E204 ERGEBNIS rueckfrage=' + $ergebnis.rueckfrage + ' user=' + $ergebnis.user + ' pass=' + (PassName $ergebnis.pass) + ' lebt=' + $lebt)
} else {
    Write-Output ('E204 ERGEBNIS rueckfrage=- user=- pass=ungemessen lebt=' + $lebt)
}
