//
// UnderTestE221.cpp - die echte RFC-2047-Kette des Sendewegs (sendmail.cpp,
// Next2047Word bis Encode2047) und E221BetreffAnfang (summary.cpp), bei
// jedem Bau frisch von Extract.ps1 geschnitten (Befund E-221).
//
// In einem eigenen Namensraum: AnyHighBits und die Token-Typen sollen mit
// nichts anderem im Testprogramm zusammenstossen, und CRString ist hier nur
// nachgebildet (die Ressourcen-DLL gibt es im Test nicht).
//
#include <afx.h>
#include <afxwin.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>

namespace UTE221
{
	// Kennungen nur fuer den Nachbau; die Texte stehen woertlich in
	// Eudora71/Eudora/EudoraRes.rc:
	//     IDS_RFC1342_FMT         "=?%s?Q?%s?="
	//     IDS_MIME_ISO_LATIN1     "iso-8859-1"
	enum { IDS_RFC1342_FMT = 1, IDS_MIME_ISO_LATIN1 = 2 };

	class CRString
	{
	public:
		explicit CRString(int id) : m_s(id == IDS_RFC1342_FMT ? "=?%s?Q?%s?=" : (id == IDS_MIME_ISO_LATIN1 ? "iso-8859-1" : "")) {}
		operator const char*() const { return m_s; }
	private:
		const char* m_s;
	};

#include "generated/sendmail_e221.inc"
#include "generated/summary_e221.inc"
}

// --------------------------------------------------------- Schnittstelle
CString UTE221_Encode2047(const char* szText, int nLineLimit, int nCharsOnLine)
{
	int n = nCharsOnLine;
	return UTE221::Encode2047(szText, (int) strlen(szText), nLineLimit, n, FALSE);
}

char* UTE221_BetreffAnfang(char* szZeile, BOOL bFortsetzung)
{
	return UTE221::E221BetreffAnfang(szZeile, bFortsetzung);
}
