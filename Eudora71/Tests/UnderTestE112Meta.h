//
// UnderTestE112Meta.h - Zugriff auf E112MetadateiAusDIB aus QCGraphics.cpp
//
// Die Funktion wird bei jedem Bau von Extract.ps1 (Region O) frisch aus dem
// Produktivcode geschnitten - es gibt keine Abschrift, die veralten koennte.
//
#ifndef EUDORA_TESTS_UNDERTEST_E112_META_H
#define EUDORA_TESTS_UNDERTEST_E112_META_H

#include <windows.h>

HMETAFILE E112MetadateiAusDIB(const BITMAPINFO* pBMI, const void* pBits,
							  long nEchtBreite, long nEchtHoehe,
							  long nZielBreite, long nZielHoehe);

#endif
