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

# Erledigt durch WACHE (30.08.2026, Branch `eudora-exe-linkt`)

Zustaendig fuer `Eudora71/QCSSL/src/*` und `Eudora71/QCSocket/src/*`. Die
Befundabschnitte oben sind unveraendert geblieben; hier steht, was daraus
geworden ist. Ausdruecklich nicht angefasst: die Hostnamenpruefung (nur CN, keine
SAN, rein beratend) und die Zertifikatsannahme bei `X509_V_ERR_CERT_UNTRUSTED` -
beide sind nach `Arbeitsweise/zurueckgestellte-befunde.md` bewusst zurueckgestellt,
der fertige Patch `tools/patches/zertifikatspruefung-verschaerfen.patch` bleibt
unangewandt.

## M1 - erledigt, Code in `78a9c10`

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp`, `SetSSLVersion()`: Z. 557
(Kommentar), Z. 577/578 - Fall 3 setzt jetzt `iMinVersion = TLS1_2_VERSION`
statt `TLS1_VERSION`, mit Begruendung im Code.

Von den beiden im Befund angebotenen Wegen wurde der erste gewaehlt: Fall 3
bekommt denselben Boden wie alle anderen Faelle, die Obergrenze bleibt offen.
Begruendung, nachgemessen statt vermutet:

- Fall 3 ist nicht der Sonderfall, sondern der **Normalfall**. `EudoraRes.rc:8143`
  und `:8147` geben `SSLReceiveVersion` und `SSLSendVersion` beide mit **3** vor.
  Die schwaechste Untergrenze galt also fuer jede Voreinstellung; die TLS-1.2-
  Untergrenze der uebrigen Faelle traf fast niemanden. Der Befund beschreibt Fall 3
  als Ausreisser - er ist in Wahrheit der Regelfall, was ihn ernster macht, nicht
  harmloser.
- Die Obergrenze offenzulassen ist richtig und bleibt so. TLS 1.3 zu verbieten,
  weil jemand vor zwanzig Jahren "TLSv1" angeklickt hat, waere unsinnig; zu tief
  war nur die Untergrenze.
- Wirkung gemessen: `Eudora71/Tests/QCSSL/work/ergebnis_qcssl_lokal.txt`, Fall 2e
  (`ProtocolVersion=3` gegen einen Server, der nur TLS 1.0 spricht) schlug **schon
  vor** der Aenderung fehl - Security Level 1 von OpenSSL 3 laesst TLS 1.0/1.1 gar
  nicht erst zu. Die Aenderung schreibt damit nur fest, was ohnehin geschieht, und
  bricht keine Verbindung, die heute zustande kommt.

**Zur Commit-Zuordnung:** die Aenderung war zum Commit vorgemerkt, als ein parallel
arbeitender Agent `git commit` ohne Pfadangabe ausfuehrte; sie ist deshalb in
`78a9c10` gelandet, dessen Nachricht sie nicht beschreibt. Inhalt und Wirkung sind
davon unberuehrt. Seither committe ich nur noch mit Pfadangabe.

Bauen: `QCSSL.vcxproj` Release/x86 erfolgreich, 0 Warnungen, 0 Fehler.
Tests: `Eudora71/Tests/RunTests.cmd` - 23 Tests, 23 bestanden, 0 fehlgeschlagen.

## N3 - erledigt, Commit `9608b39`

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp` Z. 591 und Z. 770.

- `SSL_CTX_set_min_proto_version()`: schlaegt der Aufruf fehl, wird der Kontext
  freigegeben und `NULL` zurueckgegeben. `BeginQCSSLSession()` bricht bei `NULL`
  ab - denselben Weg nimmt seit H1 auch die ungueltige Version. Die eingestellte
  Untergrenze kann damit nicht mehr stillschweigend durch die Voreinstellung von
  OpenSSL ersetzt werden.
- `SetCipherSuites()`: Rueckgabewert wird in `BeginQCSSLSession()` geprueft und
  fuehrt im Fehlerfall zum Abbruch samt `SSL_CTX_free()` und `g_Mutex.Unlock()`,
  wie in den benachbarten Fehlerzweigen. Ausloesen kann das nur `pSSLCtx == NULL`,
  was zwei Zeilen darueber schon geprueft wird - die Auswertung ist eine Schranke
  gegen kuenftige Aenderungen, kein neuer Pfad.

Bauen: `QCSSL.vcxproj` Release/x86 erfolgreich, 0 Warnungen, 0 Fehler.
Tests: `Eudora71/Tests/RunTests.cmd` - 33 Tests, 30 bestanden, 3 fehlgeschlagen.
Die drei roten Tests betreffen `ISOTranslate()` in `Eudora/utils.cpp` (Emoji,
griechische Schrift) - ein anderer Arbeitsbereich, QCSSL hat daran keinen Anteil.

## M2 - erledigt

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp` Z. 309-334, `BIO_s_workersocket()`.

Die `BIO_METHOD` wird jetzt in einer lokalen Variablen (`pNeu`) angelegt und
vollstaendig gefuellt; erst danach wird sie mit einem einzigen
`InterlockedCompareExchangePointer()` veroeffentlicht. Wer das Rennen verliert,
gibt seine eigene Struktur mit `BIO_meth_free()` wieder frei. `s_pMethodsWS` ist
zusaetzlich `volatile`, damit der Uebersetzer den Vergleich am Anfang und die
Rueckgabe am Ende nicht zu einem einzigen gepufferten Lesezugriff zusammenzieht.

Damit sind beide im Befund beschriebenen Rennen weg:

- Kein Thread kann mehr eine halb gefuellte `BIO_METHOD` sehen - der Zeiger wird
  erst gesetzt, wenn alle sechs Setter gelaufen sind.
- Es bleibt auch nichts mehr liegen: der Verlierer raeumt seine eigene Struktur ab.
  Das kleine Leck aus dem Befund ist damit ebenfalls erledigt.

Die Funktion haengt jetzt nicht mehr an der ungeschriebenen Zusicherung, dass ihr
einziger Aufrufer unter `g_Mutex` laeuft. `g_Mutex` bleibt unveraendert - es geht
nur darum, dass die Funktion fuer sich genommen haelt.

Bauen: `QCSSL.vcxproj` Release/x86 erfolgreich, 0 Warnungen, 0 Fehler.
Tests: `Eudora71/Tests/RunTests.cmd` - 33 Tests, 33 bestanden, 0 fehlgeschlagen.

## M4 - erledigt

**Datei:** `Eudora71/QCSocket/src/QCWorkerSocket.cpp:2084`, `SetSSLMode()`.
`m_nSSLSendVersion` durch `m_nSSLReceiveVersion` ersetzt, mit Begruendung im Code.

Der Befund raet, die Aufrufstellen erst zu pruefen, weil beide Richtungen dieselbe
Einstellung absichtlich nutzen koennten. Geprueft, und sie tun es nicht:

- Der `else`-Zweig ab Z. 2076 ist der Empfangszweig (POP/IMAP). **Alle** zehn
  uebrigen Zuweisungen darin lesen `m_nSSLReceive...`; der Zweig unmittelbar
  darueber (Alternativport, Z. 2080) liest `m_nSSLAltPortReceiveVersion`. Genau
  eine Zeile faellt aus dem Muster - Z. 2084.
- `m_nSSLReceiveVersion` ist voll versorgt: `SSLSettings.cpp:75` laedt es aus
  `IDS_INI_SSL_RECEIVE_VERSION`, und `EudoraRes.rc:8143` gibt dafuer denselben
  Vorgabewert **3** wie fuer `SSLSendVersion` (`:8147`). Ein Umschalten kann also
  keine ungueltige Version erzeugen; wer nichts einstellt, merkt nichts.
  `GetSSLReceiveVersion()` (SSLSettings.h:171) existiert ebenfalls und war der
  einzige weitere Beruehrungspunkt - unbenutzt.
- Kein zweiter Leser: `m_nSSLSendVersion` wird ausser hier nur in Z. 2062 im
  SMTP-Zweig gelesen. Eine Absicht, die Empfangsrichtung an die Sendeeinstellung
  zu koppeln, ist an keiner Stelle formuliert.

**Einschraenkung, damit sie nicht ueberschaetzt wird:** seit M1 laufen alle acht
gueltigen Faelle auf dieselbe Untergrenze TLS 1.2 hinaus. Die im Befund
beschriebene Wirkung - die Empfangsrichtung erbt den TLS-Boden der Sendeseite -
kann also derzeit ohnehin nicht mehr auftreten. Uebrig bleibt der Unterschied im
`default:`-Zweig (ungueltiger Wert bricht ab) und, wichtiger, dass die Einstellung
jetzt wieder die Verkabelung hat, die ihr Name verspricht.

Bauen: `QCSocket.vcxproj` Release/x86 erfolgreich, 0 Fehler (11 Warnungen, alle
aus dem Altbestand). `QCSSL.vcxproj` unveraendert gruen.
Tests: `Eudora71/Tests/RunTests.cmd` - 33 Tests, 33 bestanden, 0 fehlgeschlagen.

## N1 - erledigt, und zwar sauber statt mit `static_assert`

**Datei:** `Eudora71/QCSSL/src/QCSSLContext.cpp` Z. 249, 260, 336, 341, 789.

Der Auftrag liess die Wahl zwischen einer `static_assert` auf die Zeigergroesse und
einer sauberen Loesung. Gewaehlt wurde die saubere, weil sie nicht teurer war:

- `BIO_new_ws()` nimmt jetzt einen `QCSSLReference*` statt eines `int` und legt ihn
  ueber `BIO_ctrl(pBIO, BIO_C_SET_FD, iCloseFlag, pWorkerSocket)` ab - der vierte
  Parameter von `BIO_ctrl` ist `void*`, also zeigergross. `BIO_set_fd()` wird nicht
  mehr benutzt; genau dieses Makro war der Engpass, weil es ueber `BIO_int_ctrl()
  die Adresse eines lokalen `int` weiterreicht.
- `ws_ctrl()`, `BIO_C_SET_FD` (Z. 249): `BIO_set_data(pBIO, ptr)` statt
  `BIO_set_data(pBIO, (void*)(INT_PTR)(*((int*)ptr)))`. Kein Umweg mehr durch `int`.
- `ws_ctrl()`, `BIO_C_GET_FD` (Z. 260): `*((void**)ptr) = BIO_get_data(pBIO)` statt
  der Rueckgabe als `int`/`long`. Der Rueckgabewert `lRet` bleibt 1 (Erfolg), weil
  eine Adresse als `long` unter x64 nicht zurueckgegeben werden koennte.
- Aufrufer Z. 789: die Umwandlung `(int)pSSLReference` ist entfallen.

Dass wir die OpenSSL-Belegung von `BIO_C_SET_FD` dabei umdeuten, ist zulaessig und
im Code vermerkt: `BIO_s_workersocket` ist eine eigene BIO-Methode, `BIO_new_ws()`
ihr einziger Erzeuger, und `BIO_get_fd()` ruft im ganzen Baum niemand auf. Weder
`BIO_new_ws` noch `BIO_s_workersocket` stehen in einer Kopfdatei oder in
`qcssl.def`; ausserhalb dieser Datei ist nichts betroffen.

**Was fuer x64 trotzdem offen bleibt** (nicht Teil von N1, hier nur vermerkt, damit
es nicht als erledigt gilt): `ws_read()` Z. 154 und `ws_write()` Z. 202 reichen den
`QCSSLReference*` als `(long)` an `m_fnQCSSLReadCallback`/`m_fnQCSSLWriteCallback`
weiter. Das ist die Signatur der Rueckruffunktionen in der oeffentlichen
QCSSL-Schnittstelle, an der auch QCSocket haengt; sie zu aendern ist ein eigener
Umbau. Unter Win32 ist es folgenlos, unter x64 waere es dieselbe Trunkierung.

**Gegenprobe am Produktivpfad:** `Eudora71/Tests/QCSSL/messen.ps1` mit der neu
gebauten `Eudora71/Bin/Release/QCSSL.dll`. Alle neun Faelle verhalten sich genau wie
vor den Aenderungen (1a Erfolg TLSv1.3, 1b/1d Fehlschlag, 1c unveraendert - das ist
der zurueckgestellte Hostnamen-Befund -, 2a/2b Fehlschlag, 2c TLSv1.2, 2d TLSv1.3,
2e Fehlschlag). Die erfolgreichen Faelle uebertragen Nutzdaten, laufen also durch
`ws_read`/`ws_write` und damit durch den umgebauten Datenslot.

Bauen: `QCSSL.vcxproj` Release/x86 erfolgreich, 0 Warnungen, 0 Fehler.
Tests: `Eudora71/Tests/RunTests.cmd` - 33 Tests, 33 bestanden, 0 fehlgeschlagen.

## Ausgeliefertes Paket nachgezogen

`Releases/1.0/QCSSL.dll` ist neu gebaut, `QCSSL.dll.sha256` erneuert
(`5c7fcd5004036e9247252b8ec822687758a84774dad2d024e6fe172116339664`), und im
`Releases/1.0/README.md` steht unter "Neubau vom 30.08.2026", was fuer diesen
Build gemessen ist und was nicht. Damit stimmt auch die Aussage im Abschnitt
"Herkunft" wieder, die DLL sei byte-identisch mit `Eudora71/Bin/Release/QCSSL.dll`.

## Was in `PORTIERUNG.md` durch diese Arbeit ueberholt ist

Nicht selbst geaendert - dort arbeitet LEKTOR. Nur als Hinweis:

- Z. 204-210: "Als Mindestprotokoll setzt `QCSSLContext.cpp:561-583` bei sieben der
  acht Werte ... `TLS1_2_VERSION`. Der achte, `m_ProtocolVersion == 3` ..., setzt
  `TLS1_VERSION`, also TLS 1.0." Das gilt seit M1 nicht mehr: alle acht Werte setzen
  `TLS1_2_VERSION`.
- Derselbe Absatz: "Ein ungueltiger Wert landet im `default`-Zweig, meldet
  `IDS_ERR_VERSIONINVALID` und bleibt beim Startwert `TLS1_2_VERSION`." Das war schon
  durch H1 ueberholt - der Zweig gibt jetzt `NULL` zurueck, die Verbindung kommt
  nicht zustande.
- Die Zeile "Eine Obergrenze wird nirgends gesetzt" stimmt weiterhin und soll auch
  so bleiben.
- Tabelle Z. 196: der Eintrag zu `BIO_s_workersocket` koennte ergaenzen, dass die
  Struktur seit M2 erst nach dem Fuellen unteilbar veroeffentlicht wird.
- Nicht erwaehnt, aber jetzt anders: `BIO_set_fd()` wird nicht mehr benutzt (N1).

---

# Erledigt durch SUMME (30.08.2026, Branch `eudora-exe-linkt`)

Bearbeitet wurden die verstreuten Befunde ausserhalb von QCSSL und der
Ersatzschicht: M5, N2, N4, N5, N8. Die bestehenden Befundabschnitte oben sind
unveraendert geblieben; dieser Abschnitt verweist nur auf sie. Hinweis zur Herkunft: die vier Quelldateien und dieser Abschnitt sind versehentlich in den Commit 63f81dc eines parallel laufenden Agenten geraten, dessen Nachricht von ISOTranslate spricht. Die Begruendung zu jeder Aenderung steht deshalb nur hier, nicht in einer Commit-Nachricht.

**Bau:** `Eudora.vcxproj` Debug/x86 uebersetzt vollstaendig durch - kein einziger
Uebersetzungsfehler mehr, auch kein `C2572` aus `secbtns.h`. Es bleiben 14
**Binde**fehler (`SECBitmapButton`, `TraceStart`, `ATL::CImage::s_initGDIPlus`
und `s_cache`, `CVoiceText`, `libpng` mit `__imp___iob`) - die gehoeren LINKER.
Keiner davon nennt eine der hier geaenderten Dateien.
`plstclnt.vcxproj` Debug/x86 baut fehlerfrei bis zur fertigen `plstclnt.dll`.

**Tests:** `Eudora71/Tests/RunTests.cmd` - 33 Tests, 30 bestanden, 3
fehlgeschlagen. Alle drei liegen in `ISOTranslate` (`utils.cpp` /
`TestIsoTranslate.cpp`), beide Dateien sind gerade von einem anderen Agenten in
Arbeit und gehoeren nicht zu diesem Auftrag. Keiner der drei Tests beruehrt
`summary.h`, `plist_mgr.cpp`, `ExceptionHandler.cpp` oder `atlimage.h`.

---

## M5 - erledigt, Aufrufstellen ausgezaehlt

**Zaehlung zuerst.** `GetTail` kommt im gesamten Baum `Eudora71/` **38 mal in 10
Dateien** vor. Davon sind:

- 8 Deklarationen in vier Hilfsklassen: `tocdoc.h:512/514`, `nickdoc.h:204/206`,
  `filtersd.h:233/235`, `summary.h:506/508`;
- 6 Rumpfzeilen dieser Deklarationen, die `CObList::GetTail()` weiterreichen -
  **ausser** den beiden in `summary.h`, die `GetHead()` riefen;
- 2 Deklarationen und 3 Aufrufe der voellig unabhaengigen `CNode::GetTail` in
  `DirectoryServices/Ph`;
- **19 echte Aufrufstellen**, verteilt auf `PaigeEdtView.cpp` (12),
  `QCCommandStack.cpp` (5), `QCMailboxDirector.cpp` (1), `html2text.cpp` (1).

**Kein einziger dieser 19 Aufrufe geht auf ein `CSumList`.** Die Empfaenger
wurden einzeln aufgeloest:

| Aufrufstelle | Empfaenger | Typ |
|---|---|---|
| `PaigeEdtView.cpp` (12x) | `m_undoStack`, `m_redoStack`, `m_deleteUndoStack`, `m_deleteRedoStack`, `theStack`, `theRefStack` | `CUndoStack` = `CTypedPtrList<CPtrList, undo_ref*>` (`PaigeEdtView.h:97`) |
| `QCCommandStack.cpp` (5x) | `m_theStack` | `CPtrList` (`QCCommandStack.h:65`) |
| `QCMailboxDirector.cpp:2109` | `theList` (= `m_theMailboxList`) | `CPtrList` (`QCMailboxDirector.h:48`) |
| `html2text.cpp:851` | `m_BlockList` | `CList<CHtmlBlockInfo, CHtmlBlockInfo&>` (`html2text.h:34`) |

Die einzige abgeleitete Klasse, `CTempSumList` (`summary.h:601`), ruft
`GetTail()` ebenfalls nirgends.

**Folge:** `CSumList::GetTail()` hat **null Aufrufer**. Kein Code stuetzt sich
also auf das falsche Verhalten - die Korrektur kann nichts brechen, und sie
raeumt eine Falle weg, in die der naechste Aufrufer sonst blind hineingelaufen
waere. Der Befund war damit **heute harmlos, aber scharf gestellt**.

Zusaetzliches Indiz, dass es sich wirklich um einen Tippfehler und nicht um
Absicht handelt: die drei Schwesterklassen `CTocDocList`, `CNicknameList` und
`CFilterList` sind zeichengleich aufgebaut und rufen alle sechs richtig
`CObList::GetTail()`. Nur `summary.h` weicht ab.

**Geaendert:** `Eudora71/Eudora/summary.h` Z. 507 und 509, je
`m_ObList.GetHead()` -> `m_ObList.GetTail()`. Beide Ueberladungen sind damit
typkorrekt: die nicht-`const`-Fassung bindet an das `CObject*&`, das
`CObList::GetTail()` liefert, die `const`-Fassung nimmt den `CObject*` als Wert.

---

## N2 - erledigt und nachgemessen

**Geaendert:** `Eudora71/PlaylistClient/plstclnt_dll/plist_mgr.cpp:176`,
`int get_entry_info(...)` -> `static int get_entry_info(...)`.

Die Definition in Z. 1571 bleibt bewusst `int get_entry_info(...)` ohne
Speicherklasse - genau wie im Original 7.1. Eine Definition ohne Speicherklasse
uebernimmt die Bindung der vorangegangenen Deklaration; Deklaration und
Definition stimmen also im Rueckgabetyp ueberein, und der urspruengliche
default-int-Uebersetzungsfehler kehrt nicht zurueck.

**Nachgemessen statt vermutet:** `dumpbin /SYMBOLS` auf dem frisch erzeugten
`plist_mgr.obj` zeigt

    ?get_entry_info@@YAHPAUPrivCacheStruct@@PAUEntry@@PAPAUENTRY_INFO@@@Z   Static

- `Static`, nicht `External`. Die interne Bindung ist tatsaechlich wieder da.
Der Uebersetzer gibt dabei kein `C4211` und keine sonstige Warnung aus.

---

## N4 - erledigt, anders als vorgeschlagen

Der Vorschlag im Befund war, den Waechter in `EuMemMgr/Include/MiniDump.h`
umzubenennen. Das ist hier nicht der Weg: die Datei gehoert einem fremden
Teilprojekt (BugslayerUtil), und eine Umbenennung dort wuerde jede andere
Uebersetzungseinheit mitreissen, die sie einbindet.

Stattdessen ist die Zerbrechlichkeit **in der betroffenen Datei selbst**
beseitigt. `Eudora71/Eudora/ExceptionHandler.cpp` Z. 32-34 lautet jetzt:

    #include <minidumpapiset.h>
    #undef _MINIDUMP_H
    #include "MiniDump.h"

Der SDK-Header wird also ausdruecklich zuerst geholt, bevor sein Waechter
geloescht wird. Damit haengt die Sache nicht mehr daran, ob `stdafx.h` ihn
zufaellig schon vorher gebracht hat.

**Warum das kein Nebenwirkungsrisiko traegt:** `minidumpapiset.h` beginnt mit
`#pragma once` (Z. 3-5, vor dem `#ifndef _MINIDUMP_H`). Solange `stdafx.h` ihn
schon eingebunden hat - und das tut sie heute - ist die neue Zeile ein reiner
Nulleingriff; der Uebersetzer oeffnet die Datei gar nicht erst. Kehrt sich die
Reihenfolge irgendwann um, zieht die Zeile den Header herein und die SDK-Typen
sind da. In beiden Faellen richtig.

Der bestehende Erklaerkommentar in Z. 27-31 ist um diesen Punkt ergaenzt worden.
Die Zeilenzahl der Datei ist unveraendert.

`ExceptionHandler.cpp` uebersetzt danach fehler- und warnungsfrei.

---

## N5 - geprueft: die Aenderung war noetig, sie bleibt

Der Befund vermutete, die Aenderung koennte noetig gewesen sein. **Sie war es.**
Nachgesehen wurde beides:

1. `CAtlBaseModule` in
   `VC/Tools/MSVC/14.38.33130/atlmfc/include/atlcore.h:280` hat **kein** Element
   `m_bNT5orWin98` mehr. Das Feld war ein Win9x/NT4-Erbstueck und ist mit dem
   Ende der Win9x-Unterstuetzung aus der ATL geflogen.
2. Im gesamten Baum `Eudora71/` kommt `m_bNT5orWin98` **nirgends** vor, es gibt
   also auch keine projekteigene Ersatzdefinition.

Der urspruengliche Rumpf `return( _AtlBaseModule.m_bNT5orWin98 );` haette unter
v143 schlicht nicht uebersetzt. `return( TRUE )` ist auf dem Zielsystem
Windows 10 zudem sachlich das richtige Ergebnis. **Nichts zurueckzunehmen.**

Nebenbefund zur Herkunft: die Aenderung stammt nicht aus dem Zweig
`vs2022-portierung-fixes`, sondern schon aus `ba3d2ee` und liegt damit bereits
in `main` - `git diff main -- Eudora71/Eudora/atlimage.h` ist leer.

**Geaendert:** nur Dokumentation, und zwar **in der Datei selbst**, weil sie am
ehesten dort gefunden wird, wo jemand sie braucht - naemlich beim Vergleich mit
dem SDK-eigenen Header. `Eudora71/Eudora/atlimage.h` Z. 1537 traegt jetzt eine
`ABWEICHUNG`-Notiz mit dem Originalrumpf, dem Grund und dem Hinweis, dass sie
bei einem Umstieg auf den SDK-Header wegfaellt; Z. 1541 verweist darauf.
Zeilenzahl unveraendert.

**Offen und ausdruecklich nicht von mir erledigt:** der Eintrag in
`PORTIERUNG.md`. Die Datei liegt bei LEKTOR; sie erwaehnt `atlimage.h`,
`IsTransparencySupported` und `m_bNT5orWin98` bisher an keiner Stelle.

**Ausserdem beachtenswert fuer LINKER:** zwei der offenen Bindefehler,
`ATL::CImage::s_initGDIPlus` und `ATL::CImage::s_cache`, stammen aus genau
diesem `atlimage.h` (angezogen ueber `QCGraphics.obj`). Die mitgelieferte Kopie
deklariert die beiden statischen Elemente, aber keine Uebersetzungseinheit
definiert sie. Das ist ein eigenstaendiger Punkt, nicht Teil von N5.

---

## N8 - geprueft, nichts geaendert; die Tabelle stimmt nicht mehr ganz

Auftragsgemaess wurde nur geprueft. Alle zehn Stellen wurden geoeffnet und bis
zur Herkunft des beschriebenen Puffers zurueckverfolgt.

**Ergebnis vorweg: keine einzige Stelle schreibt in einen tatsaechlich
schreibgeschuetzten Puffer.** Nichts zu melden, nichts zu aendern. Die Bewertung
"originalgetreu" im Befund bleibt richtig.

Drei Korrekturen an der Tabelle - dort stehen Stellen als Schreibzugriff, die
keiner sind:

| Stelle | Tabelle sagt | Tatsaechlich |
|---|---|---|
| `statbar.cpp:233` | "Puffer wird umgeschrieben" | **Kein Schreibzugriff.** `Newline` wird nur getestet (Z. 234) und fuer die Differenz `Newline - lParam` benutzt (Z. 238). Kopiert wird mit `strncpy` in ein lokales `char Buffer[128]`; `lParam` selbst bleibt unberuehrt. |
| `html2text.cpp:981` | "`szCurrent + 1` ohne NULL-Pruefung" | **Kein Schreibzugriff.** Der Mangel ist echt, aber ein anderer: Z. 984 rechnet `szStart = szCurrent + 1` **vor** der NULL-Pruefung in Z. 986. Das ist Zeigerarithmetik auf einem Nullzeiger - formal undefiniert, praktisch folgenlos, weil der Wert nach dem `break` nicht mehr gelesen wird. Gehoert nicht in die `const_cast`-Familie. |
| `mapicmc.cpp:171` | Schreibzugriff auf `pszNewline` | **Ueberholt.** Die Stelle ist inzwischen auf eine rein lesende Fassung umgebaut, mit Kommentar: `pszData` zeigt bei `WM_COPYDATA` in fremden Prozessspeicher. Dort steht kein `const_cast` mehr. |

Es bleiben **sieben** echte Schreibzugriffe. Fuer jeden wurde der Aufrufweg bis
zum Ursprung des Puffers verfolgt:

| Stelle | Puffer kommt von | Bewertung |
|---|---|---|
| `mainfrm.cpp:4849` (`GetAttachmentLine`) | zwei Wege: `CWinApp::m_lpCmdLine` (`eudora.cpp:1636`) - beschreibbar; und `OnCopyData` (`mainfrm.cpp:4904`), das den fremden `WM_COPYDATA`-Block **vorher in ein eigenes `DEBUG_NEW char[]` kopiert** | unbedenklich; der gefaehrliche Fall ist bereits abgefangen |
| `Trnslate.cpp:4194` (`XLateDisplay`) | `PgHLinks.cpp:340` uebergibt ein lokales `char url[1024]` | unbedenklich |
| dieselbe Stelle | `TridentView.cpp:2840` uebergibt eine `CString szHRef` | siehe unten |
| `TridentPreviewView.cpp:352` | lokale `CString szFullMessage` (Z. 287) | siehe unten |
| `tocdoc.cpp:2173/2174` | lokale `CString ConvertedBody` (Z. 2128) | siehe unten |
| `Convhtml.cpp` (`BuildURIMap`, Schreibzugriffe in Z. 527/537/540/613) | `Trnslate.cpp:4470` uebergibt ein eigenes `DEBUG_NEW char[]`; `Trnslate.cpp:4296` und `TocFrame.cpp:1672` uebergeben eine `CString`; die Schreibzugriffe setzen den alten Wert unmittelbar wieder ein | siehe unten |
| `PaigeEdtView.cpp:2522` | lokales `char url[INTERNET_MAX_URL_LENGTH]` (Z. 2506) | unbedenklich |

**Die verbleibende Gemeinsamkeit ist enger als der Befund sie fasst:** vier der
sieben Stellen schreiben durch `CString::operator LPCTSTR` in den internen
Puffer einer `CString`, ohne vorher `GetBuffer()` zu rufen. Das ist kein
Speicherschutzverstoss - der Puffer liegt im Heap und ist beschreibbar - aber es
umgeht das Copy-on-Write von `CStringT`: teilt sich die `CString` ihre Daten
gerade mit einer zweiten (Referenzzaehler groesser 1), aendern sich beide. Der
Sonderfall des global geteilten Leerstring-Objekts kann nicht auftreten, weil
`strchr`/`strstr` auf einer leeren Zeichenkette NULL liefern und gar nicht erst
geschrieben wird.

Das gilt fuer VC6 genauso - auch dessen `CString` war referenzgezaehlt mit
Copy-on-Write. **Die Portierung hat hier also nichts verschlechtert.** Der
richtige Zeitpunkt fuer eine Bereinigung ist weiterhin der naechste inhaltliche
Umbau dieser Funktionen, so wie der Befund es vorschlaegt: Parameter auf `char*`
ziehen und die Aufrufer mit `GetBuffer()`/`ReleaseBuffer()` nachziehen.

---

# Nachpruefung 3 durch PRUEFER (30.08.2026, Branch `eudora-exe-linkt`)

**Bezugscommit:** `22a6d77` (Merge von `vs2022-portierung-fixes` nach `main`);
gelesen wurde der Dateistand dieses Commits. Waehrend der Pruefung haben andere
Agenten weitergearbeitet - `Eudora.vcxproj` war dabei mehrfach im Fluss und ist
deshalb ausdruecklich NICHT Gegenstand dieses Abschnitts.

**Auftrag:** genau die Bereiche, die die Nachpruefung 2 offen gelassen hat -
Stufe 2/2b der Ersatzschicht (`OTShim.{h,cpp}`), die Registerkartenfamilie
(`OTShim_Reiter.{h,cpp}`), Stufe 4 (`OTShim_Bild.{h,cpp}`), `SECDateTimeCtrl`
(`OTShim_Palette.{h,cpp}`) und die Werkzeuge unter `tools/`.

**Nicht Gegenstand:** Hostnamenpruefung und `X509_V_ERR_CERT_UNTRUSTED`
(bewusst zurueckgestellt), Stil/Formatierung/Namensgebung, die Dokumentation.

**Stand dieses Abschnitts: Zwischenstand.** Was schon durch ist und was noch
offen ist, steht unten unter "Stand der Nachpruefung 3".

---

## NP2-1 ist ueberholt

`OTShim_Werkzeugleiste.cpp`, `OTShim_Reiter.cpp` und `OTShim_Palette.cpp`
stehen seit `e50a89c` in `Eudora.vcxproj:217`, jeweils mit
`<PrecompiledHeader>NotUsing</PrecompiledHeader>`, und `OTShimAll.h` bindet die
zugehoerigen Header ein. Der Befund "Stufe 3 haengt nirgends" ist damit
erledigt.

---

## NP3-1 - `ZeigeInhaltsfenster` laeuft, bevor Eudora das Fenster umgehaengt hat

**Sicherheit: im Code nachgewiesen; Auswirkung Verdacht (nur sichtbar, nicht
funktional)**

**Dateien:** `Eudora71/OTShim/OTShim_Reiter.cpp:1500-1503`
(`SECTabWndBase::InsertTab`) gegen `Eudora71/Eudora/WazooBar.cpp:124-185`
(`CWazooBar::AddWazooWindow`).

`AddWazooWindow` legt das Wazoo-Fenster als sichtbares Kind des HAUPTFENSTERS
an (`WazooBar.cpp:1003` - `Create(..., WS_CHILD|WS_VISIBLE, ..., ::AfxGetMainWnd(), ...)`)
und haengt es erst NACH `AddTab`/`InsertTab` um:

    pNewTab = m_wndTab.AddTab(pWazooWnd, pWazooWnd->GetTabLabel());
    ...
    m_wndTab.SetTabIcon(nTabIndex, pWazooWnd->GetTabIconHandle());
    pWazooWnd->ModifyStyle(0, WS_CHILD);
    pWazooWnd->SetParent(&m_wndTab);          // erst hier

Der Shim ruft beim ERSTEN Reiter mitten darin `ZeigeInhaltsfenster(nNeu)` auf.
Das setzt `m_pActiveWnd`, ruft `RecalcLayout()` - das das Fenster per
`DeferWindowPos` auf `rcInnen` setzt, also auf Koordinaten des noch gar nicht
zustaendigen Elternfensters - und macht es anschliessend mit `SW_SHOW` sichtbar.

**Folge:** das Wazoo-Fenster steht fuer die Dauer weniger Anweisungen an einer
falschen Stelle im Hauptfenster. Danach zieht der naechste `RecalcLayout`
(ueber `CWazooBar::OnSize` oder `SetActiveWazooWindow`) es zurecht. Beim zweiten
und jedem weiteren Reiter tritt der Fall nicht auf, weil dann der `else`-Zweig
mit `ShowWindow(SW_HIDE)` greift. Es bleibt also hoechstens ein Aufblitzen beim
Start; ein Datenfehler entsteht nicht.

**Zu tun:** in `SECTabWndBase::InsertTab` den ersten Reiter nur vormerken
(`m_pActiveWnd` setzen) und das Zeigen dem ersten `ActivateTab` bzw.
`RecalcLayout` ueberlassen - oder `ZeigeInhaltsfenster` nur ausfuehren, wenn
`pWnd->GetParent() == this` gilt.

---

## NP3-2 - `SEC3DTabControl::OnToolHitTest` ist als `int` deklariert

**Sicherheit: nachgewiesen. Heute kein Fehler.**

**Datei:** `Eudora71/OTShim/OTShim_Reiter.h:570` und
`Eudora71/OTShim/OTShim_Reiter.cpp:1032`.

    virtual int OnToolHitTest(CPoint point, TOOLINFO* pTI) const;

`CWnd::OnToolHitTest` ist in MFC 14 als `virtual INT_PTR` deklariert
(`afxwin.h:2429`). Unter Win32 ist `INT_PTR` gleich `int`, beide Deklarationen
bezeichnen also dieselbe virtuelle Funktion - deshalb uebersetzt es. `OTShim.h`
begruendet an zwei anderen Stellen (`SECControlBar::OnToolHitTest` Z. 572-577,
`SECWorkbook::OnToolHitTest` Z. 1454-1460) ausdruecklich, warum dort `INT_PTR`
steht; hier ist es nicht nachgezogen worden.

**Folge:** keine, solange Win32 gilt. Bei einem x64-Bau waere es C2555
(Ueberschreibung mit abweichendem Rueckgabetyp) - immerhin ein lauter Fehler,
kein stiller. Derselbe Sperrgrund wie Befund N1.

**Zu tun:** auf `INT_PTR` ziehen, wie an den beiden anderen Stellen.

---

## NP3-3 - Der Kommentar zu `CreateFromBitmap` zaehlt die Aufrufstellen falsch

**Sicherheit: nachgewiesen. Der Code ist richtig, nur die Begruendung stimmt
nicht.**

**Datei:** `Eudora71/OTShim/OTShim_Bild.h:326-328`

> "Die Quellbitmap ist an drei von fuenf Stellen im uebergebenen DC ausgewaehlt:
> QCToolBarManager.cpp:420/421, 433/434, 446/447 und QCGraphics.cpp:167/226"

Nachgezaehlt sind es **neun** Aufrufstellen (Zeile 322 derselben Datei zaehlt
sie selbst korrekt auf), und ausgewaehlt ist die Quellbitmap an **sechs** davon:

| Aufrufstelle | Quellbitmap im DC ausgewaehlt? | Beleg |
|---|---|---|
| `QCGraphics.cpp:226` | ja | `:167` `cdc.SelectObject(&Bitmap)` |
| `QCGraphics.cpp:258` | nein | `cdc.CreateCDC()` ohne Auswahl |
| `QCGraphics.cpp:615` | nein | frischer `CreateCompatibleDC(NULL)` |
| `LinkHistoryManager.cpp:1249` | nein | `:1242` `cdc.SelectObject(pSavePrevBitmap)` loest vorher |
| `QCToolBarManager.cpp:421` | ja | `:420` `theSrcDC.SelectObject(&m_bmp)` |
| `QCToolBarManager.cpp:434` | ja | `:433` `theSrcDC.SelectObject(theBitmapA)` |
| `QCToolBarManager.cpp:447` | ja | `:446` `theSrcDC.SelectObject(theBitmapB)` |
| `QCToolBarManager.cpp:569` | ja | `:559` `pBmpOldSrc = theSrcDC.SelectObject(&m_bmp)` |
| `QCToolBarManager.cpp:582` | ja | `:581` `theSrcDC.SelectObject(theNewButtonBitmap)` |

Die Umsetzung ist davon unberuehrt - sie prueft den Zustand zur Laufzeit mit
`::GetCurrentObject(hdc, OBJ_BITMAP)` und behandelt beide Faelle. Nur die
Zahlenangabe im Kommentar ist falsch und laesst die beiden Stellen 569/582
aussehen, als seien sie geprueft und unkritisch.

**Zu tun:** die Zahl im Kommentar berichtigen (sechs von neun).

---

## Geprueft und in Ordnung (Nachpruefung 3)

### Stufe 2 - die zweite Andockleiste von `SECMiniDockFrameWnd`

Das war der Hauptpunkt des Auftrags: `SECMiniDockFrameWnd` haelt neben der von
`CMiniDockFrameWnd` geerbten `m_wndDockBar` (`CDockBar`, `afxpriv.h:664`) eine
eigene `m_wndSECDockBar` (`SECDockBar`). **Beide bleiben konsistent, auch beim
Zerstoeren.** Nachgemessen, nicht vermutet:

- **Alle** Stellen, an denen MFC `m_wndDockBar` anfasst, sind ueberschrieben.
  Gemessen mit `grep -n m_wndDockBar` ueber `atlmfc/src/mfc/*.cpp` (MSVC
  14.38.33130): `bardock.cpp:798` (Baumeister), `:800` (`m_bAutoDelete`),
  `:844/852` (`Create`), `:866` (`RecalcLayout`), `:873` (`OnClose`),
  `:884-913` (`OnNcLButtonDown`), `:928-933` (`OnNcLButtonDblClk`). Genau diese
  sechs Methoden ersetzt der Shim, und alle drei Nachrichtenbehandler stehen in
  `BEGIN_MESSAGE_MAP(SECMiniDockFrameWnd, ...)` (`OTShim.cpp:3002-3007`), fangen
  die Nachricht also vor der Basisklasse ab. `OnMouseActivate` ist die einzige
  nicht ueberschriebene Methode von `CMiniDockFrameWnd` - und sie fasst
  `m_wndDockBar` nicht an. Die Behauptung im Kopf von `OTShim.h:916-920` stimmt
  also wortgenau.
- **Der Zugriff von aussen laeuft ueber die Kennung, nicht ueber den
  Datenmember.** `CFrameWnd::FloatControlBar` (`winfrm2.cpp:202`) und
  `CFrameWnd::SetDockState` (`dockstat.cpp:476`) holen die schwebende
  Andockleiste mit `pDockFrame->GetDlgItem(AFX_IDW_DOCKBAR_FLOAT)`. Der Shim
  legt `m_wndSECDockBar` unter genau dieser Kennung an (`OTShim.cpp:3067-3068`),
  MFC findet also die richtige.
- **`m_wndDockBar` bekommt nie ein Fenster.** Damit ist sie in keiner
  Leistenliste (`CControlBar::OnCreate`, `barcore.cpp:554-566`, meldet die
  Leiste erst beim Anlegen beim Rahmen an), taucht in keinem `GetDlgItem` auf
  und hat beim Abraeumen nichts zu tun: `CWnd::~CWnd` findet `m_hWnd == NULL`,
  und `m_bAutoDelete` ist von `CMiniDockFrameWnd::CMiniDockFrameWnd` auf
  `FALSE` gesetzt. Fuer `m_wndSECDockBar` setzt der Shim dasselbe
  (`OTShim.cpp:3016`) - richtig, denn der Zerstoerungsweg
  `CDockBar::RemoveControlBar` nach `pFrameWnd->DestroyWindow()`
  (`bardock.cpp:342-347`) fuehrt ueber `CFrameWnd::PostNcDestroy` auf
  `delete this`, und das Wertfeld darf sich nicht zusaetzlich selbst freigeben.
- **Eudora zieht mit.** `QCMiniDockFrameWnd` (`workbook.cpp:539, 574`) ersetzt
  beide `RecalcLayout`-Fassungen vollstaendig und liest darin ausschliesslich
  `m_wndSECDockBar`; `Create`, `OnClose`, `OnNcLButtonDown` und
  `OnNcLButtonDblClk` ueberschreibt es nicht, es laufen also die Fassungen des
  Shims. Gegenprobe: `grep -rn "m_wndDockBar|m_wndSECDockBar"` ueber `Eudora71`
  ausserhalb von `OTShim/` liefert nur `workbook.cpp` - die
  `m_wndDockBar`-Treffer dort (`:371, :373, :457, :459`) gehoeren zu
  `QCControlBarWorksheet`, also zum gleichnamigen Wertfeld von
  `SECControlBarWorksheet`, das eine andere Klasse ist.
- **Kleiner Unterschied ohne Folge:** MFC laeuft in `OnNcLButtonDown` und
  `OnNcLButtonDblClk` ab `nPos = 1` durch `m_arrBars`, der Shim beginnt in
  `GetFirstDockedBar` bei 0. `CDockBar::CDockBar` legt an Index 0 immer ein
  `NULL` an (`bardock.cpp:35`), und keine Einfuegeoperation ueberschreibt es
  (`DockControlBar` haengt an, `Insert` und `SetBarInfo` beginnen bei 1).
  `GetDockedControlBar(0)` liefert also stets `NULL`; die Schleifen sind
  gleichwertig.
- **Zusatz gegenueber MFC, absichtlich:** wo MFC `ENSURE_VALID(pBar)` und
  `ENSURE(pBar->m_pDockContext != NULL)` schreibt, prueft der Shim und faellt
  auf `CMiniFrameWnd::OnNcLButtonDown` zurueck. Das ist strikt vertraeglicher
  als das Original.

### Stufe 2 - uebriger Teil der Andockfamilie

- **`SECControlBar::GetBarInfo`/`SetBarInfo`** sind fuer die einzige
  Aufrufstelle (`WazooBarMgr.cpp:432-436`, Andockhoehe der Task-Leiste auf 80
  setzen) verlustfrei: `GetBarInfo` legt alle elf SEC-Felder ab und ruft danach
  `GetBarInfoEx`, `SetBarInfo` liest sieben davon zurueck. Dass `m_dwStyle` und
  `m_dwDockStyle` bewusst NICHT zurueckgeschrieben werden, ist richtig -
  `CControlBar::SetBarInfo` (`dockstat.cpp:584-616`) fasst genau diesen Zustand
  gleich danach selbst an.
- **`SECDockBar`, Zeilenlogik.** `GetControlBarRow`, `IsOnlyControlBarInRow`,
  `BarIsNewToThisRow`, `GetRowHeight`, `InvalidateToRow` und `NormalizeRow`
  suchen den Zeilenanfang alle nach demselben Muster (rueckwaerts bis vor die
  naechste NULL-Marke) und brechen vorwaerts an der naechsten NULL ab. Alle
  sechs sind gegen `nPos < 0 || nPos >= GetSize()` geschrankt, und die
  Rueckwaertssuche kann wegen des NULL an Index 0 nicht unter 1 fallen. Die
  Platzhalter (Werte bis 0xffff) werden ueber `GetDockedControlBar`
  ausgefiltert. Kein Zugriff ueber das Feldende gefunden.
- **`SECDockBar`, Splitter und Innenkanten.** `AddSplitter`/`AddClientEdge`
  verwenden freie Eintraege wieder, `EndRecycleSplitters`/`EndRecycleEdges`
  raeumen rueckwaerts auf (richtig, weil `RemoveAt` nachfolgende Plaetze
  verschiebt), `DeleteAllSplitters`/`DeleteAllEdges` geben frei und leeren.
  Destruktor und `OnDestroy` rufen beide `DeleteAllSplitters`/`DeleteAllEdges`;
  weil beide danach `RemoveAll()` machen, ist die zweite Runde leer - keine
  Doppelfreigabe.
- **`SECControlBar::OnContextMenu`** laedt seine Beschriftungen mit
  `strItem.LoadString(ID_SEC_ALLOWDOCKING)` usw. Nachgesehen: `SECRES.H:189-191`
  vergibt die Kennungen 53288 bis 53290, `SECRES.RC:412-414` traegt genau diese
  drei in eine STRINGTABLE ein, und `EudoraRes.rc:11712` bindet `secres.rc` in
  einem `#ifndef APSTUDIO_INVOKED`-Block ein, der beim Bau durchlaufen wird. Die
  Zeichenketten sind zur Laufzeit also da.
- **`SECControlBar::DeleteLayoutInfo`** ist gegen Mehrfachaufruf sicher
  (`m_pArrLayoutInfo` wird auf NULL gesetzt); Destruktor und `OnDestroy` rufen
  es beide.
- **Stufe 2b** (`SECFrameWnd`, `SECDockState`, `SECControlBarInfo(Ex)`,
  `SECControlBarManager`, `SECDockContext`) besteht fast nur aus
  Durchreichungen an die MFC-Gegenstuecke. Zwei Stellen mit Inhalt geprueft:
  `SECControlBarInfo::~SECControlBarInfo` gibt `m_pBarInfoEx` frei (der
  Erzeuger ist `CreateControlBarInfoEx`, der Besitz liegt also wirklich hier),
  und `SECFrameWnd::OnActivate` pflegt `m_bActive`, das `GetActiveState()` nach
  aussen reicht. `SECFrameWnd::dwSECDockBarMap` ist feldgleich mit
  `SECMDIFrameWnd::dwSECDockBarMap` und mit `CFrameWnd::dwDockBarMap`
  (`winfrm2.cpp:18-24`) - genau das verlangt `CMainFrame::EnableDocking`
  (`mainfrm.cpp:2156-2173`), sonst entstuenden acht statt vier Andockleisten.

### Registerkarten - die Punkte aus dem Kommentarkopf

- **Der Ringlauf `ActivateTab` - `TCM_TABSEL` - `OnTabSelect` - `ActivateTab`
  ist wirklich aufgeloest**, und zwar doppelt abgesichert:
  1. `SECTabWndBase::OnTabSelect` (`OTShim_Reiter.cpp:1793-1810`) ruft
     `ZeigeInhaltsfenster` und NICHT `ActivateTab`; es meldet nichts an das
     Steuerelement zurueck.
  2. Selbst wenn es das taete, setzt `SECTabControlBase::ActivateTab` den
     aktiven Reiter mit `SetActiveTabQuiet` **vor** `OnActivateTab`, und der
     Wiedereintritt liefe in die Abbruchbedingung
     `if (m_bActiveTab && m_nActiveTab == nTab) return;`.
  Die Gegenprobe auf Eudoras Seite stimmt ebenfalls: `CWazooBar::OnTabSelect`
  (`WazooBar.cpp:1490-1530`) setzt nur Fenstertitel und Symbol und ruft
  `ActivateTab` nicht.
- **Es wird wirklich kein fremdes Fenster zerstoert.** `SECTabWndBase::RemoveTab`
  zerstoert nur, was in `m_arrEigeneFenster` steht, also nur ueber `CreateView`
  selbst erzeugte Fenster; `~SECTab` und `~SEC3DTab` fassen `m_pClient` und
  `m_hIcon` nicht an. Das passt zu `CWazooBar::RemoveWazooWindow`
  (`WazooBar.cpp:196-210`), das direkt nach `RemoveTab` mit
  `ASSERT(::IsWindow(pWazooWnd->GetSafeHwnd()))` prueft, dass das Fenster noch
  lebt. `SECTabWndBase::OnDestroy` fasst die Inhaltsfenster ebenfalls nicht an -
  richtig, denn `CWazooBar::OnDestroy` (`WazooBar.cpp:1197-1225`) hat sie zu
  diesem Zeitpunkt schon zerstoert und geloescht (WM_DESTROY erreicht das
  Elternfenster vor den Kindern).
- **Das Loeschen der Reiter ueber den `CObject`-Zeiger ist zulaessig.**
  `~SECTab` ist wie im Original geschuetzt, aber `CObject::~CObject` ist
  oeffentlich und virtuell; die Zugriffspruefung greift an `CObject`, die
  Ausfuehrung landet bei `~SECTab`. Kein Speicherleck, kein Zugriffsfehler.
- **Kein doppeltes Loeschen der Reiterliste.** `SECTabControlBase::OnDestroy`
  loescht die Reiter und ruft `RemoveAll()`; der Destruktor laeuft danach ueber
  ein leeres Feld. `SECTabWndBase::OnDestroy` loescht `m_pTabCtrl` und setzt es
  auf NULL, der Destruktor findet nichts mehr vor.
- **Der Kurzhinweis-Puffer ist richtig verwaltet.** `OnToolHitTest` legt den
  Text mit `_tcsdup` an; MFC gibt ihn in `CWnd::_FilterToolTipMessage`
  (`tooltip.cpp:501-502`) mit `free(tiHit.lpszText)` wieder frei, und zwar
  genau unter der Bedingung `tiHit.hinst == 0` - die erfuellt ist, weil MFC die
  Struktur vorher mit `memset` nullt (`tooltip.cpp:433`). Passendes
  Allokator-Paar, kein Leck.
- **`EnableToolTips` vor dem Anlegen des Fensters ist unbedenklich.**
  `SECTabControlBase::Create` ruft `Initialize` vor `CWnd::Create`, und
  `SEC3DTabControl::Initialize` ruft `EnableToolTips(TRUE)`.
  `CWnd::_EnableToolTips` (`tooltip.cpp:303-345`) setzt im Einschaltfall nur
  `m_nFlags |= WF_TOOLTIPS` und einen Modulzeiger - kein `m_hWnd` noetig.
- **Alle Reiterzugriffe sind geschrankt.** `GetTabPtr` prueft ueber
  `TabExists(nTab)`, und jede Stelle, die einen Reiter anfasst, geht ueber
  `GetTabPtr` und prueft auf NULL. `SetActiveTabQuiet` setzt `m_nActiveTab` auf
  -1, sobald der Index aus dem Bereich faellt; `InsertTab` und `DeleteTab`
  ziehen den Index richtig nach (nachgerechnet fuer Einfuegen vor und hinter dem
  aktiven Reiter und fuer Loeschen des letzten Reiters).

### Stufe 4 - `SECImage::CreateFromBitmap`

**Die Frage des Auftrags war, ob die Bitmapauswahl auf allen Rueckgabepfaden
wiederhergestellt wird. Ja.** `OTShim_Bild.cpp:1120-1209` hat nach dem Loesen
der Auswahl (Z. 1164-1171) **keinen einzigen weiteren `return`**: die beiden
Fehlerfaelle (`OTShimDibAnlegen` scheitert, `::GetDIBits` liefert 0) setzen
`bErfolg = FALSE` und fallen durch den gemeinsamen Ausgang Z. 1198-1208, der
erst `::SelectObject(hdc, hQuelle)` zuruecksetzt, dann die Platzhalter-Bitmap
loescht und zuletzt einen selbst angelegten DC freigibt. Die drei frueheren
`return FALSE` (Z. 1130, 1138, 1152) liegen alle **vor** der ersten
Zustandsaenderung. Auch der Fall "`::CreateBitmap` fuer den Platzhalter
scheitert" ist abgefangen: dann wird `bWarAusgewaehlt` auf FALSE gesetzt, der
Ausgang laesst den DC also in Ruhe.
Der zweite Zweck der Methode ist ebenfalls erfuellt: `OTShimDibAnlegen` ruft als
erstes `OTShimDibFreigeben()`, der Mehrfachaufruf auf demselben Objekt
(`QCToolBarManager.cpp:421/434/447` und `:569/582`) leckt also nicht.

### `SECDateTimeCtrl`

**Die Frage des Auftrags war, ob das Nachtragen der Formatzeichenkette
zuverlaessig greift. Ja.** Der einzige Weg in Eudora ist
`SearchView.cpp:1565-1566`: `SetFormat("MMMM d, yyyy")` vor
`AttachDateTimeCtrl`. `SetFormat(LPCTSTR)` legt die Zeichenkette in
`m_strCustomFormat` ab und ruft `ApplyFormat()`, das ohne Fenster sofort
zurueckkehrt. `AttachDateTimeCtrl` ruft `CreateEx` (das seinerseits schon
`ApplyFormat()` ruft) und danach noch einmal `ApplyFormat()` - der zweite Aufruf
ist ueberfluessig, aber harmlos. Es gibt keinen Weg, auf dem ein Fenster
entsteht, ohne dass danach `ApplyFormat` liefe: `Create`, `CreateEx` und
`AttachDateTimeCtrl` tun es alle drei.
Zwei Nebenpunkte mitgeprueft:
- Das fehlende `WS_VISIBLE` im Vorgabewert `dwWinStyles = WS_CHILD|WS_TABSTOP`
  ist **kein Fehler**: der Vorgabewert ist wortgleich mit dem Original
  (`DTCtrl.h:85-87`), und `CSearchView` schaltet die Sichtbarkeit selbst
  (`SearchView.cpp:1076` und `:2230`).
- Das Wegraeumen des Platzhalters (`pPlaceholder->DestroyWindow()`) ist richtig:
  der Platzhalter ist die oertliche `CEdit TempEdit` aus
  `SearchView.cpp:1557-1561`, `GetDlgItem` liefert genau dieses Objekt aus der
  staendigen Fensterzuordnung, und `DestroyWindow` setzt dessen `m_hWnd` auf
  NULL - der spaetere Zerstoerer von `TempEdit` findet nichts mehr vor.

---

## Nebenbefund im Eudora-Originalcode

`Eudora71/Eudora/SearchView.cpp:1567` schreibt

    m_DateTimeCtrl->SetFont(pFont);

statt `m_DateTimeCtrl[nIdx].SetFont(pFont)`. Damit bekommt bei jedem Durchlauf
immer nur das Feld mit Index 0 die Schrift gesetzt; die uebrigen
Steuerelemente behalten die Systemvorgabe. Die beiden Nachbarzeilen (`:1565`,
`:1566`) indizieren korrekt. **Kein Portierungsfehler** - die Zeile steht in
`main` genauso. Nur der Vollstaendigkeit halber festgehalten; die Auswirkung ist
eine abweichende Schrift, sonst nichts.

---

## Stand der Nachpruefung 3

**Durch (Zeile fuer Zeile gelesen):**

- `OTShim/OTShim.h` vollstaendig (1614 Zeilen).
- `OTShim/OTShim.cpp` Z. 175-540 (`SECMDIFrameWnd`), Z. 1229-1334
  (`SECControlBarWorksheet`), Z. 1336-3881 (Stufe 2 und 2b vollstaendig).
- `OTShim/OTShim_Reiter.h` vollstaendig (753 Zeilen).
- `OTShim/OTShim_Reiter.cpp` vollstaendig (2172 Zeilen).
- `OTShim/OTShim_Bild.cpp` `CreateFromBitmap` und `OTShimDibAnlegen`.
- `OTShim/OTShim_Palette.cpp` `SECDateTimeCtrl`, Erzeugungs- und Formatteil
  (Z. 30-260).
- Gegengelesen in Eudora: `WazooBar.cpp` (Reiterpflege, `OnDestroy`,
  `OnTabSelect`), `WazooBarMgr.cpp` (Andockaufbau), `DockBar.cpp`,
  `workbook.cpp` (`QCControlBarWorksheet`, `QCMiniDockFrameWnd`),
  `QC3DTabWnd.cpp` (`ActivateTab`, `OnLButtonDown`), `QCToolBarManager.cpp`
  und `QCGraphics.cpp` (Aufrufstellen von `CreateFromBitmap`),
  `SearchView.cpp` (`SECDateTimeCtrl`).
- Gegengelesen in MFC 14.38.33130: `bardock.cpp`, `dockstat.cpp`,
  `winfrm2.cpp`, `barcore.cpp`, `tooltip.cpp`.

**Noch offen:**

| Gegenstand | Grund |
|---|---|
| `OTShim/OTShim.cpp` Z. 1-175 und Z. 540-1229 (Stufe 0 und Stufe 1) | in der ersten Runde bereits unter "OTShim, uebriger Teil" geprueft; hier nur ueberflogen |
| `OTShim/OTShim_Bild.{h,cpp}` ausserhalb von `CreateFromBitmap` (rund 2000 Zeilen: Laden, Speichern, Farbtafel, GDI+-Anbindung) | noch nicht begonnen |
| `OTShim/OTShim_Palette.{h,cpp}` ausserhalb von `SECDateTimeCtrl` | noch nicht begonnen |
| `tools/lehren-spiegeln.pl`, `tools/pruefstand-melden.pl` | noch nicht begonnen |
| `OTShim_Werkzeugleiste`: Anordnungsrechnung, `SECTwoPartBtn::DrawButton`, `SECWndBtn`/`SECComboBtn`, `SECCustomizeToolBar` | unveraendert offen aus Nachpruefung 2 |
| `Eudora.vcxproj` | war waehrend der ganzen Pruefung im Fluss (andere Agenten); eine Aussage waere schon beim Aufschreiben veraltet |

---

# Nachpruefung 3, zweiter Teil (PRUEFER) - die Werkzeuge und zwei Meldungen von TABELLE

Fortsetzung des Abschnitts "Nachpruefung 3 durch PRUEFER". Gemessen am
Arbeitsbaum vom 30.08.2026 (HEAD zu diesem Zeitpunkt: `703a3ca`). Alle Befunde
dieses Teils sind **ausgefuehrt und nachgemessen**, nicht nur gelesen.

---

## NP3-4 - `lehren-spiegeln.pl` und der Pfadangaben-Commit: die gespiegelten Dateien werden beim naechsten Commit wieder geloescht

**Sicherheit: nachgewiesen, in einem eigens angelegten Testrepo vorgefuehrt.
Schwere: hoch - es ist genau der Wissensverlust, gegen den das Werkzeug gebaut
wurde.**

**Dateien:** `tools/lehren-spiegeln.pl:89` (`git add -- Arbeitsweise`),
`.git/hooks/pre-commit`, in Verbindung mit der seit dem 30.08.2026 geltenden
Regel "immer mit ausdruecklicher Pfadangabe committen"
(`git commit -m "..." -- BEFUNDE.md`).

`git commit -- <pfade>` baut den Commit in einem **voruebergehenden** Index auf
(git setzt `GIT_INDEX_FILE` fuer die Dauer des Vorgangs um). Der pre-commit-Hook
laeuft gegen diesen voruebergehenden Index. Das hat zwei Folgen, und nur die
erste ist die erwartete:

1. **Gut:** die von `lehren-spiegeln.pl` frisch kopierten Dateien landen
   tatsaechlich im Commit. Das hatte ich zuerst anders vermutet; die Messung sagt
   etwas anderes.
2. **Schlecht:** der **richtige** Index wird dabei nie aktualisiert. Nach dem
   Commit steht die eben mitgeschriebene Datei dort als **geloescht**. Der
   naechste Commit, der den Index nicht per Pfadangabe umgeht, nimmt diese
   Loeschung mit.

Vorgefuehrt mit git 2.55.0.windows.5 in einem leeren Repo:

    # pre-commit legt Arbeitsweise/lehre.md an und ruft "git add -- Arbeitsweise"
    git commit -m "nur a" -- a.txt
      -> Commit enthaelt: Arbeitsweise/lehre.md | 1 +   und   a.txt | 2 +-
    git status --short
      -> D  Arbeitsweise/lehre.md          <== im Index als geloescht vorgemerkt
    # Hook entfernt, naechster ganz gewoehnlicher Commit:
    git commit -m "naechster commit"
      -> Commit enthaelt: Arbeitsweise/lehre.md | 1 -
    git cat-file -e HEAD:Arbeitsweise/lehre.md  ->  die Datei ist weg

**Folge:** sobald sich eine Lehre aendert, wird sie einmal gespiegelt und
mitgeschrieben - und beim uebernaechsten Commit wieder aus dem Repo entfernt,
ohne dass jemand etwas davon merkt. Der Arbeitsbaum behaelt die Datei, das Repo
verliert sie. Das ist genau der lautlose Wissensverlust, den das Werkzeug
verhindern soll, nur eine Ebene tiefer.

Zusaetzlich verschaerft: der Hook fragt den Rueckgabewert von
`lehren-spiegeln.pl` nicht ab (`.git/hooks/pre-commit` Zeile 3 steht ohne
`set -e`, danach folgt `exec perl .../pruefe-bytes.pl`). Auch die drei `die`- und
`warn`-Ausgaenge des Skripts halten den Commit deshalb nicht auf.

**Zu tun:** entweder das Spiegeln aus dem pre-commit-Hook nehmen und daraus einen
eigenen Commit-Schritt machen, oder im Hook nach dem `git add` den echten Index
nachziehen (`git add` mit gesetztem `GIT_INDEX_FILE` auf den Standardindex - z. B.
`GIT_INDEX_FILE="$(git rev-parse --git-dir)/index" git add -- Arbeitsweise`), oder
das Werkzeug so umbauen, dass es die Kopien nur anlegt und laut meldet, statt
selbst zu stagen.

---

## NP3-5 - `lehren-spiegeln.pl` ist genau im Fehlerfall stumm

**Sicherheit: nachgewiesen (Quelltext und Ausfuehrung). Heute tritt der Fall
nicht ein.**

**Datei:** `tools/lehren-spiegeln.pl:32`, `:43-47`, `:66`, `:71`

Die Pfadableitung stimmt inzwischen - nachgemessen:

    git rev-parse --show-toplevel  ->  C:/Users/Gregor/Documents/github/Eudora7.2
    nach s{:}{-} und s{[/.]}{-}    ->  C--Users-Gregor-Documents-github-Eudora7-2
    tatsaechliches Verzeichnis     ->  C--Users-Gregor-Documents-github-Eudora7-2

Der Punkt in "Eudora7.2" wird von `s{[/.]}{-}g` mit erfasst; genau daran ist die
erste Fassung gescheitert. Heute passt es.

**Was bleibt, ist die Stummheit:** faellt die Ableitung wieder auseinander -
anderes Laufwerk, umbenanntes Repo, geaenderte Namensbildung von Claude Code,
`USERPROFILE` nicht gesetzt -, dann greift

    unless (-d $gedaechtnis) { exit 0; }

und das Werkzeug beendet sich **wortlos mit 0**. Auch `--pruefen` sagt dann
nichts. Ein Aufrufer kann "es gibt nichts zu tun" nicht von "ich habe gar nicht
erst hingesehen" unterscheiden - und das ist derselbe Fehler wie beim ersten Mal,
nur an einer anderen Stelle.

Zwei kleinere Punkte derselben Art:

- **Zeile 66/67:** `open(my $a, '<:raw', $q) or next;` - laesst sich die Quelle
  nicht lesen, wird die Datei stillschweigend uebersprungen und gilt als
  abgeglichen.
- **Der Abgleich ist einseitig.** Es wird nur kopiert, nie geloescht. Wird eine
  Lehre im Gedaechtnis umbenannt oder entfernt, bleibt die alte Kopie unter
  `Arbeitsweise/` fuer immer stehen, und `--pruefen` meldet "alles gleich". Heute
  gibt es genau einen solchen Fall - `Arbeitsweise/README.md` hat kein
  Gegenstueck im Gedaechtnis -, der ist aber gewollt und von Hand geschrieben.
  Ein spaeterer echter Fall waere davon nicht zu unterscheiden.

**Zu tun:** im nicht gefundenen Fall auf `STDERR` melden (und im `--pruefen`-Modus
mit ungleich 0 enden), den abgeleiteten Pfad mit ausgeben, und `--pruefen` auch
ueber verwaiste Kopien in `Arbeitsweise/` berichten lassen.

---

## NP3-6 - `pruefstand-melden.pl` gibt aus dem falschen Verzeichnis heraus Entwarnung

**Sicherheit: nachgewiesen, ausgefuehrt.**

**Datei:** `tools/pruefstand-melden.pl:41-44` und `:78-86`

Die drei Dateinamen stehen ohne Pfad (`'BEFUNDE.md'` usw.) und werden gegen das
**aktuelle Arbeitsverzeichnis** geprueft. Fehlt eine Datei, meldet das Werkzeug
zwar "fehlt", setzt aber `$warnung` **nicht**. Aus einem Unterverzeichnis heraus
kommt deshalb:

    $ cd Eudora71 && perl ../tools/pruefstand-melden.pl
    Stand HEAD: 703a3ca

      BEFUNDE.md         fehlt
      PORTIERUNG.md      fehlt
      README.md          fehlt

    Pruefung und Doku sind nah am Code.
    rc=0

Also der Rueckgabewert 0 und der Satz "nah am Code", obwohl gar nichts geprueft
wurde. Aus der Wurzel heraus laeuft dasselbe Werkzeug korrekt und liefert
`rc=1`. Im pre-commit-Hook steht es nicht (dort laufen nur
`lehren-spiegeln.pl` und `pruefe-bytes.pl`), es wird also von Hand aufgerufen -
und genau dann steht das Arbeitsverzeichnis nicht fest.

**Zu tun:** die Pfade an `git rev-parse --show-toplevel` haengen, wie
`lehren-spiegeln.pl` es tut, und "fehlt" als Warnung zaehlen.

---

## NP3-7 - `pruefstand-melden.pl` nennt einen beliebigen Commit als Pruefstand

**Sicherheit: nachgewiesen, ausgefuehrt. Auswirkung: die Zahl ist irrefuehrend,
nicht falsch gerundet.**

**Datei:** `tools/pruefstand-melden.pl:24-26` und `:47-58`

Die Schleife laeuft ueber **alle** Treffer von `\b([0-9a-f]{7,40})\b` in der
ganzen Datei und behaelt den **letzten**, der ein gueltiger Commit ist. Der
Kommentar nennt das "den zuletzt genannten Commit-Hash" - gemeint ist aber
offensichtlich der Commit, bis zu dem geprueft wurde, und das ist etwas anderes.
In `BEFUNDE.md` steht der Bezugscommit eines Abschnitts jeweils oben im Abschnitt;
danach folgen beliebig viele weitere Hashes aus den einzelnen Befunden.

Gemessen unmittelbar nach dem Eintragen der Nachpruefung 3:

    BEFUNDE.md   geprueft bis e50a89c, seither 18 Commit(s)  <== faellig

`e50a89c` ist der Commit, den mein Befund "NP2-1 ist ueberholt" als Beleg nennt.
Der Bezugscommit des Abschnitts ist `22a6d77`, und der ist **neuer**:

    git rev-list --count 22a6d77..HEAD  ->  17
    git rev-list --count e50a89c..HEAD  ->  18

Heute ist der Unterschied ein einziger Commit; sobald ein Befund einen alten
Commit als Beleg anfuehrt - `BEFUNDE.md` nennt an mehreren Stellen `b4b7de5`,
`ba617a8` oder `567a5d8` -, kann die Meldung um Dutzende Commits danebenliegen,
in beide Richtungen.

**Nebenbei gemessen: das Werkzeug ist langsam.** Es ruft fuer **jeden** hex-artigen
Fund `git cat-file -t` in einer eigenen Prozessinstanz auf. Allein `BEFUNDE.md`
enthaelt 60 solche Kandidaten; der gesamte Lauf ueber die drei Dateien braucht
**29,5 Sekunden** (gemessen mit `time`). Das ist der Grund, warum niemand es
gewohnheitsmaessig aufruft.

**Zu tun:** eine ausdrueckliche Marke einfuehren, die das Werkzeug sucht, statt zu
raten - z. B. eine Zeile `<!-- pruefstand: <hash> -->` oder das erste Vorkommen
von "Bezugscommit:" -, und die Hashes in einem einzigen
`git cat-file --batch-check`-Aufruf pruefen statt in 60 einzelnen.

`$gesamt` (Zeile 33-34) wird berechnet und nie benutzt.

---

## Nachgeprueft: die beiden Meldungen des Agenten TABELLE

Beide sind **bestaetigt**. Beide sind Altbestand von QUALCOMM, kein
Portierungsschaden - aber der zweite ist durch die Umstellung auf den
Codepage-Wandler haeufiger sichtbar geworden.

### NP3-8 - Der IMAP-Empfang uebersetzt keinen einzigen Zeichensatz

**Sicherheit: nachgewiesen. Originalfehler von QUALCOMM.**

**Datei:** `Eudora71/EuImap/src/ImapDownload.cpp:4644` und `:4657-4662`

Die beiden Zaehlweisen nebeneinander, jeweils an der Ressourcentabelle
nachgemessen (`Eudora/resource.h:1807-1810`, `Eudora/EudoraRes.rc:9385-9388`):

| Zeichensatz | Ressource | `FindMIMECharset` (`mime.cpp:382-390`) | `ImapDownload.cpp:4644` |
|---|---|---|---|
| `windows-*` | - | 0 (Sonderweg) | -1 (nicht gefunden) |
| `us-ascii` | 3611 | 1 | 0 |
| `iso-8859-1` | 3612 | 2 | 1 |
| `iso-8859-15` | 3613 | 3 | 2 |
| `utf-8` | 3614 | 4 | **-1** (ausserhalb des Suchbereichs) |

`FindMIMECharset` durchsucht 3611 bis **3614** und zaehlt danach mit `++iCharSet`
eins hinauf, damit die 0 fuer die Windows-Zeichensaetze frei bleibt.
`ImapDownload.cpp:4644` durchsucht nur 3611 bis **3613** und laesst das `++` weg.

`ISOTranslate` (`Eudora/utils.cpp:1165-1178`) erwartet die Zaehlweise von
`FindMIMECharset`: "0 ist Windows, 1 ist US ASCII und 2 ist Latin1" - alles
darunter kehrt sofort zurueck, und erst ab 3 wird `iCharsetIdx -= 3` in die
Uebersetzungstabelle hinein gerechnet.

Damit ergibt sich fuer den IMAP-Pfad:

- `utf-8` liefert -1, die Abfrage `if (iCharsetIdx > 1)` faellt durch - **keine
  Uebersetzung**.
- `iso-8859-15` liefert 2, die Abfrage laesst es durch, `ISOTranslate` liest die
  2 als "Latin-1, nichts zu tun" und kehrt in Zeile 1176 sofort zurueck -
  **keine Uebersetzung**.
- Jeder andere Zeichensatz liefert -1 - **keine Uebersetzung**.

Es gibt also **keinen** Wert, bei dem der IMAP-Pfad tatsaechlich uebersetzt. Die
Abfrage `> 1` ist dabei folgerichtig um eins verschoben (der POP-Pfad prueft
`> 2`, `TextReader.cpp:245` und `lex822.cpp:541`); nur der **Wert**, der an
`ISOTranslate` weitergereicht wird, ist es nicht.

**Folge:** jede IMAP-Nachricht in UTF-8, ISO-8859-15 oder einem der
Tabellenzeichensaetze kommt unuebersetzt im Postfach an. Fuer den POP-Pfad
(`TextReader.cpp:251`, `lex822.cpp:544`) gilt das nicht - dort stimmt die
Zaehlweise. Ein Schadensbild, das nur bei IMAP auftritt, ist also nicht dem
Wandler anzulasten.

**Zu tun:** in `ImapDownload.cpp:4644` denselben Aufruf verwenden wie
`mime.cpp:382-390`, am besten durch Aufruf von `FindMIMECharset` selbst, und die
Abfrage in Zeile 4657 auf `> 2` ziehen. Getrennt vom Portierungsumbau, weil es
eine echte Verhaltensaenderung ist.

### NP3-9 - Der Rueckgabewert von `ISOTranslate` wird an zwei Stellen verworfen

**Sicherheit: nachgewiesen. Originalfehler von QUALCOMM, durch die Umstellung
haeufiger sichtbar.**

**Dateien:** `Eudora71/Eudora/TextReader.cpp:251`,
`Eudora71/EuImap/src/ImapDownload.cpp:4662`

`ISOTranslate` gibt die **neue** Laenge zurueck (`utils.cpp:1361-1367`: `lSize =
lWrite; szBuf[lSize] = 0; return lSize;`) und ist nie laenger als die Eingabe.
Beide Aufrufstellen verwerfen den Wert und rechnen mit der alten Laenge weiter:

    // TextReader.cpp:251
    ISOTranslate(buf, size, iCharsetIdx);
    if (size) { ... buf[size-2] ... }        // size ist die ALTE Laenge

    // ImapDownload.cpp:4662
    ISOTranslate(pBuf, inLen, iCharsetIdx);
    ... weiter mit inLen / outLen

**Folge:** verkuerzt die Umsetzung den Text - und das tut sie bei jeder
Mehrbyte-Folge, die zu einem Byte wird -, dann liegen zwischen dem neuen Ende und
der alten Laenge die unveraenderten Reste des Ausgangstextes. Die werden
mitgeschrieben. Kein Zugriff ueber das Pufferende hinaus, aber ein sichtbar
falscher Textschwanz. Bei UTF-8 faellt das am staerksten auf: der neue Weg ueber
`MultiByteToWideChar`/`WideCharToMultiByte` verkuerzt zwei- bis vierbyteweise,
die alte Tabelle nur um ein bis zwei Byte je Zeichen.

**Nicht betroffen** sind die beiden anderen Aufrufstellen: `lex822.cpp:544` und
`ImapLex822.cpp:577` rufen mit `strlen(text)` und arbeiten danach wieder ueber
die Nullterminierung - und die setzt `ISOTranslate` auf die neue Laenge.
Nachgesehen, nicht vermutet.

**Zu tun:** `size = ISOTranslate(buf, size, iCharsetIdx);` bzw.
`inLen = ISOTranslate(pBuf, inLen, iCharsetIdx);`. Bei `ImapDownload.cpp` ist
vorher NP3-8 zu klaeren, sonst laeuft der Zweig ohnehin nie an. Achtung bei
`TextReader.cpp`: `outLen` bzw. die nachfolgende `CRLF`-Pruefung haengen an
`size`, die Aenderung ist also nicht ganz oertlich - sie gehoert mit einem Test
abgesichert.

---

## Stand nach dem zweiten Teil

**Zusaetzlich durch:**

- `tools/lehren-spiegeln.pl` (95 Zeilen), `tools/pruefstand-melden.pl` (86
  Zeilen), `tools/hooks-einrichten.sh` und der eingerichtete
  `.git/hooks/pre-commit`. Beide Skripte wurden **ausgefuehrt**, das Verhalten
  von `git commit -- <pfad>` mit stagendem pre-commit-Hook in einem eigenen
  Testrepo vorgefuehrt.
- `Eudora/utils.cpp` `ISOTranslate` vollstaendig (Z. 1165-1367),
  `Eudora/rs.cpp` `FindRStringIndexI` (Z. 796-830), `Eudora/mime.cpp`
  `FindMIMECharset` (Z. 379-400), die vier Aufrufstellen von `ISOTranslate`
  und die Ressourcentabelle der Zeichensatznamen.

**Weiterhin offen** (unveraendert gegenueber dem ersten Teil):
`OTShim_Bild.{h,cpp}` ausserhalb von `CreateFromBitmap`, `OTShim_Palette.{h,cpp}`
ausserhalb von `SECDateTimeCtrl`, die Anordnungsrechnung von
`OTShim_Werkzeugleiste`, `tools/pruefe-bytes.pl` und `tools/aendere-zeile.pl`
(nicht beauftragt), `Eudora.vcxproj`.

---

# Nachpruefung 3, dritter Teil (PRUEFER) - Bildschicht und Datumsfeld vollstaendig

Fortsetzung. Damit sind `OTShim_Bild.{h,cpp}` und `OTShim_Palette.{h,cpp}` nicht
mehr nur an den beiden beauftragten Stellen, sondern **ganz** durchgesehen.
**Kein neuer Befund.** Was folgt, ist die Fundliste des Gegenteils - damit eine
spaetere Pruefung hier nicht noch einmal anfangen muss.

## Geprueft und in Ordnung - Stufe 4, Bildschicht

- **GDI+ starten und beenden.** `OTShimGdiPlusBereit()`
  (`OTShim_Bild.cpp:96-100`) benutzt ein funktionslokales `static`. Seit C++11
  ist dessen Anlage vom Uebersetzer gegen gleichzeitige Zugriffe abgesichert
  ("magic statics"), MSVC hat das seit 2015 - die Begruendung im Kommentar
  stimmt. `GdiplusShutdown` laeuft im Aufraeumteil von `Eudora.exe`, nicht aus
  einer DLL-Entladung; die Einschraenkung der Schnittstellenbeschreibung ist
  eingehalten. Scheitert `GdiplusStartup`, liefert jede Lade- und Speichermethode
  `FALSE` mit `ERROR_NOT_READY` statt in GDI+ hineinzulaufen.
- **Der Umweg ueber `IStream`.** `OTShimStromAusDatei` gibt den `HGLOBAL` auf
  **jedem** Fehlerweg wieder frei (kein `GlobalLock`, kurzer Lesevorgang,
  `CreateStreamOnHGlobal` gescheitert) und uebergibt den Besitz erst mit
  `fDeleteOnRelease == TRUE` an den Strom. Jedes `GlobalLock` hat sein
  `GlobalUnlock`, auch im Ausnahmefall. Die 2-GB-Schranke verhindert, dass die
  Umrechnung `ULONGLONG` nach `UINT` still abschneidet. In
  `OTShimLadenUeberGdiPlus` steht das `Gdiplus::Bitmap` in einem eigenen Block,
  wird also **vor** `pStrom->Release()` zerstoert - noetig, weil GDI+ bei
  manchen Formaten erst beim Zugriff nachliest.
- **Die Zeilenrechnung.** `CalcBytesPerLine(24, w) = ((w*24+31) & ~31)/8`
  nachgerechnet: fuer w = 1,2,3,4 ergibt sich 4,8,12,12 - genau die
  4-Byte-Ausrichtung, die ein DIB verlangt. `OTShimDibAnlegen` legt `m_lpBMI`
  mit `sizeof(BITMAPINFO)` an (also mit dem einen `RGBQUAD`, in den
  `::GetDIBits` auch ohne Farbtabelle schreibt) und gibt bei einer
  fehlgeschlagenen zweiten Belegung beides wieder frei - `m_lpBMI` und
  `m_lpSrcBits` sind danach beide NULL, wie `AssertValid` es verlangt.
- **Die Zeilenumkehr beim Laden.** GDI+ liefert von oben nach unten, der DIB
  hat positives `biHeight` und will von unten nach oben - die Rechnung
  `m_lpSrcBits + (nHoehe - 1 - y) * m_dwPadWidth` ist richtig. Im Fall ohne
  Alphakanal werden `nBreite * 3` Byte kopiert, nicht `daten.Stride`; damit kann
  die Auffuellung der Quelle nicht ueber das Zeilenende des Ziels
  hinausschreiben, auch wenn beide unterschiedlich aufgefuellt waeren. Im Fall
  mit Alphakanal werden je Bildpunkt vier Byte gelesen und drei geschrieben,
  ebenfalls innerhalb beider Zeilen.
- **`OTShimUeberlagern`** ist Byte fuer Byte `alpha_composite` aus
  `QCGraphics.cpp:293-300`. Die dort dokumentierte Abweichung (durchgaengig
  gegen `m_crTransparent` statt teils gegen Schwarz) ist im Kommentar begruendet
  und macht das Bild besser, nicht anders falsch.
- **`OTShimSpeichernUeberGdiPlus`.** `EncoderParameters` traegt genau ein
  `Parameter[1]`, `Count = 1` passt also zur Struktur; der Wert `ulQualitaet`
  lebt bis nach dem `Save`. `pBild` wird auf jedem Weg geloescht, `pStrom` auf
  jedem Weg freigegeben. `Bitmap::FromBITMAPINFO` legt keine Kopie an - der
  Kommentar sagt es, und der Puffer steht bis zum Ende des Blocks.
- **`SECDib::DoSaveImage`** schreibt den Dateikopf von Hand. Nachgerechnet:
  `bfOffBits = 14 + 40 + Farbtabelle`, `bfSize = bfOffBits + m_dwPadWidth *
  m_dwHeight`, und `biSizeImage` wird unmittelbar davor auf denselben Wert
  gezogen. `DIB_HEADER_MARKER` ist in `OTShim_Bild.h:432` als
  `((WORD)('M' << 8) | 'B')` definiert, also 0x4D42 - die Bytefolge "BM".
  `BITMAPFILEHEADER` ist in `wingdi.h` auf 2 Byte gepackt, `sizeof` ist 14; der
  Kopf wird also nicht mit Fuellbytes geschrieben.
- **`SECDib::DoLoadImage`** liest den Dateikopf nur, um `m_lpbmfHdr` zu fuellen,
  und spult in **jedem** Fall auf die Ausgangsstelle zurueck, bevor GDI+ die
  Datei bekommt. Eine zu kurze Datei und ein fremdes Magiewort fuehren beide
  dazu, dass `m_lpbmfHdr` NULL bleibt - nicht dazu, dass falsch gelesen wird.
- **`CreatePalette`, `MakeBitmap`, `CopyImage`.** `CreatePalette` gibt den
  `LOGPALETTE`-Puffer auf beiden Wegen frei und raeumt `m_pPalette` wieder ab,
  wenn `CPalette::CreatePalette` scheitert. `MakeBitmap` gibt einen selbst
  angelegten DC wieder frei, bevor es zurueckkehrt, und uebergibt das
  `CBitmap` an den Aufrufer (`EmoticonMenu.cpp:113` und
  `LinkHistoryManager.cpp:608` loeschen es - nachgesehen). `CopyImage` kopiert
  zeilenweise mit der kleineren der beiden Zeilenlaengen und kann deshalb auch
  dann nicht ueber den Puffer hinausschreiben, wenn eine Quelle mit anderer
  Farbtiefe auftaucht.
- **Die Dummys sind wirklich Dummys.** `FlipHorz`, `FlipVert`, `Rotate90`,
  `ContrastImage`, `Crop`, `UnPadBits`, `InitCache` und `SECLoadDib` melden sich
  ueber `OTShimNichtUmgesetzt` je einmal pro Sitzung und liefern `FALSE`; keiner
  taeuscht Erfolg vor. `LoadCache`, `GetCache` und `PutCache` liefern 0 - fuer
  einen nie angelegten Puffer die richtige Antwort.

## Geprueft und in Ordnung - `SECDateTimeCtrl`, uebriger Teil

- `SetMinMax` weist die Werte nur zu, wenn `min <= max`, und reicht sie an
  `CDateTimeCtrl::SetRange` nur weiter, wenn es ein Fenster gibt; ohne Fenster
  bleibt der Bereich gemerkt. `Validate` prueft beide Grenzen einzeln auf
  Gueltigkeit, bevor es vergleicht.
- Die Merker (`SetModified`, `IsModified`, `EnableFastEntry`, `SetNoEdit`,
  `SetNull`) sind reine Ablage, wie im Kommentar behauptet; keiner davon hat
  einen Aufrufer in Eudora.
- `SizeToContent` ist ueber `#ifdef DTM_GETIDEALSIZE` abgesichert und prueft das
  Ergebnis auf beide Ausdehnungen, bevor es die Fenstergroesse aendert.
- `SECSetOleDateTime` gibt `dt.SetDateTime(...) == 0` zurueck. Das ist richtig:
  `COleDateTime::SetDateTime` liefert den `DateTimeStatus`, und
  `COleDateTime::valid` ist 0.
- `SECTmFromOleDate` rechnet `tm_mon` ab 0 und `tm_year` ab 1900 - beides
  richtig herum.
- `OnDateTimeChange` haengt ueber `ON_NOTIFY_REFLECT(DTN_DATETIMECHANGE)` an der
  zurueckgespiegelten Meldung des gemeinen Steuerelements und setzt `*pResult`,
  bevor es zurueckkehrt.

## Zwei Kleinigkeiten ohne Befundwert

Beide sind originalgetreu bzw. unerreichbar; sie stehen hier nur, damit ein
spaeterer Leser nicht denselben Weg noch einmal geht.

- `SECImage::LoadImage(LPCTSTR)` merkt sich den uebergebenen Zeiger in
  `m_lpszFileName` (Zeile 923). Der zeigt nach der Rueckkehr moeglicherweise ins
  Leere. Das ist die Oberflaeche des Originals (`secimage.h:74` fuehrt `LPCTSTR`,
  keinen `CString`), und Eudora liest das Feld nirgends.
- `SECDateTimeCtrl::SetDateTime` weist `m_datetime` zu, bevor
  `CDateTimeCtrl::SetTime` scheitern kann (Zeile 267-273). Nach einem
  Fehlschlag stehen Feld und Fenster damit auseinander. Eudora ruft die Methode
  nur mit gueltigen Werten (`SearchView.cpp:5261`).

## Stand nach dem dritten Teil

**Jetzt vollstaendig durch:** `OTShim.{h,cpp}` (Stufe 2 und 2b),
`OTShim_Reiter.{h,cpp}`, `OTShim_Bild.{h,cpp}`, `OTShim_Palette.{h,cpp}`,
`tools/lehren-spiegeln.pl`, `tools/pruefstand-melden.pl`.

**Weiterhin offen:**

| Gegenstand | Grund |
|---|---|
| `OTShim_Werkzeugleiste`: Anordnungsrechnung (`CalcDynamicLayout`, `CalcFixedLayout`, `Layout`, Zeilenumbruch), `SECTwoPartBtn::DrawButton`, `SECWndBtn`/`SECComboBtn`, `SECCustomizeToolBar` und die Anpassen-Dialogseiten | unveraendert offen seit Nachpruefung 2 |
| `OTShim.cpp` Stufe 0 und Stufe 1 (Z. 1-175, 540-1229) | in Runde 1 unter "OTShim, uebriger Teil" geprueft; hier nur ueberflogen |
| `tools/pruefe-bytes.pl`, `tools/aendere-zeile.pl` | nicht beauftragt |
| `Eudora.vcxproj` und die offenen Bindefehler | waehrend der ganzen Pruefung im Fluss |
| Hostnamenpruefung, `X509_V_ERR_CERT_UNTRUSTED` | bewusst zurueckgestellt |

## Gefunden durch PROBE

Der Agent PROBE hat die Ersatzschicht erstmals ausgefuehrt (Testprogramm unter
`Eudora71/Tests`, siehe `TestOTShimBild.cpp`, `TestOTShimReiter.cpp`,
`TestOTShimPalette.cpp`). Was dabei aufgefallen ist:

### P-1 - `OnActivateTab` und `ClearSelection` rufen `GetParent()`, bevor sie das eigene Fenster pruefen

**GEMESSEN**, nicht vermutet. Der erste Lauf der Registerkarten-Tests schrieb
zehn Zeilen auf stderr:

```
...\ATLMFC\Include\afxwin2.inl(213) : Assertion failed!
```

Zeile 213 ist `CWnd::GetParent`:

```cpp
_AFXWIN_INLINE CWnd* CWnd::GetParent() const
    { ASSERT(::IsWindow(m_hWnd)); return CWnd::FromHandle(::GetParent(m_hWnd)); }
```

Die zehn Meldungen decken sich Stueck fuer Stueck mit den neun Aufrufen von
`ActivateTab` und dem einen von `ClearSelection` in den Tests. Ein zweiter
Lauf mit einem Berichtshaken der Laufzeitbibliothek (`_CrtSetReportHook2`)
hat es auf zwei Stellen eingegrenzt:

| Datei | Zeile | Methode |
|---|---|---|
| `Eudora71/OTShim/OTShim_Reiter.cpp` | 330 | `SECTabControlBase::OnActivateTab` |
| `Eudora71/OTShim/OTShim_Reiter.cpp` | 358 | `SECTabControlBase::ClearSelection` |

Beide holen sich das Elternfenster, **bevor** sie pruefen, ob es das eigene
Fenster ueberhaupt gibt:

```cpp
CWnd* pParent = GetParent();
if (pParent != NULL && ::IsWindow(pParent->GetSafeHwnd()))
    pParent->SendMessage(...);
```

Die Absicht ist erkennbar - "ohne gueltiges Elternfenster nichts tun" -, die
Pruefung steht nur einen Schritt zu spaet. Ueberall sonst in derselben Datei
steht zuerst `if (GetSafeHwnd() != NULL)`, zum Beispiel drei Zeilen vor der
zweiten Fundstelle.

**Tragweite.** In Eudora selbst loest das nichts aus: das Steuerelement
entsteht in `SECTabWndBase::CreateTabCtrl` unmittelbar mit einem Fenster, und
`CWazooBar` ruft `ActivateTab` erst danach (`WazooBar.cpp:347, 408, 1364`).
Der Befund ist also eine Haertungsluecke, kein belegter Absturz. Im Debugbau
wuerde er allerdings ein modales Meldungsfenster aufmachen, sobald der Weg
doch einmal ohne Fenster genommen wird - und schliessen laesst er sich mit
zwei Zeilen.

**Vorschlag.** In beiden Methoden vorne einsetzen:

```cpp
if (GetSafeHwnd() == NULL)
    return;
```

**Nicht von PROBE repariert** - `OTShim_Reiter.cpp` gehoert einem anderen
Agenten. Der Test
`BEFUND: ActivateTab und ClearSelection fassen GetParent an, bevor sie das Fenster pruefen`
in `Eudora71/Tests/TestOTShimReiter.cpp` bleibt so lange rot und wird von
selbst gruen, sobald die zwei Zeilen stehen.

**Verwandte Stellen, die NICHT betroffen sind** (dort steht `GetParent()`
ebenfalls ungeschuetzt, die Methoden sind aber nur aus einer Nachricht heraus
erreichbar, also stets mit Fenster): `OTShim_Reiter.cpp:1301`
(`SEC3DTabControl::OnLButtonDblClk`), `:1805` (`SECTabWndBase::OnTabSelect`),
`OTShim_Palette.cpp:509` (`SECDateTimeCtrl::OnChanged`).

### P-2 - `SECTabWndBase::InsertTab` blendet ein Fenster aus, ohne es zu pruefen

Kein gemessener Fehler, sondern der Grund, warum die **Fensterebene** der
Registerkarten-Familie ungetestet bleibt. `SECTabWndBase::InsertTab`
(`OTShim_Reiter.cpp:1503`) ruft im `else`-Zweig

```cpp
pWnd->ShowWindow(SW_HIDE);
```

ohne vorherige `::IsWindow`-Pruefung - anders als `ZeigeInhaltsfenster`
zwanzig Zeilen weiter, das sie hat. In Eudora ist das kein Fehler: die
`CWazooWnd` sind vor dem Einfuegen angelegt (`WazooBar.cpp:178-179` ruft
unmittelbar danach `SetParent`, was ein Fenster voraussetzt). Es macht die
Ebene aber ohne echte Fenster unpruefbar, und es ist dieselbe Unachtsamkeit
wie P-1.

Dieselbe Methode ist schon unter NP3-1 aufgefallen, dort aus einem anderen
Grund (der erste Reiter wird gezeigt, bevor Eudora ihn umgehaengt hat).

### P-3 - `SECDateTimeCtrl::FixedTime` laesst die Stunde aus (Fehler im Original, bewusst uebernommen)

Kein Befund gegen die Ersatzschicht, sondern gegen das Stingray-Original -
festgehalten, damit niemand ihn spaeter fuer einen Uebernahmefehler haelt.

**GEMESSEN.** Ein Test in `Eudora71/Tests/TestOTShimPalette.cpp` erwartete,
dass `FixedTime` die Summe aus `FixedHour`, `FixedMinute` und `FixedSecond`
ist (0x0038), und schlug fehl. Nachgesehen in `OT501/Include/DTCtrl.h:114-118`:

```
FixedHour   = 0x0008,           // The hour is non-editable
FixedMinute = 0x0010,           // The minute is non-editable
FixedSecond = 0x0020,           // The second is non-editable
FixedDate   = 0x0007,           // The date is non-editable
FixedTime   = 0x0030            // The time is non-editable
```

`FixedDate` stimmt (0x0001|0x0002|0x0004), `FixedTime` nicht: 0x0030 ist
`FixedMinute|FixedSecond`, die Stunde fehlt. `OTShim_Palette.h` hat den Wert
woertlich uebernommen - **und das ist richtig so**: die Konstante gehoert zur
Schnittstelle, ein stillschweigend berichtigter Wert wuerde abweichendes
Verhalten erzeugen. Eudora wertet `SetNoEdit` ohnehin nirgends aus (in
`OTShim_Palette.cpp` ausdruecklich vermerkt).

Der Test schreibt den uebernommenen Wert fest, damit ein spaeteres
Geradeziehen als Aenderung sichtbar wird und nicht unbemerkt einsickert.

## S-1 — Das Auslieferungspaket 1.0.1 startet nicht (gemessen 30.08.2026)

**Erster Startversuch ueberhaupt.** `Eudora.exe` startet, laeuft acht Sekunden mit
vier Threads und 15,6 MB, oeffnet aber kein Fenster. Windows meldet:

    Die Ausfuehrung des Codes kann nicht fortgesetzt werden,
    da MSVCR71D.dll nicht gefunden wurde.

**Ursache.** Nach `Bin\Debug` gehoeren sieben vorgebaute DLLs aus der CHM-Freigabe,
die gegen die *Debug*-Laufzeit von Visual Studio 2003 gebunden sind (`MSVCR71D.dll`,
`MFC71D.DLL`, `MSVCP71D.dll`). Diese Debug-Laufzeit ist nicht verteilbar und
existiert nur auf einer Maschine mit installiertem VS2003. Betroffen: DirServ,
EudoraBk, EuMemMgr, ISock, Ldap, Ph, Paige32d.

Die Release-Varianten derselben DLLs liegen unter `Bin\Release` und brauchen nur die
*Retail*-Laufzeit (`MSVCR71.dll`, `MFC71.DLL`, `MSVCP71.dll`). Auch die ist auf
dieser Maschine nicht vorhanden — es ist keine Eudora-Installation da, aus der man
sie nehmen koennte.

**Beim Laden zwingend** sind laut Importtabelle von `Eudora.exe` nur zwei:
`EuMemMgr.dll` und `Paige32d.dll`. Die uebrigen fuenf werden erst bei Benutzung
geladen.

**Loesungsweg.**

| DLL | Quellen vorhanden | Weg |
|---|---|---|
| EuMemMgr | ja, 17.172 Zeilen unter `Eudora71/EuMemMgr` | selbst bauen mit v143 |
| Paige32 | **nein** — `Eudora71/PaigeDLL` enthaelt nur Makefiles, `PAIGE.H` und die fertigen Binaerdateien | vorgebaute Release-Fassung benutzen |

Fuer Paige bleibt die Bindung an `MSVCR71.dll`. Gemessen braucht `Paige32.dll`
daraus **genau 20 Funktionen**:

    _onexit  __dllonexit  __CppXcptFilter  _adjust_fdiv  malloc  _initterm
    free  _except_handler3  __security_error_handler  time  labs  memmove
    tmpnam  _setjmp3  memset  strlen  longjmp  remove  rename

Das ist wenig genug fuer eine eigene Weiterleitungs-DLL auf die heutige UCRT —
dasselbe Vorgehen wie bei OTShim. Heikel sind nur die VC7.1-eigenen: `_setjmp3`,
`_except_handler3`, `__security_error_handler`, `_adjust_fdiv`, `__CppXcptFilter`,
`_initterm`, `__dllonexit`, `_onexit`.

**Folge fuer die Auslieferung.** Die Datei `LIESMICH.txt` im Release 1.0.1 nennt als
Voraussetzung nur die VS2022-Debug-Laufzeiten und behauptet, die seien auf der
Zielmaschine vorhanden. Das ist unvollstaendig: die VC7.1-Laufzeit fehlt und wird
nicht erwaehnt. Das Paket ist damit **nicht startfaehig**; die Beschreibung muss
richtiggestellt werden.

## S-2 — Stapelueberlauf beim Start: die Werbeflaeche (behoben 30.08.2026)

**Symptom.** Nach dem Startbildschirm passierte nichts mehr, dann Absturz mit
`EXCEPTION_STACK_OVERFLOW` (mal auch `0xC0000005`). Die letzte Meldung vor dem
Absturz war stets `viewcore.cpp(103): Creating a pane with no CDocument`.

**Wie es gefunden wurde.** Auf der Maschine ist kein Debugger installiert, und
Eudoras eigener Absturzbehandler gibt bei einem vollen Stapel bewusst nur eine
Zeile aus (`BugslayerUtil/CrashHandler.cpp:286`). Dafuer entstand
`tools/stapel-untersuchen.ps1`: ein kleiner Debugger, der das Programm als
Debuggee startet, die toedliche Ausnahme abfaengt, die EBP-Kette ablaeuft und
mit `dbghelp.dll` symbolisiert. Bei einer Endlosrekursion sind fast alle Rahmen
gleich, deshalb weist er die haeufigsten als Zyklus aus und druckt nur den Rest.

**Gemessene Aufrufkette** (1689 Rahmen, davon 1613 im Zyklus):

    CAdWazooWnd::OnCreate              AdWazooWnd.cpp:108
      CPaigeEdtView::Create            PaigeEdtView.cpp:4490
        -> CreateWindowEx -> WM_CREATE
          CPaigeEdtView::OnCreate      PaigeEdtView.cpp:1551
            CAdView::NewPaigeObject    AdView.cpp:208
              CPaigeEdtView::NewPaigeObject   PaigeEdtView.cpp:1646
                -> Paige32d.dll, zwei Rahmen wechseln sich ~800mal ab

**Ursache.** `CAdWazooWnd::OnCreate` legt die Werbeansicht mit `CRect(0,0,0,0)`
an (AdWazooWnd.cpp:108). Paige bekommt damit eine Umbruchbreite von null und
verheddert sich in einer Endlosrekursion. Paige ist eine Fremdbibliothek ohne
Quellen (`Eudora71/PaigeDLL` enthaelt nur Makefiles und `PAIGE.H`) - dort ist
nichts zu reparieren.

**Behebung.** Die Werbeleiste wurde in `WazooBarMgr.cpp:155` **bedingungslos**
angelegt, ohne jede Abfrage der Betriebsart. Jetzt haengt sie an
`QCSharewareManager::IsBoxBuild()`. Zusammen mit dem Uebersetzungsschalter
`BUILD_BOX_OR_SITE_R_VERSION` (Eudora.vcxproj, beide Konfigurationen) entfaellt
damit die Werbung ganz - das ist die Fassung, die QUALCOMM an Firmenkunden
ausgeliefert hat. `DEFAULT_SWM_MODE` wird dadurch 2 (`SWM_MODE_PRO`), und der
Einfuehrungsdialog (eudora.cpp:1597) entfaellt ebenfalls.

**Ergebnis.** Eudora startet und zeigt sein Hauptfenster: Menueleiste,
Werkzeugleiste, Postfachbereich, Statuszeile. Erstmals seit Beginn der
Portierung.

**Nebenbefund.** `tools/rekursion-suchen.pl` (Zyklensuche im Aufrufgraphen der
Ersatzschicht) meldete fuenf Zyklen - **alle Fehlalarm**: es sind Ueberladungen,
die das Werkzeug nur am Namen und an der Argumentzahl unterscheidet, nicht an
den Typen. Die Ersatzschicht war an diesem Absturz unbeteiligt.

## S-3 — Erster Lauf durch einen Anwender: was auffiel (30.08.2026)

Gregor hat die Fassung mit abgeschalteter Werbeflaeche selbst gestartet. Sie
laeuft. Aufgefallen ist Folgendes.

### S-3a  Veraltete Selbstauskunft der Ersatzschicht (behoben)

Beim Aufruf der Auto-Wazoo-Fensterleiste (Einstellung "MDI Task Bar") meldet
sich die Ersatzschicht mit dem Hinweis, dass die Funktion fehlt - das ist so
gewollt (`OTShimNichtUmgesetzt`, OTShim.cpp:153). Der Text behauptete aber:

    Der Ersatz fuer das Stingray Objective Toolkit ist bis Stufe 2
    (MDI-Fenstergeruest und Andockfamilie) umgesetzt. Alles Weitere
    folgt in spaeteren Stufen.

Das stimmte seit Commit `e50a89c` nicht mehr - Stufe 3, die Registerkarten und
die Palette sind eingehaengt. Der Satz haette den Eindruck erweckt, die Schicht
sei halbfertig, obwohl sie vollstaendig eingehaengt ist und nur einzelne
Funktionen darin leer sind. Neu formuliert in OTShim.cpp:165-167.

**Lehre:** Ein Text, der einen *Fortschrittsstand* nennt, veraltet zwangslaeufig.
Meldungen sollen sagen, was fehlt - nicht, wie weit man ist.

### S-3b  Vier Debug-Zusicherungen beim ersten Start (offen)

Aus frisch ausgepacktem Paket erscheinen drei bis vier SUPERASSERT-Dialoge, die
weggeklickt werden muessen. Eine davon ist belegt:

    !"Erasing X1 indices because DB schema was missing or doesn't match"
    SearchManager::Info::InitX1, SearchManagerInfo.cpp:496

Das ist beim ersten Start normal - der Suchindex existiert noch nicht. In einem
Release-Bau erschiene keiner dieser Dialoge; sie sind eine reine Folge davon,
dass nur der Debug-Bau lauffaehig ist (der Release-Zweig scheitert an fehlender
`Imap.lib`). Solange das so bleibt, gehoert der Hinweis in die Paketbeschreibung.

### S-3c  Zwei Laufzeitbibliotheken fehlen weiterhin (offen)

`MFC71.DLL` und `MSVCP71.dll` sind nicht vorhanden. Betroffen sind vier DLLs,
die Eudora erst bei Benutzung laedt:

| DLL | braucht | Funktion, die ausfaellt |
|---|---|---|
| EudoraBk.dll | MFC71 | Adressbuch |
| ISock.dll | MFC71 | ein Socket-Pfad |
| Ldap.dll | MFC71, MSVCP71 | LDAP-Verzeichnissuche |
| Ph.dll | MSVCP71 | Ph-Verzeichnisdienst |

Mailabruf und -versand sind davon **nicht** betroffen. Ohne die beiden Dateien
faellt vor allem das Adressbuch aus.

## S-4 — Zusicherung im Adressbuch-Wazoo schlaegt zu (behoben 30.08.2026)

**Symptom.** Beim Wegklicken von der Adressbuch-Registerkarte:

    Assertion   : ::IsWindow(m_wndSplitter.GetSafeHwnd())
    Location    : CNicknamesWazooWnd::OnDeactivateWazoo, Zeile 115

**Ursache.** Eine Registerkarte kann *aktiv* sein, ohne je *angezeigt* worden zu
sein. `SECTabControlBase::InsertTab` (OTShim_Reiter.cpp:214) macht die erste
eingefuegte Karte still aktiv - absichtlich, damit beim Aufbau der Leiste noch
kein Wazoo angestossen wird. `CNicknamesWazooWnd::CreateViews` laeuft aber erst
in `OnActivateWazoo`. Wer also von dieser Karte wegklickt, ohne sie je geoeffnet
zu haben, loest `OnDeactivateWazoo` auf einem Fenster ohne Splitter aus.

**Das ist kein Fehler der Ersatzschicht.** QUALCOMM beschreibt genau diesen
Zustand in WazooBar.cpp:346-355:

    In the SEC stuff, the ActivateTab() call doesn't do anything if the tab is
    ALREADY active, so make sure the Wazoo gets an initialization notice
    anyway. This covers cases like ... "active" wazoos which have never been
    displayed before.

Beim **Aktivieren** faengt Eudora den Fall also ab. An den beiden
**Deaktivierungs**stellen (QC3DTabWnd.cpp:101 und WazooBar.cpp:1396) fehlt
dieselbe Absicherung.

**Beweis, dass die Regel nicht gilt:** in der Schwesterklasse
`CFiltersWazooWnd::OnDeactivateWazoo` hat QUALCOMM dieselbe Zusicherung bereits
**auskommentiert** (FiltersWazooWnd.cpp:109). In `CNicknamesWazooWnd` blieb sie
stehen.

**Behebung.** Statt der Zusicherung ein frueher Ausstieg, wenn es keinen
Splitter gibt. Der Rumpf fasst den Splitter ohnehin nicht an, setzt aber weiter
unten `g_Nicknames` voraus - aussteigen ist sicherer als weiterlaufen. Ohne
Ansichten kann nichts geaendert worden sein, es gibt also auch nichts zu sichern.

## S-5 — Menues lassen sich nicht oeffnen

> **URSACHE INZWISCHEN GEFUNDEN — siehe Abschnitt M-1 weiter unten.**
> Der Rahmen liefert immer HTERROR, weil SECToolBarManager
> m_bMainFrameEnabled auf TRUE setzt. Was hier folgt, ist der Stand der
> Untersuchung VOR diesem Fund und bleibt stehen, weil die
> Ausschluesse weiter gelten.

Gregor meldet, dass sich in Eudora keine Menues aufklappen lassen.

**Bisher gemessen** (an einem eigenen Lauf, nicht an Gregors Pruefstand):

- Das Hauptfenster hat ein Menue: `GetMenu` liefert ein gueltiges Handle mit
  **14 Eintraegen**, davon 11 mit gefuellten Untermenues (File 22, Edit 25,
  Mailbox 1, Message 24, Transfer 1, Special 13, Tools 21, Window 7, Help 12,
  Debug 16). Eintrag 0 ist das MDI-Systemmenue des maximierten Kindfensters.
- Drei Eintraege am Ende (11, 12, 13) haben **leere Beschriftung und kein
  Untermenue**. UNGEPRUEFT, ob das die Ursache ist oder normale MDI-Platzhalter.
- Das Fenster antwortet auf `WM_NULL` innerhalb von 3 s, haengt also nicht.

**Naechster Schritt:** mit `SC_KEYMENU` ein Menue oeffnen und ueber
`GetGUIThreadInfo` pruefen, ob `GUI_INMENUMODE` gesetzt wird und ein Popup der
Klasse `#32768` entsteht. Damit laesst sich unterscheiden, ob das Menue gar
nicht aufgeht oder sofort wieder zufaellt.

## S-6 — Darstellung nach dem Oeffnen mehrerer Wazoos (OFFEN)

Gregor meldet, die Darstellung sei "vorher besser" gewesen und jetzt defekt. Auf
dem Bildschirmfoto ueberlagern sich der Adressbuch-Wazoo, die Registerkarten
"Task Status"/"Task Errors" und die Nachrichtenliste.

**Ausgeschlossen:** dass es am Entfernen der Werbeleiste liegt. `QCDockBar`
prueft an beiden betroffenen Stellen selbst auf `SWM_MODE_ADWARE`
(DockBar.cpp:51 und 84) und faellt sonst auf die Basisfassung zurueck - der
Zustand ohne Werbeleiste ist dort vorgesehen.

**UNGEPRUEFT:** Verdacht auf die Andockrechnung der Ersatzschicht bei mehreren
Leisten in einer Reihe. Muss reproduziert werden, bevor etwas geaendert wird.

## S-7 — Die Wurzel aller CRLF-Probleme, endlich gefunden (behoben 30.08.2026)

**Gemessen:** 4616 von 5563 verfolgten Quell- und Textdateien unterschieden sich
von HEAD **ausschliesslich in den Zeilenenden**. Im Arbeitsverzeichnis standen
sie als CRLF, im Commit als LF.

> **Zu den Zahlen** (nachgezogen am 31.08.2026 abends; Befund Z-1 hatte belegt,
> dass W-1/PR-7 dieses Nachziehen zwar meldete, aber nicht ausgeführt hatte).
> Die **4616** ist eine einmalige Messung des damaligen Arbeitsbaums und lässt
> sich nicht wiederholen — der Baum ist angeglichen. Nachprüfbar ist nur die
> Grundgesamtheit, und die wächst mit jedem Commit und hängt an der
> Endungsliste:
>
> | Dateien | Stand | Liste |
> |---|---|---|
> | 5563 | 30.08.2026 vormittags | alte Liste |
> | 5568 | 30.08.2026 abends (PRUEFER) | alte Liste |
> | 5589 | 31.08.2026 | alte Liste |
> | 6385 | 31.08.2026 | neue gemeinsame Liste (`tools/dateiendungen.pl`) |
> | 6394 | 31.08.2026 abends | dieselbe Liste, 0 Abweichungen |
>
> Die frühere Angabe „4426 von 5336" stammte aus einem Durchlauf mit kürzerer
> Endungsliste und steht im Kopf des Werkzeugs seit W-1 nicht mehr.

**Ursache.** Das Repo wurde seinerzeit mit `core.autocrlf=true` ausgecheckt. Git
wandelte beim Auschecken LF nach CRLF und vermerkte die Datei trotzdem als
sauber - im Index steht der LF-Blob-Hash, aber die **Groesse der CRLF-Fassung**.
Spaeter wurde `autocrlf` auf `false` gesetzt und `.gitattributes` mit `* -text`
angelegt; seitdem vergleicht git woertlich.

**Warum es so lange unsichtbar blieb.** Git sieht in eine Datei gar nicht erst
hinein, solange Zeitstempel und Groesse zum Index passen. Die Dateien galten
also weiter als unveraendert - bis irgendein Werkzeug eine anfasste. Dann
aenderte sich der Zeitstempel, git las neu ein und meldete die **ganze Datei**
als geaendert.

**Das erklaert die Vorgeschichte.** Genau dieses Muster hat in diesem Projekt
wiederholt zugeschlagen und wurde jedes Mal einzeln von Hand nachgebessert. Die
fruehere Vermutung, das Repo sei mit `autocrlf=true` geklont worden, war
**richtig** - sie wurde damals als widerlegt abgehakt, weil `git config` zum
Zeitpunkt der Pruefung schon `false` sagte. Die Einstellung war inzwischen
geaendert worden; die Folgen des Auscheckens blieben.

Belegt am Beispiel `Documents/Design/AdServer/Web_Words_Search_Servlet_Design.txt`
(Beschriftung am 31.08.2026 berichtigt — sie war vertauscht, Befund Z-1):

    HEAD-Blob 8c4fb68a:   5716 Bytes, 0 CR, 65 LF     (die committete LF-Fassung)
    Index-Eintrag:        size: 5781                  (die Groesse der CRLF-Arbeitskopie)
    Arbeitskopie:         5781 Bytes                  (CRLF, inhaltlich gleich)

5716 + 65 CR = 5781 — die Rechnung geht auf. Der Index trug also die **Groesse
der CRLF-Datei** neben dem **Hash der LF-Fassung**, und genau deshalb sah git
nicht hinein: Zeitstempel und Groesse passten zueinander.

Die frühere Fassung dieses Beispiels beschriftete die 5716 als Arbeitskopie.
Das trug nicht: eine Arbeitskopie mit 5716 Bytes und LF wäre byteidentisch zum
Blob, und dann gäbe es nichts anzugleichen.

**Behebung.** `tools/zeilenenden-angleichen.pl` schreibt jede betroffene Datei
mit dem HEAD-Stand woertlich neu - aber nur, wenn sie sich danach nachweislich
byteidentisch dazu verhaelt. Dateien mit echten inhaltlichen Aenderungen bleiben
unangetastet und werden aufgezaehlt. Anschliessend muss der Index einmal
aufgefrischt werden, weil `git update-index --really-refresh` die veralteten
Groessenangaben nicht korrigiert:

    perl tools/zeilenenden-angleichen.pl --aendern
    git ls-files -z | xargs -0 -n 400 git add --

Danach meldete `git status` genau die zwei Dateien mit echten Aenderungen.

**Was sich dadurch aendert.** Jede kuenftige Aenderung erzeugt einen Unterschied,
der nur die tatsaechlich geaenderten Zeilen zeigt. Die pre-commit-Schranke
`tools/pruefe-bytes.pl` bleibt sinnvoll - sie faengt jetzt echte Schaeden statt
Nachwirkungen des Auscheckens. Ein Werkzeug, das die Datei komplett neu
schreibt, faellt weiterhin auf.

**Das Werkzeug gehoert nach jedem frischen Klon einmal ausgefuehrt.** Steht so
in README.md.

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

## M-1 - Menues lassen sich nicht oeffnen: der Rahmen liefert immer HTERROR

Bearbeiter MENUE, reine Quellcodeanalyse (kein Programmstart). Die
ausfuehrliche Fassung mit allen Belegen steht in
`Eudora71/OTShim/BEFUND-MENUE.md`.

**Ursache.** `SECToolBarManager` setzte `m_bMainFrameEnabled` im Konstruktor
auf `TRUE` (`Eudora71/OTShim/OTShim_Werkzeugleiste.cpp:3480` und `:3506`).
`CMainFrame::OnNcHitTest` (`Eudora71/Eudora/mainfrm.cpp:8662-8671`) liefert bei
`IsMainFrameEnabled() == TRUE` **immer** `HTERROR`. Damit ist die gesamte
Nichtklientenflaeche des Hauptfensters tot: Menueleiste, Titelzeile,
Systemmenue, die Knoepfe Minimieren/Maximieren/Schliessen und die Rahmenkanten.
Ein Klick auf "File" erreicht nie `WM_NCLBUTTONDOWN` mit `HTMENU` und damit nie
den Menuemodus.

**Warum der Ausgangswert falsch war.** Die Stingray-Kopfdatei
(`Eudora71/OT501/Include/tbarmgr.h:79-80, 213`) beschreibt `TRUE` als
"Hauptfenster ist freigegeben". Eudora liest den Wert an allen fuenf
Abfragestellen andersherum - `TRUE` heisst dort "der Anpassen-Dialog steht
offen". Zwei Stellen sagen es im Klartext: `mainfrm.cpp:2990` ("with a
customize dialog still active") und `mainfrm.cpp:8744` ("We have a customize
dialog up"). Der Schlussstein ist ein Widerspruchsbeweis: waere `TRUE` der
Normalzustand, haette schon Eudora 7.1 eine tote Menueleiste gehabt.
`HTERROR` kommt im ganzen Baum genau einmal vor (`mainfrm.cpp:8670`).

**Behoben** in `Eudora71/OTShim/OTShim_Werkzeugleiste.{h,cpp}`: Ausgangswert
`FALSE` in beiden Konstruktoren, Kommentare berichtigt, Waechter in
`DisableMainFrame` gerichtet, und ein Rueckweg `RestoreMainFrame()` aus dem
Anpassen-Zustand ergaenzt (sonst bliebe der Schalter nach dem ersten Besuch von
"Tools -> Customize Toolbars" auf `TRUE` stehen und die Menueleiste waere
wieder tot). Uebersetzt fehlerfrei; das Binden scheitert nur an nicht
mitgebautem `imap.lib`.

**Nicht gemessen:** die Wirkung im laufenden Programm. Vier Fragen an Gregor
entscheiden das ohne Debugger - im kaputten Bau muessten auch das Verschieben
am Titelbalken, das Ziehen an den Rahmenkanten und die Fensterknoepfe tot
gewesen sein, waehrend **Alt+F** weiterhin funktioniert haben muesste (die
Tastatur laeuft ueber `SC_KEYMENU`, nicht ueber den Hit-Test).

**Widerspruch, offen:** Gregors Beobachtung, die Menues haetten zwischendurch
funktioniert, passt nicht zu M-1 - der Schalter ist vom Umgebungszustand
unabhaengig. Verdacht (UNGEPRUEFT): der funktionierende Bau lag vor `91716bb`,
dem Commit, der `m_bMainFrameEnabled = TRUE` eingefuehrt hat.

**Ausgeschlossen (mit Beleg, siehe BEFUND-MENUE.md):** MDI-Menueverschmelzung,
Fokusdiebe und Erfassung in der Ersatzschicht, Zeitgeber- und Leerlaufpfade
(der MFC-Leerlauf laeuft waehrend des Menuemodus gar nicht, `WM_ENTERIDLE`
kommt mit `MSGF_MENU`), sowie `SECDockState::LoadState` bei leerer INI.

**Nebenbefund:** frische Arbeitsbaeume standen auf `origin/main` (`22a6d77`);
dort bricht der Bau am laengst behobenen `C2572` ab. Der lebende Stand ist
`eudora-exe-linkt`.

## A-1 — Erscheinungsbild (S-6): Ursache von Punkt 2 gefunden, Punkt 1 eingegrenzt (30.08.2026)

> **BERICHTIGUNG vom 31.08.2026.** Überschrift und Vorbemerkung galten für die
> **erste** Sitzung. In der zweiten Sitzung sind fünf Punkte umgesetzt worden
> (`db28adb`, `1a4a6d5`): `DrawDisabled` setzt Text- und Hintergrundfarbe,
> `PreDrawButton` prüft `::SelectObject`, `TBBS_HIDDEN` ist ausgeräumt, die
> Andockrechnung wertet `m_fPctWidth`, `nCol` und `nRow` aus. Die Wirkung ist
> am 31.08. am laufenden Programm **belegt** (E-1, E-2): Menüs, Anordnung und
> Werkzeugleiste stimmen. **Sämtliche Zeilenangaben dieses Abschnitts beziehen
> sich auf `31810e2` und stimmen im heutigen Baum nicht mehr** — Befund Z-1 hat
> das nachgemessen. Offen bleiben die Splitter,
> `FloatControlBarInMDIChild` und `SetControlBarWidthsInRow` (`OTShim.cpp:2244`,
> leerer Rumpf), dazu PR-2.5 (`DrawChecked` hat denselben Farbfehler).
> LEKTOR und Z-1 hatten diese Berichtigung beide gemeldet; ausgeführt wurde sie
> erst jetzt.

Agent ANSICHT, Branch `worktree-agent-a84c76a2ea910c75d`, ausgehend von
`31810e2`. **Kein Code geändert** (Stand der ersten Sitzung) — sie wurde vor
der Umsetzung abgebrochen. Vollständige Analyse mit allen Fundstellen in
[`Eudora71/OTShim/BEFUND-ANSICHT.md`](Eudora71/OTShim/BEFUND-ANSICHT.md).

### Die sich überlagernden Bereiche: Ursache belegt

Es ist kein Fehler, sondern eine **offene Baustelle**. Die Ersatzschicht sagt es
an ihrer eigenen Deklaration (`OTShim.h:695-699`): die prozentualen
Zeilenbreiten (`m_fPctWidth`) und die Splitter sind nicht umgesetzt, „die
Leisten liegen dadurch so, wie `CDockBar` sie anordnet".

Nachgemessen in `Eudora71/OTShim/OTShim.cpp`:

| Stelle | Zustand |
|---|---|
| `SECDockBar::CalcFixedLayout` Z. 2505 | reicht 1:1 an MFC durch |
| `SECDockBar::OnSizeParent` Z. 2990 | reicht 1:1 an MFC durch |
| `SECDockBar::NormalizeRow` Z. 2239 | zählt nur, **verteilt keine Breite** |
| `SECDockBar::SetControlBarWidthsInRow` Z. 2226 | leerer Rumpf |
| `SECMDIFrameWnd::DockControlBarEx` Z. 274 | legt `fPctWidth` ab, **wertet es nicht aus**; verwirft zusätzlich `nCol` und `nRow` |

Dazu `SECControlBar::CalcFixedLayout` (`OTShim.cpp:1606`): bei `bStretch`
liefert sie **32767** in Zeilenrichtung. Jede Wazoo-Leiste fordert also die
volle Zeilenbreite an, und MFCs `CDockBar` kennt keine anteilige Aufteilung
einer Zeile. Daraus folgen unmittelbar drei der vier gemeldeten
Auffälligkeiten: Adressbuch über Nachrichtenliste, der leere senkrechte
Streifen, und „Task Status/Task Errors" mitten im Fenster.

Bestätigt wird der frühere Ausschluss: an der abgeschalteten Werbeleiste liegt
es nicht (`DockBar.cpp:51-75`, `82-99` prüfen selbst auf `SWM_MODE_ADWARE`).

### Die leeren Werkzeugleisten-Knöpfe: fünf Ursachen ausgeschlossen

Gemessen (Einzelheiten in `BEFUND-ANSICHT.md`):

- Vorgabe ist **große Knöpfe** (`EudoraRes.rc:7648`), also `IDR_MAINFRAME32/A/B`.
- Alle sechs Werkzeugleisten-Bitmaps sind 24 bpp; Bildzahlen 64/61/51 stimmen
  exakt mit `Breite/Höhe` überein; **keine `SEPARATOR`-Zeile** in den
  Ressourcen.
- **Alle 15 Standardknöpfe** (`mainfrm.cpp:684-711`) liegen mit Index 0–62 im
  **ersten** Bitmap. Das Zusammensetzen der drei Ressourcen
  (`QCToolBarManager.cpp:283-540`) ist damit als Ursache **ausgeschlossen** —
  es könnte nur alle 15 gleichzeitig treffen, nicht einzelne.
- `IDToBmpIndex` liefert bei unbekannter Kennung 0 → **falsches** Symbol, nie
  ein leeres Feld. Ausgeschlossen.
- `secData` ist echt gefüllt (`OT501/Src/secaux.cpp:23`, im Projekt unter
  `Eudora.vcxproj:217`). Ausgeschlossen.
- `QCCustomToolBar` überschreibt das Zeichnen nicht — gemalt wird ausschließlich
  in der Ersatzschicht.

**Übrig bleibt der Zeichenweg je Knopf.** Stärkster Verdacht (UNGEPRÜFT):
`SECStdBtn::DrawDisabled` (`OTShim_Werkzeugleiste.cpp:786-801`) lässt vor dem
Einfarbig→Farb-`BitBlt` das Paar `SetTextColor(0)` / `SetBkColor(0xFFFFFF)`
weg, das die klassische Vorlage dort zwingend setzt. Weil `CDC::FillSolidRect`
in `DrawFace` (Z. 704) die Hintergrundfarbe auf `clrBtnFace` stehen lässt,
übersetzt GDI die Maskeneins nicht nach Weiß, sondern nach `clrBtnFace` — und
die Verknüpfungszahl `PSDPxax` setzt Weiß/Schwarz voraus. Das passt als
einziger Kandidat auf das Muster „mehrere leer, andere da": auf einer frisch
gestarteten Eudora sind gerade acht der fünfzehn Knöpfe gesperrt, und auf
Gregors **Vergleichsbild** ist ein Nachrichtenfenster offen, dort wären
dieselben Knöpfe freigegeben.

### Bauzustand

`Eudora.vcxproj` Debug/Win32 endet an `31810e2` **unverändert** mit
`LNK1104: imap.lib`. Alle Quelldateien übersetzen fehlerfrei. Nebenbefund: der
MSBuild-Aufruf aus der Arbeitsanweisung läuft in der **Git-Bash nicht** (sie
macht aus `/p:Configuration=Debug` einen Pfad) — er gehört in PowerShell, und
Visual Studio liegt auf diesem Rechner unter **Professional**, nicht Community.

## P-1 - Der POP-Abrufpfad, vor dem ersten echten Abruf gegengelesen

**Geprueft am:** 2026-08-30, Agent POSTBOTE, Branch `worktree-agent-a09934fad08c602f1`
**Anlass:** Kriterium 3 aus `ZIEL.md` ist nie geprueft worden. Gregor will als
naechstes ein freenet-Konto einrichten und Mail abrufen.
**Verfahren:** nur Quellcode und Komponententests. Kein Eudora gestartet, keine
Verbindung zu einem Mailserver, keine Zugangsdaten benutzt.
**Ablieferung nebenan:** `ABRUF-PRUEFEN.md` im Wurzelverzeichnis.

### P-1.0 Die Kette, um die es geht

```
ID_FILE_CHECKMAIL (EudoraRes.rc)
  -> CMainFrame::OnFileCheckMail        mainfrm.cpp:3428
  -> CEudoraApp::OnCheckMail            eudora.cpp:791
  -> ::GetMail(bitflags)                GetMail.cpp:82
       QCPOPSettings::GrabSettings      QCMailSettings.cpp:138  (POPAccount, POPPort)
       QCSSLSettings::GrabSettings      SSLSettings.cpp:71      (SSLReceiveUse, SSLPOPAlternatePort)
  -> CPOPSession (Worker-Thread)        POPSession.cpp:286 / DoWork:478
  -> CPOPSession::GetMail               POPSession.cpp:520
       SetupNetConnection_ 3190 -> CreateNetConnectionMT -> QCWorkerSocket
       OpenPOPConnection_  1690 (Port 110 / 995 / kpop 1110)
       [implizites TLS]     602 -> SetSSLMode -> qcssl.dll: BeginQCSSLSession
       POPAuthenticate_    2047: Banner, CAPA 752, STLS 3479, USER/PASS 2175/2176, STAT 2267
       DoGetPOPMailToSpool  916 -> POPGetMessageToSpool 1027: LIST 1045, RETR 1085, DELE 1174
                                -> FetchMessageToSpool 1207 (ReadPOPLine 2364 -> Spool-Datei)
  -> CPOP::GetMailFromSpool             pop.cpp:123
       FetchMessageTextFromSpool 461 -> WriteMessageToMBX_ 656
            HeaderDesc::Read  header.cpp:77 (+ Fix2047/Translate2047 lex822.cpp:554/514)
            MIMEState::Init   mime.cpp:109 -> Reader::ReadIt -> Base64Decoder/QPDecoder
       CTocDoc::UpdateSum/WriteSum      pop.cpp:596/639
```

### P-1.1 BEHOBEN: `TextReader::ReadIt` warf die neue Laenge von `ISOTranslate` weg

**Sicherheit: nachgewiesen (Komponententest).**
**Datei:** `Eudora71/Eudora/TextReader.cpp:251`.

`ISOTranslate` (utils.cpp:1162) uebersetzt an Ort und Stelle. Jede uebersetzte
Mehrbytefolge macht den Text **kuerzer** - die Funktion liefert deshalb die neue
Laenge zurueck. Die Aufrufstelle warf sie weg:

    ISOTranslate(buf, size, iCharsetIdx);        // vorher
    size = ISOTranslate(buf, size, iCharsetIdx); // jetzt

`size` behielt also die Laenge **vor** der Uebersetzung. Alles, was danach mit
`size` rechnet, lag daneben:

- `buf[size-2] != '\r'` (Z. 260) - die CRLF-Erkennung greift ins Leere. Jede
  Zeile mit einem Umlaut galt als "nicht mit CRLF beendet" und lief in den
  Sammelpuffer statt direkt in die Mailbox.
- `PutWithEscapedFileMarkers(buf, size, ...)` (Z. 312) - schreibt hinter den
  uebersetzten Text die Nullterminierung **und** je uebersetztem Zeichen ein
  Restbyte der alten Fassung in `In.mbx`.

**Warum es bis heute nicht auffiel - und ab jetzt jede deutsche Mail trifft.**
Im Originalcode von 2006 (`567a5d8:Eudora71/Eudora/utils.cpp`) hatte die
UTF-8-Zeile der Uebersetzungstabelle **27 Eintraege**, ausschliesslich
CP1252-Sonderzeichen (Anfuehrungsstriche, Gedankenstriche, Eurozeichen).
Deutsche Umlaute waren nicht dabei: `C3 A4` blieb `C3 A4`, der Text wurde nicht
kuerzer, und der Fehler blieb stumm. Heute hat die Tabelle **123 Eintraege**
(`utils.cpp:46`), darunter der komplette Latin-1-Bereich U+00A0..U+00FF. Damit
wird ab sofort **jede Zeile mit einem Umlaut** kuerzer - und der seit 2006
schlafende Fehler waere bei Gregors erstem Abruf sofort sichtbar geworden.

Der Fehler ist **kein Portierungsschaden**: die Zeile steht wortgleich in
`567a5d8`. Erst die Erweiterung der Tabelle hat ihn geweckt.

**Abgesichert durch:** `Eudora71/Tests/TestPopEmpfang.cpp`, Test
"POP: TextReader::ReadIt uebernimmt die neue Laenge von ISOTranslate" - ein
Waechter auf den Quelltext, damit die Zuweisung nicht wieder verschwindet.

### P-1.2 GEPRUEFT UND IN ORDNUNG: der POP-Pfad ist vom IMAP-Zeichensatzfehler nicht betroffen

**Sicherheit: nachgewiesen (Komponententest).**

Bekannt war: `EuImap/src/ImapDownload.cpp:4644` ruft `FindRStringIndexI` direkt
auf und gibt das Ergebnis **ohne die Verschiebung um eins** an `ISOTranslate`.

Der POP-Pfad geht einen anderen Weg. `TextReader.cpp:85` und `lex822.cpp:516`
benutzen `FindMIMECharset` (`mime.cpp:382`), und das zaehlt den Wert hoch:

    iCharSet = FindRStringIndexI(IDS_MIME_US_ASCII, IDS_MIME_UTF_8, charSet, -1);
    if (iCharSet >= 0) ++iCharSet;      // "Bump index to avoid conflict with windows"

Gemessen (Test "POP: der Index wird um eins verschoben"):

| Zeichensatz | roher Index (IMAP) | `FindMIMECharset` (POP) | Wirkung des rohen Index |
|---|---|---|---|
| `iso-8859-15` | 2 | 3 | 2 ist "<= 2" - gar keine Uebersetzung |
| `utf-8` | 3 | 4 | 3 waehlt nach `-3` die Zeile 0, also die **ISO-8859-15-Tabelle**; aus `C3 BC` wird `C3 8C`, der Text ist danach kaputt |

Zusaetzlich sucht IMAP nur bis `IDS_MIME_ISO_LATIN9` - `utf-8` findet es gar
nicht und bekommt `-1`. Der IMAP-Pfad uebersetzt damit ueberhaupt keine
Zeichensaetze. **Gregor benutzt POP, ist also nicht betroffen.**

### P-1.3 GEPRUEFT UND IN ORDNUNG: Betreff und Absendername laufen ueber denselben Pfad wie der Text

Beide gehen durch `HeaderDesc::Read` (header.cpp:77) und von dort durch den
Lexer (`lex822.cpp:777`), der `Fix2047` aufruft. `Fix2047` (lex822.cpp:554)
zerlegt `=?Zeichensatz?Kodierung?Text?=` und gibt den Inhalt an `Translate2047`
(lex822.cpp:514): erst `PseudoQP` bzw. `DecodeB64String`, dann **dasselbe**
`ISOTranslate` mit **demselben** Index aus `FindMIMECharset`.

Der Rueckgabewert wird hier zu Recht nicht gebraucht: `Fix2047` arbeitet
anschliessend mit `strcpy`/`strlen`, und `ISOTranslate` setzt die
Nullterminierung an die neue, kuerzere Stelle (utils.cpp:1277). P-1.1 betrifft
den Kopfzeilenpfad also nicht.

Gemessen an echten Kopfzeilen (`TestPopEmpfang.cpp`, neun Tests):

| Eingabe auf der Leitung | Ergebnis |
|---|---|
| `=?UTF-8?B?R3LDvMOfZQ==?=` | `Gr` FC DF `e` |
| `=?utf-8?Q?Gr=C3=BC=C3=9Fe?=` | `Gr` FC DF `e` |
| `=?iso-8859-1?Q?Gr=FC=DFe?=` | `Gr` FC DF `e` (Index 2, keine Uebersetzung noetig) |
| `=?utf-8?B?4oKsIDUw?=` | 80 ` 50` (Eurozeichen, 3 Bytes -> 1) |
| `=?UTF-8?B?SsO8cmdlbiBTY2jDtm4=?= <juergen@example.org>` | `J` FC `rgen Sch` F6 `n <juergen@example.org>` |
| `Re: =?utf-8?Q?Gr=C3=BC=C3=9Fe?= aus Bremen` | `Re: Gr` FC DF `e aus Bremen` |
| `=?utf-8?Q?Gr=C3=BC=C3=9Fe?= =?utf-8?Q?_und_Dank?=` | `Gr` FC DF `e und Dank` (Zwischenraum faellt weg, RFC 2047 6.2) |
| `=?koi8-r?B?VGVzdA==?=` | bleibt woertlich stehen (unbekannter Zeichensatz) |
| `=?utf-8?X?VGVzdA==?=` | bleibt woertlich stehen (unbekanntes Verfahren) |

### P-1.4 Die Portierung hat den Abrufpfad nicht angefasst

**Sicherheit: nachgewiesen** (Vergleich gegen `567a5d8`, den Commit mit den
Originalquellen).

Der gesamte Unterschied im POP-Abrufpfad zwischen 2006 und heute sind **sechs
Zeilen**, und keine davon aendert die Bedeutung:

| Fundstelle | Aenderung | Bewertung |
|---|---|---|
| `POPSession.cpp:1711, 2232, 2429, 2473` | `strchr(...)` -> `const_cast<char*>(strchr(...))` | C++-const-Ueberladung; alle vier Zeiger werden nur gelesen |
| `header.cpp:240` | dieselbe Aenderung | dito |
| `QCWorkerSocket.cpp:47` | `#include <xstddef>` -> `<functional>` | verhaltensneutral |

`SSLSettings.cpp`, `QCMailSettings.cpp` und `pop.cpp` sind **byteidentisch** zum
Original.

Ebenfalls geprueft und in Ordnung: `Eudora71/QCSSL/src/qcssl.def` ist in
`QCSSL.vcxproj` (Z. 79 und 123) fuer Debug **und** Release als
`ModuleDefinitionFile` eingehaengt. Die elf `QCSSL*`-Exporte bleiben damit
undekoriert, und die `GetProcAddress`-Aufrufe in `Network::SetSSLMode`
(`QCWorkerSocket.cpp:373-383`) finden ihre Symbole trotz `__stdcall`. Das war
der naheliegendste Weg, wie die Portierung SSL-POP still haette brechen koennen
- sie hat es nicht.

**`char` mit Vorzeichen: kein Fund.** `POPSession.cpp:1837` und `:2279` casten
schon im Original nach `unsigned char`, bevor sie `isspace`/`isdigit` rufen.
Keine Tabellenindizierung mit rohem `char` im geprueften Bereich.

**`time_t` 32 -> 64 Bit:** die einzige Kategorie, in der der Uebersetzerwechsel
Typen wirklich geaendert hat. Betroffen: `QCWorkerSocket.cpp:1728/1739`
(Netzwerk-Zeitgrenze), `POPSession.cpp:2264` und `:361/341`
(`IDS_INI_POP_LAST_AUTH` ueber `SetIniLong`/`GetIniLong`), `pop.cpp:690-694`
(Zeitstempel der `From ???@???`-Zeile). Alle Werte bleiben bis zum 19.01.2038
verlustfrei, `_USE_32BIT_TIME_T` ist nirgends gesetzt. **Keine auf Platte
geschriebene Struktur mit `time_t`** im POP-Pfad - das INI-Format bleibt
kompatibel. Kein Handlungsbedarf.

### P-1.5 OFFEN: Altlasten aus 2006, die den ersten Abruf treffen koennen

Alle folgenden Stellen stehen **wortgleich in `567a5d8`**. Sie sind keine
Portierungsschaeden, aber sie liegen auf dem Weg, den Gregors erster Abruf
nimmt. Nichts davon wurde geaendert - hier steht nur, worauf zu achten ist.

**P-1.5a  NULL-Zeiger nach gescheiterter SSL-Aushandlung.**
`QCSocket/src/QCWorkerSocket.cpp:1961-1972`. `pConnectionInfo` wird in Z. 1961
geprueft, in Z. 1969 (`pConnectionInfo->m_Outcome.m_bCertRejected`) aber
ungeprueft dereferenziert; dieselbe Stelle nochmals in `:1989-1992`. Liefert
`QCSSLGetConnectionInfo` nach einem gescheiterten Handshake NULL, stuerzt Eudora
ab, statt eine Fehlermeldung zu zeigen. **Das ist der wahrscheinlichste
Absturzpunkt beim ersten Abruf, wenn etwas mit dem Zertifikat nicht stimmt.**
Wenn Eudora beim Abruf kommentarlos verschwindet: hier zuerst nachsehen.

**P-1.5b  `sscanf` mit unbegrenztem `%s` auf Serverdaten.**
`POPSession.cpp:1050-1052`: `char szDummy[40]` und
`sscanf(szBuffer, "%s %d %ld", szDummy, ...)` auf der 3072 Byte grossen
`LIST`-Antwort. Ein Server, dessen erstes Token laenger als 39 Zeichen ist,
ueberschreibt den Stapel. Unter VS2022 greift `/GS` - daraus wird ein
kontrollierter Absturz statt stiller Verfaelschung. Richtig waere `%39s`.

**P-1.5c  Schleife laeuft ein Byte unter den Puffer.**
`POPSession.cpp:1305-1306` in `FetchMessageToSpool`:
`while (Len >= 0 && (szBuffer[Len-1] == '\r' || ...)) szBuffer[--Len] = 0;`
Bei `Len == 0` wird `szBuffer[-1]` gelesen und geschrieben. Muss `Len > 0`
heissen. **UNGEPRUEFT**, ob ein Pfad `Len == 0` ueberhaupt erreicht -
`Network::GetLine` normalisiert nacktes LF zu CRLF. Die Zeile ist unabhaengig
davon falsch.

**P-1.5d  `strncpy` ohne Nullterminierung, Servername.**
`POPSession.cpp:1739`: `char Server[128]; strncpy(Server, pszPOPServer, sizeof(Server));`
- `sizeof` statt `sizeof-1`, kein `Server[127] = 0`. Ab 128 Zeichen Servername
lesen `stricmp` (Z. 1742) und `Open()` ueber das Array hinaus. Gleiches Muster
in `POPSession.cpp:3342` und `:3344`.

**P-1.5e  Ungeprueftes `strcpy` aus den Einstellungen.**
`POPSession.cpp:2154-2155` (`char szPOPUserName[128]` aus `GetPOPAccount()`),
`:2190-2192` (`char szPassword[255]`, abgesichert nur durch ein `ASSERT`, das im
Release wegfaellt), `:1785-1795` (`char szCommand[3072]`, `strcpy` plus zwei
ungeprueften `strcat` mit Kommandoargumenten). Ein sehr langes Passwort oder
POP-Konto in der INI ueberlaeuft den Stapel.

**P-1.5f  SSL-Lesefehler wird verschluckt.**
`QCWorkerSocket.cpp:1280-1302`: `res` wird gesetzt, aber nie ausgewertet.
Schlaegt `QCSSLRead` fehl und laesst `nValid` unveraendert auf `m_nBufferSize`,
meldet `Read()` einen vollen Puffer alter Daten als gueltige Serverantwort.
**UNGEPRUEFT**, ob `QCSSLRead` `nValid` im Fehlerfall immer nullt.

**P-1.5g  `memmove` braucht zwei Bytes mehr als vorhanden.**
`POPSession.cpp:2407` in `ReadPOPLine`:
`memmove(pszBuffer+1, pszBuffer, ++nBytesRead);` - kopiert `nBytesRead+1` Bytes
ab Offset 1, braucht also `nBytesRead+2`. Bei einer maximal langen Zeile, die
mit `From ` beginnt, ein 1-Byte-Ueberlauf. **UNGEPRUEFT** (haengt an der genauen
Obergrenze in `GetLine`, die bei `len-1` liegt).

**P-1.5h  Zeiger durch 32-Bit-Typen.**
`QCWorkerSocket.cpp:1469` (`SetWindowLong(m_hWnd, GWL_USERDATA, (LONG)this)`,
Rueckweg `:1480`, Loeschen `:526`) und `:1841/1848/1899` (`long lArg` traegt
einen `QCSSLReference*`). Auf **Win32/x86 exakt 32 Bit und damit heute
harmlos.** Es ist aber der Punkt, an dem eine spaetere x64-Umstellung sofort und
vollstaendig bricht - jede Winsock-Nachricht des POP-Sockets und der ganze
SSL-Datenstrom laufen hier durch. Richtig waere `SetWindowLongPtr`/`GWLP_USERDATA`
und `LPARAM` statt `long`.

**P-1.5i  Warnungen sind dateiweit abgeschaltet.**
`QCWorkerSocket.cpp:46`: `#pragma warning(disable: 4786 4663 4244 4018 4146 4100)`.
**4244** (Datenverlust bei Konvertierung) und **4018** (signed/unsigned-Vergleich)
sind genau die Warnungen, mit denen VS2022 die obigen Kategorien in dieser Datei
melden wuerde. Die Portierung ist hier blind.

**P-1.5j  `size_t`-Unterlauf bei leerem Ressourcentext.**
`header.cpp:113-114`: `interesting[h][strlen(interesting[h]) - 1] = 0;` - ist
eine der 14 Kopfzeilen-Ressourcen leer, ergibt `strlen(...)-1` den Wert
`0xFFFFFFFF`. Alle 14 Plaetze werden in Z. 96-109 befuellt; nur der Leerstring
ist offen.

**Kleinigkeiten ohne praktische Wirkung:** `POPSession.cpp:1031`
(`char szMessageNum[10]` fuer `%d`, braeuchte 12 - erst ab 1 Mrd. Nachrichten),
`:2394` (`strcpy` auf ueberlappenden Puffern, formal UB), `:759-760`
(`strnicmp(szBuffer,"MANGLE",5)` - Laenge um eins zu klein, trifft trotzdem),
`QCWorkerSocket.cpp:1086` (`if (!m_szMachine)` auf einem Array - immer falsch,
tote Pruefung), `:1137` (`wsprintf` mit Hostnamen in `char Buffer[256]`, nur im
Fehlerpfad erreichbar).

### P-1.6 Der zurueckgestellte Zertifikats-Patch beeintraechtigt den Abruf NICHT

`tools/patches/zertifikatspruefung-verschaerfen.patch` ist **nicht angewandt**
und wurde von mir auch nicht angefasst.

Er wirkt in die **sichere** Richtung: heute behandelt
`QCCertificateUtils::CertificateCallback` die Pruefergebnisse
`X509_V_ERR_CERT_UNTRUSTED` und `X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE` als
Erfolg (`iOK = 1`), ohne dem Anwender etwas zu zeigen. Ohne den Patch ist Eudora
also **nachsichtiger** und nimmt mehr Zertifikate an. Der erste Abruf wird daran
nicht scheitern. Erst mit dem Patch wuerde Eudora Zertifikate ablehnen, die es
heute klaglos annimmt.

### P-1.7 Neue Komponententests

`Eudora71/Tests/TestPopEmpfang.cpp` (11 Tests), dazu die Uebersetzungseinheit
`Eudora71/Tests/UnderTest2047.{h,cpp}` und sechs neue Schnittregionen in
`Eudora71/Tests/Extract.ps1`.

Wie im Testprojekt ueblich steht in den Testdateien **kein abgeschriebener
Produktivcode**: `Extract.ps1` schneidet bei jedem Bau frisch aus
`Decode.h`, `Base64.h`, `Base64.cpp`, `mime.cpp` (`FindMIMECharset`, `HexToString`)
und `lex822.cpp` (`PseudoQP`, `DecodeB64String`, `Translate2047`, `Fix2047`).
Nachgebildet ist nur `FindRStringIndexI`, weil im Test keine Ressourcen-DLL
vorliegt; die vier Zeichensatznamen stammen woertlich aus `EudoraRes.rc:9385-9388`.

**Ergebnis am 30.08.2026:**

    Ergebnis: 34 Tests, 34 bestanden, 0 fehlgeschlagen

(vorher 23; die 11 neuen sind die aus P-1.2, P-1.3 und der Waechter aus P-1.1.)
Aufruf: `Eudora71\Tests\RunTests.cmd`.

### P-1.8 NICHT GEPRUEFT: Eudora.vcxproj baut aus dem eingecheckten Stand nicht

In einem frischen Worktree auf `22a6d77` bricht
`MSBuild Eudora71\Eudora\Eudora.vcxproj /p:Configuration=Debug /p:Platform=Win32`
schon bei `stdafx.cpp` ab:

    OT501\Include\secbtns.h(340,83): error C2572: "SECLoadSysColorBitmap":
      Neudefinition des Standardarguments: Parameter 1
      Siehe Deklaration von "SECLoadSysColorBitmap" in OTShim\OTShim.h(306,13)

Im gemeinsamen Arbeitsverzeichnis liegen dazu **nicht eingecheckte** Aenderungen
an `OTShim.h`, `OTShim.cpp`, `OTShimAll.h`, `OTShim_Reiter.cpp` sowie vier neue
Dateien (`OTShim_Knopf.cpp`, `OTShim_Fremdsymbole.cpp`, `OTShim_Libpng.cpp`,
`OTShim_Spur.cpp`). Der Bau gelingt also nur mit der Arbeit anderer Agenten, die
noch nicht committet ist. Das ist deren Baustelle, nicht meine.

**Folge fuer P-1.1:** die Aenderung an `TextReader.cpp:251` ist deshalb **nicht
durch den Uebersetzer gelaufen.** Das Risiko ist klein - `size` ist als `LONG`
deklariert (`TextReader.cpp:77`), `ISOTranslate` liefert `LONG`
(`utils.h:90`), es ist eine typgleiche Zuweisung. Aber gemessen ist es nicht.
**Vor der naechsten Auslieferung `Eudora.vcxproj` bauen und das nachholen.**

Das Testprojekt `Eudora71\Tests\Tests.vcxproj` baut und laeuft dagegen sauber -
es haengt nicht an OTShim.

---

## Stand und naechster Schritt (POSTBOTE, 30.08.2026)

**Fertig und im Branch:**

- `ABRUF-PRUEFEN.md` - die Anleitung fuer Gregors ersten Abruf
- P-1.1 behoben (`TextReader.cpp:251`), mit Waechtertest
- 11 neue Komponententests, alle gruen (34 von 34)
- der Abrufpfad ist ganz gegengelesen, Portierungsschaeden ausgeschlossen (P-1.4)

**Was ich als naechstes getan haette, in dieser Reihenfolge:**

1. **`Eudora.vcxproj` bauen**, sobald die OTShim-Arbeit committet ist, und damit
   P-1.8 schliessen. Das ist der einzige offene Punkt an meiner eigenen
   Aenderung.
2. **P-1.5a absichern** - die NULL-Pruefung in `QCWorkerSocket.cpp:1969` und
   `:1989`. Das ist ein Zweizeiler und verwandelt einen Absturz beim ersten
   Abruf in eine Fehlermeldung. Von allen Punkten unter P-1.5 der mit dem
   besten Verhaeltnis von Aufwand zu Nutzen.
3. **P-1.5b** (`%39s` statt `%s`) und **P-1.5d** (`sizeof(Server)-1` plus
   Nullterminierung) - beides Einzeiler auf dem Abrufweg.
4. Einen Test bauen, der eine vollstaendige POP-Antwort aus einem Puffer
   einspeist. Das braucht einen Ersatz fuer `LineReader` und `JJFile`; ich habe
   stattdessen die beiden Stellen einzeln geprueft, an denen der Zeichensatz
   umgesetzt wird. Der durchgehende Test waere die naechste Ausbaustufe.
5. Den Zeichensatzfehler im IMAP-Pfad (`ImapDownload.cpp:4644`) beheben - er ist
   in P-1.2 genau vermessen, betrifft Gregor aber nicht, weil er POP benutzt.

**Nicht angefasst, wie verabredet:**
`tools/patches/zertifikatspruefung-verschaerfen.patch` bleibt liegen (P-1.6).

## PR-1 — Die Schranke `pruefe-bytes.pl` erkennt den halben Schaden nicht (geprueft 30.08.2026)

Nachgepruefter Stand: 371c1e3. Vollstaendiger Bericht: `PRUEFBERICHT.md`.
Drei Befunde an der Schranke, alle mit Gegenprobe in einem Wegwerf-Repo belegt.

**1. Die Umwandlung LF → CRLF laeuft lautlos durch.** `tools/pruefe-bytes.pl:105-125`
sucht nur die Richtung CRLF → LF (`$a->{$inhalt}[0] > 0` und `$b->{$inhalt}[0] == 0`).
Schreibt ein Werkzeug eine gemischte Datei komplett mit CRLF neu und aendert
dabei auch Inhalt, greift Regel 1 nicht mehr und Regel 2 sieht nichts:

    Datei a.cpp in HEAD: zeile1 LF, zeile2 CRLF, zeile3 LF, zeile4 CRLF
    Im Index: alles CRLF, zeile4 durch NEU ersetzt
    -> perl tools/pruefe-bytes.pl  ==>  Rueckgabe 0, keine Meldung

Dieselbe Aenderung in der Gegenrichtung wird korrekt gemeldet. Die Schranke ist
also einseitig — und CRLF ist unter Windows die wahrscheinlichere Richtung.

**2. Sie schlaegt bei Leerzeilen grundlos an.** Regel 2 vergleicht Zeilen ueber
ihren Inhalt. Der haeufigste Inhalt in einer gemischten Datei ist die leere
Zeile, und die kommt mit beiden Enden vor. Ein voellig normaler Commit:

    c.cpp in HEAD: void f() LF, { LF, Leerzeile CRLF, \tint a; LF, } LF
    Im Index: die CRLF-Leerzeile geloescht, \tint b; und eine LF-Leerzeile ergaenzt
    -> COMMIT ABGEBROCHEN ... z. B. ""

Kein einziges Byte wurde umgewandelt. Die Meldung nennt als Beispiel die leere
Zeichenkette und sagt damit nicht, wo man nachsehen soll. Das ist derselbe
Fehlalarm-Fehler, den 371c1e3 abstellen wollte — er ist nur von der CR-Anzahl
auf den Zeileninhalt umgezogen.

**3. Ganze Dateiarten werden gar nicht geprueft.** Die Endungslisten in
`tools/pruefe-bytes.pl:52` und `tools/zeilenenden-angleichen.pl:90` sind
verschieden: `.def` steht nur in einem, `.vcxproj`/`.filters` nur im anderen.
`.sln`, `.rc2`, `.bat`, `.cmd`, `.ps1`, `.pl`, `.props` stehen in keinem —
darunter die Bauwerkzeuge dieses Projekts. Eine `.def`-Datei komplett von CRLF
auf LF umgeschrieben: Rueckgabe 0.

**Behebung**, alle drei klein, aber bewusst NICHT ausgefuehrt: die Schranke
laeuft vor jedem Commit, an ihr ohne Zeit fuer eine saubere Gegenprobe zu
drehen ist schlechter, als sie so zu lassen.

  1. Regel 2 symmetrisch: dieselbe Pruefung mit vertauschten Feldern 0 und 1.
  2. Zeilen, deren Inhalt nach `s/\s+//g` leer ist, in Regel 2 uebergehen;
     ebenso Zeilen, die in HEAD schon mit beiden Enden vorkommen.
  3. Eine gemeinsame Endungsliste fuer beide Werkzeuge, ergaenzt um
     `def sln rc2 bat cmd ps1 pl props`.

**Weitere Befunde derselben Pruefung** (Einzelheiten in `PRUEFBERICHT.md`):

  * PR-4: `BuildKennung.h` ist in git verfolgt. Faellt perl beim Bau aus,
    bricht der Bau richtigerweise nicht ab — das Fenster zeigt dann aber die
    Kennung eines FREMDEN Baus statt gar keiner. `Eudora.vcxproj:63-72`.
  * PR-5: Der Zeitstempel in der Kennung ist nicht der Bauzeitpunkt, sondern
    der Zeitpunkt der letzten Aenderung an Commit oder Sauberkeit
    (`tools/kennung-erzeugen.pl:118-130`). Als Verhalten richtig, als
    Beschreibung falsch.
  * PR-6: `_T(EUDORA_BAU_KENNUNG)` in `mainfrm.cpp:9715` uebersetzt in einem
    Unicode-Bau nicht — `__T(x)` ist `L##x`, und `##` unterbindet die
    Makroerweiterung. Im MBCS-Bau, den dieses Projekt baut, faellt es nicht auf.
  * PR-7: In S-7 widersprechen sich die Zahlen (4616/5563 hier gegen 4426/5336
    im Kopf von `tools/zeilenenden-angleichen.pl`; nachgemessen sind es 5568
    verfolgte Dateien), und das Beispiel ist falsch beschriftet: 5716 Bytes ist
    die Groesse des LF-BLOBS, nicht die der Arbeitskopie. Der Kern der
    Erklaerung — git sieht nicht in die Datei, solange Zeitstempel und Groesse
    zum Index passen — stimmt.
  * PR-8: `tools/rekursion-suchen.pl` bildet jede Kante mit dem Klassennamen
    der umgebenden Methode (`:74`). Klassenuebergreifende Zyklen sind damit
    strukturell unsichtbar — auch der aus S-2, fuer den es gebaut wurde.
    Empfehlung: loeschen.

**Ausdruecklich nachgemessen und in Ordnung:** die CONTEXT-Versaetze in
`tools/stapel-untersuchen.ps1:141-143` (Ebp 180, Eip 184, Esp 196 sind fuer
x86 richtig) und die EBP-Kette, die wegen `if ($neuEbp -le $ebp) { break }`
streng steigen muss und deshalb nicht haengen kann; der PreBuildEvent, der den
Bau in keinem Zweig abbricht; `OnUpdateFrameTitle`, das in keine Rekursion
laeuft; und die Werbeleiste an `IsBoxBuild()` — der ganze Baum `Eudora71/`
wurde nach Nutzern durchsucht, keiner greift ins Leere. `IsBoxBuild()` ist eine
Uebersetzungszeit-Weiche ueber `BUILD_BOX_OR_SITE_R_VERSION`, und das Makro
steht in `Eudora.vcxproj` in BEIDEN Konfigurationen (Zeile 77 und 130) — wer es
entfernt, holt sich den Stapelueberlauf aus S-2 zurueck.

**Nichts davon haelt Paket 1.0.3 auf.**

## P-2 - Kriterium 3 abgesichert: der Absturzpunkt vor dem ersten Abruf ist behoben

**Geprueft am:** 2026-08-31, Agent POSTBOTE, Branch `abruf-absichern`
(aus `darstellung-und-menue`, `76efdb6`).
**Anlass:** Fortsetzung von P-1. Gregor will als naechstes selbst einen
Mailserver verbinden. P-1.5a nannte den wahrscheinlichsten Absturzpunkt, P-1.8
liess die Aenderung an `TextReader.cpp:251` unuebersetzt.
**Verfahren:** nur Quellcode und Uebersetzer. Kein Eudora gestartet, keine
Verbindung zu einem Mailserver, keine Zugangsdaten benutzt.
**Ablieferung nebenan:** `ABRUF-PRUEFEN.md`, Abschnitte 1 (Servername),
5a (SSL-Aushandlung) und 5b (Zertifikatsfehler) sind neu.

### P-2.1 BEHOBEN: NULL-Zeiger nach gescheiterter SSL-Aushandlung (war P-1.5a)

**Sicherheit: nachgewiesen (uebersetzt).**
**Datei:** `Eudora71/QCSocket/src/QCWorkerSocket.cpp`, Funktion
`QCWorkerSocket::InitializeQCSSL` (ab `:1938`).

Vier Zeilen, alle im Fehlerpfad einer gescheiterten SSL-Aushandlung:

| vorher | Fundstelle | jetzt |
|---|---|---|
| `pConnectionInfo= fnConnInfo(...)` | `:1957` | Aufruf nur noch `if (fnConnInfo)` |
| `if (pConnectionInfo->m_Outcome.m_bCertRejected)` | `:1969` | `if (pConnectionInfo && pConnectionInfo->...)` |
| `pConnectionInfo = fnConnInfo(...)` | `:1989` | Aufruf nur noch `if (fnConnInfo)` |
| `m_iSSLError = pConnectionInfo->...` und `if (pConnectionInfo->...)` | `:1991/:1992` | beide in ein `if (pConnectionInfo)` gefasst |

Die Stelle `:1969` war die wichtigste: Zeile 1961 prueft `pConnectionInfo`,
Zeile 1969 dereferenziert es acht Zeilen spaeter wieder ungeprueft. Der
Zweig `:1986-1997` (kein `TaskInfo`, also IMAP oder Hauptfaden) pruefte
ueberhaupt nicht.

**Neu hinzugekommen: der Funktionszeiger.** `fnConnInfo` kann NULL sein, ohne
dass etwas vorher schiefgelaufen sein muss. `Network::SetSSLMode`
(`:362-386`) bricht nur ab, wenn `LoadLibrary("qcssl")` scheitert; die zehn
`GetProcAddress`-Ergebnisse (`:373-383`) werden **gar nicht geprueft** und
`m_bSSLMode` wird trotzdem gesetzt. Laedt also eine `QCSSL.dll` der falschen
Fassung, in der `QCSSLGetConnectionInfo` fehlt, dann ist `fnConnInfo` NULL und
der Aufruf in `:1957` stuerzt ab - **noch bevor** die alte Fundstelle `:1969`
ueberhaupt erreicht wird. Genau dieser Fall ist bei Gregor moeglich, weil in
`Releases/1.0/` mehrere `QCSSL.dll`-Fassungen liegen.

**Die Meldung.** Ohne `ConnectionInfo` blieb `csError` bisher bei
`"SSL Negotiation Failed: "` stehen und `errorCode` bei `-1`. `SetError`
(`:680`) bildet daraus `CRString(8000 + (-1 - 10000))` = `CRString(-2001)` -
eine Ressourcen-ID, die es nicht gibt; `LoadString` liefert dann den
Leerstring. Gregor haette also `SSL Negotiation Failed: <nichts> Cause:
<nichts> (-1)` gesehen. Jetzt haengt in diesem Fall ein Klartext-Zusatz daran,
der auf die DLLs zeigt. Woertliche Zeichenkette statt neuer Ressourcen-ID -
dasselbe Muster wie `QCWorkerSocket.cpp:700`
(`"Connection closed by foreign host."`), damit `EudoraRes.rc` und
`resource.h` unangetastet bleiben und keine Ressourcen-DLL neu gebaut werden
muss.

Am Ablauf aendert sich sonst nichts: `SetError(csError, errorCode)` und
`m_bAbortConnection = TRUE` laufen wie bisher, der Abruf bricht geordnet ab.

**Uebersetzt:**
`MSBuild Eudora71\QCSocket\QCSocket.vcxproj /p:Configuration=Debug /p:Platform=Win32`
- Exit 0, `Eudora71\Bin\Debug\QCSocket.dll` erzeugt. `QCWorkerSocket.cpp`
fehlerfrei, nur die vorbestehenden `C4996`-Warnungen.

### P-2.2 BEHOBEN: derselbe Fehlertyp, umgekehrt - `pSettings` in `SetSSLMode`

**Sicherheit: nachgewiesen (uebersetzt). Heute nicht erreichbar.**
**Datei:** `Eudora71/QCSocket/src/QCWorkerSocket.cpp:2050-2051`.

`QCWorkerSocket::SetSSLMode` (`:2038`) dereferenzierte `pSettings` in den
Zeilen 2050/2051 ungeprueft - und prueft denselben Zeiger fuenfzehn Zeilen
weiter unten in `:2065` (`if(pSettings)`) sehr wohl. Der Autor hat NULL also
fuer moeglich gehalten. Er ist es auch: die Deklaration in
`QCWorkerSocket.h:62` und `:265` gibt `SSLSettings *pSettings = NULL` als
**Vorgabewert** an.

**Heute nicht erreichbar:** alle fuenf echten Aufrufer uebergeben die Adresse
eines Elements, die nie NULL sein kann - `POPSession.cpp:604` und `:3489`,
`SMTPSession.cpp:717` und `:837`, `password.cpp:392`, jeweils
`&m_Settings->m_SSLSettings`. Der einzige Aufruf mit Vorgabewerten ist
`Network::SetSSLMode(bVal)` in `:2041`, und das ist eine andere Funktion, die
`pSettings` gar nicht anfasst. Gefunden hat es die Suche unten, nicht ein
Absturz.

Behoben, weil es derselbe Fehlertyp ist und die Zeile auf dem Abrufweg liegt.
Die beiden Zuweisungen stehen jetzt in einem `if (pSettings)`.

### P-2.3 Der Abrufpfad ist nach demselben Muster abgesucht

**Verfahren:** `suche-zeiger.pl` (im Branch abgelegt) liest jede Datei mit
`:raw`, findet jede Zeile der Form `if (p)`, `if (!p)`, `if (p == NULL)`,
`if (p != NULL)`, verfolgt die Klammertiefe bis zum Ende des geschuetzten
Blocks und meldet jede Dereferenzierung desselben Namens in den 40 Zeilen
danach, sofern dazwischen nicht erneut geprueft wird.

Abgesucht: `QCWorkerSocket.cpp`, `POPSession.cpp`, `pop.cpp`, `GetMail.cpp`,
`header.cpp`, `TextReader.cpp`, `mime.cpp`, `lex822.cpp`, `QCMailSettings.cpp`,
`SSLSettings.cpp`.

Acht Treffer, einzeln nachgelesen:

| Fundstelle | Bewertung |
|---|---|
| `QCWorkerSocket.cpp:2050` | **echter Fund** - P-2.2, behoben |
| `QCWorkerSocket.cpp:453` | Fehlalarm: einzeiliges `if` ohne Block, der Aufruf ist der Rumpf |
| `QCWorkerSocket.cpp:2042` | Fehlalarm: `if(!m_pSSLReference) m_pSSLReference = DEBUG_NEW ...`; `new` wirft bei MFC, liefert nicht NULL |
| `POPSession.cpp:501`, `:896`, `:3228` | Fehlalarme: einzeiliges `if`, Zugriff im Rumpf |
| `pop.cpp:312` | Fehlalarm: sauberes `if (!p) {...} else {...}` |
| `pop.cpp:476` | Fehlalarm: Zugriff steht im geschuetzten Block |

Das Muster "geprueft und ein paar Zeilen spaeter ungeprueft benutzt" kommt im
Abrufpfad also **nur an diesen beiden Stellen** vor. Beide sind behoben.

**Was die Suche NICHT findet, und wo deshalb noch etwas liegen koennte:**
Zeiger, die nirgends geprueft werden. Die zehn ungeprueften
`GetProcAddress`-Ergebnisse in `QCWorkerSocket.cpp:373-383` sind der wichtigste
Fall dieser Art. Nur `QCSSLGetConnectionInfo` ist jetzt an seinen zwei
Verwendungsstellen abgesichert; `g_fnQCSSLBeginSession` (`:1944`),
`g_fnQCSSLWrite`, `g_fnQCSSLRead`, `g_fnQCSSLEndSession` sind es nicht.
**UNGEPRUEFT**, ob eine der ausgelieferten `QCSSL.dll`-Fassungen wirklich einen
dieser Exporte vermissen laesst - P-1.4 hat `qcssl.def` als in beiden
Konfigurationen eingehaengt nachgewiesen, die Exporte sollten also da sein.
Sauber waere, `Network::SetSSLMode` `m_bSSLMode` nur dann setzen zu lassen,
wenn alle Zeiger aufgeloest wurden, und sonst eine Meldung zu zeigen. Das ist
mehr als ein Zweizeiler und war in der Zeit nicht drin.

### P-2.4 ERLEDIGT: `TextReader.cpp:251` ist jetzt uebersetzt (schliesst P-1.8)

**Sicherheit: nachgewiesen (uebersetzt und gebunden).**

P-1.8 musste die Aenderung aus P-1.1 unuebersetzt lassen, weil der damalige
Arbeitsbaum an einem OTShim-Fehler haengenblieb. Auf `darstellung-und-menue`
ist das behoben.

    MSBuild Eudora71\Eudora\Eudora.vcxproj /p:Configuration=Debug /p:Platform=Win32
    -> Eudora71\Bin\Debug\Eudora.exe   (Exit 0, 10 224 128 Byte)

`TextReader.cpp` uebersetzt fehlerfrei. Die Zuweisung
`size = ISOTranslate(buf, size, iCharsetIdx);` erzeugt **keine** Warnung -
insbesondere keine `C4244`; `size` ist `LONG` (`TextReader.cpp:77`) und
`ISOTranslate` liefert `LONG` (`utils.h:90`). Die einzigen Warnungen in der
Datei sind die vorbestehenden `C4996` zu `strncpy`, `sprintf`, `strcpy` und
`strcat`. **P-1.8 ist damit geschlossen.**

Zum Weg dorthin, fuer den naechsten, der es nachbaut:

1. `Eudora.vcxproj` mit `/p:BuildProjectReferences=false` uebersetzt alles,
   scheitert aber am Binden mit `LNK1104: imap.lib`.
2. `Eudora71\Eudora.sln` laesst sich **nicht** mit
   `/p:Platform=Win32` bauen: `MSB4126, Projektmappenkonfiguration
   "Debug|Win32" ist ungueltig`.
3. `Eudora.vcxproj` **mit** Projektverweisen baut `Imap.dll`, `QCSSL.dll`,
   `QCSocket.dll` und die uebrigen Bibliotheken, scheitert dann aber an
   `OT501.vcxproj` (`NMAKE U1073: OTA50D\OTA50D.lib`). Das ist eine fremde
   Baustelle.
4. Danach `Eudora.vcxproj` erneut **ohne** Projektverweise - jetzt liegen alle
   `.lib` in `Eudora71\Lib\Debug`, und `Eudora.exe` entsteht.

Der Umweg ueber Schritt 3 ist nur beim ersten Mal in einem frischen Worktree
noetig.

### P-2.5 Nicht angefasst

- `tools/patches/zertifikatspruefung-verschaerfen.patch` bleibt unangewendet
  (Gregors ausdrueckliche Entscheidung, siehe P-1.6).
- Die uebrigen Altlasten aus P-1.5b bis P-1.5j. Sie stehen wortgleich in
  `567a5d8` und sind unveraendert offen. Nach Aufwand-Nutzen als naechstes:
  **P-1.5b** (`%39s` statt `%s`, `POPSession.cpp:1050`) und **P-1.5d**
  (`sizeof(Server)-1` plus Nullterminierung, `POPSession.cpp:1739`, `:3342`,
  `:3344`) - beides Einzeiler.

### P-2.6 Wie zuversichtlich ich bin, dass der erste Abruf gelingt

Ehrlich: **verhalten.** Was ich sagen kann und was nicht:

- **Belegt:** der Absturz aus P-1.5a kann nicht mehr eintreten, und wo Eudora
  vorher verschwand, kommt jetzt eine Meldung mit einem Hinweis auf die DLLs.
- **Belegt:** Umlaute in Text und Betreff kommen richtig an (P-1.1 behoben und
  jetzt auch uebersetzt, P-1.3 mit neun Tests vermessen).
- **Belegt:** die Portierung hat den Abrufpfad nicht beschaedigt (P-1.4).
- **UNGEPRUEFT und der wahrscheinlichste Stolperstein:** ob `mx.freenet.de`
  ueberhaupt POP3 spricht. Ohne Netz nicht zu klaeren. `ABRUF-PRUEFEN.md`
  Abschnitt 1 nennt jetzt das unterscheidende Merkmal - kommt der
  Passwortdialog, stimmt der Server; kommt er nicht, ist es der Name oder der
  Port.
- **UNGEPRUEFT:** ob `rootcerts.p7b` die heutige CA von freenet enthaelt. Wenn
  nicht, kommt der Vertrauensdialog. Das ist kein Scheitern - Abschnitt 5b
  sagt, was der Text bedeutet und dass "OK" ihn dauerhaft wegraeumt.
- **Nichts davon ist an einem laufenden Eudora geprueft.** Der erste echte
  Abruf ist der erste echte Abruf.

Meine Erwartung: **der Abruf scheitert eher an der Serveradresse als an
Eudora.** Und wenn er scheitert, scheitert er jetzt mit einer Meldung statt
mit einem Absturz - das ist der Unterschied, den diese Sitzung gemacht hat.

### P-2.7 Nachtrag: drei Komponententests mehr (105 gruen)

Ausgangsstand waren nicht mehr die 34 aus P-1.7, sondern **102** - andere
Agenten haben in der Zwischenzeit ergaenzt. Dazu drei neue in
`Eudora71/Tests/TestPopEmpfang.cpp`:

| Test | Was er absichert |
|---|---|
| `Test_NachrichtOhneBetreff` | leerer Betreff, Betreff nur aus Zwischenraum, Betreff nur `=`, und ein angefangenes, nie geschlossenes kodiertes Wort - `Fix2047` darf dabei nicht ueber das Zeilenende hinauslesen |
| `Test_SehrLangeKopfzeile` | 60 kodierte Woerter hintereinander, roh 1620 Zeichen, dekodiert 300. Beide Laengen sind im Test gegengeprueft, damit er nicht unbemerkt etwas anderes misst |
| `Test_VollstaendigePopAntwort` | eine ganze RETR-Antwort: sechs Kopfzeilen (zwei kodiert, vier reines ASCII, die sich nicht aendern duerfen) und vier Rumpfzeilen mit Umlaut, scharfem s, Eurozeichen und geschuetztem Leerzeichen. Nachgestellt ist die Aufteilung aus `pop.cpp:656`. Jede Rumpfzeile wird zusaetzlich darauf geprueft, dass sie NACH der Uebersetzung noch auf CRLF endet - genau das ging schief, solange die neue Laenge weggeworfen wurde (P-1.1) |

    Eudora71\Tests\RunTests.cmd
    Ergebnis: 105 Tests, 105 bestanden, 0 fehlgeschlagen

Damit ist von der Wunschliste des Auftrags abgedeckt: UTF-8-Umlaute in einer
POP-Antwort, Betreff in Base64, Betreff in Quoted-Printable (die beiden
letzten standen schon aus P-1.3), Nachricht ohne Betreff, sehr lange
Kopfzeile.

**Eine Falle fuer den naechsten, der hier Tests schreibt:** `"\xC3\x9Fe"` ist
keine Bytefolge, sondern die Fluchtfolge `\x9FE` - C++ frisst das `e` als
weitere Hexziffer. Der Uebersetzer meldet `C2022: "2558" zu gross fuer ein
Zeichen`. Richtig ist `"\xC3\x9F" "e"`. Das gilt fuer jedes `a`-`f` direkt
hinter einer `\x`-Folge, und der Fehler ist genau bei deutschen Umlauten
(`\x9F` + `e` in "Strasse", "Gruesse") wahrscheinlich.

## B-2 — Die Brücke hängt in der Solution, Paket 1.0.3 steht, und ein Prüfer davor

Agent BRUECKE, 31.08.2026. Fortsetzung von [B-1](#b-1). Alle Zahlen hier sind
**gemessen**; wo nicht, steht **UNGEPRÜFT** davor. Werkzeug war
`tools/paket-pruefen.ps1` (in diesem Commit neu) und `MSBuild` aus VS 2022.

### B-2.1 — `VC71Bruecke` ist eingehängt, aber die GUID in B-1 war falsch

`Eudora71/Eudora.sln` enthält das Projekt jetzt. Byte-erhaltend eingefügt mit
`tools/ersetze-bereich.pl`, zwei Stellen, sechs Zeilen; CR-Zahl 0 vorher wie
nachher, Tabulatoren erhalten.

**Berichtigung zu B-1.** Der dortige Abschnitt „Offen“ und
`Eudora71/VC71Bruecke/BEFUND.md` Abschnitt 6 nennen als einzutragende GUID

    {7B1E9C40-3D52-4A6E-9E1F-2C4A7150D71B}

Das ist **nicht** die GUID des Projekts. In `VC71Bruecke.vcxproj:32` steht

    <ProjectGuid>{7B1C4A20-3E5D-4F71-9A16-2C8D5E71B0C4}</ProjectGuid>

Eingetragen ist die echte. Wer die aus BEFUND.md abgeschrieben hätte, bekäme
eine Solution, in der das Projekt zwar auftaucht, aber keiner Konfiguration
zugeordnet ist — es würde stillschweigend nicht gebaut. Die falsche Angabe in
`BEFUND.md` steht dort noch; sie ist mit diesem Abschnitt richtiggestellt.

**Nachgemessen:** Gesamtbau der Solution, `Debug|x86`. `VC71Bruecke` baut mit,
Ausgabe `Eudora71/Bin/Debug/msvcr71.dll`. Die drei bekannten Fehler aus `OT501`
bleiben (`NMAKE U1073` zweimal, `MSB3073` einmal). Zusätzlich zwei
`LNK1104: QCUtils.lib` in `NSImport` und `OLImport` — das ist **kein neuer
Fehler**, sondern ein Wettlauf im Parallelbau (`/m`): beide Projekte binden,
bevor `QCUtils` fertig ist. Einzeln gebaut laufen sie durch, nachgemessen.
Danach bindet auch `Eudora.vcxproj` wieder durch.

### B-2.2 — Wann Eudora die MFC71-abhängigen Module lädt: erst bei Benutzung

Die in B-1.2 offen gelassene Frage ist beantwortet, und zwar **gemessen am
ausgelieferten Paket**, nicht am Quelltext.

`tools/paket-pruefen.ps1` rechnet die **Startkette** aus: beginnend bei den
EXE-Dateien im Wurzelverzeichnis den gewöhnlichen (nicht verzögerten) Importen
folgen, solange das Ziel im Paket liegt. Das ist genau das, was der Lader
anfassen muss, bevor die erste Zeile eigener Code läuft. Ergebnis für das
Paket, **elf Module**:

    Eudora.exe  swEudora.exe  EuLang.dll  EuMemMgr.dll  Imap.dll
    libexpat.dll  msvcr71.dll  Paige32d.dll  plstclnt.dll  QCSocket.dll
    QCUtils.dll

`EudoraBk.dll`, `ISock.dll`, `Ldap.dll`, `Ph.dll` und die drei Plugins sind
**nicht darin**. Das fehlende `MFC71.DLL`/`MSVCP71.dll` hält den Start also
nicht auf. Es gehört in einen Abschnitt „was nicht geht“, nicht nach vorn in
die LIESMICH.txt. Das bestätigt S-1 („beim Laden zwingend sind nur zwei“) und
erweitert es um die transitive Kette.

### B-2.3 — Das echte Paket 1.0.2 nachgesehen: drei Berichtigungen zu B-1

B-1 musste den Paketinhalt aus der Auftragsbeschreibung übernehmen. Jetzt ist
er gemessen (`Releases/Eudora72-1.0.2-lauffaehig.zip`, ausgepackt, jede Datei
durch den PE-Leser).

**1. `MFC71.DLL` und `MSVCP71.dll` liegen tatsächlich nicht bei.** Die
Vermutung aus B-1.2 stimmt. Adressbuch, LDAP, Ph und die drei Plugins waren
also schon in 1.0.2 nicht ladbar. 1.0.3 verschlechtert daran nichts.

**2. Das Paket 1.0.2 ist gemischt, nicht durchgehend Release.** `PAKETE.md`
und die LIESMICH.txt zu 1.0.2 sagen, die sieben vorgebauten DLLs lägen als
Release-Fassungen bei. Für fünf stimmt das. Nicht für zwei:

| Datei im Paket 1.0.2 | Größe | entspricht | importiert |
|---|---|---|---|
| `Paige32d.dll` | 757.760 B | `Bin/Debug/Paige32d.dll` | `MSVCR71D.dll` |
| `Plugins/*.dll` | — | `Bin/Debug/Plugins/*` | `MFC71D.DLL`, `MSVCP71D.dll` |

**Damit ist erklärt, warum die D-Dateien im Paket lagen** — B-1 hatte sie für
totes Gewicht gehalten, weil es nur `Bin/Release` gemessen hatte. Im Paket
wurden sie sehr wohl gebraucht: `msvcr71d.dll` von der Debug-`Paige32d.dll`,
`msvcp71d.dll` von den Debug-Plugins. Der Satz aus B-1, sie seien „totes
Gewicht“, war für das Repository richtig und für das Paket falsch.

Der Weg, sie loszuwerden, bleibt derselbe und ist in B-1 belegt: die
Release-`Paige32.dll` unter dem Namen `Paige32d.dll` kopieren. Danach braucht
sie niemand mehr.

**3. `EUMAPI.DLL` im Paket ist keine PE-Datei.** Der PE-Leser bekommt keinen
gültigen Kopf. 82.944 B, unverändert aus der Freigabe von 2006 übernommen.
**UNGEPRÜFT**, was es stattdessen ist — der Verdacht ist eine 16-Bit-NE-Datei
aus der MAPI-Vergangenheit. Keine Paketdatei importiert sie; sie steht in
keiner Importtabelle. Meldet sich als Warnung, nicht als Fehler.

### B-2.4 — Paket 1.0.3 ist vorbereitet, nicht veröffentlicht

Zusammengestellt mit `tools/paket-bauen.ps1` (neu), das den Vorgang
reproduzierbar macht. Änderungen gegenüber 1.0.2 und ihre Begründung stehen im
Kopf des Skripts und in `Releases/PAKETE.md`. Kurz:

1. selbst gebaute `msvcr71.dll` statt der drei Fremddateien von dll-files.com
2. `Paige32d.dll` als Kopie der Release-`Paige32.dll`
3. `msvcr71d.dll` und `msvcp71d.dll` entfallen
4. Release-Plugins statt Debug-Plugins, ohne 12 MB Symboldateien
5. `laufzeit-holen.ps1` und `paket-pruefen.ps1` liegen im Paket

Vorgeschlagener Dateiname `Eudora72-1.0.3-vorabfassung.zip`. **Nicht
„lauffaehig“** — nach `ZIEL.md` ist derzeit keines der drei Kriterien erfüllt.

Das ZIP selbst ist **nicht** im Repository. Es besteht zu 99 % aus
Bauergebnissen, und ob veröffentlicht wird, entscheidet Gregor. Im Repository
liegen `Releases/1.0.3/LIESMICH.txt`, der Eintrag in `Releases/PAKETE.md` und
das Skript, das es jederzeit wieder herstellt.

### B-2.5 — Was der Paketprüfer findet

`tools/paket-pruefen.ps1` liest von jeder EXE/DLL/OCX den PE-Kopf selbst — kein
`dumpbin` nötig, damit es auch auf einer Maschine ohne Visual Studio läuft. Es
prüft Architektur, löst Import- **und** Verzögerungstabelle auf, sucht die vier
VS2022-Debug-Laufzeiten und eine `Eudora.ini` als Vorlage. **Es startet
nichts.**

| | 1.0.2 | 1.0.3 |
|---|---|---|
| Fehler | 3 | **0** |
| Warnungen | 5 | 7 |
| Binärdateien, alle x86 | 31 | 29 |

Die drei Fehler in 1.0.2 waren `MFC71.DLL`, `MFC71D.DLL`, `MSVCP71.dll`.
`MFC71D.DLL` ist in 1.0.3 verschwunden (Release-Plugins); die beiden anderen
sind Warnungen geworden, seit der Prüfer die Startkette kennt (B-2.2).

**Der eigentliche Zweck ist aber ein anderer Fund.** Beide Pakete bekommen
vier Warnungen der Form

    mfc140d.dll  liegt nicht im Paket. Auf dieser Maschine steht sie in
    SysWOW64, auf einer Maschine ohne Visual Studio 2022 nicht - dort
    scheitert der Start.

Genau daran ist Gregor am Morgen des 31.08.2026 gescheitert: `0xc000007b`. Der
Prüfer hätte das vor der Auslieferung gesagt, und die Architekturprüfung hätte
auch den zweiten Teil gefunden — die ersatzweise geholten Dateien waren
64 Bit.

### B-2.6 — Was ich NICHT getan habe

- Kein Eudora gestartet, kein Programm mit Fenstern, kein
  `OutputDebugString`-Mithörer. `paket-pruefen.ps1` und `paket-bauen.ps1`
  lesen und kopieren Dateien, mehr nicht.
- Nichts veröffentlicht. Kein ZIP im Repository, keine Prüfsumme in
  `PAKETE.md` — beides entsteht erst, wenn Gregor es will.
- `Eudora71/VC71Bruecke/BEFUND.md` nicht angefasst (falsche GUID in
  Abschnitt 6, siehe B-2.1) — es ist der Bericht meines Vorlaufs; die
  Richtigstellung steht hier.

## W-1 — Die Werkzeuge in Ordnung gebracht (WERKZEUG, 31.08.2026)

Abgearbeitet werden die Befunde PR-1 bis PR-8 aus `PRUEFBERICHT.md`. Jede
Aussage unten ist gemessen; die Gegenproben laufen als Testsammlung mit.

| Befund | Gegenstand | Stand |
|---|---|---|
| PR-1 | Schranke laesst LF → CRLF durch | **behoben** |
| PR-2 | Schranke schlaegt bei Leerzeilen grundlos an | **behoben** |
| PR-3 | `.def`/`.sln`/`.bat`/`.ps1` gar nicht geprueft | **behoben** |
| PR-4 | `BuildKennung.h` verfolgt → fremde Kennung | **behoben** |
| PR-5 | Zeitstempel ist nicht der Bauzeitpunkt | offen (nur Beschreibung) |
| PR-6 | `_T(EUDORA_BAU_KENNUNG)` bricht im Unicode-Bau | **behoben** |
| PR-7 | Zahlen in S-7 widersprechen sich | **behoben** |
| PR-8 | `rekursion-suchen.pl` findet den eigenen Anlass nicht | **geloescht** |

### Das Wichtigste: `tools/pruefe-bytes-tests.pl`

Die Schranke war am 30.08.2026 schon einmal "repariert" worden und danach
falsch. Beides — der Fehlalarm und das Loch — waere bei einem einzigen
Testlauf aufgefallen. Es gab nur keinen.

Jetzt gibt es einen. 23 Faelle, jeder in einem eigenen Wegwerf-Repo unter dem
Temp-Verzeichnis, mit `.gitattributes` `* -text` wie im echten Repo. Geprueft
wird ausschliesslich der Rueckgabewert der Schranke: 0 durchgelassen,
1 abgebrochen. Die Faelle sind byteweise beschrieben, es kommt kein Escape im
Testtext vor.

    perl tools/pruefe-bytes-tests.pl        # Tabelle, Rueckgabe 1 bei rot
    perl tools/pruefe-bytes-tests.pl -v     # zusaetzlich die Meldung je Fall

**Gegen den Stand vom 30.08.2026: 16 gruen, 7 rot.** Die Sammlung reproduziert
damit PR-1, PR-2 und PR-3 aus eigener Kraft:

| rot | Fall | was die alte Schranke tat |
|---|---|---|
| d | Leerzeile CRLF weg, Leerzeile LF dazu | brach den Commit ab, Beispiel `""` |
| h1 | Umwandlung LF → CRLF plus Inhalt | liess durch, Rueckgabe 0 |
| j1 | `.def` komplett CRLF → LF | liess durch |
| j2 | `.sln` komplett CRLF → LF | liess durch |
| j3 | `.bat` komplett CRLF → LF | liess durch |
| j4 | `.ps1` komplett LF → CRLF | liess durch |
| j5 | `.pl` komplett CRLF → LF | liess durch |

**Gegen den heutigen Stand: 23 gruen, 0 rot.** Alle 23 Faelle im Einzelnen:

| Fall | Beschreibung | erwartet |
|---|---|---|
| a | Zeilen hinzugefuegt (CRLF-Datei) | durchlassen |
| b | Zeilen hinzugefuegt (LF-Datei) | durchlassen |
| c1 | Zeilen geloescht (CRLF-Datei) | durchlassen |
| c2 | Zeilen geloescht (gemischte Datei, 655 Zeilen) | durchlassen |
| d | Leerzeile CRLF weg, Leerzeile LF dazu | durchlassen |
| d2 | haeufige Zeilen (`{`, `}`, leer) verschoben | durchlassen |
| e | Datei komplett CRLF → LF | anschlagen |
| f | Datei komplett LF → CRLF | anschlagen |
| g | gemischte Datei, 18 CRLF → LF unter 655 Zeilen | anschlagen |
| h1 | Umwandlung LF → CRLF plus Inhaltsaenderung | anschlagen |
| h2 | Umwandlung CRLF → LF plus Inhaltsaenderung | anschlagen |
| h3 | Umwandlung plus hinzugefuegte Zeilen (ungleiche Anzahl) | anschlagen |
| i | nur Inhalt geaendert, Zeilenenden gleich | durchlassen |
| j1..j5 | `.def` `.sln` `.bat` `.ps1` `.pl` komplett umgeschrieben | anschlagen |
| k | neue Datei, nicht in HEAD | durchlassen |
| l | Sonderzeichen zerstoert (U+FFFD dazu) | anschlagen |
| m | Datei unveraendert vorgemerkt | durchlassen |
| n | letzte Zeile ohne Zeilenumbruch, Inhalt ergaenzt | durchlassen |
| o | unbekannte Endung `.xyz` komplett umgeschrieben | durchlassen |

Fall `o` ist die **dokumentierte Grenze**: was nicht in
`tools/dateiendungen.pl` steht, wird nicht geprueft. Der Fall steht bewusst
drin, damit die Grenze sichtbar bleibt statt vergessen zu werden.

### PR-1 und PR-2: die Regel taugte nicht, nicht ihre Richtung

Die Fassung vom 30.08. zaehlte je **Zeileninhalt**, wie oft er mit CRLF und wie
oft mit LF vorkommt, und meldete jeden Inhalt, der seine CRLF-Vorkommen
verloren hatte. Daraus folgen beide Befunde zwangslaeufig:

  * Die Abfrage war einseitig formuliert (`[0] > 0` in HEAD, `[0] == 0` im
    Index), also fiel LF → CRLF heraus. Das ist unter Windows die
    **wahrscheinlichere** Schadensrichtung — Editoren, `Set-Content`,
    `Out-File` schreiben CRLF.
  * Der Zeileninhalt taugt nicht als Schluessel. `""`, `{`, `}` und ein
    blosser Tabulator kommen in einer Datei hundertfach vor, mit beiden Enden.
    Welches Vorkommen welches war, geht beim Zaehlen verloren. Eine geloeschte
    CRLF-Leerzeile plus eine ergaenzte LF-Leerzeile war deshalb von einer
    Umwandlung nicht zu unterscheiden.

Die naheliegende Behebung — Leerzeilen ueberspringen, Zeilen mit beiden Enden
ueberspringen — waere Symptombehandlung gewesen: sie haette den Fehlalarm bei
`""` beseitigt und ihn bei `\tif (nRet)` oder jeder anderen mehrfach
vorkommenden Zeile stehen gelassen.

**Was der Waechter eigentlich unterscheiden soll**, ist eine UMWANDLUNG
bestehender Zeilen von einer Ergaenzung oder Loeschung. Genau diese
Unterscheidung trifft git selbst schon. Regel 2 wertet deshalb jetzt den
eigentlichen Unterschied aus:

    git diff --cached -U0 --no-color --no-ext-diff -- <datei>

Eine umgewandelte Zeile erscheint darin als Paar aus einer entfernten und einer
hinzugefuegten Zeile **im selben Block**, deren Inhalt gleich und deren
Zeilenende verschieden ist. Eine reine Ergaenzung erzeugt einen Block ohne
entfernte Zeilen, eine reine Loeschung einen ohne hinzugefuegte — dort entsteht
gar kein Paar. Damit ist die Zuordnung **ortsgebunden statt inhaltsgebunden**,
und der Leerzeilen-Fehlalarm kann strukturell nicht mehr auftreten: die
geloeschte und die ergaenzte Leerzeile stehen an verschiedenen Stellen und
landen in verschiedenen Bloecken (Fall `d`, gemessen).

Innerhalb eines Blocks werden entfernte und hinzugefuegte Zeilen der Reihe nach
gepaart. Bei gleicher Anzahl — dem Normalfall einer Umwandlung — passt das
genau. Bei ungleicher Anzahl (Umwandlung UND ergaenzte Zeilen, Fall `h3`) fuehrt
eine Vorausschau von 30 Zeilen die Paare nach.

**Warum nicht die andere vorgeschlagene Loesung** (haeufige Zeilen aus dem
Vergleich ausnehmen): sie verschiebt die Grenze nur. Jede Schwelle "ab wie oft
ist eine Zeile haeufig" waere geraten, und ausgerechnet in den langen,
gleichfoermigen Ressourcendateien dieses Projekts sind die meisten Zeilen
haeufig — dort wuerde der Waechter dann blind. Der Diff kennt die Antwort
ohnehin schon.

Regel 1 (Inhalt gleich, Bytes verschieden) bleibt unveraendert daneben stehen.
Sie arbeitet auf den rohen Blobs und ist damit unabhaengig davon, wie git den
Unterschied darstellt — eine zweite, einfachere Sicherung fuer den haeufigsten
Fall.

### PR-3: eine Liste statt zwei

`tools/pruefe-bytes.pl` und `tools/zeilenenden-angleichen.pl` hatten je eine
eigene Endungsliste. Sie waren auseinandergelaufen. Beide laden jetzt
`tools/dateiendungen.pl`. Neu darin unter anderem `def sln vcproj props targets
dsp dsw bat cmd ps1 psm1 pl pm py sh rc2 pod ini cnf manifest config xml json
yml yaml asm inc s` sowie die Namen `.gitattributes`, `.gitignore`,
`.editorconfig`, `Makefile`.

Laesst sich die Liste nicht laden, **bricht die Schranke ab**. Eine Schranke,
die stillschweigend nichts mehr prueft, ist schlimmer als gar keine.

Gemessen, was die groessere Liste am Bestand aendert:

    perl tools/zeilenenden-angleichen.pl
      byteidentisch zu HEAD:         6385
      nur Zeilenenden verschieden:      0

Die erweiterte Liste deckt also **keinen neuen Schaden** auf; sie schliesst
eine Luecke fuer die Zukunft. Mit der alten Liste waren es 5589 Dateien.

### PR-4: `BuildKennung.h` ist nicht mehr verfolgt

`git rm --cached Eudora71/Eudora/BuildKennung.h`, Eintrag in `.gitignore`, und
`Eudora71/Eudora/BuildKennung-vorlage.h` mit `_T("unbekannt")` eingecheckt. Der
PreBuildEvent kopiert die Vorlage, wenn perl nicht laeuft:

    perl %KENNUNG% %WURZEL% && exit /b 0
    "C:\Program Files\Git\usr\bin\perl.exe" %KENNUNG% %WURZEL% && exit /b 0
    echo WARNUNG: perl nicht gefunden - die Kennung sagt "unbekannt"
    fc /b "...BuildKennung.h" "...BuildKennung-vorlage.h" >nul 2>&1 || copy /y ...
    exit /b 0

Das `fc /b` davor verhindert, dass ein Bau ohne perl die Datei jedes Mal neu
anfasst und eine vollstaendige Neuuebersetzung nach sich zieht. Ein frischer
Klon ohne perl uebersetzt, und das Fenster sagt dann ehrlich `unbekannt` statt
der Kennung eines fremden Baus.

### PR-6: kein `_T` um ein Makro

`tools/kennung-erzeugen.pl` erzeugt die Zeichenkette jetzt gleich richtig:

    #include <tchar.h>
    #define EUDORA_BAU_KENNUNG _T("1.0.3+... 2026-08-31 07:11")

und `mainfrm.cpp:9715` benutzt sie ohne `_T(...)` (byte-erhaltend geaendert mit
`tools/aendere-zeile.pl`, CR-Zahl 18 unveraendert). Damit stimmt es im
MBCS-Bau wie im Unicode-Bau: `__T(x)` ist dort `L##x`, und `##` haette die
Erweiterung des Makros unterbunden — aus `_T(EUDORA_BAU_KENNUNG)` waere der
Bezeichner `LEUDORA_BAU_KENNUNG` geworden.

**Uebersetzt** (31.08.2026, Debug|Win32, eigener Worktree):

    MSBuild.exe Eudora71\Eudora\Eudora.vcxproj /p:Configuration=Debug
                /p:Platform=Win32 /p:BuildProjectReferences=false /m /v:minimal

Alle Quelldateien uebersetzen fehlerfrei, `mainfrm.cpp` eingeschlossen — die
neue `BuildKennung.h` mit `_T("...")` und `#include <tchar.h>` traegt also. Der
Lauf endet in `LNK1104: imap.lib kann nicht geoeffnet werden`: der Worktree ist
frisch und `/p:BuildProjectReferences=false` baut die abhaengigen Projekte
nicht mit. Das hat mit diesen Aenderungen nichts zu tun. **Nicht gemessen**
wurde damit ein vollstaendiger Binaerbau — nur die Uebersetzung.

Der Rueckfallzweig des PreBuildEvent ist getrennt geprueft: Datei fehlt →
Vorlage wird kopiert; Datei schon gleich der Vorlage → Zeitstempel bleibt
unveraendert, es entsteht also keine Neuuebersetzung.

### PR-7: es gilt 4616 von 5563

Nachgemessen und in `BEFUNDE.md` (S-7), `README.md`, `WEITERMACHEN.md` und im
Kopf von `tools/zeilenenden-angleichen.pl` gleichgezogen. Die 4426 von 5336 im
Werkzeugkopf stammten aus einem Durchlauf mit kuerzerer Endungsliste und sind
ersatzlos weg.

Die **4616** ist eine einmalige Messung des damaligen Arbeitsbaums und laesst
sich nicht wiederholen — der Baum ist angeglichen. Die Grundgesamtheit dagegen
ist keine feste Zahl: sie waechst mit jedem Commit und haengt an der
Endungsliste (5563 / 5568 / 5589 alte Liste, 6385 neue). Statt einer Zahl steht
in S-7 jetzt eine Tabelle mit Datum und Liste, dazu der Befehl zum Nachzaehlen.

Nebenbei berichtigt: das Beispiel in S-7 war vertauscht beschriftet. Heute
nachgemessen — Blob `8c4fb68a` hat 5716 Bytes, 0 CR, 65 LF; der Index trug
daneben 5781, die Groesse der CRLF-Arbeitskopie. 5716 + 65 CR = 5781.

### PR-8: `rekursion-suchen.pl` geloescht

Das Urteil des Pruefers nachgeprueft und bestaetigt. Gegenprobe: eine Datei mit
einem klassenuebergreifenden Zyklus nach dem Muster von S-2 und zusaetzlich
einem Selbstaufruf innerhalb einer Klasse.

    void CAdView::Zeichne()  { m_pRahmen->Anpassen(); }
    void CRahmen::Anpassen() { m_pAnsicht->Zeichne(); }
    void CAdView::Messen()   { Messen(); }

    perl tools/rekursion-suchen.pl <verzeichnis>
    ZYKLUS (1 Glied): CAdView::Messen/0 -> CAdView::Messen/0
    1 Zyklus/Zyklen.

Es meldet nur den Selbstaufruf. Zwei Ursachen im Code, beide strukturell:
`my $zsig = "$klasse\::$ziel/"` bildet jede Kante mit der **umgebenden** Klasse,
und der Aufrufmuster-Ausdruck ueberspringt jeden Aufruf mit `.`, `->` oder `::`
davor. Eine Kante zwischen zwei Klassen kann also gar nicht entstehen.

**Warum ein Werkzeug, das nur Fehlalarme liefert, schlimmer ist als keines.**
Ein fehlendes Werkzeug kostet die Zeit, die man ohne es braucht. Ein Werkzeug,
das nur Fehlalarme liefert, kostet dieselbe Zeit **plus** die Zeit, jeden
Fehlalarm von Hand zu widerlegen — und es kostet Vertrauen: nach dem dritten
Fehlalarm liest niemand mehr seine Ausgabe, auch nicht die eine richtige
Meldung darin. Dazu kommt der teuerste Posten: wer eine Zyklensuche laufen
laesst und "0 Zyklen" liest, glaubt, geprueft zu haben. Hier war das falsch —
den Zyklus aus S-2 hat `stapel-untersuchen.ps1` gefunden, nicht dieses
Werkzeug. Eine Zusicherung, die nicht traegt, ist schaedlicher als gar keine.
Dieselbe Ueberlegung gilt fuer die Schranke oben; deshalb die Testsammlung.

### PR-5 bleibt offen

Der Zeitstempel in der Kennung ist der Zeitpunkt, zu dem sich Commit oder
Sauberkeit zuletzt geaendert haben, nicht der Bauzeitpunkt. Das **Verhalten**
ist richtig gewaehlt (sonst uebersetzt jeder Bau alles neu); nur die
Beschreibung stimmt nicht. Ein Wort im Kommentar — nicht angefasst, weil die
Frist naeher war als der Nutzen.

### Nebenbefund: `sed` verschweigt CR

Beim Umbau des PreBuildEvent hat `sed -n '114,124p' | cat -A` die Zeilen ohne
`^M` angezeigt, obwohl sie CRLF haben — das cygwin-`sed` in dieser Umgebung
liest im Textmodus und wirft CR weg. Wer Zeilenenden ansehen will, darf `sed`
dafuer **nicht** benutzen; verlaesslich ist nur ein direkter Rohvergleich:

    perl -e 'open(F,"<:raw",$ARGV[0]);local $/;$d=<F>;
             $cr=()=$d=~/\r/g;$lf=()=$d=~/\n/g;print "CR=$cr LF=$lf\n"' <datei>

Gemerkt hat es `tools/ersetze-bereich.pl`, das die CR-Zahl vorher und nachher
ausgibt: 1064 → 1062, obwohl der Block angeblich CR-frei war. Ohne diese
Ausgabe waere der Schaden in den Commit gelaufen und die Schranke haette ihn
erst dort gemeldet.


## F-1 — Der Release-Bau und die Frage nach dem statischen Binden (FREIGABE, 31.08.2026)

Auftrag war Kriterium 0 aus `ZIEL.md`: „zip runterladen, entpacken, starten -
laeuft". Der Weg dorthin sollte moeglichst das statische Binden sein.

**Kurzfassung: statisch geht nicht, und der Grund ist keine Einstellung,
sondern die Bauart des Programms.** Was geht, ist der dynamische Release-Bau,
und der erfuellt Kriterium 0 ebenfalls — mit drei DLLs, die Microsoft
ausdruecklich zum Weiterverteilen freigibt.

Alle Zahlen unten sind gemessen; wo nicht, steht **UNGEPRUEFT** davor.

### F-1.1 — Statisches MFC ist ausgeschlossen: sechs MFC-Erweiterungs-DLLs

Eudora ist nicht ein Programm, sondern ein Programm mit sechs
**MFC-Erweiterungs-DLLs**. Der Nachweis steht im Quelltext — jede von ihnen
ruft `AfxInitExtensionModule` auf:

| Modul | Fundstelle |
|---|---|
| `EudoraIcons` | `Eudora71/Eudora/EudoraIcons.cpp:18` |
| `EudoraRes` | `Eudora71/Eudora/EudoraRes.cpp:18` |
| `EudoraOldIcons` | `Eudora71/EudoraOldIcons/EudoraOldIcons.cpp:38` |
| `Imap` | `Eudora71/Imapdll/src/imap.cpp:25` |
| `QCSocket` | `Eudora71/QCSocket/src/QCSocket.cpp:24` |
| `QCUtils` | `Eudora71/QCUtils/src/QCUtils.cpp:23` |

Dieselben Projekte setzen `_AFXEXT` in ihren Praeprozessordefinitionen
(`Eudora/EudoraRes.vcxproj:64`, `EudoraOldIcons/EudoraOldIcons.vcxproj:64`,
`Imapdll/imap.vcxproj:103`, `QCSocket/QCSocket.vcxproj:104`,
`QCUtils/QCUtils.vcxproj:62`, jeweils der Release-Zweig).

`AfxInitExtensionModule`, `CDynLinkLibrary` und `AFX_EXTENSION_MODULE` gibt es
in MFC **nur**, wenn `_AFXDLL` gesetzt ist — also nur beim gemeinsam genutzten
MFC. Eine Erweiterungs-DLL ist ihrem Wesen nach ein Modul, das sich in die
MFC-Modulliste des Hauptprogramms einhaengt; dazu muss es dieselbe
MFC-Instanz benutzen. Mit `<UseOfMfc>Static</UseOfMfc>` haette jede dieser
sechs DLLs ihre eigene MFC-Kopie, ihren eigenen Heap und ihre eigene
Ressourcenkette.

**Statisches MFC waere also nicht eine Umstellung von zwei Einstellungen,
sondern der Umbau von sechs DLLs zu statischen Bibliotheken** — mit allem, was
daran haengt: `EudoraRes.dll` und `EudoraOldIcons.dll` sind reine
Ressourcen-DLLs, die zur Laufzeit ueber `CDynLinkLibrary` gesucht werden;
`Imap.dll`, `QCSocket.dll` und `QCUtils.dll` werden ausserdem von
`EudoraBk.dll`, `ISock.dll`, `Ldap.dll`, `Ph.dll` und den Importern benutzt.
Das ist kein Handgriff, das ist ein eigenes Vorhaben.

### F-1.2 — Auch nur `/MT` allein geht nicht

Statische C-Laufzeit (`/MT`) bei weiterhin dynamischem MFC ist nicht
vorgesehen: `mfc140.dll` ist selbst gegen `/MD` gebaut und gibt CRT-Objekte
(`FILE*`, Speicherbloecke) ueber die Modulgrenze weiter. Ein Programm mit
`_AFXDLL` und `/MT` bekaeme zwei getrennte CRT-Heaps.

Zusaetzlich gemessen, `dumpbin /directives` gegen `Eudora71/Lib/Release`:

| Bibliothek | CRT-Direktive |
|---|---|
| `zlib.lib` | `-defaultlib:MSVCRT` — gegen die **dynamische** Laufzeit gebaut |
| `libpng.lib` | `-defaultlib:MSVCRT` — dito |
| `Paige32.lib` | keine (Importbibliothek, neutral) |
| `EuMemMgr.lib` | keine (Importbibliothek, neutral) |
| `Uuid.Lib` | keine (neutral) |
| `SSCEWD32.LIB` | keine (Importbibliothek, neutral) |

`zlib.lib` und `libpng.lib` waeren bei `/MT` also die naechste Huerde
(`LNK4098`, dann `LNK2005`) — sie liegen nur als Binaerdatei vor, ein Neubau
mit `/MT` ist ohne ihren Quelltext nicht moeglich.

### F-1.3 — Was stattdessen liefert: der dynamische Release-Bau

Er erfuellt Kriterium 0 genauso, nur mit drei Dateien mehr im ZIP:

| | Debug (Paket 1.0.2/1.0.3) | Release, dynamisch |
|---|---|---|
| noetige Laufzeit-DLLs | `mfc140d.dll`, `msvcp140d.dll`, `vcruntime140d.dll`, `ucrtbased.dll` | `mfc140.dll`, `msvcp140.dll`, `vcruntime140.dll` |
| weiterverteilbar? | **nein** — `debug_nonredist`, kein Redistributable | **ja** — Teil des Visual-C++-Redistributable, duerfen beiliegen |
| `ucrtbase.dll` | Debug-Fassung noetig | liegt Windows 10 bei, nichts zu tun |
| SUPERASSERT beim Start (S-3b) | ja | **nein** — `NDEBUG`, keine Debug-Zusicherungen |

Der zweite Gewinn ist der, den der Auftrag nebenbei nennt: im Release-Bau
verschwinden die SUPERASSERT-Dialoge aus S-3b und saemtliche `ASSERT`- und
`VERIFY`-Pruefungen. Das Programm startet ohne Zwischenfrage durch.

### F-1.4 — Warum der Release-Zweig nie gebunden hat: ein Buchstabe

Der eigentliche Fund. `Eudora71/Eudora/Eudora.vcxproj:147`, Release-Zweig:

    <IgnoreSpecificDefaultLibraries>libc.lib;libcmt.lib;OTA50D.LIB;...

`OTA50D.LIB` ist der **Debug**-Name. Der Debug-Zweig (`:97`) schliesst
dieselbe Datei aus und ist damit richtig; der Release-Zweig braucht
`OTA50R.LIB` (`OT501/Src/OT501.vcxproj:50`) und schliesst sie nicht aus.
Ergebnis seit jeher:

    LINK : fatal error LNK1104: Datei "ota50r.lib" kann nicht geoeffnet werden.

`OTA50R.LIB` laesst sich nicht bauen — `NMAKE /f build50.mak ota50r` bricht mit
`U1073` ab, weil `OT501/Src/utility/crypt/Blackbox.cpp` in der Freigabe von
2006 fehlt. Gebraucht wird sie auch nicht: die vier Funktionen daraus liefert
`Eudora71/OTShim/OTShim_Spur.cpp` seit B-1, und die stehen ohnehin unter
`_DEBUG`.

**Woher die Anforderung kommt, war der Umweg.** Sie steht **nicht** in
`AdditionalDependencies` und **nicht** auf der Linker-Befehlszeile — im
Diagnoseprotokoll von MSBuild taucht `ota50r.lib` an keiner Stelle auf. Sie
kommt als Standardbibliotheks-Direktive aus den Objektdateien von
`AccountWizard` und `DirectoryServicesUI` (gemessen: Volltextsuche ueber alle
`.obj` unter `Eudora71`, 29 Treffer, alle in diesen beiden Projekten). Deshalb
hilft nur `IgnoreSpecificDefaultLibraries`, und deshalb hat das Suchen in
`AdditionalDependencies` nichts ergeben.

**Behoben:** `OTA50R.LIB` in `Eudora.vcxproj:147` ergaenzt. Eine Zeile.

### F-1.5 — Der zweite Stolperstein: MakeDox.pl im Nachbereitungsschritt

Danach band `Eudora.exe` durch — und der Bau endete trotzdem mit Fehler:

    error MSB3073: Der Befehl "... MakeDox.pl Eudora.sln DevDox ..."
    wurde mit dem Code 9009 beendet.

`Eudora.vcxproj:161-166` liess im Release-Zweig nach dem Binden
`MakeDox.pl Eudora.sln DevDox` laufen — die Doxygen-Entwicklerdoku von 2006.
Das Werkzeug ist nicht auf dem Pfad, 9009 heisst „Befehl nicht gefunden". Der
**Debug**-Zweig hat gar keinen Nachbereitungsschritt.

Die zwei Doku-Zeilen entfernt. `call ..\BinTools\PostProcessRel Eudora` bleibt
stehen; das ruft `UpdateExternalEMSAPIHeader.pl` und `BindExe ..\Bin\Release`
auf und laeuft durch.

**Nebenwirkung, die man wissen muss:** `BindExe` schreibt die Bindungsdaten in
**jede** DLL in `Eudora71/Bin/Release` zurueck, auch in die zwoelf vorgebauten
Fremd-DLLs von 2006, die im Repository liegen. Nach einem Release-Bau meldet
`git status` sie deshalb als geaendert. Sie gehoeren **nicht** in einen Commit.

### F-1.6 — Gemessen: was uebrig bleibt

`Eudora71/Bin/Release/Eudora.exe`, 2.933.760 B. `dumpbin /dependents`:

| Art | Eintraege |
|---|---|
| eigene Module | `Paige32.dll`, `Imap.dll`, `QCUtils.dll`, `EuMemMgr.dll`, `EuLang.dll`, `LIBEXPAT.dll`, `plstclnt.dll`, `QCSocket.dll` |
| **Laufzeit von Visual C++** | **`mfc140.dll`, `MSVCP140.dll`, `VCRUNTIME140.dll`** — alle drei verteilbar |
| UCRT | zwoelf `api-ms-win-crt-*` — Bestandteil von Windows 10, nichts beizulegen |
| Windows | `KERNEL32`, `USER32`, `GDI32`, `COMDLG32`, `ADVAPI32`, `SHELL32`, `COMCTL32`, `ole32`, `OLEAUT32`, `urlmon`, `VERSION`, `WININET`, `MSVFW32`, `WINMM`, `gdiplus` |

Kein `ucrtbased.dll`, kein `d`-Anhang. Genau die drei Dateien, an denen Gregor
am Morgen gescheitert ist, sind weg — und ihre drei Nachfolger duerfen ins ZIP.

### F-1.7 — `tools/paket-bauen.ps1` kann jetzt Release

Neuer Schalter `-Bauart Debug|Release` (Vorgabe `Debug`, also keine Aenderung
fuer bestehende Aufrufe). Bei `Release`:

- `-AusBauverzeichnis` nimmt aus `Eudora71\Bin\Release` statt `Bin\Debug`
- `Paige32.dll` kommt **unter beiden Namen** ins Paket. Der Debug-Bau
  importiert `Paige32d.dll` (`Eudora.vcxproj:94`), der Release-Bau
  `Paige32.dll` (`:144`) — das war der eine Fehler, den der Paketpruefer im
  ersten Anlauf gemeldet hat.
- die drei verteilbaren Laufzeit-DLLs kommen aus dem VC-Redistributable der
  oertlichen Visual-Studio-Installation ins Paket, ueber `vswhere`
- `laufzeit-holen.ps1` faellt weg — es wird nichts mehr nachgeholt

### F-1.8 — Was der Paketpruefer sagt

    powershell -File tools\paket-bauen.ps1 -Ziel <verz> -Bauart Release -AusBauverzeichnis
    powershell -File tools\paket-pruefen.ps1 -Paket <verz>

    32 Binaerdateien geprueft, alle x86.
    ERGEBNIS: keine Fehler.
    7 Warnung(en)

**Null Fehler.** Damit ist Kriterium 0 gemessen erfuellt, so weit ein Pruefer
ohne Start es belegen kann.

Von den sieben Warnungen sind **vier falsch**: der Pruefer sucht in Abschnitt 3
fest nach `mfc140d.dll`, `msvcp140d.dll`, `vcruntime140d.dll` und
`ucrtbased.dll` und warnt, wenn sie fehlen — auch dann, wenn keine einzige
Datei im Paket sie importiert. Fuer ein Release-Paket ist das Unsinn.
Nachgemessen: keine der 32 Binaerdateien importiert eine der vier. Die drei
uebrigen Warnungen (`EUMAPI.DLL`, `MFC71.DLL`, `MSVCP71.dll`) sind
unveraendert die aus B-2.5 und betreffen den Start nicht.

## Stand und naechster Schritt (FREIGABE, 31.08.2026)

**Erledigt.**

| | |
|---|---|
| Release-Bau | **baut**, `MSBuild ... /p:Configuration=Release /p:Platform=Win32 /p:BuildProjectReferences=false` endet mit Exit 0 |
| statisch gebunden | **nein, und zwar nicht in der verbleibenden Zeit nachholbar** — F-1.1, sechs MFC-Erweiterungs-DLLs |
| uebrige Laufzeit-DLLs | `mfc140.dll`, `msvcp140.dll`, `vcruntime140.dll` — alle drei verteilbar, alle drei jetzt im Paket |
| Paketpruefer | **null Fehler** |
| SUPERASSERT beim Start (S-3b) | im Release-Bau weg, ebenso alle `ASSERT`/`VERIFY` |

**Das Bauverfahren, das funktioniert** — die Reihenfolge ist noetig, weil ein
Bau ohne Projektverweise die `.lib`-Dateien nicht hat und ein Bau mit ihnen an
`OT501` scheitert:

    1. MSBuild Eudora71\Eudora.sln /p:Configuration=Release /p:Platform=x86 /m
       (endet mit Fehler: OT501 U1073/MSB3073 - erwartet; erzeugt aber die
        zehn .lib-Dateien in Eudora71\Lib\Release)
    2. MSBuild auf NSImport, OEImport, OLImport, dann Eudora.vcxproj,
       je /p:Configuration=Release /p:Platform=Win32
                 /p:BuildProjectReferences=false

`/p:Platform=Win32` gilt fuer **Projektdateien**, `/p:Platform=x86` fuer die
**Projektmappe** — sonst MSB4126 (Befund P-2).

**Naechster Schritt, konkret.**

1. **`tools/paket-pruefen.ps1`, Abschnitt 3** (die Liste der vier
   VS2022-Debug-Laufzeiten): nur noch warnen, wenn eine Paketdatei die
   betreffende DLL wirklich importiert. Der Pruefer loest die Importtabellen
   ohnehin schon auf (B-2.5), die Angabe steht also bereits zur Verfuegung.
   Solange das nicht geschieht, meldet ein fehlerfreies Release-Paket vier
   Warnungen, die keine sind — und wer sie ernst nimmt, holt sich mit
   `laufzeit-holen.ps1` genau die vier nicht verteilbaren DLLs zurueck.
2. **`Eudora71/Eudora/Eudora.vcxproj:144`**: der Release-Zweig fuehrt
   `QCSocket.lib` **nicht** in `AdditionalDependencies`, der Debug-Zweig
   (`:94`) sehr wohl. Gebunden hat es trotzdem — offenbar ueber eine
   Standardbibliotheks-Direktive. **UNGEPRUEFT**, ob das Zufall ist; nachsehen
   und im Zweifel angleichen.
3. **`Releases/1.0.3/LIESMICH.txt`** beschreibt noch den Debug-Weg („ZUERST:
   DIE VIER LAUFZEITEN HOLEN"). Fuer ein Release-Paket ist dieser ganze
   Abschnitt hinfaellig und irrefuehrend. Neu fassen, bevor ausgeliefert wird.
4. **Nach jedem Release-Bau**: `git status` zeigt zwoelf geaenderte DLLs unter
   `Eudora71/Bin/Release`. Das ist `BindExe` aus dem Nachbereitungsschritt
   (F-1.5), kein Bauergebnis. Nicht stagen.

**Nicht getan:** kein Eudora gestartet, kein Programm mit Fenstern, kein
`OutputDebugString`-Mithoerer. Nichts veroeffentlicht — kein ZIP im
Repository. Ob und wie das Release-Paket ausgeliefert wird, entscheidet Gregor.
Der Bau der Kriterien 1 bis 3 ist von dieser Arbeit unberuehrt: das Fenster ist
weiterhin nicht bedienbar (S-5, S-6, M-1).

## PR-2 — Nachpruefung der Arbeit vom 31.08.2026 (PRUEFER, 31.08.2026)

Grundlage: `darstellung-und-menue` bei 2cf569f. Kein Programm mit Oberflaeche
gestartet, gebaut ausschliesslich in der PowerShell. FREIGABEs Release-Bau lag
nicht vor.

---

### PR-2.0 — Der Paketpruefer leitet zum Lizenzverstoss an (hoch, OFFEN)

Von FREIGABE gemeldet, hier bestaetigt und eingeordnet — der wichtigste
Einzelpunkt an `tools/paket-pruefen.ps1`.

**Fundstelle:** `tools/paket-pruefen.ps1:360` (feste Liste), `:363-364`,
`:371`.

Der Pruefer sucht fest nach den vier VS2022-**Debug**-Laufzeiten
(`mfc140d.dll`, `msvcp140d.dll`, `vcruntime140d.dll`, `ucrtbased.dll`) und
meldet ihr Fehlen. In einem Release-Paket importiert **keine** Datei sie. Der
Pruefer gibt dort also vier falsche Warnungen.

**Warum das gefaehrlich ist:** wer die Warnung ernst nimmt, ruft
`tools/laufzeit-holen.ps1` und holt sich genau die nicht verteilbaren
Debug-DLLs ins Paket. Das Werkzeug leitet damit zu dem an, was es verhindern
soll. `README.md:73-74` sagt ausdruecklich, diese vier duerfen nicht
mitgeliefert werden — und `:363-364` bewertet ihr Vorhandensein trotzdem
gruen (siehe auch PR-2.3, letzter Punkt: derselbe Widerspruch von der anderen
Seite).

**Richtig waere:** die noetigen Laufzeiten aus den IMPORTEN der Paketdateien
ableiten statt aus einer festen Liste. Die Lesefunktion dafuer hat das Skript
schon (`:138`, `:158`) und benutzt sie an anderer Stelle korrekt — bei einem
Debug-Paket kaemen dann die `d`-Fassungen heraus, bei einem Release-Paket
`mfc140.dll` / `MSVCP140.dll` / `VCRUNTIME140.dll`, und im Release-Fall gar
keine Warnung, weil die drei schon beiliegen.

**Nicht behoben.** Nicht aus Zeitnot allein: `paket-pruefen.ps1` ist das
Werkzeug, an dem die Freigabe von 1.0.3 haengt, und eine Aenderung daran ohne
Gegenprobe an einem echten Release-Paket waere schlechter als der jetzige
Zustand. Der Umbau gehoert mit PR-2.2 und PR-2.3 zusammen: alle drei sagen,
dass der Pruefer aus dem Paket ableiten muss statt aus fester Liste und
Pruefmaschine.

---

### PR-2.1 — Der Absturz kommt VOR der Behebung (hoch, behoben)

**Fundstelle:** `Eudora71/QCSocket/src/QCWorkerSocket.cpp:1944` (vor der
Behebung).

Commit e060a81 sichert `fnConnInfo` in `:1957` und `:1998` mit dieser
Begruendung: `Network::SetSSLMode` (`QCWorkerSocket.cpp:362-386`) wertet
**keines** seiner zehn `GetProcAddress`-Ergebnisse aus und setzt `m_bSSLMode`
trotzdem; bei einer `QCSSL.dll` der falschen Fassung ist der Zeiger NULL.

Die Begruendung ist richtig. Sie trifft aber dreizehn Zeilen hoeher genauso zu:

    :1944   bool bSuccess = g_fnQCSSLBeginSession(m_pSSLReference);

`g_fnQCSSLBeginSession` wird in `:373` aus demselben ungeprueften Block
gefuellt. Ist es NULL, stuerzt Eudora **hier** ab — die neue Pruefung in
`:1957` wird nie erreicht. Der abgesicherte Abrufpfad war damit gegen genau
den Fall wirkungslos, fuer den er gebaut wurde.

**Gegenprobe, dass es dieselbe Fehlerklasse ist:** die Datei prueft die
Geschwister laengst.

    grep -n "if (g_fnQCSSL" Eudora71/QCSocket/src/QCWorkerSocket.cpp
    453:   if (g_fnQCSSLClean)
    564:   if (g_fnQCSSLEndSession)

**Behoben** in e0f8bef: `bSuccess` faellt auf `false` zurueck, wenn der Zeiger
NULL ist; damit laeuft der Fehlerzweig, der seit heute frueh eine
verstaendliche Meldung zeigt. Byte-erhaltend mit `tools/ersetze-bereich.pl`,
CR-Zahl 18 vorher wie nachher. Uebersetzt und gelinkt: MSBuild
`QCSocket.vcxproj` Debug/Win32, Exit 0, `Bin\Debug\QCSocket.dll` entsteht, nur
die vorbestehenden C4996-Warnungen.

**Bewusst NICHT angefasst:** `g_fnQCSSLWrite` (`:1164`) und `g_fnQCSSLRead`
(`:1285`) sind ebenfalls ungeprueft. Beide sind nur ueber
`m_pSSLReference->m_pSSL` erreichbar, und das bleibt NULL, wenn
`QCSSLBeginSession` nicht lief — nach der Behebung also auch bei fehlendem
Zeiger. Ein `&& g_fnQCSSLWrite` in die Bedingung von `:1160` zu haengen waere
schaedlich: dann fiele der Zweig auf den Klartextpfad zurueck und Eudora
schickte Anmeldedaten unverschluesselt.

**Was an der Behebung von heute frueh stimmt:** die vier gemeldeten Stellen
sind wirklich zu (`:1958`, `:1978`, `:1999-2010`, `:2050-2056` in der heutigen
Zaehlung), die neue Meldung verschluckt nichts — der `else`-Zweig in
`:1967-1974` haengt nur Text an einen Fall an, der vorher gar keinen Text
bekam. Eine Kleinigkeit bleibt: faellt `pConnectionInfo` im Zweig ohne
TaskInfo weg, behaelt `m_iSSLError` seinen alten Wert, statt zurueckgesetzt zu
werden. Folgenlos, solange die Meldung aus `csError` kommt.

---

### PR-2.2 — `paket-pruefen.ps1` winkt ein Paket ohne `EudoraRes.dll` durch (hoch)

**Fundstelle:** `tools/paket-pruefen.ps1:138` und `:158`.

Das Werkzeug liest die Importtabellen der PE-Dateien — Datenverzeichnis 1 und,
richtig, auch Datenverzeichnis 13 (verzoegertes Laden, 32-Byte-Deskriptoren).
Die im Auftrag vermutete Delay-Load-Luecke gibt es **nicht**; gegen
`dumpbin /dependents` auf `EuMemMgr.dll` gemessen, gleiche Aufteilung.

Was es nicht sieht, ist alles, was in keiner Importtabelle steht.

**Gegenprobe:** aus einer ausgepackten Kopie des Pakets wurden
`EudoraRes.dll`, `QCSSL.dll`, `SPELL32.DLL`, `EuGraph.ocx`, `EuShlExt.dll`,
`x1lib.dll` und der ganze Ordner `Plugins\` geloescht. Ergebnis des Pruefers:

    ERGEBNIS: keine Fehler.        EXIT=0

Kein Wort zu `EudoraRes.dll` — der Datei, die laut `README.md:66` die gesamte
Oberflaeche traegt. Sie wird per `LoadLibrary` geholt und steht deshalb in
keiner Importtabelle. Im Baum `Eudora71\` liegen 62 `LoadLibrary`- und 28
`CoCreateInstance`-Stellen, die alle im toten Winkel liegen.

**Folge fuer 1.0.3:** `paket-pruefen.ps1` beantwortet die Frage "sind alle
Importe aufloesbar", nicht die Frage "ist das Paket vollstaendig". Als
Freigabekriterium fuer Kriterium 0 taugt es in dieser Fassung nicht. Was
fehlt, ist eine Soll-Liste der Dateien, gegen die geprueft wird.

---

### PR-2.3 — Der Pruefer benotet die Maschine, nicht das Paket (hoch)

**Fundstelle:** `tools/paket-pruefen.ps1:9` ("Warnungen allein aendern die
Rueckgabe nicht"), `:266` (Rueckfall auf das Systemverzeichnis), `:433`.

**Gegenprobe** gegen das ausgepackte `Eudora72-1.0.2-lauffaehig.zip`:

    3. VS2022-DEBUG-LAUFZEITEN
       mfc140d.dll  msvcp140d.dll  vcruntime140d.dll  ucrtbased.dll
            nicht im Paket, aber in SysWOW64 vorhanden
    ERGEBNIS: keine Fehler.        EXIT=0

Genau der Fall, fuer den das Werkzeug laut seinem eigenen Kopfkommentar
(`:13-19`) gebaut wurde — ein Paket, das auf einer fremden Maschine nicht
startet — wird mit Rueckgabe 0 durchgewunken, weil auf DIESER Maschine die
Laufzeit installiert ist.

Dazu drei Verschaerfungen:

* `:266` faellt auf `System32` zurueck. Das Skript laeuft in einer 64-Bit-
  PowerShell; dort liegen 64-Bit-DLLs, die ein x86-Prozess nicht laden kann.
  1230 DLLs sind nur dort vorhanden. Die Architektur der aufgeloesten
  System-DLL wird nirgends geprueft. Beispiel: `Finde-DLL 'aadcloudap.dll'`
  meldet "aufgeloest".
* `QCSSL.dll` importiert `mfc140.dll` und `VCRUNTIME140.dll` (Release, ohne
  `d`). Die Liste in `:360` kennt nur die vier Debug-Fassungen. Ohne
  VC-Redistributable faellt TLS auf der Zielmaschine aus, der Pruefer schweigt.
* `README.md:73-74` sagt, die vier Debug-Laufzeiten duerften **nicht**
  mitgeliefert werden; `paket-pruefen.ps1:363-364` bewertet ihr Vorhandensein
  gruen und ihr Fehlen (`:371`) als FEHLER. Werkzeug und Doku widersprechen
  sich.

Ausserdem ungeprueft: Exporte und Ordinale (`:149/:151` liest nur den Namen
des Deskriptors, nie die Thunk-Tabellen — eine `msvcr71`-Bruecke mit fehlendem
Export ergibt `0xc0000139` und bleibt unentdeckt), das eingebettete Manifest
(`Microsoft.Windows.Common-Controls 6.0.0.0`, SxS-Fehler 14001), die
COM-Registrierung von `EuGraph.ocx`/`EuShlExt.dll`/`capicom.dll`, und der Ort
der `Eudora.ini` (`:386` sucht mit `-Recurse` irgendwo im Baum, nicht dort, wo
`eudora.cpp:3542` sie sucht).

---

### PR-2.4 — Der groesste Eingriff des Tages hat keinen einzigen Test (hoch)

**Fundstelle:** Commit 1a4a6d5 aendert `Eudora71/OTShim/OTShim.cpp` um 334
Zeilen; `Eudora71/Tests/` ist in demselben Commit **nicht** angefasst.

**Gegenprobe:**

    grep -rn "DistributeRow|MoveControlBarToPosition|AssignRowExtents|m_nRowExtent|NormalizeRow" Eudora71/Tests/*.cpp
    Eudora71/Tests/TestOTShimAndocken.cpp:689:  //   NormalizeRow, die Splitter und die Client-Kanten)

Ein Kommentar. Sonst nichts. Fuenf neue Funktionen mit Zeilenaufteilung,
Rundung, Mindestbreiten und Umbau von `m_arrBars` sind ohne Zusicherung.

Schaerfer noch: der bestehende Test schreibt das **alte** Verhalten fest und
bleibt deshalb gruen, egal was die neue Rechnung tut.

    Eudora71/Tests/TestOTShimAndocken.cpp:214
    GroesseVergleichen(leiste.CalcDynamicLayout(0, LM_HORZDOCK), 32767, 40, ...)

Das trifft den Zweig `m_nRowExtent == 0`. Der neue Zweig
(`OTShim.cpp:1640-1646`, `m_nRowExtent > 0`) wird von keinem der 105 Tests
betreten. "105 von 105 gruen" ist wahr — selbst gebaut und gelaufen
(`Eudora71/Tests/RunTests.cmd`, Exit 0) — sagt ueber die Aenderung des Tages
aber nichts.

Nach Tests ohne wirksame Zusicherung wurde gezielt gesucht: die Faelle, die
auf den ersten Blick leer wirken, rufen Pruefhilfen (`PruefeKopfzeile`,
`GroesseVergleichen`), die ihrerseits `TT_Fail` aufrufen. Ein immer gruener
Test wurde **nicht** gefunden. `SECDockBar: PredictInsertPosition und
CalcDockingLayout sind als offen gekennzeichnet` (`:526-533`) prueft wirklich
etwas — dass der Rumpf noch ein Rumpf ist. Das ist Absicht und in Ordnung.

---

### PR-2.5 — `DrawChecked` hat denselben Farbfehler (mittel)

**Fundstelle:** `Eudora71/OTShim/OTShim_Werkzeugleiste.cpp:851-852`.

Die Behebung in `DrawDisabled` (db28adb) ist richtig, und zwar nachgerechnet.
Die Verknuepfungszahl `0x00B8074A` (PSDPxax) ist umgekehrt polnisch
`P S D P x a x`, also

    Ergebnis = P XOR (S AND (D XOR P))

Ist `S` lauter Einsen, bleibt `D` stehen; ist `S` null, kommt der Pinsel `P`.
Beim Kopieren von einfarbig nach farbig macht GDI aus der Maskeneins die
Hintergrund- und aus der Maskennull die Textfarbe des Ziels. Die Rechnung geht
also genau dann auf, wenn dort `0x00FFFFFF` und `0x00000000` stehen — genau
das setzt `DrawDisabled` seit heute. **Richtig.** Auch die Ruecknahme ist
sicher: der einzige vorzeitige `return` (`:799`, `nWidth <= 0`) liegt VOR dem
`SetTextColor`, und die beiden `Set…`-Zeilen am Ende laufen unbedingt.

Die Begruendung im Commit nennt `DrawChecked` als Vorbild ("setzt beide Farben
laengst"). Als Vorbild dafuer, DASS man die Farben setzt, stimmt das. WELCHE
Farben `DrawChecked` setzt, haelt derselben Rechnung aber nicht stand:

    :851  COLORREF crOldText = data.m_drawDC.SetTextColor(secData.clrBtnHilite);
    :852  COLORREF crOldBk   = data.m_drawDC.SetBkColor(secData.clrBtnFace);

`clrBtnFace` ist ueblicherweise `0xF0F0F0`, `clrBtnHilite` `0xFFFFFF`. Damit
ist `S` weder lauter Einsen noch null, sondern gemischt — das Schachbrett
erscheint nur in einem Teil der Bitebenen. Nach der Begruendung, die
`DrawDisabled` behoben hat, ist `DrawChecked` der naechste Fall derselben
Klasse. Betroffen sind die angekreuzten Knoepfe und ueber
`DrawIndeterminate` (`:864-868`) die Auszeichnungsknoepfe im Verfassenfenster.

UNGEPRUEFT auf dem Bildschirm — die Auflage verbietet den Start.

---

### PR-2.6 — Die Suchleiste teilt sich jetzt Zeile 0 mit der Hauptleiste (mittel)

**Fundstelle:** `Eudora71/Eudora/mainfrm.cpp:966`.

    DockControlBarEx(m_pSearchBar, m_pToolBar->m_pDockBar->GetDlgCtrlID(),
                     nCol+1, nRow, 1.0, nDefaultHeight);

Seit 1a4a6d5 werden `nCol` und `nRow` ausgewertet. Die Suchleiste landet damit
in derselben Zeile wie die Hauptwerkzeugleiste. `SECControlBar::m_fPctWidth`
steht bei beiden auf dem Vorgabewert `1.0` (`OTShim.cpp:1453`); Eudora setzt
ihn fuer die Hauptleiste nirgends. `SECDockBar::DistributeRow` normiert
deshalb auf 0,5 zu 0,5 — die Hauptleiste bekommt die halbe Fensterbreite.

Bei fuenfzehn Knoepfen zu je rund 24 Bildpunkten reicht das auf einem breiten
Fenster; auf einem schmalen nicht. Das ist eine **neue** Moeglichkeit, die
Hauptleiste abzuschneiden, und sie entsteht durch die Aenderung von heute.

Zweite Stelle derselben Art: `AdWazooBar.cpp:176` und `:212` docken mit
`nCol=5, nRow=0, fPctWidth=0.25` an, `WazooBarMgr.cpp:253` mit
`nCol=0, nRow=0, fPctWidth=1.00` an dieselbe untere Leiste. Vorher hatte jede
ihre eigene Zeile, jetzt teilen sie sich Zeile 0 im Verhaeltnis 0,8 zu 0,2.
Das ist vermutlich genau das Gewollte — nachgewiesen ist es nicht.

**Was an der Rechnung stimmt** (von Hand durchgerechnet, ohne Lauf):

* Division durch null gibt es nicht: `fSum > 0.0` steht vor jeder Division
  (`OTShim.cpp:2688`, `:2694`), `nBars > 0` vor `1.0/nBars` (`:2669`).
* Negative Breiten gibt es nicht: `nExtent = nRest - nReserve` kann negativ
  werden, wird aber von `if (nExtent < nMin)` und zuletzt von
  `if (nExtent < 1) nExtent = 1` (`:2708`) aufgefangen.
* Leere Zeile: `DistributeRow(nStart, nStart, …)` sammelt nichts und kehrt bei
  `nBars <= 0` sofort um. Die fuehrende NULL-Marke erzeugt genau diesen Fall
  im ersten Schleifendurchlauf.
* Genau eine Leiste: sie ist die letzte, bekommt `nRest` = `nAvail`, also die
  ganze Zeile — dasselbe Ergebnis wie vorher mit 32767.
* `MoveControlBarToPosition` von Hand durchgespielt fuer den ersten und den
  zweiten Andockvorgang: `[NULL,bar1,NULL]` bleibt `[NULL,bar1,NULL]`,
  `[NULL,bar1,NULL,bar2,NULL]` wird zu `[NULL,bar1,bar2,NULL]`. Richtig.
* Der Umbruch in MFC greift nicht mehr: `CDockBar::CalcFixedLayout`
  (`atlmfc/src/mfc/bardock.cpp`) bricht bei
  `rect.left >= sizeMax.cx - afxData.cxBorder2` um und zaehlt
  `pt.x += sizeBar.cx - afxData.cxBorder2`. Da die Summe der zugeteilten
  Laengen genau `nAvail` ist und je Leiste ein `cxBorder2` abgezogen wird,
  bleibt die Zeile unter der Schranke.
* Der Weg dorthin stimmt auch: MFC ruft nicht `CalcFixedLayout`, sondern
  `pBar->CalcDynamicLayout(-1, LM_HORZDOCK|LM_HORZ)`. Waere dort
  `CControlBar::CalcDynamicLayout` zustaendig, kaeme `bStretch = FALSE` heraus
  und `m_nRowExtent` wuerde nie angewandt. `SECControlBar::CalcDynamicLayout`
  (`OTShim.cpp:1654-1658`) gibt aber ausdruecklich `CalcFixedLayout(TRUE, …)`
  zurueck. Die Kette traegt.

---

### PR-2.7 — `paket-bauen.ps1` ist kein Bau (mittel)

**Fundstellen:** `tools/paket-bauen.ps1:59-60`, `:103-106`, `:115`, `:161`.

* `:60` nimmt als Grundlage das **alte** ZIP. Frische Binaerdateien kommen nur
  mit `-AusBauverzeichnis` und nur fuer sieben fest verdrahtete Namen
  (`:103-106`). Fehlt eine davon, bleibt die alte stehen (`:115`, gelbe
  Zeile) — und das ZIP wird trotzdem geschrieben.
* Debug oder Release ist nirgends festgelegt: `Bin\Debug` ist hartkodiert
  (`:86`), gleichzeitig werden `Bin\Release`-Dateien beigemischt (`:125`,
  `:129`, `:139`).
* In einem frischen Klon laeuft es gar nicht: `.gitignore:6` ignoriert `Bin/`,
  `:59` erwartet aber `Eudora71\Bin\Release\msvcr71.dll`. Gemessen in diesem
  Worktree: Abbruch mit EXIT=1 in `:74` — **nach** dem Auspacken in `:71`, so
  dass 155 Dateien einer unveraenderten 1.0.2 im Zielverzeichnis stehen
  bleiben und wie ein 1.0.3-Bauverzeichnis aussehen. Kein Aufraeumen im
  Fehlerfall.
* Reproduzierbar ist es nur auf derselben Maschine in derselben Stunde:
  `:161` `CreateFromDirectory` schreibt Aenderungszeiten ins ZIP. Zwei Laeufe
  ohne Aenderung ergaben denselben Hash; eine verstellte `LastWriteTime`
  ergab einen anderen. Die aus dem Git-Checkout kopierten Dateien (`:146-147`,
  `:153`) tragen die Auscheckzeit. Das `.sha256` in `:162` verspricht eine
  Reproduzierbarkeit, die es nicht gibt.
* Vollstaendigkeit wird vor dem Schreiben nicht geprueft (`:159-161`);
  `paket-pruefen.ps1` wird erst danach als Textzeile empfohlen (`:172`) — und
  wuerde nach PR-2.2 ohnehin nichts merken.
* Keine Versionskopplung: weder die Datei `VERSION` noch
  `tools/kennung-erzeugen.pl` kommen vor. Ein ZIP mit Namen 1.0.3 kann eine
  1.0.2-`Eudora.exe` enthalten, ohne dass etwas warnt. Genau davor warnt
  `Releases/PAKETE.md` bei der QCSSL.dll.
* Das Grundlagen-ZIP wird ohne Hash-Abgleich ausgepackt (`:62`, `:71`),
  obwohl daneben eine `.sha256` liegt.

`tools/laufzeit-holen.ps1` laedt nichts aus dem Netz (geprueft: kein
`Invoke-WebRequest`, `DownloadFile`, `System.Net`, `http` in allen drei
Skripten). Auf einem Rechner ohne Visual Studio bricht es ab, aber nicht
sauber: mit einer Quelle, die nur drei der vier Pflichtdateien hat, kopiert es
zwei Dateien und meldet danach EXIT=1 — zurueck bleibt ein halb bestuecktes
Verzeichnis. Ausserdem ist `:74` `C:\Windows\SysWOW64` hartkodiert, waehrend
`paket-pruefen.ps1:196` es richtig ueber `$env:SystemRoot` macht, und
`Architektur()` (`:44-55`) prueft weder `MZ` noch `PE\0\0` und hat kein
`finally`.

---

### PR-2.8 — `EUDORA_BUILD_MONTH` bleibt auf Juni 2006 (niedrig, kein Handlungsbedarf)

**Fundstelle:** `Eudora71/Version.h:19`.

    #define EUDORA_BUILD_MONTH REG_EUD_CLIENT_7_1_MONTH

`regcode/regcode_eudora.h:129` gibt dafuer `(89)` an, "June 2006". Ein
`REG_EUD_CLIENT_7_2_MONTH` gibt es nicht; die Reihe endet bei 7_1.

Benutzt wird der Wert an fuenf Stellen: `QCSharewareManager.cpp:944, 953, 963`
(Ablauf eines Registrierungscodes), `:1182-1183` (`DemoDaysLeft`) und
`QCSharewareManager.h:85` (`IsNewDemoBuild`).

**Nicht mitzuaendern ist richtig.** Die Zahl bedeutet "in welchem Monat wurde
dieses Produkt gebaut" und dient dazu, Registrierungscodes ablaufen zu lassen,
die aelter als zwoelf Monate sind. Ein Hochsetzen auf einen Wert nahe heute
(rund 320) wuerde `(regCodeMonth + 12) < EUDORA_BUILD_MONTH` fuer **jeden**
existierenden Eudora-Code wahr machen und alle vorhandenen Registrierungen
entwerten. `IsNewDemoBuild` wuerde ausserdem jede gespeicherte
`DemoBuildMonth` als aelter einstufen und die Testfrist neu starten. Beides
ist nicht gewollt.

Die im Commit 2cf569f genannte Nebenwirkung ist eine andere und trifft zu:
`QCSharewareManager::Load` vergleicht `EUDORA_BUILD_VERSION` (die Zeichenkette
`"7.2.0.3"`) mit der `RetailVersion` in der INI, nicht `EUDORA_BUILD_MONTH`.

---

### PR-2.9 — Falsche Zeilenangabe in BEFUND-ANSICHT.md (niedrig)

`Eudora71/OTShim/BEFUND-ANSICHT.md:279` nennt `Splitter::cx` (= 4,
`OTShim.cpp:2091`). Die Zeile stimmt nicht mehr:

    grep -n "Splitter::cx" Eudora71/OTShim/OTShim.cpp
    2109:  const int SECDockBar::Splitter::cx = 4;
    2675:  const int nMin = 4 * Splitter::cx;

Der Wert 4 stimmt, die Fundstelle ist um 18 Zeilen verrutscht.

---

### Geprueft und in Ordnung

* **`m_bMainFrameEnabled = FALSE`** (`OTShim_Werkzeugleiste.cpp:3514`, `:3541`).
  Alle fuenf Abfragestellen in Eudora lesen TRUE als "der Anpassen-Dialog
  steht offen": `mainfrm.cpp:2988` (Schliessen unterbinden), `:8668`
  (`OnNcHitTest` liefert HTERROR), `:8679` und `:8727` (`WF_STAYACTIVE`
  loeschen), `:8743` (`OnEnterIdle` nur bei `MSGF_DIALOGBOX`). FALSE ist
  ueberall die richtige Ruhelage. Der Rueckweg existiert und wird gerufen:
  `SECToolBarCmdPage::~SECToolBarCmdPage` (`:4377`) ruft `RestoreMainFrame`,
  und `QCToolBarCmdPage` (`QCToolbarCmdPage.cpp:117`, das
  `EnableMainFrame` ruft) leitet sich davon ab. Kein Haengenbleiben auf TRUE.
* **`EudoraTests.exe`**: selbst gebaut und gelaufen ueber
  `Eudora71/Tests/RunTests.cmd`. 105 Tests, 105 bestanden, 0 fehlgeschlagen,
  Exit 0. Die Zahl stimmt.
* **Delay Load**: die vermutete Luecke in `paket-pruefen.ps1` gibt es nicht,
  siehe PR-2.2.

### Offen geblieben

Aus Zeitgruenden nicht mehr erreicht: die Stichprobe zu
`tools/zeilenenden-angleichen.pl`, BEFUNDE.md S-1 bis S-6, `utils.cpp
ISOTranslate`, sowie die eigenen Gegenproben gegen `tools/pruefe-bytes.pl` und
die Fehlalarmquote von `tools/suche-zeiger.pl`. FREIGABEs Release-Bau lag
nicht vor und ist ungeprueft.

## S-8 — Paket 1.0.2 startet mit `0xc000007b` (31.08.2026)

Nachgetragen von LEKTOR am 31.08.2026. Der Befund war bis dahin nur im Commit
`76efdb6`, in `README.md` und in `Releases/1.0.2/LIESMICH.txt` festgehalten, in
dieser Datei fehlte er. Anlass fuer `ZIEL.md`, Kriterium 0.

**Was Gregor sah.** Paket 1.0.2 ausgepackt, `Eudora.exe` gestartet:

    Die Anwendung konnte nicht korrekt gestartet werden (0xc000007b)

Kein Fenster, kein Absturzdialog, kein Protokolleintrag.

**Ursache.** `0xc000007b` ist `STATUS_INVALID_IMAGE_FORMAT`. Der Lader hat eine
Abhaengigkeit gefunden, die er nicht in den Prozess bringen kann. Im
Programmverzeichnis fehlten die vier Debug-Laufzeiten des VS-2022-Baus
vollstaendig (nachgemessen):

    mfc140d.dll   msvcp140d.dll   vcruntime140d.dll   ucrtbased.dll

**Warum es so leicht schiefgeht.** `Eudora.exe` ist ein **32-Bit**-Programm
(`Debug|Win32`, im PE-Kopf nachgemessen). Zwei Fallen fuehren beim Nachlegen der
DLLs zur 64-Bit-Fassung und damit erneut zu `0xc000007b`:

| Falle | Warum |
|---|---|
| DLL-Sammelseiten wie dll-files.com | liefern haeufig die 64-Bit-Fassung, ohne es deutlich zu machen |
| der Ordnername `SysWOW64` | er enthaelt die **32**-Bit-DLLs; die 64-Bit-DLLs liegen in `System32`. Der Name legt genau das Gegenteil nahe |

**Behebung.** `tools/laufzeit-holen.ps1` (neu in `76efdb6`). Es holt die vier
Dateien aus `C:\Windows\SysWOW64` und prueft **jede einzeln** im PE-Kopf auf
x86 nach; kopiert wird nur, was wirklich x86 ist. Mit `-NurPruefen` sagt es nur,
was fehlt. Gegen Gregors Testverzeichnis gelaufen: alle vier vorhanden und x86.
Die auf dieser Maschine vorhandene Fassung ist 14.38.33142.0 gegen Toolset
14.38.33130.

**Was damit NICHT geloest ist.** Die vier Debug-DLLs duerfen nicht
weiterverteilt werden — Microsoft nimmt die Debug-Fassungen der Laufzeit
ausdruecklich davon aus, bei Visual Studio liegen sie deshalb unter
`debug_nonredist`. Ein Redistributable gibt es nicht. Solange nur der Debug-Bau
laeuft, braucht jeder Empfaenger des Pakets ein installiertes Visual Studio
2022. Das widerspricht Kriterium 0 („zip runterladen, entpacken, starten —
laeuft"). Der Ausweg ist ein **Release-Bau**, vorzugsweise statisch gebunden;
Einzelheiten und Abwaegung in `ZIEL.md`, Abschnitt „Kriterium 0". Bis dahin
misst `tools/paket-pruefen.ps1` den Paketinhalt gegen die Startkette.

**Bezug zu anderen Befunden.** S-1 (Paket 1.0.1 startete nicht) hatte eine
andere Ursache — dort lagen die *falschen* Fremd-DLLs bei. S-8 ist der Fall,
dass die eigene Laufzeit ganz fehlt.

## Z-1 — Alle Zahlen und Fundstellen des 31.08. nachgerechnet (31.08.2026)

Ein Prüfdurchgang hat jede Zahl und jede Zeilenangabe der heutigen Befunde
gegen die Quelle gehalten. **Nichts wurde geändert** — das hier ist die Liste
der Abweichungen, damit niemand auf einer falschen Angabe aufbaut.

### Falsch

| Stelle | Behauptung | tatsächlich |
|---|---|---|
| P-2.1, P-2.3 | „die **zehn** `GetProcAddress`-Ergebnisse (`:373-383`)" | es sind **elf** (373…383). Die Zahl steht zweimal falsch da. |
| P-2.1 | „in `Releases/1.0/` liegen **mehrere** `QCSSL.dll`-Fassungen" | es liegt **genau eine** (2.920.960 B), SHA256-identisch mit der im Paket 1.0.2. **Damit trägt die Begründung des Absturzszenarios so nicht.** |
| P-2.2 | „**alle fünf** echten Aufrufer übergeben die Adresse eines Elements" | es gibt einen **sechsten**: `Eudora71/Imapdll/src/Network.cpp:539` reicht in `CNetStream::SetSSLMode` einen Zeigerparameter weiter. Nicht auf dem POP-Weg, aber „alle fünf" ist falsch. |
| P-2.2 (Quelltext) | Kommentar „Zeile **2065** unten prüft ihn auch" | die Prüfung steht nach der eigenen Änderung bei **2070**; in 2065 steht etwas anderes. Die Korrektur hat ihre eigene Zeilenangabe veraltet gemacht. |
| M-1 | `HTERROR` in `mainfrm.cpp:8670`, Funktion `8662-8671`, Kommentar `:8744` | durchweg **um eins daneben**: 8671, 8663–8672, 8745. Dieselbe Verschiebung ist in die neuen Quelltextkommentare übernommen worden (`OTShim_Werkzeugleiste.cpp:3790`, `.h:1153`). |
| M-1 | Konstruktoren `:3480` und `:3506` | das war der **Vorzustand**. Heute `:3514` und `:3541`. Im Text nicht als „vorher" gekennzeichnet. |
| A-1 | „Ursache belegt", fünf Fundstellen, 32767, Verdacht `DrawDisabled` | war an `31810e2` richtig, ist **heute überholt** — `1a4a6d5` und `db28adb` haben genau das behoben. Sämtliche Zeilenangaben des Abschnitts stimmen im heutigen Baum nicht mehr. Nur `SetControlBarWidthsInRow` ist noch leerer Rumpf (`OTShim.cpp:2244`) und `OnSizeParent` reicht noch durch (`:3276`). |
| B-2.2 | Startkette des **ausgelieferten** Pakets = **elf** Module | **zwölf** — dazu `msvcr71d.dll`, weil die gepackte `Paige32d.dll` der Debug-Bau ist. Die Elferliste ist die von Paket **1.0.3**, nicht die des ausgelieferten. |
| B-2.5 | Paket 1.0.2: **3 Fehler, 5 Warnungen** | heute mit dem eingecheckten Prüfer: **0 Fehler, 8 Warnungen**. Die Spalte stammt aus einem älteren Stand des Werkzeugs. |
| W-1 / PR-7 | „S-7 nachgezogen, Tabelle eingefügt, Beispiel berichtigt" | **S-7 ist unverändert.** Der Kasten behauptet weiter, der Werkzeugkopf nenne „4426 von 5336" — das ist dort ersatzlos entfernt worden. Die Tabelle steht nur im Werkzeugkopf. Die Beschriftung des Beispiels ist weiterhin vertauscht. |
| W-1 / PR-3 | Grundgesamtheit **6385** | heute **6392**. Wächst mit jedem Commit — kein Widerspruch, aber schon am Tag des Schreibens flüchtig. |

### Bestätigt

`P-2.1` alle vier Fundstellen exakt der Vorzustand, die Rechnung
`CRString(8000 + (-1-10000))` geht auf · `P-2.3` acht Treffer, alle sieben
Fehlalarm-Bewertungen stichprobenweise richtig · `P-2.4` `TextReader.cpp:251`
und `utils.h:90` · `P-2.7` **105 Tests, 105 bestanden** selbst ausgeführt ·
`M-1` `tbarmgr.h:79-80`, **genau fünf** Abfragestellen (2988, 8668, 8679, 8727,
8743), `91716bb` als Einführungscommit, `RestoreMainFrame` wird gerufen ·
`A-1` 15 Standardknöpfe, `secData`, `DockBar.cpp` prüft selbst auf
`SWM_MODE_ADWARE` · `B-2.1` die echte GUID steht in der Solution, die falsche
weiter in `VC71Bruecke/BEFUND.md:462` · `B-2.3` `EUMAPI.DLL` ist keine PE-Datei
— und der als UNGEPRÜFT markierte Verdacht **stimmt**: Signatur `NE`, also eine
**16-Bit-Datei** · `W-1` 23 Testfälle grün, Blob `8c4fb68a` = 5716 B mit 65 LF,
5716+65 = 5781.

### Was daraus folgt

**Zeilenangaben veralten, sobald jemand dieselbe Datei anfasst.** Sieben der elf
Abweichungen sind genau das — nicht falsch gemessen, sondern durch spätere
Commits verschoben. Wer eine Fundstelle benutzt, prüft sie nach.

Nicht prüfbar in jenem Arbeitsbaum: die Größenangaben zu `Eudora.exe` und die
MSBuild-Läufe aus P-2.4, B-2.1 und W-1.

## X-1 — Die Werkzeuge angegriffen: neun Löcher in der Schranke (31.08.2026)

Ein Angriffsdurchgang gegen die eigenen Werkzeuge, mit 15 selbst gebauten
Fällen, von denen **keiner** in `tools/pruefe-bytes-tests.pl` steht.
**Ergebnis: 9 Löcher, 0 Fehlalarme.** Die Bestandssammlung läuft weiter 23/23
grün — diese Funde kommen obendrauf.

### Schwer

**L1 — Umbenennung hebelt die Schranke vollständig aus.** `pruefe-bytes.pl:198`
benutzt `--diff-filter=ACM`. Ein `git mv alt.cpp neu.cpp` erscheint als `R088`
und landet nie in der Prüfliste. Wer danach die Datei neu schreibt, kann jedes
Zeilenende und jedes Sonderzeichen zerstören — Rückgabe 0. **`git mv` plus
Neuschreiben ist genau der Ablauf einer Portierung.**

**L2 — Latin-1 → UTF-8 umkodiert bleibt unerkannt.** Gezählt werden nur
Ersatzzeichen (`EF BF BD`). Eine *saubere* Umkodierung (`0xE4` → `C3 A4`)
erzeugt keines; der Inhalt ändert sich, also greift Regel 2, und dort verwirft
Zeile 165 das Paar. Das ist genau der Schaden, gegen den die Regel
„byte-erhaltend ändern" existiert.

**L3 — Ein neu eingefügtes UTF-8-BOM** (`EF BB BF`) bleibt aus demselben Grund
unerkannt.

### Mittel

**L4** — bei Dateien mit NUL-Byte ist Regel 2 blind: `git diff -U0` liefert nur
„Binary files differ", kein `@@`. Derzeit latent — von 6392 erfassten Dateien
enthält keine ein NUL-Byte.

**L5** — die Vorausschau von 30 Zeilen (`:118`) ist eine harte Grenze, exakt
gemessen: 30 eingefügte Zeilen vor der Umwandlung → erkannt, **31 → durch**.
Ehrlich dazu: an echten Projektdateien wird es trotzdem erkannt, weil git
wiederkehrende Zeilen in mehrere Blöcke zerlegt. Das Loch ist synthetisch
belegt, an Projektmaterial nicht.

**L6** — reine CR-Zeilenenden (Mac-Stil) → LF bleiben unerkannt; normalisiert
wird nur `\r\n`.

**L7** — verliert die letzte Zeile ihr CRLF, wird das bewusst durchgelassen
(`:166`). Es ist trotzdem ein echter Byteverlust.

### Leicht

**L8** — neue Dateien werden gar nicht geprüft (`:205`); eine neue Datei mit
Ersatzzeichen läuft durch. **L9** — eine in HEAD leere Datei gilt als „nicht
vorhanden" und wird übersprungen.

### Zusatzfund: der pre-commit-Hook wertet seinen ersten Schritt nicht aus

`tools/hooks-einrichten.sh:20` ruft `lehren-spiegeln.pl` ohne `set -e` und ohne
Prüfung von `$?`, danach `exec pruefe-bytes.pl`. Wenn das Spiegeln mit
`exit 1` abbricht und „Der Commit wurde abgebrochen" meldet, **stimmt das
nicht** — der Hook gibt 0 zurück. Die gespiegelten Lehren gehen weiterhin
lautlos aus dem Commit heraus. Das ist derselbe Befund wie NP3-4, in anderer
Gestalt.

### `tools/suche-zeiger.pl` ist Rauschen

Über 3237 Dateien: **345 Treffer**. Stichprobe von 15 zufällig gezogenen:
**15 Fehlalarme, also 100 %.** Drei strukturelle Ursachen erklären 273 der 345
(79 %): klammerloser `if`-Rumpf (211), einzeiliger Wächter mit `return` (16),
Abstand größer als das Fenster von 40 Zeilen (46). In allen 23 handgeprüften
Treffern **ein** plausibel echter: `EuImap/src/ImapMailbox.cpp:1022` prüft
`pAccount`, `:1051` dereferenziert außerhalb des Blocks.

Urteil: etwa ein brauchbarer Treffer auf 70 Ausgabezeilen. Ohne die drei
Filter nicht benutzbar.

### `tools/zeilenenden-angleichen.pl`: zwei Lücken

**Es lässt Textdateien aus.** Von 9146 verfolgten Dateien erfasst das Muster
6392; von den 2754 übrigen sind **773 eindeutig Text**. Projektrelevant fehlen
`.ih` (6 C-Header, werden mitkompiliert), `.rgs` (12 ATL-Registrar-Skripte,
landen als Ressource im Binary), `.hh` (7 Hilfe-Header), `.mc`, `.hpj`, dazu
139 Dateien ohne Endung. `tools/dateiendungen.pl:30` führt `cc`, aber nicht
`hh` und `ih`.

**Es dreht absichtliche Arbeit still zurück.** Die Zeilen 129-141 schreiben den
HEAD-Stand **richtungslos**. Wer im Arbeitsbaum absichtlich LF→CRLF korrigiert
— etwa eine `.bat`, die CRLF braucht —, verliert das durch `--aendern`
kommentarlos, und die Datei erscheint unter „angeglichen" statt unter
„inhaltlich verschieden".

**Entwarnung:** von den 6392 erfassten Dateien enthält **keine** ein NUL-Byte
und **keine** ein UTF-16-BOM. Bilder, DLLs und Archive liegen alle außerhalb
des Musters. Es fasst also keine Binärdatei fälschlich an.

### Was daraus folgt

Nichts davon ist heute akut — aber L1 und L2 sind die beiden Schäden, gegen die
die Schranke überhaupt gebaut wurde, und gegen beide ist sie wirkungslos. Wer
sie als Sicherheit betrachtet, irrt.

## E-1 — Der erste erfolgreiche Mailabruf (31.08.2026, 08:15)

**Gregor hat mit dieser Fassung Mail abgerufen.** Zum ersten Mal seit Beginn der
Portierung. Belegt durch zwei Bildschirmfotos.

Gebaut aus `93762c7`, Paket `C:\Users\Gregor\Eudora72-1.0.3`, Titelleiste:

    Eudora [Eudora 7.2.0.3 / Paket 1.0.3+93762c7* 2026-08-31 08:04 - Eudora72-1.0.3] - [In]

### Was funktioniert

| | |
|---|---|
| **Mailabruf** | Fortschrittsbalken in der Statuszeile, danach **159 Nachrichten** im Eingangspostfach (`159/4319K/0K`) |
| **Anzeige** | Absender, Datum, Größe, Betreff in der Liste; Vorschaubereich zeigt eine vollständige Nachricht mit Kopfzeilen und Text |
| **Menüs** | das *File*-Menü klappt auf und ist vollständig — **Befund S-5 ist behoben**, die Behebung M-1 wirkt |
| **Anordnung** | Postfachbaum links, Nachrichtenliste rechts oben, Vorschau darunter. **Keine sich überlagernden Bereiche mehr** — die neue Andockrechnung aus A-1 wirkt |
| **Umlaute** | im Vorschaubereich korrekt („Guten Tag", „gültig", „vergangen") |

### Was damit belegt ist

**Kriterium 3 aus `ZIEL.md` ist erfüllt.** Ein Mailkonto lässt sich einrichten,
verbinden, und Mail wird abgerufen und lesbar dargestellt. Das war nie zuvor
geprüft.

Zugleich ist damit der **erste echte Servertest der neuen TLS-Schicht**
bestanden — bisher lag nur ein Test mit einer *älteren* QCSSL-Fassung vor
(`AUSLIEFERUNGEN.md`).

**Kriterium 1 ist erfüllt.** Das Fenster erscheint und ist bedienbar. Die
Einstufung „strittig" vom 30.08. ist damit aufgehoben.

### Was noch nicht stimmt

**Die Werkzeugleiste hat weiterhin leere graue Felder** — auf dem ersten
Bildschirmfoto der erste Knopf und drei weitere in der Mitte. Die Behebung an
`SECStdBtn::DrawDisabled` (A-1) hat also **nur einen Teil** der Fälle
erwischt. Damit ist **Kriterium 2 weiterhin nicht erfüllt**.

Nächster Ansatz dafür steht in `BEFUND-ANSICHT.md`: der Zeichenweg je Knopf,
Punkte 2 und 3 (`GetDrawData`, `TBBS_HIDDEN`), und `SetControlBarWidthsInRow`
ist noch ein leerer Rumpf (`OTShim.cpp:2244`), `OnSizeParent` reicht noch durch
(`:3276`).

**Beim Start sind zwei bis drei SUPERASSERT-Dialoge wegzuklicken**, dazu einige
Warnungen. Das ist der Debug-Bau; im Release-Bau entfallen sie.

### Stand der vier Kriterien

| # | Kriterium | Stand |
|---|---|---|
| 0 | Paket läuft ohne Nachinstallieren | **nicht belegt** — der Paketprüfer trägt nicht, siehe PR-2 |
| 1 | startet und zeigt sein Hauptfenster | **erfüllt** |
| 2 | die Darstellung ist korrekt | **nicht erfüllt** — leere Werkzeugleisten-Knöpfe |
| 3 | Mailkonto verbinden und Mail abrufen | **erfüllt** |

## E-2 — Werkzeugleiste vollständig, aber Umlaute in HTML-Mails zerstört (31.08.2026, 08:25)

Zweites Bildschirmfoto aus demselben Lauf (`93762c7`, Paket 1.0.3).

### Behoben: die leeren Werkzeugleisten-Knöpfe

Auf diesem Bild ist die Werkzeugleiste **vollständig** — alle Symbole
vorhanden, kein einziges graues Feld mehr. Die Behebung an
`SECStdBtn::DrawDisabled` (A-1, Commit `db28adb`) **wirkt also doch**.

Warum das erste Bildschirmfoto welche zeigte: dort war noch kein Postfach
geöffnet und keine Nachricht ausgewählt, also waren die betroffenen Knöpfe
gesperrt. Sobald Nachrichten da sind, werden sie freigegeben und normal
gezeichnet. Der Fall „gesperrt und leer" ist damit behoben; der Fall „gesperrt
und erkennbar grau" bleibt zu prüfen, wenn wieder einmal Knöpfe gesperrt sind.

Auch der Aufgabenbereich unten („Task Status" / „Task Errors") sitzt jetzt als
eigener Streifen am unteren Rand, nicht mehr senkrecht mitten im Fenster.

### NEU UND OFFEN: Umlaute in HTML-Nachrichten werden zu `◆`

    Video Lernkurs f◆r Excel 2019 - 2021 - G◆ltig bis 23.03.2022
                     ^                      ^
                     ü                      ü

**Im reinen Text stimmten die Umlaute** — dieselbe Sitzung zeigte kurz zuvor
„gültig" und „vergangen" richtig (Befund E-1). Der Fehler trifft also nur den
**HTML-Anzeigepfad**, nicht `ISOTranslate` im Textpfad.

Das Zeichen ist ein Ersatzzeichen, kein Zeichensalat: **die Quelle wird als
etwas anderes gelesen, als sie ist.** Wahrscheinlich ist der Zeichensatz aus
dem `Content-Type` oder aus einem `<meta charset>` nicht ausgewertet, und der
Text kommt als UTF-8-Bytes in einen Wandler, der Windows-1252 erwartet — oder
umgekehrt.

**UNGEPRÜFT**, wo genau. Anzusehen wären:

  - der HTML-Anzeigepfad (`TridentView.cpp`, `PgEmbeddedImage.cpp` und was
    sonst die Vorschau mit HTML füllt)
  - ob der Zeichensatz aus dem MIME-Kopf überhaupt bis dorthin gereicht wird
  - `ISOTranslate` in `utils.cpp` wird hier offenbar **nicht** durchlaufen,
    sonst wäre das Ergebnis dasselbe wie im Textpfad

Gregors Einschätzung: *„das kann man beheben."*

### Stand der vier Kriterien

| # | Kriterium | Stand |
|---|---|---|
| 0 | Paket ohne Nachinstallieren | **nicht erfüllt** — Debug-Bau |
| 1 | startet, Hauptfenster bedienbar | **erfüllt** |
| 2 | Darstellung korrekt | **fast** — Anordnung, Menüs und Werkzeugleiste stimmen; **Umlaute in HTML-Mails nicht** |
| 3 | Mailkonto verbinden und Mail abrufen | **erfüllt** |

## E-3 — TLS 1.3 mit der ausgelieferten QCSSL 1.0.1, gegen einen echten Server (31.08.2026, 08:09:43)

Abgelesen in Eudoras eigenem Dialog *Tools → Last SSL Info*
(„Eudora SSL Connection Information Manager"), Bildschirmfoto von Gregor.

| | |
|---|---|
| Server | `mx.freenet.de`, `194.97.208.35` |
| **Port** | **110** |
| Zeitpunkt | Monday, August 31, 2026, 08:09:43 |
| Negotiation Status | **Succeeded** |
| SSL Version | **TLSv1.3** |
| Encryption Algorithm | **TLS_AES_256_GCM_SHA384 (256 bits)** |

### Warum das wichtig ist

Damit ist die offene Frage aus `Releases/1.0/AUSLIEFERUNGEN.md` beantwortet.
Dort stand: *„Der Mailserver-Test steht für sie aus."* Der bisherige
erfolgreiche Abruf (29.08., `pop.gmx.net`) war mit `c875a750` gelaufen — der
Fassung **ohne** den Regressionsfix H1 und **ohne** WACHEs fünf Befunde.

**Jetzt ist die ausgelieferte QCSSL 1.0.1 (`ab55281a`) selbst gemessen:**
TLS 1.3 mit einem AEAD-Verfahren, Aushandlung erfolgreich. Die strengeren
Vorgaben aus M1 (Mindestprotokoll TLS 1.2 für alle Einstellungen) haben nichts
verschlechtert — genau das war die Sorge, die in AUSLIEFERUNGEN.md formuliert
war.

### Port 110, nicht 995 — und das ist richtig so

`ABRUF-PRUEFEN.md` empfiehlt `SSLReceiveUse=2` mit Port 995, also **implizites
TLS**. Gregor hat stattdessen **Port 110 mit STARTTLS** benutzt, und es
funktioniert: die Verbindung beginnt im Klartext auf dem gewöhnlichen
POP3-Port und wird per `STLS` auf TLS 1.3 gehoben.

Das ist kein Widerspruch, sondern der zweite gangbare Weg. `ABRUF-PRUEFEN.md`
sollte beide nennen, statt nur einen — mit dem Hinweis, dass freenet auf 110
mit STARTTLS nachweislich arbeitet.

Nebenbei beantwortet: die in `ABRUF-PRUEFEN.md` als **UNGEPRÜFT** markierte
Frage, ob `mx.freenet.de` überhaupt POP3 spricht. **Ja**, auf Port 110.

### Was damit belegt ist

Die ganze Kette trägt: OpenSSL 3.5.8 LTS → QCSSL 1.0.1 → `QCWorkerSocket` →
POP3 über STARTTLS → 159 abgerufene Nachrichten. Kein Absturz, keine
Zertifikatswarnung — der mitgelieferte aktuelle Wurzelzertifikatsspeicher
(`rootcerts.p7b`, 121 Zertifikate) trägt gegen freenet.

## E-4 — Debug-Zusicherung beim Beenden: Index außerhalb von `m_arrBars` (31.08.2026, OFFEN)

Beim **Schließen** von Eudora:

    Microsoft Visual C++ Runtime Library
    Debug Assertion Failed!
    Program: C:\Users\Gregor\Eudora72-1.0.3\mfc140d.dll
    File:    ...\ATLMFC\Include\afxcoll.inl
    Line:    213

### Was an dieser Zeile steht — nachgeschlagen, nicht geraten

`afxcoll.inl:213` ist die Bereichsprüfung in **`CPtrArray::ElementAt`**:

```cpp
_AFXCOLL_INLINE void*& CPtrArray::ElementAt(INT_PTR nIndex)
    { ASSERT(nIndex >= 0 && nIndex < m_nSize);      // <- Zeile 213
```

Also ein **Index außerhalb des Arrays**. In der Ersatzschicht kommt `ElementAt`
nicht vor — aber MFCs eigene `CDockBar` benutzt es auf `m_arrBars`, und genau
daran hat die heutige Andockrechnung gearbeitet.

### Wahrscheinlichste Ursache (UNGEPRÜFT)

`SECDockBar::MoveControlBarToPosition` (`OTShim.cpp:2718-2795`, heute neu) baut
`m_arrBars` **von Hand** um: `RemoveAt` (bis zu zweimal), dann `InsertAt`, dann
gegebenenfalls eine `NULL`-Endemarke anhängen.

`m_arrBars` ist kein gewöhnliches Feld: MFC hält darin Zeiger auf Leisten,
getrennt durch `NULL`-Marken, die die Zeilen abschließen — und `CDockBar` führt
parallel dazu Zustand mit (`CControlBar::m_pDockBar`, die Positionsangaben, und
`CFrameWnd::m_listControlBars`). Wer das Feld umbaut, muss diesen Zustand
mitziehen.

Der Verdacht: beim Beenden läuft MFCs eigener Abbauweg über `m_arrBars` und
trifft auf eine Struktur, die zu dem nicht passt, was es sich gemerkt hat.

**Nicht widerlegt, aber auch nicht belegt** — es fehlt der Aufrufstapel.

### Wie man es morgen in Minuten findet

`tools/stapel-untersuchen.ps1` fängt die Ausnahme und läuft die EBP-Kette ab.
Damit wurde S-2 gefunden. Nötig: `Eudora.pdb` neben der `Eudora.exe` im Paket.
Eine Debug-Zusicherung ist allerdings keine Ausnahme im Sinne des Debuggers —
sie zeigt einen Dialog. Zwei Wege:

1. Im Dialog **„Wiederholen"** drücken: das löst einen Haltepunkt aus, den der
   Debugger als Ausnahme sieht.
2. Oder `_CrtSetReportMode(_CRT_ASSERT, _CRTDBG_MODE_DEBUG)` setzen, dann geht
   die Meldung in die Debugausgabe statt in einen Dialog.

### Einordnung

Es passiert **beim Beenden**, nachdem alles funktioniert hat — Abruf,
Darstellung, Menüs. Kein Datenverlust ist zu erwarten: Eudora hat seine
Postfächer zu diesem Zeitpunkt geschrieben. Im **Release-Bau gibt es die
Meldung nicht**, weil `ASSERT` dort entfällt — der zugrunde liegende
Indexfehler bliebe aber bestehen und könnte dort still danebengreifen. Das ist
der Grund, ihn nicht auf sich beruhen zu lassen.

## Z-2 — Umlaute in HTML-Nachrichten: der Zeichensatz wird nirgends angesagt (Ursache gefunden, 31.08.2026, ZEICHEN)

Befund E-2: In HTML-Nachrichten steht statt eines Umlauts ein Ersatzzeichen
(`f<>r` statt `fuer`), im reinen Text derselben Sitzung stimmen die Umlaute.

### Der HTML-Anzeigepfad, Schritt fuer Schritt (alles nachgelesen, nicht vermutet)

1. `CTridentView::LoadMessage()` (`Eudora/TridentView.cpp:1453-1550`) legt mit
   `GetTempFileName` eine **temporaere Datei** an, ruft
   `WriteTempFile(theFile, ...)` (`:1496`) und danach
   `m_pSite->Load((LPTSTR)(LPCTSTR)m_szTmpFile)` (`:1546`).
2. `CSite::Load` (`Eudora/SITE.CPP:397-465`) reicht diesen **Dateipfad** an
   MSHTML weiter — ueber `CreateURLMoniker` + `IPersistMoniker::Load` (`:423-440`),
   ersatzweise `IPersistFile::Load` (`:453-460`).
3. `CTridentView::WriteTempFile` (`Eudora/TridentView.cpp:1281-1440`) schreibt in
   diese Datei: erst das Stylesheet (aus `read.css` oder aus
   `IDS_INI_READMESSAGE_STYLE_SHEET`, `EudoraRes.rc:8129-8130`, Anfang:
   `<HTML><HEAD><STYLE>`), dann Kopfzeilen, dann den Nachrichtenrumpf aus
   `GetMessageForDisplay`.

**In keinem dieser drei Schritte wird ein Zeichensatz angegeben.** Kein BOM,
kein `<meta ... charset=...>`, keine Codepage-Umwandlung. Die Volltextsuche des
Auftrags stimmt und ist damit erklaert: die Suche nach `IPersistStreamInit`
liefert im ganzen Baum **keinen** Treffer, weil MSHTML hier ueber eine Datei
geladen wird. MSHTML muss den Zeichensatz also selbst raten — aus dem Inhalt.

### Woher das Ersatzzeichen kommt

Was auf der Platte steht, ist **Windows-1252**: `TextReader::ReadIt`
(`Eudora/TextReader.cpp:243-250`) uebersetzt jede Zeile mit
`size = ISOTranslate(buf, size, iCharsetIdx)`, sobald `iCharsetIdx > 2` ist —
und `ISOTranslate` (`Eudora/utils.cpp:1240-1283`) wandelt UTF-8 ueber
`MultiByteToWideChar(CP_UTF8, ...)` + `WideCharToMultiByte(1252, ...)` nach
CP1252. Das gilt fuer HTML-Teile genauso wie fuer Text, `bHtml`
(`TextReader.cpp:63`) steuert nur den `<x-html>`-Rahmen, nicht die Uebersetzung.

Der `<meta http-equiv="Content-Type" ... charset=utf-8>` aus der Originalmail
ueberlebt diese Umwandlung dagegen unveraendert: der Tag-Filter in
`GetBodyAsHTML` (`Eudora/msgutils.cpp:1616-1645`) sieht sich `<meta>` **nur auf
`http-equiv=refresh`** an (`:1629`) und laesst jedes andere `<meta>` samt
`charset`-Angabe stehen.

Damit steht in der temporaeren Datei: CP1252-Bytes, dazu die Ansage "utf-8".
MSHTML glaubt der Ansage, findet ein einzelnes Byte `0xFC`, das in UTF-8 nicht
vorkommt, und setzt **ein** U+FFFD dafuer.

Das passt genau zum Bild: **ein** Ersatzzeichen je Umlaut. Waere es umgekehrt —
UTF-8-Bytes als CP1252 gelesen —, stuenden dort **zwei** Zeichen (`Ã¼`). Der
Textpfad hat kein `<meta>` und keinen Rater und zeigt deshalb richtig an (E-1).

### Behebung: zwei Aenderungen, beide eingesetzt

1. **Den Zeichensatz ansagen**, als erste Bytes der temporaeren Datei, vor dem
   Stylesheet, in `CTridentView::WriteTempFile`
   (`Eudora/TridentView.cpp:1334-1351`):

       static const char	szCharsetMeta[] =
           "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1252\">\r\n";
       ...
       theFile.Write( szCharsetMeta, sizeof(szCharsetMeta) - 1 );
       theFile.Write( szStyleSheet, szStyleSheet.GetLength() );

   `windows-1252` ist in **allen** Faellen richtig: bei `iCharsetIdx <= 2`
   (Windows, US-ASCII, Latin-1) sind die Bytes unveraendert Latin-1/CP1252, bei
   `iCharsetIdx > 2` hat `ISOTranslate` nach CP1252 gewandelt. Vor dem
   Stylesheet und nicht in `IDS_INI_READMESSAGE_STYLE_SHEET`, weil eine
   vorhandene `read.css` die Ressource ersetzt (`TridentView.cpp:1300-1322`) —
   in der Ressource stuende die Ansage dann nur manchmal in der Datei.

2. **Die fremde Zeichensatz-Ansage entfernen**, in `GetBodyAsHTML`
   (`Eudora/msgutils.cpp:1625-1639`), damit MSHTML nicht doch der spaeteren
   Angabe der Mail folgt:

       CString		TagContentsLower = TagContents;
       TagContentsLower.MakeLower();
       bool		bIsBadMeta = HasBadAttributeValue(TagContents, "http-equiv", "refresh") ||
                                ( TagContentsLower.Find("charset") >= 0 );

   Ueber die Zeichenkette `charset` statt ueber `http-equiv`, weil der
   HTML5-Kurzschreibweise `<meta charset="utf-8">` das `http-equiv` fehlt und
   `HasBadAttributeValue` sie deshalb nicht sieht. `CString::MakeLower` statt
   `StrStrIA`, damit `msgutils.cpp` keinen neuen Kopf (`<shlwapi.h>`) braucht.

   UNGEPRUEFT ist allein, ob Schritt 1 fuer sich genuegt haette: ob MSHTML die
   erste oder die letzte `charset`-Angabe im Dokument gewinnen laesst, ist nicht
   nachgemessen. Schritt 2 macht die Frage gegenstandslos, deshalb beide.

### Stand und naechster Schritt

Ursache belegt, Anzeigepfad vollstaendig verfolgt, Fundstellen mit Datei:Zeile
oben. Beide Aenderungen sind eingesetzt (byte-erhaltend ueber
`tools/ersetze-bereich.pl`, CR-Zahl vorher/nachher je 18, unveraendert).

**Beide geaenderten Dateien uebersetzen fehlerfrei**, nachgemessen an den
Objektdateien: `Eudora71/Eudora/Build/Debug/msgutils.obj` (08:34:55) und
`TridentView.obj` (08:35:59), beide neuer als die Quellen (08:31:56). Der Bau
des Eudora-Projekts kommt vollstaendig durch die Uebersetzung und bricht erst
beim **Binden** ab, an einer fremden Ursache:

    LINK : fatal error LNK1104: Datei "...\Eudora71\Importers\Lib\Debug\NSImport.lib"
    kann nicht geoeffnet werden.   [Eudora.vcxproj]

`Eudora71/Importers/Lib/Debug/` gibt es in diesem Worktree gar nicht — die drei
Importer-Projekte sind im Solution-Bau vorher an `QCUtils.lib` gescheitert
(siehe naechster Unterabschnitt). Es fehlt also eine Vorstufe, nicht ein
Ergebnis dieser Aenderung.

**Nicht nachgewiesen ist die Wirkung.** Es gibt kein gebundenes `Eudora.exe`
aus diesem Worktree, und ein Lauf von Eudora war nach Auflage ausgeschlossen.
Wer weitermacht:

1. Die Vorstufen bauen, bis `QCUtils.lib` und die drei Importer-Libs stehen,
   dann `Eudora.vcxproj` erneut binden. An den zwei geaenderten Dateien ist
   dafuer nichts zu tun.
2. Gegenprobe ohne Eudora-Start moeglich: nach dem Anzeigen einer
   UTF-8-HTML-Mail liegt die Zwischendatei in `%TEMP%\eud*.htm`
   (`TridentView.cpp:1469-1484`). Darin muss die erste Zeile die
   `windows-1252`-Ansage tragen und im Rumpf darf kein `charset=` mehr stehen.
3. Erst danach das Bildschirmfoto aus E-2 wiederholen.
### Nebenbefund (nicht behoben)

`GetBodyAsHTML` schreibt beim Pruefen der Meta-Tags mit `*(LPTSTR)TagEnd = 0`
in einen Puffer, der ueber `LPCTSTR` hereinkam (`msgutils.cpp:1633`). Das ist
Bestand des Originalcodes und hier nicht angeruehrt worden, faellt aber jedem
auf, der die Stelle liest.


### Der Bau der ganzen Solution: 6 Fehler, keiner davon aus dieser Aenderung

Gemessen im frischen Worktree, `MSBuild Eudora71\Eudora.sln -p:Configuration=Debug
-p:Platform=x86 -m`, 2030 Warnungen, 6 Fehler:

  * `OT501.vcxproj`, dreimal: `NMAKE : fatal error U1073: ".\utility\crypt\Blackbox.cpp"
    konnte nicht erstellt werden`, dasselbe fuer `OTA50D\OTA50D.lib`, und daraus
    folgend `error MSB3073` fuer `NMAKE /f build50.mak ota50d`.
  * `NSImport.vcxproj`, `OLImport.vcxproj`, `OEImport.vcxproj`, je einmal:
    `LINK : fatal error LNK1104: Datei "QCUtils.lib" kann nicht geoeffnet werden`.

Beide Gruppen betreffen **fremde Teilprojekte** und keine der zwei geaenderten
Dateien. Die LNK1104-Gruppe ist eine Reihenfolge- oder Abhaengigkeitsfrage des
Parallelbaus (`-m`): die Importer binden, bevor `QCUtils.lib` fertig ist. Ob es
sich um denselben bekannten Effekt handelt, den README unter "in einem frischen
Klon oder Worktree zuerst die ganze Solution bauen" beschreibt, ist
**UNGEPRUEFT** — ein zweiter Lauf desselben Befehls wuerde das entscheiden.

## E-5 — Das Release startet auf einem Win11-Rechner ohne Visual Studio nicht (31.08.2026, OFFEN)

Gregor hat `Eudora72-1.0.3-release.zip` aus der GitHub-Veröffentlichung auf einem
zweiten Rechner (Windows 11, **kein** Visual Studio) ausgepackt: *„exe aus dem
github release ordner startet auf einem win11 pc gar nicht."*

### Was ausgeschlossen ist

Streng nachgemessen, mit `dumpbin -dependents` über alle 37 Binärdateien des
Pakets — und diesmal **ohne** `SysWOW64` als Fundort zu akzeptieren, weil dort
auf einem Rechner ohne Visual Studio nichts liegt:

| fehlt | gebraucht von | hält den Start auf? |
|---|---|---|
| `MFC42.DLL` | `EuGraph.ocx` | **nein** — erst bei Benutzung geladen |
| `MFC71.DLL` | `EudoraBk`, `ISock`, `Ldap`, drei Plugins | **nein** — dito |
| `MSVCP71.dll` | `Ldap`, `Ph`, drei Plugins | **nein** — dito |
| `oledlg.dll` | `mfc140.dll` | **nein** — Bestandteil von Windows |

Ebenfalls ausgeschlossen: eine Vermischung von Debug und Release. Jede Datei im
Paket wurde einzeln geprüft, keine braucht eine Debug-Laufzeit. Die drei
verteilbaren Laufzeiten liegen bei.

### Mein Fehler bei der vorigen Prüfung

Ich hatte gemeldet, alle Importe lösten auf — dabei habe ich „liegt in
`SysWOW64`" als „vorhanden" gewertet. Auf dieser VM stimmt das, weil Visual
Studio installiert ist; auf Gregors Zielrechner nicht. **Genau der Fehler, den
PRÜFER am Paketprüfer schon nachgewiesen hatte** (PR-2: „prüft die Maschine,
nicht das Paket") — und ich habe ihn in meiner eigenen Prüfung wiederholt.

### Was jetzt zu prüfen ist, in dieser Reihenfolge

1. **Mark of the Web.** Dateien aus einem heruntergeladenen ZIP tragen einen
   Zonenvermerk; Windows kann das Laden von DLLs daraus verweigern — ohne
   Meldung. Gegenprobe im ausgepackten Ordner:

       Get-ChildItem -Recurse | Unblock-File

2. **Wie „gar nicht" genau aussieht.** Kein Fenster? Eine Meldung? Erscheint der
   Prozess kurz im Task-Manager? Davon hängt alles Weitere ab. Ohne diese Angabe
   ist jede Vermutung wertlos.
3. **Die Ereignisanzeige** auf dem Zielrechner, Protokoll *Anwendung*: ein
   Ladefehler steht dort mit dem Namen der fehlenden Datei.
4. **`tools/paket-pruefen.ps1` auf dem ZIELRECHNER laufen lassen** — dort, wo
   kein Visual Studio ist, gibt es die richtige Antwort. Das ist auch der einzige
   belastbare Nachweis für Kriterium 0 (siehe die Berichtigung in `ZIEL.md`).

### Was daraus für Kriterium 0 folgt

**Es bleibt unbelegt, und die Vermutung, es sei erfüllt, ist widerlegt.** Ein
Release-Bau allein genügt nicht; das Paket muss auf einer Maschine ohne
Entwicklungsumgebung nachweislich starten.

## E-6 — Das Release läuft auf Windows 11 ohne Visual Studio — der Kontoassistent stürzt bei *Weiter* ab (31.08.2026, TEILERFOLG)

### Berichtigung zu E-5: es startet doch

Gregor hat das **hier gepackte** ZIP auf dem zweiten Rechner (Windows 11, kein
Visual Studio) ausgepackt und ein Mailverzeichnis hinzugefügt. **Eudora startet.**
Bildschirmfoto zeigt: Hauptfenster im Windows-11-Erscheinungsbild, Menüleiste
vollständig (*File* bis *Help* — ohne *Debug*, wie es im Release-Bau sein soll),
Postfachbaum links mit *In/Out/Junk/Trash/Recent*, Statuszeile, und den
**New Account Wizard**.

Damit ist **Kriterium 0 im Kern erreicht**: das Paket läuft ohne
Nachinstallieren auf einer Maschine ohne Entwicklungsumgebung. Einschränkung:
das Mailverzeichnis musste von Hand dazugelegt werden — der Grund dafür ist
noch nicht geklärt (im Paket liegt eines, siehe „Offene Frage" unten).

Was in E-5 als „startet gar nicht" gemeldet war, betraf offenbar das aus der
GitHub-Veröffentlichung heruntergeladene ZIP, nicht das hier gepackte. Der
Unterschied ist noch nicht gemessen; **UNGEPRÜFT**, ob es am Zonenvermerk
(*Mark of the Web*) lag.

### NEU: Absturz im Kontoassistenten

> *„wenn ich hier auf weiter klicke, stürzt es ab!"*

Der Assistent zeigt die Begrüßungsseite („Welcome to Eudora!"); der Klick auf
**Weiter >** beendet das Programm.

**Das ist ein Release-Bau — und genau davor war gewarnt.** FREIGABE hatte
festgehalten: *„im Release-Bau entfallen die SUPERASSERT-Dialoge und alle
ASSERT/VERIFY"*. Ein Fehler, der im Debug-Bau nur eine Zusicherung ausgelöst
hätte, wird hier zum Absturz. Im Debug-Bau ist der Assistent nie benutzt worden
— Gregor hat sein Konto von Hand über die `Eudora.ini` eingetragen.

**Wo zu suchen ist:** Projekt `Eudora71/AccountWizard`. Die Seitenklassen liegen
in `Eudora71/AccountWizard/PrivateInc` (`WizardAcapPage.h`,
`WizardClientPage.h`, `WizardConfirmpage.h`, `WizardFinishPage.h`,
`WizardImapDirPage.h` und weitere). Der Übergang von der ersten Seite läuft über
`OnWizardNext` der Begrüßungsseite.

**Nächster Schritt:** den **Debug**-Bau nehmen und im Assistenten auf *Weiter*
klicken. Dort meldet sich die Zusicherung mit Datei und Zeile, statt still
abzustürzen — das ist der schnellste Weg zur Fundstelle. Falls es im Debug-Bau
nicht auftritt, ist es ein reiner Release-Effekt (nicht initialisierte Variable
oder ein Codepfad, der nur ohne `ASSERT` erreicht wird), und dann hilft
`tools/stapel-untersuchen.ps1` gegen die Release-EXE mit der `Eudora.pdb`.

### Offene Frage

Warum musste das Mailverzeichnis von Hand dazugelegt werden? Das Paket enthält
`Mailverzeichnis\Eudora.ini` — entweder wurde es beim Auspacken nicht
mitgenommen, oder Eudora sucht es an anderer Stelle, wenn kein Argument
übergeben wird. Zu klären.

### Stand der vier Kriterien

| # | Kriterium | Stand |
|---|---|---|
| 0 | Paket ohne Nachinstallieren | **im Kern erreicht** — läuft auf Win11 ohne VS; Mailverzeichnis noch von Hand |
| 1 | startet, Hauptfenster bedienbar | **erfüllt** |
| 2 | Darstellung korrekt | **fast** — HTML-Umlaute behoben, aber ungeprüft |
| 3 | Mailkonto verbinden und Mail abrufen | **erfüllt** (Debug-Bau) — im Release blockiert der Assistent |

## E-7 — Die Bau-Kennung fehlt im Titel, solange kein Fenster offen ist (31.08.2026, OFFEN)

Gregor auf dem Win11-Rechner: *„und ich sehe hier keine versionsnummer in der
titelzeile"*. Der Titel zeigt nur `Eudora`.

### Es ist kein Bau-, sondern ein Anzeigeproblem — nachgemessen

| Prüfung | Ergebnis |
|---|---|
| Kennung in der Release-EXE? | **ja**, bei Versatz 2.147.104: `Eudora 7.2.0.3 / Paket 1.0.3+b1f20e0` |
| Vorlagentext `unbekannt` in der EXE? | **nein** — die echte Kennung wurde erzeugt, nicht die Vorlage |
| Überschreibung im Baum? | **ja**, `mainfrm.cpp:9686` |

### Die Ursache

`CMainFrame::OnUpdateFrameTitle` läuft **nur, wenn MFC den Rahmentitel
auffrischt** — also wenn sich ein MDI-Kindfenster ändert. Beim Start ohne
geöffnetes Postfach, und während der modale Kontoassistent läuft, ist das nie
der Fall. Der Titel steht dann noch so, wie er beim Erzeugen des Fensters
gesetzt wurde, und die Ergänzung war nie dran.

Auf dieser VM fiel es nicht auf, weil dort immer ein Postfach geöffnet war —
der Titel lautete `Eudora [... ] - [In]`. Genau der Zustandsunterschied, der
heute schon bei den Werkzeugleisten-Knöpfen zu einer falschen Meldung geführt
hat (E-2).

### Behebung

Die Kennung muss **beim Setzen des Titels** dazukommen, nicht erst bei seiner
Auffrischung. Zwei Wege:

1. In `CMainFrame::OnCreate` bzw. direkt nach
   `FinishInitAndShowWindow` (`eudora.cpp:1510`) einmal `OnUpdateFrameTitle(TRUE)`
   aufrufen. Billig, nutzt den vorhandenen Code.
2. Oder `m_strTitle` des Rahmens gleich mit der Kennung belegen — dann trägt
   MFC sie bei jeder Auffrischung von selbst mit, und die Überschreibung könnte
   ganz entfallen. Sauberer, aber `m_strTitle` wird an mehreren Stellen
   benutzt; **UNGEPRÜFT**, ob das Nebenwirkungen hat.

Weg 1 ist der kleinere Eingriff und wäre der erste Versuch.

### Warum das mehr als Kosmetik ist

Die Kennung ist dafür gebaut, ein Bildschirmfoto einem Bau zuzuordnen — und
genau in dem Zustand, in dem Gregor jetzt Fehler findet (frischer Start,
Assistent offen, noch kein Postfach), fehlt sie. Damit versagt sie an der
Stelle, für die sie da ist.

## E-8 — Berichtigung zu E-6: der Win11-Lauf war der DEBUG-Bau (31.08.2026)

Gregor: *„ich habe das verwendet: `C:\Users\Gregor\Eudora72-1.0.3`"*

Nachgemessen mit `dumpbin -dependents`:

| Verzeichnis | Bauart | Größe | Laufzeiten im Ordner |
|---|---|---|---|
| `Eudora72-1.0.3` | **DEBUG** | 10.208.256 B | `mfc140d`, `msvcp140d`, `vcruntime140d`, `ucrtbased`, `concrt140d`, `mfc140deu` |
| `Eudora72-1.0.3-release` | RELEASE | 2.933.248 B | `mfc140`, `msvcp140`, `vcruntime140` |

### Zwei Folgerungen, beide unangenehm

**1. Der Absturz im Kontoassistenten (E-6) ist KEIN Release-Effekt.** Er
passiert im Debug-Bau. Meine Erklärung in E-6 — „im Release entfallen alle
ASSERT, deshalb Absturz statt Zusicherung" — **trägt nicht**. Es ist entweder
ein Fehler unterhalb dessen, was `ASSERT` abfängt (Zugriff über einen ungültigen
Zeiger), oder es kam eine Zusicherung, die als Absturz wahrgenommen wurde.

Was das für die Suche bedeutet: der Debug-Bau bringt hier **keinen** zusätzlichen
Hinweis, weil er schon der Debug-Bau war. Der Weg führt über
`tools/stapel-untersuchen.ps1` gegen genau dieses Verzeichnis, mit der
`Eudora.pdb` daneben.

**2. Kriterium 0 ist NICHT erreicht.** Das Verzeichnis läuft auf dem
Win11-Rechner nur, weil die sechs **nicht verteilbaren** Debug-Laufzeiten
physisch darin liegen — ich hatte sie dort mit `laufzeit-holen.ps1` hinkopiert.
Genau das darf nicht ausgeliefert werden (Microsoft nimmt die Debug-Fassungen
ausdrücklich vom Weiterverteilen aus, siehe `ZIEL.md`, Kriterium 0).

Meine Meldung in E-6, Kriterium 0 sei „im Kern erreicht", ist damit **falsch**
und hiermit zurückgezogen.

### Was noch offen ist

Das **Release**-Paket (`Eudora72-1.0.3-release`, 2,9 MB) ist auf dem
Win11-Rechner **nicht ausprobiert** worden. Ob es dort startet, ist weiter
ungeprüft — und damit auch, was E-5 ursprünglich meldete.

Ebenfalls unverändert offen: warum das Mailverzeichnis von Hand dazugelegt
werden musste, obwohl beide Pakete eines enthalten.

### Die Lehre, zum dritten Mal an einem Tag

Ich habe eine Aussage über einen Zustand gemacht, ohne den Zustand zu prüfen —
und zwar genau die Frage, um die es ging: **welches Paket lief da eigentlich?**
Dieselbe Fehlerklasse wie bei den Werkzeugleisten-Knöpfen (E-2) und bei
„SysWOW64 gilt als vorhanden" (E-5). Siehe `Arbeitsweise/erst-pruefen-dann-anweisen.md`.

## E-9 — Absturz im Kontoassistenten bei *Weiter*: die Kette bis zur Importsuche (31.08.2026, OFFEN)

Gregor, in **beiden** Bauarten reproduziert (Debug- und Release-Paket 1.0.3):
*„beim klicken auf weiter stürzt es ab!"*

Damit ist es **kein Release-Effekt** — die Erklärung aus E-6 ist endgültig
widerlegt.

### Die Kette, nachgelesen

1. Die Begrüßungsseite `CWizardWelcomePage`
   (`AccountWizard/Src/WizardWelcomePage.cpp`) hat **kein** `OnWizardNext`. Der
   Klick auf *Weiter* führt also unmittelbar zur nächsten Seite.
2. Nächste Seite ist `CWizardClientPage`, angehängt in
   `WizardPropSheet.cpp:342-343` direkt nach der Begrüßungsseite.
3. Deren `OnSetActive` (`WizardClientPage.cpp`) tut als erstes dies:

   ```cpp
   if (!m_pParent->m_pImporter)
       m_pParent->m_pImporter = DEBUG_NEW CImportMail;

   if (m_pParent->m_pImporter->InitPlugins())
       m_pParent->m_pImporter->InitProviders();

   CImportMail *pIM = m_pParent->m_pImporter;
   ASSERT(pIM);
   if (!pIM->m_newhead)
   ```

4. `CImportMail::InitPlugins` (`Eudora/MAPIImport.cpp`) reicht direkt an
   `InitPluginList` weiter. Dort:

   ```cpp
   m_psDllStruct = DEBUG_NEW ImportDllStruct[iMatchingFiles];
   m_iDllStructSize = iMatchingFiles;
   ...
   m_psDllStruct[iMatchingFiles].szDllPath = finder.GetFilePath();
   InitDllStruct(iMatchingFiles);
   ```

### Zwei Auffälligkeiten in `InitPluginList`

**a) Die Anzahl wird zweimal ermittelt, das Feld nur einmal bemessen.** Erst
zählt eine Suche die Treffer, dann wird das Feld in dieser Größe angelegt, dann
läuft eine **zweite** Suche und schreibt hinein. Liefern die beiden Suchen
verschiedene Anzahlen, wird über das Feldende hinaus geschrieben.

**b) Der Rückgabewert von `DEBUG_NEW` wird nicht geprüft**, und `InitDllStruct`
wird für jeden Treffer gerufen — auch für einen, dessen DLL sich **nicht laden
lässt**. Und genau das ist belegt: die Ablaufverfolgung vom 30.08. zeigt

    LoadLibrary failed (...\Plugins\SMIME.dll): err = 126
    LoadLibrary failed (...\Plugins\SpamHeaders.dll): err = 126
    LoadLibrary failed (...\Plugins\SpamWatch.dll): err = 126

Fehler 126 ist „Modul nicht gefunden" — diese drei Plugins brauchen `MFC71.DLL`
und `MSVCP71.dll`, die dem Paket fehlen und nicht nachbaubar sind (B-2). Ob
`m_szEudoraImportSearch` diese drei überhaupt trifft, ist **UNGEPRÜFT** — das
ist die erste Frage, die morgen zu klären ist.

### Wie man es entscheidet, ohne zu raten

1. **`tools/stapel-untersuchen.ps1`** gegen das Paket, `Eudora.pdb` daneben.
   Dann *Weiter* klicken. Der Debugger fängt die Zugriffsverletzung und nennt
   die Zeile. Das ist der direkte Weg und dauert Minuten.
2. **Gegenprobe ohne Debugger:** den Ordner `Plugins` im Paket umbenennen und
   den Assistenten erneut versuchen. Stürzt es dann **nicht** ab, ist die
   Plugin-Suche die Ursache — und der Verdacht auf `InitDllStruct` bestätigt.
   Das kann Gregor selbst in zehn Sekunden machen.
3. Erst danach `m_szEudoraImportSearch` und `InitDllStruct` genau lesen.

### Umgehung, die nachweislich funktioniert

Das Konto **über die `Eudora.ini` von Hand** eintragen, wie in
`ABRUF-PRUEFEN.md` beschrieben. Auf diesem Weg hat Gregor am 31.08. um 08:09
erfolgreich Mail abgerufen (E-1, E-3) — der Assistent ist für Kriterium 3 nicht
nötig.

### E-9, Nachtrag: die Plugins sind es NICHT (31.08.2026, gemessen)

Gegenprobe von Gregor: `Plugins` in `Plugins_aus` umbenannt — **der Absturz
bleibt.** Und Eudora legt einen neuen, leeren `Plugins`-Ordner an.

Damit ist die Plugin-Suche als Ursache **ausgeschlossen**, und meine
Berichtigung im Commit `6e5da17` bestätigt: gesucht wird
`ExecutableDir` + `*.eif` (`MAPIImport.cpp:954-955`), also die drei Importer im
**Programmverzeichnis**. Der `Plugins`-Ordner enthält etwas anderes
(`SMIME.dll`, `SpamHeaders.dll`, `SpamWatch.dll`) und wird von `InitPluginList`
gar nicht angefasst. Dass Eudora ihn neu anlegt, ist normales Verhalten beim
Start und hat mit dem Assistenten nichts zu tun.

Die Härtung von `InitPluginList` (`6e5da17`) bleibt richtig — sie behebt zwei
echte Strukturfehler —, aber sie behebt **diesen** Absturz nicht.

### Wo es jetzt noch liegen kann

In `CWizardClientPage` selbst. Zwei Stellen fallen beim Lesen auf:

**a) `OnSetActive`, nach der Plugin-Suche:**

```cpp
if (m_pParent->m_pImporter->InitPlugins())
    m_pParent->m_pImporter->InitProviders();

CImportMail *pIM = m_pParent->m_pImporter;
ASSERT(pIM);
if (!pIM->m_newhead)
```

`InitProviders` wird **nur** gerufen, wenn `InitPlugins` `true` liefert. Findet
die Suche keine `*.eif`, liefert sie `false` — und danach wird `m_newhead`
gelesen, das erst `InitProviders` belegt. **UNGEPRÜFT**, ob der Konstruktor von
`CImportMail` `m_newhead` auf NULL setzt. Tut er es nicht, wird hier ein
unbestimmter Zeiger geprüft, und `pIM->m_newhead` weiter unten dereferenziert.

Das passt zum Bild: im Paket liegen zwar drei `.eif`, aber ob sie gefunden
werden, hängt an `ExecutableDir` — und das wird aus dem Modulpfad gebildet.

**b) `OnInitDialog`** ruft `OnRadioNew()`, bevor `OnSetActive` gelaufen ist —
also bevor `m_pImporter` überhaupt angelegt wurde. Was `OnRadioNew` anfasst,
ist noch nicht nachgelesen.

### Der nächste Schritt, der es entscheidet

`tools/stapel-untersuchen.ps1` gegen das Release-Paket, `Eudora.pdb` daneben,
dann *Weiter* per `BM_CLICK` an den Knopf senden — so wie es bei den
SUPERASSERT-Dialogen schon gemacht wurde. Der Debugger fängt die
Zugriffsverletzung und nennt Datei und Zeile. Ein Lauf von etwa einer Minute.

## E-11 — Der Absturz liegt nicht im Assistenten: `ReleaseBuffer` ohne `GetBuffer` (31.08.2026, URSACHE GEFUNDEN)

### Der Beleg: `eudora.log`

Gregor hat die Protokolldatei geschickt. **Beide Sitzungen enden an derselben
Stelle**, danach steht nichts mehr:

    MAIN     8: 0.01 Dialog: "Eudora is not currently the default mail program.\n"
    MAIN     8: 0.01 Dialog: "Would you like it to be the default mail program?"

Damit ist der Kontoassistent **entlastet**. Der Absturz passiert in der
Registrierung als Standard-Mailprogramm — der Klick auf *Weiter* schließt nur
den Assistenten, und danach läuft dieser Weg.

Die Meldung ist `IDS_WARN_DEFAULT_MAILTO` (`EudoraRes.rc:7909`), benutzt genau
einmal: `eudora.cpp:3331`, in `CEudoraApp::RegisterURLSchemes` (ab `:3274`,
gerufen aus `InitInstance` bei `:1591`).

### Die Fundstelle, drei Zeilen nach dem Dialog

`eudora.cpp:3369-3371`:

```cpp
if (!AddToRegistry(HKEY_CLASSES_ROOT, RegMailto, NULL, cmd))
    ::ErrorDialog(IDS_REG_MAILTO_ERR);
int i = RegMailto.Find('\');
if (i >= 0)
    RegMailto.ReleaseBuffer(i);          // <- hier
```

`RegMailto` ist ein **`CRString`** (`eudora.cpp:3287`), also ein aus einer
Ressource geladener String.

**`CString::ReleaseBuffer` ohne vorangehendes `GetBuffer` ist unzulässig.** Unter
VC6 war das gutmütig: `CString` hielt einen eigenen Puffer, und
`ReleaseBuffer(n)` setzte einfach die Länge. Bei **MFC 14** ist `CString` ein
`CStringT` mit **Referenzzählung**: `ReleaseBuffer` setzt voraus, dass der Puffer
exklusiv gesperrt ist, und schreibt in die gemeinsame Verwaltungsstruktur. Bei
einem geteilten Puffer zerstört das fremde Daten.

Das ist derselbe Klassiker wie die anderen VC6-Altlasten dieser Portierung
(`std::auto_ptr`, Iteratoren als Zeiger, Standardargumente) — nur schlägt er
erst zur Laufzeit zu.

### Der Umfang: 142 Vorkommen im Baum

`grep -rn "ReleaseBuffer(" --include=*.cpp Eudora71/` findet **142 Stellen**.
Nicht alle sind falsch — richtig ist das Muster
`p = s.GetBuffer(n); ... s.ReleaseBuffer();`. Falsch sind die Stellen **ohne**
vorangehendes `GetBuffer` auf derselben Variablen.

Auffällig auf den ersten Blick, weil sie eine **Länge** übergeben und damit
kürzen wollen — also die gefährliche Form:

- `eudora.cpp:3371` `RegMailto.ReleaseBuffer(i)` — **dieser Absturz**
- `ConConProfile.cpp:198` `m_szElementData.ReleaseBuffer(nNewDataLength)`
- `QCSharewareManager.cpp` (in `Load`) `RetailVersion.ReleaseBuffer(LastDot + 1)`
  — läuft bei **jedem Start** durch den Box-Build-Zweig

### Die Behebung

Statt `s.ReleaseBuffer(i)` gehört dort ein sauberes Kürzen:

```cpp
RegMailto = RegMailto.Left(i);
```

Das ist in allen Fällen richtig, ändert die Bedeutung nicht und kommt ohne
Puffersperre aus. **Nicht mehr in dieser Sitzung geändert** — die Zeit reichte
nicht, um es zu übersetzen und zu prüfen, und 142 Stellen wollen einzeln
angesehen werden.

### Nächster Schritt

1. `eudora.cpp:3371` auf `Left(i)` umstellen, bauen, Gregor probieren lassen.
   Ein Einzeiler, und er trifft genau den belegten Absturz.
2. Danach die 142 Vorkommen durchgehen: jedes ohne vorangehendes `GetBuffer` auf
   derselben Variablen ist ein Kandidat. Ein Werkzeug dafür wäre lohnend — das
   ist eine **Fehlerklasse**, kein Einzelfall.
3. `QCSharewareManager.cpp` zuerst, weil dieser Weg bei jedem Start läuft.

### Nebenbefund aus dem Protokoll

    Leeway 10, Out: MBX 1788158654, TOC 0
    Out .mbx size: MBX 0, TOC 1

Für eine **leere** `Out.mbx` (die Zeilen darüber melden `Size: 0`) wird eine
Dateigröße von **1.788.158.654** gemeldet — 1,7 GB. Ein nicht initialisierter
Wert. Zwei Zeilen später steht korrekt `MBX 0`. Eigener Befund, nicht
untersucht.
