# messen-e166-assistent.ps1 - stellt Gregors Sitzung vom 27.10.2026 22:26 nach
# (Befund E-166): ohne Konto startet Eudora den Konto-Assistenten per
# PostMessage, und der laeuft INNERHALB der modalen Schleife der Junk-Frage.
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (bekommt -Pfadfilter) auf einem
# Pruefstand, dessen Eudora.ini KEIN Konto und kein AskedAboutJunk enthaelt.
#
# Ablauf: wartet, bis Junk-Frage UND Assistent stehen, schreibt die Kinder des
# Assistenten ins Protokoll (Klasse, Kennung, Text), bricht den Assistenten ab
# (WM_COMMAND IDCANCEL an das gemessene Handle) und beantwortet danach die
# Junk-Frage mit No (WM_COMMAND IDCANCEL = "Dismissed with 2", wie bei Gregor).
# Kein Tastendruck (Arbeitsweise/keine-tastendruecke-verschicken.md).
#
# Ausgabe: "E166A ERGEBNIS frage=<0|1> assistent=<0|1> reihenfolge=<...>".
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [int] $WarteSekunden = 30
)
$ErrorActionPreference = 'Stop'

Add-Type @"
using System; using System.Text; using System.Collections.Generic; using System.Runtime.InteropServices;
public class E166A {
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
  [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern IntPtr SendMessage(IntPtr h, uint m, IntPtr w, string l);
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
  public static string Titel(IntPtr h)  { StringBuilder s = new StringBuilder(512); GetWindowText(h, s, 512); return s.ToString(); }
}
"@

$titelJunk = 'Automatically put junk mail in the Junk mailbox?'
$voll  = (Resolve-Path -LiteralPath $Pfadfilter).Path.TrimEnd('\')
$proz  = @(Get-Process -Name Eudora -ErrorAction SilentlyContinue |
           Where-Object { $_.Path -and $_.Path.StartsWith($voll + '\', [StringComparison]::OrdinalIgnoreCase) })
if ($proz.Count -ne 1) {
    Write-Output ('E166A FEHLER: ' + $proz.Count + ' Eudora-Prozesse unter ' + $voll + ', erwartet 1')
    exit 1
}
$p = $proz[0]

$junk = [IntPtr]::Zero; $assi = [IntPtr]::Zero
$frist = (Get-Date).AddSeconds($WarteSekunden)
while ((Get-Date) -lt $frist -and ($junk -eq [IntPtr]::Zero -or $assi -eq [IntPtr]::Zero)) {
    foreach ($h in [E166A]::Fenster([uint32] $p.Id)) {
        if ([E166A]::Klasse($h) -ne '#32770') { continue }
        if ([E166A]::Titel($h) -eq $titelJunk) { $junk = $h }
        else { $assi = $h }
    }
    Start-Sleep -Milliseconds 500
}
Write-Output ('E166A Junk-Frage ' + $junk + ', anderer Dialog ' + $assi + ' [' + [E166A]::Titel($assi) + ']')
Write-Output 'E166A Sichtbare Fenster des Prozesses:'
foreach ($h in [E166A]::Fenster([uint32] $p.Id)) {
    Write-Output ('E166A   ' + $h + '  ' + [E166A]::Klasse($h) + '  [' + [E166A]::Titel($h) + ']')
}
if ($assi -ne [IntPtr]::Zero) {
    Write-Output 'E166A Kinder des Assistenten (Kennung Klasse [Text]):'
    foreach ($k in [E166A]::Kinder($assi)) {
        if (-not [E166A]::IsWindowVisible($k)) { continue }
        Write-Output ('E166A   ' + [E166A]::GetDlgCtrlID($k) + '  ' + [E166A]::Klasse($k) + '  [' + [E166A]::Titel($k) + ']')
    }
}

$reihenfolge = @()
# E166_ERKUNDEN=<n>: n-mal "Weiter" (WM_COMMAND ID_WIZNEXT 12324; PSM_PRESSBUTTON wirkte am 28.10. nicht) und jede Seite
# mit ihren sichtbaren Kindern ausgeben; danach wie sonst abbrechen.
$erkunden = [int]$env:E166_ERKUNDEN
for ($i = 1; $i -le $erkunden -and [E166A]::IsWindow($assi); $i++) {
    [void][E166A]::PostMessage($assi, 0x0111, [IntPtr]12324, [IntPtr]::Zero)
    Start-Sleep -Seconds 2
    Write-Output ('E166A Seite ' + $i + ':')
    foreach ($k in [E166A]::Kinder($assi)) {
        if (-not [E166A]::IsWindowVisible($k)) { continue }
        Write-Output ('E166A   ' + [E166A]::GetDlgCtrlID($k) + '  ' + [E166A]::Klasse($k) + '  [' + [E166A]::Titel($k) + ']')
    }
}
# E166_FERTIG=1: den Assistenten wie Gregor bis "Fertig stellen" durchfahren.
# Leere Felder werden nach ihrer Kennung (resource.h) gefuellt, "Test server"
# wird abgewaehlt (sonst Verbindungsversuch auf 127.0.0.1). Erst wenn der
# Assistent zu ist, wird die Junk-Frage beantwortet - so war es bei Gregor.
if ($env:E166_FERTIG -eq '1' -and $assi -ne [IntPtr]::Zero) {
    $werte = @{ 26102 = 'E166 Pruefstand'; 26104 = 'e166@example.invalid'; 26113 = 'e166';
                26117 = '127.0.0.1'; 26130 = '127.0.0.1' }
    for ($i = 1; $i -le 15 -and [E166A]::IsWindow($assi); $i++) {
        $fertig = $false
        foreach ($k in [E166A]::Kinder($assi)) {
            if (-not [E166A]::IsWindowVisible($k)) { continue }
            $id = [E166A]::GetDlgCtrlID($k)
            if ([E166A]::Klasse($k) -eq 'Edit' -and $werte.ContainsKey($id) -and [E166A]::Titel($k) -eq '') {
                [void][E166A]::SendMessage($k, 0x000C, [IntPtr]::Zero, $werte[$id])   # WM_SETTEXT
                Write-Output ('E166A Seite ' + $i + ': Feld ' + $id + ' = ' + $werte[$id])
            }
            if ($id -eq 11131) { [void][E166A]::PostMessage($k, 0x00F1, [IntPtr]0, [IntPtr]::Zero) }  # BM_SETCHECK aus
            if ($id -eq 12325) { $fertig = $true }   # ID_WIZFINISH sichtbar
        }
        Start-Sleep -Milliseconds 500
        $knopf = 12324; if ($fertig) { $knopf = 12325 }
        # lParam = Handle des Knopfes: CPropertySheet::OnCommand (dlgprop.cpp)
        # setzt m_nModalResult nur bei BN_CLICKED mit Knopf-Handle - ohne das
        # liefert DoModal 0 statt ID_WIZFINISH, und StartWizard speichert nichts
        # (am 28.10.2026 so geschehen).
        $hKnopf = [IntPtr]::Zero
        foreach ($k in [E166A]::Kinder($assi)) { if ([E166A]::GetDlgCtrlID($k) -eq $knopf) { $hKnopf = $k } }
        [void][E166A]::PostMessage($assi, 0x0111, [IntPtr]$knopf, $hKnopf)
        Write-Output ('E166A Seite ' + $i + ': Knopf ' + $knopf)
        Start-Sleep -Seconds 2
    }
    if (-not [E166A]::IsWindow($assi)) { $reihenfolge += 'assistent-fertig'; $assi2 = $assi; $assi = [IntPtr]::Zero }
    Write-Output ('E166A Assistent nach Durchlauf noch da: ' + [E166A]::IsWindow($assi2))
}
if ($assi -ne [IntPtr]::Zero) {
    # WM_COMMAND = 0x0111, IDCANCEL = 2
    [void][E166A]::PostMessage($assi, 0x0111, [IntPtr]2, [IntPtr]::Zero)
    $reihenfolge += 'assistent-abgebrochen'
    Start-Sleep -Seconds 2
    Write-Output ('E166A Assistent nach Abbruch noch da: ' + [E166A]::IsWindow($assi))
}
if ($junk -ne [IntPtr]::Zero) {
    [void][E166A]::PostMessage($junk, 0x0111, [IntPtr]2, [IntPtr]::Zero)
    $reihenfolge += 'junk-no'
    Start-Sleep -Seconds 2
    Write-Output ('E166A Junk-Frage nach Antwort noch da: ' + [E166A]::IsWindow($junk))
}
# E166_KONTO=1: NACH der Junk-Antwort die Konto-Eigenschaften der
# Hauptpersoenlichkeit oeffnen und mit OK schliessen. Das ruft
# CPersonality::Modify (ModifyAcctSheet.cpp:126), und Modify leert den
# INI-Zwischenspeicher ohne ihn vorher zu schreiben (persona.cpp:221).
# Die Persoenlichkeiten-Ansicht wird am Merkmal "erscheint auf
# IDM_VIEW_PERSONALITIES (32947)" erkannt: genau eine neue SysListView32.
if ($env:E166_KONTO -eq '1') {
    $haupt = [IntPtr]::Zero
    foreach ($h in [E166A]::Fenster([uint32] $p.Id)) { if ([E166A]::Klasse($h) -eq 'EudoraMainWindow') { $haupt = $h } }
    # alle Fenster des Prozesses: eine schwebende Leiste haengt nicht unter dem Hauptfenster
    function Listen { @([E166A]::Fenster([uint32] $p.Id) | ForEach-Object { [E166A]::Kinder($_) } | Where-Object { [E166A]::Klasse($_) -eq 'SysListView32' }) }
    $vorher = Listen
    [void][E166A]::PostMessage($haupt, 0x0111, [IntPtr]32947, [IntPtr]::Zero)
    Start-Sleep -Seconds 2
    $alle = Listen
    Write-Output ('E166A Listen im Prozess: ' + $alle.Count)
    $neu = @($alle | Where-Object { $vorher -notcontains $_ })
    Write-Output ('E166A Persoenlichkeiten-Ansicht: ' + $neu.Count + ' neue Liste(n)')
    if ($neu.Count -eq 0) {
        # Stand die Ansicht schon (Eudora stellt offene Leisten wieder her),
        # entsteht keine neue Liste - am 28.10.2026 so geschehen, die Messung
        # lief dann ohne Konto-Schritt. Merkmal statt Neuheit: die Liste mit
        # dem Eintrag "<Dominant>", gelesen ueber UI Automation.
        Add-Type -AssemblyName UIAutomationClient, UIAutomationTypes
        $neu = @($alle | Where-Object {
            $el = [System.Windows.Automation.AutomationElement]::FromHandle($_)
            $c  = New-Object System.Windows.Automation.PropertyCondition(
                      [System.Windows.Automation.AutomationElement]::NameProperty, '<Dominant>')
            $null -ne $el.FindFirst([System.Windows.Automation.TreeScope]::Descendants, $c)
        })
        Write-Output ('E166A Persoenlichkeiten-Ansicht am Eintrag <Dominant>: ' + $neu.Count + ' Liste(n)')
    }
    if ($neu.Count -eq 1) {
        $dlgVorher = @([E166A]::Fenster([uint32] $p.Id) | Where-Object { [E166A]::Klasse($_) -eq '#32770' })
        [void][E166A]::PostMessage($neu[0], 0x800B, [IntPtr]::Zero, [IntPtr]::Zero)   # msgPersViewEditDom = WM_APP+11
        Start-Sleep -Seconds 2
        $blatt = @([E166A]::Fenster([uint32] $p.Id) | Where-Object { [E166A]::Klasse($_) -eq '#32770' -and $dlgVorher -notcontains $_ })
        Write-Output ('E166A Konto-Eigenschaften: ' + $blatt.Count + ' neues Fenster [' + ($(if ($blatt.Count) { [E166A]::Titel($blatt[0]) })) + ']')
        if ($blatt.Count -eq 1) {
            $ok = [IntPtr]::Zero
            foreach ($k in [E166A]::Kinder($blatt[0])) { if ([E166A]::GetDlgCtrlID($k) -eq 1 -and [E166A]::Klasse($k) -eq 'Button') { $ok = $k } }
            [void][E166A]::PostMessage($blatt[0], 0x0111, [IntPtr]1, $ok)
            Start-Sleep -Seconds 2
            Write-Output ('E166A Konto-Eigenschaften nach OK noch da: ' + [E166A]::IsWindow($blatt[0]))
            $reihenfolge += 'konto-ok'
        }
    }
}
Start-Sleep -Seconds 2
Write-Output ('E166A ERGEBNIS frage=' + [int]($junk -ne [IntPtr]::Zero) + ' assistent=' +
              [int]($assi -ne [IntPtr]::Zero) + ' reihenfolge=' + ($reihenfolge -join ','))
