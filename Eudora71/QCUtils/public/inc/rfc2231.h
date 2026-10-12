// RFC2231.H
//
// Lange und nicht-englische Parameterwerte in MIME-Kopfzeilen.
// Befund AN-1, fuenfter Teil.

#ifndef _EUDORA_RFC2231_H_
#define _EUDORA_RFC2231_H_

//	Ein Absender darf einen Parameterwert nach RFC 2231 zerlegen und kodieren:
//
//	  Content-Disposition: attachment;
//	   filename*0*=UTF-8''Angebot%20Nr%204711%20;
//	   filename*1*=fuer%20die%20Stadtwerke.pdf
//
//	Dieser Baum kannte das nicht. GetAttribute("filename") fand dann gar
//	nichts, und mime.cpp nahm ersatzweise den BETREFF aus subj[32] - also
//	31 Zeichen ohne Endung. Genau das Bild, das gemeldet war.
//
//	Die beiden Funktionen stehen in QCUtils, weil POP (Eudora) und IMAP
//	(EuImap) sie beide brauchen und AN-1 schon genug Abschriften hat.

//	Liefert den Wert des Parameters pParameterName oder NULL. pZusatz ist,
//	was der Aufrufer an RFC2231Zusammensetzen uebergeben hat - so kann
//	derselbe Code ueber Eudoras CObList und ueber die PARAMETER-Liste des
//	c-client laufen, ohne eine der beiden zu kennen.
typedef const char* (*RFC2231Sucher)(void* pZusatz, const char* pParameterName);

//	Loest EIN Stueck auf.
//
//	bKodiert	TRUE, wenn der Parametername auf * endete (filename*0*).
//				Nur dann stehen %XX fuer Bytes, und nur davor darf
//				"zeichensatz'sprache'" stehen. Ohne * ist der Wert
//				woertlich - ein %20 bleibt dann ein %20 (RFC 2231, 4).
//	pZeichensatz  darf NULL sein; wird nur beschrieben, wenn ein Vorspann
//				da ist.
//
//	Rueckgabe: Laenge des Ergebnisses, oder -1 bei fehlenden Zeigern oder
//	wenn es nicht in pZiel passt. Bei -1 ist pZiel unbrauchbar.
__declspec( dllexport ) int RFC2231Entschluesseln(const char* pWert, BOOL bKodiert,
												  char* pZiel, int nZiel,
												  char* pZeichensatz, int nZeichensatz);

//	Setzt alle Stuecke von pName zusammen - "filename*", oder "filename*0",
//	"filename*1", ... je mit oder ohne angehaengtes *.
//
//	Rueckgabe: Laenge des Ergebnisses, oder -1, wenn es kein einziges
//	Stueck gab oder etwas nicht passte.
__declspec( dllexport ) int RFC2231Zusammensetzen(const char* pName,
												  RFC2231Sucher pSuchen, void* pZusatz,
												  char* pZiel, int nZiel,
												  char* pZeichensatz, int nZeichensatz);

//	Setzt einen Namen von pZeichensatz auf die ANSI-Kodepage um, wenn
//	pZeichensatz UTF-8 nennt. Sonst bleibt alles, wie es ist - und auch
//	dann, wenn die Bytes gar kein gueltiges UTF-8 sind.
__declspec( dllexport ) void RFC2231ZeichensatzUmsetzen(const char* pZeichensatz,
														char* pName, int nName);

#endif // _EUDORA_RFC2231_H_
