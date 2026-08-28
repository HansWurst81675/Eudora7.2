

/* this ALWAYS GENERATED file contains the proxy stub code */


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

#if !defined(_M_IA64) && !defined(_M_AMD64) && !defined(_ARM_)


#pragma warning( disable: 4049 )  /* more than 64k source lines */
#if _MSC_VER >= 1200
#pragma warning(push)
#endif

#pragma warning( disable: 4211 )  /* redefine extern to static */
#pragma warning( disable: 4232 )  /* dllimport identity*/
#pragma warning( disable: 4024 )  /* array to pointer mapping*/
#pragma warning( disable: 4152 )  /* function/data pointer conversion in expression */
#pragma warning( disable: 4100 ) /* unreferenced arguments in x86 call */

#pragma optimize("", off ) 

#define USE_STUBLESS_PROXY


/* verify that the <rpcproxy.h> version is high enough to compile this file*/
#ifndef __REDQ_RPCPROXY_H_VERSION__
#define __REQUIRED_RPCPROXY_H_VERSION__ 475
#endif


#include "rpcproxy.h"
#ifndef __RPCPROXY_H_VERSION__
#error this stub requires an updated version of <rpcproxy.h>
#endif /* __RPCPROXY_H_VERSION__ */


#include "EudoraExe.h"

#define TYPE_FORMAT_STRING_SIZE   1185                              
#define PROC_FORMAT_STRING_SIZE   2557                              
#define EXPR_FORMAT_STRING_SIZE   1                                 
#define TRANSMIT_AS_TABLE_SIZE    0            
#define WIRE_MARSHAL_TABLE_SIZE   2            

typedef struct _EudoraExe_MIDL_TYPE_FORMAT_STRING
    {
    short          Pad;
    unsigned char  Format[ TYPE_FORMAT_STRING_SIZE ];
    } EudoraExe_MIDL_TYPE_FORMAT_STRING;

typedef struct _EudoraExe_MIDL_PROC_FORMAT_STRING
    {
    short          Pad;
    unsigned char  Format[ PROC_FORMAT_STRING_SIZE ];
    } EudoraExe_MIDL_PROC_FORMAT_STRING;

typedef struct _EudoraExe_MIDL_EXPR_FORMAT_STRING
    {
    long          Pad;
    unsigned char  Format[ EXPR_FORMAT_STRING_SIZE ];
    } EudoraExe_MIDL_EXPR_FORMAT_STRING;


static const RPC_SYNTAX_IDENTIFIER  _RpcTransferSyntax_2_0 = 
{{0x8A885D04,0x1CEB,0x11C9,{0x9F,0xE8,0x08,0x00,0x2B,0x10,0x48,0x60}},{2,0}};

#if defined(_CONTROL_FLOW_GUARD_XFG)
#define XFG_TRAMPOLINES(ObjectType)\
NDR_SHAREABLE unsigned long ObjectType ## _UserSize_XFG(unsigned long * pFlags, unsigned long Offset, void * pObject)\
{\
return  ObjectType ## _UserSize(pFlags, Offset, (ObjectType *)pObject);\
}\
NDR_SHAREABLE unsigned char * ObjectType ## _UserMarshal_XFG(unsigned long * pFlags, unsigned char * pBuffer, void * pObject)\
{\
return ObjectType ## _UserMarshal(pFlags, pBuffer, (ObjectType *)pObject);\
}\
NDR_SHAREABLE unsigned char * ObjectType ## _UserUnmarshal_XFG(unsigned long * pFlags, unsigned char * pBuffer, void * pObject)\
{\
return ObjectType ## _UserUnmarshal(pFlags, pBuffer, (ObjectType *)pObject);\
}\
NDR_SHAREABLE void ObjectType ## _UserFree_XFG(unsigned long * pFlags, void * pObject)\
{\
ObjectType ## _UserFree(pFlags, (ObjectType *)pObject);\
}
#define XFG_TRAMPOLINES64(ObjectType)\
NDR_SHAREABLE unsigned long ObjectType ## _UserSize64_XFG(unsigned long * pFlags, unsigned long Offset, void * pObject)\
{\
return  ObjectType ## _UserSize64(pFlags, Offset, (ObjectType *)pObject);\
}\
NDR_SHAREABLE unsigned char * ObjectType ## _UserMarshal64_XFG(unsigned long * pFlags, unsigned char * pBuffer, void * pObject)\
{\
return ObjectType ## _UserMarshal64(pFlags, pBuffer, (ObjectType *)pObject);\
}\
NDR_SHAREABLE unsigned char * ObjectType ## _UserUnmarshal64_XFG(unsigned long * pFlags, unsigned char * pBuffer, void * pObject)\
{\
return ObjectType ## _UserUnmarshal64(pFlags, pBuffer, (ObjectType *)pObject);\
}\
NDR_SHAREABLE void ObjectType ## _UserFree64_XFG(unsigned long * pFlags, void * pObject)\
{\
ObjectType ## _UserFree64(pFlags, (ObjectType *)pObject);\
}
#define XFG_BIND_TRAMPOLINES(HandleType, ObjectType)\
static void* ObjectType ## _bind_XFG(HandleType pObject)\
{\
return ObjectType ## _bind((ObjectType) pObject);\
}\
static void ObjectType ## _unbind_XFG(HandleType pObject, handle_t ServerHandle)\
{\
ObjectType ## _unbind((ObjectType) pObject, ServerHandle);\
}
#define XFG_TRAMPOLINE_FPTR(Function) Function ## _XFG
#define XFG_TRAMPOLINE_FPTR_DEPENDENT_SYMBOL(Symbol) Symbol ## _XFG
#else
#define XFG_TRAMPOLINES(ObjectType)
#define XFG_TRAMPOLINES64(ObjectType)
#define XFG_BIND_TRAMPOLINES(HandleType, ObjectType)
#define XFG_TRAMPOLINE_FPTR(Function) Function
#define XFG_TRAMPOLINE_FPTR_DEPENDENT_SYMBOL(Symbol) Symbol
#endif


extern const EudoraExe_MIDL_TYPE_FORMAT_STRING EudoraExe__MIDL_TypeFormatString;
extern const EudoraExe_MIDL_PROC_FORMAT_STRING EudoraExe__MIDL_ProcFormatString;
extern const EudoraExe_MIDL_EXPR_FORMAT_STRING EudoraExe__MIDL_ExprFormatString;

#ifdef __cplusplus
namespace {
#endif

extern const MIDL_STUB_DESC Object_StubDesc;
#ifdef __cplusplus
}
#endif


extern const MIDL_SERVER_INFO IEuApplication_ServerInfo;
extern const MIDL_STUBLESS_PROXY_INFO IEuApplication_ProxyInfo;

#ifdef __cplusplus
namespace {
#endif

extern const MIDL_STUB_DESC Object_StubDesc;
#ifdef __cplusplus
}
#endif


extern const MIDL_SERVER_INFO IEuMessage_ServerInfo;
extern const MIDL_STUBLESS_PROXY_INFO IEuMessage_ProxyInfo;

#ifdef __cplusplus
namespace {
#endif

extern const MIDL_STUB_DESC Object_StubDesc;
#ifdef __cplusplus
}
#endif


extern const MIDL_SERVER_INFO IEuMessages_ServerInfo;
extern const MIDL_STUBLESS_PROXY_INFO IEuMessages_ProxyInfo;

#ifdef __cplusplus
namespace {
#endif

extern const MIDL_STUB_DESC Object_StubDesc;
#ifdef __cplusplus
}
#endif


extern const MIDL_SERVER_INFO IEuFolder_ServerInfo;
extern const MIDL_STUBLESS_PROXY_INFO IEuFolder_ProxyInfo;

#ifdef __cplusplus
namespace {
#endif

extern const MIDL_STUB_DESC Object_StubDesc;
#ifdef __cplusplus
}
#endif


extern const MIDL_SERVER_INFO IEuFolders_ServerInfo;
extern const MIDL_STUBLESS_PROXY_INFO IEuFolders_ProxyInfo;


extern const USER_MARSHAL_ROUTINE_QUADRUPLE UserMarshalRoutines[ WIRE_MARSHAL_TABLE_SIZE ];

#if !defined(__RPC_WIN32__)
#error  Invalid build platform for this stub.
#endif

#if !(TARGET_IS_NT50_OR_LATER)
#error You need Windows 2000 or later to run this stub because it uses these features:
#error   /robust command line switch.
#error However, your C/C++ compilation flags indicate you intend to run this app on earlier systems.
#error This app will fail with the RPC_X_WRONG_STUB_VERSION error.
#endif


static const EudoraExe_MIDL_PROC_FORMAT_STRING EudoraExe__MIDL_ProcFormatString =
    {
        0,
        {

	/* Procedure get_Application */

			0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/*  2 */	NdrFcLong( 0x0 ),	/* 0 */
/*  6 */	NdrFcShort( 0x7 ),	/* 7 */
/*  8 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 10 */	NdrFcShort( 0x0 ),	/* 0 */
/* 12 */	NdrFcShort( 0x8 ),	/* 8 */
/* 14 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 16 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 18 */	NdrFcShort( 0x0 ),	/* 0 */
/* 20 */	NdrFcShort( 0x0 ),	/* 0 */
/* 22 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 24 */	NdrFcShort( 0x13 ),	/* Flags:  must size, must free, out, */
/* 26 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 28 */	NdrFcShort( 0x2 ),	/* Type Offset=2 */

	/* Return value */

/* 30 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 32 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 34 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Body */


	/* Procedure get_Caption */

/* 36 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 38 */	NdrFcLong( 0x0 ),	/* 0 */
/* 42 */	NdrFcShort( 0x8 ),	/* 8 */
/* 44 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 46 */	NdrFcShort( 0x0 ),	/* 0 */
/* 48 */	NdrFcShort( 0x8 ),	/* 8 */
/* 50 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 52 */	0x8,		/* 8 */
			0x3,		/* Ext Flags:  new corr desc, clt corr check, */
/* 54 */	NdrFcShort( 0x1 ),	/* 1 */
/* 56 */	NdrFcShort( 0x0 ),	/* 0 */
/* 58 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */


	/* Parameter pVal */

/* 60 */	NdrFcShort( 0x2113 ),	/* Flags:  must size, must free, out, simple ref, srv alloc size=8 */
/* 62 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 64 */	NdrFcShort( 0x36 ),	/* Type Offset=54 */

	/* Return value */


	/* Return value */

/* 66 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 68 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 70 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure put_Caption */

/* 72 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 74 */	NdrFcLong( 0x0 ),	/* 0 */
/* 78 */	NdrFcShort( 0x9 ),	/* 9 */
/* 80 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 82 */	NdrFcShort( 0x0 ),	/* 0 */
/* 84 */	NdrFcShort( 0x8 ),	/* 8 */
/* 86 */	0x46,		/* Oi2 Flags:  clt must size, has return, has ext, */
			0x2,		/* 2 */
/* 88 */	0x8,		/* 8 */
			0x5,		/* Ext Flags:  new corr desc, srv corr check, */
/* 90 */	NdrFcShort( 0x0 ),	/* 0 */
/* 92 */	NdrFcShort( 0x1 ),	/* 1 */
/* 94 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter newVal */

/* 96 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 98 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 100 */	NdrFcShort( 0x44 ),	/* Type Offset=68 */

	/* Return value */

/* 102 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 104 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 106 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Folders */

/* 108 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 110 */	NdrFcLong( 0x0 ),	/* 0 */
/* 114 */	NdrFcShort( 0xa ),	/* 10 */
/* 116 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 118 */	NdrFcShort( 0x0 ),	/* 0 */
/* 120 */	NdrFcShort( 0x8 ),	/* 8 */
/* 122 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 124 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 126 */	NdrFcShort( 0x0 ),	/* 0 */
/* 128 */	NdrFcShort( 0x0 ),	/* 0 */
/* 130 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 132 */	NdrFcShort( 0x13 ),	/* Flags:  must size, must free, out, */
/* 134 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 136 */	NdrFcShort( 0x4e ),	/* Type Offset=78 */

	/* Return value */

/* 138 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 140 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 142 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Date */


	/* Procedure get_FullName */

/* 144 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 146 */	NdrFcLong( 0x0 ),	/* 0 */
/* 150 */	NdrFcShort( 0xb ),	/* 11 */
/* 152 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 154 */	NdrFcShort( 0x0 ),	/* 0 */
/* 156 */	NdrFcShort( 0x8 ),	/* 8 */
/* 158 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 160 */	0x8,		/* 8 */
			0x3,		/* Ext Flags:  new corr desc, clt corr check, */
/* 162 */	NdrFcShort( 0x1 ),	/* 1 */
/* 164 */	NdrFcShort( 0x0 ),	/* 0 */
/* 166 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */


	/* Parameter pVal */

/* 168 */	NdrFcShort( 0x2113 ),	/* Flags:  must size, must free, out, simple ref, srv alloc size=8 */
/* 170 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 172 */	NdrFcShort( 0x36 ),	/* Type Offset=54 */

	/* Return value */


	/* Return value */

/* 174 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 176 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 178 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Height */

/* 180 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 182 */	NdrFcLong( 0x0 ),	/* 0 */
/* 186 */	NdrFcShort( 0xc ),	/* 12 */
/* 188 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 190 */	NdrFcShort( 0x0 ),	/* 0 */
/* 192 */	NdrFcShort( 0x24 ),	/* 36 */
/* 194 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 196 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 198 */	NdrFcShort( 0x0 ),	/* 0 */
/* 200 */	NdrFcShort( 0x0 ),	/* 0 */
/* 202 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 204 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 206 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 208 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 210 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 212 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 214 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure put_Height */

/* 216 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 218 */	NdrFcLong( 0x0 ),	/* 0 */
/* 222 */	NdrFcShort( 0xd ),	/* 13 */
/* 224 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 226 */	NdrFcShort( 0x8 ),	/* 8 */
/* 228 */	NdrFcShort( 0x8 ),	/* 8 */
/* 230 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 232 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 234 */	NdrFcShort( 0x0 ),	/* 0 */
/* 236 */	NdrFcShort( 0x0 ),	/* 0 */
/* 238 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter newVal */

/* 240 */	NdrFcShort( 0x48 ),	/* Flags:  in, base type, */
/* 242 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 244 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 246 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 248 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 250 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_InBox */

/* 252 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 254 */	NdrFcLong( 0x0 ),	/* 0 */
/* 258 */	NdrFcShort( 0xe ),	/* 14 */
/* 260 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 262 */	NdrFcShort( 0x0 ),	/* 0 */
/* 264 */	NdrFcShort( 0x8 ),	/* 8 */
/* 266 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 268 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 270 */	NdrFcShort( 0x0 ),	/* 0 */
/* 272 */	NdrFcShort( 0x0 ),	/* 0 */
/* 274 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 276 */	NdrFcShort( 0x13 ),	/* Flags:  must size, must free, out, */
/* 278 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 280 */	NdrFcShort( 0x68 ),	/* Type Offset=104 */

	/* Return value */

/* 282 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 284 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 286 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Index */


	/* Procedure get_Index */


	/* Procedure get_Interactive */

/* 288 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 290 */	NdrFcLong( 0x0 ),	/* 0 */
/* 294 */	NdrFcShort( 0xf ),	/* 15 */
/* 296 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 298 */	NdrFcShort( 0x0 ),	/* 0 */
/* 300 */	NdrFcShort( 0x24 ),	/* 36 */
/* 302 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 304 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 306 */	NdrFcShort( 0x0 ),	/* 0 */
/* 308 */	NdrFcShort( 0x0 ),	/* 0 */
/* 310 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */


	/* Parameter pVal */


	/* Parameter pVal */

/* 312 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 314 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 316 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */


	/* Return value */


	/* Return value */

/* 318 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 320 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 322 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Left */

/* 324 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 326 */	NdrFcLong( 0x0 ),	/* 0 */
/* 330 */	NdrFcShort( 0x10 ),	/* 16 */
/* 332 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 334 */	NdrFcShort( 0x0 ),	/* 0 */
/* 336 */	NdrFcShort( 0x24 ),	/* 36 */
/* 338 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 340 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 342 */	NdrFcShort( 0x0 ),	/* 0 */
/* 344 */	NdrFcShort( 0x0 ),	/* 0 */
/* 346 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 348 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 350 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 352 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 354 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 356 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 358 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure put_Left */

/* 360 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 362 */	NdrFcLong( 0x0 ),	/* 0 */
/* 366 */	NdrFcShort( 0x11 ),	/* 17 */
/* 368 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 370 */	NdrFcShort( 0x8 ),	/* 8 */
/* 372 */	NdrFcShort( 0x8 ),	/* 8 */
/* 374 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 376 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 378 */	NdrFcShort( 0x0 ),	/* 0 */
/* 380 */	NdrFcShort( 0x0 ),	/* 0 */
/* 382 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter newVal */

/* 384 */	NdrFcShort( 0x48 ),	/* Flags:  in, base type, */
/* 386 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 388 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 390 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 392 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 394 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Path */


	/* Procedure get_Priority */


	/* Procedure get_Name */

/* 396 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 398 */	NdrFcLong( 0x0 ),	/* 0 */
/* 402 */	NdrFcShort( 0x12 ),	/* 18 */
/* 404 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 406 */	NdrFcShort( 0x0 ),	/* 0 */
/* 408 */	NdrFcShort( 0x8 ),	/* 8 */
/* 410 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 412 */	0x8,		/* 8 */
			0x3,		/* Ext Flags:  new corr desc, clt corr check, */
/* 414 */	NdrFcShort( 0x1 ),	/* 1 */
/* 416 */	NdrFcShort( 0x0 ),	/* 0 */
/* 418 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */


	/* Parameter pVal */


	/* Parameter pVal */

/* 420 */	NdrFcShort( 0x2113 ),	/* Flags:  must size, must free, out, simple ref, srv alloc size=8 */
/* 422 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 424 */	NdrFcShort( 0x36 ),	/* Type Offset=54 */

	/* Return value */


	/* Return value */


	/* Return value */

/* 426 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 428 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 430 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Path */

/* 432 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 434 */	NdrFcLong( 0x0 ),	/* 0 */
/* 438 */	NdrFcShort( 0x13 ),	/* 19 */
/* 440 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 442 */	NdrFcShort( 0x0 ),	/* 0 */
/* 444 */	NdrFcShort( 0x8 ),	/* 8 */
/* 446 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 448 */	0x8,		/* 8 */
			0x3,		/* Ext Flags:  new corr desc, clt corr check, */
/* 450 */	NdrFcShort( 0x1 ),	/* 1 */
/* 452 */	NdrFcShort( 0x0 ),	/* 0 */
/* 454 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 456 */	NdrFcShort( 0x2113 ),	/* Flags:  must size, must free, out, simple ref, srv alloc size=8 */
/* 458 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 460 */	NdrFcShort( 0x36 ),	/* Type Offset=54 */

	/* Return value */

/* 462 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 464 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 466 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Parent */

/* 468 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 470 */	NdrFcLong( 0x0 ),	/* 0 */
/* 474 */	NdrFcShort( 0x14 ),	/* 20 */
/* 476 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 478 */	NdrFcShort( 0x0 ),	/* 0 */
/* 480 */	NdrFcShort( 0x8 ),	/* 8 */
/* 482 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 484 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 486 */	NdrFcShort( 0x0 ),	/* 0 */
/* 488 */	NdrFcShort( 0x0 ),	/* 0 */
/* 490 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 492 */	NdrFcShort( 0x13 ),	/* Flags:  must size, must free, out, */
/* 494 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 496 */	NdrFcShort( 0x2 ),	/* Type Offset=2 */

	/* Return value */

/* 498 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 500 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 502 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_ProcessID */

/* 504 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 506 */	NdrFcLong( 0x0 ),	/* 0 */
/* 510 */	NdrFcShort( 0x15 ),	/* 21 */
/* 512 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 514 */	NdrFcShort( 0x0 ),	/* 0 */
/* 516 */	NdrFcShort( 0x24 ),	/* 36 */
/* 518 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 520 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 522 */	NdrFcShort( 0x0 ),	/* 0 */
/* 524 */	NdrFcShort( 0x0 ),	/* 0 */
/* 526 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 528 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 530 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 532 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 534 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 536 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 538 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_RefCount */

/* 540 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 542 */	NdrFcLong( 0x0 ),	/* 0 */
/* 546 */	NdrFcShort( 0x16 ),	/* 22 */
/* 548 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 550 */	NdrFcShort( 0x0 ),	/* 0 */
/* 552 */	NdrFcShort( 0x24 ),	/* 36 */
/* 554 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 556 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 558 */	NdrFcShort( 0x0 ),	/* 0 */
/* 560 */	NdrFcShort( 0x0 ),	/* 0 */
/* 562 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 564 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 566 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 568 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 570 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 572 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 574 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_RootFolder */

/* 576 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 578 */	NdrFcLong( 0x0 ),	/* 0 */
/* 582 */	NdrFcShort( 0x17 ),	/* 23 */
/* 584 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 586 */	NdrFcShort( 0x0 ),	/* 0 */
/* 588 */	NdrFcShort( 0x8 ),	/* 8 */
/* 590 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 592 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 594 */	NdrFcShort( 0x0 ),	/* 0 */
/* 596 */	NdrFcShort( 0x0 ),	/* 0 */
/* 598 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 600 */	NdrFcShort( 0x13 ),	/* Flags:  must size, must free, out, */
/* 602 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 604 */	NdrFcShort( 0x68 ),	/* Type Offset=104 */

	/* Return value */

/* 606 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 608 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 610 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_StatusBar */

/* 612 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 614 */	NdrFcLong( 0x0 ),	/* 0 */
/* 618 */	NdrFcShort( 0x18 ),	/* 24 */
/* 620 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 622 */	NdrFcShort( 0x0 ),	/* 0 */
/* 624 */	NdrFcShort( 0x8 ),	/* 8 */
/* 626 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 628 */	0x8,		/* 8 */
			0x3,		/* Ext Flags:  new corr desc, clt corr check, */
/* 630 */	NdrFcShort( 0x1 ),	/* 1 */
/* 632 */	NdrFcShort( 0x0 ),	/* 0 */
/* 634 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 636 */	NdrFcShort( 0x2113 ),	/* Flags:  must size, must free, out, simple ref, srv alloc size=8 */
/* 638 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 640 */	NdrFcShort( 0x36 ),	/* Type Offset=54 */

	/* Return value */

/* 642 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 644 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 646 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure put_StatusBar */

/* 648 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 650 */	NdrFcLong( 0x0 ),	/* 0 */
/* 654 */	NdrFcShort( 0x19 ),	/* 25 */
/* 656 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 658 */	NdrFcShort( 0x0 ),	/* 0 */
/* 660 */	NdrFcShort( 0x8 ),	/* 8 */
/* 662 */	0x46,		/* Oi2 Flags:  clt must size, has return, has ext, */
			0x2,		/* 2 */
/* 664 */	0x8,		/* 8 */
			0x5,		/* Ext Flags:  new corr desc, srv corr check, */
/* 666 */	NdrFcShort( 0x0 ),	/* 0 */
/* 668 */	NdrFcShort( 0x1 ),	/* 1 */
/* 670 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter newVal */

/* 672 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 674 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 676 */	NdrFcShort( 0x44 ),	/* Type Offset=68 */

	/* Return value */

/* 678 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 680 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 682 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Top */

/* 684 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 686 */	NdrFcLong( 0x0 ),	/* 0 */
/* 690 */	NdrFcShort( 0x1a ),	/* 26 */
/* 692 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 694 */	NdrFcShort( 0x0 ),	/* 0 */
/* 696 */	NdrFcShort( 0x24 ),	/* 36 */
/* 698 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 700 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 702 */	NdrFcShort( 0x0 ),	/* 0 */
/* 704 */	NdrFcShort( 0x0 ),	/* 0 */
/* 706 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 708 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 710 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 712 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 714 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 716 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 718 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure put_Top */

/* 720 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 722 */	NdrFcLong( 0x0 ),	/* 0 */
/* 726 */	NdrFcShort( 0x1b ),	/* 27 */
/* 728 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 730 */	NdrFcShort( 0x8 ),	/* 8 */
/* 732 */	NdrFcShort( 0x8 ),	/* 8 */
/* 734 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 736 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 738 */	NdrFcShort( 0x0 ),	/* 0 */
/* 740 */	NdrFcShort( 0x0 ),	/* 0 */
/* 742 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter newVal */

/* 744 */	NdrFcShort( 0x48 ),	/* Flags:  in, base type, */
/* 746 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 748 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 750 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 752 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 754 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_VersionBuild */

/* 756 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 758 */	NdrFcLong( 0x0 ),	/* 0 */
/* 762 */	NdrFcShort( 0x1c ),	/* 28 */
/* 764 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 766 */	NdrFcShort( 0x0 ),	/* 0 */
/* 768 */	NdrFcShort( 0x22 ),	/* 34 */
/* 770 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 772 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 774 */	NdrFcShort( 0x0 ),	/* 0 */
/* 776 */	NdrFcShort( 0x0 ),	/* 0 */
/* 778 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 780 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 782 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 784 */	0x6,		/* FC_SHORT */
			0x0,		/* 0 */

	/* Return value */

/* 786 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 788 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 790 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_VersionMajor */

/* 792 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 794 */	NdrFcLong( 0x0 ),	/* 0 */
/* 798 */	NdrFcShort( 0x1d ),	/* 29 */
/* 800 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 802 */	NdrFcShort( 0x0 ),	/* 0 */
/* 804 */	NdrFcShort( 0x22 ),	/* 34 */
/* 806 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 808 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 810 */	NdrFcShort( 0x0 ),	/* 0 */
/* 812 */	NdrFcShort( 0x0 ),	/* 0 */
/* 814 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 816 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 818 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 820 */	0x6,		/* FC_SHORT */
			0x0,		/* 0 */

	/* Return value */

/* 822 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 824 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 826 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_VersionMinor */

/* 828 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 830 */	NdrFcLong( 0x0 ),	/* 0 */
/* 834 */	NdrFcShort( 0x1e ),	/* 30 */
/* 836 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 838 */	NdrFcShort( 0x0 ),	/* 0 */
/* 840 */	NdrFcShort( 0x22 ),	/* 34 */
/* 842 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 844 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 846 */	NdrFcShort( 0x0 ),	/* 0 */
/* 848 */	NdrFcShort( 0x0 ),	/* 0 */
/* 850 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 852 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 854 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 856 */	0x6,		/* FC_SHORT */
			0x0,		/* 0 */

	/* Return value */

/* 858 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 860 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 862 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_VersionMinor2 */

/* 864 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 866 */	NdrFcLong( 0x0 ),	/* 0 */
/* 870 */	NdrFcShort( 0x1f ),	/* 31 */
/* 872 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 874 */	NdrFcShort( 0x0 ),	/* 0 */
/* 876 */	NdrFcShort( 0x22 ),	/* 34 */
/* 878 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 880 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 882 */	NdrFcShort( 0x0 ),	/* 0 */
/* 884 */	NdrFcShort( 0x0 ),	/* 0 */
/* 886 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 888 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 890 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 892 */	0x6,		/* FC_SHORT */
			0x0,		/* 0 */

	/* Return value */

/* 894 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 896 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 898 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Visible */

/* 900 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 902 */	NdrFcLong( 0x0 ),	/* 0 */
/* 906 */	NdrFcShort( 0x20 ),	/* 32 */
/* 908 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 910 */	NdrFcShort( 0x0 ),	/* 0 */
/* 912 */	NdrFcShort( 0x24 ),	/* 36 */
/* 914 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 916 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 918 */	NdrFcShort( 0x0 ),	/* 0 */
/* 920 */	NdrFcShort( 0x0 ),	/* 0 */
/* 922 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 924 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 926 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 928 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 930 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 932 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 934 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure put_Visible */

/* 936 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 938 */	NdrFcLong( 0x0 ),	/* 0 */
/* 942 */	NdrFcShort( 0x21 ),	/* 33 */
/* 944 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 946 */	NdrFcShort( 0x8 ),	/* 8 */
/* 948 */	NdrFcShort( 0x8 ),	/* 8 */
/* 950 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 952 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 954 */	NdrFcShort( 0x0 ),	/* 0 */
/* 956 */	NdrFcShort( 0x0 ),	/* 0 */
/* 958 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter newVal */

/* 960 */	NdrFcShort( 0x48 ),	/* Flags:  in, base type, */
/* 962 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 964 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 966 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 968 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 970 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Width */

/* 972 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 974 */	NdrFcLong( 0x0 ),	/* 0 */
/* 978 */	NdrFcShort( 0x22 ),	/* 34 */
/* 980 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 982 */	NdrFcShort( 0x0 ),	/* 0 */
/* 984 */	NdrFcShort( 0x24 ),	/* 36 */
/* 986 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 988 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 990 */	NdrFcShort( 0x0 ),	/* 0 */
/* 992 */	NdrFcShort( 0x0 ),	/* 0 */
/* 994 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 996 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 998 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1000 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 1002 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1004 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1006 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure put_Width */

/* 1008 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1010 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1014 */	NdrFcShort( 0x23 ),	/* 35 */
/* 1016 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1018 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1020 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1022 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 1024 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 1026 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1028 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1030 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter newVal */

/* 1032 */	NdrFcShort( 0x48 ),	/* Flags:  in, base type, */
/* 1034 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1036 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 1038 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1040 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1042 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure CloseEudora */

/* 1044 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1046 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1050 */	NdrFcShort( 0x24 ),	/* 36 */
/* 1052 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1054 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1056 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1058 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x1,		/* 1 */
/* 1060 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 1062 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1064 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1066 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Return value */

/* 1068 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1070 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1072 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure CheckMail */

/* 1074 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1076 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1080 */	NdrFcShort( 0x25 ),	/* 37 */
/* 1082 */	NdrFcShort( 0x18 ),	/* x86 Stack size/offset = 24 */
/* 1084 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1086 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1088 */	0x46,		/* Oi2 Flags:  clt must size, has return, has ext, */
			0x2,		/* 2 */
/* 1090 */	0x8,		/* 8 */
			0x5,		/* Ext Flags:  new corr desc, srv corr check, */
/* 1092 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1094 */	NdrFcShort( 0x1 ),	/* 1 */
/* 1096 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter Password */

/* 1098 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 1100 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1102 */	NdrFcShort( 0x466 ),	/* Type Offset=1126 */

	/* Return value */

/* 1104 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1106 */	NdrFcShort( 0x14 ),	/* x86 Stack size/offset = 20 */
/* 1108 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure CompactFolders */

/* 1110 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1112 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1116 */	NdrFcShort( 0x26 ),	/* 38 */
/* 1118 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1120 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1122 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1124 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x1,		/* 1 */
/* 1126 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 1128 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1130 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1132 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Return value */

/* 1134 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1136 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1138 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure EmptyTrash */

/* 1140 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1142 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1146 */	NdrFcShort( 0x27 ),	/* 39 */
/* 1148 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1150 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1152 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1154 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x1,		/* 1 */
/* 1156 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 1158 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1160 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1162 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Return value */

/* 1164 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1166 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1168 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure Folder */

/* 1170 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1172 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1176 */	NdrFcShort( 0x28 ),	/* 40 */
/* 1178 */	NdrFcShort( 0x14 ),	/* x86 Stack size/offset = 20 */
/* 1180 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1182 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1184 */	0x47,		/* Oi2 Flags:  srv must size, clt must size, has return, has ext, */
			0x4,		/* 4 */
/* 1186 */	0x8,		/* 8 */
			0x5,		/* Ext Flags:  new corr desc, srv corr check, */
/* 1188 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1190 */	NdrFcShort( 0x1 ),	/* 1 */
/* 1192 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter Name */

/* 1194 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 1196 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1198 */	NdrFcShort( 0x44 ),	/* Type Offset=68 */

	/* Parameter FindRecursive */

/* 1200 */	NdrFcShort( 0x48 ),	/* Flags:  in, base type, */
/* 1202 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1204 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Parameter pVal */

/* 1206 */	NdrFcShort( 0x13 ),	/* Flags:  must size, must free, out, */
/* 1208 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1210 */	NdrFcShort( 0x68 ),	/* Type Offset=104 */

	/* Return value */

/* 1212 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1214 */	NdrFcShort( 0x10 ),	/* x86 Stack size/offset = 16 */
/* 1216 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure FolderByID */

/* 1218 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1220 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1224 */	NdrFcShort( 0x29 ),	/* 41 */
/* 1226 */	NdrFcShort( 0x14 ),	/* x86 Stack size/offset = 20 */
/* 1228 */	NdrFcShort( 0x10 ),	/* 16 */
/* 1230 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1232 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x4,		/* 4 */
/* 1234 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 1236 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1238 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1240 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter ID */

/* 1242 */	NdrFcShort( 0x48 ),	/* Flags:  in, base type, */
/* 1244 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1246 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Parameter FindRecursive */

/* 1248 */	NdrFcShort( 0x48 ),	/* Flags:  in, base type, */
/* 1250 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1252 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Parameter pVal */

/* 1254 */	NdrFcShort( 0x13 ),	/* Flags:  must size, must free, out, */
/* 1256 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1258 */	NdrFcShort( 0x68 ),	/* Type Offset=104 */

	/* Return value */

/* 1260 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1262 */	NdrFcShort( 0x10 ),	/* x86 Stack size/offset = 16 */
/* 1264 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure QueueMessage */

/* 1266 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1268 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1272 */	NdrFcShort( 0x2a ),	/* 42 */
/* 1274 */	NdrFcShort( 0x20 ),	/* x86 Stack size/offset = 32 */
/* 1276 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1278 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1280 */	0x46,		/* Oi2 Flags:  clt must size, has return, has ext, */
			0x7,		/* 7 */
/* 1282 */	0x8,		/* 8 */
			0x5,		/* Ext Flags:  new corr desc, srv corr check, */
/* 1284 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1286 */	NdrFcShort( 0x1 ),	/* 1 */
/* 1288 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter To */

/* 1290 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 1292 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1294 */	NdrFcShort( 0x44 ),	/* Type Offset=68 */

	/* Parameter Subject */

/* 1296 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 1298 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1300 */	NdrFcShort( 0x44 ),	/* Type Offset=68 */

	/* Parameter Cc */

/* 1302 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 1304 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1306 */	NdrFcShort( 0x44 ),	/* Type Offset=68 */

	/* Parameter Bcc */

/* 1308 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 1310 */	NdrFcShort( 0x10 ),	/* x86 Stack size/offset = 16 */
/* 1312 */	NdrFcShort( 0x44 ),	/* Type Offset=68 */

	/* Parameter Attach */

/* 1314 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 1316 */	NdrFcShort( 0x14 ),	/* x86 Stack size/offset = 20 */
/* 1318 */	NdrFcShort( 0x44 ),	/* Type Offset=68 */

	/* Parameter Body */

/* 1320 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 1322 */	NdrFcShort( 0x18 ),	/* x86 Stack size/offset = 24 */
/* 1324 */	NdrFcShort( 0x44 ),	/* Type Offset=68 */

	/* Return value */

/* 1326 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1328 */	NdrFcShort( 0x1c ),	/* x86 Stack size/offset = 28 */
/* 1330 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure SendQueuedMessages */

/* 1332 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1334 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1338 */	NdrFcShort( 0x2b ),	/* 43 */
/* 1340 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1342 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1344 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1346 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x1,		/* 1 */
/* 1348 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 1350 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1352 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1354 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Return value */

/* 1356 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1358 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1360 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_AttachmentListAsString */

/* 1362 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1364 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1368 */	NdrFcShort( 0x7 ),	/* 7 */
/* 1370 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1372 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1374 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1376 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 1378 */	0x8,		/* 8 */
			0x3,		/* Ext Flags:  new corr desc, clt corr check, */
/* 1380 */	NdrFcShort( 0x1 ),	/* 1 */
/* 1382 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1384 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 1386 */	NdrFcShort( 0x2113 ),	/* Flags:  must size, must free, out, simple ref, srv alloc size=8 */
/* 1388 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1390 */	NdrFcShort( 0x36 ),	/* Type Offset=54 */

	/* Return value */

/* 1392 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1394 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1396 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_BodyAsHTML */

/* 1398 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1400 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1404 */	NdrFcShort( 0x9 ),	/* 9 */
/* 1406 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1408 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1410 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1412 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 1414 */	0x8,		/* 8 */
			0x3,		/* Ext Flags:  new corr desc, clt corr check, */
/* 1416 */	NdrFcShort( 0x1 ),	/* 1 */
/* 1418 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1420 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 1422 */	NdrFcShort( 0x2113 ),	/* Flags:  must size, must free, out, simple ref, srv alloc size=8 */
/* 1424 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1426 */	NdrFcShort( 0x36 ),	/* Type Offset=54 */

	/* Return value */

/* 1428 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1430 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1432 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_BodyAsSimpleText */

/* 1434 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1436 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1440 */	NdrFcShort( 0xa ),	/* 10 */
/* 1442 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1444 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1446 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1448 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 1450 */	0x8,		/* 8 */
			0x3,		/* Ext Flags:  new corr desc, clt corr check, */
/* 1452 */	NdrFcShort( 0x1 ),	/* 1 */
/* 1454 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1456 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 1458 */	NdrFcShort( 0x2113 ),	/* Flags:  must size, must free, out, simple ref, srv alloc size=8 */
/* 1460 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1462 */	NdrFcShort( 0x36 ),	/* Type Offset=54 */

	/* Return value */

/* 1464 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1466 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1468 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_From */

/* 1470 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1472 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1476 */	NdrFcShort( 0xc ),	/* 12 */
/* 1478 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1480 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1482 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1484 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 1486 */	0x8,		/* 8 */
			0x3,		/* Ext Flags:  new corr desc, clt corr check, */
/* 1488 */	NdrFcShort( 0x1 ),	/* 1 */
/* 1490 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1492 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 1494 */	NdrFcShort( 0x2113 ),	/* Flags:  must size, must free, out, simple ref, srv alloc size=8 */
/* 1496 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1498 */	NdrFcShort( 0x36 ),	/* Type Offset=54 */

	/* Return value */

/* 1500 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1502 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1504 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_HeaderInfo */

/* 1506 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1508 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1512 */	NdrFcShort( 0xd ),	/* 13 */
/* 1514 */	NdrFcShort( 0x10 ),	/* x86 Stack size/offset = 16 */
/* 1516 */	NdrFcShort( 0x6 ),	/* 6 */
/* 1518 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1520 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x3,		/* 3 */
/* 1522 */	0x8,		/* 8 */
			0x3,		/* Ext Flags:  new corr desc, clt corr check, */
/* 1524 */	NdrFcShort( 0x1 ),	/* 1 */
/* 1526 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1528 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter HeaderField */

/* 1530 */	NdrFcShort( 0x48 ),	/* Flags:  in, base type, */
/* 1532 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1534 */	0xd,		/* FC_ENUM16 */
			0x0,		/* 0 */

	/* Parameter pVal */

/* 1536 */	NdrFcShort( 0x2113 ),	/* Flags:  must size, must free, out, simple ref, srv alloc size=8 */
/* 1538 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1540 */	NdrFcShort( 0x36 ),	/* Type Offset=54 */

	/* Return value */

/* 1542 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1544 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1546 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_ID */


	/* Procedure get_ID */

/* 1548 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1550 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1554 */	NdrFcShort( 0xe ),	/* 14 */
/* 1556 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1558 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1560 */	NdrFcShort( 0x24 ),	/* 36 */
/* 1562 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 1564 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 1566 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1568 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1570 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */


	/* Parameter pVal */

/* 1572 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 1574 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1576 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */


	/* Return value */

/* 1578 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1580 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1582 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_RawMessage */

/* 1584 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1586 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1590 */	NdrFcShort( 0x10 ),	/* 16 */
/* 1592 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1594 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1596 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1598 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 1600 */	0x8,		/* 8 */
			0x3,		/* Ext Flags:  new corr desc, clt corr check, */
/* 1602 */	NdrFcShort( 0x1 ),	/* 1 */
/* 1604 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1606 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 1608 */	NdrFcShort( 0x2113 ),	/* Flags:  must size, must free, out, simple ref, srv alloc size=8 */
/* 1610 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1612 */	NdrFcShort( 0x36 ),	/* Type Offset=54 */

	/* Return value */

/* 1614 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1616 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1618 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_RefCount */

/* 1620 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1622 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1626 */	NdrFcShort( 0x11 ),	/* 17 */
/* 1628 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1630 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1632 */	NdrFcShort( 0x24 ),	/* 36 */
/* 1634 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 1636 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 1638 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1640 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1642 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 1644 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 1646 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1648 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 1650 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1652 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1654 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Status */

/* 1656 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1658 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1662 */	NdrFcShort( 0x13 ),	/* 19 */
/* 1664 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1666 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1668 */	NdrFcShort( 0x22 ),	/* 34 */
/* 1670 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 1672 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 1674 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1676 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1678 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 1680 */	NdrFcShort( 0x2010 ),	/* Flags:  out, srv alloc size=8 */
/* 1682 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1684 */	NdrFcShort( 0x470 ),	/* Type Offset=1136 */

	/* Return value */

/* 1686 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1688 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1690 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure put_Status */

/* 1692 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1694 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1698 */	NdrFcShort( 0x14 ),	/* 20 */
/* 1700 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1702 */	NdrFcShort( 0x6 ),	/* 6 */
/* 1704 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1706 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 1708 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 1710 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1712 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1714 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter newVal */

/* 1716 */	NdrFcShort( 0x48 ),	/* Flags:  in, base type, */
/* 1718 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1720 */	0xd,		/* FC_ENUM16 */
			0x0,		/* 0 */

	/* Return value */

/* 1722 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1724 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1726 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Subject */

/* 1728 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1730 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1734 */	NdrFcShort( 0x15 ),	/* 21 */
/* 1736 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1738 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1740 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1742 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 1744 */	0x8,		/* 8 */
			0x3,		/* Ext Flags:  new corr desc, clt corr check, */
/* 1746 */	NdrFcShort( 0x1 ),	/* 1 */
/* 1748 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1750 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 1752 */	NdrFcShort( 0x2113 ),	/* Flags:  must size, must free, out, simple ref, srv alloc size=8 */
/* 1754 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1756 */	NdrFcShort( 0x36 ),	/* Type Offset=54 */

	/* Return value */

/* 1758 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1760 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1762 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_To */

/* 1764 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1766 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1770 */	NdrFcShort( 0x16 ),	/* 22 */
/* 1772 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1774 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1776 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1778 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 1780 */	0x8,		/* 8 */
			0x3,		/* Ext Flags:  new corr desc, clt corr check, */
/* 1782 */	NdrFcShort( 0x1 ),	/* 1 */
/* 1784 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1786 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 1788 */	NdrFcShort( 0x2113 ),	/* Flags:  must size, must free, out, simple ref, srv alloc size=8 */
/* 1790 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1792 */	NdrFcShort( 0x36 ),	/* Type Offset=54 */

	/* Return value */

/* 1794 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1796 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1798 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure Move */

/* 1800 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1802 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1806 */	NdrFcShort( 0x17 ),	/* 23 */
/* 1808 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1810 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1812 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1814 */	0x46,		/* Oi2 Flags:  clt must size, has return, has ext, */
			0x2,		/* 2 */
/* 1816 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 1818 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1820 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1822 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter NewParentFolder */

/* 1824 */	NdrFcShort( 0xb ),	/* Flags:  must size, must free, in, */
/* 1826 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1828 */	NdrFcShort( 0x6c ),	/* Type Offset=108 */

	/* Return value */

/* 1830 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1832 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1834 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Item */


	/* Procedure get_Item */

/* 1836 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1838 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1842 */	NdrFcShort( 0x7 ),	/* 7 */
/* 1844 */	NdrFcShort( 0x10 ),	/* x86 Stack size/offset = 16 */
/* 1846 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1848 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1850 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x3,		/* 3 */
/* 1852 */	0x8,		/* 8 */
			0x3,		/* Ext Flags:  new corr desc, clt corr check, */
/* 1854 */	NdrFcShort( 0x1 ),	/* 1 */
/* 1856 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1858 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter Index */


	/* Parameter Index */

/* 1860 */	NdrFcShort( 0x48 ),	/* Flags:  in, base type, */
/* 1862 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1864 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Parameter ppFolder */


	/* Parameter ppFolder */

/* 1866 */	NdrFcShort( 0x4113 ),	/* Flags:  must size, must free, out, simple ref, srv alloc size=16 */
/* 1868 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1870 */	NdrFcShort( 0x47c ),	/* Type Offset=1148 */

	/* Return value */


	/* Return value */

/* 1872 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1874 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1876 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get__NewEnum */


	/* Procedure get__NewEnum */

/* 1878 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1880 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1884 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1886 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1888 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1890 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1892 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 1894 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 1896 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1898 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1900 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter ppEnum */


	/* Parameter ppEnum */

/* 1902 */	NdrFcShort( 0x13 ),	/* Flags:  must size, must free, out, */
/* 1904 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1906 */	NdrFcShort( 0x486 ),	/* Type Offset=1158 */

	/* Return value */


	/* Return value */

/* 1908 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1910 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1912 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Count */


	/* Procedure get_bContainsUnreadMessages */


	/* Procedure get_Count */

/* 1914 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1916 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1920 */	NdrFcShort( 0x9 ),	/* 9 */
/* 1922 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1924 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1926 */	NdrFcShort( 0x24 ),	/* 36 */
/* 1928 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 1930 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 1932 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1934 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1936 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */


	/* Parameter pVal */


	/* Parameter pVal */

/* 1938 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 1940 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1942 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */


	/* Return value */


	/* Return value */

/* 1944 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1946 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1948 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_ItemByID */

/* 1950 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1952 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1956 */	NdrFcShort( 0xa ),	/* 10 */
/* 1958 */	NdrFcShort( 0x10 ),	/* x86 Stack size/offset = 16 */
/* 1960 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1962 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1964 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x3,		/* 3 */
/* 1966 */	0x8,		/* 8 */
			0x3,		/* Ext Flags:  new corr desc, clt corr check, */
/* 1968 */	NdrFcShort( 0x1 ),	/* 1 */
/* 1970 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1972 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter ID */

/* 1974 */	NdrFcShort( 0x48 ),	/* Flags:  in, base type, */
/* 1976 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 1978 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Parameter ppFolder */

/* 1980 */	NdrFcShort( 0x4113 ),	/* Flags:  must size, must free, out, simple ref, srv alloc size=16 */
/* 1982 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 1984 */	NdrFcShort( 0x47c ),	/* Type Offset=1148 */

	/* Return value */

/* 1986 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 1988 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 1990 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_RefCount */

/* 1992 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 1994 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1998 */	NdrFcShort( 0xb ),	/* 11 */
/* 2000 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 2002 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2004 */	NdrFcShort( 0x24 ),	/* 36 */
/* 2006 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 2008 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 2010 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2012 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2014 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 2016 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 2018 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 2020 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 2022 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 2024 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 2026 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure RemoveByID */


	/* Procedure RemoveByID */

/* 2028 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 2030 */	NdrFcLong( 0x0 ),	/* 0 */
/* 2034 */	NdrFcShort( 0xc ),	/* 12 */
/* 2036 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 2038 */	NdrFcShort( 0x8 ),	/* 8 */
/* 2040 */	NdrFcShort( 0x8 ),	/* 8 */
/* 2042 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 2044 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 2046 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2048 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2050 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter ID */


	/* Parameter ID */

/* 2052 */	NdrFcShort( 0x48 ),	/* Flags:  in, base type, */
/* 2054 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 2056 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */


	/* Return value */

/* 2058 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 2060 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 2062 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure UpdateList */

/* 2064 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 2066 */	NdrFcLong( 0x0 ),	/* 0 */
/* 2070 */	NdrFcShort( 0xd ),	/* 13 */
/* 2072 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 2074 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2076 */	NdrFcShort( 0x8 ),	/* 8 */
/* 2078 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x1,		/* 1 */
/* 2080 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 2082 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2084 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2086 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Return value */

/* 2088 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 2090 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 2092 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_bCanContainMessages */

/* 2094 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 2096 */	NdrFcLong( 0x0 ),	/* 0 */
/* 2100 */	NdrFcShort( 0x7 ),	/* 7 */
/* 2102 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 2104 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2106 */	NdrFcShort( 0x24 ),	/* 36 */
/* 2108 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 2110 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 2112 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2114 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2116 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 2118 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 2120 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 2122 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 2124 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 2126 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 2128 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_bCanContainSubFolders */

/* 2130 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 2132 */	NdrFcLong( 0x0 ),	/* 0 */
/* 2136 */	NdrFcShort( 0x8 ),	/* 8 */
/* 2138 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 2140 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2142 */	NdrFcShort( 0x24 ),	/* 36 */
/* 2144 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 2146 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 2148 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2150 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2152 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 2154 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 2156 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 2158 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 2160 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 2162 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 2164 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_RefCount */


	/* Procedure get_bIsImapFolder */

/* 2166 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 2168 */	NdrFcLong( 0x0 ),	/* 0 */
/* 2172 */	NdrFcShort( 0xa ),	/* 10 */
/* 2174 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 2176 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2178 */	NdrFcShort( 0x24 ),	/* 36 */
/* 2180 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 2182 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 2184 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2186 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2188 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */


	/* Parameter pVal */

/* 2190 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 2192 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 2194 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */


	/* Return value */

/* 2196 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 2198 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 2200 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Level */

/* 2202 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 2204 */	NdrFcLong( 0x0 ),	/* 0 */
/* 2208 */	NdrFcShort( 0xb ),	/* 11 */
/* 2210 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 2212 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2214 */	NdrFcShort( 0x22 ),	/* 34 */
/* 2216 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 2218 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 2220 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2222 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2224 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 2226 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 2228 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 2230 */	0x6,		/* FC_SHORT */
			0x0,		/* 0 */

	/* Return value */

/* 2232 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 2234 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 2236 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Folders */

/* 2238 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 2240 */	NdrFcLong( 0x0 ),	/* 0 */
/* 2244 */	NdrFcShort( 0xc ),	/* 12 */
/* 2246 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 2248 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2250 */	NdrFcShort( 0x8 ),	/* 8 */
/* 2252 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 2254 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 2256 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2258 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2260 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 2262 */	NdrFcShort( 0x13 ),	/* Flags:  must size, must free, out, */
/* 2264 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 2266 */	NdrFcShort( 0x4e ),	/* Type Offset=78 */

	/* Return value */

/* 2268 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 2270 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 2272 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_FullName */

/* 2274 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 2276 */	NdrFcLong( 0x0 ),	/* 0 */
/* 2280 */	NdrFcShort( 0xd ),	/* 13 */
/* 2282 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 2284 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2286 */	NdrFcShort( 0x8 ),	/* 8 */
/* 2288 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 2290 */	0x8,		/* 8 */
			0x3,		/* Ext Flags:  new corr desc, clt corr check, */
/* 2292 */	NdrFcShort( 0x1 ),	/* 1 */
/* 2294 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2296 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 2298 */	NdrFcShort( 0x2113 ),	/* Flags:  must size, must free, out, simple ref, srv alloc size=8 */
/* 2300 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 2302 */	NdrFcShort( 0x36 ),	/* Type Offset=54 */

	/* Return value */

/* 2304 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 2306 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 2308 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Messages */

/* 2310 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 2312 */	NdrFcLong( 0x0 ),	/* 0 */
/* 2316 */	NdrFcShort( 0x10 ),	/* 16 */
/* 2318 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 2320 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2322 */	NdrFcShort( 0x8 ),	/* 8 */
/* 2324 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 2326 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 2328 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2330 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2332 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 2334 */	NdrFcShort( 0x13 ),	/* Flags:  must size, must free, out, */
/* 2336 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 2338 */	NdrFcShort( 0x48a ),	/* Type Offset=1162 */

	/* Return value */

/* 2340 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 2342 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 2344 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_Name */

/* 2346 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 2348 */	NdrFcLong( 0x0 ),	/* 0 */
/* 2352 */	NdrFcShort( 0x11 ),	/* 17 */
/* 2354 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 2356 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2358 */	NdrFcShort( 0x8 ),	/* 8 */
/* 2360 */	0x45,		/* Oi2 Flags:  srv must size, has return, has ext, */
			0x2,		/* 2 */
/* 2362 */	0x8,		/* 8 */
			0x3,		/* Ext Flags:  new corr desc, clt corr check, */
/* 2364 */	NdrFcShort( 0x1 ),	/* 1 */
/* 2366 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2368 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 2370 */	NdrFcShort( 0x2113 ),	/* Flags:  must size, must free, out, simple ref, srv alloc size=8 */
/* 2372 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 2374 */	NdrFcShort( 0x36 ),	/* Type Offset=54 */

	/* Return value */

/* 2376 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 2378 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 2380 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure get_RefCount */

/* 2382 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 2384 */	NdrFcLong( 0x0 ),	/* 0 */
/* 2388 */	NdrFcShort( 0x13 ),	/* 19 */
/* 2390 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 2392 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2394 */	NdrFcShort( 0x24 ),	/* 36 */
/* 2396 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 2398 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 2400 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2402 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2404 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter pVal */

/* 2406 */	NdrFcShort( 0x2150 ),	/* Flags:  out, base type, simple ref, srv alloc size=8 */
/* 2408 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 2410 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 2412 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 2414 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 2416 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure Move */

/* 2418 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 2420 */	NdrFcLong( 0x0 ),	/* 0 */
/* 2424 */	NdrFcShort( 0x14 ),	/* 20 */
/* 2426 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 2428 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2430 */	NdrFcShort( 0x8 ),	/* 8 */
/* 2432 */	0x46,		/* Oi2 Flags:  clt must size, has return, has ext, */
			0x2,		/* 2 */
/* 2434 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 2436 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2438 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2440 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter NewParentFolder */

/* 2442 */	NdrFcShort( 0xb ),	/* Flags:  must size, must free, in, */
/* 2444 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 2446 */	NdrFcShort( 0x6c ),	/* Type Offset=108 */

	/* Return value */

/* 2448 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 2450 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 2452 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure Open */

/* 2454 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 2456 */	NdrFcLong( 0x0 ),	/* 0 */
/* 2460 */	NdrFcShort( 0x15 ),	/* 21 */
/* 2462 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 2464 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2466 */	NdrFcShort( 0x8 ),	/* 8 */
/* 2468 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x1,		/* 1 */
/* 2470 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 2472 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2474 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2476 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Return value */

/* 2478 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 2480 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 2482 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure Resynchronize */

/* 2484 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 2486 */	NdrFcLong( 0x0 ),	/* 0 */
/* 2490 */	NdrFcShort( 0x16 ),	/* 22 */
/* 2492 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 2494 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2496 */	NdrFcShort( 0x8 ),	/* 8 */
/* 2498 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x1,		/* 1 */
/* 2500 */	0x8,		/* 8 */
			0x1,		/* Ext Flags:  new corr desc, */
/* 2502 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2504 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2506 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Return value */

/* 2508 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 2510 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 2512 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure Add */

/* 2514 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 2516 */	NdrFcLong( 0x0 ),	/* 0 */
/* 2520 */	NdrFcShort( 0xb ),	/* 11 */
/* 2522 */	NdrFcShort( 0x10 ),	/* x86 Stack size/offset = 16 */
/* 2524 */	NdrFcShort( 0x8 ),	/* 8 */
/* 2526 */	NdrFcShort( 0x8 ),	/* 8 */
/* 2528 */	0x46,		/* Oi2 Flags:  clt must size, has return, has ext, */
			0x3,		/* 3 */
/* 2530 */	0x8,		/* 8 */
			0x5,		/* Ext Flags:  new corr desc, srv corr check, */
/* 2532 */	NdrFcShort( 0x0 ),	/* 0 */
/* 2534 */	NdrFcShort( 0x1 ),	/* 1 */
/* 2536 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter Name */

/* 2538 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 2540 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 2542 */	NdrFcShort( 0x44 ),	/* Type Offset=68 */

	/* Parameter bCanContainMessages */

/* 2544 */	NdrFcShort( 0x48 ),	/* Flags:  in, base type, */
/* 2546 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 2548 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 2550 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 2552 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 2554 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

			0x0
        }
    };

static const EudoraExe_MIDL_TYPE_FORMAT_STRING EudoraExe__MIDL_TypeFormatString =
    {
        0,
        {
			NdrFcShort( 0x0 ),	/* 0 */
/*  2 */	
			0x11, 0x10,	/* FC_RP [pointer_deref] */
/*  4 */	NdrFcShort( 0x2 ),	/* Offset= 2 (6) */
/*  6 */	
			0x2f,		/* FC_IP */
			0x5a,		/* FC_CONSTANT_IID */
/*  8 */	NdrFcLong( 0xeda10001 ),	/* -308215807 */
/* 12 */	NdrFcShort( 0xaaaa ),	/* -21846 */
/* 14 */	NdrFcShort( 0x11d0 ),	/* 4560 */
/* 16 */	0xb3,		/* 179 */
			0xc5,		/* 197 */
/* 18 */	0x0,		/* 0 */
			0x80,		/* 128 */
/* 20 */	0x5f,		/* 95 */
			0x8a,		/* 138 */
/* 22 */	0xa4,		/* 164 */
			0xfb,		/* 251 */
/* 24 */	
			0x11, 0x4,	/* FC_RP [alloced_on_stack] */
/* 26 */	NdrFcShort( 0x1c ),	/* Offset= 28 (54) */
/* 28 */	
			0x13, 0x0,	/* FC_OP */
/* 30 */	NdrFcShort( 0xe ),	/* Offset= 14 (44) */
/* 32 */	
			0x1b,		/* FC_CARRAY */
			0x1,		/* 1 */
/* 34 */	NdrFcShort( 0x2 ),	/* 2 */
/* 36 */	0x9,		/* Corr desc: FC_ULONG */
			0x0,		/*  */
/* 38 */	NdrFcShort( 0xfffc ),	/* -4 */
/* 40 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 42 */	0x6,		/* FC_SHORT */
			0x5b,		/* FC_END */
/* 44 */	
			0x17,		/* FC_CSTRUCT */
			0x3,		/* 3 */
/* 46 */	NdrFcShort( 0x8 ),	/* 8 */
/* 48 */	NdrFcShort( 0xfff0 ),	/* Offset= -16 (32) */
/* 50 */	0x8,		/* FC_LONG */
			0x8,		/* FC_LONG */
/* 52 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 54 */	0xb4,		/* FC_USER_MARSHAL */
			0x83,		/* 131 */
/* 56 */	NdrFcShort( 0x0 ),	/* 0 */
/* 58 */	NdrFcShort( 0x4 ),	/* 4 */
/* 60 */	NdrFcShort( 0x0 ),	/* 0 */
/* 62 */	NdrFcShort( 0xffde ),	/* Offset= -34 (28) */
/* 64 */	
			0x12, 0x0,	/* FC_UP */
/* 66 */	NdrFcShort( 0xffea ),	/* Offset= -22 (44) */
/* 68 */	0xb4,		/* FC_USER_MARSHAL */
			0x83,		/* 131 */
/* 70 */	NdrFcShort( 0x0 ),	/* 0 */
/* 72 */	NdrFcShort( 0x4 ),	/* 4 */
/* 74 */	NdrFcShort( 0x0 ),	/* 0 */
/* 76 */	NdrFcShort( 0xfff4 ),	/* Offset= -12 (64) */
/* 78 */	
			0x11, 0x10,	/* FC_RP [pointer_deref] */
/* 80 */	NdrFcShort( 0x2 ),	/* Offset= 2 (82) */
/* 82 */	
			0x2f,		/* FC_IP */
			0x5a,		/* FC_CONSTANT_IID */
/* 84 */	NdrFcLong( 0xeda10015 ),	/* -308215787 */
/* 88 */	NdrFcShort( 0xaaaa ),	/* -21846 */
/* 90 */	NdrFcShort( 0x11d0 ),	/* 4560 */
/* 92 */	0xb3,		/* 179 */
			0xc5,		/* 197 */
/* 94 */	0x0,		/* 0 */
			0x80,		/* 128 */
/* 96 */	0x5f,		/* 95 */
			0x8a,		/* 138 */
/* 98 */	0xa4,		/* 164 */
			0xfb,		/* 251 */
/* 100 */	
			0x11, 0xc,	/* FC_RP [alloced_on_stack] [simple_pointer] */
/* 102 */	0x8,		/* FC_LONG */
			0x5c,		/* FC_PAD */
/* 104 */	
			0x11, 0x10,	/* FC_RP [pointer_deref] */
/* 106 */	NdrFcShort( 0x2 ),	/* Offset= 2 (108) */
/* 108 */	
			0x2f,		/* FC_IP */
			0x5a,		/* FC_CONSTANT_IID */
/* 110 */	NdrFcLong( 0xeda10014 ),	/* -308215788 */
/* 114 */	NdrFcShort( 0xaaaa ),	/* -21846 */
/* 116 */	NdrFcShort( 0x11d0 ),	/* 4560 */
/* 118 */	0xb3,		/* 179 */
			0xc5,		/* 197 */
/* 120 */	0x0,		/* 0 */
			0x80,		/* 128 */
/* 122 */	0x5f,		/* 95 */
			0x8a,		/* 138 */
/* 124 */	0xa4,		/* 164 */
			0xfb,		/* 251 */
/* 126 */	
			0x11, 0xc,	/* FC_RP [alloced_on_stack] [simple_pointer] */
/* 128 */	0x6,		/* FC_SHORT */
			0x5c,		/* FC_PAD */
/* 130 */	
			0x12, 0x0,	/* FC_UP */
/* 132 */	NdrFcShort( 0x3ce ),	/* Offset= 974 (1106) */
/* 134 */	
			0x2b,		/* FC_NON_ENCAPSULATED_UNION */
			0x9,		/* FC_ULONG */
/* 136 */	0x7,		/* Corr desc: FC_USHORT */
			0x0,		/*  */
/* 138 */	NdrFcShort( 0xfff8 ),	/* -8 */
/* 140 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 142 */	NdrFcShort( 0x2 ),	/* Offset= 2 (144) */
/* 144 */	NdrFcShort( 0x10 ),	/* 16 */
/* 146 */	NdrFcShort( 0x2f ),	/* 47 */
/* 148 */	NdrFcLong( 0x14 ),	/* 20 */
/* 152 */	NdrFcShort( 0x800b ),	/* Simple arm type: FC_HYPER */
/* 154 */	NdrFcLong( 0x3 ),	/* 3 */
/* 158 */	NdrFcShort( 0x8008 ),	/* Simple arm type: FC_LONG */
/* 160 */	NdrFcLong( 0x11 ),	/* 17 */
/* 164 */	NdrFcShort( 0x8001 ),	/* Simple arm type: FC_BYTE */
/* 166 */	NdrFcLong( 0x2 ),	/* 2 */
/* 170 */	NdrFcShort( 0x8006 ),	/* Simple arm type: FC_SHORT */
/* 172 */	NdrFcLong( 0x4 ),	/* 4 */
/* 176 */	NdrFcShort( 0x800a ),	/* Simple arm type: FC_FLOAT */
/* 178 */	NdrFcLong( 0x5 ),	/* 5 */
/* 182 */	NdrFcShort( 0x800c ),	/* Simple arm type: FC_DOUBLE */
/* 184 */	NdrFcLong( 0xb ),	/* 11 */
/* 188 */	NdrFcShort( 0x8006 ),	/* Simple arm type: FC_SHORT */
/* 190 */	NdrFcLong( 0xa ),	/* 10 */
/* 194 */	NdrFcShort( 0x8008 ),	/* Simple arm type: FC_LONG */
/* 196 */	NdrFcLong( 0x6 ),	/* 6 */
/* 200 */	NdrFcShort( 0xe8 ),	/* Offset= 232 (432) */
/* 202 */	NdrFcLong( 0x7 ),	/* 7 */
/* 206 */	NdrFcShort( 0x800c ),	/* Simple arm type: FC_DOUBLE */
/* 208 */	NdrFcLong( 0x8 ),	/* 8 */
/* 212 */	NdrFcShort( 0xff6c ),	/* Offset= -148 (64) */
/* 214 */	NdrFcLong( 0xd ),	/* 13 */
/* 218 */	NdrFcShort( 0xdc ),	/* Offset= 220 (438) */
/* 220 */	NdrFcLong( 0x9 ),	/* 9 */
/* 224 */	NdrFcShort( 0xe8 ),	/* Offset= 232 (456) */
/* 226 */	NdrFcLong( 0x2000 ),	/* 8192 */
/* 230 */	NdrFcShort( 0xf4 ),	/* Offset= 244 (474) */
/* 232 */	NdrFcLong( 0x24 ),	/* 36 */
/* 236 */	NdrFcShort( 0x31c ),	/* Offset= 796 (1032) */
/* 238 */	NdrFcLong( 0x4024 ),	/* 16420 */
/* 242 */	NdrFcShort( 0x316 ),	/* Offset= 790 (1032) */
/* 244 */	NdrFcLong( 0x4011 ),	/* 16401 */
/* 248 */	NdrFcShort( 0x314 ),	/* Offset= 788 (1036) */
/* 250 */	NdrFcLong( 0x4002 ),	/* 16386 */
/* 254 */	NdrFcShort( 0x312 ),	/* Offset= 786 (1040) */
/* 256 */	NdrFcLong( 0x4003 ),	/* 16387 */
/* 260 */	NdrFcShort( 0x310 ),	/* Offset= 784 (1044) */
/* 262 */	NdrFcLong( 0x4014 ),	/* 16404 */
/* 266 */	NdrFcShort( 0x30e ),	/* Offset= 782 (1048) */
/* 268 */	NdrFcLong( 0x4004 ),	/* 16388 */
/* 272 */	NdrFcShort( 0x30c ),	/* Offset= 780 (1052) */
/* 274 */	NdrFcLong( 0x4005 ),	/* 16389 */
/* 278 */	NdrFcShort( 0x30a ),	/* Offset= 778 (1056) */
/* 280 */	NdrFcLong( 0x400b ),	/* 16395 */
/* 284 */	NdrFcShort( 0x2f4 ),	/* Offset= 756 (1040) */
/* 286 */	NdrFcLong( 0x400a ),	/* 16394 */
/* 290 */	NdrFcShort( 0x2f2 ),	/* Offset= 754 (1044) */
/* 292 */	NdrFcLong( 0x4006 ),	/* 16390 */
/* 296 */	NdrFcShort( 0x2fc ),	/* Offset= 764 (1060) */
/* 298 */	NdrFcLong( 0x4007 ),	/* 16391 */
/* 302 */	NdrFcShort( 0x2f2 ),	/* Offset= 754 (1056) */
/* 304 */	NdrFcLong( 0x4008 ),	/* 16392 */
/* 308 */	NdrFcShort( 0x2f4 ),	/* Offset= 756 (1064) */
/* 310 */	NdrFcLong( 0x400d ),	/* 16397 */
/* 314 */	NdrFcShort( 0x2f2 ),	/* Offset= 754 (1068) */
/* 316 */	NdrFcLong( 0x4009 ),	/* 16393 */
/* 320 */	NdrFcShort( 0x2f0 ),	/* Offset= 752 (1072) */
/* 322 */	NdrFcLong( 0x6000 ),	/* 24576 */
/* 326 */	NdrFcShort( 0x2ee ),	/* Offset= 750 (1076) */
/* 328 */	NdrFcLong( 0x400c ),	/* 16396 */
/* 332 */	NdrFcShort( 0x2ec ),	/* Offset= 748 (1080) */
/* 334 */	NdrFcLong( 0x10 ),	/* 16 */
/* 338 */	NdrFcShort( 0x8002 ),	/* Simple arm type: FC_CHAR */
/* 340 */	NdrFcLong( 0x12 ),	/* 18 */
/* 344 */	NdrFcShort( 0x8006 ),	/* Simple arm type: FC_SHORT */
/* 346 */	NdrFcLong( 0x13 ),	/* 19 */
/* 350 */	NdrFcShort( 0x8008 ),	/* Simple arm type: FC_LONG */
/* 352 */	NdrFcLong( 0x15 ),	/* 21 */
/* 356 */	NdrFcShort( 0x800b ),	/* Simple arm type: FC_HYPER */
/* 358 */	NdrFcLong( 0x16 ),	/* 22 */
/* 362 */	NdrFcShort( 0x8008 ),	/* Simple arm type: FC_LONG */
/* 364 */	NdrFcLong( 0x17 ),	/* 23 */
/* 368 */	NdrFcShort( 0x8008 ),	/* Simple arm type: FC_LONG */
/* 370 */	NdrFcLong( 0xe ),	/* 14 */
/* 374 */	NdrFcShort( 0x2ca ),	/* Offset= 714 (1088) */
/* 376 */	NdrFcLong( 0x400e ),	/* 16398 */
/* 380 */	NdrFcShort( 0x2ce ),	/* Offset= 718 (1098) */
/* 382 */	NdrFcLong( 0x4010 ),	/* 16400 */
/* 386 */	NdrFcShort( 0x2cc ),	/* Offset= 716 (1102) */
/* 388 */	NdrFcLong( 0x4012 ),	/* 16402 */
/* 392 */	NdrFcShort( 0x288 ),	/* Offset= 648 (1040) */
/* 394 */	NdrFcLong( 0x4013 ),	/* 16403 */
/* 398 */	NdrFcShort( 0x286 ),	/* Offset= 646 (1044) */
/* 400 */	NdrFcLong( 0x4015 ),	/* 16405 */
/* 404 */	NdrFcShort( 0x284 ),	/* Offset= 644 (1048) */
/* 406 */	NdrFcLong( 0x4016 ),	/* 16406 */
/* 410 */	NdrFcShort( 0x27a ),	/* Offset= 634 (1044) */
/* 412 */	NdrFcLong( 0x4017 ),	/* 16407 */
/* 416 */	NdrFcShort( 0x274 ),	/* Offset= 628 (1044) */
/* 418 */	NdrFcLong( 0x0 ),	/* 0 */
/* 422 */	NdrFcShort( 0x0 ),	/* Offset= 0 (422) */
/* 424 */	NdrFcLong( 0x1 ),	/* 1 */
/* 428 */	NdrFcShort( 0x0 ),	/* Offset= 0 (428) */
/* 430 */	NdrFcShort( 0xffff ),	/* Offset= -1 (429) */
/* 432 */	
			0x15,		/* FC_STRUCT */
			0x7,		/* 7 */
/* 434 */	NdrFcShort( 0x8 ),	/* 8 */
/* 436 */	0xb,		/* FC_HYPER */
			0x5b,		/* FC_END */
/* 438 */	
			0x2f,		/* FC_IP */
			0x5a,		/* FC_CONSTANT_IID */
/* 440 */	NdrFcLong( 0x0 ),	/* 0 */
/* 444 */	NdrFcShort( 0x0 ),	/* 0 */
/* 446 */	NdrFcShort( 0x0 ),	/* 0 */
/* 448 */	0xc0,		/* 192 */
			0x0,		/* 0 */
/* 450 */	0x0,		/* 0 */
			0x0,		/* 0 */
/* 452 */	0x0,		/* 0 */
			0x0,		/* 0 */
/* 454 */	0x0,		/* 0 */
			0x46,		/* 70 */
/* 456 */	
			0x2f,		/* FC_IP */
			0x5a,		/* FC_CONSTANT_IID */
/* 458 */	NdrFcLong( 0x20400 ),	/* 132096 */
/* 462 */	NdrFcShort( 0x0 ),	/* 0 */
/* 464 */	NdrFcShort( 0x0 ),	/* 0 */
/* 466 */	0xc0,		/* 192 */
			0x0,		/* 0 */
/* 468 */	0x0,		/* 0 */
			0x0,		/* 0 */
/* 470 */	0x0,		/* 0 */
			0x0,		/* 0 */
/* 472 */	0x0,		/* 0 */
			0x46,		/* 70 */
/* 474 */	
			0x12, 0x10,	/* FC_UP [pointer_deref] */
/* 476 */	NdrFcShort( 0x2 ),	/* Offset= 2 (478) */
/* 478 */	
			0x12, 0x0,	/* FC_UP */
/* 480 */	NdrFcShort( 0x216 ),	/* Offset= 534 (1014) */
/* 482 */	
			0x2a,		/* FC_ENCAPSULATED_UNION */
			0x49,		/* 73 */
/* 484 */	NdrFcShort( 0x18 ),	/* 24 */
/* 486 */	NdrFcShort( 0xa ),	/* 10 */
/* 488 */	NdrFcLong( 0x8 ),	/* 8 */
/* 492 */	NdrFcShort( 0x5a ),	/* Offset= 90 (582) */
/* 494 */	NdrFcLong( 0xd ),	/* 13 */
/* 498 */	NdrFcShort( 0x7e ),	/* Offset= 126 (624) */
/* 500 */	NdrFcLong( 0x9 ),	/* 9 */
/* 504 */	NdrFcShort( 0x9e ),	/* Offset= 158 (662) */
/* 506 */	NdrFcLong( 0xc ),	/* 12 */
/* 510 */	NdrFcShort( 0xc8 ),	/* Offset= 200 (710) */
/* 512 */	NdrFcLong( 0x24 ),	/* 36 */
/* 516 */	NdrFcShort( 0x124 ),	/* Offset= 292 (808) */
/* 518 */	NdrFcLong( 0x800d ),	/* 32781 */
/* 522 */	NdrFcShort( 0x140 ),	/* Offset= 320 (842) */
/* 524 */	NdrFcLong( 0x10 ),	/* 16 */
/* 528 */	NdrFcShort( 0x15a ),	/* Offset= 346 (874) */
/* 530 */	NdrFcLong( 0x2 ),	/* 2 */
/* 534 */	NdrFcShort( 0x174 ),	/* Offset= 372 (906) */
/* 536 */	NdrFcLong( 0x3 ),	/* 3 */
/* 540 */	NdrFcShort( 0x18e ),	/* Offset= 398 (938) */
/* 542 */	NdrFcLong( 0x14 ),	/* 20 */
/* 546 */	NdrFcShort( 0x1a8 ),	/* Offset= 424 (970) */
/* 548 */	NdrFcShort( 0xffff ),	/* Offset= -1 (547) */
/* 550 */	
			0x1b,		/* FC_CARRAY */
			0x3,		/* 3 */
/* 552 */	NdrFcShort( 0x4 ),	/* 4 */
/* 554 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 556 */	NdrFcShort( 0x0 ),	/* 0 */
/* 558 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 560 */	
			0x4b,		/* FC_PP */
			0x5c,		/* FC_PAD */
/* 562 */	
			0x48,		/* FC_VARIABLE_REPEAT */
			0x49,		/* FC_FIXED_OFFSET */
/* 564 */	NdrFcShort( 0x4 ),	/* 4 */
/* 566 */	NdrFcShort( 0x0 ),	/* 0 */
/* 568 */	NdrFcShort( 0x1 ),	/* 1 */
/* 570 */	NdrFcShort( 0x0 ),	/* 0 */
/* 572 */	NdrFcShort( 0x0 ),	/* 0 */
/* 574 */	0x12, 0x0,	/* FC_UP */
/* 576 */	NdrFcShort( 0xfdec ),	/* Offset= -532 (44) */
/* 578 */	
			0x5b,		/* FC_END */

			0x8,		/* FC_LONG */
/* 580 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 582 */	
			0x16,		/* FC_PSTRUCT */
			0x3,		/* 3 */
/* 584 */	NdrFcShort( 0x8 ),	/* 8 */
/* 586 */	
			0x4b,		/* FC_PP */
			0x5c,		/* FC_PAD */
/* 588 */	
			0x46,		/* FC_NO_REPEAT */
			0x5c,		/* FC_PAD */
/* 590 */	NdrFcShort( 0x4 ),	/* 4 */
/* 592 */	NdrFcShort( 0x4 ),	/* 4 */
/* 594 */	0x11, 0x0,	/* FC_RP */
/* 596 */	NdrFcShort( 0xffd2 ),	/* Offset= -46 (550) */
/* 598 */	
			0x5b,		/* FC_END */

			0x8,		/* FC_LONG */
/* 600 */	0x8,		/* FC_LONG */
			0x5b,		/* FC_END */
/* 602 */	
			0x21,		/* FC_BOGUS_ARRAY */
			0x3,		/* 3 */
/* 604 */	NdrFcShort( 0x0 ),	/* 0 */
/* 606 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 608 */	NdrFcShort( 0x0 ),	/* 0 */
/* 610 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 612 */	NdrFcLong( 0xffffffff ),	/* -1 */
/* 616 */	NdrFcShort( 0x0 ),	/* Corr flags:  */
/* 618 */	0x4c,		/* FC_EMBEDDED_COMPLEX */
			0x0,		/* 0 */
/* 620 */	NdrFcShort( 0xff4a ),	/* Offset= -182 (438) */
/* 622 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 624 */	
			0x1a,		/* FC_BOGUS_STRUCT */
			0x3,		/* 3 */
/* 626 */	NdrFcShort( 0x8 ),	/* 8 */
/* 628 */	NdrFcShort( 0x0 ),	/* 0 */
/* 630 */	NdrFcShort( 0x6 ),	/* Offset= 6 (636) */
/* 632 */	0x8,		/* FC_LONG */
			0x36,		/* FC_POINTER */
/* 634 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 636 */	
			0x11, 0x0,	/* FC_RP */
/* 638 */	NdrFcShort( 0xffdc ),	/* Offset= -36 (602) */
/* 640 */	
			0x21,		/* FC_BOGUS_ARRAY */
			0x3,		/* 3 */
/* 642 */	NdrFcShort( 0x0 ),	/* 0 */
/* 644 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 646 */	NdrFcShort( 0x0 ),	/* 0 */
/* 648 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 650 */	NdrFcLong( 0xffffffff ),	/* -1 */
/* 654 */	NdrFcShort( 0x0 ),	/* Corr flags:  */
/* 656 */	0x4c,		/* FC_EMBEDDED_COMPLEX */
			0x0,		/* 0 */
/* 658 */	NdrFcShort( 0xff36 ),	/* Offset= -202 (456) */
/* 660 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 662 */	
			0x1a,		/* FC_BOGUS_STRUCT */
			0x3,		/* 3 */
/* 664 */	NdrFcShort( 0x8 ),	/* 8 */
/* 666 */	NdrFcShort( 0x0 ),	/* 0 */
/* 668 */	NdrFcShort( 0x6 ),	/* Offset= 6 (674) */
/* 670 */	0x8,		/* FC_LONG */
			0x36,		/* FC_POINTER */
/* 672 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 674 */	
			0x11, 0x0,	/* FC_RP */
/* 676 */	NdrFcShort( 0xffdc ),	/* Offset= -36 (640) */
/* 678 */	
			0x1b,		/* FC_CARRAY */
			0x3,		/* 3 */
/* 680 */	NdrFcShort( 0x4 ),	/* 4 */
/* 682 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 684 */	NdrFcShort( 0x0 ),	/* 0 */
/* 686 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 688 */	
			0x4b,		/* FC_PP */
			0x5c,		/* FC_PAD */
/* 690 */	
			0x48,		/* FC_VARIABLE_REPEAT */
			0x49,		/* FC_FIXED_OFFSET */
/* 692 */	NdrFcShort( 0x4 ),	/* 4 */
/* 694 */	NdrFcShort( 0x0 ),	/* 0 */
/* 696 */	NdrFcShort( 0x1 ),	/* 1 */
/* 698 */	NdrFcShort( 0x0 ),	/* 0 */
/* 700 */	NdrFcShort( 0x0 ),	/* 0 */
/* 702 */	0x12, 0x0,	/* FC_UP */
/* 704 */	NdrFcShort( 0x192 ),	/* Offset= 402 (1106) */
/* 706 */	
			0x5b,		/* FC_END */

			0x8,		/* FC_LONG */
/* 708 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 710 */	
			0x1a,		/* FC_BOGUS_STRUCT */
			0x3,		/* 3 */
/* 712 */	NdrFcShort( 0x8 ),	/* 8 */
/* 714 */	NdrFcShort( 0x0 ),	/* 0 */
/* 716 */	NdrFcShort( 0x6 ),	/* Offset= 6 (722) */
/* 718 */	0x8,		/* FC_LONG */
			0x36,		/* FC_POINTER */
/* 720 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 722 */	
			0x11, 0x0,	/* FC_RP */
/* 724 */	NdrFcShort( 0xffd2 ),	/* Offset= -46 (678) */
/* 726 */	
			0x2f,		/* FC_IP */
			0x5a,		/* FC_CONSTANT_IID */
/* 728 */	NdrFcLong( 0x2f ),	/* 47 */
/* 732 */	NdrFcShort( 0x0 ),	/* 0 */
/* 734 */	NdrFcShort( 0x0 ),	/* 0 */
/* 736 */	0xc0,		/* 192 */
			0x0,		/* 0 */
/* 738 */	0x0,		/* 0 */
			0x0,		/* 0 */
/* 740 */	0x0,		/* 0 */
			0x0,		/* 0 */
/* 742 */	0x0,		/* 0 */
			0x46,		/* 70 */
/* 744 */	
			0x1b,		/* FC_CARRAY */
			0x0,		/* 0 */
/* 746 */	NdrFcShort( 0x1 ),	/* 1 */
/* 748 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 750 */	NdrFcShort( 0x4 ),	/* 4 */
/* 752 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 754 */	0x1,		/* FC_BYTE */
			0x5b,		/* FC_END */
/* 756 */	
			0x1a,		/* FC_BOGUS_STRUCT */
			0x3,		/* 3 */
/* 758 */	NdrFcShort( 0x10 ),	/* 16 */
/* 760 */	NdrFcShort( 0x0 ),	/* 0 */
/* 762 */	NdrFcShort( 0xa ),	/* Offset= 10 (772) */
/* 764 */	0x8,		/* FC_LONG */
			0x8,		/* FC_LONG */
/* 766 */	0x4c,		/* FC_EMBEDDED_COMPLEX */
			0x0,		/* 0 */
/* 768 */	NdrFcShort( 0xffd6 ),	/* Offset= -42 (726) */
/* 770 */	0x36,		/* FC_POINTER */
			0x5b,		/* FC_END */
/* 772 */	
			0x12, 0x0,	/* FC_UP */
/* 774 */	NdrFcShort( 0xffe2 ),	/* Offset= -30 (744) */
/* 776 */	
			0x1b,		/* FC_CARRAY */
			0x3,		/* 3 */
/* 778 */	NdrFcShort( 0x4 ),	/* 4 */
/* 780 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 782 */	NdrFcShort( 0x0 ),	/* 0 */
/* 784 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 786 */	
			0x4b,		/* FC_PP */
			0x5c,		/* FC_PAD */
/* 788 */	
			0x48,		/* FC_VARIABLE_REPEAT */
			0x49,		/* FC_FIXED_OFFSET */
/* 790 */	NdrFcShort( 0x4 ),	/* 4 */
/* 792 */	NdrFcShort( 0x0 ),	/* 0 */
/* 794 */	NdrFcShort( 0x1 ),	/* 1 */
/* 796 */	NdrFcShort( 0x0 ),	/* 0 */
/* 798 */	NdrFcShort( 0x0 ),	/* 0 */
/* 800 */	0x12, 0x0,	/* FC_UP */
/* 802 */	NdrFcShort( 0xffd2 ),	/* Offset= -46 (756) */
/* 804 */	
			0x5b,		/* FC_END */

			0x8,		/* FC_LONG */
/* 806 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 808 */	
			0x1a,		/* FC_BOGUS_STRUCT */
			0x3,		/* 3 */
/* 810 */	NdrFcShort( 0x8 ),	/* 8 */
/* 812 */	NdrFcShort( 0x0 ),	/* 0 */
/* 814 */	NdrFcShort( 0x6 ),	/* Offset= 6 (820) */
/* 816 */	0x8,		/* FC_LONG */
			0x36,		/* FC_POINTER */
/* 818 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 820 */	
			0x11, 0x0,	/* FC_RP */
/* 822 */	NdrFcShort( 0xffd2 ),	/* Offset= -46 (776) */
/* 824 */	
			0x1d,		/* FC_SMFARRAY */
			0x0,		/* 0 */
/* 826 */	NdrFcShort( 0x8 ),	/* 8 */
/* 828 */	0x1,		/* FC_BYTE */
			0x5b,		/* FC_END */
/* 830 */	
			0x15,		/* FC_STRUCT */
			0x3,		/* 3 */
/* 832 */	NdrFcShort( 0x10 ),	/* 16 */
/* 834 */	0x8,		/* FC_LONG */
			0x6,		/* FC_SHORT */
/* 836 */	0x6,		/* FC_SHORT */
			0x4c,		/* FC_EMBEDDED_COMPLEX */
/* 838 */	0x0,		/* 0 */
			NdrFcShort( 0xfff1 ),	/* Offset= -15 (824) */
			0x5b,		/* FC_END */
/* 842 */	
			0x1a,		/* FC_BOGUS_STRUCT */
			0x3,		/* 3 */
/* 844 */	NdrFcShort( 0x18 ),	/* 24 */
/* 846 */	NdrFcShort( 0x0 ),	/* 0 */
/* 848 */	NdrFcShort( 0xa ),	/* Offset= 10 (858) */
/* 850 */	0x8,		/* FC_LONG */
			0x36,		/* FC_POINTER */
/* 852 */	0x4c,		/* FC_EMBEDDED_COMPLEX */
			0x0,		/* 0 */
/* 854 */	NdrFcShort( 0xffe8 ),	/* Offset= -24 (830) */
/* 856 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 858 */	
			0x11, 0x0,	/* FC_RP */
/* 860 */	NdrFcShort( 0xfefe ),	/* Offset= -258 (602) */
/* 862 */	
			0x1b,		/* FC_CARRAY */
			0x0,		/* 0 */
/* 864 */	NdrFcShort( 0x1 ),	/* 1 */
/* 866 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 868 */	NdrFcShort( 0x0 ),	/* 0 */
/* 870 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 872 */	0x1,		/* FC_BYTE */
			0x5b,		/* FC_END */
/* 874 */	
			0x16,		/* FC_PSTRUCT */
			0x3,		/* 3 */
/* 876 */	NdrFcShort( 0x8 ),	/* 8 */
/* 878 */	
			0x4b,		/* FC_PP */
			0x5c,		/* FC_PAD */
/* 880 */	
			0x46,		/* FC_NO_REPEAT */
			0x5c,		/* FC_PAD */
/* 882 */	NdrFcShort( 0x4 ),	/* 4 */
/* 884 */	NdrFcShort( 0x4 ),	/* 4 */
/* 886 */	0x12, 0x0,	/* FC_UP */
/* 888 */	NdrFcShort( 0xffe6 ),	/* Offset= -26 (862) */
/* 890 */	
			0x5b,		/* FC_END */

			0x8,		/* FC_LONG */
/* 892 */	0x8,		/* FC_LONG */
			0x5b,		/* FC_END */
/* 894 */	
			0x1b,		/* FC_CARRAY */
			0x1,		/* 1 */
/* 896 */	NdrFcShort( 0x2 ),	/* 2 */
/* 898 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 900 */	NdrFcShort( 0x0 ),	/* 0 */
/* 902 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 904 */	0x6,		/* FC_SHORT */
			0x5b,		/* FC_END */
/* 906 */	
			0x16,		/* FC_PSTRUCT */
			0x3,		/* 3 */
/* 908 */	NdrFcShort( 0x8 ),	/* 8 */
/* 910 */	
			0x4b,		/* FC_PP */
			0x5c,		/* FC_PAD */
/* 912 */	
			0x46,		/* FC_NO_REPEAT */
			0x5c,		/* FC_PAD */
/* 914 */	NdrFcShort( 0x4 ),	/* 4 */
/* 916 */	NdrFcShort( 0x4 ),	/* 4 */
/* 918 */	0x12, 0x0,	/* FC_UP */
/* 920 */	NdrFcShort( 0xffe6 ),	/* Offset= -26 (894) */
/* 922 */	
			0x5b,		/* FC_END */

			0x8,		/* FC_LONG */
/* 924 */	0x8,		/* FC_LONG */
			0x5b,		/* FC_END */
/* 926 */	
			0x1b,		/* FC_CARRAY */
			0x3,		/* 3 */
/* 928 */	NdrFcShort( 0x4 ),	/* 4 */
/* 930 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 932 */	NdrFcShort( 0x0 ),	/* 0 */
/* 934 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 936 */	0x8,		/* FC_LONG */
			0x5b,		/* FC_END */
/* 938 */	
			0x16,		/* FC_PSTRUCT */
			0x3,		/* 3 */
/* 940 */	NdrFcShort( 0x8 ),	/* 8 */
/* 942 */	
			0x4b,		/* FC_PP */
			0x5c,		/* FC_PAD */
/* 944 */	
			0x46,		/* FC_NO_REPEAT */
			0x5c,		/* FC_PAD */
/* 946 */	NdrFcShort( 0x4 ),	/* 4 */
/* 948 */	NdrFcShort( 0x4 ),	/* 4 */
/* 950 */	0x12, 0x0,	/* FC_UP */
/* 952 */	NdrFcShort( 0xffe6 ),	/* Offset= -26 (926) */
/* 954 */	
			0x5b,		/* FC_END */

			0x8,		/* FC_LONG */
/* 956 */	0x8,		/* FC_LONG */
			0x5b,		/* FC_END */
/* 958 */	
			0x1b,		/* FC_CARRAY */
			0x7,		/* 7 */
/* 960 */	NdrFcShort( 0x8 ),	/* 8 */
/* 962 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 964 */	NdrFcShort( 0x0 ),	/* 0 */
/* 966 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 968 */	0xb,		/* FC_HYPER */
			0x5b,		/* FC_END */
/* 970 */	
			0x16,		/* FC_PSTRUCT */
			0x3,		/* 3 */
/* 972 */	NdrFcShort( 0x8 ),	/* 8 */
/* 974 */	
			0x4b,		/* FC_PP */
			0x5c,		/* FC_PAD */
/* 976 */	
			0x46,		/* FC_NO_REPEAT */
			0x5c,		/* FC_PAD */
/* 978 */	NdrFcShort( 0x4 ),	/* 4 */
/* 980 */	NdrFcShort( 0x4 ),	/* 4 */
/* 982 */	0x12, 0x0,	/* FC_UP */
/* 984 */	NdrFcShort( 0xffe6 ),	/* Offset= -26 (958) */
/* 986 */	
			0x5b,		/* FC_END */

			0x8,		/* FC_LONG */
/* 988 */	0x8,		/* FC_LONG */
			0x5b,		/* FC_END */
/* 990 */	
			0x15,		/* FC_STRUCT */
			0x3,		/* 3 */
/* 992 */	NdrFcShort( 0x8 ),	/* 8 */
/* 994 */	0x8,		/* FC_LONG */
			0x8,		/* FC_LONG */
/* 996 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 998 */	
			0x1b,		/* FC_CARRAY */
			0x3,		/* 3 */
/* 1000 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1002 */	0x7,		/* Corr desc: FC_USHORT */
			0x0,		/*  */
/* 1004 */	NdrFcShort( 0xffd8 ),	/* -40 */
/* 1006 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 1008 */	0x4c,		/* FC_EMBEDDED_COMPLEX */
			0x0,		/* 0 */
/* 1010 */	NdrFcShort( 0xffec ),	/* Offset= -20 (990) */
/* 1012 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 1014 */	
			0x1a,		/* FC_BOGUS_STRUCT */
			0x3,		/* 3 */
/* 1016 */	NdrFcShort( 0x28 ),	/* 40 */
/* 1018 */	NdrFcShort( 0xffec ),	/* Offset= -20 (998) */
/* 1020 */	NdrFcShort( 0x0 ),	/* Offset= 0 (1020) */
/* 1022 */	0x6,		/* FC_SHORT */
			0x6,		/* FC_SHORT */
/* 1024 */	0x8,		/* FC_LONG */
			0x8,		/* FC_LONG */
/* 1026 */	0x4c,		/* FC_EMBEDDED_COMPLEX */
			0x0,		/* 0 */
/* 1028 */	NdrFcShort( 0xfdde ),	/* Offset= -546 (482) */
/* 1030 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 1032 */	
			0x12, 0x0,	/* FC_UP */
/* 1034 */	NdrFcShort( 0xfeea ),	/* Offset= -278 (756) */
/* 1036 */	
			0x12, 0x8,	/* FC_UP [simple_pointer] */
/* 1038 */	0x1,		/* FC_BYTE */
			0x5c,		/* FC_PAD */
/* 1040 */	
			0x12, 0x8,	/* FC_UP [simple_pointer] */
/* 1042 */	0x6,		/* FC_SHORT */
			0x5c,		/* FC_PAD */
/* 1044 */	
			0x12, 0x8,	/* FC_UP [simple_pointer] */
/* 1046 */	0x8,		/* FC_LONG */
			0x5c,		/* FC_PAD */
/* 1048 */	
			0x12, 0x8,	/* FC_UP [simple_pointer] */
/* 1050 */	0xb,		/* FC_HYPER */
			0x5c,		/* FC_PAD */
/* 1052 */	
			0x12, 0x8,	/* FC_UP [simple_pointer] */
/* 1054 */	0xa,		/* FC_FLOAT */
			0x5c,		/* FC_PAD */
/* 1056 */	
			0x12, 0x8,	/* FC_UP [simple_pointer] */
/* 1058 */	0xc,		/* FC_DOUBLE */
			0x5c,		/* FC_PAD */
/* 1060 */	
			0x12, 0x0,	/* FC_UP */
/* 1062 */	NdrFcShort( 0xfd8a ),	/* Offset= -630 (432) */
/* 1064 */	
			0x12, 0x10,	/* FC_UP [pointer_deref] */
/* 1066 */	NdrFcShort( 0xfc16 ),	/* Offset= -1002 (64) */
/* 1068 */	
			0x12, 0x10,	/* FC_UP [pointer_deref] */
/* 1070 */	NdrFcShort( 0xfd88 ),	/* Offset= -632 (438) */
/* 1072 */	
			0x12, 0x10,	/* FC_UP [pointer_deref] */
/* 1074 */	NdrFcShort( 0xfd96 ),	/* Offset= -618 (456) */
/* 1076 */	
			0x12, 0x10,	/* FC_UP [pointer_deref] */
/* 1078 */	NdrFcShort( 0xfda4 ),	/* Offset= -604 (474) */
/* 1080 */	
			0x12, 0x10,	/* FC_UP [pointer_deref] */
/* 1082 */	NdrFcShort( 0x2 ),	/* Offset= 2 (1084) */
/* 1084 */	
			0x12, 0x0,	/* FC_UP */
/* 1086 */	NdrFcShort( 0x14 ),	/* Offset= 20 (1106) */
/* 1088 */	
			0x15,		/* FC_STRUCT */
			0x7,		/* 7 */
/* 1090 */	NdrFcShort( 0x10 ),	/* 16 */
/* 1092 */	0x6,		/* FC_SHORT */
			0x1,		/* FC_BYTE */
/* 1094 */	0x1,		/* FC_BYTE */
			0x8,		/* FC_LONG */
/* 1096 */	0xb,		/* FC_HYPER */
			0x5b,		/* FC_END */
/* 1098 */	
			0x12, 0x0,	/* FC_UP */
/* 1100 */	NdrFcShort( 0xfff4 ),	/* Offset= -12 (1088) */
/* 1102 */	
			0x12, 0x8,	/* FC_UP [simple_pointer] */
/* 1104 */	0x2,		/* FC_CHAR */
			0x5c,		/* FC_PAD */
/* 1106 */	
			0x1a,		/* FC_BOGUS_STRUCT */
			0x7,		/* 7 */
/* 1108 */	NdrFcShort( 0x20 ),	/* 32 */
/* 1110 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1112 */	NdrFcShort( 0x0 ),	/* Offset= 0 (1112) */
/* 1114 */	0x8,		/* FC_LONG */
			0x8,		/* FC_LONG */
/* 1116 */	0x6,		/* FC_SHORT */
			0x6,		/* FC_SHORT */
/* 1118 */	0x6,		/* FC_SHORT */
			0x6,		/* FC_SHORT */
/* 1120 */	0x4c,		/* FC_EMBEDDED_COMPLEX */
			0x0,		/* 0 */
/* 1122 */	NdrFcShort( 0xfc24 ),	/* Offset= -988 (134) */
/* 1124 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 1126 */	0xb4,		/* FC_USER_MARSHAL */
			0x83,		/* 131 */
/* 1128 */	NdrFcShort( 0x1 ),	/* 1 */
/* 1130 */	NdrFcShort( 0x10 ),	/* 16 */
/* 1132 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1134 */	NdrFcShort( 0xfc14 ),	/* Offset= -1004 (130) */
/* 1136 */	
			0x11, 0xc,	/* FC_RP [alloced_on_stack] [simple_pointer] */
/* 1138 */	0xd,		/* FC_ENUM16 */
			0x5c,		/* FC_PAD */
/* 1140 */	
			0x11, 0x4,	/* FC_RP [alloced_on_stack] */
/* 1142 */	NdrFcShort( 0x6 ),	/* Offset= 6 (1148) */
/* 1144 */	
			0x13, 0x0,	/* FC_OP */
/* 1146 */	NdrFcShort( 0xffd8 ),	/* Offset= -40 (1106) */
/* 1148 */	0xb4,		/* FC_USER_MARSHAL */
			0x83,		/* 131 */
/* 1150 */	NdrFcShort( 0x1 ),	/* 1 */
/* 1152 */	NdrFcShort( 0x10 ),	/* 16 */
/* 1154 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1156 */	NdrFcShort( 0xfff4 ),	/* Offset= -12 (1144) */
/* 1158 */	
			0x11, 0x10,	/* FC_RP [pointer_deref] */
/* 1160 */	NdrFcShort( 0xfd2e ),	/* Offset= -722 (438) */
/* 1162 */	
			0x11, 0x10,	/* FC_RP [pointer_deref] */
/* 1164 */	NdrFcShort( 0x2 ),	/* Offset= 2 (1166) */
/* 1166 */	
			0x2f,		/* FC_IP */
			0x5a,		/* FC_CONSTANT_IID */
/* 1168 */	NdrFcLong( 0xeda10005 ),	/* -308215803 */
/* 1172 */	NdrFcShort( 0xaaaa ),	/* -21846 */
/* 1174 */	NdrFcShort( 0x11d0 ),	/* 4560 */
/* 1176 */	0xb3,		/* 179 */
			0xc5,		/* 197 */
/* 1178 */	0x0,		/* 0 */
			0x80,		/* 128 */
/* 1180 */	0x5f,		/* 95 */
			0x8a,		/* 138 */
/* 1182 */	0xa4,		/* 164 */
			0xfb,		/* 251 */

			0x0
        }
    };

XFG_TRAMPOLINES(BSTR)
XFG_TRAMPOLINES(VARIANT)

static const USER_MARSHAL_ROUTINE_QUADRUPLE UserMarshalRoutines[ WIRE_MARSHAL_TABLE_SIZE ] = 
        {
            
            {
            (USER_MARSHAL_SIZING_ROUTINE)XFG_TRAMPOLINE_FPTR(BSTR_UserSize)
            ,(USER_MARSHAL_MARSHALLING_ROUTINE)XFG_TRAMPOLINE_FPTR(BSTR_UserMarshal)
            ,(USER_MARSHAL_UNMARSHALLING_ROUTINE)XFG_TRAMPOLINE_FPTR(BSTR_UserUnmarshal)
            ,(USER_MARSHAL_FREEING_ROUTINE)XFG_TRAMPOLINE_FPTR(BSTR_UserFree)
            
            }
            ,
            {
            (USER_MARSHAL_SIZING_ROUTINE)XFG_TRAMPOLINE_FPTR(VARIANT_UserSize)
            ,(USER_MARSHAL_MARSHALLING_ROUTINE)XFG_TRAMPOLINE_FPTR(VARIANT_UserMarshal)
            ,(USER_MARSHAL_UNMARSHALLING_ROUTINE)XFG_TRAMPOLINE_FPTR(VARIANT_UserUnmarshal)
            ,(USER_MARSHAL_FREEING_ROUTINE)XFG_TRAMPOLINE_FPTR(VARIANT_UserFree)
            
            }
            

        };



/* Standard interface: __MIDL_itf_EudoraExe_0000_0000, ver. 0.0,
   GUID={0x00000000,0x0000,0x0000,{0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}} */


/* Object interface: IUnknown, ver. 0.0,
   GUID={0x00000000,0x0000,0x0000,{0xC0,0x00,0x00,0x00,0x00,0x00,0x00,0x46}} */


/* Object interface: IDispatch, ver. 0.0,
   GUID={0x00020400,0x0000,0x0000,{0xC0,0x00,0x00,0x00,0x00,0x00,0x00,0x46}} */


/* Object interface: IEuApplication, ver. 0.0,
   GUID={0xEDA10001,0xAAAA,0x11d0,{0xB3,0xC5,0x00,0x80,0x5F,0x8A,0xA4,0xFB}} */

#pragma code_seg(".orpc")
static const unsigned short IEuApplication_FormatStringOffsetTable[] =
    {
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    0,
    36,
    72,
    108,
    144,
    180,
    216,
    252,
    288,
    324,
    360,
    396,
    432,
    468,
    504,
    540,
    576,
    612,
    648,
    684,
    720,
    756,
    792,
    828,
    864,
    900,
    936,
    972,
    1008,
    1044,
    1074,
    1110,
    1140,
    1170,
    1218,
    1266,
    1332
    };

static const MIDL_STUBLESS_PROXY_INFO IEuApplication_ProxyInfo =
    {
    &Object_StubDesc,
    EudoraExe__MIDL_ProcFormatString.Format,
    &IEuApplication_FormatStringOffsetTable[-3],
    0,
    0,
    0
    };


static const MIDL_SERVER_INFO IEuApplication_ServerInfo = 
    {
    &Object_StubDesc,
    0,
    EudoraExe__MIDL_ProcFormatString.Format,
    &IEuApplication_FormatStringOffsetTable[-3],
    0,
    0,
    0,
    0};
CINTERFACE_PROXY_VTABLE(44) _IEuApplicationProxyVtbl = 
{
    &IEuApplication_ProxyInfo,
    &IID_IEuApplication,
    IUnknown_QueryInterface_Proxy,
    IUnknown_AddRef_Proxy,
    IUnknown_Release_Proxy ,
    0 /* IDispatch::GetTypeInfoCount */ ,
    0 /* IDispatch::GetTypeInfo */ ,
    0 /* IDispatch::GetIDsOfNames */ ,
    0 /* IDispatch_Invoke_Proxy */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_Application */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_Caption */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::put_Caption */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_Folders */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_FullName */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_Height */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::put_Height */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_InBox */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_Interactive */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_Left */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::put_Left */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_Name */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_Path */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_Parent */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_ProcessID */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_RefCount */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_RootFolder */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_StatusBar */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::put_StatusBar */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_Top */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::put_Top */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_VersionBuild */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_VersionMajor */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_VersionMinor */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_VersionMinor2 */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_Visible */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::put_Visible */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::get_Width */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::put_Width */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::CloseEudora */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::CheckMail */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::CompactFolders */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::EmptyTrash */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::Folder */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::FolderByID */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::QueueMessage */ ,
    (void *) (INT_PTR) -1 /* IEuApplication::SendQueuedMessages */
};


EXTERN_C DECLSPEC_SELECTANY const PRPC_STUB_FUNCTION IEuApplication_table[] =
{
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2
};

CInterfaceStubVtbl _IEuApplicationStubVtbl =
{
    &IID_IEuApplication,
    &IEuApplication_ServerInfo,
    44,
    &IEuApplication_table[-3],
    CStdStubBuffer_DELEGATING_METHODS
};


/* Object interface: IEuMessage, ver. 0.0,
   GUID={0xEDA10004,0xAAAA,0x11d0,{0xB3,0xC5,0x00,0x80,0x5F,0x8A,0xA4,0xFB}} */

#pragma code_seg(".orpc")
static const unsigned short IEuMessage_FormatStringOffsetTable[] =
    {
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    1362,
    36,
    1398,
    1434,
    144,
    1470,
    1506,
    1548,
    288,
    1584,
    1620,
    396,
    1656,
    1692,
    1728,
    1764,
    1800
    };

static const MIDL_STUBLESS_PROXY_INFO IEuMessage_ProxyInfo =
    {
    &Object_StubDesc,
    EudoraExe__MIDL_ProcFormatString.Format,
    &IEuMessage_FormatStringOffsetTable[-3],
    0,
    0,
    0
    };


static const MIDL_SERVER_INFO IEuMessage_ServerInfo = 
    {
    &Object_StubDesc,
    0,
    EudoraExe__MIDL_ProcFormatString.Format,
    &IEuMessage_FormatStringOffsetTable[-3],
    0,
    0,
    0,
    0};
CINTERFACE_PROXY_VTABLE(24) _IEuMessageProxyVtbl = 
{
    &IEuMessage_ProxyInfo,
    &IID_IEuMessage,
    IUnknown_QueryInterface_Proxy,
    IUnknown_AddRef_Proxy,
    IUnknown_Release_Proxy ,
    0 /* IDispatch::GetTypeInfoCount */ ,
    0 /* IDispatch::GetTypeInfo */ ,
    0 /* IDispatch::GetIDsOfNames */ ,
    0 /* IDispatch_Invoke_Proxy */ ,
    (void *) (INT_PTR) -1 /* IEuMessage::get_AttachmentListAsString */ ,
    (void *) (INT_PTR) -1 /* IEuMessage::get_Body */ ,
    (void *) (INT_PTR) -1 /* IEuMessage::get_BodyAsHTML */ ,
    (void *) (INT_PTR) -1 /* IEuMessage::get_BodyAsSimpleText */ ,
    (void *) (INT_PTR) -1 /* IEuMessage::get_Date */ ,
    (void *) (INT_PTR) -1 /* IEuMessage::get_From */ ,
    (void *) (INT_PTR) -1 /* IEuMessage::get_HeaderInfo */ ,
    (void *) (INT_PTR) -1 /* IEuMessage::get_ID */ ,
    (void *) (INT_PTR) -1 /* IEuMessage::get_Index */ ,
    (void *) (INT_PTR) -1 /* IEuMessage::get_RawMessage */ ,
    (void *) (INT_PTR) -1 /* IEuMessage::get_RefCount */ ,
    (void *) (INT_PTR) -1 /* IEuMessage::get_Priority */ ,
    (void *) (INT_PTR) -1 /* IEuMessage::get_Status */ ,
    (void *) (INT_PTR) -1 /* IEuMessage::put_Status */ ,
    (void *) (INT_PTR) -1 /* IEuMessage::get_Subject */ ,
    (void *) (INT_PTR) -1 /* IEuMessage::get_To */ ,
    (void *) (INT_PTR) -1 /* IEuMessage::Move */
};


EXTERN_C DECLSPEC_SELECTANY const PRPC_STUB_FUNCTION IEuMessage_table[] =
{
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2
};

CInterfaceStubVtbl _IEuMessageStubVtbl =
{
    &IID_IEuMessage,
    &IEuMessage_ServerInfo,
    24,
    &IEuMessage_table[-3],
    CStdStubBuffer_DELEGATING_METHODS
};


/* Object interface: IEuMessages, ver. 0.0,
   GUID={0xEDA10005,0xAAAA,0x11d0,{0xB3,0xC5,0x00,0x80,0x5F,0x8A,0xA4,0xFB}} */

#pragma code_seg(".orpc")
static const unsigned short IEuMessages_FormatStringOffsetTable[] =
    {
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    1836,
    1878,
    1914,
    1950,
    1992,
    2028,
    2064
    };

static const MIDL_STUBLESS_PROXY_INFO IEuMessages_ProxyInfo =
    {
    &Object_StubDesc,
    EudoraExe__MIDL_ProcFormatString.Format,
    &IEuMessages_FormatStringOffsetTable[-3],
    0,
    0,
    0
    };


static const MIDL_SERVER_INFO IEuMessages_ServerInfo = 
    {
    &Object_StubDesc,
    0,
    EudoraExe__MIDL_ProcFormatString.Format,
    &IEuMessages_FormatStringOffsetTable[-3],
    0,
    0,
    0,
    0};
CINTERFACE_PROXY_VTABLE(14) _IEuMessagesProxyVtbl = 
{
    &IEuMessages_ProxyInfo,
    &IID_IEuMessages,
    IUnknown_QueryInterface_Proxy,
    IUnknown_AddRef_Proxy,
    IUnknown_Release_Proxy ,
    0 /* IDispatch::GetTypeInfoCount */ ,
    0 /* IDispatch::GetTypeInfo */ ,
    0 /* IDispatch::GetIDsOfNames */ ,
    0 /* IDispatch_Invoke_Proxy */ ,
    (void *) (INT_PTR) -1 /* IEuMessages::get_Item */ ,
    (void *) (INT_PTR) -1 /* IEuMessages::get__NewEnum */ ,
    (void *) (INT_PTR) -1 /* IEuMessages::get_Count */ ,
    (void *) (INT_PTR) -1 /* IEuMessages::get_ItemByID */ ,
    (void *) (INT_PTR) -1 /* IEuMessages::get_RefCount */ ,
    (void *) (INT_PTR) -1 /* IEuMessages::RemoveByID */ ,
    (void *) (INT_PTR) -1 /* IEuMessages::UpdateList */
};


EXTERN_C DECLSPEC_SELECTANY const PRPC_STUB_FUNCTION IEuMessages_table[] =
{
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2
};

CInterfaceStubVtbl _IEuMessagesStubVtbl =
{
    &IID_IEuMessages,
    &IEuMessages_ServerInfo,
    14,
    &IEuMessages_table[-3],
    CStdStubBuffer_DELEGATING_METHODS
};


/* Object interface: IEuFolder, ver. 0.0,
   GUID={0xEDA10014,0xAAAA,0x11d0,{0xB3,0xC5,0x00,0x80,0x5F,0x8A,0xA4,0xFB}} */

#pragma code_seg(".orpc")
static const unsigned short IEuFolder_FormatStringOffsetTable[] =
    {
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    2094,
    2130,
    1914,
    2166,
    2202,
    2238,
    2274,
    1548,
    288,
    2310,
    2346,
    396,
    2382,
    2418,
    2454,
    2484
    };

static const MIDL_STUBLESS_PROXY_INFO IEuFolder_ProxyInfo =
    {
    &Object_StubDesc,
    EudoraExe__MIDL_ProcFormatString.Format,
    &IEuFolder_FormatStringOffsetTable[-3],
    0,
    0,
    0
    };


static const MIDL_SERVER_INFO IEuFolder_ServerInfo = 
    {
    &Object_StubDesc,
    0,
    EudoraExe__MIDL_ProcFormatString.Format,
    &IEuFolder_FormatStringOffsetTable[-3],
    0,
    0,
    0,
    0};
CINTERFACE_PROXY_VTABLE(23) _IEuFolderProxyVtbl = 
{
    &IEuFolder_ProxyInfo,
    &IID_IEuFolder,
    IUnknown_QueryInterface_Proxy,
    IUnknown_AddRef_Proxy,
    IUnknown_Release_Proxy ,
    0 /* IDispatch::GetTypeInfoCount */ ,
    0 /* IDispatch::GetTypeInfo */ ,
    0 /* IDispatch::GetIDsOfNames */ ,
    0 /* IDispatch_Invoke_Proxy */ ,
    (void *) (INT_PTR) -1 /* IEuFolder::get_bCanContainMessages */ ,
    (void *) (INT_PTR) -1 /* IEuFolder::get_bCanContainSubFolders */ ,
    (void *) (INT_PTR) -1 /* IEuFolder::get_bContainsUnreadMessages */ ,
    (void *) (INT_PTR) -1 /* IEuFolder::get_bIsImapFolder */ ,
    (void *) (INT_PTR) -1 /* IEuFolder::get_Level */ ,
    (void *) (INT_PTR) -1 /* IEuFolder::get_Folders */ ,
    (void *) (INT_PTR) -1 /* IEuFolder::get_FullName */ ,
    (void *) (INT_PTR) -1 /* IEuFolder::get_ID */ ,
    (void *) (INT_PTR) -1 /* IEuFolder::get_Index */ ,
    (void *) (INT_PTR) -1 /* IEuFolder::get_Messages */ ,
    (void *) (INT_PTR) -1 /* IEuFolder::get_Name */ ,
    (void *) (INT_PTR) -1 /* IEuFolder::get_Path */ ,
    (void *) (INT_PTR) -1 /* IEuFolder::get_RefCount */ ,
    (void *) (INT_PTR) -1 /* IEuFolder::Move */ ,
    (void *) (INT_PTR) -1 /* IEuFolder::Open */ ,
    (void *) (INT_PTR) -1 /* IEuFolder::Resynchronize */
};


EXTERN_C DECLSPEC_SELECTANY const PRPC_STUB_FUNCTION IEuFolder_table[] =
{
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2
};

CInterfaceStubVtbl _IEuFolderStubVtbl =
{
    &IID_IEuFolder,
    &IEuFolder_ServerInfo,
    23,
    &IEuFolder_table[-3],
    CStdStubBuffer_DELEGATING_METHODS
};


/* Object interface: IEuFolders, ver. 0.0,
   GUID={0xEDA10015,0xAAAA,0x11d0,{0xB3,0xC5,0x00,0x80,0x5F,0x8A,0xA4,0xFB}} */

#pragma code_seg(".orpc")
static const unsigned short IEuFolders_FormatStringOffsetTable[] =
    {
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    1836,
    1878,
    1914,
    2166,
    2514,
    2028
    };

static const MIDL_STUBLESS_PROXY_INFO IEuFolders_ProxyInfo =
    {
    &Object_StubDesc,
    EudoraExe__MIDL_ProcFormatString.Format,
    &IEuFolders_FormatStringOffsetTable[-3],
    0,
    0,
    0
    };


static const MIDL_SERVER_INFO IEuFolders_ServerInfo = 
    {
    &Object_StubDesc,
    0,
    EudoraExe__MIDL_ProcFormatString.Format,
    &IEuFolders_FormatStringOffsetTable[-3],
    0,
    0,
    0,
    0};
CINTERFACE_PROXY_VTABLE(13) _IEuFoldersProxyVtbl = 
{
    &IEuFolders_ProxyInfo,
    &IID_IEuFolders,
    IUnknown_QueryInterface_Proxy,
    IUnknown_AddRef_Proxy,
    IUnknown_Release_Proxy ,
    0 /* IDispatch::GetTypeInfoCount */ ,
    0 /* IDispatch::GetTypeInfo */ ,
    0 /* IDispatch::GetIDsOfNames */ ,
    0 /* IDispatch_Invoke_Proxy */ ,
    (void *) (INT_PTR) -1 /* IEuFolders::get_Item */ ,
    (void *) (INT_PTR) -1 /* IEuFolders::get__NewEnum */ ,
    (void *) (INT_PTR) -1 /* IEuFolders::get_Count */ ,
    (void *) (INT_PTR) -1 /* IEuFolders::get_RefCount */ ,
    (void *) (INT_PTR) -1 /* IEuFolders::Add */ ,
    (void *) (INT_PTR) -1 /* IEuFolders::RemoveByID */
};


EXTERN_C DECLSPEC_SELECTANY const PRPC_STUB_FUNCTION IEuFolders_table[] =
{
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2,
    NdrStubCall2
};

CInterfaceStubVtbl _IEuFoldersStubVtbl =
{
    &IID_IEuFolders,
    &IEuFolders_ServerInfo,
    13,
    &IEuFolders_table[-3],
    CStdStubBuffer_DELEGATING_METHODS
};

#ifdef __cplusplus
namespace {
#endif
static const MIDL_STUB_DESC Object_StubDesc = 
    {
    0,
    NdrOleAllocate,
    NdrOleFree,
    0,
    0,
    0,
    0,
    0,
    EudoraExe__MIDL_TypeFormatString.Format,
    1, /* -error bounds_check flag */
    0x50002, /* Ndr library version */
    0,
    0x8010274, /* MIDL Version 8.1.628 */
    0,
    UserMarshalRoutines,
    0,  /* notify & notify_flag routine table */
    0x1, /* MIDL flag */
    0, /* cs routines */
    0,   /* proxy/server info */
    0
    };
#ifdef __cplusplus
}
#endif

const CInterfaceProxyVtbl * const _EudoraExe_ProxyVtblList[] = 
{
    ( CInterfaceProxyVtbl *) &_IEuApplicationProxyVtbl,
    ( CInterfaceProxyVtbl *) &_IEuMessageProxyVtbl,
    ( CInterfaceProxyVtbl *) &_IEuMessagesProxyVtbl,
    ( CInterfaceProxyVtbl *) &_IEuFolderProxyVtbl,
    ( CInterfaceProxyVtbl *) &_IEuFoldersProxyVtbl,
    0
};

const CInterfaceStubVtbl * const _EudoraExe_StubVtblList[] = 
{
    ( CInterfaceStubVtbl *) &_IEuApplicationStubVtbl,
    ( CInterfaceStubVtbl *) &_IEuMessageStubVtbl,
    ( CInterfaceStubVtbl *) &_IEuMessagesStubVtbl,
    ( CInterfaceStubVtbl *) &_IEuFolderStubVtbl,
    ( CInterfaceStubVtbl *) &_IEuFoldersStubVtbl,
    0
};

PCInterfaceName const _EudoraExe_InterfaceNamesList[] = 
{
    "IEuApplication",
    "IEuMessage",
    "IEuMessages",
    "IEuFolder",
    "IEuFolders",
    0
};

const IID *  const _EudoraExe_BaseIIDList[] = 
{
    &IID_IDispatch,
    &IID_IDispatch,
    &IID_IDispatch,
    &IID_IDispatch,
    &IID_IDispatch,
    0
};


#define _EudoraExe_CHECK_IID(n)	IID_GENERIC_CHECK_IID( _EudoraExe, pIID, n)

int __stdcall _EudoraExe_IID_Lookup( const IID * pIID, int * pIndex )
{
    IID_BS_LOOKUP_SETUP

    IID_BS_LOOKUP_INITIAL_TEST( _EudoraExe, 5, 4 )
    IID_BS_LOOKUP_NEXT_TEST( _EudoraExe, 2 )
    IID_BS_LOOKUP_NEXT_TEST( _EudoraExe, 1 )
    IID_BS_LOOKUP_RETURN_RESULT( _EudoraExe, 5, *pIndex )
    
}

EXTERN_C const ExtendedProxyFileInfo EudoraExe_ProxyFileInfo = 
{
    (PCInterfaceProxyVtblList *) & _EudoraExe_ProxyVtblList,
    (PCInterfaceStubVtblList *) & _EudoraExe_StubVtblList,
    (const PCInterfaceName * ) & _EudoraExe_InterfaceNamesList,
    (const IID ** ) & _EudoraExe_BaseIIDList,
    & _EudoraExe_IID_Lookup, 
    5,
    2,
    0, /* table of [async_uuid] interfaces */
    0, /* Filler1 */
    0, /* Filler2 */
    0  /* Filler3 */
};
#if _MSC_VER >= 1200
#pragma warning(pop)
#endif


#endif /* !defined(_M_IA64) && !defined(_M_AMD64) && !defined(_ARM_) */

