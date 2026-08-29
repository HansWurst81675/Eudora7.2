# Patch: Zertifikatsprüfung verschärfen

**Datei:** `zertifikatspruefung-verschaerfen.patch`
**Betrifft:** `Eudora71/QCSSL/src/qccertificate.cpp`, Funktion
`QCCertificateUtils::CertificateCallback()`
**Stand:** nicht angewandt — bewusst bereitgelegt

Dieser Patch liegt bereit, ist aber **absichtlich nicht eingespielt**. Er ändert das
Verhalten beim Mailabruf, und diese Entscheidung gehört dem Betreiber, nicht dem
Werkzeug.

---

## Was heute passiert

Der Verifikations-Callback behandelt zwei OpenSSL-Prüffehler als Erfolg:

```c
case X509_V_ERR_CERT_UNTRUSTED:                     /* 27 */
case X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE:    /* 21 */
    iOK = 1;
    break;
```

`iOK` ist der Rückgabewert des Callbacks. `iOK = 1` sagt OpenSSL ausdrücklich
„Zertifikat in Ordnung" — der Fehler wird also nicht bloß übergangen, sondern ins
Gegenteil verkehrt. Anders als in allen benachbarten `case`-Zweigen wird zusätzlich
weder ein Fehlercode in `pInfo->m_Outcome` gesetzt noch eine Warnung angehängt. Der
Anwender bekommt nichts zu sehen.

Fehler 27 stammt aus `check_trust()` und tritt im gewöhnlichen Kettenaufbau auf,
nicht nur in Randfällen.

**Folge:** Eudora nimmt Zertifikate an, deren Vertrauenskette es nicht verifizieren
konnte.

## Was der Patch tut

Er entfernt den Sonderzweig und hängt die beiden Fehlercodes stattdessen an den
bereits vorhandenen, korrekt ausgeführten Zweig für
`X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT_LOCALLY`:

```c
case X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT_LOCALLY:
case X509_V_ERR_CERT_UNTRUSTED:
case X509_V_ERR_UNABLE_TO_VERIFY_LEAF_SIGNATURE:
    if (pInfo->m_Outcome.m_ErrorCode == 0)
    {
        pInfo->m_Outcome.m_ErrorCode = IDS_CERTERR_CHAINNOTTRUSTED;
    }
    pInfo->m_Outcome.AddErrors(IDS_CERTERR_CHAINNOTTRUSTED);
    if (bInStore) pInfo->m_Outcome.AddErrors(IDS_CERTWARN_IGNOREBCOSTRUSTED);
    break;
```

Es wird also kein neuer Code erfunden, sondern die vorhandene, richtige Behandlung
mitbenutzt. Der Patch ist 24 Zeilen groß und berührt nur diese eine Datei.

## Was danach anders ist

* `iOK` bleibt bei diesen beiden Fehlern **0**. Der Callback meldet OpenSSL damit
  ein fehlgeschlagenes Zertifikat, und die Verbindung wird abgelehnt.
* Der Anwender bekommt die Meldung `IDS_CERTERR_CHAINNOTTRUSTED`
  („Kette nicht vertrauenswürdig") zu sehen, statt wie bisher gar nichts.
* **Eudora wird Zertifikate ablehnen, die es heute klaglos annimmt.** Genau das ist
  der Zweck — und genau deshalb ist der Patch nicht vorab eingespielt.

### Der Ausweg für den Anwender bleibt erhalten

Wichtig: Der `switch` wird nur erreicht, wenn das Zertifikat **nicht** bereits im
vom Anwender bestätigten Speicher liegt. Der Block davor prüft das zuerst:

```c
if (iOK == 0)
{
    bInStore = (CertIsInStore(...) == 1);
    if (bInStore) { iOK = 1; lErrors = 0; }
}
if (iOK == 0)  /* erst jetzt der switch */
```

Wer ein bestimmtes Zertifikat trotzdem akzeptieren will, kann es also weiterhin über
den Zertifikatsspeicher freigeben. Der Patch nimmt die pauschale Annahme weg, nicht
die Möglichkeit der bewussten Einzelfreigabe.

## Anwenden

```
git apply tools/patches/zertifikatspruefung-verschaerfen.patch
```

Geprüft mit `git apply --check` gegen den Stand, in dem der Patch abgelegt wurde.

## Zurückdrehen

```
git apply -R tools/patches/zertifikatspruefung-verschaerfen.patch
```

## Vor dem Commit beachten

Der Patch entfernt vier Zeilen und fügt zwei hinzu, die Datei schrumpft also um zwei
Zeilen: **CR und LF gehen gemeinsam von 372 auf 370.**

`tools/pruefe-bytes.pl` verlangt eine unveränderte CR-Anzahl und kann eine
beabsichtigte Zeilenlöschung nicht von einem Werkzeugschaden unterscheiden. Der Hook
wird den Commit deshalb abweisen. Das ist hier ein Fehlalarm; nachprüfen lässt er
sich so:

```
git show :Eudora71/QCSSL/src/qccertificate.cpp | perl -ne "$c+=tr/\r//; $l+=tr/\n//; END{print qq{CR=$c LF=$l\n}}"
```

Stimmen CR und LF überein (370 = 370) und zeigt `git diff --cached` ausschließlich
die sechs erwarteten Zeilen, ist die Änderung sauber und
`git commit --no-verify` gerechtfertigt.

## Geprüft

* `git apply --check` läuft ohne Beanstandung durch.
* Mit angewandtem Patch baut `Eudora71\QCSSL\QCSSL.vcxproj` in
  `Release|x86` fehlerfrei; es entstehen keine neuen Warnungen.
* Die Arbeitskopie wurde danach zurückgesetzt und `QCSSL.dll` aus dem
  **unveränderten** Quelltext neu gebaut, damit die abgelegte Binärdatei zum
  eingecheckten Code passt und nicht zum Patch.

## Randbeobachtung, nicht Teil des Patches

Die Zeile `if (bInStore) pInfo->m_Outcome.AddErrors(...)` ist in allen Zweigen des
`switch` toter Code: Ist `bInStore` wahr, wurde `iOK` schon vorher auf 1 gesetzt und
der `switch` gar nicht erst betreten. Der Patch übernimmt die Zeile unverändert, um
der Form der Nachbarzweige zu folgen. Aufräumen wäre eine eigene Änderung.
