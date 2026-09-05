## E-17 — Der Kontoassistent startete bei jedem Start, obwohl ein Konto eingerichtet war

**Agent:** PERSONA · **Zweig:** `wt/persona` · **Datum:** 05.09.2026 ·
**Fassung:** 7.2.0.5 · **Status:** behoben

Gregor am 05.09.2026: *„beim starten wird immer wieder der wizard gestartet,
obwohl ich bereits ein konto eingerichtet habe. warum?"* — *„sollte nicht sein,
nur wenn keins da ist"*.

### Ursache — bestätigt

Eudora kennt zwei Orte für Kontodaten:

| Persönlichkeit | Abschnitt in `Eudora.ini` |
|---|---|
| die **dominante** (`<Dominant>`) | `[Settings]` |
| jede **benannte** | `[Persona-<Name>]` |

Die Startprüfung in `Eudora71/Eudora/eudora.cpp` sah **nur die erste**:

```c
// Put up New Account Wizard if no return address specified
const char* ra = GetReturnAddress();
if (!ra || !*ra)
{
    SetIniShort(IDS_INI_LAST_SETTINGS_CATEGORY, 0);
    pMainFrame->PostMessage(WM_COMMAND, ID_SPECIAL_NEWACCOUNT);
}
```

Der Weg ist Zeile für Zeile nachgesehen, nicht vermutet:

1. `GetReturnAddress()` (`address.cpp:472`) liest `IDS_INI_RETURN_ADDRESS`,
   ersatzweise `IDS_INI_POP_ACCOUNT`, über `GetIniString`.
2. `GetIniString` (`rs.cpp:252`) **kennt sehr wohl einen Persönlichkeits­­bezug**
   — die Vermutung im Auftrag, es lese stur `[Settings]`, greift zu kurz. Es
   fragt zuerst die *aktuelle* Persönlichkeit:

   ```c
   CString Personality = g_Personalities.GetCurrent();
   g_Personalities.GetProfileString(Personality, Entry, BogusEntry, buf, size);
   ```

3. `CPersonality::GetProfileString` (`persona.cpp:887`) bildet daraus den
   Abschnitt: leerer Name oder `<Dominant>` → **`"Settings"`**, sonst
   `"Persona-" + Name`.
4. `CPersonality::m_Current` wird im Konstruktor auf `""` gesetzt und bis zur
   Startprüfung **von niemandem verändert** (alle `SetCurrent`-Aufrufe stehen in
   Abrufen, Dialogen und dem Wazoo, keiner davon läuft vorher). Der Quelltext
   sagt das an anderer Stelle selbst: der Kommentar vor `g_Personalities.Init()`
   (`eudora.cpp:1071–1078`) hält fest, dass `GetCurrent()` „ein leeres
   `m_Current`" liefert und `GetProfileString` daran die dominante
   Persönlichkeit erkennt.

**Ergebnis:** zum Zeitpunkt der Startprüfung ist die aktuelle Persönlichkeit die
dominante, gelesen wird also tatsächlich `[Settings]`. In Gregors Datei ist dort
`ReturnAddress=` und `POPAccount=` leer → Assistent, bei jedem Start.

### Ein Fehler, drei Symptome — auch das bestätigt

Gregors `Eudora.ini` (nur lesend geprüft,
`C:\Users\Gregor\Eudora72-1.0.5-debug\Mailverzeichnis\`):

```ini
[Settings]
POPAccount=
RealName=
ReturnAddress=
SMTPServer=
PopServer=
LoginName=
…

[Personalities]
Persona0=Persona-hans wurst

[Persona-hans wurst]
POPAccount=adventskalender-mails@freenet.de@mx.freenet.de
RealName=adventskalender-mails@freenet.de
ReturnAddress=adventskalender-mails@freenet.de
SMTPServer=mx.freenet.de
PopServer=mx.freenet.de
LoginName=adventskalender-mails@freenet.de
```

- **Assistent bei jedem Start** — `[Settings]` ist leer.
- **„Account Settings for &lt;Dominant&gt;" zeigte leere Felder** —
  `CModifyAcctSheet` lädt mit `g_Personalities.GetParams("<Dominant>", …)`, das
  liest `[Settings]`. Leer rein, leer angezeigt.
- **Mailabruf funktionierte trotzdem** — er läuft über
  `CheckMailList()`/`SetCurrent(Persona)` und damit über `[Persona-hans wurst]`.

Nebenbelegt: `eudora.log` enthält
`Dialog: "No POP Account entered. …"` — derselbe leere Dominant, aus einer
POP-Sitzung heraus.

### Was der Assistent wirklich tut — Vermutung (a) ist widerlegt

Der Auftrag vermutete, der Assistent lege beim ersten Konto eine **benannte**
Persönlichkeit an statt die dominante zu füllen. Das ist **nicht so**:

- `CMainFrame::OnSpecialNewAccount` (`mainfrm.cpp:4286`) ruft
  `CWizardPropSheet dlg("", NULL, 0, true)`. Das letzte `true` ist `bDominant`
  und landet in `m_bIsDominant` (`WizardPropSheet.h:40/48`).
- `AddPages(m_bIsDominant)` (`WizardPropSheet.cpp:333`) lässt bei `true` die
  Seite `CWizardPersNamePage` **weg** — es wird also gar kein Name abgefragt.
- `StartWizard()` (`WizardPropSheet.cpp:188`):

  ```c
  if (!m_bIsDominant)
      VERIFY(g_Personalities.Add(*m_pParams));      // benannte Persönlichkeit
  else {
      m_pParams->PersName = CRString(IDS_DOMINANT); // "<Dominant>"
      VERIFY(g_Personalities.Modify(*m_pParams));
  }
  ```

- `Modify` → `SavePersonaInfo` (`persona.cpp:924`) setzt bei `<Dominant>`
  `PersonaID = "Settings"`.

Der **Start**-Assistent schreibt also korrekt nach `[Settings]`. Eine benannte
Persönlichkeit entsteht nur auf dem zweiten Weg:
`CPersonalityView::OnCmdNewPersonality` (`PersonalityView.cpp:879`) ruft
`CWizardPropSheet dlg("", this)` — `bDominant` bleibt `false`, die Namensseite
kommt dazu, `Add()` legt `[Persona-<Name>]` an. Genau dafür ist dieser Weg da;
der Name „hans wurst" stammt aus dieser Seite.

Wie der **leere** Schlüsselblock in `[Settings]` entstanden ist, lässt sich nicht
mehr zweifelsfrei rekonstruieren (`eudora.log` ist von späteren Starts
überschrieben). Er trägt den vollständigen Satz Schlüssel, den
`SavePersonaInfo` schreibt — also hat ein `Modify`/`Add` auf die dominante
Persönlichkeit mit leeren Feldern stattgefunden. Zwei Wege können das:
der Startassistent mit leer durchgeklickten Seiten, oder — wahrscheinlicher,
weil Gregor genau diesen Dialog heute gesehen hat — ein **OK** im leeren
„Account Settings for &lt;Dominant&gt;". Beides sind zulässige Benutzeraktionen,
kein Programmfehler.

### Behebung — Weg (b), und warum nicht (a)

**(a)** „Der Assistent soll beim ersten Konto die dominante Persönlichkeit
füllen" — **tut er schon** (siehe oben). Was bliebe, wäre, den *Wazoo*-Weg
umzubauen, damit er bei noch leerer dominanter Persönlichkeit ebenfalls dorthin
schreibt. Das wäre eine Änderung an korrektem Verhalten auf Verdacht: dieser Weg
heißt „neue Persönlichkeit" und soll eine benannte anlegen. Er brächte zudem die
Willkommensseite an eine Stelle, an der sie nicht hingehört (`AddPages`
koppelt sie an `bDominant`). Nicht gemacht.

**(b)** Die Startprüfung berücksichtigt benannte Persönlichkeiten — **gemacht**.
Das ist wörtlich Gregors Anforderung („nur wenn keins da ist"), es behebt sein
Problem in seiner vorhandenen Datei, und es fasst weder Assistent noch
Ini-Schreibpfade an.

Geändert wurde nur `Eudora71/Eudora/eudora.cpp`:

```c
static BOOL AnyPersonalityHasAccount()
{
    const CString strReturnAddr = CPersonality::GetIniKeyName(IDS_INI_PERSONA_RETURN_ADDR);
    const CString strPopAccount = CPersonality::GetIniKeyName(IDS_INI_PERSONA_POP_ACCOUNT);

    for (LPSTR pszName = g_Personalities.List(); pszName && *pszName;
         pszName += strlen(pszName) + 1)
    {
        if (g_Personalities.IsDominant(pszName))
            continue;           // schon von GetReturnAddress() abgedeckt
        …                       // ReturnAddress bzw. POPAccount des Abschnitts
    }
    return FALSE;
}
```

und an der Startprüfung:

```c
const char* ra = GetReturnAddress();
BOOL bHaveAccount = (ra && *ra) ? TRUE : AnyPersonalityHasAccount();
if (!bHaveAccount) { … Assistent … }
```

Das `if (ra && *ra)` für den Tipp des Tages weiter unten wurde auf
`if (bHaveAccount)` mitgezogen — sonst bliebe der Tipp bei einem Anwender mit
benannter Persönlichkeit für immer aus.

`List()` liefert `<Dominant>` zuerst und danach die benannten Namen ohne
Präfix (`persona.cpp:626`); `GetProfileString` liest damit unmittelbar aus der
Ini, **ohne** den Ini-Zwischenspeicher oder die aktuelle Persönlichkeit
anzufassen. Der Start bleibt also nebenwirkungsfrei. `g_Personalities.Init()`
läuft in derselben Funktion deutlich früher (`eudora.cpp:1079`), die von `List()`
gebrauchten Felder `m_szPersonality` und `m_Dominant` sind zur Prüfung also
gesetzt.

### Was mit Gregors vorhandener `Eudora.ini` geschieht

**Der Assistent bleibt weg** — sofort, ohne dass er etwas ändern muss. Seine
`[Personalities]`-Zeile `Persona0=Persona-hans wurst` genügt der neuen Prüfung.

**Seine dominante Persönlichkeit bleibt aber leer.** Die Behebung heilt das
Symptom, nicht den Datenstand — absichtlich nicht: automatisch die Daten einer
benannten Persönlichkeit nach `[Settings]` zu kopieren, hätte sein Konto
doppelt in der Persönlichkeitsliste stehen lassen (`<Dominant>` **und**
„hans wurst"), mit der Gefahr doppelt abgerufener Mail. Was daher **bestehen
bleibt**, solange er nichts tut:

- „Account Settings for &lt;Dominant&gt;" zeigt weiter leere Felder,
- eine neue Nachricht ohne ausgewählte Persönlichkeit bekommt keinen
  `From:`-Kopf (`compmsgd.cpp:140` und `:1502` setzen ihn aus
  `GetReturnAddress()` der *aktuellen* Persönlichkeit),
- ein Abruf, der die dominante Persönlichkeit mitnimmt, meldet weiter
  „No POP Account entered" (`POPSession.cpp:1704`). Im automatischen Abruf
  kommt sie wegen `CheckMailByDefault=0` nicht vor
  (`CPersonality::CheckMailList`), in `eudora.log` steht die Meldung aber.

**Wenn er das will — von Hand, bei geschlossenem Eudora** (sonst überschreibt
Eudora die Datei beim Beenden): in
`C:\Users\Gregor\Eudora72-1.0.5-debug\Mailverzeichnis\Eudora.ini` die sechs
leeren Zeilen im Abschnitt `[Settings]` durch die Werte aus
`[Persona-hans wurst]` ersetzen:

| Zeile in `[Settings]` | vorher | nachher |
|---|---|---|
| `POPAccount=` | leer | `adventskalender-mails@freenet.de@mx.freenet.de` |
| `RealName=` | leer | `adventskalender-mails@freenet.de` |
| `ReturnAddress=` | leer | `adventskalender-mails@freenet.de` |
| `SMTPServer=` | leer | `mx.freenet.de` |
| `PopServer=` | leer | `mx.freenet.de` |
| `LoginName=` | leer | `adventskalender-mails@freenet.de` |

Danach **den Abschnitt `[Persona-hans wurst]` und die Zeile
`Persona0=Persona-hans wurst` löschen** — sonst hat er dasselbe Konto zweimal
und lädt Mail doppelt. Das Kennwort muss er einmal neu eingeben.

Wer es umgekehrt bequemer hat: Der Zustand ist mit dieser Behebung
funktionsfähig; die dominante Persönlichkeit leer zu lassen ist in Eudora
zulässig, solange man beim Verfassen die Persönlichkeit „hans wurst" wählt.

### Zurückgestellt, nicht angefasst

- **`OnMsgAdvEditDom` nimmt Listenzeile 0 statt `<Dominant>`**
  (`PersonalityView.cpp:850`: `theCtrl.GetItemText(0, 0)`). Es geht gut, weil
  `List()` `<Dominant>` immer zuerst liefert — aber es ist eine stille Kopplung
  an die Sortierung, keine Zusicherung.
- **Der Dialog „Account Settings for &lt;Dominant&gt;" lässt sich mit komplett
  leeren Feldern mit OK schließen** und schreibt dann den leeren Schlüsselblock
  nach `[Settings]`. Genau so entsteht der Zustand, der E-17 ausgelöst hat.
  Eine Plausibilitätsprüfung dort wäre die eigentliche Vorbeugung — eigener
  Auftrag.
- **`CPersonality::List()` benutzt `m_ListBuf` doppelt** (`persona.cpp:643`
  schreibt den gestrippten Namen an den Pufferanfang, während `lpBuf` in
  denselben Puffer schreibt). Es geht gut, weil `CSortedStringListMT` kopiert
  und der Anfang danach überschrieben wird — fragil bleibt es.

### Bau

Projektmappe `Eudora71/Eudora.sln`, Plattform `x86` (Projektdateien `Win32`),
`-t:Build` (kein `Rebuild`, kein `Clean`).

| Konfiguration | Rückgabewert | Endsumme | `error`-Zeilen im Protokoll | Artefakte neu |
|---|---|---|---|---|
| Release | 0 | 4824 Warnungen, **0 Fehler** | **0** | ja (4:42) |
| Debug | 0 | 4433 Warnungen, **0 Fehler** | **0** | ja (4:39) |

Der Rückgabewert allein zählt nicht — MSBuild kann mit 0 zurückkommen, ohne
gebaut zu haben. Deshalb zusätzlich gemessen:

- `grep -cE ": (error|fatal error) [A-Z]+[0-9]+"` über das vollständige
  Protokoll: **0** in beiden Läufen.
- Zeitstempel gegen den in Sekunden festgehaltenen Bau-Beginn: die Artefakte in
  `Eudora71/Bin/Release` und `Eudora71/Bin/Debug` sind **jünger** als der
  jeweilige Laufbeginn.
- Gegen die Quelle: `Eudora71/Eudora/eudora.cpp` (mtime 1788637287) ist älter
  als `Build/Release/eudora.obj` (1788637306) **und** als
  `Build/Debug/eudora.obj` (1788637603) — beide Objektdateien enthalten also
  den endgültigen Stand, nicht einen Zwischenstand. (Der Release-Bau lief
  zweimal: der erste hatte die Datei kompiliert, bevor eine reine
  Kommentar­änderung folgte; der zweite Lauf hat sie neu übersetzt und neu
  gebunden.)

### Nachprüfen

1. `Bin/Release/Eudora.exe` gegen sein Mailverzeichnis starten.
2. Der Kontoassistent darf **nicht** mehr erscheinen.
3. Gegenprobe: ein leeres Mailverzeichnis (ohne `[Personalities]`) — dort muss
   der Assistent weiterhin kommen.
