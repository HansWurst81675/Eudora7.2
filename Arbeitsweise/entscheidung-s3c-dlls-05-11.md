---
name: entscheidung-s3c-dlls-05-11
description: Gregor 05.11.2026: MFC71/msvcp71 nicht ausliefern, Hinweis in Release-Notizen; S/MIME-Plugin später aus plugins/SMIME neu bauen; Test-ZIP für Gregor darf sie enthalten
metadata:
  type: project
---
Schranke: keine - Entscheidung; geprüft beim Einarbeiten in Intern/BEFUNDE.md (S-3c) und den Release-Notizen.

Gregor am 05.11.2026 zu meinem Vorschlag: *„dein vorschlag: 1 + 2 sind gut. so machen wir es.“* und *„S/MIME-Plugins als Befund für ein späteres Paket aufnehmen - ja, gute idee.“*

1. Release-Pakete liefern `MFC71.DLL`/`msvcp71.dll` NICHT mit (nur für VS-2003-Lizenznehmer weiterverteilbar; kein offizielles vcredist 7.1). Release-Notizen nennen Dateien, Fassung (7.10.6041.0 / 7.10.6052.0), Herkunft aus alter Eudora-7.1/Hermes/VS2003-Installation, raten von DLL-Download-Seiten ab.
2. S/MIME-Plugin aus `plugins/SMIME` mit heutigem Compiler neu bauen → braucht nur mfc140/msvcp140. Späteres Paket, nicht 7.2.2.134. SpamWatch/SpamHeaders: kein Quelltext.

Lokale Test-ZIPs für Gregor dürfen die beiden DLLs enthalten (sein Wunsch 05.11.: „da muß ich nichts herum kopieren“).

**Why:** Lizenz unklar, Download-Seiten unsicher; Neubau beseitigt die Abhängigkeit für S/MIME.
**How to apply:** Nicht wieder fragen; beim Paketbau 7.2.2.134 ff. Hinweis prüfen. Siehe [[entscheidung-pruefstand-fenster-05-11]].
