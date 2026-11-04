# messen-e178.ps1 - Befund E-178: machen Formatierbefehle im Bearbeiten-Modus
# der Leseansicht (und die Antwort auf markierten Text) Zeichen ausserhalb von
# windows-1252 zu "??"?
#
# Laeuft unter tools\testlauf.ps1 -MessenSkript (ueber pruefstand-lauf.ps1),
# Pruefstand C:\Temp\E178 (Kopie von C:\Temp\E136). Nur Botschaften an
# gemessene Fensterhandles, KEIN Tastendruck.
#
# Pruefnachricht Testdaten\e136-zeichen-als-entitaet.eml (HTML, windows-1252,
# &#128293; und &#1046; als Entitaet - ueber den Server empfangene Emoji gehen
# wegen E-90/E-147 schon beim Empfang verloren, deshalb diese Nachricht).
#
# WIE DER WEG GETROFFEN WIRD
#   * Bearbeiten-Modus: haengt am Leistenknopf ID_EDIT_MESSAGE (32996) der
#     Leiste "Read Message" (CReadMessageFrame::GetCheck liest dessen Stil;
#     ein WM_COMMAND allein schaltet ihn nicht um, E-136). Ein Mausklick per
#     Botschaft an die Leiste wirkt nicht (OTShim SECCustomToolBar braucht
#     SetCapture, gemessen 02.11.2026). Statt dessen die zwei Schritte des
#     Klicks als Botschaften an das Nachrichtenfenster: "umsgButtonSetCheck"
#     (OnButtonSetCheck, setzt TBBS_CHECKED) und WM_COMMAND ID_EDIT_MESSAGE
#     (OnEditMode in Rahmen und Anzeige). Nachweis: body.isContentEditable.
#   * Auswahl: ueber das Dokument der Anzeige (WM_HTML_GETOBJECT an das
#     gemessene Fenster "Internet Explorer_Server", ObjectFromLresult, spaete
#     Bindung ueber IDispatch), IHTMLTxtRange.findText/select. Die Auswahl
#     umfasst "Vierbyte-Zeichen:" MIT dem Emoji bis einschliesslich des
#     kyrillischen Zeichens - der haertere Fall: die Zeichen liegen IN dem
#     Text, den der Befehl umbaut. Fuer den Link nur der Listenpunkt mit dem
#     Emoji (ueber zwei Listenpunkte oeffnet sich kein Link-Dialog).
#   * Befehle als WM_COMMAND an das Nachrichtenfenster: ID_EDIT_TEXT_BOLD
#     (32882), ID_EDIT_TEXT_ITALIC (32884) - beide nur ExecCommand, keine der
#     neun Stellen, stehen als Kontrolle drin -, ID_EDIT_INSERT_LINK (33012 ->
#     IDM_HYPERLINK mit MSHTML-Dialog "Link", danach ExpandTag),
#     ID_EDIT_TEXT_TT (33004, Festbreite -> WrapTag). Den Link-Dialog fuellt
#     das Skript ueber SEIN Dokument (txtURL, btnOK.click()) - kein Tastendruck.
#   * Nach jedem Befehl wird das Dokument der Anzeige gelesen: stehen U+1F525
#     und U+0416 noch darin? "Schon auf dem Bildschirm" ist damit gemessen,
#     nicht erst in der Datei. War ein Schritt kaputt, setzt das Skript die
#     Liste fuer den naechsten Schritt per DOM zurueck (sonst waere jeder
#     spaetere Schritt nur Folgefehler) und vermerkt das.
#   * Speichern: ID_FILE_SAVE (57603), Fenster schliessen, In.mbx lesen
#     (letzte Fassung - gespeichert wird angehaengt).
#   * Antwort: zweite Abschrift der Pruefnachricht (Betreff "E-178 Antwort")
#     im Lesemodus oeffnen, dieselbe Auswahl, ID_MESSAGE_REPLY (32855);
#     CMessageDoc holt den markierten Text ueber CTridentView::GetSelectedHTML
#     (TridentView.cpp, die neunte Stelle). Das Verfassen-Fenster ist Paige
#     (EudoraEdit), sein Inhalt nicht lesbar: WM_CHAR an das Betreff-Feld
#     (macht die Antwort speicherbar), ID_FILE_SAVE, Out.mbx lesen.
#
# Ausgabe:
#   E178 SCHRITT <name> emoji=<0|1> kyr=<0|1> frage=<n> html=<auszug>
#   E178 ERGEBNIS fett=<passt|kaputt|-> kursiv=<..> tt=<..> link=<..> gespeichert=<passt|kaputt|-> antwort=<..|-> lebt=<0|1>
#   passt = beide Zeichen stehen nach dem Schritt noch im Dokument (bzw. in
#   der Datei als Entitaet oder Zeichen); kaputt = eines fehlt; - = Schritt
#   nicht erreicht (Grund in einer Zeile davor).
param(
    [Parameter(Mandatory = $true)] [string] $Pfadfilter,
    [switch] $Vorbereiten
)
$ErrorActionPreference = 'Stop'
# Jede Ausnahme als Zeile auf stdout und Rueckgabe 1 - eine Ausnahme auf
# stderr bricht testlauf.ps1 (ErrorActionPreference Stop) VOR dem Beenden und
# vor dem Protokoll ab (gemessen 02.11.2026, 11:02: Eudora blieb stehen, keine
# Zeile in TESTLAEUFE.md).
trap { Write-Host ("E178 AUSNAHME " + $_.Exception.Message + " | " + ($_.InvocationInfo.PositionMessage -replace '\s+', ' ')); Write-Host "E178 ERGEBNIS abgebrochen"; exit 1 }

$voll = [IO.Path]::GetFullPath($Pfadfilter).TrimEnd('\')
if ($voll -notmatch '^C:\\Temp\\[^\\]+') { Write-Host "E178 ABGEWIESEN: $voll liegt nicht unter C:\Temp"; exit 2 }
$md = Join-Path $voll 'Mailverzeichnis'

if ($Vorbereiten) {
    if (-not (Test-Path (Join-Path $md 'Eudora.ini'))) { Write-Host "E178 FEHLER: kein Mailverzeichnis in $voll"; exit 1 }
    foreach ($n in 'Out','In','Trash') {
        Get-ChildItem -LiteralPath $md -File | Where-Object { $_.Name -match ('^' + $n + '\.(mbx|toc)(\.\d{3})?$') } |
            Remove-Item -Force
    }
    $eml = Join-Path (Split-Path -Parent $PSScriptRoot) 'Testdaten\e136-zeichen-als-entitaet.eml'
    $b = [IO.File]::ReadAllBytes($eml)
    $kopf = [Text.Encoding]::ASCII.GetBytes("From ???@??? Mon Nov 02 11:00:00 2026`r`n")
    $ende = [Text.Encoding]::ASCII.GetBytes("`r`n")
    # Zweite Abschrift mit eigenem Betreff fuer die Antwort: die erste ist nach
    # den Formatierbefehlen umgebaut (der Link trennt "Kyrillisch:" und das
    # Zeichen in zwei Listenpunkte, gemessen 02.11.2026, 11:16), eine Auswahl
    # darauf traefe das Zeichen nicht mehr.
    $t = [Text.Encoding]::GetEncoding(28591).GetString($b)
    $b2 = [Text.Encoding]::GetEncoding(28591).GetBytes(($t -replace 'Subject: Pruefung E-136:', 'Subject: Pruefung E-178 Antwort:' -replace 'Message-ID: <e136-entitaet@', 'Message-ID: <e178-antwort@'))
    [IO.File]::WriteAllBytes((Join-Path $md 'In.mbx'), [byte[]]($kopf + $b + $ende + $kopf + $b2 + $ende))
    Write-Host ("E178 vorbereitet: {0}" -f $md)
    exit 0
}

Add-Type @"
using System; using System.Text; using System.Runtime.InteropServices;
public class E178 {
  public delegate bool EP(IntPtr h, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EP f, IntPtr p);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr h, EP f, IntPtr p);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Ansi)] public static extern int GetWindowTextA(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetDlgCtrlID(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out R r);
  [DllImport("user32.dll")] public static extern bool GetClientRect(IntPtr h, out R r);
  [DllImport("user32.dll")] public static extern bool ScreenToClient(IntPtr h, ref P p);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern bool PostMessageA(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern uint RegisterWindowMessageW(string s);
  [DllImport("user32.dll")] public static extern IntPtr SendMessageTimeoutA(IntPtr h, uint m, IntPtr w, IntPtr l, uint f, uint t, out IntPtr r);
  [DllImport("oleacc.dll", PreserveSig=false)] [return: MarshalAs(UnmanagedType.Interface)]
  public static extern object ObjectFromLresult(IntPtr lr, [MarshalAs(UnmanagedType.LPStruct)] Guid iid, IntPtr w);
  [StructLayout(LayoutKind.Sequential)] public struct R { public int L, T, Ri, B; }
  [StructLayout(LayoutKind.Sequential)] public struct P { public int X, Y; }
  public static object Dokument(IntPtr h) {
    uint m = RegisterWindowMessageW("WM_HTML_GETOBJECT");
    IntPtr r;
    SendMessageTimeoutA(h, m, IntPtr.Zero, IntPtr.Zero, 2, 5000, out r);   // SMTO_ABORTIFHUNG
    if (r == IntPtr.Zero) return null;
    return ObjectFromLresult(r, new Guid("332C4425-26CB-11D0-B483-00C04FD90119"), IntPtr.Zero);  // IHTMLDocument2
  }
  // Das Dokument kommt ohne Typinformation an; der COM-Adapter von
  // PowerShell bindet dann keine Eigenschaft ($doc.body ist leer, gemessen
  // 02.11.2026). Spaete Bindung ueber IDispatch geht.
  const System.Reflection.BindingFlags GP = System.Reflection.BindingFlags.GetProperty;
  public static object Get(object o, string n) { try { return o.GetType().InvokeMember(n, GP, null, o, null); } catch (Exception e) { throw new Exception("Get " + n + ": " + (e.InnerException ?? e).Message); } }
  public static void Set(object o, string n, object v) { o.GetType().InvokeMember(n, System.Reflection.BindingFlags.SetProperty, null, o, new object[] { v }); }
  public static object Call(object o, string n, object[] a) { try { return o.GetType().InvokeMember(n, System.Reflection.BindingFlags.InvokeMethod, null, o, a); } catch (Exception e) { throw new Exception("Call " + n + ": " + (e.InnerException ?? e).Message); } }
}
"@

function Kl($h) { $s = New-Object Text.StringBuilder 256; [void][E178]::GetClassName($h,$s,256); $s.ToString() }
function Tx($h) { $s = New-Object Text.StringBuilder 512; [void][E178]::GetWindowTextA($h,$s,512); $s.ToString() }
function G($o, [string] $n) { return ,([E178]::Get($o, $n)) }   # Komma: eine Sammlung nicht auffaechern
function S($o, [string] $n, $v) { [E178]::Set($o, $n, $v) }
function C($o, [string] $n) { return ,([E178]::Call($o, $n, [object[]]$args)) }
function Kinder($h) {
    $k = New-Object System.Collections.ArrayList
    $cc = [E178+EP]{ param($x,$q) [void]$k.Add($x); return $true }
    [void][E178]::EnumChildWindows($h,$cc,[IntPtr]::Zero)
    return $k
}
function AlleFenster($pp) {
    $r = New-Object System.Collections.ArrayList
    $cb = [E178+EP]{ param($h,$p)
        $o = 0; [void][E178]::GetWindowThreadProcessId($h,[ref]$o)
        if ($o -eq $pp) {
            [void]$r.Add([pscustomobject]@{H=$h; Klasse=(Kl $h); Text=(Tx $h); Vis=[E178]::IsWindowVisible($h); Oben=$true})
            foreach ($c in (Kinder $h)) {
                [void]$r.Add([pscustomobject]@{H=$c; Klasse=(Kl $c); Text=(Tx $c); Vis=[E178]::IsWindowVisible($c); Oben=$false})
            }
        }
        return $true }
    [void][E178]::EnumWindows($cb,[IntPtr]::Zero)
    return $r
}
function Lebt($pp) { return [bool](Get-Process -Id $pp -ErrorAction SilentlyContinue) }
# Dialoge (#32770) mit Text ausgeben; ohne passenden Knopf ABBRECHEN, nie blind OK.
function Dialoge($pp, [string] $Knopf = '^(OK)$') {
    $n = 0
    foreach ($d in (AlleFenster $pp | Where-Object { $_.Oben -and $_.Vis -and $_.Klasse -eq '#32770' })) {
        $texte = @(); $knoepfe = @()
        foreach ($c in (Kinder $d.H)) {
            $k = Kl $c; $t = (Tx $c) -replace '&',''
            if ($k -eq 'Static' -and $t) { $texte += $t }
            if ($k -eq 'Button')         { $knoepfe += [pscustomobject]@{H=$c; T=$t} }
        }
        Write-Host ("E178 DIALOG [{0}] {1} | Knoepfe: {2}" -f $d.Text, ($texte -join ' '), (($knoepfe | ForEach-Object { $_.T }) -join ', '))
        $b = $knoepfe | Where-Object { $_.T -match $Knopf } | Select-Object -First 1
        if ($b) { [void][E178]::PostMessageA($b.H, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) }   # BM_CLICK
        else    { [void][E178]::PostMessageA($d.H, 0x0111, [IntPtr]2, [IntPtr]::Zero) }       # IDCANCEL
        Start-Sleep -Milliseconds 800
        $n++
    }
    return $n
}
function Befehl($h, [int] $id) { [void][E178]::PostMessageA($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero); Start-Sleep -Milliseconds 1500 }
function Aktiv($mdi) { return [E178]::SendMessageA($mdi, 0x0229, [IntPtr]::Zero, [IntPtr]::Zero) }   # WM_MDIGETACTIVE
function Liste($kind) {
    return (Kinder $kind | Where-Object { (Kl $_) -eq 'ListBox' -and [E178]::IsWindowVisible($_) } | Select-Object -First 1)
}
function Anzahl($lb) { return [int][E178]::SendMessageA($lb, 0x018B, [IntPtr]::Zero, [IntPtr]::Zero) }  # LB_GETCOUNT
function Waehle($lb, [int] $i) {
    [void][E178]::SendMessageA($lb, 0x0185, [IntPtr]0, [IntPtr](-1))     # LB_SETSEL FALSE, alle
    [void][E178]::SendMessageA($lb, 0x0185, [IntPtr]1, [IntPtr]$i)       # LB_SETSEL TRUE, i
    [void][E178]::SendMessageA($lb, 0x019E, [IntPtr]$i, [IntPtr]::Zero)  # LB_SETCARETINDEX
}
function InListe() {
    for ($v = 0; $v -lt 10; $v++) {
        Befehl $haupt 32792                       # ID_MAILBOX_IN
        $k = Aktiv $mdi; $lb = Liste $k
        if ($lb) { return @($k, $lb) }
        Start-Sleep -Milliseconds 500
    }
    Write-Host 'E178 FEHLER: Postfach In kam nicht nach vorn'; exit 1
}
# Oeffnet die Nachricht aus In, deren Fenstertitel $Betreff enthaelt (die
# Reihenfolge in der Liste haengt an der Sortierung - deshalb am Titel erkannt).
function Oeffnen([string] $Betreff) {
    $in, $lbIn = InListe
    $n = Anzahl $lbIn
    if ($n -lt 1) { Write-Host 'E178 FEHLER: In ist leer - die Vorbereitung hat nicht gegriffen'; exit 1 }
    for ($i = 0; $i -lt $n; $i++) {
        if ($i -gt 0) { $in, $lbIn = InListe }
        Waehle $lbIn $i
        [void][E178]::PostMessageA($lbIn, 0x0100, [IntPtr]0x0D, [IntPtr]0)    # WM_KEYDOWN VK_RETURN an die Liste (Botschaft an das Handle)
        [void][E178]::PostMessageA($lbIn, 0x0101, [IntPtr]0x0D, [IntPtr]0)
        Start-Sleep -Seconds 3
        $l = Aktiv $mdi
        if ($l -eq $in) { Write-Host 'E178 FEHLER: die Nachricht liess sich nicht oeffnen'; exit 1 }
        if ((Tx $l).Contains($Betreff)) { return $l }
        [void][E178]::PostMessageA($l, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)   # falsche Nachricht: schliessen
        Start-Sleep -Milliseconds 1000
    }
    Write-Host ("E178 FEHLER: keine Nachricht mit [{0}] in In" -f $Betreff); exit 1
}
function Anzeige($rahmen) {
    return (Kinder $rahmen | Where-Object { (Kl $_) -eq 'Internet Explorer_Server' -and [E178]::IsWindowVisible($_) } | Select-Object -First 1)
}

$EMOJI = [char]::ConvertFromUtf32(0x1F525)
$KYR   = [string][char]0x0416
# Zustand des Dokuments: Emoji und Kyrillisch noch da? Fragezeichen im Listenteil?
function Zustand($doc, [string] $name) {
    $html = [string](G (G $doc 'body') 'innerHTML')
    $e = [int]$html.Contains($EMOJI); $k = [int]$html.Contains($KYR)
    $i = $html.IndexOf('Vierbyte'); $j = $html.IndexOf('Euro')
    $teil = if ($i -ge 0 -and $j -gt $i) { $html.Substring($i, $j - $i) } elseif ($i -ge 0) { $html.Substring($i, [Math]::Min(200, $html.Length - $i)) } else { '' }
    $f = ([regex]::Matches($teil, '\?')).Count
    $aus = ($teil -replace "[`r`n]+", ' ')
    $aus = -join ($aus.ToCharArray() | ForEach-Object { if ([int]$_ -gt 126) { '\u{0:X4}' -f [int]$_ } else { $_ } })
    Write-Host ("E178 SCHRITT {0} emoji={1} kyr={2} frage={3} html={4}" -f $name, $e, $k, $f, $aus)
    return [pscustomobject]@{ Emoji=$e; Kyr=$k; Frage=$f; Urteil=$(if ($e -and $k -and $f -eq 0) { 'passt' } else { 'kaputt' }) }
}
# Auswahl: von "Vierbyte-Zeichen" bis einschliesslich des kyrillischen Zeichens.
# -NurEmoji: nur der Listenpunkt mit dem Emoji. Fuer den Link noetig - ueber
# zwei Listenpunkte hinweg oeffnet ID_EDIT_INSERT_LINK keinen Dialog
# (gemessen 02.11.2026, 11:12); das kyrillische Zeichen liegt dann ausserhalb
# der Auswahl und wird nur auf Erhalt geprueft.
function Auswahl($doc, [switch] $NurEmoji) {
    $r = C (G $doc 'body') 'createTextRange'
    if (-not (C $r 'findText' 'Vierbyte-Zeichen')) { Write-Host 'E178 Auswahl: Vierbyte-Zeichen nicht gefunden'; return $false }
    if ($NurEmoji) {
        $p = C $r 'parentElement'
        while ($p -and [string](G $p 'tagName') -ne 'LI') { $p = G $p 'parentElement' }
        if (-not $p) { Write-Host 'E178 Auswahl: kein Listenpunkt um das Emoji'; return $false }
        [void](C $r 'moveToElementText' $p)
        [void](C $r 'select')
        $t = [string](G $r 'text')
        $aus = -join ($t.ToCharArray() | ForEach-Object { if ([int]$_ -gt 126) { '\u{0:X4}' -f [int]$_ } elseif ([int]$_ -lt 32) { ' ' } else { $_ } })
        Write-Host ("E178 AUSWAHL [{0}]" -f $aus)
        return $true
    }
    $r2 = C (G $doc 'body') 'createTextRange'
    if (-not (C $r2 'findText' 'Kyrillisch: ')) { Write-Host 'E178 Auswahl: Kyrillisch nicht gefunden'; return $false }
    [void](C $r2 'moveEnd' 'character' 1)
    [void](C $r 'setEndPoint' 'EndToEnd' $r2)
    [void](C $r 'select')
    # document.selection ist ueber IDispatch nicht erreichbar (DISP_E_UNKNOWNNAME,
    # gemessen 02.11.2026) - der Text des ausgewaehlten Bereichs genuegt.
    $t = [string](G $r 'text')
    $aus = -join ($t.ToCharArray() | ForEach-Object { if ([int]$_ -gt 126) { '\u{0:X4}' -f [int]$_ } elseif ([int]$_ -lt 32) { ' ' } else { $_ } })
    Write-Host ("E178 AUSWAHL [{0}]" -f $aus)
    return $true
}
$URSPRUNG = $null
function Zuruecksetzen($doc) {
    $ul = C (C (G $doc 'all') 'tags' 'ul') 'item' 0
    if ($ul -and $URSPRUNG) { S $ul 'innerHTML' $URSPRUNG; Write-Host 'E178 Liste per DOM zurueckgesetzt (voriger Schritt war kaputt)' }
}

# --- Prozess und Hauptfenster --------------------------------------------
$proz = Get-Process Eudora -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -and $_.Path.StartsWith($Pfadfilter, 'OrdinalIgnoreCase') }
if (-not $proz) { Write-Host "E178 FEHLER: keine Eudora aus $Pfadfilter"; exit 1 }
$pp = $proz[0].Id
$haupt = AlleFenster $pp | Where-Object { $_.Klasse -eq 'EudoraMainWindow' -and $_.Vis } | Select-Object -First 1
if (-not $haupt) { Write-Host 'E178 FEHLER: kein Hauptfenster'; exit 1 }
$haupt = $haupt.H
$mdi = Kinder $haupt | Where-Object { (Kl $_) -eq 'MDIClient' } | Select-Object -First 1
Write-Host "E178 Prozess $pp Hauptfenster $haupt MDI $mdi"
[void](Dialoge $pp)

$erg = [ordered]@{ fett='-'; kursiv='-'; tt='-'; link='-'; gespeichert='-'; antwort='-' }
$mbx = Join-Path $md 'In.mbx'

# --- Nachricht oeffnen ----------------------------------------------------
$lesen = Oeffnen 'Pruefung E-136'
Write-Host ("E178 Nachrichtenfenster {0} [{1}]" -f $lesen, (Tx $lesen))
$ie = Anzeige $lesen
if (-not $ie) { Write-Host 'E178 FEHLER: keine Trident-Anzeige im Nachrichtenfenster'; exit 1 }
$doc = [E178]::Dokument($ie)
if (-not $doc) { Write-Host 'E178 FEHLER: WM_HTML_GETOBJECT lieferte kein Dokument'; exit 1 }
$ul = C (C (G $doc 'all') 'tags' 'ul') 'item' 0
$URSPRUNG = [string](G $ul 'innerHTML')
$z0 = Zustand $doc 'geoeffnet'
if ($z0.Urteil -ne 'passt') { Write-Host 'E178 FEHLER: schon die Anzeige traegt die Zeichen nicht - Pruefnachricht?'; exit 1 }

# --- Bearbeiten-Modus ------------------------------------------------------
# Der Knopf ID_EDIT_MESSAGE (32996) liegt auf der Leiste "Read Message"
# (OTShim SECCustomToolBar). Ein Klick per WM_LBUTTONDOWN/UP an die Leiste
# wirkt nicht (gemessen 02.11.2026: Klick auf die Mitte des Knopfs, die Leiste
# "Format" blieb unsichtbar) - OnLButtonDown setzt SetCapture, und ein Fenster
# im Hintergrund bekommt die Maus nicht (OnLButtonUp prueft GetCapture).
# Statt dessen dieselben zwei Schritte, die der Klick ausloest, als Botschaften
# an das Nachrichtenfenster: (1) die registrierte Botschaft
# "umsgButtonSetCheck" (CReadMessageFrame::OnButtonSetCheck) setzt
# TBBS_CHECKED am Knopf - den Stil liest GetCheck(ID_EDIT_MESSAGE);
# (2) WM_COMMAND ID_EDIT_MESSAGE (BN_CLICKED = 0) - CReadMessageFrame::
# OnCmdMsg ruft OnEditMode (Leiste "Format" an), die Anzeige
# CTridentReadMessageView::OnEditMode schaltet IDM_EDITMODE.
$umsgCheck = [E178]::RegisterWindowMessageW('umsgButtonSetCheck')
[void][E178]::SendMessageA($lesen, $umsgCheck, [IntPtr]32996, [IntPtr]1)
[void][E178]::SendMessageA($lesen, 0x0111, [IntPtr]32996, [IntPtr]::Zero)
Start-Sleep -Milliseconds 1500
$format = Kinder $lesen | Where-Object { (Tx $_) -eq 'Format' -and (Kl $_) -like 'Afx:*' } | Select-Object -First 1
$ie = Anzeige $lesen; $doc = [E178]::Dokument($ie)
$editierbar = [bool](G (G $doc 'body') 'isContentEditable')
Write-Host ("E178 Bearbeiten-Modus: format-leiste={0} editierbar={1}" -f [int]($format -and [E178]::IsWindowVisible($format)), [int]$editierbar)
if (-not $editierbar) {
    Write-Host 'E178 FEHLER: Bearbeiten-Modus nicht erreicht'
    Write-Host ("E178 ERGEBNIS fett=- kursiv=- tt=- link=- gespeichert=- antwort=- lebt={0}" -f [int](Lebt $pp))
    exit 1
}

# --- Der Link-Dialog von MSHTML (IDM_HYPERLINK mit Oberflaeche) --------------
# Ein HTML-Dialog (Klasse Internet Explorer_TridentDlgFrame). Er wird ueber
# sein eigenes Dokument gefuellt: Adresse ins Eingabefeld, OK per click().
function LinkDialog() {
    $dlg = $null
    for ($i = 0; $i -lt 40; $i++) {
        $dlg = AlleFenster $pp | Where-Object { $_.Oben -and $_.Vis -and $_.Klasse -eq 'Internet Explorer_TridentDlgFrame' } | Select-Object -First 1
        if ($dlg) { break }
        Start-Sleep -Milliseconds 250
    }
    if (-not $dlg) {
        Write-Host 'E178 LINK kein Dialog erschienen; sichtbare Fenster:'
        foreach ($f in (AlleFenster $pp | Where-Object { $_.Oben -and $_.Vis })) { Write-Host ("E178   {0} [{1}] [{2}]" -f $f.H, $f.Klasse, $f.Text) }
        [void](Dialoge $pp '(?!)'); return $false
    }
    Write-Host ("E178 LINK Dialog {0} [{1}]" -f $dlg.H, $dlg.Text)
    $die = Kinder $dlg.H | Where-Object { (Kl $_) -eq 'Internet Explorer_Server' } | Select-Object -First 1
    $dd = $null
    if ($die) { $dd = [E178]::Dokument($die) }
    if (-not $dd) { Write-Host 'E178 LINK Dialogdokument nicht erreichbar - Abbruch per WM_CLOSE'; [void][E178]::PostMessageA($dlg.H, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero); return $false }
    $url = $null; $ok = $null
    foreach ($tag in 'input', 'button') {
        $ein = C (G $dd 'all') 'tags' $tag
        $n = [int](G $ein 'length')
        for ($k = 0; $k -lt $n; $k++) {
            $e = C $ein 'item' $k
            $id = [string](G $e 'id'); $ty = [string](G $e 'type'); $va = [string](G $e 'value')
            Write-Host ("E178 LINK {0} id={1} type={2} value={3}" -f $tag, $id, $ty, $va)
            if ($tag -eq 'input' -and $ty -eq 'text' -and -not $url) { $url = $e }
            if (-not $ok -and ($id -match 'OK' -or $va -match '^\s*OK\s*$')) { $ok = $e }
        }
    }
    if (-not $url -or -not $ok) { Write-Host 'E178 LINK Feld oder OK nicht gefunden - Abbruch per WM_CLOSE'; [void][E178]::PostMessageA($dlg.H, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero); return $false }
    S $url 'value' 'http://e178.invalid/'
    [void](C $ok 'click')
    Start-Sleep -Milliseconds 1500
    return $true
}

# --- Formatierbefehle ---------------------------------------------------------
# Link VOR tt: nach WrapTag steht die Auswahl ueber <br>-Resten, und
# ID_EDIT_INSERT_LINK oeffnete dann keinen Dialog (gemessen 02.11.2026, 11:10);
# mit einfacher Auswahl erscheint er (Internet Explorer_TridentDlgFrame "Link",
# Felder txtURL/btnOK).
$schritte = @(
    @{ Name='fett';   Id=32882 },   # ID_EDIT_TEXT_BOLD  -> ExecCommand(IDM_BOLD)
    @{ Name='kursiv'; Id=32884 },   # ID_EDIT_TEXT_ITALIC -> ExecCommand(IDM_ITALIC)
    @{ Name='link';   Id=33012 },   # ID_EDIT_INSERT_LINK -> OnEditInsertLink -> ExpandTag
    @{ Name='tt';     Id=33004 }    # ID_EDIT_TEXT_TT -> OnBlkfmtFixedwidth -> WrapTag
)
$vorher = 'passt'
foreach ($s in $schritte) {
    if ($vorher -ne 'passt') { Zuruecksetzen $doc }
    if (-not (Auswahl $doc -NurEmoji:($s.Name -eq 'link'))) { Write-Host ("E178 {0}: keine Auswahl" -f $s.Name); continue }
    [void][E178]::PostMessageA($lesen, 0x0111, [IntPtr]$s.Id, [IntPtr]::Zero)
    Start-Sleep -Milliseconds 1500
    if ($s.Name -eq 'link') {
        if (-not (LinkDialog)) { Write-Host 'E178 link: Dialog nicht bedient, Schritt nicht gewertet'; continue }
    }
    [void](Dialoge $pp '(?!)')
    if (-not (Lebt $pp)) { Write-Host ("E178 {0}: Eudora lebt nicht mehr" -f $s.Name); break }
    $z = Zustand $doc $s.Name
    $erg[$s.Name] = $z.Urteil
    $vorher = $z.Urteil
}

# --- Speichern ----------------------------------------------------------------
$vorZeit = (Get-Item -LiteralPath $mbx).LastWriteTimeUtc
if (Lebt $pp) {
    [void][E178]::PostMessageA($lesen, 0x0111, [IntPtr]57603, [IntPtr]::Zero)    # ID_FILE_SAVE
    Start-Sleep -Seconds 2
    [void](Dialoge $pp)
    [void][E178]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)  # WM_CLOSE
    Start-Sleep -Milliseconds 1500
    for ($r = 0; $r -lt 3; $r++) { if ((Dialoge $pp '^(No|Nein|Don.t Save)$') -eq 0) { break }; Start-Sleep -Milliseconds 600 }
    Start-Sleep -Seconds 1
}
$geschrieben = (Get-Item -LiteralPath $mbx).LastWriteTimeUtc -ne $vorZeit
$t = [Text.Encoding]::GetEncoding(28591).GetString([IO.File]::ReadAllBytes($mbx))
# Gespeichert wird angehaengt; die alte Fassung bleibt bis zum Verdichten
# stehen. Gewertet wird deshalb die LETZTE Fassung.
$a = $t.LastIndexOf('Vierbyte'); $b = $t.LastIndexOf('Euro:')
$teil = if ($a -ge 0 -and $b -gt $a) { $t.Substring($a, $b - $a) } else { '' }
foreach ($zl in ($teil -split "`r?`n")) { if ($zl) { Write-Host ("E178 MBX {0}" -f $zl) } }
$vier = $teil.Contains('&#128293;') -or $teil.Contains(([string][char]0xF0) + [char]0x9F + [char]0x94 + [char]0xA5)
$kyr  = $teil.Contains('&#1046;') -or $teil.Contains(([string][char]0xD0) + [char]0x96)
$frage = ([regex]::Matches($teil, '\?')).Count
# E-199: Zeichenmuell "t;" (der Rest von "&gt;", den WrapTag/SplitTagOff
# abschnitten) - in der ganzen zuletzt gespeicherten Fassung, nicht nur im
# Abschnitt oben: am 02.11.2026 stand er als "<TT>t;Vierbyte" VOR dem
# Abschnitt und als "<LI>t; <BR>" dahinter. Gezaehlt wird "t;" ohne
# Buchstabe, Ziffer, "#" oder "&" davor - "&gt;", "&quot;" zaehlen nicht.
$letzte = $t.LastIndexOf('From ???@???')
$ganz = if ($letzte -ge 0) { $t.Substring($letzte) } else { $t }
$muell = ([regex]::Matches($ganz, '(?<![A-Za-z0-9#&])t;')).Count
foreach ($m in [regex]::Matches($ganz, '.{0,20}(?<![A-Za-z0-9#&])t;.{0,20}')) { Write-Host ("E178 MUELL {0}" -f ($m.Value -replace "`r?`n", ' ')) }
Write-Host ("E178 GESPEICHERT geschrieben={0} vierbyte={1} kyrillisch={2} fragezeichen={3} fassungen={4}" -f [int]$geschrieben, [int]$vier, [int]$kyr, $frage, ([regex]::Matches($t, 'Vierbyte')).Count)
Write-Host ("E178 MUELL anzahl={0}" -f $muell)
if ($geschrieben) { $erg.gespeichert = $(if ($vier -and $kyr -and $frage -eq 0 -and $muell -eq 0) { 'passt' } else { 'kaputt' }) }

# --- Antwort auf markierten Text ---------------------------------------------
# CReadMessageDoc -> CMessageDoc::GetSelectedText -> CTridentView::
# GetSelectedHTML (die neunte Stelle). Das Verfassen-Fenster wird gelesen:
# als Trident-Dokument, sonst nach Speichern aus Out.mbx.
if (Lebt $pp) {
    $lesen = Oeffnen 'E-178 Antwort'
    $ie = Anzeige $lesen; $doc = [E178]::Dokument($ie)
    if ($doc -and (Auswahl $doc)) {
        [void][E178]::PostMessageA($lesen, 0x0111, [IntPtr]32855, [IntPtr]::Zero)   # ID_MESSAGE_REPLY
        Start-Sleep -Seconds 3
        [void](Dialoge $pp '(?!)')
        $comp = Aktiv $mdi
        if ($comp -and $comp -ne $lesen) {
            Write-Host ("E178 ANTWORT Fenster {0} [{1}]" -f $comp, (Tx $comp))
            $cie = Anzeige $comp
            if ($cie) {
                $cd = [E178]::Dokument($cie)
                $erg.antwort = (Zustand $cd 'antwort').Urteil
            } else {
                $kl = (Kinder $comp | ForEach-Object { Kl $_ } | Sort-Object -Unique) -join ','
                Write-Host ("E178 ANTWORT keine Trident-Anzeige im Verfassen-Fenster, Klassen: {0}" -f $kl)
                $out = Join-Path $md 'Out.mbx'
                # Eine frische Antwort gilt als unveraendert; ID_FILE_SAVE schreibt dann
                # nichts (gemessen 02.11.2026, 11:12: Out.mbx blieb 0 Byte). Ein WM_CHAR
                # an das Betreff-Feld (Kennung 5052, gemessenes Handle) macht sie
                # speicherbar, ohne den Rumpf anzufassen.
                $betreff = Kinder $comp | Where-Object { (Kl $_) -eq 'Edit' -and [E178]::GetDlgCtrlID($_) -eq 5052 } | Select-Object -First 1
                if ($betreff) { [void][E178]::SendMessageA($betreff, 0x0102, [IntPtr]0x78, [IntPtr]1); Start-Sleep -Milliseconds 500 }   # WM_CHAR 'x'
                else { Write-Host 'E178 ANTWORT kein Betreff-Feld 5052' }
                [void][E178]::PostMessageA($comp, 0x0111, [IntPtr]57603, [IntPtr]::Zero)   # ID_FILE_SAVE
                Start-Sleep -Seconds 2
                [void](Dialoge $pp '(?!)')
                if (Test-Path -LiteralPath $out) {
                    $o = [Text.Encoding]::GetEncoding(28591).GetString([IO.File]::ReadAllBytes($out))
                    $a = $o.LastIndexOf('Vierbyte'); $b = if ($a -ge 0) { $o.IndexOf('Kyrillisch', $a) } else { -1 }
                    $oteil = if ($a -ge 0 -and $b -gt $a) { $o.Substring($a, [Math]::Min($o.Length - $a, $b - $a + 40)) } else { '' }
                    foreach ($zl in ($oteil -split "`r?`n")) { if ($zl) { Write-Host ("E178 OUT {0}" -f $zl) } }
                    $ov = $oteil.Contains('&#128293;') -or $oteil.Contains(([string][char]0xF0) + [char]0x9F + [char]0x94 + [char]0xA5)
                    $ok2 = $oteil.Contains('&#1046;') -or $oteil.Contains(([string][char]0xD0) + [char]0x96)
                    $of = ([regex]::Matches($oteil, '\?')).Count
                    Write-Host ("E178 ANTWORT out.mbx vierbyte={0} kyrillisch={1} fragezeichen={2}" -f [int]$ov, [int]$ok2, $of)
                    if ($oteil) { $erg.antwort = $(if ($ov -and $ok2 -and $of -eq 0) { 'passt' } else { 'kaputt' }) }
                } else { Write-Host 'E178 ANTWORT Out.mbx fehlt' }
            }
            [void][E178]::PostMessageA($comp, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
            Start-Sleep -Milliseconds 1500
            for ($r = 0; $r -lt 3; $r++) { if ((Dialoge $pp '^(No|Nein|Don.t Save)$') -eq 0) { break }; Start-Sleep -Milliseconds 600 }
        } else { Write-Host 'E178 ANTWORT kein Verfassen-Fenster erschienen' }
        [void][E178]::PostMessageA($lesen, 0x0010, [IntPtr]::Zero, [IntPtr]::Zero)
        Start-Sleep -Milliseconds 1000
    }
}

Write-Host ("E178 ERGEBNIS fett={0} kursiv={1} tt={2} link={3} gespeichert={4} antwort={5} lebt={6}" -f $erg.fett, $erg.kursiv, $erg.tt, $erg.link, $erg.gespeichert, $erg.antwort, [int](Lebt $pp))
