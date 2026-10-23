//
// UnderTestE116.cpp - bindet decimal_value_percent aus PGHTMIMP.CPP ein
//
// Die .inc-Datei wird bei jedem Build von Extract.ps1 frisch geschnitten.
// pg_char_ptr ist in Eudoras Bau (Win32, ohne UNICODE) unsigned char*
// (PaigeDLL/PGHEADER/CPUDEFS.H); PGHTMIMP.CPP selbst zieht die ganze
// Paige-Welt herein und ist darum nicht einzeln uebersetzbar.
//
#include "UnderTestE116.h"

typedef unsigned char pg_char;
typedef pg_char* pg_char_ptr;

#include "generated/pghtmimp_e116.inc"

long E116DecimalValuePercent(const char* param, long max_for_percent)
{
	return decimal_value_percent((pg_char_ptr)param, max_for_percent);
}
