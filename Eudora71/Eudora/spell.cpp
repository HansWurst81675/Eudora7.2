//
// spell.cpp -- Ersatz fuer die fehlende Implementierung von CSpell.
//
// Die Datei fehlt in der Quelltextfreigabe des Computer History Museum; nur
// spell.h ist vorhanden. Eudora.vcxproj listet spell.cpp weiterhin
// (ClCompile, Zeile 503), also bricht der Build ohne diese Datei mit C1083 ab.
//
// WAS CSpell IM ORIGINAL TUT
//   Den Text eines CEdit- bzw. CRichEditCtrl-Feldes zeilen- und wortweise an
//   die Sentry Spelling Checker Engine (SSCE, siehe ssce.h) geben, Treffer im
//   CSpellDialog anzeigen und Ersetzungen in das Feld zurueckschreiben.
//   CSpellPaige (spellpaige.cpp) ist die Paige-Variante desselben Ablaufs und
//   dient hier als Vorlage fuer Rueckgabewerte.
//
// WAS DIESER DUMMY STATTDESSEN TUT
//   Gar nichts pruefen. ssce.h ist selbst nur ein rekonstruierter Platzhalter,
//   die Engine wird nicht angebunden. Die Methoden behalten Signatur und
//   Reihenfolge des Headers, damit der Rumpf mit spell.h vergleichbar bleibt.
//   Die vom Anwender erreichbaren Einstiegspunkte (Check, Popup) melden sich
//   einmal pro Sitzung mit einem Hinweis -- ein still nichts tuender
//   Menuepunkt "Edit > Check Spelling" saehe sonst wie ein Fehler aus.
//   Rein interne Methoden bleiben still.
//
// RUECKGABEWERT VON Check() -- BELEGT, NICHT GERATEN
//   spell.h:6 definiert NO_MISSPELLINGS als -2. Das ist hier der FALSCHE Wert:
//   NO_MISSPELLINGS heisst "geprueft und nichts gefunden", nicht "nicht
//   geprueft". Belege:
//     - spellpaige.cpp:267 setzt result = NO_MISSPELLINGS erst, nachdem
//       CSpellDialog::FoundMisspelling() == FALSE gemeldet hat, also nach
//       einem tatsaechlich gelaufenen Durchgang.
//     - CompMessageFrame.cpp:948 und :964 zeigen bei NO_MISSPELLINGS die
//       Meldung IDS_SPELL_NO_MISSPELLINGS ("No misspellings found"). Der Dummy
//       wuerde damit eine Pruefung behaupten, die nie stattgefunden hat.
//   Ebenso falsch waere IDCANCEL: compmsgd.cpp:797 bricht daraufhin das
//   Einreihen der Nachricht in die Warteschlange ab (return FALSE).
//   Richtig ist 0. Das ist im aufrufenden Code bereits der Wert fuer "die
//   Pruefung lief nicht":
//     - headervw.cpp:2966 gibt 0 zurueck, wenn UsingFullFeatureSet() FALSE ist,
//       also im Shareware-Modus ohne Rechtschreibpruefung.
//     - headervw.cpp:1738 gibt 0 zurueck, wenn gar kein Betreff-Feld existiert.
//   0 ist weder NO_MISSPELLINGS noch IDCANCEL noch < 0, laeuft also durch alle
//   Auswertungen der Aufrufer sauber hindurch.
//

#include "stdafx.h"
#include "spell.h"

#include "DebugNewHelpers.h"

//
// Hinweis nur einmal pro Sitzung. Wer waehrend des Schreibens mehrfach
// F7 drueckt oder das Tippfehler-Timing von CHeaderField::DoSpellCheck
// (headervw.cpp:1188) auslaest, soll nicht in einer Kette von Meldungen
// haengen bleiben.
//
static BOOL s_bHinweisGezeigt = FALSE;

static void ZeigeHinweisEinmal()
{
	if (s_bHinweisGezeigt)
		return;

	s_bHinweisGezeigt = TRUE;

	// Kein CRString/IDS_..., weil dafuer eine neue Ressource noetig waere und
	// EudoraRes.rc hier bewusst unangetastet bleibt.
	AfxMessageBox(
		_T("Die Rechtschreibpruefung ist in dieser Fassung nicht verfuegbar. ")
		_T("Die Pruefengine (SSCE) fehlt in der Quelltextfreigabe."),
		MB_OK | MB_ICONINFORMATION);
}


/////////////////////////////////////////////////////////////////////////////
// Konstruktion

//
// Der Konstruktor zeigt bewusst KEINE Meldung: CSpell wird auch ohne
// Anwenderaktion angelegt, etwa in CHeaderField::DoSpellCheck
// (headervw.cpp:1188), das am Tipp-Timer haengt.
//
// Die Member werden trotzdem vollstaendig gesetzt. m_bJustQueue ist kein
// interner Wert, sondern wird von aussen gelesen: headervw.cpp:2961 reicht
// Spell.m_bJustQueue direkt an CHeaderView::SetJustQueue weiter, und
// compmsgd.cpp:806 entscheidet daran, ob der Nachrichtenrumpf noch geprueft
// wird. Uninitialisiert waere das ein Zufallswert.
//
CSpell::CSpell(BOOL hasQuotedText /*= FALSE*/)
{
	m_pSpellDialog	= NULL;

	m_bWasHighlighted	= FALSE;
	m_bInteractive		= FALSE;
	m_BegChar			= 0;
	m_EndChar			= 0;
	m_BegRow			= 0;
	m_EndRow			= 0;
	m_BegCol			= 0;
	m_EndCol			= 0;
	m_CurRow			= 0;
	m_CurCol			= 0;
	m_CurIndex			= 0;
	m_CurBufIndex		= 0;
	m_TopVisibleLine	= 0;
	m_DidTopScroll		= FALSE;
	m_hRichEdit			= NULL;
	m_hEdit				= NULL;
	m_prevWord[0]		= 0;
	m_termChar			= 0;

	m_HasQuotedText		= hasQuotedText;
	m_bJustQueue		= FALSE;
}


//
// Leer. Im Original wird hier der CSpellDialog abgeraeumt (vgl.
// CSpellPaige::Cleanup, spellpaige.cpp:101). Dieser Dummy legt nie einen an,
// m_pSpellDialog bleibt ueber die gesamte Lebensdauer NULL. Damit muss auch
// SpellDialog.h nicht eingebunden werden.
//
CSpell::~CSpell()
{
}


/////////////////////////////////////////////////////////////////////////////
// Interne Fehlerausgabe

//
// Leerer Rumpf, keine Meldung: ErrMsg ist private (spell.h:20) und wird im
// Original nur aus den Check-Pfaden heraus mit einem Fehlercode der Engine
// gerufen (vgl. CSpellPaige::ErrMsg, spellpaige.cpp:87). Ohne Engine gibt es
// keine Fehlercodes. Der Wert wird unveraendert zurueckgereicht, so wie es
// die Paige-Variante tut.
//
int CSpell::ErrMsg(int ret)
{
	return ret;
}


/////////////////////////////////////////////////////////////////////////////
// Pruefeinstiege -- vom Anwender erreichbar

//
// Aufrufstelle: mainfrm.cpp:6878 ff. CMainFrame::CheckSpelling haengt an
// ON_COMMAND(ID_EDIT_CHECKSPELLING) (mainfrm.cpp:625), also am Menuepunkt
// "Edit > Check Spelling". Der Rueckgabewert wird dort nicht ausgewertet.
//
int CSpell::Check(CRichEditCtrl* hEdit, int LinesFromTop /*= 0*/, BOOL autoCheck /*= FALSE*/)
{
	m_hRichEdit = hEdit;

	ZeigeHinweisEinmal();

	// 0 = "nicht geprueft", siehe Kopf der Datei.
	return 0;
}


//
// Aufrufstellen:
//   headervw.cpp:1188  CHeaderField::DoSpellCheck  -- Hintergrundlauf am
//                      Tipp-Timer, markiert im Original die Tippfehler im
//                      Betreff-Feld.
//   headervw.cpp:2956  CHeaderField::OnCheckSpelling -- Menuepunkt bzw.
//                      Pruefung beim Einreihen in die Warteschlange.
//   headervw.cpp:2977  CHeaderField::CheckSpelling -- Pruefung einer Auswahl.
//
// Der Hinweis kommt auch hier, teilt sich aber das Flag mit allen anderen
// Einstiegen. Es bleibt also bei einer Meldung pro Sitzung, egal ob sie der
// Timer oder das Menue ausloest.
//
int CSpell::Check(CEdit* hEdit, int LinesFromTop /*= 0*/, BOOL autoCheck /*= FALSE*/,
				  BOOL bInteractive /*= FALSE*/)
{
	m_hEdit        = hEdit;
	m_bInteractive = bInteractive;

	ZeigeHinweisEinmal();

	// Wichtig fuer headervw.cpp:2961: m_bJustQueue bleibt FALSE, damit
	// compmsgd.cpp:806 den Nachrichtenrumpf weiterhin normal behandelt.
	m_bJustQueue = FALSE;

	// 0 = "nicht geprueft", siehe Kopf der Datei. Insbesondere NICHT
	// NO_MISSPELLINGS (falsche Erfolgsmeldung) und nicht IDCANCEL
	// (wuerde compmsgd.cpp:797 das Einreihen abbrechen lassen).
	return 0;
}


//
// Aufrufstelle: headervw.cpp:1340, CHeaderField::OnRButtonDown. Rechtsklick
// auf ein als falsch markiertes Wort im Betreff-Feld. Der Rueckgabewert wird
// dort nicht ausgewertet.
//
// In der Praxis wird das nie erreicht, weil die vorgelagerte Pruefung
// IsMissSpelledWord() (headervw.cpp:1350) auf m_pSpellDirtyPair beruht und
// dieser Dummy nie ein Wort markiert. Der Hinweis steht trotzdem hier, weil
// die Methode am Anwender ankommt, sobald jemand die Markierung wieder
// beibringt.
//
int CSpell::Popup(CEdit* pEdit, char* pWord, POINT& point, BOOL doubledWord /*= FALSE*/)
{
	ZeigeHinweisEinmal();

	return 0;
}


/////////////////////////////////////////////////////////////////////////////
// Interne Ablaufteile -- nie direkt am Anwender, daher ohne Meldung

//
// Leer. ReallyCheck ist der eigentliche Pruefdurchgang und wird ausschliesslich
// aus den Check-Methoden heraus gerufen (vgl. spellpaige.cpp:113 und :121, die
// beide nur an ReallyCheck weiterreichen). Ohne Engine gibt es keinen
// Durchgang. Rueckgabewert wie bei Check: 0 = "nicht geprueft".
//
int CSpell::ReallyCheck(int LinesFromTop, BOOL autoCheck)
{
	return 0;
}


//
// Leer. Markiert im Original das gerade beanstandete Wort im Eingabefeld.
// Gerufen wird das aus dem Pruefdurchgang und aus dem CSpellDialog heraus
// (vgl. spellpaige.cpp:288), beides Wege, die dieser Dummy nie
// betritt.
//
void CSpell::myHilightWord(BOOL bMark /*= FALSE*/)
{
}


//
// Leerer Durchgang. Im Original laeuft hier die Schleife ueber den Textblock,
// die SSCE_CheckBlock bemueht und bei jedem Treffer zurueckkehrt.
//
// Der Rueckgabewert ist belegt, nicht geraten: CSpellPaige::my_CheckBlock
// liefert am Ende des Blocks SpellCheck_END_OF_BLOCK_RSLT
// (spellpaige.cpp:553), und die auswertende Schleife behandelt jeden anderen
// Wert als Treffer (spellpaige.cpp:544 ff.). "Block zu Ende, nichts mehr da"
// ist genau der Zustand, den dieser Dummy meldet.
//
int CSpell::my_CheckBlock(long options, UCHAR* errWord, UCHAR* repWord)
{
	return SpellCheck_END_OF_BLOCK_RSLT;
}


//
// Leer. Ersetzt im Original das beanstandete Wort im Eingabefeld durch den im
// CSpellDialog gewaehlten Vorschlag (vgl. spellpaige.cpp:313). Der Dialog wird
// hier nie geoeffnet, also gibt es nichts zu ersetzen.
//
void CSpell::my_ReplaceBlockWord(UCHAR* CurWord, const UCHAR* repWord)
{
}


//
// Leer. Erkennt im Original das doppelt getippte Wort ("das das"). Private
// (spell.h:34) und nur aus my_CheckBlock heraus gerufen, das hier bereits
// leer laeuft. 0 = FALSE = "kein doppeltes Wort", der harmlose Fall.
//
int CSpell::BlockIsDoubledWord(const char* curWord)
{
	return 0;
}


//
// Leer. Hilfsfunktion des Zeilenparsers (spell.h:38, protected). Wird nur aus
// ParseLine heraus gerufen, das hier ebenfalls leer laeuft. FALSE ist der
// neutrale Wert: kein Zeichen gilt als Satzzeichen, also wird nichts
// abgetrennt.
//
BOOL CSpell::IsPunctuation(char CurChar)
{
	return FALSE;
}


//
// Leer. Zerlegt im Original eine Zeile in das naechste zu pruefende Wort und
// gibt dessen Laenge zurueck. Ohne Pruefdurchgang gibt es keinen Aufrufer.
// 0 = "kein Wort mehr in dieser Zeile" und beendet damit jede Schleife, die
// spaeter wieder darauf aufsetzt.
//
int CSpell::ParseLine(char* CurLin, char* CurWord, int LinLen, BOOL quoteLine /*= FALSE*/)
{
	return 0;
}
