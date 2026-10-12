// HEADER.CPP
//
// Routines for looking at mail headers
//

#include "stdafx.h"

#include <QCUtils.h>
#include "resource.h"
#include "ems-wglu.h"
#include "trnslate.h"

#include "cursor.h"
#include "fileutil.h"
#include "header.h"
#include "mime.h"
#include "lex822.h"
#include "pop.h"
#include "resource.h"
#include "rs.h"
#include "address.h"
#include "rfc2231.h"	// AN-1, fuenfter Teil

#include "DebugNewHelpers.h"


HeaderDesc::HeaderDesc(long estSize, bool bIgnoreDisc)
{
	RemainingBytes = estSize;
	m_bIgnoreDisc = bIgnoreDisc;
	// This is for the translator
	m_TLMime = DEBUG_NEW CTLMime();

	Init();
}

HeaderDesc::~HeaderDesc()
{
	while (Attributes.IsEmpty() == FALSE)
		delete Attributes.RemoveHead();

	delete (m_TLMime);
}

void HeaderDesc::Init()
{
	state = ExpectHeaderName;
	hFound = hLimit;
	*contentEnco = *receivedDate = *messageID = *status = *subj = *who = 0;
	// Initialize the type and subtype, version
	strcpy(contentType, LPCTSTR(CRString(IDS_MIME_TEXT)));
	strcpy(contentSubType, LPCTSTR(CRString(IDS_MIME_PLAIN)));
	strcpy(mimeVersion, LPCTSTR(CRString(IDS_MIME_VERSION)));


	if(!m_bIgnoreDisc)
	{
	g_pPOPInboxFile->Tell(&lDiskStart);
	ASSERT(lDiskStart >= 0);
	lDiskEnd = lDiskStart;
	}

	grokked = TRUE;
	isMIME = FALSE;
	isMHTML = FALSE;
	hasRich = FALSE;
	isPartial = FALSE;
	isDispNotifyTo = FALSE;

	contentID[0] = '\0';
	contentLocation[0] = '\0';
	contentBase[0] = '\0';

	// Initialize Plain
	m_TLMime->CreateMimeType();
}

int HeaderDesc::Read(LineReader* pLR, bool bWriteHeader /*= true*/)
{
	const int IntHeaderSize = 32;
	char interesting[hLimit][IntHeaderSize];
	short h;
	bool bL822Param = !m_bIgnoreDisc;
	if(bWriteHeader)
		bL822Param = !m_bIgnoreDisc;
	else
		bL822Param = bWriteHeader;

	Lex822State l822s(pLR,bL822Param);
	Token822Enum tokenType;
	long lLastNewline = 0;
	long lastParam;

#define EXPECT_TEXT l822s.State = CollectText; state = ExpectText;

	// Grab the interesting header labels
	strcpy(interesting[hContentType], CRString(IDS_MIME_HEADER_CONTENT_TYPE));
	strcpy(interesting[hContentEncoding], CRString(IDS_MIME_HEADER_CONTENT_ENCODING));
	strcpy(interesting[hContentDisposition], CRString(IDS_MIME_HEADER_CONTENT_DISP));
	strcpy(interesting[hContentDescription], CRString(IDS_MIME_CONTENT_DESCRIPTION));
	strcpy(interesting[hContentBase], CRString(IDS_MIME_HEADER_CONTENT_BASE));
	strcpy(interesting[hContentID], CRString(IDS_MIME_HEADER_CONTENT_ID));
	strcpy(interesting[hContentLocation], CRString(IDS_MIME_HEADER_CONTENT_LOCATION));
	strcpy(interesting[hStatus], CRString(IDS_HEADER_STATUS));
	strcpy(interesting[hMimeVersion],CRString(IDS_MIME_HEADER_VERSION));
	strcpy(interesting[hReceived], CRString(IDS_POP_RECEIVED_HEADER));
	strcpy(interesting[hMessageID],CRString(IDS_POP_MESSAGE_ID_HEADER));
	strcpy(interesting[hSubject],CRString(IDS_HEADER_SUBJECT));
	strcpy(interesting[hWho], CRString(IDS_HEADER_FROM));
	strcpy(interesting[hDispNotifyTo], CRString(IDS_MIME_HEADER_READR));

	
    // Remove the colons
	for (h = hContentType; h < hLimit; h++)
    	interesting[h][strlen(interesting[h]) - 1] = 0;
	if(!m_bIgnoreDisc)
	{
		g_pPOPInboxFile->Tell(&lDiskStart);
		ASSERT(lDiskStart >= 0);
		lLastNewline = lDiskEnd = lDiskStart;
	}
	// Read the header
	for (tokenType = l822s.Lex822(); ; tokenType = l822s.Lex822())
	{
		// Write the token to disk
		tokenType = l822s.WriteHeaderToken(tokenType);
		if (tokenType == Comment)
			tokenType = LinearWhite;
		
		// First, we handle a few special token types
		switch (tokenType)
		{
		// any of these things terminate the header collection
		case EndOfHeader:
		case EndOfMessage:
		case ErrorToken:
			goto out;
			break;
			
		// If we have a return, we've hit the end of a header field the header
		// can only legally end in ExpectText or ExpectSem or ExpectVersion
		case Special:
			if (l822s.Token[0] == '\r')
				break;		// Skip first part of newline
			else if (l822s.Token[0] == '\n')
			{
				if (state != ExpectText && state != ExpectSem && state != ExpectVersion)
					grokked = FALSE;
				state = ExpectHeaderName;
				if(!m_bIgnoreDisc)
				{
				g_pPOPInboxFile->Tell(&lLastNewline);
				ASSERT(lLastNewline >= 2);
				lLastNewline -= 2;
				}
				break;
			}
			// Fall through
				
		default:
			// We handle the remaining tokens on a state-by-state basis
			switch (state)
			{
			//********************************
			case ExpectHeaderName:
				switch (tokenType)
				{
				case LinearWhite:
					break;	// Ignore
							
				case Atom:
					for (h = 0; h < hLimit; h++)
						if (!stricmp(interesting[h], (char*)l822s.Token))
							break;
					hFound = (InterestHeaderEnum)h;
					state = ExpectColon;
					if (h > hMimeVersion)
						grokked = FALSE;
					break;
							
				default:
					grokked = FALSE;
					EXPECT_TEXT;
					break;
				}
				break;
						
			//********************************
			case ExpectColon:
				switch (tokenType)
				{
				case LinearWhite:
					break; // ignore
							
				case Special:
					if (l822s.Token[0] == ':')
					{
						switch (hFound)
						{
						case hContentType:
							state = ExpectType;
							break;
						case hContentEncoding:
							state = ExpectEnco;
							break;
						case hContentDisposition:
							strncpy(attributeName,
								CRString(IDS_MIME_HEADER_CONTENT_DISP),
								sizeof(attributeName) - 1);

							state = ExpectValue;
							break;
						case hMimeVersion:
							state = ExpectVersion;
							break;
						default:
							if (hFound > hMimeVersion)
								grokked = FALSE;
							EXPECT_TEXT;
							break;
						}
					}
					break;
							
				default:
					grokked = FALSE;
					EXPECT_TEXT;
					break;
				}
				break;
			//********************************
			case ExpectText:
				switch (hFound)
				{
				case hStatus:
					strncpy(status, ::TrimWhitespaceMT((char*)l822s.Token), sizeof(status) - 1);
					status[sizeof(status) - 1] = 0;
					break;
				case hReceived:
					{
						char* comma = const_cast<char *>(strchr((const char*)l822s.Token, ','));
						if (comma && !*receivedDate)
						{
							strncpy(receivedDate, ::TrimWhitespaceMT(comma + 1), sizeof(receivedDate) - 1);
							receivedDate[sizeof(receivedDate) - 1] = 0;
						}
					}
					break;
				case hMessageID:
					strncpy(messageID, ::TrimWhitespaceMT((char*)l822s.Token), sizeof(messageID) - 1);
					messageID[sizeof(messageID) - 1] = 0;
					break;
				case hSubject:
					strncpy(subj, ::TrimWhitespaceMT((char*)l822s.Token), sizeof(subj) - 1);
					subj[sizeof(subj) - 1] = 0;
					break;
				case hWho:
					strncpy(who, GetRealName((char*)l822s.Token), sizeof(who) - 1);
					who[sizeof(who) - 1] = 0;
					break;
				case hDispNotifyTo:
					isDispNotifyTo = TRUE;
					break;
				case hContentBase:
					strncpy(contentBase, ::TrimWhitespaceMT((char*)l822s.Token), sizeof(contentBase) - 1);
					contentBase[sizeof(contentBase) - 1] = 0;
					break;
				case hContentID:
					strncpy(contentID, ::TrimWhitespaceMT((char*)l822s.Token), sizeof(contentID) - 1);
					contentID[sizeof(contentID) - 1] = 0;
					break;
				case hContentLocation:
					strncpy(contentLocation, ::TrimWhitespaceMT((char*)l822s.Token), sizeof(contentLocation) - 1);
					contentLocation[sizeof(contentLocation) - 1] = 0;
					break;
				}
				break;

			//********************************
			case ExpectEnco:
				switch (tokenType)
				{
				case LinearWhite:
					break;	// Ignore
				default:
					strncpy(contentEnco, ::TrimWhitespaceMT((char*)l822s.Token),
						sizeof(contentEnco) - 1);
					contentEnco[sizeof(contentEnco) - 1] = 0;
					// If we know the encoding, get rid of it
					// that is, if it's safe to do so.
					if(!m_bIgnoreDisc)
					{
					if (g_bAttachmentDecodeEnabled && FindMIMEDecoder(contentEnco, FALSE))
						 g_pPOPInboxFile->Seek(lLastNewline);
					}
					EXPECT_TEXT;
					break;
				}
				break;

			//********************************
			case ExpectVersion:
				switch (tokenType)
				{
				case LinearWhite:
					break;	// Ignore
				default:
					isMIME = CompareRStringI(IDS_MIME_VERSION, (char*)l822s.Token, 0) == 0;
					EXPECT_TEXT;
					break;
				}
				break;
		
			//********************************
			case ExpectType:
				if (tokenType == LinearWhite)
					break;	// skip this
				if (tokenType == Atom || tokenType == QText)
				{
					strncpy(contentType, ::TrimWhitespaceMT((char*)l822s.Token),
						sizeof(contentType) - 1);
					contentType[sizeof(contentType) - 1] = 0;
					
					m_TLMime->ChangeInfo(NULL,contentType,NULL);

					state = ExpectSlash;
				}
				else
				{
					grokked = FALSE;
					EXPECT_TEXT;
				}
				break;
							
			//********************************
			case ExpectSlash:
				if (tokenType == LinearWhite)
					break;	// Ignore
				if (tokenType == Special && l822s.Token[0] == '/')
				{
					state = ExpectSubType;
					break;
				}
				else
				{
					grokked = FALSE;
					EXPECT_TEXT;
				}
				break;
						
			//********************************
			case ExpectSubType:
				if (tokenType == LinearWhite)
					break;	// Skip this
				if (tokenType == Atom || tokenType == QText)
				{
					strncpy(contentSubType, ::TrimWhitespaceMT((char*)l822s.Token),
						sizeof(contentSubType) - 1);
					contentSubType[sizeof(contentSubType) - 1] = 0;

					m_TLMime->ChangeInfo(NULL,NULL,contentSubType);

					state = ExpectSem;
					if (!CompareRStringI(IDS_MIME_PARTIAL, contentSubType))
						isPartial = TRUE;
					else
						isPartial = FALSE;
					if (!CompareRStringI(IDS_MIME_RICHTEXT, contentSubType) ||
						!CompareRStringI(IDS_MIME_ENRICHED, contentSubType) )
						hasRich = TRUE;  //hasRich = g_AnyRich = TRUE;
					if (!CompareRStringI(IDS_MIME_HTML, contentSubType) )
						isMHTML = TRUE;  //isMHTML = g_AnyHTML = TRUE;
					if(!m_bIgnoreDisc)
					{
					g_pPOPInboxFile->Tell(&lastParam);
					ASSERT(lastParam >= 0);
					}
				}
				else
				{
					grokked = FALSE;
					EXPECT_TEXT;
				}
				break;
					
			//********************************
			case ExpectSem:
				if (tokenType == LinearWhite)
					break;
				if (tokenType == Special && l822s.Token[0] == ';')
				{
					state = ExpectAttribute;
					break;
				}
				else
				{
					grokked = FALSE;
					EXPECT_TEXT;
				}
				break;
						
			//********************************
			case ExpectAttribute:
				if (tokenType == LinearWhite)
					break;	// Skip this
				if (tokenType == Atom)
				{
					strncpy(attributeName, ::TrimWhitespaceMT((char*)l822s.Token),
						sizeof(attributeName) - 1);
					attributeName[sizeof(attributeName) - 1] = 0;
					state = ExpectEqual;
				}
				else
				{
					grokked = FALSE;
					EXPECT_TEXT;
				}
				break;
		
			//********************************
			case ExpectEqual:
				if (tokenType == LinearWhite)
					break;
				if (tokenType == Special && l822s.Token[0] == '=')
				{
					state = ExpectValue;
					break;
				}
				else
				{
					grokked = FALSE;
					EXPECT_TEXT;
				}
				break;
						
			//********************************
			case ExpectValue:
				if (tokenType == LinearWhite)
					break;	// skip this
				if (tokenType == Atom || tokenType == QText)
				{
					if (!AddAttribute((char *)l822s.Token))
					{
						tokenType = ErrorToken;
						goto out;
					}
					state = ExpectSem;
					if(!m_bIgnoreDisc)
						{
						g_pPOPInboxFile->Tell(&lastParam);
						ASSERT(lastParam >= 0);
						}
				}
				else
				{
					grokked = FALSE;
					EXPECT_TEXT;
				}
				break;
			}
		}
	}
	
out:
	// did we finish cleanly?
	if (state != ExpectHeaderName && state != ExpectSem && state != ExpectText)
		grokked = FALSE;
	if(!m_bIgnoreDisc)
	{
	// where we ended up
	g_pPOPInboxFile->Tell(&lDiskEnd);
	ASSERT(lDiskEnd >= 0);
	}
	return (tokenType);
}

int HeaderDesc::AddAttribute(const char* Value)
{
	//	Eine Faltung im Wert (CRLF + Leerzeichen oder Tabulator) wird nach
	//	RFC 5322 3.2.2 zu einem einzelnen Leerzeichen; ein CR am Ende stammt
	//	aus einer unbeendeten Zeichenkette und faellt weg. CollectQText nimmt
	//	beides mit, damit WriteHeaderToken die Kopfzeile unveraendert in die
	//	Mailbox schreiben kann - hier, und nur hier, wird es entfernt.
	//	szWert ist so gross wie Lex822State::Token; laenger kann ein Wert
	//	nicht sein, weil der Zerleger bei sizeof(Token)-3 abbricht. Die Zahl
	//	kommt aus lex822.h, damit beide nicht auseinanderlaufen koennen.
	char	szWert[LEX822_TOKEN_MAX];
	if (strchr(Value, '\r'))
	{
		const char *	s = Value;
		char *			d = szWert;
		char *			e = szWert + sizeof(szWert) - 1;
		while (*s && d < e)
		{
			if (s[0] == '\r' && s[1] == '\n' && (s[2] == ' ' || s[2] == '\t'))
			{
				s += 2;
				while (*s == ' ' || *s == '\t')
					++s;
				*d++ = ' ';
				continue;
			}
			if (s[0] == '\r' && s[1] == '\0')
			{
				++s;
				continue;
			}
			*d++ = *s++;
		}
		*d = 0;
		Value = szWert;
	}

	AttributeElement* AE = DEBUG_NEW_MFCOBJ_NOTHROW AttributeElement(attributeName, Value);
	if (!AE)
		return (FALSE);
 
	
	// This is a hack, we really should be parsing out the disposition into its own field
	if (!CompareRStringI(IDS_MIME_HEADER_CONTENT_DISP, attributeName))
		m_TLMime->ChangeInfo(NULL, NULL, NULL, Value);

	// This is a hack, we really should be parsing out the disposition into its own field
	if (!CompareRStringI(IDS_MIME_CONTENT_DISP_FILENAME, attributeName))
		m_TLMime->AddContentParam(attributeName, Value);

	else
		m_TLMime->AddParam(attributeName, Value);


	//	ANHANG-Marke 3: der Wert, wie er abgelegt wird - also nach
	//	allem, was Zerleger und AddAttribute damit gemacht haben. Wer nur
	//	eine Zeile aus dem Log braucht, um den Dateinamen zu sehen, nimmt
	//	die hier (Befund AN-1).
	if (QCLogFileMT::DebugMaskSet(DEBUG_MASK_ATTACH))
	{
		char	szWo[160];
		_snprintf(szWo, sizeof(szWo) - 1, "ANHANG Kopfzeile: %s =",
			(LPCTSTR)AE->m_Name);
		szWo[sizeof(szWo) - 1] = 0;
		PutDebugLogSichtbar(DEBUG_MASK_ATTACH, szWo, (LPCTSTR)AE->m_Value,
			(long)AE->m_Value.GetLength());
	}

	if (Attributes.AddTail(AE))
		return (TRUE);
	else
		return (FALSE);
}

//	Der Sucher fuer RFC2231Zusammensetzen: Eudoras Attributliste.
//	AN-1, fuenfter Teil.
static const char* RFC2231AusListe(void* pZusatz, const char* pName)
{
	CObList* pListe = (CObList*)pZusatz;

	POSITION pos = pListe->GetHeadPosition();
	while (pos)
	{
		AttributeElement* AE = (AttributeElement*)pListe->GetNext(pos);
		if (AE->m_Name.CompareNoCase(pName) == 0)
			return ((LPCTSTR)AE->m_Value);
	}

	return (NULL);
}

AttributeElement* HeaderDesc::GetAttribute(const char* Name)
{
	if (!Name || !*Name)
	{
		ASSERT(FALSE);
		return (NULL);
	}

	POSITION pos = Attributes.GetHeadPosition();
	while (pos)
	{
		AttributeElement* AE = (AttributeElement*)Attributes.GetNext(pos);
		if (AE->m_Name.CompareNoCase(Name) == 0)
			return (AE);
	}

	//	AN-1, fuenfter Teil: unter dem schlichten Namen steht nichts - dann
	//	darf der Wert noch nach RFC 2231 zerlegt und kodiert dastehen
	//	(filename*0*=UTF-8''...). Erst hier nachsehen und nicht beim
	//	Einlesen: beim Einlesen steht noch nicht fest, ob alle Stuecke da
	//	sind.
	char	szWert[LEX822_TOKEN_MAX];
	char	szZeichensatz[32];

	if (RFC2231Zusammensetzen(Name, RFC2231AusListe, &Attributes,
							  szWert, sizeof(szWert),
							  szZeichensatz, sizeof(szZeichensatz)) <= 0)
	{
		return (NULL);
	}

	RFC2231ZeichensatzUmsetzen(szZeichensatz, szWert, sizeof(szWert));

	//	ANHANG-Marke 10: hier war vorher gar kein Wert. Steht diese Zeile im
	//	Log, dann hat die Nachricht den Namen nach RFC 2231 geschickt - und
	//	vor der Behebung von AN-1 Teil 5 waere stattdessen der Betreff als
	//	Dateiname gelandet.
	if (QCLogFileMT::DebugMaskSet(DEBUG_MASK_ATTACH))
	{
		char	szWo[160];
		_snprintf(szWo, sizeof(szWo) - 1,
			"ANHANG Kopfzeile: %s nach RFC 2231 zusammengesetzt (%s) =",
			Name, *szZeichensatz? szZeichensatz : "ohne Zeichensatz");
		szWo[sizeof(szWo) - 1] = 0;
		PutDebugLogSichtbar(DEBUG_MASK_ATTACH, szWo, szWert, (long)strlen(szWert));
	}

	//	Unter dem schlichten Namen ablegen. Dann findet der naechste Aufruf
	//	es sofort, und MIMEMap::Find sieht denselben Wert wie mime.cpp.
	AttributeElement* Neu = DEBUG_NEW_MFCOBJ_NOTHROW AttributeElement(Name, szWert);
	if (!Neu)
		return (NULL);

	if (!Attributes.AddTail(Neu))
	{
		delete Neu;
		return (NULL);
	}

	return (Neu);
}

