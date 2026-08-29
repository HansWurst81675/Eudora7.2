# Befunde aus dem Altbestand

Vier Mängel, die ein früherer Prüf-Agent im geerbten Eudora-7.1-Code gefunden und
am Quelltext belegt hat. Sie wurden zunächst zurückgestellt, weil Vorrang hatte,
überhaupt erst ein lauffähiges `Eudora.exe` herzustellen.

Diese Datei hält sie dauerhaft fest. Bis hierher existierten die Befunde nur im
Gesprächsverlauf und wären beim nächsten Abschalten verloren gewesen.

Alle vier Befunde stammen aus dem Originalcode und bestanden bereits unter VC6.
Keiner ist durch die Portierung auf Visual Studio 2022 entstanden.

Zeilenangaben beziehen sich auf den Stand **vor** der jeweiligen Behebung.

| Nr. | Kurzfassung | Datei | Status |
|-----|-------------|-------|--------|
| 1 | Toter Schreibzugriff in einen fremden Datenslot | `Eudora71/QCSSL/src/qccertificate.cpp:157` | behoben |
| 2 | Suche ignoriert die Groß-/Kleinschreibung nicht | `Eudora71/Eudora/headervw.cpp:2107, 2191, 2266` | behoben |
| 3 | Schreibzugriff auf einen fremden Prozesspuffer | `Eudora71/Eudora/mapicmc.cpp:174, 176` | offen, in Arbeit |
| 4 | Nicht vertrauenswürdige Zertifikate werden angenommen | `Eudora71/QCSSL/src/qccertificate.cpp:110-112` | **vorbereitet, nicht angewandt** |

---

## Befund 1 — Toter Schreibzugriff in einen fremden Datenslot

**Datei:** `Eudora71/QCSSL/src/qccertificate.cpp`, Zeile 157
**Funktion:** `QCCertificateUtils::CertificateCallback()`

**Ursache**

```c
X509_STORE_CTX_set_ex_data(pX509StoreCtx, 0, (void*)lErrors);
```

Index 0 des `X509_STORE_CTX` ist nicht frei. OpenSSL vergibt ihn selbst: in
`include/openssl/x509_vfy.h` ist `X509_STORE_CTX_set_app_data(ctx, data)` als
`X509_STORE_CTX_set_ex_data(ctx, 0, data)` definiert, und libssl legt dort während
der Zertifikatsprüfung den `SSL`-Zeiger ab, den `SSL_get_ex_data_X509_STORE_CTX_idx()`
zurückgibt. Der Aufruf überschreibt also fremde Daten.

**Nachgeprüft**

Im gesamten Projektcode (ohne den mitgelieferten OpenSSL-Baum) gibt es genau
einen Aufruf von `X509_STORE_CTX_set_ex_data` — den obigen — und **keinen einzigen**
Aufruf von `X509_STORE_CTX_get_ex_data`. Der geschriebene Wert wird nirgends
zurückgelesen.

**Folge**

Der Schreibzugriff hat keinen Nutzen und beschädigt potenziell den Zustand, den
libssl selbst im Kontext führt.

**Behebung**

Der Aufruf ist entfernt; ersetzt wurde er nur durch einen Kommentar, der an Ort
und Stelle festhält, warum dort nichts mehr steht. Der Kommentar hält zugleich die
Zeilenzahl konstant, sodass `tools/pruefe-bytes.pl` die Änderung ohne `--no-verify`
durchlässt. QCSSL baut unverändert durch (`Release|x86`), keine neuen Warnungen.

**Rest, bewusst stehengelassen**

Die lokale Variable `lErrors` wird dadurch zwar noch gesetzt (Zeilen 35, 71, 79),
aber nirgends mehr gelesen. Sie wurde **nicht** mitentfernt: das lag außerhalb des
erteilten Auftrags, und ein späteres, sauberes Durchreichen des Fehlercodes an
`pInfo->m_Outcome` hat damit noch einen Anknüpfungspunkt. Der Compiler warnt nicht,
weil die Variable durch die Zuweisungen als referenziert gilt.

---

## Befund 2 — Suche ignoriert die Groß-/Kleinschreibung nicht

**Datei:** `Eudora71/Eudora/headervw.cpp`
**Funktionen:** `CHeaderView::DoFindFirst()` (Zeile 2107) und
`CHeaderView::DoFindNext()` (Zeilen 2191 und 2266) — dasselbe Muster an drei Stellen.

**Ursache**

```cpp
const char* p_msgtext = msg_text;   // Zeiger auf den JETZIGEN Puffer

if (! bMatchCase)
{
    msg_text.MakeLower();           // legt den Puffer ggf. NEU an
    search_str.MakeLower();
}

char* p_match = const_cast<char *>(strstr(p_msgtext, search_str));
```

Der Textzeiger wird geholt, **bevor** `MakeLower()` läuft. `CString::MakeLower()`
ruft intern `GetBuffer()` auf; ist der Puffer geteilt oder muss er umkopiert werden,
zeigt `p_msgtext` danach auf den alten, noch nicht kleingeschriebenen Inhalt.

**Folge**

Zwei Fehler zugleich:

1. Die Suche arbeitet groß-/kleinschreibungsabhängig, obwohl der Anwender das
   Gegenteil eingestellt hat — gesucht wird der kleingeschriebene Suchbegriff im
   nicht kleingeschriebenen Text.
2. An den Stellen 2191 und 2266 wird der Treffer anschließend mit
   `startIndex = p_match - msg_text;` verrechnet. `p_match` stammt dann aus dem
   alten Puffer, `msg_text` liefert den neuen — eine Zeigerdifferenz über zwei
   verschiedene Speicherblöcke hinweg. Der daraus berechnete Index ist
   bedeutungslos und steuert danach `SetSel()`.

**Behebung**

An allen drei Stellen wird der Zeiger erst **nach** dem `MakeLower()`-Block geholt.
Bei der Stelle in `DoFindNext()` ab Zeile 2188, wo `p_msgtext` zwischendurch für
`strlen()` und den Versatz `dummy_sel_y` gebraucht wird, wurde stattdessen der
`MakeLower()`-Block nach vorne gezogen — wirkungsgleich, da `MakeLower()` die Länge
nicht ändert.

Die Änderung ist eine reine Umstellung ganzer Zeilen: keine Zeile kommt hinzu, keine
fällt weg, keine wird inhaltlich verändert. Damit bleiben Zeilenenden und Kodierung
zwangsläufig unangetastet (CR=18, LF=3762 vor und nach der Änderung — die Datei hat
gemischte Zeilenenden, CRLF nur im Kopf, Zeilen 3-20).

**Nicht gebaut**

Ein Bau des Eudora-Projekts wurde bewusst unterlassen: ein paralleler Agent hatte zu
diesem Zeitpunkt `Eudora71/Eudora/Eudora.vcxproj` und `EudoraExe.rc` mit eigenen
Änderungen im Index. Ein Bau hätte dessen Stand geprüft, nicht diesen, und in
gemeinsam genutzte Ausgabeverzeichnisse geschrieben. Geprüft wurde stattdessen am
Quelltext: die verschobenen Blöcke sind in sich geschlossen, `p_msgtext` wird an
keiner Stelle vor seiner Deklaration benutzt, und die Klammerbilanz ist durch die
reine Permutation unverändert.

---

## Befund 3 — Schreibzugriff auf einen fremden Prozesspuffer

**Datei:** `Eudora71/Eudora/mapicmc.cpp`, Zeilen 174 und 176
**Funktion:** `ProcessMAPIData()`

**Ursache**

```cpp
char* pszNewline = const_cast<char *>(strchr(pszData, '\n'));
if (pszNewline)
{
    *pszNewline = '\0';     // temporäre NULL-Terminierung
    current_line = pszData;
    *pszNewline = '\n';     // Rücknahme
    pszData = pszNewline + 1;
}
```

`pszData` ist als `const char*` deklariert. Der einzige Aufrufer, der von außen
gespeiste Daten liefert, ist `HandleMAPIMessage()` in Zeile 409:

```cpp
ProcessMAPIData((const char *) pcds->lpData, ...)
```

`pcds` ist die `COPYDATASTRUCT` einer `WM_COPYDATA`-Nachricht, `lpData` zeigt also in
den Speicher eines **fremden Prozesses**. Microsoft schreibt für diesen Speicher
ausdrücklich vor, ihn als schreibgeschützt zu behandeln. Der `const_cast` hebelt
genau die Zusicherung aus, die die Signatur gibt.

**Folge**

Zugriffsverletzung möglich, sobald der sendende Prozess den Puffer in
schreibgeschütztem Speicher ablegt. Der Fehler bestand schon unter VC6 und ist
nicht durch die Portierung entstanden.

**Geplante Behebung**

Die Zeile wird ohne jeden Schreibzugriff aus dem fremden Puffer herauskopiert:

```cpp
const char* pszNewline = strchr(pszData, '\n');
if (pszNewline)
{
    current_line = CString(pszData, (int)(pszNewline - pszData));
    pszData = pszNewline + 1;
}
```

Ergebnisgleich (`CString(ptr, len)` kopiert genau die Zeichen bis vor das
Zeilenende), und der `const_cast` entfällt ersatzlos. Kopiert wird jeweils nur die
aktuelle Zeile, nicht der ganze Puffer.

---

## Befund 4 — Nicht vertrauenswürdige Zertifikate werden angenommen

**Datei:** `Eudora71/QCSSL/src/qccertificate.cpp`, Zeilen 110-112
**Status: NICHT behoben — als Patch bereitgelegt**

**Ursache**

```c
case X509_V_ERR_CERT_UNTRUSTED:                     /* 27 */
case X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE:    /* 21 */
    iOK = 1;
    break;
```

Beide Prüffehler werden nicht nur ignoriert, sondern kehren das Ergebnis aktiv ins
Positive: `iOK = 1` ist der Rückgabewert des Verifikations-Callbacks und sagt
OpenSSL „Zertifikat in Ordnung". Anders als in allen übrigen `case`-Zweigen wird
weder ein Fehlercode in `pInfo->m_Outcome` gesetzt noch eine Warnung angehängt —
der Anwender erfährt nichts.

Fehler 27 (`X509_V_ERR_CERT_UNTRUSTED`) stammt aus `check_trust()` und ist im
normalen Kettenaufbau erreichbar, nicht nur in Randfällen.

**Folge**

Eudora nimmt Zertifikate an, deren Vertrauenskette es nicht verifizieren konnte.

**Warum hier nichts geändert wurde**

Die Behebung ist sachlich richtig, würde aber dazu führen, dass Eudora Zertifikate
ablehnt, die es heute annimmt. Der Auftraggeber ruft mit diesem Build produktiv
Mail ab; ob er diese Verschärfung will, ist seine Entscheidung und nicht die des
Agenten.

**Wo der Patch liegt**

```
tools/patches/zertifikatspruefung-verschaerfen.patch
tools/patches/zertifikatspruefung-verschaerfen.md    (Beschreibung, Anwendung, Rücknahme)
```

Anwenden mit einem Befehl:

```
git apply tools/patches/zertifikatspruefung-verschaerfen.patch
```

Zurückdrehen:

```
git apply -R tools/patches/zertifikatspruefung-verschaerfen.patch
```
