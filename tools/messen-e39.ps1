# messen-e39.ps1 - Befund E-39: entsteht der INI-Abschnitt einer geloeschten
# Persoenlichkeit wieder, wenn Eudora danach beendet wird?
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript bzw. als Schalter
# messen=tools\messen-e39.ps1 in tools\pruefstand-faelle.txt, Pruefstand
# C:\Temp\E39 (Kopie von C:\Temp\E140, ohne Netz).
#
# WARUM ES DAS GIBT. E-39 stand seit dem 08.09.2026 nur am Quelltext:
# CPersonality::Remove loescht den Abschnitt [Persona-<Name>], stellt die
# aktuelle Persoenlichkeit aber nicht um; FlushINIFile schreibt SavePassword
# und SavePasswordText in den Abschnitt der aktuellen. Dieser Lauf nimmt den
# Weg des Anwenders: Fenster Personalities, Eintrag waehlen, Delete,
# Rueckfrage mit Yes, Eudora beenden, Eudora.ini lesen.
#
#   -Vorbereiten  legt [Personalities] Persona0=Persona-E39Zwei und den
#                 Abschnitt [Persona-E39Zwei] (mit SavePassword=1) an
#   Messen        IDM_VIEW_PERSONALITIES (32947) ans Hauptfenster, die Liste
#                 am Eintrag <Dominant> erkannt (UI Automation), E39Zwei
#                 ueber SelectionItemPattern gewaehlt, IDM_DELETE_PERSONALITY
#                 (33038) an die Liste, die Rueckfrage (#32770 mit "E39Zwei"
#                 im Text) mit WM_COMMAND IDYES (6) samt Knopf-Handle
#                 beantwortet; Eudora.ini lesen; WM_CLOSE ans Hauptfenster,
#                 auf das Ende warten (nach Pfad gefiltert), Eudora.ini lesen.
#
# Nur Botschaften an gemessene Handles, kein Tastendruck
# (Arbeitsweise/keine-tastendruecke-verschicken.md).
#
# Ausgabe:
#   E39 ERGEBNIS abschnitt-wieder=<0|1> schluessel=<liste|-> aktuell-danach=<name|ungemessen> lebt=<0|1>
# Positivprobe (E39 PROBE): der Abschnitt stand vorher da, die Rueckfrage kam,
# und direkt nach Yes fehlten Abschnitt und Listeneintrag - sonst hat das
# Loeschen nicht stattgefunden, und abschnitt-wieder=0 waere nichts wert.
# aktuell-danach liest die Spurzeile "E-39 ..." aus eudora.log, falls der Bau
# sie schreibt; sonst "ungemessen".
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten,
    [int] $WarteSekunden = 20
)
$ErrorActionPreference = 'Stop'
$NAME   = 'E39Zwei'
$ABSCHN = 'Persona-' + $NAME

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Output "E39 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md  = Join-Path $voll 'Mailverzeichnis'
$ini = Join-Path $md 'Eudora.ini'
if (-not (Test-Path -LiteralPath $ini)) { Write-Output "E39 FEHLER: keine Eudora.ini in $md"; exit 1 }
$ansi = [Text.Encoding]::Default

# Abschnitte einer INI als Liste von @{Name; Zeilen}
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

if ($Vorbereiten) {
    $abschnitte = Lies-Ini
    $rest = @($abschnitte | Where-Object { $_.Name -ine 'Personalities' -and $_.Name -ine $ABSCHN })
    $sb = New-Object Text.StringBuilder
    foreach ($a in $rest) {
        if ($a.Name -ne '') { [void]$sb.Append('[' + $a.Name + ']' + "`r`n") }
        foreach ($z in $a.Zeilen) { if ($a.Name -ine 'Settings' -or $z -notmatch '^SavePasswordText=') { [void]$sb.Append($z + "`r`n") } }
        # Ein gemerktes Kennwort der Hauptpersoenlichkeit - sonst ist
        # Special > Forget Password(s) gesperrt (OnUpdateSpecialForgetPassword
        # fragt AccountsHavePasswords), und MFC fuehrt einen gesperrten Befehl
        # nicht aus (am 02.11.2026 so gemessen: kein Dialog).
        if ($a.Name -ieq 'Settings') { [void]$sb.Append("SavePasswordText=e39`r`n") }
    }
    [void]$sb.Append("[Personalities]`r`nPersona0=$ABSCHN`r`n")
    [void]$sb.Append("[$ABSCHN]`r`nRealName=E39 Zweite`r`nReturnAddress=e39zwei@e39.invalid`r`n" +
                     "POPAccount=e39zwei`r`nLoginName=e39zwei`r`nPopServer=127.0.0.1`r`n" +
                     "SMTPServer=127.0.0.1`r`nSavePassword=1`r`n")
    [IO.File]::WriteAllText($ini, $sb.ToString(), $ansi)
    Write-Output "E39 vorbereitet: [Personalities] Persona0=$ABSCHN und [$ABSCHN] angelegt"
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Collections.Generic; using System.Runtime.InteropServices;
public class E39W {
  public delegate bool EP(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP p, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr w, EP p, IntPtr l);
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int GetClassName(IntPtr h, StringBuilder s, int m);
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int m);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
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
  // LVITEMA im 32-Bit-Ziel: mask, iItem, iSubItem, state, stateMask, pszText, cchTextMax (je 4 Byte)
  static byte[] Lvitem(int mask, int item, int state, int stateMask, int text, int cch) {
    byte[] b = new byte[64];
    BitConverter.GetBytes(mask).CopyTo(b, 0);  BitConverter.GetBytes(item).CopyTo(b, 4);
    BitConverter.GetBytes(0).CopyTo(b, 8);     BitConverter.GetBytes(state).CopyTo(b, 12);
    BitConverter.GetBytes(stateMask).CopyTo(b, 16); BitConverter.GetBytes(text).CopyTo(b, 20);
    BitConverter.GetBytes(cch).CopyTo(b, 24);
    return b;
  }
  // Spalte 0 aller Eintraege (LVM_GETITEMCOUNT 0x1004, LVM_GETITEMTEXTA 0x102D)
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
  // nur Eintrag idx gewaehlt und fokussiert (LVM_SETITEMSTATE 0x102B; -1 = alle abwaehlen)
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
  // gewaehlte Eintraege zaehlen (LVM_GETSELECTEDCOUNT 0x1032)
  public static int Gewaehlt(IntPtr liste) { return (int)Senden(liste, 0x1032, IntPtr.Zero, IntPtr.Zero); }
}
"@

$proz = @(Get-Process -Name Eudora -ErrorAction SilentlyContinue |
          Where-Object { $_.Path -and $_.Path.StartsWith($voll + '\', [StringComparison]::OrdinalIgnoreCase) })
if ($proz.Count -ne 1) { Write-Output ('E39 FEHLER: ' + $proz.Count + ' Eudora-Prozesse unter ' + $voll + ', erwartet 1'); exit 1 }
$p = $proz[0]
$pid32 = [uint32]$p.Id

$a0 = Lies-Ini
$vorher = [int]($null -ne (Abschnitt $a0 $ABSCHN))
$pl0 = Abschnitt $a0 'Personalities'
$listeVorher = [int]($null -ne $pl0 -and (@($pl0.Zeilen | Where-Object { $_ -match ('=' + [regex]::Escape($ABSCHN) + '\s*$') }).Count -gt 0))
Write-Output ('E39 vorher: abschnitt=' + $vorher + ' liste=' + $listeVorher)

$haupt = [IntPtr]::Zero
foreach ($h in [E39W]::Fenster($pid32)) { if ([E39W]::Klasse($h) -eq 'EudoraMainWindow') { $haupt = $h } }
if ($haupt -eq [IntPtr]::Zero) { Write-Output 'E39 FEHLER: kein EudoraMainWindow'; exit 1 }

# Neuer Dialog des Prozesses, erkannt an einem Kind mit Kennung $merkmal
# (0 = jeder neue #32770).
function Warte-Dialog([IntPtr[]] $vorher, [int] $merkmal) {
    $frist = (Get-Date).AddSeconds($WarteSekunden)
    while ((Get-Date) -lt $frist) {
        Start-Sleep -Milliseconds 500
        foreach ($d in [E39W]::Fenster($pid32)) {
            if ([E39W]::Klasse($d) -ne '#32770' -or $vorher -contains $d) { continue }
            if ($merkmal -eq 0) { return $d }
            foreach ($k in [E39W]::Kinder($d)) { if ([E39W]::GetDlgCtrlID($k) -eq $merkmal) { return $d } }
        }
    }
    return [IntPtr]::Zero
}
function Kind([IntPtr] $d, [int] $id) {
    foreach ($k in [E39W]::Kinder($d)) { if ([E39W]::GetDlgCtrlID($k) -eq $id) { return $k } }
    return [IntPtr]::Zero
}
function Dialoge { @([E39W]::Fenster($pid32) | Where-Object { [E39W]::Klasse($_) -eq '#32770' }) }

# VORLAUF - wie die geloeschte Persoenlichkeit zur aktuellen wird. Ueber die
# Oberflaeche bleibt sie das nur auf einem Weg (am Quelltext gesucht,
# 02.11.2026): Special > Change Password (ChangePassword, password.cpp) waehlt
# im Dialog die Persoenlichkeit, schaltet mit SetCurrent auf sie um und kehrt
# bei einem Konto ohne "@" mit ErrorDialog zurueck, OHNE zurueckzuschalten.
# Danach Special > Forget Password(s) fuer alle: ForgetPasswords setzt
# SavePasswordText im Zwischenspeicher der aktuellen auf "geaendert", und weil
# die aktuelle am Ende dieselbe bleibt, wird nichts geschrieben.
$vorlauf = @()
$d = Dialoge
[void][E39W]::PostMessage($haupt, 0x0111, [IntPtr]32824, [IntPtr]::Zero)      # ID_SPECIAL_CHANGEPASSWORD
$mp = Warte-Dialog $d 20612                                                     # IDC_PERSONA_NAME
if ($mp -ne [IntPtr]::Zero) {
    [void][E39W]::Senden((Kind $mp 20612), 0x014E, [IntPtr]1, [IntPtr]::Zero)   # CB_SETCURSEL 1
    [void][E39W]::SendMessage((Kind $mp 1188), 0x000C, [IntPtr]::Zero, 'e39alt')   # WM_SETTEXT ins Kennwortfeld
    $d = Dialoge
    [void][E39W]::PostMessage($mp, 0x0111, [IntPtr]1, (Kind $mp 1))             # IDOK
    $fehler = Warte-Dialog $d 0
    if ($fehler -ne [IntPtr]::Zero) {
        $txt = @([E39W]::Kinder($fehler) | Where-Object { [E39W]::Klasse($_) -eq 'Static' } | ForEach-Object { [E39W]::Titel($_) } | Where-Object { $_ -ne '' }) -join ' / '
        Write-Output ('E39 Change Password: Meldung [' + ($txt -replace "`r?`n", ' ') + ']')
        [void][E39W]::PostMessage($fehler, 0x0111, [IntPtr]1, (Kind $fehler 1))
        Start-Sleep -Seconds 1
        $vorlauf += 'kennwort-meldung'
    } else { $vorlauf += 'kennwort-ohne-meldung' }
} else { $vorlauf += 'kennwort-kein-dialog' }
$d = Dialoge
[void][E39W]::PostMessage($haupt, 0x0111, [IntPtr]32823, [IntPtr]::Zero)      # ID_SPECIAL_FORGETPASSWORD
$fg = Warte-Dialog $d 8127                                                      # IDC_FORGET_PERSONAS
if ($fg -ne [IntPtr]::Zero) {
    [void][E39W]::Senden((Kind $fg 8127), 0x0185, [IntPtr]1, [IntPtr](-1))     # LB_SETSEL alle
    [void][E39W]::PostMessage($fg, 0x0111, [IntPtr]1, (Kind $fg 1))
    Start-Sleep -Seconds 1
    $vorlauf += 'vergessen'
} else { $vorlauf += 'vergessen-kein-dialog' }
Write-Output ('E39 Vorlauf: ' + ($vorlauf -join ','))

# Personalities-Fenster: IDM_VIEW_PERSONALITIES; die Liste am Eintrag <Dominant> erkannt
[void][E39W]::PostMessage($haupt, 0x0111, [IntPtr]32947, [IntPtr]::Zero)
# (UI Automation sah am 02.11.2026 in beiden Listen keine Eintraege; deshalb
# Spalte 0 ueber LVM_GETITEMTEXTA im Speicher des Zielprozesses.)
$liste = [IntPtr]::Zero; $eintrag = -1
$frist = (Get-Date).AddSeconds($WarteSekunden)
while ((Get-Date) -lt $frist -and $eintrag -lt 0) {
    Start-Sleep -Milliseconds 700
    $listen = @([E39W]::Fenster($pid32) | ForEach-Object { [E39W]::Kinder($_) } |
                Where-Object { [E39W]::Klasse($_) -eq 'SysListView32' -and [E39W]::IsWindowVisible($_) })
    foreach ($l in $listen) {
        $texte = @([E39W]::Texte($l, $pid32))
        if ($texte -notcontains '<Dominant>') { continue }
        $liste = $l
        $eintrag = [array]::IndexOf($texte, $NAME)
        Write-Output ('E39 Liste ' + $l + ': [' + ($texte -join '|') + ']')
    }
}
Write-Output ('E39 Persoenlichkeiten-Liste ' + $liste + ', Eintrag ' + $NAME + ' an Stelle ' + $eintrag)
if ($liste -eq [IntPtr]::Zero) {
    foreach ($l in @([E39W]::Fenster($pid32) | ForEach-Object { [E39W]::Kinder($_) } | Where-Object { [E39W]::Klasse($_) -eq 'SysListView32' })) {
        Write-Output ('E39   Liste ' + $l + ' sichtbar=' + [int][E39W]::IsWindowVisible($l) + ' [' + (@([E39W]::Texte($l, $pid32)) -join '|') + ']')
    }
}

$frage = 0; $nachAbschnitt = -1; $nachListe = -1; $frageText = ''
if ($eintrag -ge 0) {
    [E39W]::Waehle($liste, $pid32, $eintrag)
    Start-Sleep -Milliseconds 500
    Write-Output ('E39 gewaehlt: ' + [E39W]::Gewaehlt($liste) + ' Eintrag(e)')

    $dlgVorher = @([E39W]::Fenster($pid32) | Where-Object { [E39W]::Klasse($_) -eq '#32770' })
    [void][E39W]::PostMessage($liste, 0x0111, [IntPtr]33038, [IntPtr]::Zero)   # IDM_DELETE_PERSONALITY
    $dlg = [IntPtr]::Zero
    $frist = (Get-Date).AddSeconds($WarteSekunden)
    while ((Get-Date) -lt $frist -and $dlg -eq [IntPtr]::Zero) {
        Start-Sleep -Milliseconds 500
        foreach ($d in [E39W]::Fenster($pid32)) {
            if ([E39W]::Klasse($d) -ne '#32770' -or $dlgVorher -contains $d) { continue }
            foreach ($k in [E39W]::Kinder($d)) {
                if ([E39W]::Klasse($k) -eq 'Static' -and [E39W]::Titel($k) -like ('*' + $NAME + '*')) { $dlg = $d; $frageText = [E39W]::Titel($k) }
            }
        }
    }
    if ($dlg -ne [IntPtr]::Zero) {
        $frage = 1
        Write-Output ('E39 Rueckfrage: [' + ($frageText -replace "`r?`n", ' ') + ']')
        $ja = [IntPtr]::Zero
        foreach ($k in [E39W]::Kinder($dlg)) { if ([E39W]::GetDlgCtrlID($k) -eq 6 -and [E39W]::Klasse($k) -eq 'Button') { $ja = $k } }
        [void][E39W]::PostMessage($dlg, 0x0111, [IntPtr]6, $ja)                 # IDYES
        Start-Sleep -Seconds 2
        Write-Output ('E39 Rueckfrage nach Yes noch da: ' + [E39W]::IsWindow($dlg))
    } else {
        Write-Output 'E39 FEHLER: keine Rueckfrage zum Loeschen erschienen'
    }
    $a1 = Lies-Ini
    $nachAbschnitt = [int]($null -ne (Abschnitt $a1 $ABSCHN))
    $pl1 = Abschnitt $a1 'Personalities'
    $nachListe = [int]($null -ne $pl1 -and (@($pl1.Zeilen | Where-Object { $_ -match ('=' + [regex]::Escape($ABSCHN) + '\s*$') }).Count -gt 0))
    Write-Output ('E39 nach Yes: abschnitt=' + $nachAbschnitt + ' liste=' + $nachListe)
}

$p.Refresh()
$lebt = [int](-not $p.HasExited)
if ($lebt -eq 1) {
    [void][E39W]::PostMessage($haupt, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # WM_CLOSE
    $frist = (Get-Date).AddSeconds(60)
    while (-not $p.HasExited -and (Get-Date) -lt $frist) { Start-Sleep -Milliseconds 500; $p.Refresh() }
    Write-Output ('E39 beendet: ' + $p.HasExited)
}

$a2 = Lies-Ini
$s2 = Abschnitt $a2 $ABSCHN
$wieder = [int]($null -ne $s2)
$schl = '-'
if ($null -ne $s2) { $schl = (@($s2.Zeilen | ForEach-Object { ($_ -split '=', 2)[0] }) -join ',') }

$aktuell = 'ungemessen'
$log = Join-Path $md 'eudora.log'
if (Test-Path -LiteralPath $log) {
    # Spurzeile: "E-39 Remove <Name>: war-aktuell=<0|1> aktuell=<name>" -
    # mit Leerzeichen davor, sonst trifft "war-aktuell=" (am 02.11.2026 so
    # geschehen: aktuell-danach=1).
    $spur = @(Get-Content -LiteralPath $log | Where-Object { $_ -match 'E-39 .* aktuell=(\S+)' })
    if ($spur.Count -gt 0) { [void]($spur[-1] -match ' aktuell=(\S+)'); $aktuell = $Matches[1] }
}

$probe = 'ok'
if ($vorher -ne 1 -or $listeVorher -ne 1) { $probe = 'abschnitt-fehlte-vorher' }
elseif ($frage -ne 1) { $probe = 'keine-rueckfrage' }
elseif ($nachAbschnitt -ne 0 -or $nachListe -ne 0) { $probe = 'nicht-geloescht' }
Write-Output ('E39 PROBE ' + $probe)
Write-Output ('E39 ERGEBNIS abschnitt-wieder=' + $wieder + ' schluessel=' + $schl + ' aktuell-danach=' + $aktuell + ' lebt=' + $lebt)
