

/* this ALWAYS GENERATED file contains the IIDs and CLSIDs */

/* link this file in with the server and any clients */


 /* File created by MIDL compiler version 8.01.0628 */
/* at Tue Jan 19 04:14:07 2038
 */
/* Compiler settings for EudoraExe.idl:
    Oicf, W1, Zp8, env=Win32 (32b run), target_arch=X86 8.01.0628 
    protocol : dce , ms_ext, c_ext, robust
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
/* @@MIDL_FILE_HEADING(  ) */

#pragma warning( disable: 4049 )  /* more than 64k source lines */


#ifdef __cplusplus
extern "C"{
#endif 


#include <rpc.h>
#include <rpcndr.h>

#ifdef _MIDL_USE_GUIDDEF_

#ifndef INITGUID
#define INITGUID
#include <guiddef.h>
#undef INITGUID
#else
#include <guiddef.h>
#endif

#define MIDL_DEFINE_GUID(type,name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8) \
        DEFINE_GUID(name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8)

#else // !_MIDL_USE_GUIDDEF_

#ifndef __IID_DEFINED__
#define __IID_DEFINED__

typedef struct _IID
{
    unsigned long x;
    unsigned short s1;
    unsigned short s2;
    unsigned char  c[8];
} IID;

#endif // __IID_DEFINED__

#ifndef CLSID_DEFINED
#define CLSID_DEFINED
typedef IID CLSID;
#endif // CLSID_DEFINED

#define MIDL_DEFINE_GUID(type,name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8) \
        EXTERN_C __declspec(selectany) const type name = {l,w1,w2,{b1,b2,b3,b4,b5,b6,b7,b8}}

#endif // !_MIDL_USE_GUIDDEF_

MIDL_DEFINE_GUID(IID, IID_IEuApplication,0xEDA10001,0xAAAA,0x11d0,0xB3,0xC5,0x00,0x80,0x5F,0x8A,0xA4,0xFB);


MIDL_DEFINE_GUID(IID, IID_IEuMessage,0xEDA10004,0xAAAA,0x11d0,0xB3,0xC5,0x00,0x80,0x5F,0x8A,0xA4,0xFB);


MIDL_DEFINE_GUID(IID, IID_IEuMessages,0xEDA10005,0xAAAA,0x11d0,0xB3,0xC5,0x00,0x80,0x5F,0x8A,0xA4,0xFB);


MIDL_DEFINE_GUID(IID, IID_IEuFolder,0xEDA10014,0xAAAA,0x11d0,0xB3,0xC5,0x00,0x80,0x5F,0x8A,0xA4,0xFB);


MIDL_DEFINE_GUID(IID, IID_IEuFolders,0xEDA10015,0xAAAA,0x11d0,0xB3,0xC5,0x00,0x80,0x5F,0x8A,0xA4,0xFB);


MIDL_DEFINE_GUID(IID, LIBID_EudoraLib,0xEDA00000,0xAAAA,0x11d0,0xB3,0xC5,0x00,0x80,0x5F,0x8A,0xA4,0xFB);


MIDL_DEFINE_GUID(IID, DIID_IEuApplicationEvents,0xEDA30001,0xAAAA,0x11d0,0xB3,0xC5,0x00,0x80,0x5F,0x8A,0xA4,0xFB);


MIDL_DEFINE_GUID(CLSID, CLSID_EuApplication,0xEDA20001,0xAAAA,0x11d0,0xB3,0xC5,0x00,0x80,0x5F,0x8A,0xA4,0xFB);


MIDL_DEFINE_GUID(CLSID, CLSID_EuMessage,0xEDA20014,0xAAAA,0x11d0,0xB3,0xC5,0x00,0x80,0x5F,0x8A,0xA4,0xFB);


MIDL_DEFINE_GUID(CLSID, CLSID_EuMessages,0xEDA20004,0xAAAA,0x11d0,0xB3,0xC5,0x00,0x80,0x5F,0x8A,0xA4,0xFB);


MIDL_DEFINE_GUID(CLSID, CLSID_EuFolder,0xEDA20005,0xAAAA,0x11d0,0xB3,0xC5,0x00,0x80,0x5F,0x8A,0xA4,0xFB);


MIDL_DEFINE_GUID(CLSID, CLSID_EuFolders,0xEDA20015,0xAAAA,0x11d0,0xB3,0xC5,0x00,0x80,0x5F,0x8A,0xA4,0xFB);

#undef MIDL_DEFINE_GUID

#ifdef __cplusplus
}
#endif



