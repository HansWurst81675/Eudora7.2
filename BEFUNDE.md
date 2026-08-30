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
