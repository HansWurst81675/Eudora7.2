@echo off
cd %1%
echo ...............................................
echo .           Starting Post Build BIND          .
echo ...............................................
rem E-130 (23.10.2026): nur noch die eigenen Bauergebnisse binden. Die vorgebauten
rem Fremd-DLLs (DirServ, EudoraBk, ISock, LDAP, LDAP32, Paige32, Ph, SPELL32,
rem EuMemMgr, libeay32, ssleay32, libexpat, x1lib) sind QUALCOMMs Originale;
rem bind schrieb bei jedem Bau Pruefsumme und Zeitstempel hinein.
..\..\BinTools\bind -p .;%windir%;%windir%\system32 -u -v Eudora.exe EudoraRes.dll QCUtils.dll imap.dll QCSocket.dll plstclnt.dll EuLang.dll QCSSL.dll
echo ...............................................
echo .            Ending Post Build BIND           .
echo ...............................................

