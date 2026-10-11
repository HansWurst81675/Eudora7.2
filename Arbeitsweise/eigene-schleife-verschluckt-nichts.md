---
name: eigene-schleife-verschluckt-nichts
description: "Eine eigene Nachrichtenschleife darf WM_QUIT nicht entnehmen, ohne sie zurückzustellen — und nicht ohne Zeitschranke warten"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 75d9adec-3126-4823-88d3-b19debb061b7
  modified: 2026-09-09T00:00:00.000Z
---

Wer selbst Nachrichten aus der Schlange nimmt, übernimmt damit die Pflichten
der Hauptschleife. Zwei davon werden regelmäßig vergessen:

1. **`WM_QUIT` zurückstellen.** `PeekMessage` mit `PM_REMOVE` nimmt die
   Nachricht aus der Schlange, `DispatchMessage` tut mit ihr **nichts**. Die
   Aufforderung zu beenden ist damit weg — das Programm läuft weiter, obwohl
   es enden sollte. Bei `GetMessage(&msg, hWnd, 0, 0)` ist es schlimmer:
   `WM_QUIT` kommt **trotz** Fensterfilter, der Rückgabewert wird 0, und eine
   Schleife der Form `while (1) { GetMessage(...); … }` dreht sich danach für
   immer, weil die erwartete Nachricht nie mehr kommt.
2. **Nicht ohne Zeitschranke warten.** Kommt das erwartete Ereignis nie, ist
   das Programm tot, und es sieht von außen wie ein Absturz aus, der keiner
   ist.

**Why:** Beides ist genau die Fehlerklasse, die Gregor tagelang gekostet hat —
*„beenden kann ich es auch nicht"*. Sie ist besonders teuer, weil sie
**Kriterium 7 nachträglich wieder aufreißt**: das Beenden ist bestätigt, und
Wochen später sorgt eine neue Schleife dafür, dass es in einem bestimmten
Moment doch nicht geht. Niemand verbindet das dann mit dem Beenden.

Der Anlass sind zwei Fehler am 09.09.2026, beide in derselben Schleife:

| | |
|---|---|
| **E-51**, von mir selbst | `Splitter::Track` lief mit `while(::GetMessage(...))`. Die Prüfinstanz musste **zweimal** abgeschossen werden |
| **E-61**, von PRÜFER | dieselbe Schleife nahm mit `PM_REMOVE` Nachrichten heraus und stellte `WM_QUIT` nicht zurück |

Und beim ersten Lauf der Schranke über den ganzen Baum: **sieben weitere
Fundstellen in Eudoras eigenem Code** (E-62), zwei davon mit echter
Hängegefahr — `LeftClickAttachment` und `CTocView::SizeColumn` warten in
`while (1)` auf eine Nachricht, die nach einem `WM_QUIT` nie mehr kommt, und
halten dabei den Mausfang.

**How to apply:** In jeder eigenen Schleife, unmittelbar nach dem Entnehmen:

```cpp
if (msg.message == WM_QUIT)
{
    ::PostQuitMessage((int) msg.wParam);
    break;          // oder return - aber immer beides: zurückstellen UND raus
}
```

Und statt `while (::GetMessage(...))` warten mit

```cpp
::MsgWaitForMultipleObjects(0, NULL, FALSE, 100, QS_ALLINPUT);
```

danach die Abbruchgründe **selbst** prüfen: Fenster noch da, Mausfang noch da,
Maustaste noch gedrückt. Der Preis ist ehrlich zu nennen — ein künstlicher Zug
über Fensterbotschaften ist damit nicht mehr möglich, das Ziehen kann nur ein
Mensch prüfen. Eine Schleife, die sich bequem testen lässt, aber das Programm
einfrieren kann, wäre der schlechtere Tausch.

**Schranke:** tools/pruefe-nachrichtenschleife.pl (pre-commit)

Die Schranke war bei ihrem ersten Lauf **stumm für genau die Datei, für die
sie geschrieben wurde**: `OTShim.cpp` ist reines CRLF, und das Muster für
einen Funktionskopf verlangte `{\n`. Gemessen: sieben Fundstellen in
LF-Dateien, null in `OTShim.cpp`, obwohl dort die Schleife steht. Siehe
[[schranke-gegentesten]] — und [[zeilenenden-nach-jedem-schreibzugriff-messen]],
weil es dieselbe Ursache ist wie dort.

Verwandt: [[assert-ist-im-release-nichts]] (eine Klasse, die man am besten an
der Wurzel abstellt), [[fehlerklassen-abstellen]] (beim zweiten Auftreten
Werkzeug und Schranke bauen — hier waren es zwei am selben Tag).
