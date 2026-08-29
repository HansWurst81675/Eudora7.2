---
name: zurueckgestellte-befunde
description: "Gefundene, belegte Maengel, die Gregor bewusst spaeter angehen will - nicht von selbst anfassen"
metadata:
  type: project
---

Diese Befunde sind belegt und dokumentiert, aber auf Gregors Wunsch **zurueckgestellt**.
Nicht von selbst aufgreifen. Erst wieder anfassen, wenn er es aufruft - seine Begruendung
am 28.08.2026: "das koennen wir spaeter angehen, wenn alles soweit laeuft." Vorrang hat
ein startendes Eudora.exe.

## 1. Wurzelzertifikatsspeicher ist von 2004

QCSSL prueft Serverzertifikate ausschliesslich gegen die Datei `rootcerts.p7b` im
Eudora- oder Programmverzeichnis (`QCSSLContext.cpp:53`, geladen in
`SetupCertificates()`) - **nicht** gegen den Windows-Zertifikatspeicher.

Nachgemessen an `InstallersForEudora/Eudora7.1/Data/win32/rootcerts.p7b` mit
`certutil -dump` (deutsche Feldnamen "Nicht vor"/"Nicht nach"):
30 Zertifikate, neuestes Ausstellungsdatum 04.03.2004, davon **17 im August 2026
abgelaufen**, 13 noch gueltig.

Folge: Releases/1.0 ist auf einer Installation ohne HermesSSL unvollstaendig - ein
Zertifikatsfehler (`IDS_CERTERR_UNKNOWNROOT`) ist zu erwarten, obwohl der Handshake
funktioniert. Gregors eigene Installation hat HermesSSL 7.8 gamma samt aktuellem
Speicher, deshalb lief sein Test durch.

Wiedereinstieg: aktuelles CA-Bundle holen, nach PKCS#7 wandeln, dem Release beilegen.

## 2. Zwei Schwaechen der Zertifikatspruefung (Altbestand)

Gefunden bei der Pruefung der QCSSL-Portierung. Beide stammen aus Qualcomms
Originalcode, nicht aus der Umstellung auf OpenSSL 3.x - die ist geprueft und
entlastet, die Pruefung greift grundsaetzlich.

- **`qccertificate.cpp:110-112`** setzt bei `X509_V_ERR_CERT_UNTRUSTED` (27) und
  `X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE` (21) `iOK = 1`, akzeptiert das
  Zertifikat also. Fehler 27 aus `check_trust()` ist erreichbar. Empfehlung: beide
  `case` streichen.
- **`qccertificate.cpp:157`** schreibt per `X509_STORE_CTX_set_ex_data(ctx, 0, ...)`
  in Index 0 des STORE_CTX - genau den Slot, in dem libssl den `SSL`-Zeiger fuehrt.
  Der Wert wird nirgends zurueckgelesen: toter Schreibzugriff auf fremde Daten.

**Warum zurueckgestellt:** Punkt 1 zu beheben heisst, dass Eudora Zertifikate ablehnt,
die es heute annimmt. Das ist richtiger, koennte aber Verbindungen brechen, die bei
Gregor heute funktionieren. Deshalb erst, wenn der Rest laeuft.

Dazu zwei weitere Altbestaende, dokumentiert in `PORTIERUNG.md`: der Namensabgleich
ist rein beratend und prueft nur den CN (keine SAN), und es wird kein SNI gesetzt.

## 3. Suche ignoriert die Gross-/Kleinschreibung nicht

`headervw.cpp:2107` holt den Textzeiger aus `msg_text`, **bevor** Zeile 2111
`msg_text.MakeLower()` aufruft. Legt MakeLower den CString-Puffer neu an, sucht der
`strstr` in Zeile 2118 im alten Puffer - die Suche arbeitet dann
gross-/kleinschreibungsabhaengig, obwohl der Anwender das Gegenteil eingestellt hat.
Dasselbe Muster zweimal in `DoFindNext` (2209, 2277).

Das ist ein sichtbarer Anwenderfehler und unabhaengig von der Portierung.

## 4. Schreibzugriff auf einen fremden Prozesspuffer

`mapicmc.cpp:171` schreibt durch einen Zeiger, der aus `WM_COPYDATA`
(`pcds->lpData`) stammt - also aus dem Speicher eines fremden Prozesses. Laut
Microsoft ist der als schreibgeschuetzt zu behandeln; ein Schreibzugriff kann eine
Zugriffsverletzung ausloesen. Bestand schon unter VC6 so.

Siehe auch [[dummy-statt-weglassen]] und [[pruefen-statt-vermuten]].
