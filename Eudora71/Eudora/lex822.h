// LEX822.HPP
//
// Routines for parsing RFC 822 messages
//

#ifndef _LEX822_H_
#define _LEX822_H_

// Data Types

typedef enum
{
	LinearWhite,
	Atom,
	QText,
	RegText,
	DomainLit,
	Comment,
	Special,
	EndOfHeader,
	EndOfMessage,
	ErrorToken,				// something went wrong
	Continue822
} Token822Enum;

typedef enum
{
	Init822,			// get started
	CollectLine,		// not doing anything special right at the moment
	CollectLWSP,		// collecting a run of LWSP
	CollectAtom,		// collecting an atom
	CollectComment,		// collecting an RFC 822 comment
	CollectQText,		// collecting a quoted text string
	CollectDL,			// collecting a domain literal
	CollectSpecial,		// collecting a single special character
	CollectText,		// collecting an unstructured field body
						// we have to be put in this state by an external force
	ReceiveError,		// ran out of characters
	State822Limit
} State822Enum;

/*
 * this enum names the various character classes
 */
typedef enum
{
	ALPHA822,	DIGIT822,	CTL822,		CR822,
	LF822,		SPACE822,	HTAB822,	QUOTE822,
	RPAR822,	LPAR822,	AT822,		COMMA822,
	SEM822,		COLON822,	BSLSH822,	DOT822, 
	LSQU822,	RSQU822,	CHAR822,	EQUAL822,
	SLASH822,	QMARK822,
	CHARTYPE_LIMIT
} Char822Enum;

//	Die groesste Marke, die Lex822() liefern kann - AN-1, zweiter Teil.
//	Hier stand 256, und der Abbruch in Lex822() greift bei sizeof-3, also
//	bei 254 Zeichen. Ein Dateiname nach _MAX_PATH (260) passte damit nicht
//	hinein und verlor genau dort seine Endung.
//
//	WER DIESE ZAHL AENDERT, muss zwei Puffer mitaendern, die sich auf sie
//	berufen: szWert in HeaderDesc::AddAttribute (header.cpp) und in
//	ImapHeaderDesc::AddAttribute (ImapHeader.cpp). Dort wird dieselbe Marke
//	entfaltet, und ein kleinerer Puffer wuerde den Namen wieder abschneiden.
//	Beide holen die Zahl deshalb von hier.
//
//	NICHT das Ziel: eine ganze DKIM-Signature aufnehmen. Die ist oft ueber
//	1500 Zeichen lang und wird weiter stueckweise geliefert - gemessen am
//	12.10.2026 (281 Kappungen in vier Nachrichten) und dort folgenlos, weil
//	Kopfzeilentext nur durchgeschrieben wird. Es geht um Werte in
//	Anfuehrungszeichen, und der laengste davon ist ein Dateiname.
#define LEX822_TOKEN_MAX 1024

// Forward Declarations
class JJFile;
class LineReader;

// Lex822State
class EXPORT Lex822State
{
public:
	Lex822State(LineReader* pLR, bool outputToFile = true, JJFile* pOutputFile = NULL);

	Token822Enum Lex822();
	Token822Enum WriteHeaderToken(Token822Enum tokenType);

	State822Enum State;
	BYTE Token[LEX822_TOKEN_MAX];	// Groesse und Begruendung oben

private:
	Char822Enum LexFill();
	void ADD(BYTE c) { Token[TokenSpot++] = c; Token[TokenSpot] = 0; }

	int TokenSpot;
	BYTE Buffer[2048];		// input buffer line
	BYTE* Spot;				// spot we're currently processing
	BYTE* End;				// time to die
	short InStructure;		// in a quote, comment, or domain literal
	short ReinitToken;		// have we seen the end of the input stream?
	BOOL UhOh;				// we tawt we taw a putty tat
	BOOL Has2047;			// RFC 2047 parsing for 8bit chars in headers

	LineReader* m_LR;		// make this a member because we can have different inputs
	bool		m_ShouldOutputToFile;	// true if WriteHeaderToken should actually write
	JJFile*		m_OutputFile;			// File WriteHeaderToken writes to, or NULL if
										// WriteHeaderToken should write to g_pPOPInboxFile
};


// Function Prototypes

char* Quote822(char* into, const char* from, BOOL space = TRUE, BOOL Param1521 = FALSE);

#endif
