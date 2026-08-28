// Automatisch erzeugt von Extract.ps1 - NICHT von Hand aendern.
// Quelle: C:\Users\Gregor\Documents\github\Eudora7.2\Eudora71\Tests\..\Eudora\utils.cpp, Zeilen 1162 bis 1234
#line 1162 "C:/Users/Gregor/Documents/github/Eudora7.2/Eudora71/Tests/../Eudora/utils.cpp"
LONG ISOTranslate(LPTSTR szBuf, LONG lSize, UINT iCharsetIdx)
{
	// Bail if there is no buffer or no table.
	if (!szBuf)
	{
		return 0;
	}

	// An index of 0 is Windows, 1 is US ASCII and 2 is Latin1, none of which need
	// any translation.  Exit now if no translation needed.
	if (iCharsetIdx <= 2)
	{
		return lSize;
	}

	// We are still here so translation is needed.  Bump the index down by
	// 3 since Windows, US_ASCII and ISO_LATIN1 do not have entries in the table.
	iCharsetIdx -= 3;

	// Make sure there is a table entry for this character set
	if (iCharsetIdx >= MAX_CHARACTER_SETS)
	{
		ASSERT(0);	// Who gave me this bad data?
		return lSize;
	}

	// Make sure the input text is NULL terminated.
	//
	// Bug note - this NULL termination business is a bit nasty. TextReader::ReadIt
	// was filling up its entire buffer with text and then calling us. NULL terminating
	// here was writing one past the end of the buffer. I'd like to do away with this
	// NULL termination (because TextReader doesn't seem to need it - it relies on
	// the buffer size), but I can't easily be sure of the implications of that.
	// Instead TextReader::ReadIt is now making sure that it leaves space at the
	// end of its buffer for us to NULL terminate it.
	szBuf[lSize] = 0;

	// Copy the buffer into a CString for easier string substitution.
	CString			 csTranslated(szBuf);

	unsigned char	 szTransTo[2] = {'\0', '\0'};

	// Iterate through the translation table replacing occurrences
	// of target strings with their replacements.
	for (int i = 0; i < XLATE_CHARS; ++i)
	{
		if (pcXlateTable[iCharsetIdx][i][0] == '\0')
		{
			// We have reached an empty entry: no more strings to translate.
			break;
		}

		// Place the last item in the table's row in the string
		// to replace the above string.
		szTransTo[0] = pcXlateTable[iCharsetIdx][i][MAX_CHARS_TO_TRANS + 1];

		// Note that this might decrease the size of the text but will never
		// increase the size because the replacement string is always
		// exactly one character long.
		csTranslated.Replace((char*)pcXlateTable[iCharsetIdx][i], (char*)szTransTo);
	}

	// Recalculate the text length in case we got shorter.
	lSize = csTranslated.GetLength();

	// Copy the translated text back into the buffer.
	strncpy(szBuf, csTranslated, lSize);
	
	// Make sure the text is NULL terminated.
	szBuf[lSize] = 0;

	return strlen(szBuf);
}
