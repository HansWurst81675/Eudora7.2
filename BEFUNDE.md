# Befundbericht Korrektheitspruefung

**Geprueft am:** 2026-08-29
**Stand Teil 1:** `b4b7de5` bzw. Nachtrag `ba617a8` auf Branch `vs2022-portierung-fixes`
**Stand Teil 2 (Nachpruefung, unvollstaendig):** `8dd6b2a` - siehe letzter Abschnitt
(Durchsicht begann bei `fd9a235`; die waehrenddessen entstandenen Commits
`e4a0fae`, `75b60e1`, `b4b7de5` sind eingearbeitet.)
**Vergleichsbasis:** `git diff main...HEAD`
**Pruefer:** Agent PRUEFER (nur lesend; ausser dieser Datei wurde nichts geaendert)

## Was geprueft wurde

Korrektheitsfehler: Stellen, an denen sich das Verhalten gegenueber Eudora 7.1
ungewollt geaendert hat oder an denen der neue Code falsch ist. Schwerpunkt in
dieser Reihenfolge:

1. QCSSL (OpenSSL 0.9.7 -> 3.x): `QCSSLContext.cpp`, `qccertificate.cpp`,
   `certstore.cpp`, `SSLConnectionManager.cpp`
2. Die OT501-Ersatzschicht unter `Eudora71/OTShim/`
3. Die rund 90 Einzelkorrekturen an Eudoras eigenem Code (alle Hunks von
   `git diff main...HEAD --ignore-cr-at-eol` ueber `*.cpp`/`*.h` ausserhalb von
   `OpenSSL3/`, `MAPI/include/` und `Tests/` wurden gelesen)

## Was ausdruecklich nicht geprueft wurde

- **Die Hostnamenpruefung in QCSSL** (nur CN, keine SAN, rein beratend) -
  bekannt, belegt und vom Auftraggeber bewusst zurueckgestellt.
- Stil, Formatierung, Namensgebung.
- Die Dokumentation (`README.md`, `PORTIERUNG.md`) - dafuer ist LEKTOR
  zustaendig.
- `Eudora71/OpenSSL3/**` - fremder Quelltext, unveraendert uebernommen.
- `Eudora71/MAPI/include/*.h` - rund 25.000 Zeilen unveraenderte
  Microsoft-SDK-Header.
- `Eudora71/Tests/**` - das Pruefgeruest selbst (nicht der Prueflingscode).
- Die `.vcxproj`-Dateien (QCSSL, QCSocket, QCUtils; zusammen rund 1.200
  geaenderte Zeilen). Einzig `<Platform>Win32</Platform>` wurde nachgesehen,
  weil Befund N1 davon abhaengt.
- `Releases/1.0/QCSSL.dll` - Binaerdatei.
- Zeilenenden und Kodierung der beruehrten Dateien.
- Die Rumpfteile von `TBarBmpCombo.cpp`, `TBarStatic.cpp`, `TBarEdit.cpp`
  jenseits von Konstruktoren und Nachrichtentabellen.
- Es wurde nichts gebaut und nichts ausgefuehrt; alle Befunde stammen aus dem
  Quelltext.

---

# Befunde

## H1 - QCSSL: ungueltige Protokollversion bricht die Verbindung nicht mehr ab

**Sicherheit: nachgewiesen**

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp`, `SetSSLVersion()`,
`default:`-Zweig ab Z. 578, Wirkung ab Z. 585.

Vorher stand im `default:`-Zweig nur die Fehlermeldung; `sslmethod` blieb
`NULL`, und die Funktion endete mit `return SSL_CTX_new(sslmethod);`.
`SSL_CTX_new(NULL)` liefert `NULL`. `BeginQCSSLSession()` fing das ab:

```
SSL_CTX *pSSLCtx = SetSSLVersion(pSSLReference);
if (!pSSLCtx) { ASSERT(0); g_Mutex.Unlock(); return false; }
```

Jetzt steht der Aufruf ausserhalb des `switch`:

```
	default:
		... AddComments(CResString(IDS_ERR_VERSIONINVALID));
		break;
	}

	sslmethod = TLS_client_method();

	SSL_CTX	*pCtx = SSL_CTX_new(sslmethod);
```

**Folge:** Bei einem ungueltigen `m_ProtocolVersion` wird der Kommentar
"Version ungueltig" zwar noch in die ConnectionInfo geschrieben, die Verbindung
kommt aber trotzdem zustande - mit `iMinVersion = TLS1_2_VERSION`, weil die
Variable ihren Anfangswert behaelt. Aus "abbrechen" ist "stillschweigend
weitermachen" geworden. Der Fehlerfall oeffnet also, statt zu schliessen.

**Zu tun:** Im `default:`-Zweig `return NULL;` statt `break;` - oder eine
Merkervariable setzen und vor `SSL_CTX_new()` abfragen.

---

## H2 - Zeichentabelle: bereits behoben, Korrektur nachgeprueft

**Sicherheit: nachgewiesen (Befund und Behebung)**

**Datei:** `Eudora71/Eudora/utils.cpp`

Beide in `4c2f614` gemeldeten Fehler - sieben falsche Zuordnungen und die
Doppelersetzung durch das zeilenweise `CString::Replace()` - sind mit `b4b7de5`
behoben worden. Die Pruefung dieser Sitzung war unabhaengig zum selben Ergebnis
gekommen: Die Eingabe `C3 83 C2 A9` (U+00C3 gefolgt von U+00A9) haette
`C3 A9` ergeben muessen, wurde aber zu dem einen Byte `E9`, weil die Zeile
`C3 83 -> 0xC3` ein neues Fuehrungsbyte erzeugt, das die spaetere Zeile
`C3 A9 -> 0xE9` noch einmal frisst. Aus zwei Zeichen wurde eines.

Die Korrektur wurde nachgeprueft und ist richtig:

- Alle 27 CP1252-Zeilen wurden byteweise gegen CP1252.TXT geprueft. Alle 27
  stimmen jetzt (0x80..0x9F ohne 81, 8D, 8F, 90, 9D).
- Der Ersatz von `CString::Replace()` durch einen einzigen Links-nach-rechts-Lauf
  ist korrekt: `lWrite <= lRead` gilt in beiden Zweigen, das Schreiben in
  denselben Puffer ist damit gefahrlos; der Laengenlauf ueber `pFrom[iLen]`
  liefert 2 bzw. 3, wie es das Zeilenformat verlangt; `lRead + iLen > lSize`
  verhindert das Lesen ueber das Pufferende; "laengste Uebereinstimmung
  gewinnt" ist implementiert.

Kein Handlungsbedarf. Hier nur festgehalten, damit spaetere Pruefungen wissen,
dass die Stelle geprueft ist.

---

## M1 - QCSSL: aus "genau TLS 1.0" wurde "mindestens TLS 1.0, nach oben offen"

**Sicherheit: nachgewiesen (Code); Auswirkung: Verdacht**

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp`, `SetSSLVersion()`, Fall 3
(Z. 573-575) sowie `SSL_CTX_set_min_proto_version()` Z. 590.

`TLSv1_method()` war eine **versionsgenaue** Methode: Unter- *und* Obergrenze
TLS 1.0. Die Ersetzung setzt nur `SSL_CTX_set_min_proto_version(ctx,
TLS1_VERSION)` und laesst die Obergrenze offen.

Zwei Abweichungen auf einmal:

1. Fall 3 handelte frueher genau TLS 1.0 aus; jetzt kann bis TLS 1.3
   ausgehandelt werden. Das ist vermutlich gewuenscht, steht aber weder im
   Kommentar noch in `PORTIERUNG.md`.
2. Fall 3 setzt die Untergrenze auf TLS 1.0, waehrend alle anderen Faelle
   TLS 1.2 verlangen. Wer in den Einstellungen "TLSv1" gewaehlt hat, bekommt
   damit eine **schwaechere** Untergrenze als jeder andere. Praktisch faengt
   das die Voreinstellung Security Level 1 von OpenSSL 3 wieder ab, die TLS < 1.2
   ohnehin ablehnt - verlassen sollte man sich darauf nicht.

**Zu tun:** Entscheiden, ob Fall 3 heute noch etwas anderes bedeuten soll als
Fall 0/1/4/6/7. Wenn nicht: ebenfalls auf `TLS1_2_VERSION` legen. Wenn doch:
`SSL_CTX_set_max_proto_version()` mitsetzen und den Kommentar ergaenzen.

---

## M2 - QCSSL: `BIO_s_workersocket()` ist fuer sich genommen nicht threadsicher

**Sicherheit: nachgewiesen (Code); in der Praxis derzeit entschaerft**

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp` Z. 310-334.

```
static BIO_METHOD *s_pMethodsWS = NULL;

BIO_METHOD *BIO_s_workersocket()
{
	if (s_pMethodsWS == NULL)
	{
		s_pMethodsWS = BIO_meth_new(...);      // <-- zuerst zuweisen
		...
		BIO_meth_set_write(s_pMethodsWS, ws_write);   // <-- dann fuellen
		...
	}
	return s_pMethodsWS;
}
```

Vorher war das eine funktionslokale `static BIO_METHOD` mit konstantem
Initialisierer - statisch initialisiert, also von Haus aus threadsicher.
Jetzt gibt es zwei Rennen:

- Zwei Threads sehen beide `NULL`, beide rufen `BIO_meth_new()` auf; einer der
  beiden Bloecke bleibt fuer immer liegen (kleines Leck).
- Schlimmer: `s_pMethodsWS` wird **vor** den Settern zugewiesen. Ein zweiter
  Thread kann in genau diesem Fenster einen `BIO_METHOD` mit lauter
  Null-Zeigern bekommen. `BIO_new()` ruft dann `create == NULL` auf bzw. die
  spaeteren `read`/`write` laufen ins Leere.

**Warum es heute trotzdem haelt:** Der einzige Aufrufer ist `BIO_new_ws()`
(Z. 338), und der einzige Aufrufer davon ist `BeginQCSSLSession()` (Z. 789),
das seit Z. 745 unter `g_Mutex` laeuft. Solange das so bleibt, kann das Rennen
nicht auftreten.

**Zu tun:** In eine lokale Variable bauen und erst am Ende zuweisen - das
kostet nichts und macht die Funktion unabhaengig von `g_Mutex`.

---

## M3 - OTShim: `SetWorkbookMode()` setzt `m_bWorkbookMode` nicht

**Sicherheit: nachgewiesen**

**Datei:** `Eudora71/OTShim/OTShim.cpp`, `SECWorkbook::SetWorkbookMode()`
(Z. 1067-1081), zusammen mit `OnViewWorkbook()` (Z. 1156-1159) und
`OnUpdateViewWorkbook()` (Z. 1161-1165).

Der Setzer meldet den nicht umgesetzten Fall und ruft
`m_pWBClient->SetMargins(0,0,0,0)` - er weist `m_bWorkbookMode` aber nie zu.
Der Wert bleibt fuer die gesamte Laufzeit auf dem `FALSE` aus dem Konstruktor.

**Folge:** `OnViewWorkbook()` ruft immer `SetWorkbookMode(TRUE)`, nie
`SetWorkbookMode(FALSE)`; `OnUpdateViewWorkbook()` zeigt den Haken nie an. Der
Menuepunkt reagiert also aus Sicht des Anwenders gar nicht - und da die
Hinweismeldung ueber eine `static`-Merkervariable nur einmal je Sitzung kommt,
passiert ab dem zweiten Klick sichtbar nichts.

Das kann Absicht sein ("der Modus gibt es nicht, also bleibt er aus"), steht so
aber nirgends. Falls Absicht: als Kommentar hinschreiben. Falls nicht:
`m_bWorkbookMode = bEnabled;` ergaenzen.

---

## M4 - `QCWorkerSocket`: Empfangsrichtung liest die Sendeeinstellung

**Sicherheit: nachgewiesen. Nicht aus der Portierung - Originalfehler.**

**Datei:** `Eudora71/QCSocket/src/QCWorkerSocket.cpp:2084`

```
else   // Empfang, Standardport
{
	m_pSSLReference->m_ProtocolInfo.m_ProtocolVersion = pSettings->m_nSSLSendVersion;
}
```

Jede andere Zeile in diesem `else`-Block liest `m_nSSLReceive...`; nur diese
eine liest `m_nSSLSendVersion`. `m_nSSLReceiveVersion` existiert und wird in
`SSLSettings.cpp:75` aus `IDS_INI_SSL_RECEIVE_VERSION` geladen - es wird nur
nirgends benutzt.

**Folge:** Die Protokollversion fuer POP/IMAP kommt aus der SMTP-Einstellung.
Bisher war das folgenlos, weil alle Faelle auf `SSLv23_method()` hinausliefen.
**Seit der Portierung steuert dieser Wert die TLS-Untergrenze** (siehe M1), die
Verwechslung wird also erstmals wirksam.

Die Datei ist von der Portierung nur an einer Stelle beruehrt worden
(`<xstddef>` -> `<functional>`); der Fehler ist Originalcode von QUALCOMM.

**Zu tun:** `m_nSSLReceiveVersion` einsetzen - aber getrennt vom Portierungs-
umbau, weil es eine echte Verhaltensaenderung ist.

---

## M5 - `CSumList::GetTail()` liefert den Kopf

**Sicherheit: nachgewiesen. Nicht aus der Portierung - Originalfehler,
in die neue const-Ueberladung uebernommen.**

**Datei:** `Eudora71/Eudora/summary.h` Z. 504 und Z. 507

```
CSummary*&      GetTail()       { return reinterpret_cast<CSummary *&>( m_ObList.GetHead() ); }
const CSummary* GetTail() const { return reinterpret_cast<const CSummary *>( m_ObList.GetHead() ); }
```

Beide `GetTail()` rufen `m_ObList.GetHead()` auf. In `main` steht dasselbe; die
Portierung hat den Fehler beim Umbau der const-Ueberladung mitgenommen, statt
ihn zu bemerken.

**Folge:** Jeder Aufrufer von `GetTail()` bekommt das erste statt des letzten
Elements. Wie oft das zutraegt, haengt an den Aufrufstellen - die wurden im
Rahmen dieser Pruefung nicht durchgezaehlt.

**Zu tun:** `GetTailPosition()`/`m_ObList.GetTail()` verwenden. Vorher pruefen,
ob sich Code auf das falsche Verhalten stuetzt.

---

## N1 - QCSSL: der Zeigerschmuggel durch `BIO_set_fd` haelt nur unter Win32

**Sicherheit: nachgewiesen. Heute kein Fehler.**

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp` Z. 249 (setzen), Z. 148 und
Z. 196 (lesen), Z. 259 (zurueckgeben), Z. 789 (Aufrufer).

Eudora reicht einen `QCSSLReference*` als `int` durch `BIO_set_fd()`:

```
BIO *pBIO = BIO_new_ws((int)pSSLReference, BIO_NOCLOSE);
```

`BIO_set_fd` ist `BIO_int_ctrl(b, BIO_C_SET_FD, c, fd)`, und `BIO_int_ctrl`
reicht die Adresse eines lokalen `int` weiter. Der Umbau legt den Wert nun im
Datenslot ab:

```
BIO_set_data(pBIO, (void*)(INT_PTR)(*((int*)ptr)));
```

Setzen und Lesen sind **konsistent**: `ws_read` und `ws_write` holen den Zeiger
mit `BIO_get_data()`, `BIO_C_GET_FD` gibt ihn ueber denselben Weg zurueck. Ein
Zeiger wird dabei **nicht** beschaedigt, weil `QCSSL.vcxproj` ausschliesslich
`<Platform>Win32</Platform>` kennt - `int` und Zeiger sind beide 32 Bit.

Sobald QCSSL einmal fuer x64 gebaut wird, schneidet `*((int*)ptr)` die oberen
32 Bit des Zeigers ab, und zwar lautlos. Der Weg ueber `BIO_int_ctrl` kann das
nicht heilen; dafuer muesste `BIO_new_ws` den Zeiger direkt per `BIO_set_data`
ablegen und `BIO_C_SET_FD` gar nicht mehr benutzen.

**Zu tun:** Nichts, solange Win32 gilt. Als Sperre fuer eine spaetere
x64-Portierung vormerken.

---

## N2 - `plist_mgr.cpp`: `static` bei `get_entry_info` verlorengegangen

**Sicherheit: nachgewiesen**

**Datei:** `Eudora71/PlaylistClient/plstclnt_dll/plist_mgr.cpp:176`

```
- static get_entry_info( PrivCachePtr pcp, Entry* pe, ENTRY_INFO** pei );
+ int get_entry_info( PrivCachePtr pcp, Entry* pe, ENTRY_INFO** pei );
```

Die Definition in Z. 1571 lautet in beiden Fassungen `int get_entry_info(...)`
ohne Speicherklasse. In C++ uebernimmt eine Definition ohne Speicherklasse die
Bindung der vorangegangenen Deklaration - vorher also **interne** Bindung,
jetzt **externe**.

**Folge:** Der Name wird zu einem globalen Symbol der DLL. Heute kollidiert
nichts (es baut), aber eine spaetere Uebersetzungseinheit mit gleichem Namen
gaebe LNK2005 oder - schlimmer - eine stille Fehlbindung. Zur Behebung des
Uebersetzungsfehlers (fehlender Rueckgabetyp) war das Entfernen von `static`
nicht noetig.

**Zu tun:** `static int get_entry_info(...)` schreiben.

---

## N3 - QCSSL: zwei Rueckgabewerte werden nicht mehr ausgewertet

**Sicherheit: nachgewiesen; geringe Auswirkung**

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp`

- Z. 590: `SSL_CTX_set_min_proto_version()` liefert 0 bei Fehlschlag. Der Wert
  wird verworfen. Scheitert der Aufruf, gilt die Voreinstellung von OpenSSL -
  die Untergrenze aus den Einstellungen greift dann nicht.
- Z. 534: `SetCipherSuites()` gibt jetzt `1` zurueck, ohne etwas gesetzt zu
  haben. Der Rueckgabewert wurde allerdings auch vorher schon von
  `BeginQCSSLSession()` verworfen, insofern keine Aenderung im Ablauf.

**Zu tun:** Beim ersten Punkt den Rueckgabewert pruefen und im Fehlerfall wie
in H1 abbrechen.

---

## N4 - `ExceptionHandler.cpp`: `#undef` auf einen SDK-Waechter

**Sicherheit: nachgewiesen; heute wirkungslos, aber zerbrechlich**

**Datei:** `Eudora71/Eudora/ExceptionHandler.cpp` Z. 18-32

```
#undef _MINIDUMP_H
#include "MiniDump.h"
```

`EuMemMgr/Include/MiniDump.h:27` benutzt denselben Waechternamen wie
`minidumpapiset.h` aus dem Windows SDK. Der `#undef` macht den fremden Header
wieder einbindbar - danach setzt `MiniDump.h` `_MINIDUMP_H` erneut.

**Folge:** In dieser Uebersetzungseinheit ist `minidumpapiset.h` ab hier
gesperrt. Das faellt heute nicht auf, weil `stdafx.h` es vorher schon
hereingezogen hat. Kehrt sich die Einbindungsreihenfolge irgendwann um, fehlen
die SDK-Typen ohne verstaendliche Fehlermeldung.

**Zu tun:** Nichts Dringendes. Falls jemand daran vorbeikommt: den Waechter von
`EuMemMgr/Include/MiniDump.h` umbenennen (z. B. `_EUMEMMGR_MINIDUMP_H`) und den
`#undef` entfernen.

---

## N5 - `atlimage.h`: Laufzeitpruefung durch `TRUE` ersetzt

**Sicherheit: nachgewiesen; Ergebnis sachlich richtig**

**Datei:** `Eudora71/Eudora/atlimage.h:1541`

```
- return( _AtlBaseModule.m_bNT5orWin98 );
+ return( TRUE );
```

`CImage::IsTransparencySupported()` liefert jetzt ohne Pruefung `TRUE`. Auf dem
Zielsystem (Windows 10) ist das korrekt. Bemerkenswert ist nur, dass dafuer
eine **mitgelieferte Kopie eines Microsoft-ATL-Headers** geaendert wurde -
solche Aenderungen gehen bei einem Wechsel auf den SDK-eigenen Header
verloren.

**Zu tun:** In `PORTIERUNG.md` als bewusste Abweichung fuehren, falls noch
nicht geschehen.

---

## N6 - OTShim ist in keinem Projekt

> **Ueberholt seit `7dcac81`** (nachgetragen von LEKTOR, gemessen an `e7e6f3c`).
> `Eudora/stdafx.h:52` zieht jetzt `OTShimAll.h` statt `secall.h`, und
> `Eudora.vcxproj:217` uebersetzt `OTShim.cpp`, `OTShim_Bild.cpp` und
> `..\OT501\Src\secaux.cpp` mit. Der Befund gilt aber unveraendert fuer die
> **drei nicht eingehaengten** Teile: `OTShim_Werkzeugleiste.*` (6083 Zeilen),
> `OTShim_Reiter.*` (2925) und `OTShim_Palette.*` (890) stehen weder in
> `OTShimAll.h` noch in einer `.vcxproj` - siehe Befund NP2-1.

**Sicherheit: nachgewiesen. Kein Fehler, sondern eine Standortbestimmung.**

`Eudora71/OTShim/` wird ausserhalb des eigenen Verzeichnisses nur von
`README.md` und `PORTIERUNG.md` erwaehnt. Keine `.vcxproj`, keine `.sln`, kein
Skript bindet `OTShim.cpp` ein; `Eudora/stdafx.h:52` zieht weiterhin
`secall.h` aus `OT501/Include`.

Zusaetzlich: `OTShim.h` deklariert `SECControlBar` und `SECGripperInfo`
vollstaendig, aber `OTShim.cpp` implementiert davon **keine einzige Methode**.
Und `TBarEdit.cpp`, `TBarBmpCombo.cpp`, `TBarStatic.cpp` rufen
`SECWndBtn::AdjustSize()`, `SECWndBtn::LButtonDown()` usw. auf, fuer die es in
`OT501` nur Header gibt.

"Nie gelaufen, nur uebersetzt" ist damit genau richtig - genauer: es
uebersetzt, es bindet nicht, und im Build steckt es noch gar nicht.

---

## N7 - OTShim: zwei kleinere Stellen

**Sicherheit: Verdacht; beide heute wirkungslos**

**Datei:** `Eudora71/OTShim/OTShim.cpp`

- **`SECWorkbook::GetTabRgn()` (Z. 1003-1012)** greift fest auf `pts[0]` und
  `pts[4]` zu, waehrend `count` aus der virtuellen `GetTabPts()` stammt. Die
  Basisfassung liefert 6 Punkte, das passt. Eine abgeleitete Fassung mit
  weniger als 5 Punkten liest ueber das Feldende hinaus.
- **`SECWorkbookClient::CalcWindowRect()` (Z. 713-727)** zieht die Raender vom
  Ergebnis von `CWnd::CalcWindowRect()` ab. `CalcWindowRect` rechnet ein
  **Client**- in ein **Fenster**rechteck um (es vergroessert); die Raender
  danach abzuziehen verkleinert das Fensterrechteck, statt die Client-Flaeche
  zu verkleinern. Fuer den Zweck "Platz fuer die Registerleiste freihalten"
  sieht das nach der falschen Richtung aus. Wirkungslos, solange die Raender
  ueberall 0 sind - und `SetWorkbookMode()` setzt sie ausdruecklich auf 0.

---

## N8 - `const_cast` mit anschliessendem Schreibzugriff

**Sicherheit: nachgewiesen (das Muster); Bewertung: originalgetreu**

Zehn der rund 50 `const_cast`-Korrekturen liegen an Stellen, an denen der
zurueckgewonnene Zeiger anschliessend **beschrieben** wird - und zwar in einen
Puffer, der ueber einen `const char*`/`LPCTSTR`-Parameter hereinkam:

| Datei | Zeile | Schreibzugriff |
|---|---|---|
| `Eudora/Trnslate.cpp` | 4191 | `*space = 0; *(space-1) = 0;` auf `const char *inFileCmd` |
| `Eudora/mainfrm.cpp` | 4848 | `*c++ = 0;` auf `LPCTSTR cmdLine` |
| `Eudora/TridentPreviewView.cpp` | 350 | `*EndOfHeader = 0;` |
| `Eudora/mapicmc.cpp` | 171 | `*pszNewline = '\0';` |
| `Eudora/sendmail.cpp` | 1537 | `*pEnd = '\0';` |
| `Eudora/statbar.cpp` | 233 | Puffer wird umgeschrieben |
| `Eudora/tocdoc.cpp` | 2169 | vorlaeufige NUL-Terminierung |
| `Eudora/Convhtml.cpp` | 489, 570 | Kopfzeilen werden zerschnitten |
| `Eudora/PaigeEdtView.cpp` | 2521 | `*s = 0;` |
| `Eudora/html2text.cpp` | 981 | `szCurrent + 1` ohne NULL-Pruefung |

**Das ist kein Rueckschritt.** Vor VS2005 hatte `strchr`/`strstr`/`strrchr` in
`<string.h>` nur die C-Signatur `char* f(const char*, ...)`; der Schreibzugriff
fand also schon vorher statt. Der `const_cast` macht das nur sichtbar.

Trotzdem festgehalten, weil das die Stellen sind, an denen ein spaeterer
Umbau - etwa ein Aufrufer, der eine Zeichenkettenkonstante oder einen
`CString`-Puffer ohne `GetBuffer()` uebergibt - einen Absturz erzeugt, den
niemand mehr mit der Portierung in Verbindung bringt.

**Zu tun:** Nichts jetzt. Bei kuenftigen Aenderungen an diesen Funktionen die
Parameter auf `char*` ziehen und die Aufrufer nachziehen.

---

# Geprueft und in Ordnung

Diese Bereiche wurden Zeile fuer Zeile durchgesehen und sind unauffaellig.
Spaetere Pruefungen muessen hier nicht noch einmal anfangen.

## QCSSL

- **BIO-Schicht, Zustandsfelder.** `ws_new`/`ws_free` bilden `init`, `flags`
  und `shutdown` richtig ueber die Zugriffsfunktionen ab.
  `BIO_clear_flags(pBIO, ~0)` entspricht `pBIO->flags = 0`. Das im Original
  fehlende `BIO_set_shutdown(pBIO, 0)` in `ws_new` ist sogar **noetig**:
  `BIO_new()` setzt in OpenSSL 3 `shutdown = 1` vor, bevor es `create` ruft.
  Der Endzustand nach `BIO_new_ws(..., BIO_NOCLOSE)` ist in beiden Fassungen
  derselbe.
- **Datenslot-Rundlauf** setzen/lesen/zurueckgeben - konsistent (Einzelheiten
  unter N1).
- **`qccertificate.cpp`.** `X509_STORE_CTX_get0_store(ctx)` liefert dasselbe
  Objekt wie frueher `pX509StoreCtx->ctx`; `X509_STORE_CTX_get_current_cert()`
  und `X509_STORE_CTX_get_error()` sind wortgleiche Ersetzungen. Die
  Zusatzdaten werden in `BeginQCSSLSession()` auf dem `X509_STORE` des
  `SSL_CTX` abgelegt und im Rueckruf von demselben Objekt gelesen. Die
  Indizes 0 und 1 ohne `X509_STORE_get_ex_new_index()` funktionieren unter
  OpenSSL 3 (`CRYPTO_set_ex_data` legt den Stapel bei Bedarf an), und die
  Klasse `X509_STORE` wird von libssl selbst nicht mit Zusatzdaten belegt.
- **`certstore.cpp`.** Einzige Aenderung ist die `const`-Anpassung an
  `d2i_X509()`. Die Funktion schreibt weiterhin durch den Zeiger-auf-Zeiger,
  der Zeiger selbst ist nicht `const` - richtig.
- **Cipher-Liste entfernt.** Die Begruendung stimmt: die Liste von 2006
  enthaelt kein einziges AEAD-Verfahren; unter OpenSSL 3 haette sie den
  Handshake mit heutigen Servern verhindert statt abgesichert.
- **`ERR_remove_state()` gestrichen** - in OpenSSL 1.1+ ersatzlos entfallen,
  die Bibliothek raeumt selbst auf.
- **`SSLConnectionManager.cpp`.** Der `const_cast` bei `strchr(uniquename,'\n')`
  wird nur gelesen (`++strProtocol`, `strcmp`).

## OpenSSL-3-Umstellung, uebrige Stellen

- `d2i_X509`, `SSL_get_current_cipher`, `SSL_METHOD` als `const` - reine
  Signaturanpassungen ohne Verhaltensfolge.

## `summary.h`, const-Ueberladungen

Der Wechsel von `const CSummary*&` auf `const CSummary*` ist **eine Behebung,
kein Rueckschritt**. `CObList::GetHead() const` liefert `CObject*` **als Wert**;
das alte `reinterpret_cast<const CSummary*&>(...)` band also eine Referenz an
ein temporaeres Objekt. Die Ueberladungen kaemen ausserdem nur ueber einen
Uebersetzungsfehler zum Vorschein, wenn ein Aufrufer das Ergebnis wirklich als
Referenz binden wollte - das tut keiner. (Der eigentliche Fehler an dieser
Stelle ist M5.)

## Schleifenzaehler, die vorgezogen wurden

Alle fuenf geprueft, alle mit **unveraendertem Anfangswert** und ohne
Ueberschreiben eines aeusseren Zaehlers:

- `QCUtils/src/jjfile.cpp:819` `ReadLine_` - `lNumRead` wird nach der Schleife
  in mehreren `return`-Zweigen gebraucht.
- `QCUtils/src/services.cpp:635` `TrimWhitespaceMT` - `pszEnd` wird nach der
  Schleife gebraucht.
- `PlaylistClient/.../plist_html.cpp:207` `ParseURLs` - `nSearch` wird nach der
  Schleife abgefragt.
- `Importers/OEImport/OEImportClass.cpp:2222` `ReadTilDone` - `oemh` wird nach
  der Schleife gebraucht.
- `EuImap/src/ImapFiltersd.cpp:1602` und `:1712` - hier wurde umgekehrt ein
  `int i` **hinzugefuegt**. Beide Schleifen liegen **ausserhalb** der
  vorangehenden `for (int i = 0; i < NUM_FILT_ACTS; i++)`-Schleife (Nachpruefung
  ueber die Einrueckungsebenen), der aeussere Zaehler ist zu diesem Zeitpunkt
  tot. Kein Verhaltensunterschied.

## Rueckgabetypen, die von "implizit int" auf einen Typ gesetzt wurden

Alle geprueft, jeweils gegen die Aufrufstellen:

- `Eudora/DynamicMenu.h:52` + `.cpp:81` `OnInitMenuPopup` -> `void`. Alle drei
  Aufrufstellen (`mainfrm.cpp:7012`, `guiutils.cpp:3055`, `:3158`) verwerfen
  das Ergebnis.
- `Eudora/DynamicPersonalityMenu.cpp`, `DynamicPluginMenu.cpp`,
  `DynamicRecipientMenu.cpp`, `DynamicStationeryMenu.cpp` `BuildMenu` -> `BOOL`.
  Die Basis deklariert bereits `virtual BOOL BuildMenu(...) = 0`; alle Ruempfe
  enthalten `return TRUE;`. `CDynamicMenu::OnInitMenuPopup` wertet den Wert aus
  und bekommt jetzt denselben wie vorher.
- `Eudora/trnslate.h` `GetIcon`, `IsInYerFace`, `LoadModule` -> `BOOL`;
  `Eudora/spell.h` `Check`, `ReallyCheck` -> `int`; `Eudora/UsgStatsView.h`
  `UpdateFT` -> `void` (leerer Rumpf, kein Aufrufer wertet aus);
  `EuLang/src/lang_info.cpp` `friend` -> `int`; `QCUtils/inc/services.h`
  `operator=` -> `CSortedStringListMT&`; `Imapdll/src/misc.cpp` `register bitno`
  -> `int`; `PlaylistClient` `typedef (*adproc)` -> `int (*adproc)` in allen
  drei Dateien einheitlich.
- `Eudora/ComboBoxEnhanced.cpp:51-53`, `Eudora/eudora.cpp:4625` und `:4745`,
  `Eudora/FileBrowseView.cpp:285`, `Eudora/ExtLaunchMgr.cpp:37`,
  `Importers/OEImport/OEImportClass.cpp:1297` - Konstanten und `static`-Merker
  bekommen einen Typ. `FolderLen` wird von `int` zu `size_t`; die drei
  Verwendungen (`_tcsnicmp`, Feldindex, Zeigeraddition) kennen kein
  Vorzeichenproblem.
- `Eudora/AboutDlg.h`, `Eudora/mainfrm.h` `OnNcHitTest` `UINT` -> `LRESULT` -
  von `ON_WM_NCHITTEST` im heutigen MFC so verlangt.

## `FileBrowseView::GetFullyQualPidlFromPath`

Die Korrektur ist richtig. Alt wurde `sizeof(szOleChar)` (520) als
`cchWideChar` fuer einen Puffer von 260 `WCHAR` uebergeben - `MultiByteToWideChar`
haette bis zu 520 Zeichen geschrieben. Neu steht dort `_countof(szOleChar)`,
und der zusaetzliche `if (iWideChars == 0) return NULL;` fuellt genau die
Luecke, die der frueher verworfene Rueckgabewert offenliess. Die Funktion haelt
zu diesem Zeitpunkt keine Ressource, die freigegeben werden muesste.

## Zeit- und Typkorrekturen

- `Eudora/MsgRecord.cpp:425` `long` -> `time_t` mit `(unsigned long)`-Rueckwandlung
  beim Ablegen in `m_ulDate` - dieselbe Reichweite wie bisher.
- `Eudora/StatMng.cpp:1273`, `:1578`, `:1816` - `localtime()` bekommt eine
  `time_t`-Kopie des 32-bittigen Feldes aus der Statistikdatei. Das Dateiformat
  bleibt unangetastet.
- `QCUtils/src/services.cpp:209` dasselbe Muster.
- `QCUtils/src/services.cpp:1079` `WORD wsz[MAX_PATH]` -> `WCHAR` - beide 16 Bit
  ohne Vorzeichen, gleiche Groesse.
- `Imapdll/src/osdep.cpp:200` `tzname`/`daylight` -> `_tzname`/`_daylight` -
  in der Microsoft-CRT dieselben Objekte, `_daylight` heisst wie zuvor "eine
  Sommerzeitregel ist eingestellt", nicht "Sommerzeit gilt gerade".

## `EuImap/src/searchutil.{h,cpp}`

Der Ersatz von `m_Iterator == NULL` durch das eigene Kennzeichen
`m_bIteratorValid` ist richtig: Ein `std::list::iterator` liess sich frueher
nur wegen einer nicht normgerechten Ueberladung mit `NULL` vergleichen. Beide
Auswertungen (`GetNextCriterion`, `HasNext`) fragen das Kennzeichen **vor** dem
Vergleich mit `end()` ab, ein einzelner Iterator wird also nie angefasst.
Konstruktor und `Initialize()` setzen es vollstaendig.

## `Imapdll/src/krbv4.cpp`

Die Umbenennung `ntohl`/`ntohs`/`htonl`/`htons` -> `krbv4_*` aendert nichts an
der Rechnung (dieselben Byte-Vertauschungen, `htonl` ruft weiterhin `ntohl`).
Alle Aufrufstellen wurden mitgezogen. Ausserhalb der Datei gibt es keine
Verwendung; ein Zusammenstoss mit `ws2_32` bestand ohnehin nicht, weil die
Winsock-Fassungen `__stdcall` sind und damit anders heissen.

## `Eudora/spell.cpp` (neu, Ersatzimplementierung)

Der Konstruktor initialisiert **alle** in `spell.h` deklarierten Felder,
einschliesslich `m_bJustQueue`, das von aussen gelesen wird
(`headervw.cpp:2961`, `compmsgd.cpp:806`). Die Begruendung fuer `0` als
Rueckgabewert von `Check()` (statt `NO_MISSPELLINGS` oder `IDCANCEL`) ist an
den Aufrufstellen belegt und stimmt.

## `Eudora/ConConMessage.cpp`, `Eudora/mime.cpp`

Die `memchr`-Ergebnisse werden nach dem `const_cast` sofort wieder an einen
`const char*` zugewiesen bzw. nur gelesen. Kein Schreibzugriff.

## `<xstddef>` -> `<functional>`

Elf Dateien; in allen ist der Header nur ein Vorspann fuer ein direkt darauf
folgendes `<map>`/`<list>`/`<algorithm>`/`<stack>`. Ohne Wirkung auf den Ablauf.

## OTShim, uebriger Teil

Konstruktoren von `SECMDIFrameWnd`, `SECMDIChildWnd`, `SECWorksheet`,
`SECWorkbookClient`, `SECWorkbook`, `SECTipOfDay`, `SECControlBarWorksheet`
setzen jeweils alle eigenen Skalarfelder. Alle Eintraege der
Nachrichtentabellen (`SECWorksheet`, `SECWorkbook`, `SECControlBarWorksheet`)
haben eine passende Behandlungsroutine mit passender Signatur; keiner zeigt
ins Leere. Die ueberschriebenen Methoden rufen die Basis auf, wo es das
Original verlangt - `SECWorkbook::OnDestroy()` raeumt vor
`SECMDIFrameWnd::OnDestroy()` auf, `SECWorksheet::LoadFrame()` prueft das
Ergebnis der Basis, bevor es weitermacht. Die doppelte Freigabe von
`m_pWBClient` (Destruktor **und** `OnDestroy`) ist ueber die NULL-Pruefung
abgefangen.

---

# Nachtrag: Stand nach `ba617a8`

Waehrend die Pruefung lief, haben andere Agenten weitergearbeitet. Gegen
`ba617a8` nachgesehen:

- **M3 ist ueberholt.** `OTShim.cpp:1104` haelt inzwischen ausdruecklich fest
  "Bewusst keine Zuweisung an `m_bWorkbookMode`", `OTShim.h:970` nennt es eine
  Grundentscheidung. Damit ist genau die Luecke geschlossen, die der Befund
  bemaengelt hat: es war Absicht, sie stand nur nirgends. Kein Handlungsbedarf
  mehr.
- **N6 gilt weiter.** Auch nach `e81adb0` ("Stufe 4: Bildklassen ueber GDI+")
  taucht `OTShim` in keiner `.vcxproj` auf.
- **H1, M1, M2, M4, M5 und N1 bis N5, N7, N8 gelten unveraendert.**
  `SetSSLVersion()` steht in `ba617a8` Zeile fuer Zeile so da wie beschrieben.
- Nicht als Befund aufgenommen, weil waehrend der Pruefung behoben:
  `X509_STORE_CTX_set_ex_data(pX509StoreCtx, 0, ...)` in
  `qccertificate.cpp` schrieb in einen Slot, den libssl fuer sich beansprucht
  (`SSL_get_ex_data_X509_STORE_CTX_idx()` liefert dort ueblicherweise 0). Das
  war Originalcode und ist mit `455294c` entfernt worden.

---

# Zusammenfassung

- 1 Befund hoher Schwere (H1) - eine echte Regression aus der Portierung.
- 5 Befunde mittlerer Schwere; davon zwei (M4, M5) **Originalfehler**, die die
  Portierung nicht verursacht, aber auch nicht bemerkt hat.
- 8 Befunde niedriger Schwere, ueberwiegend vorsorglicher Natur.
- H2 (Zeichentabelle) war bei Pruefungsbeginn offen und ist waehrend der
  Pruefung mit `b4b7de5` behoben worden; die Behebung wurde nachgeprueft und
  ist richtig.

Der QCSSL-Umbau ist insgesamt sauber. Die Abbildung der undurchsichtigen
OpenSSL-3-Strukturen auf Zugriffsfunktionen stimmt an allen geprueften
Stellen; der Zeigerschmuggel durch die BIO-Schicht ist konsistent. Die
einzige echte Regression liegt nicht in der API-Umstellung, sondern in der
umgebauten Ablaufsteuerung von `SetSSLVersion()`.

---

# Nachpruefung 2 (Bereich `ba617a8..8dd6b2a`) - ABGEBROCHEN, UNVOLLSTAENDIG

**Bezugscommit des neuen Teils:** `8dd6b2a` auf `vs2022-portierung-fixes`
**Vergleichsbasis:** `git diff ba617a8..HEAD`
**Abgebrochen am:** 2026-08-29, wegen Herunterfahren des Rechners.

Alles oberhalb dieser Linie bezieht sich unveraendert auf den alten Stand
`ba617a8` und ist abgeschlossen. Alles ab hier ist **Zwischenstand**.

## Zu pruefender Bereich

```
8dd6b2a Lehren werden jetzt automatisch ins Repo gespiegelt
adcede6 Arbeitsweise/: die Lehren aus dem Projekt liegen jetzt im Repo
7d94c3d PLAN.md berichtigt: Registerkarten sind nicht verzichtbar
91716bb OT501-Ersatzschicht Stufe 3: Werkzeugleisten und Knoepfe
94e32c6 QCSSL bekommt eine ablesbare Kennung
dd65c33 OTShim Stufe 2b: der Rest der Andockfamilie
7dcac81 OT501-Ersatzschicht in Eudora eingehaengt
1a0c343 Zertifikatspruefung: Verschaerfung als Patch bereitgelegt
a7478b0 OTShim Stufe 2: Andockfamilie
bc94cf0 MAPI: kein Schreibzugriff mehr in den fremden WM_COPYDATA-Puffer
f42466b Eudora: SafeSEH und doppeltes Manifest
```

Rund 11.200 eingefuegte Zeilen, davon 6.083 allein in
`OTShim_Werkzeugleiste.{h,cpp}`.

## Erledigt: geprueft und in Ordnung

- **`QCSSLContext.cpp`, Behebung von H1** (`7d94c3d`-Reihe): `break;` wurde
  durch `return NULL;` ersetzt. Das stellt das alte Verhalten **wirklich
  wieder her** und verschiebt es nicht: `SetSSLVersion()` liefert wie frueher
  `NULL`, und `BeginQCSSLSession()` faengt das in Z. 750 mit
  `if (!pSSLCtx) { ASSERT(0); g_Mutex.Unlock(); return false; }` ab. Zu
  diesem Zeitpunkt ist noch kein `SSL_CTX` angelegt, es leckt also nichts.
  **H1 ist damit erledigt.**
- **`mapicmc.cpp` (`bc94cf0`)**: `current_line = CString(pszData, (int)(pszNewline - pszData));`
  ersetzt das Setzen und Zuruecksetzen des NUL-Bytes. Bei `WM_COPYDATA` liegt
  der Puffer im fremden Prozess; der Schreibzugriff faellt jetzt weg. Der
  ausgeschnittene Text ist byteweise derselbe. Richtig.
- **`EudoraExe.rc` / Manifest (`f42466b`)**: Das `RT_MANIFEST` aus der `.rc`
  auszukommentieren ist unbedenklich - `Eudora.vcxproj:966` fuehrt
  `<Manifest Include="Eudora.manifest" />`, und MSBuild reicht `@(Manifest)`
  an den Linker weiter. Die Abhaengigkeit auf
  `Microsoft.Windows.Common-Controls 6.0.0.0` (und damit die Fensterthemen,
  auf die `XPThemedAppearance` baut) bleibt im erzeugten Manifest erhalten.
  Nachgesehen, nicht vermutet.
- **`qcssl.rc` (`94e32c6`)**: nur Versionstexte, ohne Wirkung auf den Ablauf.

## Neuer Befund

### NP2-1 - Stufe 3 haengt nirgends: 6.083 Zeilen ohne Uebersetzung

**Sicherheit: nachgewiesen**

**Dateien:** `Eudora71/OTShim/OTShim_Werkzeugleiste.h`,
`Eudora71/OTShim/OTShim_Werkzeugleiste.cpp` (Commit `91716bb`),
`Eudora71/OTShim/OTShimAll.h`, `Eudora71/Eudora/Eudora.vcxproj`

Gemessen, nicht geschaetzt:

```
grep -c OTShim_Werkzeugleiste Eudora71/Eudora/Eudora.vcxproj  -> 0
grep -c OTShim_Werkzeugleiste Eudora71/OTShim/OTShimAll.h     -> 0
```

`7dcac81` hat drei Dateien ins Projekt genommen (`OTShim.cpp`,
`OTShim_Bild.cpp`, `OT501/Src/secaux.cpp`) und `OTShimAll.h` angelegt. Beides
ist **vor** `91716bb` passiert und danach nicht nachgezogen worden. Folge:

1. `OTShim_Werkzeugleiste.cpp` wird von keinem Projekt uebersetzt. Die 4.671
   Zeilen sind bisher durch **keinen Uebersetzer gelaufen**.
2. `OTShim_Werkzeugleiste.h` wird von `OTShimAll.h` nicht eingebunden. Die
   Klassen `SECStdBtn`, `SECWndBtn`, `SECTwoPartBtn`, `SECComboBtn`,
   `SECCustomToolBar`, `SECToolBarManager` kommen fuer Eudora weiterhin aus
   den Stingray-Originalen unter `OT501/Include` - fuer die es keine
   Implementierung gibt.
3. `OTShimAll.h` Z. 38-40 haelt den Waechter dafuer ausdruecklich noch
   zurueck:
   ```
   // #ifndef __SECBTNS_H__  -- erst setzen, wenn Stufe 3 (Knoepfe) geliefert ist
   ```
   Stufe 3 **ist** geliefert; die Zeile ist seitdem veraltet. Umgekehrt wuerde
   das Setzen des Waechters ohne Einbinden von `OTShim_Werkzeugleiste.h` die
   Knopfklassen ersatzlos verschwinden lassen.

Das ist derselbe Befundtyp wie N6 aus der ersten Runde, nur eine Stufe
weiter: Der Code ist da, er ist nur an nichts angeschlossen. Solange das so
ist, sagt "uebersetzt" ueber Stufe 3 gar nichts aus - auch der
Uebersetzungsfehler waere noch nicht gefunden.

**Zu tun (fuer die naechste Sitzung, nicht fuer den Pruefer):**
`OTShim_Werkzeugleiste.cpp` in `Eudora.vcxproj` aufnehmen (wie die anderen
drei mit `<PrecompiledHeader>NotUsing</PrecompiledHeader>`),
`OTShim_Werkzeugleiste.h` in `OTShimAll.h` einbinden und dabei die Waechter
`__TBTNSTD_H__`, `__TBTNWND_H__`, `__TBTN2PRT_H__`, `__TBTNCMBO_H__`,
`__TBARCUST_H__`, `__TBARMGR_H__`, `__TBARPAGE_H__`, `__TBARTRCK_H__` und
`__SECBTNS_H__` gemeinsam setzen. `OTShim_Werkzeugleiste.h:1402-1405` setzt
vier davon bereits selbst - das ist beim Zusammenfuehren zu beachten, damit
kein Waechter doppelt oder gar nicht gesetzt wird.

## Noch offen - hier ansetzen

Die inhaltliche Pruefung des neuen Codes hat **nicht mehr stattgefunden**.
Angesehen wurde bisher nur die Gliederung (Klassenliste des Headers,
Funktionsliste des `.cpp`). Offen sind:

| Prioritaet | Gegenstand | Stand |
|---|---|---|
| 1 | `OTShim_Werkzeugleiste.cpp` `SECStdBtn::DrawFace` (Z. 688-762) gegen `TBarSendButton.cpp:71-160` und die auskommentierte zweite Kopie in `MoodMailStatic.cpp:63-120` | **nicht begonnen** |
| 1 | `SECBtnDrawData` (Z. 156ff Header, Z. 286-438 cpp): drei `CPaletteDC` als Wertfelder - Lebensdauer, Freigabe der GDI-Objekte, Verhalten bei fehlgeschlagenem `CreateCompatibleDC` | **nicht begonnen** |
| 1 | `SECCustomToolBar`: Anordnung, Umbruch, Mausbehandlung, `OnUpdateCmdUI` mit eigener `CCmdUI`-Ableitung; Indexgrenzen und Nullzeiger | **nicht begonnen** |
| 1 | `SECToolBarManager::LoadState` gegen `QCLoadState` | **nicht begonnen** |
| 1 | `CSafetyPalette`/`CPaletteDC` (cpp Z. 121-284) - in der Freigabe nie implementiert | **nicht begonnen** |
| 2 | `OTShim.{h,cpp}` Stufe 2/2b (`a7478b0`, `dd65c33`): `SECControlBar`, `SECDockBar`, `SECMiniDockFrameWnd`, `SECFrameWnd`, `SECDockState`, `SECControlBarInfo(Ex)`, `SECControlBarManager`, `SECDockContext`; besonders die zweite Dockbar `m_wndSECDockBar` neben dem geerbten `m_wndDockBar` | **nicht begonnen** |
| 3 | `OTShim_Bild.*` (`e81adb0`): Wiederherstellen der Bitmapauswahl in **allen** Rueckgabepfaden von `CreateFromBitmap`, auch im Fehlerfall | **nicht begonnen** |
| 4 | `tools/lehren-spiegeln.pl` (`8dd6b2a`/`adcede6`), im pre-commit-Hook | **nicht begonnen** |
| 4 | `tools/patches/zertifikatspruefung-verschaerfen.patch` (`1a0c343`) - liegt nur bereit, ist nicht angewandt | **nicht begonnen** |

Nicht zu pruefen (waren beim Abbruch noch im Fluss, andere Agenten):
`OTShim_Reiter.{h,cpp}`, `OTShim_Palette.{h,cpp}`.

Weiterhin ausgenommen: die **Hostnamenpruefung** in QCSSL.

## Stand der alten Befunde

Nicht erneut nachgesehen; sie beziehen sich auf `ba617a8`. Ausnahme: **H1 ist
behoben** (siehe oben). `M3` war schon im Nachtrag als ueberholt vermerkt.

---

## Ergebnis der Stufe-3-Pruefung (`91716bb`) - NACHTRAG zur obigen Tabelle

Die Tabelle "Noch offen" oben war der Stand beim ersten Sicherungs-Commit.
Danach konnte Stufe 3 doch noch weitgehend geprueft werden. **Erledigt** sind
damit: `SECStdBtn::DrawFace`, `SECBtnDrawData` samt
`PreDrawButton`/`PostDrawButton`/`SysColorChange`/`CreateDitherBrush`,
`CSafetyPalette`, `CPaletteDC`, `SECToolBarManager::LoadState`/`SaveState`,
`SECToolBarCmdUI` mit `SECCustomToolBar::OnUpdateCmdUI` sowie saemtliche
Indexzugriffe auf `m_btns` samt `m_nDown`/`m_nRaised`.

**Weiterhin offen von Stufe 3:** die Anordnungsrechnung von
`SECCustomToolBar` (Zeilenumbruch, `CalcDynamicLayout`, `CalcFixedLayout`,
`Layout`), `SECTwoPartBtn::DrawButton`, `SECWndBtn`/`SECComboBtn`
(Fenstererzeugung, Weiterreichen der Mausereignisse), `SECCustomizeToolBar`
und die Anpassen-Dialogseiten. Unveraendert offen: Stufe 2/2b, Stufe 4,
`lehren-spiegeln.pl`, der Zertifikats-Patch.

### Geprueft und in Ordnung

- **`SECStdBtn::DrawFace` (cpp Z. 688-762).** Der Vertrag stimmt: Ziel ist
  `data.m_drawDC`; `x`, `y`, `nWidth`, `nHeight` kommen als ganzer Knopf herein
  und gehen als innere Flaeche zurueck; `bForce` unterdrueckt Gedrueckt- und
  Angehoben-Darstellung; `nImgWidth == -1` heisst volle Bildbreite. Alle vier
  Rahmenzweige (gedrueckt, cool+angehoben, cool, klassisch) decken sich Zeile
  fuer Zeile mit `TBarSendButton.cpp:71-160`, und
  `ColorToolbarButton.cpp:53-73` bestaetigt den Rueckgabevertrag: es rechnet
  nach dem Basisaufruf mit den veraenderten `x`/`y` weiter.

- **Wichtig fuer spaetere Leser: das fehlende `+ 1` ist richtig so.**
  `TBarSendButton.cpp:83` rechnet
  `yImg = (nHeight - GetImgHeight())/2 + y + 1`, der Shim rechnet ohne `+ 1`.
  Die zweite, auskommentierte Kopie in `MoodMailStatic.cpp:73` rechnet
  **ebenfalls ohne `+ 1`**. Das `+ 1` ist also die Zugabe des Sende-Knopfes und
  nicht Teil der Basis; der Shim folgt der Basis. Wer das spaeter
  "berichtigt", verschiebt jedes Knopfbild um einen Bildpunkt nach unten.
  Die Commit-Nachricht von `91716bb` nennt nur `TBarSendButton` als Vorlage -
  deshalb hier ausdruecklich festgehalten.
  Zwei weitere Abweichungen von `TBarSendButton` sind ebenfalls richtig: das
  dortige `SetBkColor(COLOR_WINDOW)` gehoert zum anschliessend gezeichneten
  Text und ist fuer ein `SRCCOPY` ohne Belang; die zusaetzliche Schranke
  `if (nImgWidth > 0)` ist folgenlos, weil ein `BitBlt` der Breite 0 ohnehin
  nichts tut.

- **`SECToolBarManager::LoadState` (cpp Z. 4074-4106).** Gegen
  `QCToolBarManager::QCLoadState` (`QCToolBarManager.cpp:1118-1170`)
  abgeglichen: gleiche Reihenfolge, dieselben drei Profilwerte, dieselbe
  Leistenschleife mit `SetManager` und Zaehler, dasselbe
  `SetDefaultDockState()` bei null Leisten. Entscheidend sind die
  Schluesselnamen, denn Eudora **liest** mit `QCLoadState` und **schreibt**
  ueber `SECToolBarManager::SaveState` - beide Seiten muessen dieselben
  Zeichenketten benutzen, sonst gingen Kurzhinweise, Cool-Look und grosse
  Knoepfe bei jedem Start still verloren. Nachgemessen (cpp Z. 4064-4067):
  `"%s-ToolBarManager"`, `"ToolTips"`, `"CoolLook"`, `"LargeButtons"` -
  **wortgleich** mit `QCToolBarManager.cpp:1125-1128`. Die Iteration ist sogar
  sauberer als das Original: sie wandelt erst nach `CControlBar*` und prueft
  dann `IsKindOf`, statt vor der Pruefung nach `SECCustomToolBar*` zu wandeln.

- **`SECToolBarCmdUI` / `OnUpdateCmdUI` (cpp Z. 2676-2745).** Deckt sich mit
  `CToolCmdUI` aus `winctrl3.cpp`, einschliesslich des dortigen
  `nNewStyle &= ~TBBS_PRESSED` beim Sperren und des Ueberspringens von
  `TBBS_SEPARATOR`. `SetText` ist wie im Vorbild leer.

- **`SECBtnDrawData`, Lebensdauer der GDI-Objekte.** Durchgerechnet:
  `PreDrawButton` stellt auf **jedem** Fehlerweg die zuvor gewaehlten Objekte
  wieder her, bevor es `FALSE` liefert, und setzt `m_bReady` erst ganz am
  Ende - nach der letzten Fehlerstelle. Ein verschachtelter Aufruf wird oben
  mit `if (m_bReady) PostDrawButton();` abgefangen. Der Destruktor ruft
  `PostDrawButton()` im **Rumpf**, also bevor die Member abgebaut werden; die
  `CBitmap`-Felder sind damit abgewaehlt, ehe sie zerstoert werden - was hier
  noetig ist, weil sie in umgekehrter Deklarationsreihenfolge vor den
  `CPaletteDC`-Feldern an die Reihe kaemen. Kein Leck gefunden.

- **Indexgrenzen.** `AddButton`, `RemoveButton`, `GetItemID`, `GetItemRect`,
  `InvalidateButton`, `GetButtonStyle` und `SetButtonStyle` pruefen alle
  `nIndex < 0 || nIndex >= GetBtnCount()`. `RemoveButton` zieht `m_nDown`,
  `m_nRaised` und das durchgereichte `*pIndex` richtig nach; `AddButton`
  schiebt `m_nDown` mit. Alle Verwendungen von `m_nDown`/`m_nRaised` sind
  beidseitig geschrankt - auch `OnLButtonUp` (Z. 2886) und `RaiseButton`
  (Z. 2948-2968, wo der Index aus `ItemFromPoint` kommt und damit gueltig oder
  -1 ist). Nichts gefunden, was ueber das Feld hinausgreift.

### NP2-2 - `SysColorChange()` tut nicht, was daneben steht

**Sicherheit: nachgewiesen. Auswirkung: keine - aber der Kommentar fuehrt in
die Irre.**

`Eudora71/OTShim/OTShim_Werkzeugleiste.cpp` Z. 320-331. Der Kommentar sagt,
ein zwischengespeicherter Zeichenpuffer bleibe bei einem Farbwechsel nicht
gueltig. Die Funktion loescht dann aber nur `m_ditherBrush`; `m_bmpDraw`,
`m_bmpMono`, `m_cxBuf` und `m_cyBuf` bleiben stehen, und der naechste
`PreDrawButton` nimmt denselben Puffer wieder.

Folgenlos, weil `DrawFace` den Puffer bei jedem Knopf zuerst mit
`FillSolidRect` ueberschreibt - ein alter Bildpunkt wird also nie sichtbar.
Der Kommentar behauptet aber eine Vorkehrung, die es nicht gibt.

**Zu tun:** Entweder die zwei Loeschzeilen ergaenzen oder den Kommentar auf das
kuerzen, was zutrifft.

### NP2-3 - `BitBltTransparent` meldet Erfolg, ohne gezeichnet zu haben

**Sicherheit: nachgewiesen; geringe Auswirkung**

`Eudora71/OTShim/OTShim_Werkzeugleiste.cpp` Z. 233-272. Der eigentliche
Kopiervorgang steht in einem `if`:

```
if (dcTmp.CreateCompatibleDC(this) &&
    bmTmp.CreateCompatibleBitmap(this, nWidth, nHeight))
{
    ... die vier BitBlt ...
}

dcMask.SelectObject(pOldMask);
return TRUE;
```

Schlaegt eine der beiden Erzeugungen fehl, wird nichts gezeichnet - die
Funktion liefert trotzdem `TRUE`. Der Aufrufer haelt die Flaeche fuer
gezeichnet und laesst stehen, was vorher dort stand. Die frueheren
Fehlerausgaenge derselben Funktion liefern korrekt `FALSE`; nur dieser eine
nicht.

**Zu tun:** Den Rueckgabewert an das Ergebnis des Blocks binden.

---

## Gesamtzahl nach der Nachpruefung

- Teil 1 (`ba617a8`): 1 hoch (**H1 inzwischen behoben**), 5 mittel (davon M3
  ueberholt, M4 und M5 Originalfehler), 8 niedrig.
- Teil 2 (`ba617a8..8dd6b2a`, unvollstaendig): 3 Befunde - NP2-1 (Stufe 3
  haengt in keinem Projekt), NP2-2 und NP2-3 (beide klein, in Stufe 3).

Der Werkzeugleisten-Block aus `91716bb` ist an den geprueften Stellen
**sauber**. Die vier Punkte, auf die der Auftrag ausdruecklich hingewiesen hat -
`DrawFace`, `SECBtnDrawData` mit den drei `CPaletteDC`, die Indexgrenzen von
`SECCustomToolBar` und `LoadState` gegen `QCLoadState` - halten der Pruefung
stand. Der ernsteste Befund an Stufe 3 ist nicht der Code selbst, sondern dass
er nirgends eingebunden ist (NP2-1) und deshalb noch durch keinen Uebersetzer
gelaufen ist.

---

## B-1 — Ersatz für die Laufzeitbibliothek von Visual C++ 7.1 (`VC71Bruecke`)

Agent BRUECKE, 30.08.2026. Ausführliche Fassung mit allen Messungen:
[`Eudora71/VC71Bruecke/BEFUND.md`](Eudora71/VC71Bruecke/BEFUND.md). Hier nur
das, was für andere Agenten und für Paket 1.0.3 zählt.

### Was jetzt da ist

`Eudora71/VC71Bruecke` erzeugt eine eigene `msvcr71.dll`, die ihre Exporte an
`C:\Windows\SysWOW64\msvcrt.dll` weiterleitet. Damit können die drei
unsignierten Fremd-DLLs von dll-files.com (`msvcr71.dll`, `msvcr71d.dll`,
`msvcp71d.dll`) aus dem Paket **entfallen**.

Gemessen am fertigen PE:

- x86, Abhängigkeiten: **nur `KERNEL32.dll`** (`dumpbin -dependents`) — keine
  moderne CRT, das Problem ist also gelöst und nicht verschoben
- 1430 Exporte, davon **1429 echte Forwarder** und eine eigene Funktion
  (`__security_error_handler`, die einzige der 118 gebrauchten, die
  `msvcrt.dll` nicht hat)
- laufzeitgeprüft mit einem Konsolenprogramm: **alle 1429 lösen auf**,
  `malloc`/`strlen`/`free` funktionieren über die Brücke

Bauen (das Projekt hängt noch **nicht** in `Eudora.sln`, siehe unten):

    MSBuild VC71Bruecke.vcxproj /p:Configuration=Release /p:Platform=Win32 /p:BuildProjectReferences=false /m /v:minimal

### Drei Befunde, die über den Auftrag hinausgehen

**B-1.1 — Der Kreis der betroffenen Module ist größer als sieben.** In
`Eudora71/Bin/Release/Plugins` liegen drei weitere vorgebaute Fremdmodule ohne
Quellen: `SMIME.dll`, `SpamHeaders.dll`, `SpamWatch.dll`. Alle drei brauchen
`MFC71.DLL`, `MSVCR71.dll` **und** `MSVCP71.dll`.

**B-1.2 — Die Brücke rettet drei von zehn Modulen, und das ist die Obergrenze.**
Vollständig gelöst sind `Paige32.dll` (Textbearbeitung), `DirServ.dll` und
`EuMemMgr.dll` — sie brauchen nur `MSVCR71`. Die anderen sieben scheitern
nicht an `MSVCR71`, sondern an `MFC71.DLL` (`EudoraBk`, `ISock`, `Ldap`,
die drei Plugins) und `MSVCP71.dll` (`Ph`, `Ldap`, die drei Plugins).
**Diese beiden DLLs liegen dem Paket nach Auftragsbeschreibung gar nicht bei.**
Wenn das stimmt, sind Adressbuch, LDAP-Verzeichnisdienst, `Ph` und alle drei
Plugins **heute schon nicht ladbar** — unabhängig von der `msvcr71`-Frage.
**Das gehört am echten Paket nachgesehen**; es liegt nicht im Repository.

**B-1.3 — `MFC71.DLL` ist nicht „schwierig“, sondern aussichtslos.** Die
Messung „0 benannte Importe aus MFC71“ bedeutet nicht, dass nichts gebraucht
wird, sondern das Gegenteil: es sind **157 Importe nach Ordinal** (Debug: 173),
also 157 Bindungen ohne Namen. Ein Ersatz müsste Microsofts Ordinalvergabe von
2003 exakt treffen; diese Zuordnung ist nicht veröffentlicht und aus den
vorliegenden Dateien nicht rekonstruierbar. Für `MSVCP71.dll` gilt: technisch
nachbaubar (17 Namen für die sieben DLLs, 173 mit den Plugins), aber
**nutzlos**, weil sechs der sieben betroffenen Module zusätzlich an `MFC71`
hängen. Übrig bliebe nur `Ph.dll`. **Nicht bauen.**

### `Paige32d.dll`: Umbenennen ist erlaubt (belegt)

Die Release-`Paige32.dll` darf unter dem Namen `Paige32d.dll` in `Bin/Debug`
liegen. Vier unabhängige Belege:

1. Exportlisten beider DLLs: **938 Namen, Differenz leer**
2. `Paige32.lib` und `Paige32d.lib`: **938 Symbole, Differenz leer**
3. `PAIGE.H` hat **kein einziges** `#ifdef _DEBUG`. Paige schaltet über ein
   eigenes Makro `PG_DEBUG`, das in `CPUDEFS.H:35`/`:47` auskommentiert ist und
   in keiner `.vcxproj` und keinem Quelltext gesetzt wird. Die Felder unter dem
   Kommentar `PAIGE.H:2169` („used only for PG_DEBUG“) stehen **unbedingt** in
   der Struktur.
4. Unabhängig von den Kopfdateien: `pgAllocateNewRef` bekäme unter `PG_DEBUG`
   zwei Parameter mehr (`PGMEMMGR.H:269-274`). Der Export heißt in **beiden**
   DLLs `_pgAllocateNewRef@20`, nicht `@28`. Beide wurden also mit derselben
   Konfiguration gebaut.

Ein Startversuch ist für dieses Urteil nicht nötig.

### `msvcr71d.dll` und `msvcp71d.dll` können aus dem Paket weg

Gemessen: **kein einziges** Modul unter `Eudora71/Bin/Release` importiert aus
`MSVCR71D.dll`, `MSVCP71D.dll` oder `MFC71D.DLL`. Ein Auslieferungspaket wird
aus der Release-Ausgabe gebaut. Nebenbei: `msvcp71d.dll` war ohnehin die
falsche Begründung — `Paige32d.dll` importiert **kein** `MSVCP71D`, sondern nur
`KERNEL32`, `USER32`, `GDI32` und `MSVCR71D`.

### Fallstrick für alle, die an der `.def` arbeiten

Die klassische Zeile `malloc = msvcrt.malloc` **bindet mit dem Linker aus
VS 2022 nicht**: `LNK2001: Nicht aufgelöstes externes Symbol "malloc"`.
Ursache eingekreist (fünf Testbindungen, siehe `BEFUND.md` 2.3): link.exe löst
den Namen auf der rechten Seite trotzdem als gewöhnliches externes Symbol auf.
Weder `/EXPORT` auf der Befehlszeile noch `PRIVATE`, `@ordinal` oder
`/ALTERNATENAME` helfen. Der Bauablauf erzeugt deshalb vor dem Binden mit
`lib.exe` eine Stub-Importbibliothek; im fertigen PE steht davon nichts.

### Vier im Auftrag genannte Dateien gibt es nicht

`ZIEL.md`, `Releases/PAKETE.md`, `tools/zeilenenden-angleichen.pl` und
`tools/ersetze-bereich.pl` sind im Repository nicht vorhanden. Ebenso gibt es
in dieser `BEFUNDE.md` keine Abschnitte `S-1` bis `S-7`. Wer künftige Aufträge
schreibt, sollte das wissen.

### Offen

- `VC71Bruecke` hängt **noch nicht** in `Eudora71/Eudora.sln` — bewusst nicht
  eingetragen, um keinen Konflikt in einer geteilten Datei zu hinterlassen.
  Die zwei nötigen Einfügungen stehen wörtlich in `BEFUND.md`, Abschnitt 6.
- Startversuch mit der Brücke steht aus (Auflage: keine Fenster, kein
  Eudora-Start).
