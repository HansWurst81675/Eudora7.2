// MIMEMap.h
//
// MIMEMap object that handles mappings between MIME type/subtype,
// filename extension, and Mac creator and type

#ifndef _MIMEMap_h_
#define _MIMEMap_h_

class MIMEState;

typedef enum
{
	MT_IN,
	MT_OUT,
    MT_BOTH
} MapType;


class MIMEMap : public CObject
{
public:
	MIMEMap();
	~MIMEMap();
	void Init();

	BOOL Find(MIMEState* ms);
	BOOL Find(LPCTSTR Creator, LPCTSTR Type);
	BOOL Find(LPCTSTR Extension);

	//	nPuffer: Groesse des Puffers hinter Filename, samt Null (AN-1, Teil 11).
	BOOL SetExtension(LPTSTR Filename, size_t nPuffer = _MAX_PATH + 1);

	TCHAR m_Suffix[8];
	TCHAR m_Mimetype[32];
	TCHAR m_Subtype[32];
	TCHAR m_Creator[5];
	TCHAR m_Type[5];

	BOOL m_bDelete;

private:
	CObArray m_Maps;
	MapType m_MapType;

	BOOL GetMaps();
};

#endif // #ifndef _MIMEMap_h_
