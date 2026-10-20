//
// TestE131.cpp - Befund E-131: eine ungueltige Schwebeposition in der INI
//
// Ein Anwender hat am 18.10.2026 gemeldet (Issue #102), dass sein Hermes
// 7.1.0.9 nach dem Lauf unserer Fassung v1.0.101 nicht mehr startet:
// EXCEPTION_ACCESS_VIOLATION in MFC71.DLL, Ordinal 3952, ECX=0. In der
// gemeinsam benutzten Eudora.ini stand MRUFloatXPos=-2147483648 - INT_MIN,
// kein Bildschirmpunkt.
//
// Am 20.10.2026 am Pruefstand nachgestellt: ein einziges Starten und Beenden
// von 7.2.0.112 genuegte. Die INI wuchs von 3249 auf 6480 Byte, und der Wert
// stand dreimal darin.
//
// Geprueft wird hier die Entscheidung allein: ist diese Position brauchbar?
// Das Durchgehen der INI-Abschnitte steht daneben in mainfrm.cpp und ist
// ohne Oberflaeche nicht zu pruefen - diese Rechnung schon.
//
#include <afx.h>
#include <afxwin.h>
#include <stdio.h>

#include "TinyTest.h"
#include "UnderTestE131.h"

void RunE131Tests(void)
{
	TT_Suite("E-131: ungueltige Schwebeposition in der Eudora.ini");

	// Ein ueblicher Bildschirm: 1920x1294 an 0,0 - so hat ihn der
	// Pruefstand am 20.10.2026 gemeldet.
	const int L = 0, O = 0, B = 1920, H = 1294;

	// ------------------------------------------------------------- (1)
	// Der gemeldete Wert. Ohne diesen Fall ist die ganze Behebung nicht
	// belegt.
	TT_BeginTest("E-131: INT_MIN ist keine brauchbare Position");
	{
		TT_CHECK_MSG(!E131PositionIstBrauchbar(-2147483647 - 1, 0, L, O, B, H),
			"MRUFloatXPos=-2147483648 wird verworfen");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (2)
	// Die Gegenprobe: gewoehnliche Positionen muessen durchgehen. Ohne sie
	// waere aus der Behebung "jede Position wird ueberschrieben" geworden,
	// und der Anwender fiende seine Leisten jedes Mal woanders.
	TT_BeginTest("E-131 Gegenprobe: gewoehnliche Positionen bleiben unangetastet");
	{
		TT_CHECK_MSG(E131PositionIstBrauchbar(100, 100, L, O, B, H), "mitten auf dem Schirm");
		TT_CHECK_MSG(E131PositionIstBrauchbar(0, 0, L, O, B, H), "linke obere Ecke");
		TT_CHECK_MSG(E131PositionIstBrauchbar(1800, 1200, L, O, B, H), "rechts unten");
		TT_CHECK_MSG(E131PositionIstBrauchbar(40, 40, L, O, B, H), "der Ersatzwert selbst");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (3)
	// Ein Fenster darf ueber den Rand hinausragen - solange ein Streifen
	// sichtbar bleibt. Wer enger prueft, zerstoert gueltige Anordnungen.
	TT_BeginTest("E-131: teilweise ausserhalb ist erlaubt, ganz draussen nicht");
	{
		TT_CHECK_MSG(E131PositionIstBrauchbar(-1800, 0, L, O, B, H),
			"ein Streifen ragt noch herein");
		TT_CHECK_MSG(!E131PositionIstBrauchbar(-1900, 0, L, O, B, H),
			"ganz links ausserhalb");
		TT_CHECK_MSG(!E131PositionIstBrauchbar(0, 1400, L, O, B, H),
			"unterhalb des Schirms");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (4)
	// Zwei Bildschirme: der linke liegt bei negativen x. Negative Werte
	// sind dann voellig normal und duerfen nicht verworfen werden.
	TT_BeginTest("E-131: zweiter Bildschirm links - negatives x ist gueltig");
	{
		const int L2 = -1920, O2 = 0, B2 = 3840, H2 = 1080;
		TT_CHECK_MSG(E131PositionIstBrauchbar(-1000, 300, L2, O2, B2, H2),
			"auf dem linken Schirm");
		TT_CHECK_MSG(!E131PositionIstBrauchbar(-2147483647 - 1, 0, L2, O2, B2, H2),
			"INT_MIN bleibt auch dort falsch");
	}
	TT_EndTest();

	// ------------------------------------------------------------- (5)
	// Weiss das Programm nichts ueber den Bildschirm, wird nicht geurteilt.
	// Lieber stehen lassen als aufgrund einer Fehlmessung ueberschreiben.
	TT_BeginTest("E-131: ohne Bildschirmmass wird nichts verworfen");
	{
		TT_CHECK_MSG(E131PositionIstBrauchbar(-2147483647 - 1, 0, 0, 0, 0, 0),
			"Breite und Hoehe 0: keine Entscheidung");
		TT_CHECK_MSG(E131PositionIstBrauchbar(12345, 0, 0, 0, -5, -5),
			"negative Masse: keine Entscheidung");
	}
	TT_EndTest();
}
