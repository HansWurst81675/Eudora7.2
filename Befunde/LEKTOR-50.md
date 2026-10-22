# <a id="lektor-50"></a>LEKTOR-50 — „Was noch fehlt" für alle 40 offenen Befunde, 22.10.2026

**Auftrag.** Gregor hatte sich [A-1](../Intern/BEFUNDE.md#a-1) angesehen und gefragt: *„Erscheinungsbild:
fünf Punkte umgesetzt | teilweise, Wirkung belegt ([E-1](../Intern/BEFUNDE.md#e-1)/[E-2](../Intern/BEFUNDE.md#e-2)), was heißt es? was
fehlt hier?"* — und gleich darauf: *„mir geht es nicht nur um [A-1](../Intern/BEFUNDE.md#a-1), sondern um
alle punkte! [A-1](../Intern/BEFUNDE.md#a-1) war nur ein beispiel, das ich mir angeschaut habe!"*

**Gemessen vor dem Eingriff:** 23 von 40 offenen Befunden nannten nur ihre
**Einstufung** („offen", „teilweise"), nicht was aussteht. Acht davon mit
einem einzigen Wort.

**Getan.** 34 Urteile in `Intern/BEFUNDE.md` um die Marke
`**Was noch fehlt:**` ergänzt (sechs waren vorher gesetzt). Nur diese Datei
angefasst, über ein Skript mit Zeilenankern und geprüfter Trefferzahl.
`git diff --numstat`: `40 40` — ausschließlich die 40 Urteilszeilen berührt,
keine Zeile dazu, keine weg. Bytes: `CRLF 0`, `nur-LF 8668`, kein BOM.

## <a id="l-50.1"></a>L-50.1 — drei Fehler im Werkzeug, die die Marke unsichtbar machten

1. **`split /\|/` zerschnitt auch an maskierten Pipes.** Vier Urteile
   enthalten eines — [E-128](../Intern/BEFUNDE.md#e-128) (`"Text Files (*.txt)\|*.txt"`), [E-116](../Intern/BEFUNDE.md#e-116)
   (`digit < '0' \|\| digit > '9'`), [E-105](../Intern/BEFUNDE.md#e-105) (ein zitierter Betreff) und [NP3-1](../Intern/BEFUNDE.md#np3-1)
   (`WS_CHILD \| WS_VISIBLE`). Ihre Zeilen zerfielen in 6 bis 9 statt 5
   Spalten, `$s[3]` endete **vor** der Marke, und die Tabelle schrieb bei
   allen vieren „nicht aufgeschrieben", obwohl der Text dastand.
   Behoben mit `split /(?<!\)\|/`.

2. **Der Abgleich zählte Kennungen aus allen Spalten.** Die erste Fassung der
   S-3-Marke schrieb `**S-3c**` fett — der nächste Lauf meldete
   `ZU VIEL (1, laut BEFUNDE.md erledigt): S-3c`, eine Kennung, die gar keine
   Tabellenzeile war. Gezählt wird jetzt nur die Kennungsspalte.

3. **[E-89](../Intern/BEFUNDE.md#e-89) fiel aus der Urteilserkennung.** Sein Urteil endet mit
   `…*„keine überlappung."*** **Die Ursache…` — in der Folge `*** **` liefert
   das Muster als erstes Fettwort ein **Leerzeichen**. [E-89](../Intern/BEFUNDE.md#e-89) galt damit weder
   als offen noch als behoben und wurde stillschweigend übergangen. Dass das
   folgenlos blieb, lag nur daran, dass er wirklich behoben ist. Es war die
   einzige Zeile der Datei mit diesem Muster.

## <a id="l-50.2"></a>L-50.2 — elf Befunde, deren Urteil nichts hergab

Hier musste die Leerstelle **benannt** statt abgeschrieben werden:

| | woran es fehlt |
|---|---|
| **[NP2-3](../Intern/BEFUNDE.md#np2-3)** | **nirgends** in `Intern/BEFUNDE.md` steht, welche Oberfläche leer bleibt, wenn `BitBltTransparent` still scheitert — ohne das kann niemand entscheiden, ob es sich lohnt |
| **[E-126](../Intern/BEFUNDE.md#e-126)** | es gibt überhaupt keine Messung: nie beobachtet, am Prüfstand nicht nachstellbar, weil POP-Post nie aus `Out` kommt |
| **[E-129](../Intern/BEFUNDE.md#e-129)** | für den schwereren der zwei Mängel (vier Verzeichniseinträge gehen beim Beenden ohne Server verloren) steht **keine** Ursache und kein nächster Schritt da |
| **[E-130](../Intern/BEFUNDE.md#e-130)** | „wer stempelt" ist ausdrücklich nicht gemessen, und es ist nicht entschieden, welche der beiden auseinanderlaufenden DLL-Fassungen gilt |
| **[E-127](../Intern/BEFUNDE.md#e-127)** | „Ursache nicht untersucht" — der nächste Schritt ist aus den Protokollwerten abgeleitet, er steht so nirgends |
| **[E-114](../Intern/BEFUNDE.md#e-114)** | Gregor konnte es selbst nicht nachstellen; eine „Zu messen"-Liste gibt es, eine Ursache nicht |
| **[E-92](../Intern/BEFUNDE.md#e-92)** | die Erzeugungsstelle des eigenen Weiterleitungskopfs ist nicht gefunden — und ohne Eudora-Bild zur selben Nachricht ist offen, ob unser Kopf überhaupt abweicht |
| **[S-6](../Intern/BEFUNDE.md#s-6), [S-3](../Intern/BEFUNDE.md#s-3), [P-1](../Intern/BEFUNDE.md#p-1), [R-1](../Intern/BEFUNDE.md#r-1)** | reine Stummel in der Übersicht; der Inhalt steht in Abschnitten weit unten (`:2839`, `:2852`, `:2928`, `:3428-3505`, `:3845`) |

Bei **[E-71](../Intern/BEFUNDE.md#e-71), [E-90](../Intern/BEFUNDE.md#e-90), [E-124](../Intern/BEFUNDE.md#e-124), [E-133](../Intern/BEFUNDE.md#e-133)** ist „was fehlt" bewusst **keine Behebung**,
sondern eine Entscheidung Gregors bzw. eine Antwort von außen (Microsofts
Urteil zum Defender-Vorgang, der Unicode-Umbau).

## <a id="l-50.3"></a>L-50.3 — zwei Widersprüche zwischen Dokumenten

1. **S-3b wird an drei Stellen verschieden bewertet.** Die Übersicht
   (`:133`) nennt nur S-3c offen; die Querverweistabelle (`:356`) sagt
   „S-3a behoben, S-3b/S-3c offen"; `:4419` und `:4534` sagen, im
   **Release**-Bau verschwinden die SUPERASSERT-Dialoge aus S-3b samt allen
   `ASSERT`/`VERIFY`. Ausgeliefert wird Release — S-3b ist damit faktisch
   gegenstandslos, steht aber weiter als offen da.

2. **[A-1](../Intern/BEFUNDE.md#a-1) nennt dieselbe Funktion mit zwei Zeilen.** Die Marke in `:147` sagt
   `OTShim.cpp:2830` (am 22.10.2026 gemessen), der A-1-Abschnitt bei `:3191`
   sagt `:2244`. Der Abschnitt warnt selbst, dass alle seine Zeilenangaben
   auf `31810e2` zeigen und veraltet sind ([Z-1](../Intern/BEFUNDE.md#z-1)) —
   berichtigt wurde er trotzdem nie. Trifft auch [S-6](../Intern/BEFUNDE.md#s-6), das sich darauf stützt.

## Ergebnis

`perl tools/offene-befunde.pl` → **40 offene Befunde, 0 ohne „Was noch
fehlt"**. `Intern/BEFUNDE.md`: `CRLF 0`, 8668 Zeilen, unverändert.
