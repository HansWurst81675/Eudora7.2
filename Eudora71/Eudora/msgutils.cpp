// MSGUTILS.CPP
//
// Helper routines for messages
//
// Copyright (c) 1991-2000 by QUALCOMM, Incorporated
/* Copyright (c) 2016, Computer History Museum 
All rights reserved. 
Redistribution and use in source and binary forms, with or without modification, are permitted (subject to 
the limitations in the disclaimer below) provided that the following conditions are met: 
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. 
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following 
   disclaimer in the documentation and/or other materials provided with the distribution. 
 * Neither the name of Computer History Museum nor the names of its contributors may be used to endorse or promote products 
   derived from this software without specific prior written permission. 
NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE 
COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH 
DAMAGE. */

//

#include "stdafx.h"


#include <QCUtils.h>

#include "msgutils.h"
#include "resource.h"
#include "rs.h"
#include "eudora.h"
#include "utils.h"
#include "text2html.h"
#include "etf2html.h"
#include "fileutil.h"
#include "PgEmbeddedImage.h"
#include "QCGraphics.h"
#include "trnslate.h"
#include "guiutils.h"
#include "QCSharewareManager.h"
#include "EmoticonManager.h"

#include "DebugNewHelpers.h"

extern EmoticonDirector g_theEmoticonDirector;

char* HeaderContents(UINT HeaderID, const char* message)
{
	CRString HeaderName(HeaderID);
	
	if (!message || !*message)
		return (NULL);

	// Find out if this header exists
	int len = strlen(HeaderName);
	while (1)
	{
		if (!strnicmp(message, HeaderName, len))
			break;
		if (*message == '\r' || *message == '\n')
			return (NULL);
		if (message = strchr(message, '\n'))
		 	message++;
		else
			return (NULL);
	}

	// Find end of header
	const char* beg = message + len;
	while (*beg == ' ' || *beg == '\t')
		beg++;
	const char* end;
	const char* next = beg;
	do
	{
		if (!(end = strchr(next, '\n')))
			return (NULL);
		end--;
		next = end + 2;
		if (*end == '\r')
			end--;
	} while (*next == ' ' || *next == '\t');

	if (beg > end)
		return (NULL);

	// Copy contents in to new buffer, unwrapping lines as we go
	char* contents = DEBUG_NEW char[end - beg + 2];
	char* p = contents;
	BOOL bAtLineStart = FALSE;
	for (; beg <= end; beg++)
	{
		if (bAtLineStart)
		{
			if (*beg != ' ' && *beg != '\t')
			{
				*p++ = *beg;
				bAtLineStart = FALSE;
			}
		}
		else
		{
			if (*beg == '\n')
			{
				if (beg < end)
					*p++ = ' ';
				bAtLineStart = TRUE;
			}
			else if (*beg != '\r')
				*p++ = *beg;
		}
	}

	*p = 0;
	
	return (contents);
}



// QuoteText
//
char* QuoteText(const char* message, BOOL IsForward, UINT IsRich /*= 0 */, const char* PlainStartText /*= NULL*/, bool bEnsureHTML /*= true*/, bool bSingle /*= true*/)
{
	char* NewMessageBuffer = NULL;

	if (!message)
		return (NULL);

	const BOOL bInterpretFormatFlowed = GetIniShort(IDS_INI_INTERPRET_FORMAT_FLOWED);
	const BOOL bConvertFFToExcerpt = GetIniShort(IDS_INI_CONVERT_FF_TO_EXCERPT);
	const char* Prefix = NULL;
	const char* Start = NULL;
	CString szExtraLinesBeforeStart;
	CString End;

	if (IsForward)
	{
		Prefix = GetIniString(IDS_INI_QUOTE_PREFIX);
		Start = GetIniString(IDS_INI_QUOTE_START);
		GetIniString(IDS_INI_QUOTE_END, End);
	}
	else
	{
		Prefix = GetIniString(IDS_INI_REPLY_PREFIX);
		Start = GetIniString(IDS_INI_REPLY_START);
		GetIniString(IDS_INI_REPLY_END, End);

		// Add extra line before or after if necessary
		if ( !GetIniShort(IDS_INI_WHEN_REPLYING_SELECT_ALL) &&
			 GetIniShort(IDS_INI_WHEN_REPLYING_SEPARATE_WITH_LINE) )
		{
			if ( GetIniShort(IDS_INI_WHEN_REPLYING_TYPE_AFTER) )
				End += "\r\n";
			else if ( GetIniShort(IDS_INI_WHEN_REPLYING_TYPE_BEFORE) )
				szExtraLinesBeforeStart = "\r\n\r\n";
		}
	}
	if (*Prefix)
		Prefix = ">";
	int Plen = ::SafeStrlenMT(Prefix);

	if ((PlainStartText && GetIniShort(IDS_INI_ALWAYS_EXCERPT_RESPONSE)) ||
		(IsRich > IS_FLOWED || (IsRich == IS_FLOWED && (bInterpretFormatFlowed && bConvertFFToExcerpt))))
	{
		CString NewQuotedText;
		CString ExcerptOn;
		CString ExcerptOff;
		CString xHtmlOn;
		CString xHtmlOff;
		CRString xHtml(IDS_MIME_XHTML);
		CString HtmlStartText(Text2Html(PlainStartText, TRUE, FALSE));
		CString HtmlEndText;

		HtmlStartText.Insert( 0, Text2Html(szExtraLinesBeforeStart, TRUE, FALSE) );

		if (*Prefix)
		{
			ExcerptOn.Format("<%s>", (LPCTSTR)CRString(IDS_HTML_BLOCKQUOTE_CITE));
			ExcerptOff.Format("</%s>", (LPCTSTR)CRString(IDS_HTML_BLOCKQUOTE));
		}

		if (*Start)
		{
			HtmlStartText += Text2Html(Start, TRUE, FALSE);
			HtmlStartText += "<br>";
		}

		if (*End)
		{
			if (ExcerptOn.IsEmpty())
				HtmlEndText = "<br>";
			HtmlEndText += Text2Html(End, TRUE, FALSE);
		}

		if (bEnsureHTML)
			GetBodyAsHTML(NewQuotedText, message, false, false, false, false);
		else
			NewQuotedText = message;

		if (bSingle)
		{
			xHtmlOn.Format("<%s>", (LPCTSTR)xHtml);
			xHtmlOff.Format("</%s>", (LPCTSTR)xHtml);
		}

		int NewLen = xHtmlOn.GetLength() + HtmlStartText.GetLength() + ExcerptOn.GetLength() +
						NewQuotedText.GetLength() + ExcerptOff.GetLength() + HtmlEndText.GetLength() +
						xHtmlOff.GetLength();
		NewMessageBuffer = DEBUG_NEW char[NewLen + 1];
		sprintf(NewMessageBuffer, "%s%s%s%s%s%s%s", (LPCTSTR)xHtmlOn, (LPCTSTR)HtmlStartText, (LPCTSTR)ExcerptOn,
													(LPCTSTR)NewQuotedText, (LPCTSTR)ExcerptOff, (LPCTSTR)HtmlEndText,
													(LPCTSTR)xHtmlOff);

		return NewMessageBuffer;
	}

	if (IsRich == IS_FLOWED && bInterpretFormatFlowed)
	{
		// Flow the text
		NewMessageBuffer = FlowText(message);
	}
	else
	{
		if (GetIniShort(IDS_INI_EXCERPT_FIXED_TEXT))
		{
			// I know, it's bad to cast away const-ness, but we handle the case below and make
			// sure not to delete NewMessageBuffer if it's just been asigned to message.
			NewMessageBuffer = (char*)message;
		}
		else
		{
			// Get a wrapped version of the message as it will look much better when plain quoted
			NewMessageBuffer = WrapText(message);
		}
	}
	const char* NewMessage = NewMessageBuffer;

	// Find out how many lines
	int count = 0;
	const char* line = NewMessageBuffer;
	for (; line; count++)
		if (line = strchr(line, '\n'))
			line++;
	
	int		nTotalLengthNeeded = ::SafeStrlenMT(PlainStartText) + szExtraLinesBeforeStart.GetLength() +
								 (::SafeStrlenMT(Start) + 2) + (count * (Plen + 1)) +
								 ::SafeStrlenMT(NewMessageBuffer) + (::SafeStrlenMT(End) + 2) + 1;
	char*	NewText = DEBUG_NEW char[nTotalLengthNeeded];
	
	*NewText = 0;

	// Extra line before start
	strcat(NewText, szExtraLinesBeforeStart);
	
	// attribution?
	if (PlainStartText && *PlainStartText)
	{
		strcat(NewText,PlainStartText);
	}
	
	// quote start string?
	if (Start && *Start)
	{
		strcat(NewText, Start);
		strcat(NewText, "\r\n");
	}

	CRString XFlowed(IDS_MIME_XFLOWED);
	CString FlowedOn, FlowedOff;
	FlowedOn.Format( CRString(IDS_MIME_RICH_ON) , (LPCTSTR)XFlowed);
	FlowedOff.Format(CRString(IDS_MIME_RICH_OFF), (LPCTSTR)XFlowed);

	char* p = NewText + strlen(NewText);
	// Copy line by line into p
	while (1)
	{
		if (strncmp(FlowedOn, NewMessage, FlowedOn.GetLength()) == 0)
		{
			NewMessage += FlowedOn.GetLength();
			if (*NewMessage == '\r')
				NewMessage++;
			if (*NewMessage == '\n')
				NewMessage++;
			continue;
		}
		else if (strncmp(FlowedOff, NewMessage, FlowedOff.GetLength()) == 0)
		{
			NewMessage += FlowedOff.GetLength();
			if (*NewMessage == '\r')
				NewMessage++;
			if (*NewMessage == '\n')
				NewMessage++;
			continue;
		}

		strcpy(p, Prefix);
		p += Plen;

		const char* end = strchr(NewMessage, '\n'); 
		if (end)
		{
			strncpy(p, NewMessage, end - NewMessage + 1);
			p += end - NewMessage + 1;
			NewMessage = end + 1;
		}
		if (!end || !*NewMessage)
		{
			strcpy(p, NewMessage);
			if (End && *End)
			{
				if (!end)
					strcat(p, "\r\n");
				strcat(p, End);
			}

			if (NewMessageBuffer != message)
				delete [] NewMessageBuffer;

			return (NewText);
		}
	}
}



// FindBody
// Returns a pointer to the body of a message
//
const char* FindBody(const char* message)
{
	const char* body = NULL;

	if (message)
	{
		body = strstr(message, "\r\n\r\n");
		if (body)
			body += 4;
		else
		{
			// This is done to be compatible with the legacy way this function
			// was implemented, and I don't want other code to break.
			body = message + strlen(message);
		}
	}

	return body;
}


// WrapText
//
// Takes text and adds newlines at the word wrap column.
// Returns a pointer to an allocated buffer, so remeber to delete!
//
char* WrapText(const char* text)
{
	if (!text)
		return (NULL);

	int WWColumn = GetIniShort(IDS_INI_WORD_WRAP_COLUMN);
	int WWMax = GetIniShort(IDS_INI_WORD_WRAP_MAX);

	// Find out how many newlines will have to be added (approximately)
	long count = 0L;
	const char* p = text;
	while (*p)
	{
		const char *nl = strchr(p, '\n');
		if (!nl)
			nl = p + strlen(p) - 1;
		if (nl - p > WWColumn)
			count += (nl - p) / WWColumn;
		p = nl + 1;
	}

	long total = 0, length = strlen(text) + count * 2 + 1024;
	char* wrapped = DEBUG_NEW_NOTHROW char[length];

	if (!wrapped)
		return (NULL);

	*wrapped = 0;

	char* w = wrapped;
	while (*text)
	{
		const char *stop = strchr(text, '\n');
		int extra = 0;

		if (!stop)
			stop = text + strlen(text) - 1;
		else
		{
			if (*--stop == '\r')
				stop--;
		}
		count = stop - text + 1;
		if (count > WWMax - 1)
		{
			p = text + WWColumn;
			while (*p != ' ' && *p != '\t' && p > text)
				p--;
			if (p == text)
				count = WWColumn;
			else
				count = p - text + 1;
		}
		else
		{
			if (text[count] == '\r')
			{
				extra++;
				if (text[count + 1] == '\n')
					extra++;
			}
			else if (text[count] == '\n')
				extra++;
		}
		if (total + count + 3 > length)
		{
			long OldSpot = w - wrapped;
			length += 1024;
			char* n = DEBUG_NEW_NOTHROW char[length];
			if (!n)
			{
				delete [] wrapped;
				return (NULL);
			}
			strcpy(n, wrapped);
			delete [] wrapped;
			wrapped = n;
			w = wrapped + OldSpot;
		}
		strncpy(w, text, (int)count);
		w += count;
		strcpy(w, "\r\n");
		w += 2;
		text += count + extra;
	}

	return (wrapped);
}

// UnwrapText
//
// Takes wrapped text and heuristically tries to keep newlines only at the ends
// of paragraphs.  
//
char* UnwrapText(char* text)
{
	char* Beg = text;
	char* t = text;
	char* End;
	char* End2; 

	if (!text)
		return (NULL);

	while (*Beg)
	{
		End2 = End = strchr(Beg, '\n');

		// On last line
		if (!End)
			End2 = End = Beg + strlen(Beg) - 1;
		// Next line is quoted
		else if (End[1] == '>')
			;
		// This line is short
		else if (End - Beg < 40)
        	;
		// This line is blank
		else if (End == Beg || (End == Beg + 1 && Beg[1] == '\r'))
			;
		// Next line is blank
		else if (End[1] == '\r' || End[1] == '\n')
        	;
		// Next line is indented
		else if (End[1] == '\t' || (End[1] && End[1] == ' ' && End[2] == ' '))
			;
		else
		{
			End2 = End - 1;
			while (End2 != Beg &&
				(*End2 == '\r' || *End2 == ' ' || *End2 == '\t'))
				End2--;
			if (*End2 == '.' || *End2 == '?' || *End2 == '!')
            	End2 = End;
            else
				*++End2 = ' ';
        }
		strncpy(t, Beg, End2 - Beg + 1);
		t += End2 - Beg + 1;        
        Beg = End + 1;
	}
    *t = 0;

	return (text);
}


// FlowText
//
// Takes (assumed) format=flowed text and removes newlines to flow lines together.
// Returns an allocated buffer, so be sure to delete returned pointer after done.
//
char* FlowText(const char* Text, int Length /*=-1*/, BOOL ForceFlowed /*= FALSE*/)
{
	if (!Text)
	{
		// Passing in a NULL pointer is probably a coding bug
		ASSERT(0);
		return NULL;
	}

	if (Length < 0)
		Length = strlen(Text);

	char* FlowedText = DEBUG_NEW char[Length + 1];
	char* Out = FlowedText;
	const char* LineStart = Text;
	BOOL bLastWasFlowed = FALSE;
	int OldQuoteLevel = 0;

	CRString XFlowed(IDS_MIME_XFLOWED);
	CString FlowedOn, FlowedOff;
	FlowedOn.Format( CRString(IDS_MIME_RICH_ON) , (LPCTSTR)XFlowed);
	FlowedOff.Format(CRString(IDS_MIME_RICH_OFF), (LPCTSTR)XFlowed);
	int FlowedLevel = ForceFlowed? 1 : 0;

	while (1)
	{
		if (strncmp(FlowedOn, LineStart, FlowedOn.GetLength()) == 0)
		{
			LineStart += FlowedOn.GetLength();
			if (*LineStart == '\r')
				LineStart++;
			if (*LineStart == '\n')
				LineStart++;
			FlowedLevel++;
			continue;
		}
		else if (FlowedLevel && strncmp(FlowedOff, LineStart, FlowedOff.GetLength()) == 0)
		{
			LineStart += FlowedOff.GetLength();
			if (*LineStart == '\r')
				LineStart++;
			if (*LineStart == '\n')
				LineStart++;
			FlowedLevel--;
			OldQuoteLevel = 0;
			continue;
		}

		int NewQuoteLevel = 0;
		if (FlowedLevel)
		{
			const char* QuoteEnd = LineStart;

			while (*QuoteEnd == '>')
				QuoteEnd++;
			NewQuoteLevel = QuoteEnd - LineStart;

			// Lines that begin with one or more quotes that are immediately followed
			// by "From " are mangled From lines, so remove one level of quotes.
			if (NewQuoteLevel && strncmp(QuoteEnd, "From ", 5) == 0)
				NewQuoteLevel--;

			if (bLastWasFlowed)
			{
				if (NewQuoteLevel == OldQuoteLevel)
				{
					if (*QuoteEnd == ' ')
						QuoteEnd++;
					LineStart = QuoteEnd;
				}
				else
				{
					// Bad format=flowed!  You should never have a flowed line
					// that changes quote level.  Who created this text?
					*Out++ = '\r';
					*Out++ = '\n';
				}
			}
			OldQuoteLevel = NewQuoteLevel;
		}

		const char* LineEnd = strchr(LineStart, '\r');
		if (!LineEnd)
		{
			strcpy(Out, LineStart);
			break;
		}

		const int NumChars = LineEnd - LineStart;
		strncpy(Out, LineStart, NumChars);
		Out += NumChars;

		bLastWasFlowed = FALSE;
		if (FlowedLevel && NumChars > 0 && LineEnd[-1] == ' ' && (NumChars == 1 || LineEnd[-2] != ' '))
		{
			bLastWasFlowed = TRUE;
			int NonQuoteChars = NumChars;
			if (NewQuoteLevel)
				NonQuoteChars -= NewQuoteLevel + 1;
			if (NonQuoteChars == 3 && LineEnd[-2] == '-' && LineEnd[-3] == '-')
				bLastWasFlowed = FALSE;
		}
		if (!bLastWasFlowed)
		{
			*Out++ = '\r';
			if (LineEnd[1] == '\n')
				*Out++ = '\n';
		}
		LineStart = LineEnd + 1;
		if (*LineStart == '\n')
			LineStart++;
	}

	return FlowedText;
}


// BOG: this probably belongs in QCUtils or something

// IsColorIcon95 - This is a hack that only works for Windows 95. On Windows NT,
// it seems to be impossible to reliably tell a color from Black & White icon.
// This means that CreateJpegFromIcon (QCGraphics.cpp) will generate black
// images from Black & White icons on Windows NT. However, on Windows 95 it
// will crash, so it's still worthwhile to try.

static inline bool IsColorIcon95( HICON hIcon )
{
	bool fRet = false;
	ICONINFO ii;

	if ( hIcon && GetIconInfo( hIcon, &ii ) ) {
		if ( ii.hbmColor ) {
			fRet = true;
			::DeleteObject( ii.hbmColor );
		}

		::DeleteObject( ii.hbmMask );
	}

	return fRet;
}


// GetAssocIcon - try to get the icon associated with a file. requires full
// path to file. compatible with desktop shell and non-shell systems
// (i.e. winnt 3.x). does not use system default icon when association
// cannot be made, but instead uses our own. handles non-existent files.
//
// Note: the Sane Coders Association (SCA) has certified this code to be one
// hundred percent CString Free(tm).

static HICON GetAssocIcon( const char* fullPath, bool & out_bIsSharedIcon )
{
	assert( fullPath );
	HICON theIcon = 0;

	// first we make sure the file even exists. if not, we provide an
	// icon indicating a broken link.
	struct _stat fileInfo;
	bool caller_is_bozo = (fullPath == NULL);

	// Assume that the icon is not shared
	out_bIsSharedIcon = false;

	if ( caller_is_bozo || (_stat( fullPath, &fileInfo ) == -1) ) {
		theIcon = QCLoadIcon( IDI_ATTACH_NOTFOUND );

		// Note that the icon is shared so that we know not to call DestroyIcon
		out_bIsSharedIcon = true;
	}
	else {
		HICON foundIcon = 0;
		HINSTANCE hInst = AfxGetInstanceHandle();
		
		char pathCopy[_MAX_PATH];
		strcpy( pathCopy, fullPath );

		if ( IsVersion4() ) {

			// we use an index of one because otherwise the shell will create
			// thumbnails for image files, which look like crap.

			WORD icoIndex = 1;
			foundIcon = ExtractAssociatedIcon( hInst, pathCopy, &icoIndex );

			// Note that the icon is not shared so that we know to call DestroyIcon
			out_bIsSharedIcon = false;
		}
		else {
			char buf[_MAX_PATH];
			HINSTANCE hInstAssoc = FindExecutable( pathCopy, NULL, buf );
			
			if ( hInstAssoc > (HINSTANCE)32 )
				foundIcon = ExtractIcon( hInst, buf, 0 );

			// if theIcon is nil, we have an exe without an icon; if it is 1,
			// then we have a file that is not an exe, and has no association.
			// setting 'pathCopy' to zero forces the use of our "default"

			if ( !foundIcon || (foundIcon == (HICON)1) )
				*pathCopy = '\0';
			else
				out_bIsSharedIcon = false;
		}

		// BPO - CreateJpegFromIcon (QCGraphics.cpp) does not handle
		// Black & White icons, so for that case we use our own default icon.
		
		if ( (stricmp( pathCopy, fullPath  ) == 0) &&
				IsColorIcon95( foundIcon ) ) {

			theIcon = foundIcon;
		}
		else {
			theIcon = QCLoadIcon( IDI_ATTACH_DEFAULT );

			// Note that the icon is shared so that we know not to call DestroyIcon
			out_bIsSharedIcon = true;
		}
	}

	assert( theIcon );
	return theIcon;
}


CString IconToFile(HICON hIcon)
{
	// create a temp filename - the bmp equiv to the hicon lives for
	// the duration of this QCMessage object
    char FinalFname[_MAX_PATH+1];
    char DirName[_MAX_PATH+1];
	CString iconDir(EudoraDir);

	iconDir += CRString(IDS_ICON_FOLDER); 
	iconDir.MakeLower();
	strcpy(DirName, iconDir);

	// see if we need to create an "icon" directory
	WIN32_FIND_DATA wfd;
	HANDLE findHandle = FindFirstFile(iconDir, &wfd);
	if ( findHandle == INVALID_HANDLE_VALUE)
	{
		// if we can't make the directory, reset it to to old way
		if (mkdir(iconDir) < 0)
			if (errno != EACCES)
				strcpy(DirName, EudoraDir);
	}
	FindClose(findHandle);

	GetTmpFile(DirName, "jpg", FinalFname);

	CString Path;
	if (CreateJpegFromIcon(hIcon, FinalFname, GetSysColor(COLOR_WINDOW)))
		Path = FinalFname;

	return Path;
}

UINT GetTmpFile(LPCTSTR lpPathName, LPCTSTR lpExtension, LPTSTR lpTempName)
{
	WIN32_FIND_DATA wfd;
	HANDLE	findHandle;

	while (1)
	{
		DWORD	count = ::GetTickCount();
		char	szCount[ 20 ];

		strcpy( lpTempName, lpPathName );
		if ( lpTempName[ strlen( lpTempName ) - 1 ] != '\\' )
			strcat( lpTempName, "\\");
		ltoa( count, szCount, 16 );
		strncat( lpTempName, szCount, 8 );
		strcat( lpTempName, "." );
		strcat( lpTempName, lpExtension );

		findHandle = FindFirstFile(lpTempName, &wfd);
		if (findHandle == INVALID_HANDLE_VALUE)
			break;
		FindClose(findHandle);
	}

	return 1;
}

//	Returns whether or not character is whitespace
inline bool IsWhiteSpace(char cPossibleWS)
{
	static const char *		szWhiteSpace = "\r\n\t ";

	return (strchr(szWhiteSpace, cPossibleWS) != NULL);
}


//	Skip whitespace, modifying pScan by reference
inline void SkipWhiteSpace(const char *& pScan)
{
	while ( IsWhiteSpace(*pScan) )
		++pScan;
}


//	Return whether or not the character string looks like the start
//	of a local file reference.
inline int LocalFileReferenceStartLength(const char* szPotentialReference)
{
	int		nLocalFileRefStartLength = 0;
	
	if (strnicmp(szPotentialReference, "file://", 7) == 0)
	{
		//	File URLs are definitely local file references
		nLocalFileRefStartLength = 7;
	}
	else
	{
		//	Look for drive letter colon backslash or slash (e.g. C:\ or C:/)
		char		cRefStart = *szPotentialReference;
		if ( ((cRefStart >= 'a') && (cRefStart <= 'z')) ||
			 ((cRefStart >= 'A') && (cRefStart <= 'Z')) )
		{
			if ( (szPotentialReference[1] == ':') &&
				 ((szPotentialReference[2] == '\\') || (szPotentialReference[2] == '/')) )
			{
				nLocalFileRefStartLength = 3;
			}
		}
	}

	return nLocalFileRefStartLength;
}

void ParseWordForEmoticons(CString & Body, CString & szWord, int wordLength, int wordIndex, int & index)
{

	if(wordLength != 0) {
		bool bTriggerFound = g_theEmoticonDirector.ParseWordForEmoticons(szWord, true);
		if(bTriggerFound) {
			Body.Delete(wordIndex, wordLength); 
			Body.Insert(wordIndex, szWord);
			index = index + 1 - wordLength + szWord.GetLength();
		} else {
			index += 1;
		}
		szWord.Empty();
	} else  {
		index += 1;
	}
}


void ScanTextForEmoticons(CString & Body, int nStartIndex)
{
	CString szWord;
	int index = nStartIndex;
	char ch = Body.GetAt(index);
	bool bInsideTag = false;
	bool bInsideTagQuotes = false;

	while(ch) {
		
		if(!bInsideTag)		
			szWord += ch;

		if(ch == '<') {
				
			int wordLength = szWord.GetLength() - 1; //-1, since we remove the start of tag character
			szWord.Delete(wordLength); //remove the start of tag
			bInsideTag = true;
			ParseWordForEmoticons(Body, szWord, wordLength, index-wordLength, index);

		} else if(ch == '>') {

			if(!bInsideTagQuotes)
				bInsideTag = false;

			index += 1;

		} else if( ch == '"' ) {

			if(bInsideTag && !bInsideTagQuotes) 
				bInsideTagQuotes = true;
			else if(bInsideTag && bInsideTagQuotes) 
				bInsideTagQuotes = false;

			index += 1;
		
		} else if( (ch == ' ') || (ch == '\t') || (ch == '\r') || (ch == '\n') ) {
					
			int wordLength = szWord.GetLength();
			ParseWordForEmoticons(Body, szWord, wordLength, index-wordLength+1, index); //+1 required bcos we have a space at the end of the word

		} else {

			index += 1;
		}
			
		if(index >= Body.GetLength()) {
			
			int wordLength = szWord.GetLength();
			//this is required to convert out the last word. we cannot always expect an end html tag bcos this function
			//is called multiple times for a single message with different indexes into the message
			ParseWordForEmoticons(Body, szWord, wordLength, index-wordLength, index); // it is ok to meddle with the index in the ParseWordForEmoticons functions since we are breakign anyway

			break;
		}
		ch = Body.GetAt(index);

	}
}

void AddHTMLToBody(CString & Body, const char* szPart, bool bRelaxLocalFileRefStripping, bool bConvertEmoticonTriggersToImageTags)
{
	int		nBodySizeBeforeAddition = Body.GetLength();
	
	if ( !GetIniShort(IDS_INI_REMOVE_SUSPICIOUS_LOCAL_FILE_REFS) )
	{
		//	Just add the HTML unmolested
		Body += szPart;
	}
	else
	{
		//	Add the HTML while stripping any suspicious local file references.
		//	We know that any local file references came from the sender, because
		//	we have not translated anything to a file URL ourselves yet.
		//	We have not converted embeded references to file URLs yet,
		//	and attachment references are converted without calling AddHTMLToBody.
		//	Therefore any local file references we find were in the original message.

		//	Assume that we're not inside quotes - should be a safe assumption
		//	given how AddToBody works
		bool					bInsideQuotes = false;
		int						nLocalFileRefStartLength;
		bool					bFoundLocalFileRef;
		bool					bQuotedFileRef = false;
		const char *			pScan = szPart;
		const char *			pSafeStart = szPart;
		const char *			pLocalFileRefScan = NULL;
		const char *			pLocalFileRefStart =  NULL;
		const char *			pLocalFileRefEnd = NULL;
		const char *			pAttributeValueStart = NULL;
		const char *			pTagStart = NULL;
		const char *			pTagEnd = szPart;
		char					cSave;
		char					cScanQuote = 0;
		char					cFileRefQuote = 0;
		
		while (*pScan)
		{
			switch (*pScan)
			{
				case '<':
					if (!bInsideQuotes)
					{
						//	We're not inside quotes, so look to see if this looks like the start of a tag
						char		cFirstTagChar = pScan[1];
						if ( ((cFirstTagChar >= 'a') && (cFirstTagChar <= 'z')) ||
							 ((cFirstTagChar >= 'A') && (cFirstTagChar <= 'Z')) )
						{
							//	We're probably inside of a tag, make sure it's not an <a> tag (<a href>, etc.)
							//	An <a> tag has "<a" followed by one or more whitespace characters
							if ( ((cFirstTagChar != 'a') && (cFirstTagChar != 'A')) || !IsWhiteSpace(pScan[2]) )
							{
								//	For now if we're relaxing local file ref stripping (i.e. content is of local
								//	origination - pasted or stationery) allow image tags. We may later choose to
								//	skip local file ref stripping altogether when the content is of local origination.
								if ( !bRelaxLocalFileRefStripping || (strnicmp(pScan, "<img", 4) != 0) || !IsWhiteSpace(pScan[4]) )
									pTagStart = pScan;
							}
						}
					}
					
					//	Advance to the next character
					++pScan;
					break;

				case '>':
					if (!bInsideQuotes)
					{
						//	We're not inside a tag
						pTagStart = NULL;
					}

					//	Advance to the next character
					++pScan;
					break;

				case '"':
				case '\'':
					//	Advance to the next character
					++pScan;

					if (pTagStart)
					{
						//	We're inside a tag, so keep track of whether or not we're inside quotes
						if (!bInsideQuotes)
						{
							//	We're inside quotes
							bInsideQuotes = true;

							//	Remember the quote character to match
							cScanQuote = *(pScan-1);

							//	Skip whitespace after quote character
							SkipWhiteSpace(pScan);
						}
						else if ( cScanQuote == *(pScan-1) )
						{
							//	We found the terminating quote character - we're not inside quotes anymore
							bInsideQuotes = false;
						}
					}
					break;

				case '=':
					//	Advance to the next character
					++pScan;
					
					//	If we're not inside of a tag, then this = doesn't mean anything
					if (pTagStart == NULL)
						break;

					//	Remember where the attribute value started
					pAttributeValueStart = pScan;
					
					//	Skip whitespace after =
					SkipWhiteSpace(pScan);

					pLocalFileRefScan = pScan;
					cFileRefQuote = *pLocalFileRefScan;
					bQuotedFileRef = ( (cFileRefQuote == '"') || (cFileRefQuote == '\'') );

					//	Skip quote character, if any
					if (bQuotedFileRef)
					{
						++pLocalFileRefScan;

						//	Skip whitespace after quote character
						SkipWhiteSpace(pLocalFileRefScan);
					}
					
					pLocalFileRefStart = pLocalFileRefScan;
					nLocalFileRefStartLength = LocalFileReferenceStartLength(pLocalFileRefStart);
					bFoundLocalFileRef = (nLocalFileRefStartLength > 0);

					//	We'll continue scanning after the start of the local file reference
					pLocalFileRefScan += nLocalFileRefStartLength;
					
					//	If the last tag end that we found is before our current position,
					//	look for the next one.
					if (pTagEnd < pLocalFileRefStart)
					{
						//	Keep track of whether or not we're outside quotes
						bool	bOutsideQuotes;
						char	cTagScanQuote = 0;

						if (bInsideQuotes)
						{
							bOutsideQuotes = false;
							cTagScanQuote = cScanQuote;
						}
						else if (bQuotedFileRef)
						{
							bOutsideQuotes = false;
							cTagScanQuote = cFileRefQuote;
						}
						else
						{
							bOutsideQuotes = true;
						}
						
						//	Start looking for the end tag after the start of the local file reference
						pTagEnd = pLocalFileRefScan;

						while (*pTagEnd)
						{
							if (bOutsideQuotes)
							{
								//	If we're outside quotes, then either < or > will clue us in to whether
								//	or not we're really inside of a tag
								if ( (*pTagEnd == '<') || (*pTagEnd == '>') )
								{
									break;
								}
								else if ( (*pTagEnd == '"') || (*pTagEnd == '\'') )
								{
									bOutsideQuotes = false;
									cTagScanQuote = *pTagEnd;
								}
							}
							else if (cTagScanQuote == *pTagEnd)
							{
								bOutsideQuotes = true;
							}

							++pTagEnd;
						}
					}			

					//	Are we really inside of a tag?
					if (*pTagEnd == '>')
					{		
						//	Initialize bSawUpDirRelativeRef to bFoundLocalFileRef so that our
						//	test in the loop below is somewhat less complicated.
						bool			bSawUpDirRelativeRef = bFoundLocalFileRef;
						char			cLocalFileRefEnd;
						
						//	Mimic the criteria that IE appears to use for what terminates
						//	a local file reference.
						//	* When the local file reference is quoted, IE strongly prefers
						//	  to find the matching quote character.
						//	* When the local file reference is not quoted any whitespace or
						//	  the tag end terminates the local file reference, while a quote is
						//	  treated as a legal part of the local file reference.
						pLocalFileRefEnd = pLocalFileRefScan;
						while (pLocalFileRefEnd < pTagEnd)
						{
							cLocalFileRefEnd = *pLocalFileRefEnd;
							
							if (bQuotedFileRef || bInsideQuotes)
							{
								if ( bInsideQuotes && (cLocalFileRefEnd == cScanQuote) )
								{
									//	Just break without removing the end quote character so that
									//	we're sure to notice that we're no longer in quotes the
									//	next time through the scan loop.
									break;
								}
								else if ( bQuotedFileRef && (cLocalFileRefEnd == cFileRefQuote) )
								{
									//	The local file reference was directly quoted, so remove the end quote character
									++pLocalFileRefEnd;
									break;
								}
							}
							else
							{
								//	Whitespace terminates non-quoted local file references
								if ( IsWhiteSpace(cLocalFileRefEnd) )
									break;
							}

							//	Look for "../" or "..\" which are signs of potential relative
							//	path exploits:
							//	* Don't bother checking if we already found one
							//	* Current char must be dot
							//	* We can't be on the first char
							//	* The previous char must be a dot
							//	* The next char must be either / or \ (we know we have a next char because the
							//	  loop is terminated when we reach the file ref end)
							//	* The char before the previous char, if any, cannot be a dot, because
							//	  we don't care about ".../" or "...\"
							if ( !bSawUpDirRelativeRef && (cLocalFileRefEnd == '.') &&
								 (pLocalFileRefEnd > pLocalFileRefScan) && (*(pLocalFileRefEnd-1) == '.') &&
								 ( (*(pLocalFileRefEnd+1) == '/') || (*(pLocalFileRefEnd+1) == '\\') ) &&
								 ( ((pLocalFileRefEnd-1) == pLocalFileRefScan) || (*(pLocalFileRefEnd-2) != '.') ) )
							{
								bSawUpDirRelativeRef = true;
							}

							++pLocalFileRefEnd;
						}

						if (!bFoundLocalFileRef && bSawUpDirRelativeRef)
						{
							//	It didn't start like an obvious file ref, but it contained "..\" so it
							//	might be a obscured relative file path.
							CString			szPotentialFileRef;
							char			szSaveCurWorkingDir[MAX_PATH+1];
							char			szPotentialFileFullPath[MAX_PATH+1];

							//	Save the current working directory
							char *			szSaveCurWorkingDirResult = _getcwd(szSaveCurWorkingDir, MAX_PATH); 
							
							//	Set the current working directory to the temp dir where we write out
							//	our temp files when working with the Microsoft viewer
							_chdir(TempDir);

							//	Copy the potential file ref
							cSave = *pLocalFileRefEnd;
							*(char *)pLocalFileRefEnd = 0;
							szPotentialFileRef = pLocalFileRefStart;
							*(char *)pLocalFileRefEnd = cSave;

							//	Resolve the path if possible
							if ( _fullpath(szPotentialFileFullPath, szPotentialFileRef, MAX_PATH) )
							{
								//	Check to see if the file actually exists - if not we're better
								//	off allowing the HTML to exist as is
								if ( FileExistsMT(szPotentialFileFullPath) )
									bFoundLocalFileRef = true;
							}

							//	Restore the current working directory
							if (szSaveCurWorkingDirResult)
								_chdir(szSaveCurWorkingDir);
						}

						if (bFoundLocalFileRef)
						{
							if (pAttributeValueStart > pSafeStart)
							{
								//	We've accumulated some HTML that is free of dangerous local file references, add the
								//	safe stuff to the body
								cSave = *pAttributeValueStart;
								*(char *)pAttributeValueStart = 0;
								Body += pSafeStart;
								*(char *)pAttributeValueStart = cSave;
							}

							//	Continue scanning after the local file reference
							pScan = pLocalFileRefEnd;
							pSafeStart = pScan;
						}
					}
					break;

				default:
					//	Advance to the next character
					++pScan;
					break;
			}
		}

		//	Add any remaining HTML
		if (*pSafeStart)
			Body += pSafeStart;
	}

	if (bConvertEmoticonTriggersToImageTags)
	{
		bool  bShowEmoticons = (GetIniShort(IDS_INI_DISPLAY_EMOTICON_AS_PICTURES) != 0);
		if (bShowEmoticons && UsingFullFeatureSet())
			ScanTextForEmoticons(Body, nBodySizeBeforeAddition);
	}
}



void
AddHTMLToBodyIfNotInCode(
	bool				bNotInCode,
	const char *		pTagStart,
	const char *		pNonCodeStart,
	bool				bRelaxLocalFileRefStripping,
	bool				bConvertEmoticonTriggersToImageTags,
	CString &			Body)
{
	if ( bNotInCode && (pTagStart != pNonCodeStart) )
	{
		// Copy over safe content
		*const_cast<char *>(pTagStart) = 0;
		AddHTMLToBody(Body, pNonCodeStart, bRelaxLocalFileRefStripping, bConvertEmoticonTriggersToImageTags);
		*const_cast<char *>(pTagStart) = '<';
	}
}


bool
HasBadAttributeValue(
	CString &		szTagContents,
	const char *	szAttributeToFind,
	const char *	szBadValue)
{
	bool	bHasBadAttributeValue = false;
	
	// Convert to lowercase for case insensitive searching
	szTagContents.MakeLower();
	
	int			nAttributeValueLoc = szTagContents.Find(szAttributeToFind);

	if (nAttributeValueLoc >= 0)
	{
		// Skip past szAttributeToFind and any whitespace
		LPCTSTR		szAttributeValue = ((LPCTSTR) szTagContents) + nAttributeValueLoc + strlen(szAttributeToFind);						
		SkipWhiteSpace(szAttributeValue);

		if (*szAttributeValue == '=')
		{
			// Skip past = and any whitespace
			++szAttributeValue;
			SkipWhiteSpace(szAttributeValue);

			// Skip past quote character and any whitespace
			if ( (*szAttributeValue == '"') || (*szAttributeValue == '\'') )
			{
				++szAttributeValue;
				SkipWhiteSpace(szAttributeValue);
			}

			if (strncmp(szAttributeValue, szBadValue, strlen(szBadValue)) == 0)
				bHasBadAttributeValue = true;
		}
	}

	return bHasBadAttributeValue;
}


void
AddToBody(
	CString &			Body,
	const char *		Part,
	int					Length,
	int					PartType,
	bool				bAlwaysStripHTMLCode,
	bool				bStripDocumentLevelTags,
	bool				bRelaxLocalFileRefStripping,
	bool				bConvertEmoticonTriggersToImageTags)
{
	bool	bStripHTMLCode = (GetIniShort(IDS_INI_RUN_HTML_CODE) == 0) || bAlwaysStripHTMLCode;
	
	// Yes, casting away const'ness is normally a bad thing to do, but in this case we
	// really are treating it as const because we're restoring the character, and it
	// gives a big performance win because we don't have to make a new allocation
	if ( Part == NULL || Length == 0 )
		return;

	char SaveChar = Part[Length];
	((char*)Part)[Length] = 0;

	switch ( PartType )
	{
	case IS_ASCII :
		Body += Text2Html(Part, TRUE, FALSE, GetIniShort(IDS_INI_EXCERPT_FIXED_TEXT), bConvertEmoticonTriggersToImageTags);
		break;

	case IS_FLOWED :
		if (!GetIniShort(IDS_INI_INTERPRET_FORMAT_FLOWED))
			Body += Text2Html(Part, TRUE, FALSE, GetIniShort(IDS_INI_CONVERT_FF_TO_EXCERPT), bConvertEmoticonTriggersToImageTags);
		else
		{
			char* Flowed = FlowText(Part, Length, TRUE);

			Body += Text2Html(Flowed, TRUE, FALSE, GetIniShort(IDS_INI_CONVERT_FF_TO_EXCERPT), bConvertEmoticonTriggersToImageTags);

			delete [] Flowed;
		}
		break;

	case IS_RICH :
		if (Part && *Part)
		{
			int size = Etf2Html_Measure( Part );
			char * buf = DEBUG_NEW_NOTHROW char[ size + 1 ];
			if ( buf )
			{
				Etf2Html_Convert( buf, Part );
				Body += buf;
				delete [] buf;
			}
		}
		break;

	case IS_HTML :
		if (bStripHTMLCode || bStripDocumentLevelTags)
		{
			// If bStripHTMLCode is true we:
			// Strip out stuff that could be potentially dangerous.
			// This means <script>, <applet>, <object>, and <embed> code.
			//
			// If bStripDocumentLevelTags is true we:
			// Strip out document level tags - i.e. html & body
			LPCTSTR NonCodeStart = Part;
			LPCTSTR TagStart = NonCodeStart;
			int ScriptLevel = 0;
			int AppletLevel = 0;
			int ObjectLevel = 0;
			int EmbedLevel = 0;
			int MarqueeLevel = 0;
			bool bLastATagWasBad = false;
#define NotInCode() (!ScriptLevel && !AppletLevel && !ObjectLevel && !EmbedLevel)

			CStringList		listIgnoreTags;
			POSITION		posFoundTag;

			GetIniStringList(IDS_INI_TAGS_TO_IGNORE, ',', listIgnoreTags);

			while (TagStart = strchr(TagStart, '<'))
			{
				if (bStripHTMLCode)
				{
					// <script>
					if (strnicmp(TagStart, "<script", 7) == 0)
					{
						AddHTMLToBodyIfNotInCode( NotInCode(), TagStart, NonCodeStart,
												  bRelaxLocalFileRefStripping,
												  bConvertEmoticonTriggersToImageTags, Body );
						ScriptLevel++;
						TagStart += 7;
					}
					else if (strnicmp(TagStart, "</script", 8) == 0)
					{
						TagStart = strchr(TagStart, '>');
						if (!TagStart)
							break;
						TagStart++;
						if (--ScriptLevel == 0)
						{
							if (NotInCode())
								NonCodeStart = TagStart;
						}
						else if (ScriptLevel < 0)
						{
							// Found a </script> before a <script>
							ScriptLevel = 0;
						}
					}

					// <applet>
					else if (strnicmp(TagStart, "<applet", 7) == 0)
					{
						AddHTMLToBodyIfNotInCode( NotInCode(), TagStart, NonCodeStart,
												  bRelaxLocalFileRefStripping,
												  bConvertEmoticonTriggersToImageTags, Body );
						AppletLevel++;
						TagStart += 7;
					}
					else if (strnicmp(TagStart, "</applet", 8) == 0)
					{
						TagStart = strchr(TagStart, '>');
						if (!TagStart)
							break;
						TagStart++;
						if (--AppletLevel == 0)
						{
							if (NotInCode())
								NonCodeStart = TagStart;
						}
						else if (AppletLevel < 0)
						{
							// Found a </applet> before a <applet>
							AppletLevel = 0;
						}
					}

					// <object>
					else if (strnicmp(TagStart, "<object", 7) == 0)
					{
						AddHTMLToBodyIfNotInCode( NotInCode(), TagStart, NonCodeStart,
												  bRelaxLocalFileRefStripping,
												  bConvertEmoticonTriggersToImageTags, Body );
						ObjectLevel++;
						TagStart += 7;
					}
					else if (strnicmp(TagStart, "</object", 8) == 0)
					{
						TagStart = strchr(TagStart, '>');
						if (!TagStart)
							break;
						TagStart++;
						if (--ObjectLevel == 0)
						{
							if (NotInCode())
								NonCodeStart = TagStart;
						}
						else if (ObjectLevel < 0)
						{
							// Found a </object> before a <object>
							ObjectLevel = 0;
						}
					}

					// <embed>
					else if (strnicmp(TagStart, "<embed", 6) == 0)
					{
						AddHTMLToBodyIfNotInCode( NotInCode(), TagStart, NonCodeStart,
												  bRelaxLocalFileRefStripping,
												  bConvertEmoticonTriggersToImageTags, Body );
						EmbedLevel++;
						TagStart += 6;
					}
					else if (strnicmp(TagStart, "</embed", 7) == 0)
					{
						TagStart = strchr(TagStart, '>');
						if (!TagStart)
							break;
						TagStart++;
						if (--EmbedLevel == 0)
						{
							if (NotInCode())
								NonCodeStart = TagStart;
						}
						else if (EmbedLevel < 0)
						{
							// Found a </embed> before a <embed>
							EmbedLevel = 0;
						}
					}

					// <marquee>
					else if (strnicmp(TagStart, "<marquee", 8) == 0)
					{
						//	Keep track of the marquee level. Allow one marquee tag, but not embedded tags.
						//	A future version of IE may fix this, but the current version (and presumably
						//	past versions) of IE crashes when dealing with a lot of embedded marquee tags.
						if (MarqueeLevel > 0)
						{
							//	We have embedded marquee tags. Ignore this tag and add any safe
							//	HTML up to this point.
							AddHTMLToBodyIfNotInCode( NotInCode(), TagStart, NonCodeStart,
													  bRelaxLocalFileRefStripping,
													  bConvertEmoticonTriggersToImageTags, Body );
							if (!(TagStart = strchr(TagStart, '>')))
								break;
							TagStart++;
							if (NotInCode())
								NonCodeStart = TagStart;
						}
						else
						{
							//	We're on our first marquee tag - allow it.
							TagStart += 8;
						}

						//	Increment our marquee level count.
						MarqueeLevel++;
					}
					else if (strnicmp(TagStart, "</marquee", 9) == 0)
					{
						if (MarqueeLevel > 1)
						{
							//	We have embedded marquee tags. Ignore this tag and add any safe
							//	HTML up to this point.
							AddHTMLToBodyIfNotInCode( NotInCode(), TagStart, NonCodeStart,
													  bRelaxLocalFileRefStripping,
													  bConvertEmoticonTriggersToImageTags, Body );
							if (!(TagStart = strchr(TagStart, '>')))
								break;
							TagStart++;
							if (NotInCode())
								NonCodeStart = TagStart;
						}
						else
						{
							//	We're closing our original marquee tag - allow it.
							TagStart += 8;
						}

						//	Decrement and sanity check our marquee count.
						if (--MarqueeLevel < 0)
							MarqueeLevel = 0;
					}

					// <iframe>
					// Content between <iframe> and </iframe> tags are to be shown
					else if (strnicmp(TagStart, "<iframe", 7) == 0 || strnicmp(TagStart, "</iframe", 8) == 0)
					{
						AddHTMLToBodyIfNotInCode( NotInCode(), TagStart, NonCodeStart,
												  bRelaxLocalFileRefStripping,
												  bConvertEmoticonTriggersToImageTags, Body );
						if (!(TagStart = strchr(TagStart, '>')))
							break;
						TagStart++;
						if (NotInCode())
							NonCodeStart = TagStart;
					}

					// <t:video>, etc.
					else if (strnicmp(TagStart, "<t:", 3) == 0)
					{
						// Block <t: tags which support src attribute because they can
						// cause automatic playing of media file when rendered. Media
						// file can contain scripts, hence this is a potential security
						// issue.
						// I'm not sure if <t: normally have an end tag, but in the
						// exploit reported by greymagic they do not.
						if ( (strnicmp(TagStart, "<t:animation", 12) == 0) ||
							 (strnicmp(TagStart, "<t:audio", 8) == 0) ||
							 (strnicmp(TagStart, "<t:img", 6) == 0) ||
							 (strnicmp(TagStart, "<t:media", 8) == 0) ||
							 (strnicmp(TagStart, "<t:ref", 6) == 0) ||
							 (strnicmp(TagStart, "<t:video", 8) == 0) )
						{
							AddHTMLToBodyIfNotInCode( NotInCode(), TagStart, NonCodeStart,
													  bRelaxLocalFileRefStripping,
													  bConvertEmoticonTriggersToImageTags, Body );
							if (!(TagStart = strchr(TagStart, '>')))
								break;
							TagStart++;
							if (NotInCode())
								NonCodeStart = TagStart;
						}
						else
						{
							TagStart++;
						}
					}

					// <bgsound>
					else if (strnicmp(TagStart, "<bgsound", 8) == 0)
					{
						// Block <bgsound> tags because:
						// * Can be exploited in combination with special DOS device names
						// * Sounds in email are annoying - who wants loud porno moaning because of spam?!?
						AddHTMLToBodyIfNotInCode( NotInCode(), TagStart, NonCodeStart,
												  bRelaxLocalFileRefStripping,
												  bConvertEmoticonTriggersToImageTags, Body );
						if (!(TagStart = strchr(TagStart, '>')))
							break;
						TagStart++;
						if (NotInCode())
							NonCodeStart = TagStart;
					}

					// <meta> when http-equiv=refresh
					else if (strnicmp(TagStart, "<meta", 5) == 0)
					{
						// Find the end of the tag
						LPCTSTR		TagEnd = strchr(TagStart, '>');

						if (!TagEnd)
							break;

						// Look for http-equiv=refresh inside of the current <meta> tag,
						// and for any charset declaration.  The latter has to go: the
						// stored message body is Windows-1252 (ISOTranslate has already
						// run on it in TextReader::ReadIt), while the tag still names the
						// charset of the ORIGINAL mail.  MSHTML loads our temp file as a
						// file path and believes that tag, which makes every umlaut a
						// U+FFFD.  CTridentView::WriteTempFile writes the correct
						// declaration at the top of the file instead.
						*(LPTSTR)TagEnd = 0;

						CString		TagContents = TagStart + 5;
						CString		TagContentsLower = TagContents;
						TagContentsLower.MakeLower();
						bool		bIsBadMeta = HasBadAttributeValue(TagContents, "http-equiv", "refresh") ||
											 ( TagContentsLower.Find("charset") >= 0 );
						*(LPTSTR)TagEnd = '>';

						if (bIsBadMeta)
						{
							AddHTMLToBodyIfNotInCode( NotInCode(), TagStart, NonCodeStart,
													  bRelaxLocalFileRefStripping,
													  bConvertEmoticonTriggersToImageTags, Body );
							TagStart = TagEnd + 1;
							if (NotInCode())
								NonCodeStart = TagStart;
						}
						else
						{
							TagStart++;
						}
					}

					// <a> when href or onclick=javascript:
					else if (strnicmp(TagStart, "<a", 2) == 0)
					{
						const char *	pTagWalker = TagStart + 2;

						//	Assume <a> is harmless
						bLastATagWasBad = false;

						//	Check to make sure that we're looking at an actual <A> tag,
						//	not just a tag name that happens to start with A.
						if ( IsWhiteSpace(*pTagWalker) )
						{
							//	Skip past the whitespace
							SkipWhiteSpace(pTagWalker);
							
							//	Find the end of the tag
							LPCTSTR		TagEnd = strchr(pTagWalker, '>');

							if (!TagEnd)
								break;

							//	Look for href or onclick = javascript: inside of the current <meta> tag
							*(LPTSTR)TagEnd = 0;

							CString		TagContents = pTagWalker;

							//	Check for javascript: reference in href or onclick
							bLastATagWasBad = HasBadAttributeValue(TagContents, "href", "javascript:");

							if (!bLastATagWasBad)
								bLastATagWasBad = HasBadAttributeValue(TagContents, "onclick", "javascript:");

							*(LPTSTR)TagEnd = '>';

							if (bLastATagWasBad)
							{
								//	Add any harmless HTML that occurred before this tag
								AddHTMLToBodyIfNotInCode( NotInCode(), TagStart, NonCodeStart,
														  bRelaxLocalFileRefStripping,
														  bConvertEmoticonTriggersToImageTags, Body );

								//	Allow contents of this tag if we're not inside code
								TagStart = TagEnd + 1;
								if (NotInCode())
									NonCodeStart = TagStart;
							}
							else
							{
								TagStart++;
							}
						}
						else
						{
							TagStart++;
						}
					}

					//	Remove ending </a> when the start was harmful
					else if ( (strnicmp(TagStart, "</a", 3) == 0) && bLastATagWasBad )
					{
						char	cNextChar = TagStart[3];

						if ( IsWhiteSpace(cNextChar) || (cNextChar == '>') )
						{
							// Find the end of the tag
							LPCTSTR		TagEnd = strchr(TagStart, '>');

							if (!TagEnd)
								break;

							//	Add any harmless HTML that occurred inside the <a> tag
							AddHTMLToBodyIfNotInCode( NotInCode(), TagStart, NonCodeStart,
													  bRelaxLocalFileRefStripping,
													  bConvertEmoticonTriggersToImageTags, Body );
							TagStart = TagEnd + 1;
							if (NotInCode())
								NonCodeStart = TagStart;

							bLastATagWasBad = false;
						}
						else
						{
							TagStart++;
						}
					}

					// Ignore tags specified in IDS_INI_TAGS_TO_IGNORE. Display content
					// inside said tags. Can be used as a brute force way to ignore styles
					// or as a way to avoid exploits that rely on the abuse of a particular
					// tag that we don't care that much about.
					else if ( ((TagStart[1] != '/') && StringStartsWithStringInList(TagStart+1, listIgnoreTags, posFoundTag)) ||
							  ((TagStart[1] == '/') && StringStartsWithStringInList(TagStart+2, listIgnoreTags, posFoundTag)) )
					{
						//	Start with the character after the '<'
						LPCTSTR		pNextChar = TagStart+1;
						
						//	If it's an end tag move past the '/'
						if (*pNextChar == '/')
							pNextChar++;

						//	Get the next character after the end of the tag
						CString &	szFoundTag = listIgnoreTags.GetAt(posFoundTag);
						pNextChar += szFoundTag.GetLength();

						//	Make sure the tag is an exact match
						if ( IsWhiteSpace(*pNextChar) || (*pNextChar == '>') )
						{
							//	The tag is an exact match with a tag that we were told to block.
							//	Block the tag, but allow the contents of the tag.
							AddHTMLToBodyIfNotInCode( NotInCode(), TagStart, NonCodeStart,
													bRelaxLocalFileRefStripping,
													bConvertEmoticonTriggersToImageTags, Body );
							if (!(TagStart = strchr(TagStart, '>')))
								break;
							TagStart++;
							if (NotInCode())
								NonCodeStart = TagStart;
						}
						else if (!bStripDocumentLevelTags)
						{
							//	Not an exact match - move past the '<' unless we're
							//	going to be stripping document level tags too
							TagStart++;
						}
					}

					//	We didn't match any dangerous tags, move past the '<' unless
					//	we're going to be stripping document level tags too
					else if (!bStripDocumentLevelTags)
					{
						TagStart++;
					}
				}

				//	If we want to strip document level tags check to see if previous
				//	HTML code stripping has already acted on the tag
				if ( bStripDocumentLevelTags && (*TagStart == '<') )
				{
					//	Move past the '<'
					const char *	pBodyTagStart = TagStart + 1;

					//	If it's an end tag, move past the '/'
					if (*pBodyTagStart == '/')
						pBodyTagStart++;
					
					if (strnicmp(pBodyTagStart, "html", 4) == 0)
					{
						AddHTMLToBodyIfNotInCode( NotInCode(), TagStart, NonCodeStart,
												  bRelaxLocalFileRefStripping,
												  bConvertEmoticonTriggersToImageTags, Body );
						if (!(TagStart = strchr(TagStart, '>')))
							break;
						TagStart++;
						if (NotInCode())
							NonCodeStart = TagStart;
					}
					else if (strnicmp(pBodyTagStart, "x-html", 6) == 0)
					{
						AddHTMLToBodyIfNotInCode( NotInCode(), TagStart, NonCodeStart,
												  bRelaxLocalFileRefStripping,
												  bConvertEmoticonTriggersToImageTags, Body );
						if (!(TagStart = strchr(TagStart, '>')))
							break;
						TagStart++;
						if (NotInCode())
							NonCodeStart = TagStart;
					}
					else if (strnicmp(pBodyTagStart, "body", 4) == 0)
					{
						AddHTMLToBodyIfNotInCode( NotInCode(), TagStart, NonCodeStart,
												  bRelaxLocalFileRefStripping,
												  bConvertEmoticonTriggersToImageTags, Body );
						if (!(TagStart = strchr(TagStart, '>')))
							break;
						TagStart++;
						if (NotInCode())
							NonCodeStart = TagStart;
					}
					else
					{
						//	We didn't match any dangerous tags (in HTML code stripping) or any
						//	document level tags - move on
						TagStart++;
					}
				}
			}

			//	Add any level over HTML if it's safe
			if (NotInCode())
				AddHTMLToBody(Body, NonCodeStart, bRelaxLocalFileRefStripping, bConvertEmoticonTriggersToImageTags);
		}
		else
		{
			//	We're not stripping either HTML code or document level tags.
			//	Just add the HTML to the body.
			AddHTMLToBody(Body, Part, bRelaxLocalFileRefStripping, bConvertEmoticonTriggersToImageTags);
		}
		break;
	}

	((char*)Part)[Length] = SaveChar;
}

void AddAttachmentToBody(
	CString &			szBody,
	CString &			szPath,
	const CString &		szNoIconPrefix)
{
	//	We only show images inline if the user has told us to, and then only if
	//	the image looks valid to us.
	//
	//	Note that since we have no way to validate whether or not MSHTML will
	//	recognize the image, we make the assumption that MSHTML will handle
	//	everything that we can handle (either internally or via QuickTime).
	bool		bShowAttachmentInline = (GetIniShort(IDS_INI_DISPLAY_IMAGE_ATTACHMENTS_INLINE) != 0) &&
										IsValidImageFileQuickCheck(szPath);
	bool		bShowAttachmentIcons = (GetIniShort(IDS_INI_SHOW_ATTACHMENT_ICONS) != 0);
	CString		szHREF = EscapeURL( CString("file://") + szPath );
	CString		szFileName;
	CString		szIconPath;

	if (bShowAttachmentInline || bShowAttachmentIcons)
	{
		//	We need the file name if we're showing the attachment inline or if
		//	we're displaying an icon and the file name. (When displaying it without
		//	an icon and not inline we just use the full path).
		int		iPos = szPath.ReverseFind( '\\' );
		
		if (iPos >= 0)
			szFileName = szPath.Right( szPath.GetLength() - iPos - 1 );
		else
			szFileName = szPath;
	}

	szBody += "<div>\r\n<a href=\"";
	szBody += szHREF;
	if ( UsingTrident() )
	{
		// Ben sez: we stash the href in our "file" attr, so the trident can't
		// find it, and mess (ok Ben used a more colorful word than "mess")
		// with the url-encoding. however, we keep "href" for paige, and
		// "send to browser." pretty sucky.
		szBody += "\" file=\"";
		szBody += szHREF;
	}
	szBody += "\" EUDORA=ATTACHMENT>\r\n";

	if (bShowAttachmentInline)
	{
		//	Show the image inline with the name underneath it.
		//	Make the entire image and name a link so that the user can still open
		//	the image.
		szBody += "<img src=\"file://";
		szBody += szPath;
		szBody += "\">\r\n<br>\r\n";
		szBody += szFileName;
		szBody += "\r\n</a>\r\n</div>\r\n";
	}
	else
	{
		//	Get the icon for the attachment if appropriate and possible.
		if (bShowAttachmentIcons)
		{			
			// Get the associated icon
			bool	bIsSharedIcon = false;
			HICON	hIcon = GetAssocIcon(szPath, bIsSharedIcon);
			
			if (hIcon)
			{
				szIconPath = IconToFile(hIcon);
				
				if (!bIsSharedIcon)
					DestroyIcon( hIcon );
			}
		}

		if ( !szIconPath.IsEmpty() )
		{
			szBody += "<img src=\"file://";
			szBody += szIconPath;
			szBody += "\" alt=\"";
			szBody += szFileName;
			szBody += "\"> ";
			szBody += szFileName;
			szBody += " </a>\r\n</div>\r\n";
		}
		else
		{
			// make it an anchor with no icon
			// Note that previously this generated invalid HTML by not closing the
			// div tag. That also meant that multiple attachments did not have a
			// blank line between them. If anyone complains about the blank lines
			// between attachment names when icons are turned off, we'll have to
			// try this specific case without the div tags altogether.
			szBody += szNoIconPrefix;
			szBody += "\"";
			szBody += szPath;
			szBody += "\"</a>\r\n</div>\r\n";
		}
	}
}

void
GetBodyAsHTML(
	CString &			Body,
	LPCTSTR				Text,
	bool				bAlwaysStripHTMLCode,
	bool				bStripDocumentLevelTags,
	bool				bRelaxLocalFileRefStripping,
	bool				bConvertEmoticonTriggersToImageTags)
{
	const char*	pCurrent = Text;
	int			PartType = IS_ASCII;
	CString		szPath;
	LONG		lLen;
	CString		szBase;
	INT			iPos;
	const char* pStartNext = NULL;
	const char* pNextLineStart = pCurrent;
	const char* pLineStart = NULL;
	

	// now process the body removing "Attachment converted" and
	// "Embedded content" lines as well as converting things to HTML
	CRString ACTrailer( IDS_ATTACH_CONVERTED );
	CRString ECTrailer( IDS_EMBEDDED_CONTENT );
	CRString TFTrailer( IDS_TRANS_FILE_TAG );

	// IDS_ATTACH_REG_INFO is now deprecated in favor of IDS_ATTACH_EUDORA_INFO. Because
	// registration info attachments were previously marked with IDS_ATTACH_REG_INFO,
	// we should support it for all 4.3 releases (or as long as the registration
	// codes which could be marked with IDS_ATTACH_REG_INFO could be valid).
	CRString RITrailer( IDS_ATTACH_REG_INFO );
	CRString EITrailer( IDS_ATTACH_EUDORA_INFO );

	CRString RichTag( IDS_MIME_XRICH );
	CRString HTMLTag( IDS_MIME_XHTML );
	CRString HTML2Tag( IDS_MIME_HTML );
	CRString FlowedTag( IDS_MIME_XFLOWED );
	bool bHtml1 = false;
	bool bHtml1StartTag = false;
	const bool bHtmlInPlainText = GetIniShort(IDS_INI_HTML_IN_PLAIN_TEXT) != 0;

	CString  RichOn;
	CString  RichOff;
	CString  HtmlOn;
	CString  HtmlOff;
	CString	 Html2On;
	CString  Html2Off;
	CString  FlowedOn;
	CString  FlowedOff;

	CString  XRichExcerptOn = "<excerpt>";
	CString  XRichExcerptOff = "</excerpt>";
	int		 XRichExcerptOnLEN = 9;
	int		 XRichExcerptOffLEN = 10;
	int		 inXRichExcerpt = 0;
	const char* excerptPtr;
	char	*pHtml1, *pHtml2;

	RichOn.Format( "<%s>", ( const char* )RichTag );
	RichOff.Format( "</%s>", ( const char* )RichTag );
	HtmlOn.Format( "<%s", ( const char* )HTMLTag );	// can be <x-html content-base>
	HtmlOff.Format( "</%s>", ( const char* )HTMLTag );
	Html2On.Format( "<%s", ( const char* )HTML2Tag );	
	Html2Off.Format( "</%s>", ( const char* )HTML2Tag );
	FlowedOn.Format( "<%s>", ( const char* )FlowedTag );
	FlowedOff.Format( "</%s>", ( const char* )FlowedTag );

	CString  HtmlOnUpper(HtmlOn);
	CString  HtmlOffUpper(HtmlOff);
	CString	 Html2OnUpper(Html2On);
	CString  Html2OffUpper(Html2Off);

	//Get the tags in uppercase
	HtmlOnUpper.MakeUpper();
	HtmlOffUpper.MakeUpper();
	Html2OnUpper.MakeUpper();
	Html2OffUpper.MakeUpper();

	Body.Empty();

	// Preallocate enough space for the current text and some overhead
	Body.GetBuffer(strlen(Text) + 1024);

	CString Part;
	const char* PartStart = NULL;
		
	while (*pCurrent)
	{
		pLineStart = pNextLineStart;
		pNextLineStart = strchr( pCurrent, '\r' );

//FORNOW		//
//FORNOW		// If we ever decide to change our policy on sending HTML
//FORNOW		// "attachments" as inline data in the message body, then we'll
//FORNOW		// need the following code instead of the one-line strchr()
//FORNOW		// call above.  WKS 97.11.16
//FORNOW		//
//FORNOW		{
//FORNOW			int nEndLineIndex = strcspn( pCurrent, "\r\n" );
//FORNOW			if (nEndLineIndex)
//FORNOW				pNextLineStart = pCurrent + nEndLineIndex;
//FORNOW			else if (*pCurrent == '\r' || *pCurrent == '\n')
//FORNOW				pNextLineStart = pCurrent;
//FORNOW			else
//FORNOW				pNextLineStart = NULL;
//FORNOW		}

		if( pNextLineStart == NULL )
		{
			lLen = strlen( pCurrent );
			pNextLineStart = pCurrent + lLen;
		}
		else
		{
			lLen = pNextLineStart - pCurrent;
			// prepare for the next line -  skip '\r\n'
			if ( *pNextLineStart == '\r' || *pNextLineStart == '\n' ) pNextLineStart++;
			if ( *pNextLineStart == '\r' || *pNextLineStart == '\n' ) pNextLineStart++;
		}
		pStartNext = pNextLineStart;

		//Need to check if we are within excerpted text for etf msgs, since AC lines
		//should not be processed in such a case. Also the closing excerpt tags don't 
		//necessarily occur at the beginning of the line, so search thru the current line.
		if (PartType == IS_RICH) 
		{
			excerptPtr = pCurrent;
			while ((excerptPtr = strstr(excerptPtr, (LPCTSTR)XRichExcerptOn)) && (excerptPtr < pStartNext))
			{
				++inXRichExcerpt;
				excerptPtr += XRichExcerptOnLEN;
			}

			excerptPtr = pCurrent;
			while ((excerptPtr = strstr(excerptPtr, (LPCTSTR)XRichExcerptOff)) && (excerptPtr < pStartNext))
			{
				--inXRichExcerpt;
				excerptPtr += XRichExcerptOffLEN;
			}
		}

		if ( (PartType == IS_ASCII) && (pCurrent == pLineStart) &&
			 (strnicmp( ACTrailer, pCurrent, ACTrailer.GetLength()) == 0) )
		{
			// convert and add any existing body part
			AddToBody( Body, PartStart, pCurrent - PartStart, PartType, bAlwaysStripHTMLCode,
					   bStripDocumentLevelTags, bRelaxLocalFileRefStripping,
					   bConvertEmoticonTriggersToImageTags );
			PartStart = NULL;

			// morph the Attachment converted line into HTML
			szPath = CString( pCurrent + ACTrailer.GetLength(), lLen - ACTrailer.GetLength() );

			szPath.TrimLeft();
			szPath.TrimRight();

			// trim starting and ending quotes
			// this needs to be done carefully so that spoofed Attachment Converted: lines can't
			// have extra parameters to them that show one file name in the icon and a different
			// file that actually gets launched, which is done by finding the first quoted block.
			if( ( szPath.IsEmpty() == FALSE ) && ( szPath[ 0 ] == '"' ) )
			{
				szPath = szPath.Right( szPath.GetLength() - 1 );
			}

			if( szPath.IsEmpty() == FALSE )
			{
				int i = szPath.Find('"');
				if (i >= 0)
					szPath.ReleaseBuffer(i);
			}
			
			FindAttachment(szPath);

			AddAttachmentToBody(Body, szPath, ACTrailer);
		}
		else if ( (PartType == IS_ASCII) && (pCurrent == pLineStart) &&
				  (strnicmp(ECTrailer, pCurrent, ECTrailer.GetLength()) == 0) )
		{
			// embedded content lines get dropped - they should already
			// have a reference in the HTML
			// convert and add any existing body part
			AddToBody( Body, PartStart, pCurrent - PartStart, PartType, bAlwaysStripHTMLCode,
					   bStripDocumentLevelTags, bRelaxLocalFileRefStripping,
					   bConvertEmoticonTriggersToImageTags );
			PartStart = NULL;
		}
		else if ( (PartType == IS_ASCII) && (pCurrent == pLineStart) &&
				  (strnicmp(TFTrailer, pCurrent, TFTrailer.GetLength()) == 0) )
		{
			// convert and add any existing body part
			AddToBody( Body, PartStart, pCurrent - PartStart, PartType, bAlwaysStripHTMLCode,
					   bStripDocumentLevelTags, bRelaxLocalFileRefStripping,
					   bConvertEmoticonTriggersToImageTags );
			PartStart = NULL;

			// morph the Run Plugin: line into HTML
			// The format is "[path] <pluginID.TransID>"
			szPath = CString( pCurrent + TFTrailer.GetLength(), lLen - TFTrailer.GetLength() );

			szPath.TrimLeft();
			szPath.TrimRight();

			// trim ending and starting quotes
			if( ( szPath.IsEmpty() == FALSE ) && ( szPath[ szPath.GetLength() - 1 ] == '"' ) )
			{
				szPath.ReleaseBuffer( szPath.GetLength() - 1 );
			}

			if( ( szPath.IsEmpty() == FALSE ) && ( szPath[ 0 ] == '"' ) )
			{
				szPath = szPath.Right( szPath.GetLength() - 1 );
			}
	
			// Search for the end of the path
			int		leftAngleBracketPos = szPath.ReverseFind('<');		
			if (leftAngleBracketPos == -1)
			{
				// We didn't find what we expect, punt and move on
				Body += CString( pCurrent, lLen );
				pCurrent = pStartNext;
				continue;
			}

			// Separate the trans string from the path
			CString		szTrans = szPath.Right(szPath.GetLength() - leftAngleBracketPos);
			szPath.ReleaseBuffer(leftAngleBracketPos);
			szPath.TrimRight();
		
			// szPath now points at the path
			// get the basename
			iPos = szPath.ReverseFind( '\\' );
			
			if( iPos >= 0 )
			{
				szBase = szPath.Right( szPath.GetLength() - iPos - 1 );
			}
			else
			{
				szBase = szPath;
			}

			// Verify that the trans string looks right
			int pluginID = 0, translatorID = 0;
			if ( 2 != sscanf( szTrans, "<%04ld.%04ld>", &pluginID, &translatorID))
			{
				// We didn't find what we expect, punt and move on
				Body += CString( pCurrent, lLen );
				pCurrent = pStartNext;
				continue;
			}

			// extract the icon from the plugin
			HICON hIcon = NULL;
			CString IconPath;
			CString caption;
			CEudoraApp* pTheApp = (CEudoraApp*)AfxGetApp();
			CTranslator * theTranslator = 
				pTheApp->GetTranslators()->GetTranslator( pluginID, translatorID);
			if ( theTranslator )
			{
				theTranslator->GetIcon( hIcon );
				IconPath = IconToFile( hIcon );
				theTranslator->getDescription( caption );
			}

			// dynamic HTML here we come...
			Body += "<div>\r\n<a href=\"file://";
			Body += szPath;
			Body += ' ';
			Body += szTrans;
			Body += "\" EUDORA=PLUGIN";//-";
			Body += " >\r\n";
			if (IconPath.IsEmpty() == FALSE)
			{
				Body += "<img src=\"file://";
				Body += IconPath;
				Body += "\" alt=\"";
				Body += szPath;
				Body += "\"> ";
			}
			Body += szBase;
			Body += " </a>\r\n</div>\r\n";
		}
		else if ( PartType == IS_ASCII && (pCurrent == pLineStart) &&
				  ((strnicmp(EITrailer, pCurrent, EITrailer.GetLength()) == 0) ||
				   (strnicmp(RITrailer, pCurrent, RITrailer.GetLength()) == 0)) )
		{
			// convert and add any existing body part
			AddToBody( Body, PartStart, pCurrent - PartStart, PartType, bAlwaysStripHTMLCode,
					   bStripDocumentLevelTags, bRelaxLocalFileRefStripping,
					   bConvertEmoticonTriggersToImageTags );
			PartStart = NULL;
			
			// morph the Attachment converted line into HTML
			if (strnicmp(EITrailer, pCurrent, EITrailer.GetLength()) == 0)
				szPath = CString( pCurrent + EITrailer.GetLength(), lLen - EITrailer.GetLength() );
			else	// begins with RITrailer
				szPath = CString( pCurrent + RITrailer.GetLength(), lLen - RITrailer.GetLength() );

			szPath.TrimLeft();
			szPath.TrimRight();

			// trim ending and starting quotes
			if( ( szPath.IsEmpty() == FALSE ) && ( szPath[ szPath.GetLength() - 1 ] == '"' ) )
			{
				szPath.ReleaseBuffer( szPath.GetLength() - 1 );
			}

			if( ( szPath.IsEmpty() == FALSE ) && ( szPath[ 0 ] == '"' ) )
			{
				szPath = szPath.Right( szPath.GetLength() - 1 );
			}


			FindAttachment(szPath);

			CString szHREF = EscapeURL( CString("file://") + szPath );

			// szPath now points at the path
			// get the basename
			iPos = szPath.ReverseFind( '\\' );
				
			if( iPos >= 0 )
			{
				szBase = szPath.Right( szPath.GetLength() - iPos - 1 );
			}
			else
			{
				szBase = szPath;
			}

			// Get the associated icon
			HICON hIcon = QCLoadIcon(IDI_EUDORA_INFO_ATTACH);
			CString IconPath = IconToFile( hIcon );

			// dynamic HTML here we come...
			Body += "<div>\r\n<a href=\"";
			Body += szHREF;
			Body += "\" EUDORA=";
			Body += CRString(IDS_EUDORA_INFO);
			Body += ">\r\n";
			if (IconPath.IsEmpty() == FALSE)
			{
				Body += "<img src=\"file://";
				Body += IconPath;
				Body += "\" alt=\"";
				Body += szPath;
				Body += "\"> ";
			}
			Body += szBase;
			Body += " </a>\r\n</div>\r\n";
		}
		else if ( strnicmp( RichOn, pCurrent, RichOn.GetLength() ) == 0 )		// <x-rich>
		{
			AddToBody( Body, PartStart, pCurrent - PartStart, PartType, bAlwaysStripHTMLCode,
					   bStripDocumentLevelTags, bRelaxLocalFileRefStripping,
					   bConvertEmoticonTriggersToImageTags );
			PartStart = NULL;

			// <x-rich> And the message all comes on the same line
			PartType = IS_RICH;
			pStartNext = pCurrent + RichOn.GetLength();
			PartStart = pStartNext;
		}
		else if ( strnicmp( RichOff, pCurrent, RichOff.GetLength() ) == 0 )		// </x-rich>
		{
			// convert and add any existing body part
			AddToBody( Body, PartStart, pCurrent - PartStart, PartType, bAlwaysStripHTMLCode,
					   bStripDocumentLevelTags, bRelaxLocalFileRefStripping,
					   bConvertEmoticonTriggersToImageTags );
			PartStart = NULL;
			PartType = IS_ASCII;

			// </x-rich> And the message all comes on the same line
			pStartNext = pCurrent + RichOff.GetLength();
		}
		else if ( strnicmp( FlowedOn, pCurrent, FlowedOn.GetLength() ) == 0 )		// <x-flowed>
		{
			AddToBody( Body, PartStart, pCurrent - PartStart, PartType, bAlwaysStripHTMLCode,
					   bStripDocumentLevelTags, bRelaxLocalFileRefStripping,
					   bConvertEmoticonTriggersToImageTags );
			PartStart = NULL;

			// <x-flowed> is on a line all by itself
			// It used to come on the same line as the text, so account for that
			PartType = IS_FLOWED;
			pStartNext = pCurrent + FlowedOn.GetLength();
			if (*pStartNext == '\r')
				pStartNext++;
			if (*pStartNext == '\n')
				pStartNext++;
			PartStart = pStartNext;
		}
		else if ( strnicmp( FlowedOff, pCurrent, FlowedOff.GetLength() ) == 0 )	// </x-flowed>
		{
			// convert and add any existing body part
			AddToBody( Body, PartStart, pCurrent - PartStart, PartType, bAlwaysStripHTMLCode,
					   bStripDocumentLevelTags, bRelaxLocalFileRefStripping,
					   bConvertEmoticonTriggersToImageTags );
			PartStart = NULL;
			PartType = IS_ASCII;

			// </x-flowed> And the message all comes on the same line
			pStartNext = pCurrent + FlowedOff.GetLength();
		}
		else if ( (bHtml1 = (strnicmp( HtmlOn,	pCurrent, HtmlOn.GetLength()	)) == 0 ) ||		// <x-html>
							((pCurrent==Text||bHtmlInPlainText) && strnicmp( Html2On, pCurrent, Html2On.GetLength() ) == 0 ))		// <html>
		{
			AddToBody( Body, PartStart, pCurrent - PartStart, PartType, bAlwaysStripHTMLCode,
					   bStripDocumentLevelTags, bRelaxLocalFileRefStripping,
					   bConvertEmoticonTriggersToImageTags );
			PartStart = NULL;
			PartType = IS_HTML;

			// <x-html> And the message all comes on the same line
			if ( bHtml1 )
			{
				bHtml1StartTag = true;
				pStartNext = pCurrent + HtmlOn.GetLength();
			}
			else
			{
				pStartNext = pCurrent + Html2On.GetLength();
			}

			while( ( *pStartNext != '>' ) && ( *pStartNext != '\0' ) )
			{
				pStartNext++;
			}

			if( *pStartNext == '>' ) 
			{
				pStartNext++;
			}
			PartStart = pStartNext;
		}
		else 
		{
			pHtml1 = pHtml2 = NULL;

			//Set the pEnd char to NULL so we don't search beyond the current line
			//Remember to set it back again after the search is done in each case
			//Either this or check for the substring and check against pStartNext to
			//make sure we are dealing with the same line
			//Temporarily cast away the constness to do this, bad but it saves sone processing time.
			char temp = *pStartNext;
			*((char*)pStartNext) = '\0';

			if ( PartType == IS_HTML &&
					(((pHtml1 = const_cast<char *>(strstr( pCurrent, HtmlOff ))) || (pHtml1 = const_cast<char *>(strstr( pCurrent, HtmlOffUpper ))) ) ||	// </x-html>
					( (pHtml2 = const_cast<char *>(strstr( pCurrent, Html2Off ))) || (pHtml2 = const_cast<char *>(strstr( pCurrent, Html2OffUpper ))) ) ) )	// </html>
			{
				//Restore the char at the end of the line
				*((char *)pStartNext) = temp;

				// convert and add any existing body part
				if (pHtml1)
				{
					if (!bHtml1StartTag)
					{
						// Uh oh, found </x-html> without a starting <x-html>
						ASSERT(0);
					}
					else
					{
						AddToBody( Body, PartStart, pHtml1 - PartStart, PartType, bAlwaysStripHTMLCode,
								   bStripDocumentLevelTags, bRelaxLocalFileRefStripping,
								   bConvertEmoticonTriggersToImageTags );
						PartStart = NULL;
						PartType = IS_ASCII;
						bHtml1StartTag = false;
					}
				}
				else
				{
					// Let's wait for the ending </x-html> tag if we started with <x-html>
					if (!bHtml1StartTag)
					{
						AddToBody( Body, PartStart, pHtml2 - PartStart, PartType, bAlwaysStripHTMLCode,
								   bStripDocumentLevelTags, bRelaxLocalFileRefStripping,
								   bConvertEmoticonTriggersToImageTags );
						PartStart = NULL;
						PartType = IS_ASCII;
					}
				}

				// </x-html> And the message all comes on the same line 
				if ( pHtml1 )
					pStartNext = pHtml1 + HtmlOff.GetLength();
				else
					pStartNext = pHtml2 + Html2Off.GetLength();

				if (*pStartNext == '\r')
					pStartNext++;
				if (*pStartNext == '\n')
					pStartNext++;
			}
			else
			{
				//Restore the char at the end of the line
				*((char*)pStartNext) = temp;

				// must be PLAIN
				if ( ! PartStart )
					PartStart = pCurrent;
			}
		}

		pCurrent = pStartNext;
	}

	// convert and add any remaining body part
	if (PartStart)
	{
		AddToBody( Body, PartStart, pStartNext - PartStart, PartType, bAlwaysStripHTMLCode,
				   bStripDocumentLevelTags, bRelaxLocalFileRefStripping,
				   bConvertEmoticonTriggersToImageTags );
	}

	// Free any extra space that we might have because of the GetBuffer preallocation
	Body.FreeExtra();
}



void ConvertNBSPsToSpaces( char* szText )
{
	INT	i;

	for ( i = strlen( szText) - 1; i >= 0; i-- )
	{
		if( ( UCHAR )( szText[ i ] ) == 0xa0 )
		{
			szText[ i ] = ' ';
		}
	}
}


// StripAttachFromBody
// Strips the 'Attachment Converted' lines from the message
// Moved from summary.cpp for common access
BOOL StripAttachFromBody(char* message, UINT tag)
{
	if (!message)
	{
		ASSERT(0);
		return FALSE;
	}

	CRString szTag(tag);
	const char* InSpot = message;
	char* OutSpot = message;
	const char* pMatch = NULL;
	int SaveTextLen = 0;

	while (pMatch = strstr(InSpot, szTag))
	{
		const char* EndLine = strchr(pMatch, '\r');
		if (!EndLine)
			EndLine = pMatch + strlen(pMatch) - 1;
		else if (EndLine[1] == '\n')
			EndLine++;

		// Make sure it was only at the beginning of a line
		if (pMatch == InSpot || pMatch[-1] == '\n' || pMatch[-1] == '\r')
			SaveTextLen = pMatch - InSpot;
		else
		{
			//Could have been inside quoted text, usually a msg w/ attachment
			//replied to using Eudora 3.x or Light. 
			//Need to preserve it as part of quoted text.
			SaveTextLen = EndLine - InSpot;

			//Remember to grab the newline too
			if (*EndLine == '\n')
				SaveTextLen++;
		}

		if (InSpot == OutSpot)
		{
			// If first time, then nothing to copy because it's
			// already in the right spot in the buffer
			OutSpot += SaveTextLen;
		}
		else
		{
			strncpy(OutSpot, InSpot, SaveTextLen);
			OutSpot += SaveTextLen;
		}

		//*OutSpot = 0;
		
		InSpot = EndLine + 1;
	}

	if (OutSpot != message)
		strcpy(OutSpot, InSpot);

	return TRUE;
}


CString StripNonPreviewHeaders(const char* Message)
{
	CUIntArray	HeaderStartArray;
	const char* PreviewHeadersList = GetIniString(IDS_INI_PREVIEW_HEADERS);
	CString PreviewHeaders;
	const UINT MaxLinesPerHeader = GetIniShort(IDS_INI_PREVIEW_HEADERS_MAX_LINES);

	if (!Message || !PreviewHeadersList)
		return PreviewHeaders;

	// Build up list that contains start of each header in the PreviewHeaders list
	const char* CurrentHeader = PreviewHeadersList;
	while (1)
	{
		HeaderStartArray.Add(CurrentHeader - PreviewHeadersList);
		const char* Comma = strchr(CurrentHeader, ',');
		if (!Comma)
		{
			// Add end of list marker for calculating string lengths below
			HeaderStartArray.Add(CurrentHeader - PreviewHeadersList + strlen(CurrentHeader));
			break;
		}
		CurrentHeader = Comma + 1;
	}

	PreviewHeaders.GetBuffer(256);	// Trick to prevent lots of little buffer allocations
	int PreviewHeadersListSize = HeaderStartArray.GetSize();
	const char* EndHeader = Message;
	for (; *Message && *Message != '\r'; Message = EndHeader + 1)
	{
		BOOL bIncludeIt = FALSE;
		const char* Colon = strchr(Message, ':');
		if (!Colon)
			break;

		if (MaxLinesPerHeader > 0)
		{
			int HeaderLen = Colon - Message + 1;
			for (int i = 0; i < PreviewHeadersListSize - 1; i++)
			{
				int PreviewHeaderLen = HeaderStartArray[i + 1] - HeaderStartArray[i] - 1;
				if (PreviewHeaderLen <= HeaderLen)
				{
					if (strnicmp(Message, PreviewHeadersList + HeaderStartArray[i], PreviewHeaderLen) == 0)
					{
						const char* HeaderContents = Colon + 1;
						while (*HeaderContents == ' ' || *HeaderContents == '\t')
							HeaderContents++;

						if (*HeaderContents && *HeaderContents != '\r' && *HeaderContents != '\n')
							bIncludeIt = TRUE;
						break;
					}
				}
			}
		}

		// Collect at most MaxLinesPerHeader lines of the header
		EndHeader = Colon;
		UINT LinesLeftToInclude = MaxLinesPerHeader;
		const char* EndInclude = EndHeader;
		do
		{
			EndHeader = strchr(EndHeader + 1, '\n');
			if (!EndHeader)
				EndHeader = Colon + strlen(Colon) - 1;
			if (LinesLeftToInclude > 0)
			{
				LinesLeftToInclude--;
				EndInclude = EndHeader;
			}
		} while (EndHeader[1] == ' ' || EndHeader[1] == '\t');

		if (bIncludeIt)
		{
			// Hack to prevent extra memory allocation
			char SaveChar = EndInclude[1];
			((char*)EndInclude)[1] = 0;
			PreviewHeaders += Message;
			((char*)EndInclude)[1] = SaveChar;

			// Ensure ending newline
			if (*EndInclude != '\n')
				PreviewHeaders += "\r\n";
		}

		Message = EndHeader + 1;
	}

	return PreviewHeaders;
}


// Function to handle & make sure that attachments are indeed present in the directory specified by user 
// if the default directory is not used. 
// The sequence is :
//	1> Check if the path user specified has the file
//	2> Check if the path user has specified in the attachment (Tools->options) contains the file
//	3> Check if the default attachment path (Eudora installation Directory\Attach) has the file
// If found in either one of cases then return TRUE & modify the csAttachment to reflect the new dir, else return FALSE

BOOL FindAttachment(CString &csAttachment)
{
	// Make sure that the attachment name isn't too long (avoids buffer overflow reported
	// by Paul Szabo). This may not strictly be necessary because we now use CStrings below
	// and FileExistsMT doesn't seem to mind, but for now I want to make sure this bug is
	// definitely fixed (plus many other locations in Eudora limit paths to MAX_PATH).
	if (csAttachment.GetLength() < MAX_PATH)
	{
		const char* Filename = strrchr((LPCTSTR) csAttachment, '\\');
		if (Filename)
		{
			if ( !FileExistsMT(csAttachment) )
			{
				// Use CStrings so that we don't need to worry about buffer overflow from
				// long file name combined with directory name. Also allows us to lift the
				// MAX_PATH maximum length restriction later if we so choose.
				CString		NewLocation;
				CString		AutoReceiveDir;

				GetIniString(IDS_INI_AUTO_RECEIVE_DIR, AutoReceiveDir);

				if ( !AutoReceiveDir.IsEmpty() )
				{
					NewLocation = AutoReceiveDir;
					NewLocation += Filename;

					if ( (NewLocation.GetLength() < MAX_PATH) && FileExistsMT(NewLocation) )
					{
						csAttachment = NewLocation;
						return TRUE;
					}
				}

				NewLocation = EudoraDir;
				NewLocation += CRString(IDS_ATTACH_FOLDER);
				NewLocation += Filename;
				
				if ( (NewLocation.GetLength() < MAX_PATH) && FileExistsMT(NewLocation) )
				{
					csAttachment = NewLocation;
					return TRUE;
				}
			}
			else
				return TRUE;
		}	
	}
	
	return FALSE;
}


//	Moved from MimeStorage.cpp for common use.
int GetAttachments(
	const char *		in_szMessage,
	CString &			out_szAttachments)
{
	CRString		szACTrailer( IDS_ATTACH_CONVERTED );
	int				nAttachments = 0;
	
	out_szAttachments.Empty();

	if (in_szMessage)
	{
		const char *	pLine = in_szMessage;
		const char *	pEndLine;
		CString			szExcerptOn = "<excerpt>";
		CString			szExcerptOff = "</excerpt>";
		int				nExcerptLevel = 0;

		while (*pLine)
		{
			// prepare for the next line
			pEndLine = strchr(pLine, '\r');
			if (pEndLine)
				pEndLine--;
			else
				pEndLine = pLine + strlen(pLine) - 1;

			if ( strnicmp( szExcerptOn, pLine, szExcerptOn.GetLength()) == 0 )
				nExcerptLevel++;
			if ( strnicmp( szExcerptOff, pLine, szExcerptOff.GetLength()) == 0 )
				nExcerptLevel--;

			if ( ( strnicmp( szACTrailer, pLine, szACTrailer.GetLength()) == 0 ) && (nExcerptLevel == 0) )
			{
				// extract path
				const char * pPath = pLine + szACTrailer.GetLength();
				while ( *pPath == ' ' || *pPath == '"' )
					pPath++;

				// pPath now points at the path
				const char *	pEnd = pEndLine;
				if ( *pEnd == '"')
					pEnd--;

				// add the path to the return CString
				if ( !out_szAttachments.IsEmpty() )
					out_szAttachments += "; ";

				// Little trick here of temporarily creating a null-terminated string
				// out of the line in order to save on an extra memory allocation
				char		cSaveChar = pEnd[1];
				const_cast<char *>(pEnd)[1] = 0;
				out_szAttachments += pPath;
				const_cast<char *>(pEnd)[1] = cSaveChar;

				nAttachments++;
			}

			pLine = pEndLine + 1;
			if (*pLine == '\r')
				pLine++;
			if (*pLine == '\n')
				pLine++;
		}
	}

	return nAttachments;
}



//
// BEFUND E-88: das Original-HTML unangetastet aufheben und beim Senden
// wieder einsetzen.
//
// Warum ueberhaupt: verfasst wird mit Paige. Dessen HTML-Leser kennt keine
// einzige CSS-Eigenschaft (PGHTMDEF.C:20-48) und wertet aus <div> allein
// align aus. Alles, was eine Nachricht an Kaesten, Hintergruenden und per
// CSS gesetzten Bildgroessen mitbringt, ist nach dem Weg durch den Editor
// endgueltig fort - und zwar nicht nur in der Anzeige, sondern in dem Text,
// den PgMsgView::ExportMessage ueber pDoc->SetText() zum Rumpf der
// Nachricht macht. Genau dieser Rumpf geht spaeter per SMTP hinaus
// (sendmail.cpp:3368).
//
// Was hier passiert: beim Antworten und Weiterleiten legt
// CSummary::ComposeMessage den Rumpf, wie QuoteText ihn gebaut hat, im
// Verfassendokument ab (CCompMessageDoc::m_szE88OriginalHTML). Beim
// Speichern und damit vor jedem Absenden wird geprueft, ob der Klartext
// dieses Originals im Klartext der Editorfassung als ein zusammenhaengendes
// Stueck wiederzufinden ist. Ist er das, geht das Original unveraendert
// hinaus, davor und dahinter das, was der Anwender selbst geschrieben hat.
// Ist er es nicht, bleibt alles beim alten.
//
// Die Wahl des Verfahrens ist in der Commit-Nachricht begruendet. Kurz: der
// Vergleich ist zustandslos - er braucht kein Merken eines frueheren
// Zustandes, keine Aenderungszaehler und keine Annahme darueber, wo der
// Anwender tippt. Findet er das Original nicht, faellt er auf das alte
// Verhalten zurueck; er kann also nichts kaputt machen, was heute heil ist.
//
// Abschalten mit ForwardOriginalHTML=0 in [Settings].
//

//
// E88NurText: aus HTML den blanken Vergleichstext gewinnen.
//
// Absichtlich grob. Der Text dient nur dem Vergleich, nicht der Anzeige.
// Alles, was Paige beim Ein- und Auslesen umformen koennte, wird gleich
// behandelt und damit unschaedlich:
//   - Markierungen <...> fallen weg, samt allem in <script>/<style>
//   - Entitaeten (&nbsp;, &auml;, &#228;) werden zu einem Fragezeichen
//   - jedes Zeichen ueber 127 wird zu einem Fragezeichen
//   - jede Folge von Leerraum wird zu einem einzelnen Leerzeichen
// Die letzten beiden Regeln sind der Grund, warum der Vergleich ueberhaupt
// aufgeht: Paige schreibt Umlaute mal als Zeichen, mal als Entitaet, und es
// bricht Zeilen anders um als das Original.
//
static void E88NurText( const char* pszHtml, CString& out_szText )
{
	out_szText.Empty();
	if (!pszHtml)
		return;

	int			nLen = (int) strlen(pszHtml);
	char*		pBuf = DEBUG_NEW_NOTHROW char[nLen + 1];
	if (!pBuf)
		return;

	char*		q = pBuf;
	bool		bLetzterWarLeer = true;		// fuehrenden Leerraum verschlucken

	for (int i = 0; i < nLen; )
	{
		unsigned char	c = (unsigned char) pszHtml[i];

		if (c == '<')
		{
			// Markierung ueberspringen. Ist sie nie geschlossen, ist der
			// Rest der Zeichenkette eine Markierung - das ist dasselbe
			// Ergebnis, das ein Empfaenger saehe.
			const char*		pEnde = strchr(pszHtml + i, '>');
			if (!pEnde)
				break;
			i = (int)(pEnde - pszHtml) + 1;
			continue;
		}

		if (c == '&')
		{
			// Entitaet ueberspringen, wenn sie kurz genug ist, um eine zu sein
			const char*		pSemi = strchr(pszHtml + i, ';');
			if (pSemi && (pSemi - (pszHtml + i)) <= 10)
			{
				i = (int)(pSemi - pszHtml) + 1;
				c = '?';		// faellt unten in den Normalfall
			}
			else
			{
				c = '?';
				i++;
			}

			*q++ = (char) c;
			bLetzterWarLeer = false;
			continue;
		}

		i++;

		if (c == ' ' || c == '\t' || c == '\r' || c == '\n')
		{
			if (!bLetzterWarLeer)
			{
				*q++ = ' ';
				bLetzterWarLeer = true;
			}
			continue;
		}

		if (c > 127)
			c = '?';

		*q++ = (char) c;
		bLetzterWarLeer = false;
	}

	// abschliessenden Leerraum abschneiden
	while (q > pBuf && *(q - 1) == ' ')
		q--;

	*q = 0;
	out_szText = pBuf;
	delete [] pBuf;
}


//
// E88OriginalEinsetzen
//
// Rueckgabe: true, wenn out_szNeuerRumpf gefuellt wurde und an die Stelle
// der Editorfassung treten soll. false heisst: alles beim alten lassen.
//
// out_szSpur bekommt in jedem Fall eine Zeile fuer das Protokoll - auch
// wenn nichts ersetzt wird. Ohne diese Zeile merkte niemand, dass eine
// Nachricht anders hinausgeht, als das Verfassenfenster sie zeigt.
//
bool E88OriginalEinsetzen(
		const char*			pszOriginalHtml,
		const char*			pszEditorText,
		char				cAntwortTyp,
		bool				bAnwenderHatGetippt,
		CString&			out_szNeuerRumpf,
		CString&			out_szSpur )
{
	out_szNeuerRumpf.Empty();

	const int	nOrigLen   = pszOriginalHtml ? (int) strlen(pszOriginalHtml) : 0;
	const int	nEditorLen = pszEditorText   ? (int) strlen(pszEditorText)   : 0;
	const int	nSchalter  = (int) GetIniShort(IDS_INI_FORWARD_ORIGINAL_HTML);

	// Der eine Ort, an dem alles zusammenkommt. Erst am Ende ergaenzt um
	// das Urteil - siehe die Zuweisungen an szUrteil.
	CString		szUrteil;

	if (!nSchalter)
		szUrteil = "EDITOR (Schalter aus)";
	else if (nOrigLen == 0)
		szUrteil = "EDITOR (kein Original gemerkt)";
	else if (nEditorLen == 0)
		szUrteil = "EDITOR (Editorfassung leer)";
	else if (::IsFancy(pszOriginalHtml) != IS_HTML)
		szUrteil = "EDITOR (Original ist kein HTML)";

	CString		szOrigText, szEditorText;
	int			nFund = -1;
	int			nVorLen = 0, nNachLen = 0;

	if (szUrteil.IsEmpty())
	{
		E88NurText(pszOriginalHtml, szOrigText);
		E88NurText(pszEditorText,   szEditorText);

		// Ein sehr kurzes Original koennte zufaellig irgendwo stecken.
		// Unter 40 Zeichen Klartext ist der Vergleich nichts wert.
		if (szOrigText.GetLength() < 40)
			szUrteil = "EDITOR (Original zu kurz zum Vergleichen)";
		else
		{
			nFund = szEditorText.Find(szOrigText);
			if (nFund < 0)
			{
				//
				// Der Klartext des Originals steckt nicht als ein Stueck in
				// der Editorfassung. Bis zum 14.09.2026 hiess das immer
				// "der Anwender hat im Zitat geaendert", und die magere
				// Editorfassung ging hinaus.
				//
				// GEMESSEN AN GREGORS LAUF mit 1.0.58, beim Weiterleiten
				// einer bereits weitergeleiteten Nachricht (Fw: Fw:):
				//
				//   Fassung=EDITOR (Anwender hat im Zitat geaendert)
				//   OrigBytes=105125 EditorBytes=17889 Fundstelle=-1
				//
				// Er hatte nichts geaendert. Hinaus gingen trotzdem 17889
				// statt 105125 Byte - 83 Prozent des Inhalts fehlten, und
				// niemand haette es gemerkt. Bei verschachtelten Zitaten
				// baut Paige den Text so um, dass der Vergleich ins Leere
				// greift.
				//
				// Deshalb zaehlt jetzt zuerst, ob der Anwender ueberhaupt
				// etwas getippt hat. Paige fuehrt darueber Buch
				// (CPaigeEdtView::HasChanged, PaigeEdtView.h:193). Hat er
				// nichts angefasst, gibt es nichts zu schuetzen, und das
				// Original geht hinaus - ohne Zusatz davor, denn es gibt
				// keinen.
				//
				// Die Regel kann nur helfen, nie schaden: sie greift
				// ausschliesslich, wenn nachweislich nicht getippt wurde.
				// Im Zweifel bleibt es bei der bisherigen Entscheidung.
				//
				if (bAnwenderHatGetippt)
					szUrteil = "EDITOR (Anwender hat im Zitat geaendert)";
				else
				{
					nFund    = 0;
					nVorLen  = 0;
					nNachLen = 0;
				}
			}
			else
			{
				nVorLen  = nFund;
				nNachLen = szEditorText.GetLength() - nFund - szOrigText.GetLength();
			}
		}
	}

	bool	bErsetzt = false;

	if (szUrteil.IsEmpty())
	{
		//
		// Das Original steckt unveraendert in der Editorfassung. Es geht
		// hinaus, wie es war; davor und dahinter kommt das, was der
		// Anwender selbst geschrieben hat.
		//
		// Bewusste Einschraenkung: sein eigener Zusatz geht als Klartext
		// hinaus, nicht mit seiner Auszeichnung. Ihn aus dem Editor-HTML
		// herauszuschneiden hiesse, an einer geratenen Stelle in fremde
		// Markierungen zu schneiden - und ein halb offener Kasten kann den
		// ganzen Rest der Nachricht verschlucken. Klartext kann das nicht.
		//
		CString		szVor, szNach;

		if (nVorLen > 0)
			szVor = szEditorText.Left(nVorLen);
		if (nNachLen > 0)
			szNach = szEditorText.Right(nNachLen);

		szVor.TrimLeft();
		szNach.TrimRight();

		// Das Original ist bereits ein vollstaendiges <x-html>-Stueck.
		// Der Zusatz muss deshalb hinein, nicht davor.
		CString		szOrig(pszOriginalHtml);
		int			nAuf = -1;

		if (!szVor.IsEmpty() || !szNach.IsEmpty())
		{
			// erste schliessende Klammer der ersten Markierung suchen
			if (szOrig.GetLength() > 0 && szOrig[0] == '<')
				nAuf = szOrig.Find('>');
		}

		if (nAuf < 0)
		{
			// Kein Platz zum Einsetzen gefunden: dann nur dann ersetzen,
			// wenn es gar nichts einzusetzen gibt.
			if (szVor.IsEmpty() && szNach.IsEmpty())
			{
				out_szNeuerRumpf = szOrig;
				bErsetzt = true;
				szUrteil = "ORIGINAL (unveraendert)";
			}
			else
				szUrteil = "EDITOR (kein Platz fuer den Zusatz)";
		}
		else
		{
			CString		szVorHtml, szNachHtml;

			if (!szVor.IsEmpty())
				szVorHtml = Text2Html(szVor, TRUE, FALSE) + "<br>";
			if (!szNach.IsEmpty())
				szNachHtml = CString("<br>") + Text2Html(szNach, TRUE, FALSE);

			int		nSchluss = szOrig.ReverseFind('<');
			if (!szNachHtml.IsEmpty() && nSchluss > nAuf)
				szOrig = szOrig.Left(nSchluss) + szNachHtml + szOrig.Mid(nSchluss);
			else if (!szNachHtml.IsEmpty())
				szOrig += szNachHtml;

			out_szNeuerRumpf = szOrig.Left(nAuf + 1) + szVorHtml + szOrig.Mid(nAuf + 1);
			bErsetzt = true;
			szUrteil = "ORIGINAL (mit Zusatz)";
		}
	}

	//
	// Alle Werte in EINER Zeile. Getrennte Zeilen lassen immer die Ausrede
	// offen, sie seien zu anderer Zeit entstanden.
	//
	out_szSpur.Format(
		"E-88 vor dem Absenden: Fassung=%s Schalter=%d OrigBytes=%d EditorBytes=%d "
		"NeuBytes=%d ZusatzVor=%d ZusatzNach=%d Fundstelle=%d Typ=%d getippt=%d",
		(LPCTSTR) szUrteil, nSchalter, nOrigLen, nEditorLen,
		out_szNeuerRumpf.GetLength(), nVorLen, nNachLen, nFund, (int) cAntwortTyp,
		bAnwenderHatGetippt ? 1 : 0 );

	return bErsetzt;
}


//
// BEFUND E-89: im Verfassenfenster liegen die Bilder ueber dem Text.
//
// Gregor an 1.0.56: "1 und da ist alles durcheinander, man kann ja nichts
// lesen." Auf seinem Bildschirmfoto liegt das Doctolib-Logo ueber der
// Ueberschrift, die App-Store-Kacheln liegen ueber einem Absatz. Als
// Massstab hat er Thunderbird genannt: dessen Verfassenfenster ist auch
// nicht huebsch - es zeichnet rote Hilfslinien um jede Tabellenzelle -,
// aber nichts ueberlappt, und jeder Satz ist lesbar. Genau diese Schwelle
// ist hier das Ziel, nicht Thunderbirds Aussehen: Paige uebersetzt HTML in
// ein eigenes Format und kennt keine einzige CSS-Eigenschaft
// (PGHTMDEF.C:20-48), Thunderbird rechnet mit einer echten HTML-Maschine.
//
// WARUM DAS UEBERHAUPT GEHT, ohne etwas kaputtzumachen: seit E-88 geht beim
// Senden das aufgehobene Original hinaus, nicht die Editorfassung. Das
// Verfassenfenster ist damit nur noch Arbeitsflaeche. Es muss nicht schoen
// sein und dem Original nicht gleichen - es muss lesbar sein.
//
// ZWEI URSACHEN, beide gemessen und nicht vermutet:
//
// (1) KEINE AUSWERTBARE GROESSE. Paiges HTML-Leser holt die Bildgroesse
// ausschliesslich aus den Attributen width und height
// (PGHTMIMP.CPP:2019-2022, image_width_attribute / image_height_attribute).
// Steht die Groesse nur im CSS - style="width:16px" -, bleiben source_width
// und source_height auf 0. Was dann passiert, steht in
// PgEmbeddedImage.cpp:424-427: die Masse werden beim Laden aus der
// Bilddatei nachgetragen, also die ORIGINALGROESSE. Weil das erst beim
// Laden geschieht, war der Absatz da schon umbrochen;
// PgEmbeddedImage.cpp:458-507 versucht die Stelle nachtraeglich
// wiederzufinden - ueber embed->style == embed_ptr->style, was beim ersten
// Bild gleichen Stils stehenbleibt und bei mehreren Bildern die falsche
// Stelle trifft. Das ist das Uebereinanderliegen.
//
// (2) AUSWERTBAR, ABER ZU BREIT. Gregors zweites Thunderbild-Bild
// (freenet/audibene-Rundbrief) zeigt dasselbe Kopflogo im schmalen
// Verfassenfenster schmal und in der breiteren Leseansicht breiter -
// proportional auf die verfuegbare Spaltenbreite gerechnet. Ein Bild mit
// width="1200" sprengt die Zeile auch dann, wenn Paige die Zahl lesen
// kann. Der Massstab ist also nicht "Originalgroesse vermeiden", sondern
// "nie breiter als der verfuegbare Raum".
//
// WARUM EIN FESTER DECKEL UND KEINE ECHTE FENSTERBREITE - gemessen, nicht
// vermutet: umgeschrieben wird in CSummary::ComposeMessage, und der Aufruf
// dort geht mit in_bDisplayOrQueueImmediately = kDontDisplayOrQueue
// (summary.h:142) hinein. Beide Zweige, die ein Fenster erzeugen koennten,
// haengen an dieser Bedingung (summary.cpp:1818-1837) - zum Zeitpunkt der
// Umschrift existiert das Verfassenfenster noch nicht. Ein gespeichertes
// Mass gibt es auch nicht: unter den INI-Schluesseln steht keiner fuer die
// Groesse eines Verfassenfensters (EudoraRes.rc). Es bleibt ein fester,
// grosszuegiger Deckel - besser als gar keiner, und Hoehe und Breite
// werden gemeinsam gerechnet, damit nichts verzerrt.
//
// GEMESSEN an Gregors gesicherten Postfaechern (alle .mbx unter
// C:\Users\Gregor\Eudora72-Postfaecher-gesichert, Stand 14.09.2026):
// 2884 <img> insgesamt, davon 2601 mit Attribut, 122 nur mit CSS-Groesse
// und 161 ganz ohne Groessenangabe. Ursache (1) trifft die letzten beiden
// Gruppen, Ursache (2) kann jede der drei treffen.
//
// WARUM NICHT DER PLATZHALTER (das Bild durch "[Bild]" ersetzen): das waere
// radikaler und sicherer lesbar, aber es wuerde E-88 zerstoeren.
// E88OriginalEinsetzen vergleicht den Klartext des Originals mit dem
// Klartext der Editorfassung und verlangt, dass er darin als EIN
// zusammenhaengendes Stueck steckt. E88NurText wirft Markierungen weg -
// ein geaendertes width=... innerhalb einer Markierung aendert am
// Vergleichstext also nichts, ein eingefuegtes "[Bild]" dagegen zerreisst
// ihn mitten im Zitat, und das Original ginge nie wieder hinaus. Nur der
// Weg ueber die Attribute geht mit E-88 zusammen.
//
// WAS NICHT ANGETASTET WIRD: ein Bild, das width und height als Attribut
// traegt und unter dem Deckel bleibt, bleibt Zeichen fuer Zeichen wie es
// ist - das sind die meisten. src bleibt in jedem Fall unberuehrt, damit
// eingebettete cid:-Teile weiter gefunden werden.
//
// WO ES WIRKT: allein auf der Fassung, die CSummary::ComposeMessage in den
// Editor gibt. Das Original fuer E-88 wird an derselben Stelle, aber aus
// der UNVERAENDERTEN Zeichenkette gemerkt.
//

// Der Deckel. Kein Bild darf im Editor breiter oder hoeher werden; wird es
// gedeckelt, geht das andere Mass im selben Verhaeltnis mit. 600 Bildpunkte
// sind grosszuegig gewaehlt: schmaler als jedes brauchbare Fenster soll die
// Arbeitsflaeche nicht wirken, und wer breiter zieht, verliert nichts, was
// hinausgeht.
#define E89_MAX_BREITE		600
#define E89_MAX_HOEHE		600

// Vorgabemasse fuer ein Bild, dessen Groesse nirgends steht. Hier gibt es
// nichts zu rechnen - weder Originalgroesse noch Seitenverhaeltnis sind
// bekannt, und nachgeladen wird beim Verfassen nichts. Die Hoehe ist die
// wichtige Zahl: sie bestimmt, wie weit der Zeilenabstand aufreisst, und
// damit die Lesbarkeit.


//
// E89ZahlLesen: fuehrende Zahl einer Laengenangabe holen.
//
// Erkannt werden "120", "120px", "120pt", "120.0px" und "100%"; alles
// andere ("auto", "3em", "calc(...)", leer) liefert 0. Lieber die Vorgabe
// als eine falsche Zahl.
//
static int E89ZahlLesen( const char* pszWert, bool& out_bProzent )
{
	out_bProzent = false;

	if (!pszWert)
		return 0;

	const char*		r = pszWert;

	while (*r == ' ' || *r == '\t')
		r++;

	if (*r < '0' || *r > '9')
		return 0;

	int		nWert = 0;
	while (*r >= '0' && *r <= '9')
	{
		if (nWert < 100000)
			nWert = nWert * 10 + (*r - '0');
		r++;
	}
	if (*r == '.')
	{
		r++;
		while (*r >= '0' && *r <= '9')
			r++;
	}
	while (*r == ' ' || *r == '\t')
		r++;

	if (*r == '%')
	{
		out_bProzent = true;
		return nWert;
	}
	if (_strnicmp(r, "px", 2) == 0 || _strnicmp(r, "pt", 2) == 0)
		return nWert;
	if (*r == ';' || *r == 0)
		return nWert;		// blanke Zahl - HTML will sie so, CSS verlangt
							// eine Einheit, aber Absender schreiben sie weg

	return 0;
}


//
// E89CssMass: aus einem style="..."-Wert die Laenge zu einer Eigenschaft holen.
//
// Der Name muss am Anfang einer Eigenschaft stehen, sonst ginge "max-width"
// als "width" durch.
//
static int E89CssMass( const char* pszStyle, const char* pszName, bool& out_bProzent )
{
	out_bProzent = false;

	if (!pszStyle || !*pszStyle || !pszName)
		return 0;

	const int	nNameLen = (int) strlen(pszName);

	for (const char* p = pszStyle; *p; p++)
	{
		if (_strnicmp(p, pszName, nNameLen) != 0)
			continue;

		// Davor darf nur Leerraum stehen, und davor ein ';' oder der Anfang.
		const char*		q = p;
		while (q > pszStyle && (q[-1] == ' ' || q[-1] == '\t' || q[-1] == '\r' || q[-1] == '\n'))
			q--;
		if (q != pszStyle && q[-1] != ';')
			continue;

		// Hinter dem Namen muss ein Doppelpunkt kommen.
		const char*		r = p + nNameLen;
		while (*r == ' ' || *r == '\t')
			r++;
		if (*r != ':')
			continue;
		r++;

		return E89ZahlLesen(r, out_bProzent);
	}

	return 0;
}


//
// E89Attribut: ein HTML-Attribut im Bereich zwischen "<img" und ">" finden.
//
// Rueckgabe true, wenn das Attribut da ist - auch dann, wenn sein Wert leer
// ist. out_nVon/out_nBis (beide duerfen NULL sein) umschliessen das ganze
// Attribut samt Namen, Gleichheitszeichen und Anfuehrungszeichen; damit
// laesst es sich beim Neuschreiben der Markierung herausnehmen.
//
static bool E89Attribut( const char* pszAttrs, int nLen, const char* pszName,
						 CString& out_szWert, int* out_nVon, int* out_nBis )
{
	out_szWert.Empty();
	if (out_nVon) *out_nVon = -1;
	if (out_nBis) *out_nBis = -1;

	const int	nNameLen = (int) strlen(pszName);
	int			i = 0;

	while (i < nLen)
	{
		// Leerraum vor dem naechsten Namen
		while (i < nLen && (pszAttrs[i] == ' ' || pszAttrs[i] == '\t' ||
							pszAttrs[i] == '\r' || pszAttrs[i] == '\n' ||
							pszAttrs[i] == '/'))
			i++;
		if (i >= nLen)
			break;

		const int	nAnfang = i;

		while (i < nLen && pszAttrs[i] != '=' && pszAttrs[i] != ' ' &&
			   pszAttrs[i] != '\t' && pszAttrs[i] != '\r' && pszAttrs[i] != '\n' &&
			   pszAttrs[i] != '/')
			i++;

		const bool	bTreffer = ( (i - nAnfang) == nNameLen &&
								 _strnicmp(pszAttrs + nAnfang, pszName, nNameLen) == 0 );
		const int	nNameEnde = i;

		while (i < nLen && (pszAttrs[i] == ' ' || pszAttrs[i] == '\t' ||
							pszAttrs[i] == '\r' || pszAttrs[i] == '\n'))
			i++;

		if (i < nLen && pszAttrs[i] == '=')
		{
			i++;
			while (i < nLen && (pszAttrs[i] == ' ' || pszAttrs[i] == '\t' ||
								pszAttrs[i] == '\r' || pszAttrs[i] == '\n'))
				i++;

			int		nWertAnfang, nWertEnde;

			if (i < nLen && (pszAttrs[i] == '"' || pszAttrs[i] == 0x27))
			{
				const char	cQuote = pszAttrs[i];
				i++;
				nWertAnfang = i;
				while (i < nLen && pszAttrs[i] != cQuote)
					i++;
				nWertEnde = i;
				if (i < nLen)
					i++;			// schliessendes Anfuehrungszeichen
			}
			else
			{
				nWertAnfang = i;
				while (i < nLen && pszAttrs[i] != ' ' && pszAttrs[i] != '\t' &&
					   pszAttrs[i] != '\r' && pszAttrs[i] != '\n')
					i++;
				nWertEnde = i;
			}

			if (bTreffer)
			{
				out_szWert = CString(pszAttrs + nWertAnfang, nWertEnde - nWertAnfang);
				if (out_nVon) *out_nVon = nAnfang;
				if (out_nBis) *out_nBis = i;
				return true;
			}
		}
		else if (bTreffer)
		{
			// Attribut ohne Wert, etwa <img ... ismap>
			if (out_nVon) *out_nVon = nAnfang;
			if (out_nBis) *out_nBis = nNameEnde;
			return true;
		}
	}

	return false;
}


//
// E89BilderMessbarMachen
//
// Liefert in out_szHtml dieselbe Nachricht, in der jedes <img> eine
// Groesse traegt, die Paige lesen kann und die unter dem Deckel bleibt.
// Rueckgabe: true, wenn wirklich etwas geaendert wurde - nur dann ist
// out_szHtml gefuellt.
//
// out_szSpur bekommt in jedem Fall eine Zeile fuer das Protokoll. Alle
// Zahlen stehen in DERSELBEN Zeile: getrennte Zeilen lassen immer die
// Ausrede offen, sie seien zu anderer Zeit entstanden.
//
bool E89BilderMessbarMachen( const char* pszHtml, CString& out_szHtml, CString& out_szSpur )
{
	out_szHtml.Empty();

	int		nBilder = 0;		// <img> insgesamt
	int		nSchonGut = 0;		// unveraendert gelassen
	int		nAusCss = 0;		// mindestens ein Mass aus style="..." geholt
	int		nEingebettet = 0;	// cid: oder data: - Paige kennt die Groesse
	int		nOhneMass = 0;		// kein Mass bekannt - Bild unangetastet gelassen
	int		nGedeckelt = 0;		// war breiter oder hoeher als der Deckel

	const int	nLen = pszHtml ? (int) strlen(pszHtml) : 0;

	if (nLen == 0)
	{
		out_szSpur = "E-89 Bilder im Editor: nichts zu tun (leerer Rumpf)";
		return false;
	}

	CString		szAus;
	int			i = 0;
	int			nKopiertAb = 0;

	while (i < nLen)
	{
		if (pszHtml[i] != '<')
		{
			i++;
			continue;
		}

		// "<img", gefolgt von Leerraum, '/' oder '>'
		if (_strnicmp(pszHtml + i, "<img", 4) != 0)
		{
			i++;
			continue;
		}

		const char	cNach = (i + 4 < nLen) ? pszHtml[i + 4] : 0;
		if (cNach != ' ' && cNach != '\t' && cNach != '\r' && cNach != '\n' &&
			cNach != '/' && cNach != '>')
		{
			i++;
			continue;
		}

		// Ende der Markierung suchen, Anfuehrungszeichen dabei achten -
		// ein '>' in einem alt-Text darf die Markierung nicht beenden.
		int		j = i + 4;
		char	cQuote = 0;

		while (j < nLen)
		{
			const char	c = pszHtml[j];

			if (cQuote)
			{
				if (c == cQuote)
					cQuote = 0;
			}
			else if (c == '"' || c == 0x27)
				cQuote = c;
			else if (c == '>')
				break;

			j++;
		}

		if (j >= nLen)
			break;				// nie geschlossen - Rest unveraendert lassen

		nBilder++;

		const int	nAttrAnfang = i + 4;
		int			nAttrEnde = j;					// vor dem '>'

		// ein abschliessendes '/' gehoert nicht zu den Attributen
		bool		bSelbstSchliessend = false;
		while (nAttrEnde > nAttrAnfang &&
			   (pszHtml[nAttrEnde - 1] == ' ' || pszHtml[nAttrEnde - 1] == '\t' ||
				pszHtml[nAttrEnde - 1] == '\r' || pszHtml[nAttrEnde - 1] == '\n'))
			nAttrEnde--;
		if (nAttrEnde > nAttrAnfang && pszHtml[nAttrEnde - 1] == '/')
		{
			bSelbstSchliessend = true;
			nAttrEnde--;
		}

		const char*	pAttrs   = pszHtml + nAttrAnfang;
		const int	nAttrLen = nAttrEnde - nAttrAnfang;

		CString		szBreiteWert, szHoeheWert, szStyle;
		int			nBVon = -1, nBBis = -1, nHVon = -1, nHBis = -1;

		const bool	bHatBreite = E89Attribut(pAttrs, nAttrLen, "width",  szBreiteWert, &nBVon, &nBBis);
		const bool	bHatHoehe  = E89Attribut(pAttrs, nAttrLen, "height", szHoeheWert,  &nHVon, &nHBis);

		E89Attribut(pAttrs, nAttrLen, "style", szStyle, NULL, NULL);

		//
		// E-95: eingebettete Bilder bleiben unangetastet.
		//
		// Paige kennt ihre echte Groesse, sobald es sie geladen hat - und
		// eingebettete Bilder (cid:, data:) LIEGEN in der Nachricht, werden
		// also auch beim Verfassen geladen. Jede Vorgabe von uns macht es
		// dort nur schlechter.
		//
		// Gregor am 14.09.2026 an 1.0.60, nachdem der Text endlich frei war:
		// die Bilder wurden zerschnitten. Der Fund steckte in seinem Bild -
		// der blaue Doctolib-Kreis war BLAU, nicht grau. Paige hatte ihn
		// geladen; unser height="20" schnitt ihn ab.
		//
		// Bei der FairToner-Nachricht dagegen standen graue Kaesten: dort
		// sind die Bilder EXTERN (http://), werden beim Verfassen nicht
		// geholt, und Paige weiss nichts ueber ihre Groesse. Nur dort ist
		// eine Vorgabe sinnvoll.
		//
		// E89BilderMessbarMachen hat beide Faelle gleich behandelt. Genau das
		// erklaert das Schwanken ueber vier Fassungen: 200x90 (grauer
		// Kasten), gar nichts (Text zugedeckt), 20x20 (Bilder zerschnitten).
		// Es war nie eine Frage der richtigen Zahl - es waren zwei Faelle,
		// die wie einer behandelt wurden.
		//
		CString		szSrc;
		E89Attribut(pAttrs, nAttrLen, "src", szSrc, NULL, NULL);
		szSrc.TrimLeft();

		const bool	bEingebettet = ( szSrc.GetLength() >= 4 &&
									 ( _strnicmp((LPCTSTR) szSrc, "cid:",  4) == 0 ||
									   _strnicmp((LPCTSTR) szSrc, "data:", 5) == 0 ) );


		//
		// Die beiden Masse bestimmen. Reihenfolge: Attribut, dann CSS,
		// dann Vorgabe. Was aus dem Attribut kommt, ist bereits das, was
		// Paige sehen wuerde - es zaehlt trotzdem mit, weil der Deckel es
		// noch treffen kann.
		//
		bool	bProzB = false, bProzH = false;
		bool	bAusCss = false;

		int		nBreite = bHatBreite ? E89ZahlLesen((LPCTSTR) szBreiteWert, bProzB) : 0;
		int		nHoehe  = bHatHoehe  ? E89ZahlLesen((LPCTSTR) szHoeheWert,  bProzH) : 0;

		// Eine Hoehe in Prozent kann Paige nicht: numeric_value liest dort
		// nur die Zahl (PGHTMIMP.CPP:2022), aus "50%" wuerden 50
		// Bildpunkte. Lieber die Vorgabe als eine erfundene Zahl.
		if (bProzH)
		{
			nHoehe = 0;
			bProzH = false;
		}

		if (nBreite <= 0)
		{
			bool	bProz = false;
			int		nCss = E89CssMass((LPCTSTR) szStyle, "width", bProz);

			if (nCss > 0)
			{
				// Prozentbreite kann Paige: decimal_value_percent rechnet
				// sie gegen die Seitenbreite (PGHTMIMP.CPP:2020).
				nBreite = nCss;
				bProzB  = bProz;
				bAusCss = true;
			}
		}

		if (nHoehe <= 0)
		{
			bool	bProz = false;
			int		nCss = E89CssMass((LPCTSTR) szStyle, "height", bProz);

			if (nCss > 0 && !bProz)
			{
				nHoehe  = nCss;
				bAusCss = true;
			}
		}

		//
		// Ist nach Attribut und CSS kein Mass bekannt, bekommt das Bild ein
		// KLEINES Vorgabemass - gerade so hoch wie eine Textzeile.
		//
		// Der Weg dahin, in drei Schritten an einem Tag:
		//
		//  1. 7.2.0.57 gab 200x90 vor. Auf Gregors Bild stand daraufhin ein
		//     grosser grauer Kasten mitten im Text.
		//  2. 7.2.0.58/59 liess das Bild ganz in Ruhe. Dann fehlt aber das
		//     height-Attribut, und genau daran haengt die Zeilenhoehe:
		//     image_record.source_height kommt aus numeric_value() ueber das
		//     ATTRIBUT (PGHTMIMP.CPP:2022), nicht aus der Bilddatei. Ohne
		//     Attribut ist der Wert null, der ganze Block wird uebersprungen,
		//     die Zeile bleibt textklein - und der Text wird zugedeckt.
		//     Gemessen an Gregors Bild zu 1.0.59, Doctolib-Nachricht:
		//     "gesamt=5 unveraendert=4 ohne-Mass=1 geaendert=0", und der
		//     blaue Kreis lag ueber dem Verifizierungscode.
		//  3. Jetzt ein kleines Mass. Die Zeile wird so hoch, dass nichts
		//     zugedeckt wird, und der Platzhalter faellt kaum auf.
		//
		// Den grauen Kasten selbst gibt es so oder so: Paige zeichnet ihn fuer
		// jedes Bild, das es nicht geladen hat - auf Gregors Bildern stehen
		// welche in ECHTEN Bildmassen. Die Frage ist nur, wie gross er ist.
		//
		// Gregors Entscheidung am 14.09.2026 zwischen kleiner Vorgabe, gar
		// keiner und den alten 200x90: "ok, option a".
		//
		// E-95/E-96, 15.09.2026: KEINE Vorgabe mehr fuer Bilder ohne Mass.
		//
		// Bis 7.2.0.62 bekam ein Bild ohne Groessenangabe 20x20 Punkte. Das war
		// ein Notbehelf gegen E-96: solange die Zeilenhoehe die des ERSTEN
		// Bildes behielt, blieb sie bei fehlendem height-Attribut textklein,
		// und der Text wurde zugedeckt.
		//
		// Seit E-96 behoben ist, stimmt die Zeilenhoehe je Bild. GEMESSEN an
		// Gregors Nachrichten mit 1.0.62:
		//
		//   attr=600x1   ascent=13     (Trennlinie - Zeile bleibt textbreit)
		//   attr=175x35  ascent=35
		//   attr=200x50  ascent=50
		//   attr=80x80   ascent=80
		//
		// Damit ist der Notbehelf nicht nur ueberfluessig, sondern SCHAEDLICH:
		// auf seinem Bild war die Tonerkartusche ein schmaler Streifen - kein
		// abgeschnittenes Bild, sondern eines, das wir auf 20x20 gequetscht
		// hatten. In derselben Messung steht dazu "attr=20x20".
		//
		// Paige kennt die wirkliche Groesse, sobald es die Datei geladen hat;
		// die Spalte "embed=" der Spurmarke belegt es. Ohne unser Zutun traegt
		// es sie selbst ein.
		//
		// Vier Fassungen lang wurde an dieser Zahl gedreht - 200x90, gar
		// nichts, 20x20, cid-gegen-http. Keine davon war die Ursache. Die lag
		// in ProcessEmbed, und seit sie behoben ist, braucht es hier gar
		// nichts mehr.
		if (nBreite <= 0 && nHoehe <= 0)
		{
			nOhneMass++;
			if (bEingebettet) nEingebettet++;
			i = j + 1;
			continue;
		}
		else if (nHoehe <= 0)
		{
			// Breite bekannt, Hoehe nicht: auch hier NICHTS erfinden.
			//
			// Eine geratene Hoehe verzerrt das Bild - bei width="600" und
			// einer Vorgabe von 20 waere es ein Streifen. Paige traegt die
			// echte Hoehe nach, sobald es die Datei geladen hat, und seit
			// E-96 behoben ist, stimmt die Zeilenhoehe dann auch.
			//
			// Die Breite bleibt stehen: sie stand im HTML und ist die
			// erklaerte Absicht des Absenders.
			nOhneMass++;
		}

		//
		// Der Deckel. Proportional, damit nichts verzerrt: wird die Breite
		// auf E89_MAX_BREITE gestutzt, geht die Hoehe im selben Verhaeltnis
		// mit, und danach umgekehrt.
		//
		bool	bGedeckelt = false;

		if (!bProzB && nBreite > E89_MAX_BREITE)
		{
			nHoehe = (int) (((double) nHoehe * E89_MAX_BREITE) / (double) nBreite);
			if (nHoehe < 1)
				nHoehe = 1;
			nBreite = E89_MAX_BREITE;
			bGedeckelt = true;
		}

		if (nHoehe > E89_MAX_HOEHE)
		{
			if (!bProzB)
			{
				nBreite = (int) (((double) nBreite * E89_MAX_HOEHE) / (double) nHoehe);
				if (nBreite < 1)
					nBreite = 1;
			}
			nHoehe = E89_MAX_HOEHE;
			bGedeckelt = true;
		}

		//
		// Muss die Markierung ueberhaupt angefasst werden? Nur, wenn ein
		// Mass fehlt oder sich ein Wert aendert. Die grosse Mehrheit der
		// Bilder faellt hier heraus und bleibt Zeichen fuer Zeichen stehen.
		//
		CString		szNeueBreite, szNeueHoehe;

		szNeueBreite.Format(bProzB ? "%d%%" : "%d", nBreite);
		szNeueHoehe.Format("%d", nHoehe);

		const bool	bAendern = ( !bHatBreite || !bHatHoehe ||
								 szNeueBreite != szBreiteWert ||
								 szNeueHoehe  != szHoeheWert );

		if (!bAendern)
		{
			nSchonGut++;
			i = j + 1;
			continue;
		}

		if (bAusCss)	nAusCss++;
		if (bGedeckelt)	nGedeckelt++;

		//
		// Die Markierung neu schreiben: alle Attribute ausser width und
		// height unveraendert uebernehmen, die beiden hinten anhaengen.
		// Ein zweites width weiter vorn duerfte nicht stehenbleiben -
		// find_parameter nimmt das erste, das es findet
		// (PGHTMIMP.CPP:2019), also muss das alte wirklich weg.
		//
		CString		szRest;
		{
			int		nA1 = nBVon, nE1 = nBBis;
			int		nA2 = nHVon, nE2 = nHBis;

			if (nA1 < 0 || (nA2 >= 0 && nA2 < nA1))
			{
				int t;
				t = nA1; nA1 = nA2; nA2 = t;
				t = nE1; nE1 = nE2; nE2 = t;
			}

			int		nPos = 0;

			if (nA1 >= 0)
			{
				szRest += CString(pAttrs + nPos, nA1 - nPos);
				nPos = nE1;
			}
			if (nA2 >= 0)
			{
				szRest += CString(pAttrs + nPos, nA2 - nPos);
				nPos = nE2;
			}
			szRest += CString(pAttrs + nPos, nAttrLen - nPos);
		}

		szRest.TrimRight();

		szAus += CString(pszHtml + nKopiertAb, (i + 4) - nKopiertAb);
		szAus += szRest;
		// Nur schreiben, was bekannt ist. Ein Bild, von dem nur die Breite
		// im CSS steht, bekommt width - und keine erfundene Hoehe.
		if (nBreite > 0)
			szAus += " width=\"" + szNeueBreite + "\"";
		if (nHoehe > 0)
			szAus += " height=\"" + szNeueHoehe + "\"";
		if (bSelbstSchliessend)
			szAus += " /";
		szAus += ">";

		i = j + 1;
		nKopiertAb = i;
	}

	const bool	bGeaendert = (nKopiertAb > 0);

	if (bGeaendert)
	{
		szAus += CString(pszHtml + nKopiertAb, nLen - nKopiertAb);
		out_szHtml = szAus;
	}

	//
	// BEFUND E-103: der Anfang des Rumpfs gehoert in die Marke.
	//
	// Am 17.09.2026 meldete diese Marke fuer die Doctolib-Nachricht
	// gesamt=0 bei 9092 Byte - kein einziges <img>, obwohl das Original
	// 23201 Byte und fuenf Bilder hat. Ohne zu sehen, WAS hier ankommt,
	// laesst sich nicht entscheiden, ob QuoteText die Bilder verliert
	// oder ob sie nie im Rumpf waren. Zwei Werte in eine Ausgabe -
	// Arbeitsweise/zwei-werte-in-eine-ausgabe.md.
	//
	CString		szAnfang;
	long		nCrLf   = 0;
	long		nNurLf  = 0;
	long		nEscImg = 0;
	{
		const int	nZeig = ( nLen < 160 ) ? nLen : 160;

		szAnfang = CString( pszHtml, nZeig );

		// Zeilenschaltungen wuerden die Protokollzeile zerreissen.
		szAnfang.Replace( "\r", " " );
		szAnfang.Replace( "\n", " " );

		//
		// BEFUND E-103: die Zeilenenden zaehlen.
		//
		// FindBody (msgutils.cpp:333) sucht "\r\n\r\n". Liegen im Postfach
		// nackte LF, findet es die Grenze nie und liefert das Ende der
		// Zeichenkette zurueck. Dann ist fuer jeden Aufrufer der ganze
		// Rumpf leer - und die Nachricht wird als ein einziger Textblock
		// behandelt. Ob das hier der Fall ist, sagt nur die Messung.
		//
		// Dazu: kommt "&lt;img" vor, ist das HTML als TEXT durchgereicht
		// worden (Text2Html hat die spitzen Klammern geschuetzt) - dann
		// sind die Bilder nicht verloren, sondern unsichtbar gemacht.
		//
		for ( int p = 0; p < nLen; p++ )
		{
			if ( pszHtml[p] == '\n' )
			{
				if ( p > 0 && pszHtml[p-1] == '\r' )
					nCrLf++;
				else
					nNurLf++;
			}
		}

		const char *	pSuch = pszHtml;

		while ( ( pSuch = strstr( pSuch, "&lt;img" ) ) != NULL )
		{
			nEscImg++;
			pSuch += 7;
		}
	}

	out_szSpur.Format(
		"E-89 Bilder im Editor: gesamt=%d unveraendert=%d aus-CSS=%d "
		"eingebettet=%d ohne-Mass=%d gedeckelt=%d geaendert=%d Bytes vorher=%d nachher=%d crlf=%ld nur-lf=%ld esc-img=%ld anfang=[%s]",
		nBilder, nSchonGut, nAusCss, nEingebettet, nOhneMass, nGedeckelt, bGeaendert ? 1 : 0,
		nLen, bGeaendert ? out_szHtml.GetLength() : nLen,
		nCrLf, nNurLf, nEscImg,
		(LPCTSTR) szAnfang );

	return bGeaendert;
}


//
// ---------------------------------------------------------------------------
// E101SpeicherfassungAufbereiten
// ---------------------------------------------------------------------------
//
// BEFUND E-101: was "Speichern unter" hinausschreibt, kann kein anderes
// Programm lesen.
//
// Gregor am 17.09.2026, nachdem er eine weitergeleitete Nachricht gesichert
// hatte: "datei gespeichert, aber unbrauchbar". Gemessen an seiner Datei
// (Fw Ihr Doctolib Verifizierungscode.eml, 5716 Byte):
//
//   From: gregor.czempik@web.de
//   To: markus.bakus@gmx.de
//   Subject: Fw: Ihr Doctolib Verifizierungscode
//   Date: Mon, 14 Sep 2026 10:52:45 +0000
//
//   <x-html>
//   <html><body>...g<FC>ltig...
//
// Vier Kopfzeilen, danach Eudoras INTERNER Marker <x-html> und roher HTML-
// Text. Keine Content-Type-Zeile, keine MIME-Version, kein Zeichensatz.
//
// WARUM DAS SO IST - und warum es kein Fehler des Speicherns allein ist:
// bei einer selbst verfassten Nachricht entsteht die Content-Type-Zeile ERST
// BEIM SENDEN. SendContentType (sendmail.cpp:766) baut sie aus den Merkern
// des Uebersichtseintrags (MSF_XRICH, MSFEX_HTML), nicht aus dem Rumpf. Was
// in Out.mbx liegt, ist die interne Fassung. GetFullMessage liefert genau
// die, und der Speicherweg (tocview.cpp:3163) schreibt sie unveraendert
// hinaus.
//
// WAS DER ANWENDER DAVON HAT: Thunderbird und jedes andere Programm zeigen
// entweder HTML-Quelltext oder Buchstabensalat. Die Umlaute sind korrekt als
// Latin-1 gespeichert (das Byte hinter dem g in "gueltig" ist 0xFC,
// gemessen) - aber ohne charset= weiss kein Leser das.
//
// WAS DIESE FUNKTION TUT
//
//   1. Sie trennt Kopfzeilen und Rumpf an der ersten Leerzeile.
//   2. Sie entfernt den <x-html>-Marker und sein Gegenstueck </x-html>.
//      Der Marker darf Zusaetze tragen (<x-html content-base="...">),
//      deshalb wird bis zum > gelesen.
//   3. Fehlt eine Content-Type-Zeile, ergaenzt sie MIME-Version,
//      Content-Type und Content-Transfer-Encoding.
//   4. Der Untertyp folgt dem Marker: war er da, ist es text/html, sonst
//      text/plain. Der Zeichensatz folgt den Bytes: ein Byte >= 0x80
//      irgendwo im Rumpf heisst ISO-8859-1, sonst us-ascii.
//
// WAS SIE NICHT TUT: eine vorhandene Content-Type-Zeile anfassen. Eine
// empfangene Nachricht bringt ihre echten Kopfzeilen aus dem Postfach mit;
// die sind richtig und bleiben, wie sie sind. Gemessen wird das, nicht
// vermutet - die Spurmarke nennt den Befund.
//
// Reine Textverarbeitung: Text rein, Text raus. Damit ohne Fenster und ohne
// Postfach pruefbar, und genau so steht sie in der Testsammlung.
//
// Rueckgabe: true, wenn out_szDatei gefuellt ist und an die Stelle des
// Eingangstextes tritt. out_szSpur gehoert ins Protokoll.
//
bool E101SpeicherfassungAufbereiten(
		const char *		pszVoll,
		bool				bHatKopfzeilen,
		CString &			out_szDatei,
		CString &			out_szSpur )
{
	out_szDatei.Empty();

	const int	nLen = pszVoll ? (int) strlen(pszVoll) : 0;

	if ( nLen == 0 )
	{
		out_szSpur = "E-101 speichern: leer, nichts zu tun";
		return false;
	}

	CString		szAlles( pszVoll );

	//
	// 1. Kopfzeilen und Rumpf trennen.
	//
	// Die Grenze ist die erste Leerzeile. Eudora schreibt CRLF, aber eine
	// Datei aus fremder Hand kann auch nacktes LF tragen - beide Faelle
	// werden gesucht, und es gewinnt der fruehere Fund. Wer nur nach
	// "\r\n\r\n" sucht, findet bei nacktem LF die Grenze erst im Rumpf und
	// zerschneidet die Nachricht mitten im HTML.
	//
	int		nRumpfAb   = -1;
	int		nKopfEnde  = -1;

	if ( bHatKopfzeilen )
	{
		const int	nCrLf = szAlles.Find( "\r\n\r\n" );
		const int	nLfLf = szAlles.Find( "\n\n" );

		if ( nCrLf >= 0 && ( nLfLf < 0 || nCrLf <= nLfLf ) )
		{
			nKopfEnde = nCrLf;
			nRumpfAb  = nCrLf + 4;
		}
		else if ( nLfLf >= 0 )
		{
			nKopfEnde = nLfLf;
			nRumpfAb  = nLfLf + 2;
		}
	}

	//
	// BEFUND E-101 / PRUEFER P-20: steht die Leerzeile ganz vorn, gibt es
	// keinen Kopf - dann ist ALLES Rumpf. Ohne diese Bedingung wird szKopf
	// wegen ( nKopfEnde > 0 ) leer, der Zusammenbau schreibt den Trenner
	// nicht, und die vier Byte sind ersatzlos weg. Gemessen vom PRUEFER:
	// "\r\n\r\nErste Rumpfzeile\r\n" - 22 Byte rein, 18 raus.
	//
	if ( nRumpfAb < 0 || nKopfEnde <= 0 )
	{
		// Ohne Kopfzeilen ist alles Rumpf.
		nKopfEnde = 0;
		nRumpfAb  = 0;
	}

	CString		szKopf  = ( nKopfEnde > 0 ) ? szAlles.Left( nKopfEnde ) : CString("");
	CString		szRumpf = szAlles.Mid( nRumpfAb );

	//
	// 2. Den x-html-Marker entfernen.
	//
	// Gesucht wird ohne Ruecksicht auf Gross- und Kleinschreibung, denn
	// etf2html.cpp:200 schreibt "<x-html>", TocFrame.cpp:1408 baut ihn aus
	// der Ressource IDS_MIME_XHTML zusammen, und eine Nachricht aus fremder
	// Hand kann alles Moegliche tragen.
	//
	bool		bWarHtml = false;

	CString		szKlein( szRumpf );
	szKlein.MakeLower();

	//
	// PRUEFER P-18: der Marker steht, wenn ueberhaupt, als ERSTE ZEILE des
	// Rumpfs - etf2html.cpp:200 und TocFrame.cpp:1408 schreiben ihn genau
	// dort. Der erste Entwurf suchte ihn im ganzen Rumpf und dann das
	// naechste '>' ueber Zeilengrenzen hinweg. In einer Klartextnachricht
	// ist das naechste '>' das ZITATZEICHEN, und alles dazwischen fiel weg:
	//
	//   "Er schrieb <x-html in die Zeile. Du sagtest:\r\n> stimmt"
	//     wurde zu "Er schrieb  stimmt"   -   36 von 62 Byte verloren.
	//
	// Der PRUEFER hat das am 17.09.2026 an der uebersetzten Funktion
	// gemessen, mit zwoelf Eingaben, bevor das Paket hinausging
	// (Befunde/PRUEFER-13.md). Die Zeilengrenze erledigt vier der
	// gemessenen Faelle auf einmal - darunter den, dass eine EMPFANGENE
	// Nachricht Rumpftext verlor, obwohl an ihr nichts anzutasten ist.
	//
	if ( szKlein.Left( 7 ) == "<x-html" )
	{
		//
		// PRUEFER P-28, DATENVERLUST: es wird das TAG entfernt, nicht die
		// ZEILE.
		//
		// Der Entwurf davor schnitt die ganze erste Zeile weg, sobald sie
		// auf '>' endete. Steht der Marker mit dem Text auf DERSELBEN
		// Zeile, war damit der komplette Rumpf weg. Der PRUEFER hat es am
		// 17.09.2026 an der uebersetzten Funktion gemessen:
		//
		//   "<x-html><html><body>Der ganze Text...</body></html></x-html>"
		//     104 Byte rein, 128 raus - und NULL Byte Rumpf.
		//
		// Die Datei wird dabei GROESSER, weil die Kopfzeilen dazukommen.
		// Deshalb faellt der Verlust niemandem auf.
		//
		// Dass der Fall vorkommt, steht in Eudoras eigenem Quelltext:
		// msgutils.cpp:2374 sagt woertlich "<x-html> And the message all
		// comes on the same line", IDS_MIME_RICH_ON ist "<%s>" ohne
		// Zeilenende (EudoraRes.rc:9564), und etf2html.cpp:200 schreibt
		// den Marker ebenso. Nur der POP-Weg setzt ihn auf eine eigene
		// Zeile.
		//
		// Das Ende des Tags ist das erste '>' AUSSERHALB von
		// Anfuehrungszeichen - ein <x-html content-base="http://host/a>b/">
		// traegt eines im Attributwert. Ueber die erste Zeile hinaus wird
		// nicht gesucht: dort stuende in einer Klartextnachricht das
		// Zitatzeichen (P-18).
		//
		int			nZu = -1;
		bool		bInAnfuehrung = false;

		for ( int q = 0; q < szRumpf.GetLength(); q++ )
		{
			const char	c = szRumpf[q];

			if ( c == '\r' || c == '\n' )
				break;

			if ( c == '"' )
				bInAnfuehrung = !bInAnfuehrung;
			else if ( c == '>' && !bInAnfuehrung )
			{
				nZu = q;
				break;
			}
		}

		if ( nZu >= 0 )
		{
			bWarHtml = true;

			int		nNach = nZu + 1;

			//
			// Steht hinter dem Tag nichts mehr auf der Zeile, faellt die
			// Zeilenschaltung mit weg - sonst begaenne der Rumpf mit einer
			// Leerzeile, die vorher nicht da war. Folgt Text, bleibt er
			// stehen, und zwar vollstaendig.
			//
			const bool	bAlleinAufZeile =
					( nNach >= szRumpf.GetLength() ||
					  szRumpf[nNach] == '\r' || szRumpf[nNach] == '\n' );

			if ( bAlleinAufZeile )
			{
				if ( nNach < szRumpf.GetLength() && szRumpf[nNach] == '\r' )
					nNach++;
				if ( nNach < szRumpf.GetLength() && szRumpf[nNach] == '\n' )
					nNach++;
			}

			szRumpf = szRumpf.Mid( nNach );

			// Und das Gegenstueck am Ende.
			szKlein = szRumpf;
			szKlein.MakeLower();

			// CString kennt ReverseFind nur fuer EIN Zeichen, nicht fuer
			// eine Zeichenkette. Deshalb von hinten selbst suchen.
			int			nEnde = -1;
			{
				const char *	pszK  = (const char *) szKlein;
				const int		nKLen = szKlein.GetLength();

				for ( int i = nKLen - 9; i >= 0; i-- )
				{
					if ( memcmp( pszK + i, "</x-html>", 9 ) == 0 )
					{
						nEnde = i;
						break;
					}
				}
			}

			if ( nEnde >= 0 )
			{
				//
				// PRUEFER P-19: nur wenn hinter dem Fund nichts als Leerraum
				// steht, ist es wirklich das Gegenstueck. Sonst ist es
				// zitierter Text. Gemessen wurde
				// "WICHTIGER NACHSATZ </x-html> ende" - daraus wurde
				// "WICHTIGER NACHSATZ  ende", waehrend das ECHTE </x-html>
				// stehen blieb: Verlust und verfehltes Ziel in einem.
				//
				bool	bNurLeerraum = true;

				for ( int k = nEnde + 9; k < szRumpf.GetLength(); k++ )
				{
					const char	c = szRumpf[k];

					if ( c != '\r' && c != '\n' && c != ' ' && c != '\t' )
					{
						bNurLeerraum = false;
						break;
					}
				}

				if ( bNurLeerraum )
				{
					int		nNachEnde = nEnde + 9;

					if ( nNachEnde < szRumpf.GetLength() && szRumpf[nNachEnde] == '\r' )
						nNachEnde++;
					if ( nNachEnde < szRumpf.GetLength() && szRumpf[nNachEnde] == '\n' )
						nNachEnde++;

					szRumpf = szRumpf.Left( nEnde ) + szRumpf.Mid( nNachEnde );
				}
			}
		}
	}
	//
	// 3. Gibt es schon eine Content-Type-Zeile?
	//
	// Gesucht wird nur am ZEILENANFANG. Im Rumpf einer weitergeleiteten
	// Nachricht steht der Text "Content-Type:" haeufig mitten drin - als
	// zitierter Kopf der urspruenglichen Nachricht. Wer ohne Zeilenanker
	// sucht, findet den und ergaenzt nichts.
	//
	bool		bHatContentType = false;

	if ( !szKopf.IsEmpty() )
	{
		CString		szKopfKlein( szKopf );
		szKopfKlein.MakeLower();

		if ( szKopfKlein.Left( 13 ) == "content-type:" )
		{
			bHatContentType = true;
		}
		else
		{
			int		nSuch = szKopfKlein.Find( "\ncontent-type:" );
			if ( nSuch >= 0 )
				bHatContentType = true;
		}
	}

	//
	// 4. Zeichensatz aus den Bytes bestimmen, nicht aus einer Einstellung.
	//
	// Ein Byte >= 0x80 heisst: das ist nicht us-ascii. Eudora legt intern
	// Latin-1 ab (Befund NP3-8 und E-85 handeln von genau dieser Kodierung),
	// deshalb ist ISO-8859-1 die richtige Angabe. Sie wird aus dem Inhalt
	// abgeleitet und nicht geraten.
	//
	bool		bHochbyte = false;

	{
		const int	nRLen = szRumpf.GetLength();

		for ( int i = 0; i < nRLen; i++ )
		{
			if ( (unsigned char) szRumpf[i] >= 0x80 )
			{
				bHochbyte = true;
				break;
			}
		}
	}

	const char *	pszUntertyp = bWarHtml  ? "html"        : "plain";
	const char *	pszCharset  = bHochbyte ? "ISO-8859-1"  : "us-ascii";

	//
	// 5. Zusammensetzen.
	//
	CString		szNeu;

	if ( !szKopf.IsEmpty() )
	{
		//
		// PRUEFER P-21: lautet der Trenner \r\n + \n, greift der
		// "\n\n"-Zweig, und szKopf endet auf einem einzelnen \r. In der
		// Datei stuende dann \r\r\n - eine Kopfzeile, die kein Leser so
		// erwartet. Kein Verlust, aber falsch.
		//
		while ( !szKopf.IsEmpty() &&
				( szKopf[szKopf.GetLength()-1] == '\r' ||
				  szKopf[szKopf.GetLength()-1] == '\n' ) )
			szKopf = szKopf.Left( szKopf.GetLength() - 1 );

		szNeu = szKopf;

		if ( !bHatContentType )
		{
			szNeu += "\r\nMIME-Version: 1.0";
			szNeu += "\r\nContent-Type: text/";
			szNeu += pszUntertyp;
			szNeu += "; charset=\"";
			szNeu += pszCharset;
			szNeu += "\"";
			szNeu += "\r\nContent-Transfer-Encoding: 8bit";
		}

		szNeu += "\r\n\r\n";
	}

	szNeu += szRumpf;

	const bool	bGeaendert = ( szNeu != szAlles );

	if ( bGeaendert )
		out_szDatei = szNeu;

	out_szSpur.Format(
		"E-101 speichern: kopfzeilen=%d trenner=%d xhtml=%d content-type-vorhanden=%d "
		"typ=text/%s charset=%s bytes-vorher=%d nachher=%d geaendert=%d",
		bHatKopfzeilen ? 1 : 0,
		( nKopfEnde > 0 ) ? 1 : 0,
		bWarHtml ? 1 : 0,
		bHatContentType ? 1 : 0,
		pszUntertyp,
		pszCharset,
		nLen,
		szNeu.GetLength(),
		bGeaendert ? 1 : 0 );

	return bGeaendert;
}
