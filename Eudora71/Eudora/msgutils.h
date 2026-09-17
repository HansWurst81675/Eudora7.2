// MSGUTILS.H
//
// Helper routines for messages
//

char* HeaderContents(UINT HeaderID, const char* Message);
char* QuoteText(const char* message, BOOL IsForward, UINT IsRich = 0, const char* PlainStartText = NULL, bool bEnsureHTML = true, bool bSingle = true);
const char* FindBody(const char* message);
char* WrapText(const char* text);
char* UnwrapText(char* text);
char* FlowText(const char* Text, int Length = -1, BOOL ForceFlowed = FALSE);
UINT GetTmpFile(LPCTSTR lpPathName, LPCTSTR lpExtension, LPTSTR lpTempName);

void	AddToBody(
				CString &			Body,
				const char *		Part,
				int					Length,
				int					PartType,
				bool				bAlwaysStripHTMLCode,
				bool				bStripDocumentLevelTags,
				bool				bRelaxLocalFileRefStripping,
				bool				bConvertEmoticonTriggersToImageTags = true);

void	AddAttachmentToBody(
				CString &			szBody,
				CString &			szPath,
				const CString &		szNoIconPrefix);

void	GetBodyAsHTML(
				CString &			Body,
				LPCTSTR				Text,
				bool				bAlwaysStripHTMLCode = false,
				bool				bStripDocumentLevelTags = false,
				bool				bRelaxLocalFileRefStripping = false,
				bool				bConvertEmoticonTriggersToImageTags = true);
void ConvertNBSPsToSpaces( char* szText );
BOOL StripAttachFromBody(char* message, UINT tag);
CString StripNonPreviewHeaders(const char* Message);
BOOL FindAttachment(CString &csAttachment);
int		GetAttachments(
				const char *		in_szMessage,
				CString &			out_szAttachments);

//
// BEFUND E-88: Original-HTML beim Antworten und Weiterleiten unangetastet
// aufheben und beim Senden wieder einsetzen. Erlaeuterung am Rumpf in
// msgutils.cpp. out_szSpur wird immer gefuellt und gehoert ins Protokoll.
//
bool E88OriginalEinsetzen(
				const char *		pszOriginalHtml,
				const char *		pszEditorText,
				char				cAntwortTyp,
				bool				bAnwenderHatGetippt,
				CString &			out_szNeuerRumpf,
				CString &			out_szSpur);

//
// BEFUND E-89: die Bilder im Verfassenfenster lesbar machen. Ergaenzt in
// der Fassung, die in den Editor geht, jedem <img> ohne auswertbare
// Groesse ein width- und ein height-Attribut. Erlaeuterung am Rumpf in
// msgutils.cpp. Rueckgabe true heisst: out_szHtml ist gefuellt und tritt
// an die Stelle des Eingangstextes. out_szSpur gehoert ins Protokoll.
//
bool E89BilderMessbarMachen(
				const char *		pszHtml,
				CString &			out_szHtml,
				CString &			out_szSpur);

//
// BEFUND E-101: was "Speichern unter" hinausschreibt, ist Eudoras interne
// Fassung - vier Kopfzeilen, der Marker <x-html> und roher HTML-Text, ohne
// Content-Type und ohne Zeichensatz. Kein anderes Programm kann das lesen.
// Diese Funktion macht daraus eine gueltige RFC-822-Datei. Erlaeuterung am
// Rumpf in msgutils.cpp. Rueckgabe true heisst: out_szDatei ist gefuellt und
// tritt an die Stelle des Eingangstextes. out_szSpur gehoert ins Protokoll.
//
bool E101SpeicherfassungAufbereiten(
				const char *		pszVoll,
				bool				bHatKopfzeilen,
				CString &			out_szDatei,
				CString &			out_szSpur);
