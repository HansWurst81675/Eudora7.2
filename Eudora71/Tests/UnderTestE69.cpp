//
// UnderTestE69.cpp - bindet die beiden E-69-Regeln aus dem Produktivcode ein
//
// Beide .inc-Dateien werden bei jedem Build von Extract.ps1 frisch
// geschnitten - aus filtersd.cpp und aus TaskErrorView.cpp. Hier steht
// deshalb bewusst kein abgeschriebener Code.
//
// WARUM DAS GEPRUEFT WIRD. Bis zum 19.10.2026 legte Eudora bei jeder
// uebersprungenen Nachricht einen eigenen Eintrag in "Task Errors" an. Jeder
// Eintrag piept und holt das Fenster nach vorn. Filtert der Anwender ein
// IMAP-Postfach mit 500 angerissenen Nachrichten, waehrend der Server nicht
// erreichbar ist, sind das 500 Pieptoene und 500 Fenstersprunge - und man
// kann es nicht wegklicken.
//
// Beide Regeln sind reine Buchhaltung: keine Task Errors, kein Fenster, kein
// CSummary. Genau deshalb stehen sie in eigenen Einheiten und nicht im
// Meldeweg - bei E-106 stand dieselbe Art Regel mitten im Ladeweg und war
// nur an Gregors Rechner pruefbar.
//
#include <windows.h>
#include <stdlib.h>

#include "UnderTestE69.h"

// --------------------------------------------------- A: die Buchhaltung
#include "generated/filtersd_e69.inc"

// --------------------------------------------------- B: die Zeitregel
#include "generated/taskerror_e69.inc"

// --------------------------------------------------------- Schnittstelle
#line 35 "UnderTestE69.cpp"

void* UTE69_Neu(void)
{
	CE69Sammlung* p = new CE69Sammlung;
	p->nTiefe = 0;
	p->nUebersprungen = 0;
	p->bErstGemeldet = false;
	return p;
}

void UTE69_Frei(void* pSammlung)
{
	delete (CE69Sammlung*) pSammlung;
}

void UTE69_LaufBeginn(void* pSammlung)
{
	((CE69Sammlung*) pSammlung)->LaufBeginn();
}

bool UTE69_Melden(void* pSammlung)
{
	return ((CE69Sammlung*) pSammlung)->Melden();
}

int UTE69_LaufEnde(void* pSammlung)
{
	return ((CE69Sammlung*) pSammlung)->LaufEnde();
}
