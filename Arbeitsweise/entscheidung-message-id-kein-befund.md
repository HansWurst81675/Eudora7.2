---
name: entscheidung-message-id-kein-befund
description: Gregor 25.10.2026 - die Message-ID-Frage (HermesMail-Faden, RFC 5322) bekommt keinen Befund; zwei Randfälle in AssignMessageId stehen nur hier, dazu ein ungeprüfter Puffer-Hinweis
metadata:
  type: project
---

Schranke: keine - eine Entscheidungsnotiz hält Gregors Wort fest; prüfen lässt sich nur, ob sie im Repo steht, und das ist ihr offener Punkt unten.

**Gregor am 25.10.2026, 20:27:32 MEZ**, auf die Frage, ob zwei Randfälle als Befund aufgenommen werden sollen: *„nein, mir reicht, wenn wir generell hier nicht gegen die standards verstoßen.“*

**Anlass:** Er fragte um 20:23 MEZ, ob die Anforderung aus dem HermesMail-Faden „Eudora 7.0 mail header not RFC 5322 compliant now“ (sourceforge, 26.02.2024; MailChannels markierte Eudora-Mails als Spam wegen der Message-ID) bei uns erfüllt ist.

**Antwort von 20:26:07 (Stand):**
- **gemessen:** Eine Nachricht vom Prüfstand `C:\Temp\E125` trägt `Message-Id: <7.2.0.122.2.20261025200323.06321090@127.0.0.1>`. Das ist syntaktisch RFC-5322-konform. Die Domäne ist die des Prüfstands, nicht die eines echten Kontos.
- **belegt am Quelltext:** Jede Mail bekommt eine ID: beim Anlegen (`compmsgd.cpp:163`), beim Öffnen älterer Nachrichten ohne ID (`msgdoc.cpp:347`) und vor dem Senden (`sendmail.cpp:3180`).
- **Randfälle, belegt an `msgdoc.cpp:1343-1361` (`CMessageDoc::AssignMessageId`), nicht gemessen:** (1) Rücksendeadresse leer oder ohne `@` ergibt `@wheresmymailserver.com`, formal gültig. (2) Rücksendeadresse mit Namen, etwa `Name <x@y.de>`: alles hinter dem letzten `@` wird übernommen, also auch `>`. Dann ist die ID nicht konform. Ob Eudora so eine Eingabe dort zulässt, ist ungeprüft.
- **nicht gemessen:** gegen einen echten Spamfilter. Was genau 2024 an Eudora 7.0 bemängelt wurde, ist offen. Der Faden war nur als Zusammenfassung lesbar.

**Zusätzlich, vom CHRONIST am Quelltext gesehen, nicht geprüft und Gregor nicht vorgelegt:** `AssignMessageId` schreibt mit `sprintf` ohne Längengrenze in `char msgid[256]`. Der Domänenteil kommt unbegrenzt aus der INI (`IDS_INI_RETURN_ADDRESS`). Bei einer Rücksendeadresse mit über rund 200 Zeichen hinter dem `@` liefe der Puffer über. Das ist kein Randfall der RFC-Frage. Ob er eine Frage an Gregor wert ist, entscheidet der Hauptstrang. `befund-suchen.pl AssignMessageId` meldet am 26.10.: kein bestehender Befund.

**Offen:** Die Entscheidung und die zwei Randfälle stehen in keiner Repo-Datei (gemessen am 26.10.: kein Treffer für `wheresmymailserver` in `origin/main`). Wer die Frage wieder stellt, sucht neu ([[bestand-vor-neuer-suche]]). Vorschlag: eine Zeile „nicht aufgenommen, Gregor 25.10.2026“ an der Stelle, die `befund-suchen.pl AssignMessageId` findet.
