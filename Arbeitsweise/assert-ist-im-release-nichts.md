---
name: assert-ist-im-release-nichts
description: "ASSERT und VERIFY sind im Release-Bau weg; bei \"es passiert nichts\" zuerst auf dem betroffenen Weg nach ASSERT(0) und VERIFY( suchen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-07T12:46:23.800Z
---

# „Es passiert nichts" — dann zuerst nach `ASSERT` suchen

Das ist inzwischen die **haeufigste Ursachenklasse dieser Portierung**. Stand
07.09.2026: E-37 viermal, E-38 zweimal, E-33 verwandt, E-34 und E-16 aus
derselben Familie.

## Der Mechanismus

Der Eudora-Quelltext von 1996–2006 wurde mit MFC 6 im **Debug**-Bau
entwickelt. Dort meldet sich jeder Fehlschlag von selbst. Wir liefern
**Release** aus:

| im Quelltext | im Release-Bau |
|---|---|
| `ASSERT(x)` | **weg** — nichts wird geprueft, nichts gemeldet |
| `ASSERT(0)` als „darf nie passieren"-Zweig | ein **leerer** `else`-Zweig |
| `VERIFY(f)` | `((void)(f))` — `f` **laeuft**, der Rueckgabewert wird verworfen |

Damit ist jedes `ASSERT(0)` im Release genau das, was Gregor meldet:
*„es passiert nichts."* Kein Absturz, keine Meldung, kein Log-Eintrag — die
Funktion kehrt still zurueck. Und jedes `VERIFY(f)` verschluckt einen
Fehlschlag, dessen Folgen erst spaeter sichtbar werden.

## Die belegten Fundstellen

| Befund | Symptom (Gregors Worte) | Stelle |
|---|---|---|
| **E-37** | *„loeschen der konten geht uebrigens auch nicht"* | `PersonalityView.cpp:925-976`, `OnCmdDeletePersonality` — **vier** `ASSERT(0)` fuer jeden Fehlschlag; dazu `GetSelectedPersonalities`, `PersonalityView.cpp:280` |
| **E-38** | Assistentendaten hinterher leer | `AccountWizard/Src/WizardPropSheet.cpp:192-193` — `ASSERT(!IsA(...))` und `VERIFY(g_Personalities.Add(...))`; dazu `ModifyAcctSheet.cpp:46` `VERIFY(m_params.GetDefaultParams())` |
| **E-33** | *„weder alt+F4, noch x rechts oben funktionieren"* | verwandt: die geworfene `CInvalidArgException` landet in `CWinApp::ProcessWndProcException`, das die Meldung zeigt und **0** liefert — `WM_CLOSE` gilt als beantwortet, das Fenster bleibt |

E-37 war am Ende **kein** Datenfehler: geloescht wurde korrekt, nur die Liste
wurde nicht neu gefuellt. Entschieden hat das Gregors Antwort auf die richtige
Frage — *„verschwinden sie nach Neustart?"* → *„ja"*. Behoben mit einem
`PopulateView()`-Aufruf statt des `FindItem`-Pfads, plus drei Spurmarken statt
der `ASSERT(0)`-Zweige.

**Warum:** Diese Klasse ist nicht selten und nicht zufaellig — sie steckt
ueberall dort, wo der Originalautor „kann nicht passieren" dachte. Sie ist die
Antwort auf die haeufigste Meldung, die Gregor abgibt, und sie sagt, **wo man
zuerst sucht**, statt den ganzen Weg zu lesen. Und sie kostet nichts zu pruefen:
zwei `grep`.

**Wie anwenden — bei jeder Meldung „X passiert nicht / bleibt leer":**

1. **Erst greppen, dann lesen.** Auf dem betroffenen Weg:
   ```
   grep -n 'ASSERT(0)\|ASSERT(\|VERIFY(' <die beteiligten .cpp>
   ```
   Jeder Treffer ist ein Kandidat fuer den stillen Abbruch.
2. **Jeden `ASSERT(0)`-Zweig durch eine Spurmarke ersetzen**, nicht loeschen:
   `PutDebugLog(DEBUG_MASK_MISC | DEBUG_MASK_TOC_CORRUPT, strMeldung)` mit
   Befundkennung im Text. `PutDebugLog` nimmt **keinen Formatstring**, sondern
   einen fertigen Puffer — erst `CString::Format`, dann uebergeben (Muster:
   `QCChildToolBar.cpp:155-168`). `ASSERT` daneben stehen lassen, damit der
   Debug-Bau weiter meldet ([[dummy-statt-weglassen]]).
3. **`VERIFY(f)` nie fuer eine Aussage benutzen.** Der Rueckgabewert muss
   gelesen und behandelt werden, sonst ist der Fehlschlag im Release
   unsichtbar.
4. **Die Behebung nicht von der unbelegten Ursache abhaengig machen.** Wenn
   nicht zu belegen ist, *warum* der Zweig genommen wird, wird so behoben, dass
   es in beiden Faellen richtig ist — und gleichzeitig eine Marke gelegt, die
   es beim naechsten Lauf verraet.
5. **Marken zaehlen nur gebaut und gepackt.** Ein Log aus einem Paket ohne die
   Marken beweist nichts ([[messung-muss-den-weg-treffen]]).

Der Satz gehoert in `README.md` und `WEITERMACHEN.md`, damit der naechste ihn
findet: *Wer hier weitermacht, sucht auf dem betroffenen Weg zuerst nach
`ASSERT(0)` und `VERIFY(`.*

Siehe [[pruefen-statt-vermuten]] und [[erfolg-aus-anwendersicht]].
