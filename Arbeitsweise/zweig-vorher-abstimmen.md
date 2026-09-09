---
name: zweig-vorher-abstimmen
description: Einen Zweig erst anlegen, wenn Gregor den Namen bestaetigt hat; ein nicht vereinbarter Zweig wird geloescht
metadata:
  type: feedback
---

Schranke: keine - das Repo führt keine Liste der mit Gregor vereinbarten Zweignamen; tools/pruefe-branch.pl erkennt tote Zweige, nicht unabgesprochene

# Zweignamen vorher abstimmen, nicht nachher erklären

**Gregor am 07.09.2026, 06:53 Uhr:** *„doch: da ist wieder ein branch erstellt.
denn die ziele auf dem repo ist verhaltet. so wie ein paar andere dinge. obwohl
es nicht sein durfte."*

Und vier Minuten später, mit dem Namen des Zweigs davor:

> *„ziele-berichtigen*
> *der branch ist illegal und wird gelöscht. den haben wir gar nicht
> vereinbart."*

## Was tatsächlich passiert ist

Ich habe `ziele-berichtigen` von `main` abgezweigt, ohne den Zweig anzukündigen,
und zwei Commits darauf gelegt — `2fb800f` („Ziele berichtigt: sieben
Kriterien") um 06:52 und `732b31a` („BEFUNDE.md: drei Überschriften als
Zeitdokument datiert") um 06:55 — und ihn gepusht.

Gregor hat ihn um 07:02 und 07:03 in beiden Richtungen entfernt:

```
$ git fetch --prune
 - [deleted]         (none)     -> origin/ziele-berichtigen
$ git branch -D ziele-berichtigen
Deleted branch ziele-berichtigen (was 732b31a).
```

Danach gab es **keine Referenz mehr** auf die beiden Commits. Sie waren nur noch
zu retten, weil die Objekte noch in der Objektdatenbank lagen und weil die SHA
`732b31a` in Gregors abgedruckter Ausgabe stand — über `git cat-file`. Ein
`git gc` dazwischen, und die Arbeit wäre weg gewesen. Gregors Urteil dazu:
*„mach neu, dann lernst du was davon - hoffentlich."*

## Warum die vorhandene Lehre nicht gereicht hat

[nie-direkt-auf-main](nie-direkt-auf-main.md) verlangt einen eigenen Zweig und
zeigt sogar den Befehl:

```
git checkout -b <sprechender-name> origin/main
```

Genau das habe ich getan — und trotzdem verstoßen. Die Lücke ist das
`<sprechender-name>`: die Lehre regelt, **dass** ein Zweig sein muss, aber nicht,
**wer den Namen bestimmt**. „Sprechend" ist mein Urteil; vereinbart ist es
nicht. Ein Zweig, den Gregor nicht kennt, ist für ihn kein Arbeitsstand, sondern
ein Fremdkörper im Repo — und er löscht ihn, bevor er nachfragt.

## Die Regel

1. **Vor `git checkout -b`** eine Zeile an Gregor, die den Namen nennt und auf
   eine Antwort wartet:
   *„Für <Vorhaben> möchte ich den Zweig `<name>` von `origin/main` — in
   Ordnung?"*
   Kein Zweig ohne ein Ja darauf.
2. **Schon vereinbart und deshalb frei** sind allein die Arbeitsbäume
   `wt/<agent>` aus [agenten-koordinieren](agenten-koordinieren.md). Alles
   andere — auch „nur für die Doku", auch „nur für einen Commit" — braucht die
   Zustimmung.
3. **Nicht pushen, was nicht vereinbart ist.** Der Push macht den Zweig auf dem
   Server sichtbar; genau daran hat Gregor ihn gefunden.
4. **Wenn ein Zweig gelöscht wird**, ist der erste Handgriff die SHA aus der
   Ausgabe zu sichern, bevor irgendetwas anderes läuft:
   ```
   git branch rettung/<name> <sha-aus-der-ausgabe>
   ```
   `Deleted branch X (was <sha>)` ist die letzte Referenz, die es gibt. Erst
   danach nachsehen, was auf dem Zweig lag.
5. **Der Löschstand ist nicht die Spitze.** `732b31a` war der Zweigkopf zum
   Zeitpunkt des Löschens; drei Minuten später entstand `060a4bf` woanders. Wer
   nur die abgedruckte SHA rettet, rettet nicht zwangsläufig alles.

Siehe [nie-direkt-auf-main](nie-direkt-auf-main.md),
[commit-auf-extra-branch-und-pushen](commit-auf-extra-branch-und-pushen.md) und
[agenten-koordinieren](agenten-koordinieren.md).
