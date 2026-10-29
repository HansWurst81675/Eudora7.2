---
name: jede-neuerung-lokal-pruefbar
description: "Gregor 29.10.2026 - fuer alles neu Entwickelte baue ich die Tests selbst, damit es lokal ohne seine Testverzeichnisse pruefbar ist; seine Uebersicht der Testsysteme fuehrt er selbst"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 052dc212-9ba1-48b1-a2c2-5e444dee95dd
  modified: 2026-10-29T20:42:27.337Z
---

Schranke: tools/pruefe-regressionstest.pl (pre-commit) - weist ein neues "behoben" ohne Regressionstest ab

Gregor am 29.10.2026, nachdem er vier Testsysteme (Laptop direkt, Laptop-VM, Desktop, viele Fassungen) nicht mehr ueberblickte und ich ein Inventar-Werkzeug vorschlug: *"nein, ich mache mir selbst eine liste. wichtig ist, daß du alle möglichen tests bei dir baust, damit man es zumindest lokal überprüfen kann, was neu entwickelt wurde"*.

**Why:** Sein Test an mehreren Rechnern ist teuer und unuebersichtlich; am Laptop sah die erste Junk-Frage nach dem Nachruesten der MFC-DLLs zunaechst wie ein Rueckfall von E-166 aus. Was ich lokal nachstellen kann, soll nicht erst bei ihm auffallen.

**How to apply:**
- Zu jeder Behebung und jeder neuen Funktion gehoert ein lokal laufender Test (Unit-Test oder Pruefstandsfall), der ohne Gregors Verzeichnisse auskommt - auch fuer Randfaelle wie "erst ohne, dann mit Junk-Werkzeugen".
- Kein Inventar-Werkzeug ueber seine Testverzeichnisse bauen; das ist seine Liste.
- Verwandt: [[erst-nachstellen-dann-ausliefern]], [[tests-vor-jedem-commit-laufen-lassen]], [[test-prueft-den-ausstieg]].
