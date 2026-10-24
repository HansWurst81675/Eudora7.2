# messen-e77.ps1 - wie zeigt Eudora IMAP-Ordner mit Umlauten an? (Befund E-77)
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript. Der Pruefstand (C:\Temp\E77)
# traegt in Mailverzeichnis\Imap\pruefimap\mboxlist.lst die Ordner so, wie GMX
# sie schickt: "Entw&APw-rfe" und "Gel&APY-scht" (modifiziertes UTF-7,
# RFC 3501). Eudora liest die Liste beim Start; das Skript liest danach das
# Menue Transfer samt Untermenues und gibt jeden Eintrag aus. Kein Netz.
#
# Ausgabe: "E77 MENUE <Pfad>" je Eintrag, am Ende "E77 ERGEBNIS
# roh=<n> dekodiert=<n>". Erwartet nach der Behebung: roh=0 dekodiert=2.
param([Parameter(Mandatory = $true)] [string] $Pfadfilter, [switch] $Vorbereiten)
$ErrorActionPreference = 'Stop'
$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')

# -Vorbereiten: die Ordnerliste so anlegen, wie GMX sie schickt. Nur unter C:\Temp.
if ($Vorbereiten) {
    if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E77 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
    $konto = Join-Path $voll 'Mailverzeichnis\Imap\pruefimap'
    if (-not (Test-Path $konto)) { Write-Host "E77 FEHLER: kein IMAP-Konto pruefimap in $voll"; exit 1 }
    foreach ($d in 'Entw&APw-rfe', 'Gel&APY-scht') { New-Item -ItemType Directory -Force -Path (Join-Path $konto $d) | Out-Null }
    $zeilen = @('INBOX,INBOX,M,/,0,0,0,0,Y,0', 'Ablage,Ablage,M,/,0,0,0,0,N,0',
                'Entw&APw-rfe,Entw&APw-rfe,M,/,0,0,0,0,N,0', 'Gel&APY-scht,Gel&APY-scht,M,/,0,0,0,0,N,0')
    [IO.File]::WriteAllText((Join-Path $konto 'mboxlist.lst'), (($zeilen -join "`r`n") + "`r`n"))
    Write-Host "E77 vorbereitet: $konto"
    exit 0
}
Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class WinBild {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out R r);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern IntPtr GetMenu(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetMenuItemCount(IntPtr m);
  [DllImport("user32.dll")] public static extern uint GetMenuItemID(IntPtr m, int i);
  [DllImport("user32.dll")] public static extern IntPtr GetSubMenu(IntPtr m, int i);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetMenuStringA(IntPtr m, uint id, StringBuilder s, int n, uint f);
  [StructLayout(LayoutKind.Sequential)] public struct R { public int L, T, Ri, B; }
}
"@

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][WinBild]::GetClassName($h,$s,256); $s.ToString() }
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and [IO.Path]::GetDirectoryName($_.Path).TrimEnd('\') -ieq $voll }
if (-not $proz) { Write-Host "E77 FEHLER: keine Eudora aus $voll"; exit 1 }
$haupt = $null
$cb = [WinBild+EP]{ param($h,$p)
    $o = 0; [void][WinBild]::GetWindowThreadProcessId($h,[ref]$o)
    if ($o -eq $proz[0].Id -and (Kl $h) -eq 'EudoraMainWindow' -and [WinBild]::IsWindowVisible($h)) { $script:haupt = $h }
    return $true }
[void][WinBild]::EnumWindows($cb,[IntPtr]::Zero)
if (-not $haupt) { Write-Host 'E77 FEHLER: kein Hauptfenster'; exit 1 }

$script:roh = 0; $script:dekodiert = 0
function Ausgeben($menu, [string] $pfad, [int] $tiefe) {
    if ($tiefe -gt 4) { return }
    for ($i = 0; $i -lt [WinBild]::GetMenuItemCount($menu); $i++) {
        $s = New-Object Text.StringBuilder 256
        [void][WinBild]::GetMenuStringA($menu, [uint32]$i, $s, 256, 0x400)
        # "&&" ist ein echtes "&" (ein IMAP-Rohname enthaelt eins), "&x" eine Zugriffstaste.
        $t = $s.ToString().Replace('&&', [string][char]1).Replace('&', '').Replace([string][char]1, '&')
        if ($t -eq '') { continue }
        $voller = "$pfad > $t"
        # Roh kommt im Menue OHNE "&" an - Windows nimmt es als Zugriffstaste
        # (gemessen an 7.2.0.120: "EntwAPw-rfe"). Deshalb am Base64-Rest erkennen.
        if ($t -match 'AP[wY]-') { $script:roh++ }
        if ($t -eq ("Entw" + [char]0xFC + "rfe") -or $t -eq ("Gel" + [char]0xF6 + "scht")) { $script:dekodiert++ }
        Write-Host "E77 MENUE $voller"
        $sub = [WinBild]::GetSubMenu($menu, $i)
        if ($sub -ne [IntPtr]::Zero) {
            [void][WinBild]::SendMessageA($haupt, 0x0117, $sub, [IntPtr]$i)   # WM_INITMENUPOPUP: Eudora fuellt erst beim Aufklappen
            Ausgeben $sub $voller ($tiefe + 1)
        }
    }
}
$m = [WinBild]::GetMenu($haupt)
for ($i = 0; $i -lt [WinBild]::GetMenuItemCount($m); $i++) {
    $s = New-Object Text.StringBuilder 128
    [void][WinBild]::GetMenuStringA($m, [uint32]$i, $s, 128, 0x400)
    if (($s.ToString() -replace '&','') -ne 'Transfer') { continue }
    $sub = [WinBild]::GetSubMenu($m, $i)
    [void][WinBild]::SendMessageA($haupt, 0x0117, $sub, [IntPtr]$i)
    Ausgeben $sub 'Transfer' 1
}
Write-Host ("E77 ERGEBNIS roh={0} dekodiert={1}" -f $script:roh, $script:dekodiert)
