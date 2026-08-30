---
name: was-lauffaehig-heisst
description: "Gregors drei Kriterien für „lauffähig" — startet, korrekte Darstellung, Mail abrufen; alle drei müssen erfüllt sein"
metadata:
  type: project
---

Gregor hat am 30.08.2026 festgelegt, was „lauffähig" bei Eudora 7.2 heißt,
nachdem ich ein Paket so genannt hatte, das zwar startete, aber nicht bedienbar
war:

> * es genügt nicht, daß das programm startet
> * die darstellung sollte korrekt sein
> * ich möchte damit einen mail server verbinden und mails abrufen.

**Alle drei müssen erfüllt sein.** Vorher heißt eine Fassung, was sie ist — etwa
„startet" oder „Vorabfassung". Der Dateiname `Eudora72-1.0.2-lauffaehig.zip`
behauptet mehr, als die Fassung kann; das war mein Fehler.

Maßstab für Kriterium 2 ist ein Bildschirmfoto der Originalfassung, das Gregor
geliefert hat. Maßstab für Kriterium 3 ist ein tatsächlicher Abruf gegen einen
echten Server, mit Protokollversion aus *Tools → Last SSL Info* und mindestens
einer lesbar dargestellten Nachricht.

**Why:** Ich habe zweimal ausgeliefert und dabei den Zustand beschönigt — beim
Paket 1.0.1, das gar nicht startete, und beim Paket 1.0.2, das nur das erste
Kriterium erfüllt. Beides hat Gregor Zeit gekostet, weil er es selbst
herausfinden musste.

**How to apply:** Vor jeder Auslieferung die drei Kriterien einzeln durchgehen
und den Stand nennen. Was nicht geprüft ist, heißt „nicht geprüft" — nicht
„funktioniert vermutlich". Steht ausführlich in `ZIEL.md` im Repo.

Siehe [[lauffaehiges-ergebnis-liefern]] und [[pruefen-statt-vermuten]].
