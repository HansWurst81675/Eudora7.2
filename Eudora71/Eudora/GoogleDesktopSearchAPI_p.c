

/* this ALWAYS GENERATED file contains the proxy stub code */


 /* File created by MIDL compiler version 8.01.0628 */
/* at Tue Jan 19 04:14:07 2038
 */
/* Compiler settings for GoogleDesktopSearchAPI.idl:
    Oicf, W1, Zp8, env=Win32 (32b run), target_arch=X86 8.01.0628 
    protocol : dce , ms_ext, c_ext, robust
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
/* @@MIDL_FILE_HEADING(  ) */

#if !defined(_M_IA64) && !defined(_M_AMD64) && !defined(_ARM_)


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


#include "GoogleDesktopSearchAPI.h"

#define TYPE_FORMAT_STRING_SIZE   1221                              
#define PROC_FORMAT_STRING_SIZE   247                               
#define EXPR_FORMAT_STRING_SIZE   1                                 
#define TRANSMIT_AS_TABLE_SIZE    0            
#define WIRE_MARSHAL_TABLE_SIZE   2            

typedef struct _GoogleDesktopSearchAPI_MIDL_TYPE_FORMAT_STRING
    {
    short          Pad;
    unsigned char  Format[ TYPE_FORMAT_STRING_SIZE ];
    } GoogleDesktopSearchAPI_MIDL_TYPE_FORMAT_STRING;

typedef struct _GoogleDesktopSearchAPI_MIDL_PROC_FORMAT_STRING
    {
    short          Pad;
    unsigned char  Format[ PROC_FORMAT_STRING_SIZE ];
    } GoogleDesktopSearchAPI_MIDL_PROC_FORMAT_STRING;

typedef struct _GoogleDesktopSearchAPI_MIDL_EXPR_FORMAT_STRING
    {
    long          Pad;
    unsigned char  Format[ EXPR_FORMAT_STRING_SIZE ];
    } GoogleDesktopSearchAPI_MIDL_EXPR_FORMAT_STRING;


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


extern const GoogleDesktopSearchAPI_MIDL_TYPE_FORMAT_STRING GoogleDesktopSearchAPI__MIDL_TypeFormatString;
extern const GoogleDesktopSearchAPI_MIDL_PROC_FORMAT_STRING GoogleDesktopSearchAPI__MIDL_ProcFormatString;
extern const GoogleDesktopSearchAPI_MIDL_EXPR_FORMAT_STRING GoogleDesktopSearchAPI__MIDL_ExprFormatString;

#ifdef __cplusplus
namespace {
#endif

extern const MIDL_STUB_DESC Object_StubDesc;
#ifdef __cplusplus
}
#endif


extern const MIDL_SERVER_INFO IGoogleDesktopSearchComponentRegistration_ServerInfo;
extern const MIDL_STUBLESS_PROXY_INFO IGoogleDesktopSearchComponentRegistration_ProxyInfo;

#ifdef __cplusplus
namespace {
#endif

extern const MIDL_STUB_DESC Object_StubDesc;
#ifdef __cplusplus
}
#endif


extern const MIDL_SERVER_INFO IGoogleDesktopSearchComponentRegister_ServerInfo;
extern const MIDL_STUBLESS_PROXY_INFO IGoogleDesktopSearchComponentRegister_ProxyInfo;

#ifdef __cplusplus
namespace {
#endif

extern const MIDL_STUB_DESC Object_StubDesc;
#ifdef __cplusplus
}
#endif


extern const MIDL_SERVER_INFO IGoogleDesktopSearchEvent_ServerInfo;
extern const MIDL_STUBLESS_PROXY_INFO IGoogleDesktopSearchEvent_ProxyInfo;

#ifdef __cplusplus
namespace {
#endif

extern const MIDL_STUB_DESC Object_StubDesc;
#ifdef __cplusplus
}
#endif


extern const MIDL_SERVER_INFO IGoogleDesktopSearchEventFactory_ServerInfo;
extern const MIDL_STUBLESS_PROXY_INFO IGoogleDesktopSearchEventFactory_ProxyInfo;


extern const USER_MARSHAL_ROUTINE_QUADRUPLE UserMarshalRoutines[ WIRE_MARSHAL_TABLE_SIZE ];

#if !defined(__RPC_WIN32__)
#error  Invalid build platform for this stub.
#endif
#if !(TARGET_IS_NT60_OR_LATER)
#error You need Windows Vista or later to run this stub because it uses these features:
#error   forced complex structure or array, new range semantics, compiled for Windows Vista.
#error However, your C/C++ compilation flags indicate you intend to run this app on earlier systems.
#error This app will fail with the RPC_X_WRONG_STUB_VERSION error.
#endif


static const GoogleDesktopSearchAPI_MIDL_PROC_FORMAT_STRING GoogleDesktopSearchAPI__MIDL_ProcFormatString =
    {
        0,
        {

	/* Procedure RegisterExtension */

			0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/*  2 */	NdrFcLong( 0x0 ),	/* 0 */
/*  6 */	NdrFcShort( 0x7 ),	/* 7 */
/*  8 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 10 */	NdrFcShort( 0x0 ),	/* 0 */
/* 12 */	NdrFcShort( 0x8 ),	/* 8 */
/* 14 */	0x46,		/* Oi2 Flags:  clt must size, has return, has ext, */
			0x2,		/* 2 */
/* 16 */	0x8,		/* 8 */
			0x45,		/* Ext Flags:  new corr desc, srv corr check, has range on conformance */
/* 18 */	NdrFcShort( 0x0 ),	/* 0 */
/* 20 */	NdrFcShort( 0x1 ),	/* 1 */
/* 22 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter extension_handled */

/* 24 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 26 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 28 */	NdrFcShort( 0x26 ),	/* Type Offset=38 */

	/* Return value */

/* 30 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 32 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 34 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure RegisterComponent */

/* 36 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 38 */	NdrFcLong( 0x0 ),	/* 0 */
/* 42 */	NdrFcShort( 0x7 ),	/* 7 */
/* 44 */	NdrFcShort( 0x20 ),	/* x86 Stack size/offset = 32 */
/* 46 */	NdrFcShort( 0x0 ),	/* 0 */
/* 48 */	NdrFcShort( 0x8 ),	/* 8 */
/* 50 */	0x47,		/* Oi2 Flags:  srv must size, clt must size, has return, has ext, */
			0x4,		/* 4 */
/* 52 */	0x8,		/* 8 */
			0x45,		/* Ext Flags:  new corr desc, srv corr check, has range on conformance */
/* 54 */	NdrFcShort( 0x0 ),	/* 0 */
/* 56 */	NdrFcShort( 0x1 ),	/* 1 */
/* 58 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter component_guid_or_progid */

/* 60 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 62 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 64 */	NdrFcShort( 0x26 ),	/* Type Offset=38 */

	/* Parameter component_description */

/* 66 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 68 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 70 */	NdrFcShort( 0x4a0 ),	/* Type Offset=1184 */

	/* Parameter registration */

/* 72 */	NdrFcShort( 0x13 ),	/* Flags:  must size, must free, out, */
/* 74 */	NdrFcShort( 0x18 ),	/* x86 Stack size/offset = 24 */
/* 76 */	NdrFcShort( 0x4aa ),	/* Type Offset=1194 */

	/* Return value */

/* 78 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 80 */	NdrFcShort( 0x1c ),	/* x86 Stack size/offset = 28 */
/* 82 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure UnregisterComponent */

/* 84 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 86 */	NdrFcLong( 0x0 ),	/* 0 */
/* 90 */	NdrFcShort( 0x8 ),	/* 8 */
/* 92 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 94 */	NdrFcShort( 0x0 ),	/* 0 */
/* 96 */	NdrFcShort( 0x8 ),	/* 8 */
/* 98 */	0x46,		/* Oi2 Flags:  clt must size, has return, has ext, */
			0x2,		/* 2 */
/* 100 */	0x8,		/* 8 */
			0x45,		/* Ext Flags:  new corr desc, srv corr check, has range on conformance */
/* 102 */	NdrFcShort( 0x0 ),	/* 0 */
/* 104 */	NdrFcShort( 0x1 ),	/* 1 */
/* 106 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter component_guid_or_progid */

/* 108 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 110 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 112 */	NdrFcShort( 0x26 ),	/* Type Offset=38 */

	/* Return value */

/* 114 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 116 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 118 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure AddProperty */

/* 120 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 122 */	NdrFcLong( 0x0 ),	/* 0 */
/* 126 */	NdrFcShort( 0x7 ),	/* 7 */
/* 128 */	NdrFcShort( 0x1c ),	/* x86 Stack size/offset = 28 */
/* 130 */	NdrFcShort( 0x0 ),	/* 0 */
/* 132 */	NdrFcShort( 0x8 ),	/* 8 */
/* 134 */	0x46,		/* Oi2 Flags:  clt must size, has return, has ext, */
			0x3,		/* 3 */
/* 136 */	0x8,		/* 8 */
			0x45,		/* Ext Flags:  new corr desc, srv corr check, has range on conformance */
/* 138 */	NdrFcShort( 0x0 ),	/* 0 */
/* 140 */	NdrFcShort( 0x1 ),	/* 1 */
/* 142 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter property_name */

/* 144 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 146 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 148 */	NdrFcShort( 0x26 ),	/* Type Offset=38 */

	/* Parameter property_value */

/* 150 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 152 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 154 */	NdrFcShort( 0x4a0 ),	/* Type Offset=1184 */

	/* Return value */

/* 156 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 158 */	NdrFcShort( 0x18 ),	/* x86 Stack size/offset = 24 */
/* 160 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure Send */

/* 162 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 164 */	NdrFcLong( 0x0 ),	/* 0 */
/* 168 */	NdrFcShort( 0x8 ),	/* 8 */
/* 170 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 172 */	NdrFcShort( 0x8 ),	/* 8 */
/* 174 */	NdrFcShort( 0x8 ),	/* 8 */
/* 176 */	0x44,		/* Oi2 Flags:  has return, has ext, */
			0x2,		/* 2 */
/* 178 */	0x8,		/* 8 */
			0x41,		/* Ext Flags:  new corr desc, has range on conformance */
/* 180 */	NdrFcShort( 0x0 ),	/* 0 */
/* 182 */	NdrFcShort( 0x0 ),	/* 0 */
/* 184 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter event_flags */

/* 186 */	NdrFcShort( 0x48 ),	/* Flags:  in, base type, */
/* 188 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 190 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Return value */

/* 192 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 194 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 196 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

	/* Procedure CreateEvent */

/* 198 */	0x33,		/* FC_AUTO_HANDLE */
			0x6c,		/* Old Flags:  object, Oi2 */
/* 200 */	NdrFcLong( 0x0 ),	/* 0 */
/* 204 */	NdrFcShort( 0x7 ),	/* 7 */
/* 206 */	NdrFcShort( 0x14 ),	/* x86 Stack size/offset = 20 */
/* 208 */	NdrFcShort( 0x0 ),	/* 0 */
/* 210 */	NdrFcShort( 0x8 ),	/* 8 */
/* 212 */	0x47,		/* Oi2 Flags:  srv must size, clt must size, has return, has ext, */
			0x4,		/* 4 */
/* 214 */	0x8,		/* 8 */
			0x45,		/* Ext Flags:  new corr desc, srv corr check, has range on conformance */
/* 216 */	NdrFcShort( 0x0 ),	/* 0 */
/* 218 */	NdrFcShort( 0x1 ),	/* 1 */
/* 220 */	NdrFcShort( 0x0 ),	/* 0 */

	/* Parameter component_guid_or_progid */

/* 222 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 224 */	NdrFcShort( 0x4 ),	/* x86 Stack size/offset = 4 */
/* 226 */	NdrFcShort( 0x26 ),	/* Type Offset=38 */

	/* Parameter schema_name */

/* 228 */	NdrFcShort( 0x8b ),	/* Flags:  must size, must free, in, by val, */
/* 230 */	NdrFcShort( 0x8 ),	/* x86 Stack size/offset = 8 */
/* 232 */	NdrFcShort( 0x26 ),	/* Type Offset=38 */

	/* Parameter event */

/* 234 */	NdrFcShort( 0x13 ),	/* Flags:  must size, must free, out, */
/* 236 */	NdrFcShort( 0xc ),	/* x86 Stack size/offset = 12 */
/* 238 */	NdrFcShort( 0x4c0 ),	/* Type Offset=1216 */

	/* Return value */

/* 240 */	NdrFcShort( 0x70 ),	/* Flags:  out, return, base type, */
/* 242 */	NdrFcShort( 0x10 ),	/* x86 Stack size/offset = 16 */
/* 244 */	0x8,		/* FC_LONG */
			0x0,		/* 0 */

			0x0
        }
    };

static const GoogleDesktopSearchAPI_MIDL_TYPE_FORMAT_STRING GoogleDesktopSearchAPI__MIDL_TypeFormatString =
    {
        0,
        {
			NdrFcShort( 0x0 ),	/* 0 */
/*  2 */	
			0x12, 0x0,	/* FC_UP */
/*  4 */	NdrFcShort( 0x18 ),	/* Offset= 24 (28) */
/*  6 */	
			0x1b,		/* FC_CARRAY */
			0x1,		/* 1 */
/*  8 */	NdrFcShort( 0x2 ),	/* 2 */
/* 10 */	0x9,		/* Corr desc: FC_ULONG */
			0x0,		/*  */
/* 12 */	NdrFcShort( 0xfffc ),	/* -4 */
/* 14 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 16 */	0x0 , 
			0x0,		/* 0 */
/* 18 */	NdrFcLong( 0x0 ),	/* 0 */
/* 22 */	NdrFcLong( 0x0 ),	/* 0 */
/* 26 */	0x6,		/* FC_SHORT */
			0x5b,		/* FC_END */
/* 28 */	
			0x17,		/* FC_CSTRUCT */
			0x3,		/* 3 */
/* 30 */	NdrFcShort( 0x8 ),	/* 8 */
/* 32 */	NdrFcShort( 0xffe6 ),	/* Offset= -26 (6) */
/* 34 */	0x8,		/* FC_LONG */
			0x8,		/* FC_LONG */
/* 36 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 38 */	0xb4,		/* FC_USER_MARSHAL */
			0x83,		/* 131 */
/* 40 */	NdrFcShort( 0x0 ),	/* 0 */
/* 42 */	NdrFcShort( 0x4 ),	/* 4 */
/* 44 */	NdrFcShort( 0x0 ),	/* 0 */
/* 46 */	NdrFcShort( 0xffd4 ),	/* Offset= -44 (2) */
/* 48 */	
			0x12, 0x0,	/* FC_UP */
/* 50 */	NdrFcShort( 0x45a ),	/* Offset= 1114 (1164) */
/* 52 */	
			0x2b,		/* FC_NON_ENCAPSULATED_UNION */
			0x9,		/* FC_ULONG */
/* 54 */	0x7,		/* Corr desc: FC_USHORT */
			0x0,		/*  */
/* 56 */	NdrFcShort( 0xfff8 ),	/* -8 */
/* 58 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 60 */	0x0 , 
			0x0,		/* 0 */
/* 62 */	NdrFcLong( 0x0 ),	/* 0 */
/* 66 */	NdrFcLong( 0x0 ),	/* 0 */
/* 70 */	NdrFcShort( 0x2 ),	/* Offset= 2 (72) */
/* 72 */	NdrFcShort( 0x10 ),	/* 16 */
/* 74 */	NdrFcShort( 0x2f ),	/* 47 */
/* 76 */	NdrFcLong( 0x14 ),	/* 20 */
/* 80 */	NdrFcShort( 0x800b ),	/* Simple arm type: FC_HYPER */
/* 82 */	NdrFcLong( 0x3 ),	/* 3 */
/* 86 */	NdrFcShort( 0x8008 ),	/* Simple arm type: FC_LONG */
/* 88 */	NdrFcLong( 0x11 ),	/* 17 */
/* 92 */	NdrFcShort( 0x8001 ),	/* Simple arm type: FC_BYTE */
/* 94 */	NdrFcLong( 0x2 ),	/* 2 */
/* 98 */	NdrFcShort( 0x8006 ),	/* Simple arm type: FC_SHORT */
/* 100 */	NdrFcLong( 0x4 ),	/* 4 */
/* 104 */	NdrFcShort( 0x800a ),	/* Simple arm type: FC_FLOAT */
/* 106 */	NdrFcLong( 0x5 ),	/* 5 */
/* 110 */	NdrFcShort( 0x800c ),	/* Simple arm type: FC_DOUBLE */
/* 112 */	NdrFcLong( 0xb ),	/* 11 */
/* 116 */	NdrFcShort( 0x8006 ),	/* Simple arm type: FC_SHORT */
/* 118 */	NdrFcLong( 0xa ),	/* 10 */
/* 122 */	NdrFcShort( 0x8008 ),	/* Simple arm type: FC_LONG */
/* 124 */	NdrFcLong( 0x6 ),	/* 6 */
/* 128 */	NdrFcShort( 0xe8 ),	/* Offset= 232 (360) */
/* 130 */	NdrFcLong( 0x7 ),	/* 7 */
/* 134 */	NdrFcShort( 0x800c ),	/* Simple arm type: FC_DOUBLE */
/* 136 */	NdrFcLong( 0x8 ),	/* 8 */
/* 140 */	NdrFcShort( 0xff76 ),	/* Offset= -138 (2) */
/* 142 */	NdrFcLong( 0xd ),	/* 13 */
/* 146 */	NdrFcShort( 0xdc ),	/* Offset= 220 (366) */
/* 148 */	NdrFcLong( 0x9 ),	/* 9 */
/* 152 */	NdrFcShort( 0xe8 ),	/* Offset= 232 (384) */
/* 154 */	NdrFcLong( 0x2000 ),	/* 8192 */
/* 158 */	NdrFcShort( 0xf4 ),	/* Offset= 244 (402) */
/* 160 */	NdrFcLong( 0x24 ),	/* 36 */
/* 164 */	NdrFcShort( 0x39e ),	/* Offset= 926 (1090) */
/* 166 */	NdrFcLong( 0x4024 ),	/* 16420 */
/* 170 */	NdrFcShort( 0x398 ),	/* Offset= 920 (1090) */
/* 172 */	NdrFcLong( 0x4011 ),	/* 16401 */
/* 176 */	NdrFcShort( 0x396 ),	/* Offset= 918 (1094) */
/* 178 */	NdrFcLong( 0x4002 ),	/* 16386 */
/* 182 */	NdrFcShort( 0x394 ),	/* Offset= 916 (1098) */
/* 184 */	NdrFcLong( 0x4003 ),	/* 16387 */
/* 188 */	NdrFcShort( 0x392 ),	/* Offset= 914 (1102) */
/* 190 */	NdrFcLong( 0x4014 ),	/* 16404 */
/* 194 */	NdrFcShort( 0x390 ),	/* Offset= 912 (1106) */
/* 196 */	NdrFcLong( 0x4004 ),	/* 16388 */
/* 200 */	NdrFcShort( 0x38e ),	/* Offset= 910 (1110) */
/* 202 */	NdrFcLong( 0x4005 ),	/* 16389 */
/* 206 */	NdrFcShort( 0x38c ),	/* Offset= 908 (1114) */
/* 208 */	NdrFcLong( 0x400b ),	/* 16395 */
/* 212 */	NdrFcShort( 0x376 ),	/* Offset= 886 (1098) */
/* 214 */	NdrFcLong( 0x400a ),	/* 16394 */
/* 218 */	NdrFcShort( 0x374 ),	/* Offset= 884 (1102) */
/* 220 */	NdrFcLong( 0x4006 ),	/* 16390 */
/* 224 */	NdrFcShort( 0x37e ),	/* Offset= 894 (1118) */
/* 226 */	NdrFcLong( 0x4007 ),	/* 16391 */
/* 230 */	NdrFcShort( 0x374 ),	/* Offset= 884 (1114) */
/* 232 */	NdrFcLong( 0x4008 ),	/* 16392 */
/* 236 */	NdrFcShort( 0x376 ),	/* Offset= 886 (1122) */
/* 238 */	NdrFcLong( 0x400d ),	/* 16397 */
/* 242 */	NdrFcShort( 0x374 ),	/* Offset= 884 (1126) */
/* 244 */	NdrFcLong( 0x4009 ),	/* 16393 */
/* 248 */	NdrFcShort( 0x372 ),	/* Offset= 882 (1130) */
/* 250 */	NdrFcLong( 0x6000 ),	/* 24576 */
/* 254 */	NdrFcShort( 0x370 ),	/* Offset= 880 (1134) */
/* 256 */	NdrFcLong( 0x400c ),	/* 16396 */
/* 260 */	NdrFcShort( 0x36e ),	/* Offset= 878 (1138) */
/* 262 */	NdrFcLong( 0x10 ),	/* 16 */
/* 266 */	NdrFcShort( 0x8002 ),	/* Simple arm type: FC_CHAR */
/* 268 */	NdrFcLong( 0x12 ),	/* 18 */
/* 272 */	NdrFcShort( 0x8006 ),	/* Simple arm type: FC_SHORT */
/* 274 */	NdrFcLong( 0x13 ),	/* 19 */
/* 278 */	NdrFcShort( 0x8008 ),	/* Simple arm type: FC_LONG */
/* 280 */	NdrFcLong( 0x15 ),	/* 21 */
/* 284 */	NdrFcShort( 0x800b ),	/* Simple arm type: FC_HYPER */
/* 286 */	NdrFcLong( 0x16 ),	/* 22 */
/* 290 */	NdrFcShort( 0x8008 ),	/* Simple arm type: FC_LONG */
/* 292 */	NdrFcLong( 0x17 ),	/* 23 */
/* 296 */	NdrFcShort( 0x8008 ),	/* Simple arm type: FC_LONG */
/* 298 */	NdrFcLong( 0xe ),	/* 14 */
/* 302 */	NdrFcShort( 0x34c ),	/* Offset= 844 (1146) */
/* 304 */	NdrFcLong( 0x400e ),	/* 16398 */
/* 308 */	NdrFcShort( 0x350 ),	/* Offset= 848 (1156) */
/* 310 */	NdrFcLong( 0x4010 ),	/* 16400 */
/* 314 */	NdrFcShort( 0x34e ),	/* Offset= 846 (1160) */
/* 316 */	NdrFcLong( 0x4012 ),	/* 16402 */
/* 320 */	NdrFcShort( 0x30a ),	/* Offset= 778 (1098) */
/* 322 */	NdrFcLong( 0x4013 ),	/* 16403 */
/* 326 */	NdrFcShort( 0x308 ),	/* Offset= 776 (1102) */
/* 328 */	NdrFcLong( 0x4015 ),	/* 16405 */
/* 332 */	NdrFcShort( 0x306 ),	/* Offset= 774 (1106) */
/* 334 */	NdrFcLong( 0x4016 ),	/* 16406 */
/* 338 */	NdrFcShort( 0x2fc ),	/* Offset= 764 (1102) */
/* 340 */	NdrFcLong( 0x4017 ),	/* 16407 */
/* 344 */	NdrFcShort( 0x2f6 ),	/* Offset= 758 (1102) */
/* 346 */	NdrFcLong( 0x0 ),	/* 0 */
/* 350 */	NdrFcShort( 0x0 ),	/* Offset= 0 (350) */
/* 352 */	NdrFcLong( 0x1 ),	/* 1 */
/* 356 */	NdrFcShort( 0x0 ),	/* Offset= 0 (356) */
/* 358 */	NdrFcShort( 0xffff ),	/* Offset= -1 (357) */
/* 360 */	
			0x15,		/* FC_STRUCT */
			0x7,		/* 7 */
/* 362 */	NdrFcShort( 0x8 ),	/* 8 */
/* 364 */	0xb,		/* FC_HYPER */
			0x5b,		/* FC_END */
/* 366 */	
			0x2f,		/* FC_IP */
			0x5a,		/* FC_CONSTANT_IID */
/* 368 */	NdrFcLong( 0x0 ),	/* 0 */
/* 372 */	NdrFcShort( 0x0 ),	/* 0 */
/* 374 */	NdrFcShort( 0x0 ),	/* 0 */
/* 376 */	0xc0,		/* 192 */
			0x0,		/* 0 */
/* 378 */	0x0,		/* 0 */
			0x0,		/* 0 */
/* 380 */	0x0,		/* 0 */
			0x0,		/* 0 */
/* 382 */	0x0,		/* 0 */
			0x46,		/* 70 */
/* 384 */	
			0x2f,		/* FC_IP */
			0x5a,		/* FC_CONSTANT_IID */
/* 386 */	NdrFcLong( 0x20400 ),	/* 132096 */
/* 390 */	NdrFcShort( 0x0 ),	/* 0 */
/* 392 */	NdrFcShort( 0x0 ),	/* 0 */
/* 394 */	0xc0,		/* 192 */
			0x0,		/* 0 */
/* 396 */	0x0,		/* 0 */
			0x0,		/* 0 */
/* 398 */	0x0,		/* 0 */
			0x0,		/* 0 */
/* 400 */	0x0,		/* 0 */
			0x46,		/* 70 */
/* 402 */	
			0x12, 0x10,	/* FC_UP [pointer_deref] */
/* 404 */	NdrFcShort( 0x2 ),	/* Offset= 2 (406) */
/* 406 */	
			0x12, 0x0,	/* FC_UP */
/* 408 */	NdrFcShort( 0x298 ),	/* Offset= 664 (1072) */
/* 410 */	
			0x2a,		/* FC_ENCAPSULATED_UNION */
			0x49,		/* 73 */
/* 412 */	NdrFcShort( 0x18 ),	/* 24 */
/* 414 */	NdrFcShort( 0xa ),	/* 10 */
/* 416 */	NdrFcLong( 0x8 ),	/* 8 */
/* 420 */	NdrFcShort( 0x64 ),	/* Offset= 100 (520) */
/* 422 */	NdrFcLong( 0xd ),	/* 13 */
/* 426 */	NdrFcShort( 0x9c ),	/* Offset= 156 (582) */
/* 428 */	NdrFcLong( 0x9 ),	/* 9 */
/* 432 */	NdrFcShort( 0xd0 ),	/* Offset= 208 (640) */
/* 434 */	NdrFcLong( 0xc ),	/* 12 */
/* 438 */	NdrFcShort( 0x104 ),	/* Offset= 260 (698) */
/* 440 */	NdrFcLong( 0x24 ),	/* 36 */
/* 444 */	NdrFcShort( 0x174 ),	/* Offset= 372 (816) */
/* 446 */	NdrFcLong( 0x800d ),	/* 32781 */
/* 450 */	NdrFcShort( 0x190 ),	/* Offset= 400 (850) */
/* 452 */	NdrFcLong( 0x10 ),	/* 16 */
/* 456 */	NdrFcShort( 0x1b4 ),	/* Offset= 436 (892) */
/* 458 */	NdrFcLong( 0x2 ),	/* 2 */
/* 462 */	NdrFcShort( 0x1d8 ),	/* Offset= 472 (934) */
/* 464 */	NdrFcLong( 0x3 ),	/* 3 */
/* 468 */	NdrFcShort( 0x1fc ),	/* Offset= 508 (976) */
/* 470 */	NdrFcLong( 0x14 ),	/* 20 */
/* 474 */	NdrFcShort( 0x220 ),	/* Offset= 544 (1018) */
/* 476 */	NdrFcShort( 0xffff ),	/* Offset= -1 (475) */
/* 478 */	
			0x1b,		/* FC_CARRAY */
			0x3,		/* 3 */
/* 480 */	NdrFcShort( 0x4 ),	/* 4 */
/* 482 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 484 */	NdrFcShort( 0x0 ),	/* 0 */
/* 486 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 488 */	0x0 , 
			0x0,		/* 0 */
/* 490 */	NdrFcLong( 0x0 ),	/* 0 */
/* 494 */	NdrFcLong( 0x0 ),	/* 0 */
/* 498 */	
			0x4b,		/* FC_PP */
			0x5c,		/* FC_PAD */
/* 500 */	
			0x48,		/* FC_VARIABLE_REPEAT */
			0x49,		/* FC_FIXED_OFFSET */
/* 502 */	NdrFcShort( 0x4 ),	/* 4 */
/* 504 */	NdrFcShort( 0x0 ),	/* 0 */
/* 506 */	NdrFcShort( 0x1 ),	/* 1 */
/* 508 */	NdrFcShort( 0x0 ),	/* 0 */
/* 510 */	NdrFcShort( 0x0 ),	/* 0 */
/* 512 */	0x12, 0x0,	/* FC_UP */
/* 514 */	NdrFcShort( 0xfe1a ),	/* Offset= -486 (28) */
/* 516 */	
			0x5b,		/* FC_END */

			0x8,		/* FC_LONG */
/* 518 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 520 */	
			0x16,		/* FC_PSTRUCT */
			0x3,		/* 3 */
/* 522 */	NdrFcShort( 0x8 ),	/* 8 */
/* 524 */	
			0x4b,		/* FC_PP */
			0x5c,		/* FC_PAD */
/* 526 */	
			0x46,		/* FC_NO_REPEAT */
			0x5c,		/* FC_PAD */
/* 528 */	NdrFcShort( 0x4 ),	/* 4 */
/* 530 */	NdrFcShort( 0x4 ),	/* 4 */
/* 532 */	0x11, 0x0,	/* FC_RP */
/* 534 */	NdrFcShort( 0xffc8 ),	/* Offset= -56 (478) */
/* 536 */	
			0x5b,		/* FC_END */

			0x8,		/* FC_LONG */
/* 538 */	0x8,		/* FC_LONG */
			0x5b,		/* FC_END */
/* 540 */	
			0x21,		/* FC_BOGUS_ARRAY */
			0x3,		/* 3 */
/* 542 */	NdrFcShort( 0x0 ),	/* 0 */
/* 544 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 546 */	NdrFcShort( 0x0 ),	/* 0 */
/* 548 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 550 */	0x0 , 
			0x0,		/* 0 */
/* 552 */	NdrFcLong( 0x0 ),	/* 0 */
/* 556 */	NdrFcLong( 0x0 ),	/* 0 */
/* 560 */	NdrFcLong( 0xffffffff ),	/* -1 */
/* 564 */	NdrFcShort( 0x0 ),	/* Corr flags:  */
/* 566 */	0x0 , 
			0x0,		/* 0 */
/* 568 */	NdrFcLong( 0x0 ),	/* 0 */
/* 572 */	NdrFcLong( 0x0 ),	/* 0 */
/* 576 */	0x4c,		/* FC_EMBEDDED_COMPLEX */
			0x0,		/* 0 */
/* 578 */	NdrFcShort( 0xff2c ),	/* Offset= -212 (366) */
/* 580 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 582 */	
			0x1a,		/* FC_BOGUS_STRUCT */
			0x3,		/* 3 */
/* 584 */	NdrFcShort( 0x8 ),	/* 8 */
/* 586 */	NdrFcShort( 0x0 ),	/* 0 */
/* 588 */	NdrFcShort( 0x6 ),	/* Offset= 6 (594) */
/* 590 */	0x8,		/* FC_LONG */
			0x36,		/* FC_POINTER */
/* 592 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 594 */	
			0x11, 0x0,	/* FC_RP */
/* 596 */	NdrFcShort( 0xffc8 ),	/* Offset= -56 (540) */
/* 598 */	
			0x21,		/* FC_BOGUS_ARRAY */
			0x3,		/* 3 */
/* 600 */	NdrFcShort( 0x0 ),	/* 0 */
/* 602 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 604 */	NdrFcShort( 0x0 ),	/* 0 */
/* 606 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 608 */	0x0 , 
			0x0,		/* 0 */
/* 610 */	NdrFcLong( 0x0 ),	/* 0 */
/* 614 */	NdrFcLong( 0x0 ),	/* 0 */
/* 618 */	NdrFcLong( 0xffffffff ),	/* -1 */
/* 622 */	NdrFcShort( 0x0 ),	/* Corr flags:  */
/* 624 */	0x0 , 
			0x0,		/* 0 */
/* 626 */	NdrFcLong( 0x0 ),	/* 0 */
/* 630 */	NdrFcLong( 0x0 ),	/* 0 */
/* 634 */	0x4c,		/* FC_EMBEDDED_COMPLEX */
			0x0,		/* 0 */
/* 636 */	NdrFcShort( 0xff04 ),	/* Offset= -252 (384) */
/* 638 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 640 */	
			0x1a,		/* FC_BOGUS_STRUCT */
			0x3,		/* 3 */
/* 642 */	NdrFcShort( 0x8 ),	/* 8 */
/* 644 */	NdrFcShort( 0x0 ),	/* 0 */
/* 646 */	NdrFcShort( 0x6 ),	/* Offset= 6 (652) */
/* 648 */	0x8,		/* FC_LONG */
			0x36,		/* FC_POINTER */
/* 650 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 652 */	
			0x11, 0x0,	/* FC_RP */
/* 654 */	NdrFcShort( 0xffc8 ),	/* Offset= -56 (598) */
/* 656 */	
			0x1b,		/* FC_CARRAY */
			0x3,		/* 3 */
/* 658 */	NdrFcShort( 0x4 ),	/* 4 */
/* 660 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 662 */	NdrFcShort( 0x0 ),	/* 0 */
/* 664 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 666 */	0x0 , 
			0x0,		/* 0 */
/* 668 */	NdrFcLong( 0x0 ),	/* 0 */
/* 672 */	NdrFcLong( 0x0 ),	/* 0 */
/* 676 */	
			0x4b,		/* FC_PP */
			0x5c,		/* FC_PAD */
/* 678 */	
			0x48,		/* FC_VARIABLE_REPEAT */
			0x49,		/* FC_FIXED_OFFSET */
/* 680 */	NdrFcShort( 0x4 ),	/* 4 */
/* 682 */	NdrFcShort( 0x0 ),	/* 0 */
/* 684 */	NdrFcShort( 0x1 ),	/* 1 */
/* 686 */	NdrFcShort( 0x0 ),	/* 0 */
/* 688 */	NdrFcShort( 0x0 ),	/* 0 */
/* 690 */	0x12, 0x0,	/* FC_UP */
/* 692 */	NdrFcShort( 0x1d8 ),	/* Offset= 472 (1164) */
/* 694 */	
			0x5b,		/* FC_END */

			0x8,		/* FC_LONG */
/* 696 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 698 */	
			0x1a,		/* FC_BOGUS_STRUCT */
			0x3,		/* 3 */
/* 700 */	NdrFcShort( 0x8 ),	/* 8 */
/* 702 */	NdrFcShort( 0x0 ),	/* 0 */
/* 704 */	NdrFcShort( 0x6 ),	/* Offset= 6 (710) */
/* 706 */	0x8,		/* FC_LONG */
			0x36,		/* FC_POINTER */
/* 708 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 710 */	
			0x11, 0x0,	/* FC_RP */
/* 712 */	NdrFcShort( 0xffc8 ),	/* Offset= -56 (656) */
/* 714 */	
			0x2f,		/* FC_IP */
			0x5a,		/* FC_CONSTANT_IID */
/* 716 */	NdrFcLong( 0x2f ),	/* 47 */
/* 720 */	NdrFcShort( 0x0 ),	/* 0 */
/* 722 */	NdrFcShort( 0x0 ),	/* 0 */
/* 724 */	0xc0,		/* 192 */
			0x0,		/* 0 */
/* 726 */	0x0,		/* 0 */
			0x0,		/* 0 */
/* 728 */	0x0,		/* 0 */
			0x0,		/* 0 */
/* 730 */	0x0,		/* 0 */
			0x46,		/* 70 */
/* 732 */	
			0x1b,		/* FC_CARRAY */
			0x0,		/* 0 */
/* 734 */	NdrFcShort( 0x1 ),	/* 1 */
/* 736 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 738 */	NdrFcShort( 0x4 ),	/* 4 */
/* 740 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 742 */	0x0 , 
			0x0,		/* 0 */
/* 744 */	NdrFcLong( 0x0 ),	/* 0 */
/* 748 */	NdrFcLong( 0x0 ),	/* 0 */
/* 752 */	0x1,		/* FC_BYTE */
			0x5b,		/* FC_END */
/* 754 */	
			0x1a,		/* FC_BOGUS_STRUCT */
			0x3,		/* 3 */
/* 756 */	NdrFcShort( 0x10 ),	/* 16 */
/* 758 */	NdrFcShort( 0x0 ),	/* 0 */
/* 760 */	NdrFcShort( 0xa ),	/* Offset= 10 (770) */
/* 762 */	0x8,		/* FC_LONG */
			0x8,		/* FC_LONG */
/* 764 */	0x4c,		/* FC_EMBEDDED_COMPLEX */
			0x0,		/* 0 */
/* 766 */	NdrFcShort( 0xffcc ),	/* Offset= -52 (714) */
/* 768 */	0x36,		/* FC_POINTER */
			0x5b,		/* FC_END */
/* 770 */	
			0x12, 0x20,	/* FC_UP [maybenull_sizeis] */
/* 772 */	NdrFcShort( 0xffd8 ),	/* Offset= -40 (732) */
/* 774 */	
			0x1b,		/* FC_CARRAY */
			0x3,		/* 3 */
/* 776 */	NdrFcShort( 0x4 ),	/* 4 */
/* 778 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 780 */	NdrFcShort( 0x0 ),	/* 0 */
/* 782 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 784 */	0x0 , 
			0x0,		/* 0 */
/* 786 */	NdrFcLong( 0x0 ),	/* 0 */
/* 790 */	NdrFcLong( 0x0 ),	/* 0 */
/* 794 */	
			0x4b,		/* FC_PP */
			0x5c,		/* FC_PAD */
/* 796 */	
			0x48,		/* FC_VARIABLE_REPEAT */
			0x49,		/* FC_FIXED_OFFSET */
/* 798 */	NdrFcShort( 0x4 ),	/* 4 */
/* 800 */	NdrFcShort( 0x0 ),	/* 0 */
/* 802 */	NdrFcShort( 0x1 ),	/* 1 */
/* 804 */	NdrFcShort( 0x0 ),	/* 0 */
/* 806 */	NdrFcShort( 0x0 ),	/* 0 */
/* 808 */	0x12, 0x0,	/* FC_UP */
/* 810 */	NdrFcShort( 0xffc8 ),	/* Offset= -56 (754) */
/* 812 */	
			0x5b,		/* FC_END */

			0x8,		/* FC_LONG */
/* 814 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 816 */	
			0x1a,		/* FC_BOGUS_STRUCT */
			0x3,		/* 3 */
/* 818 */	NdrFcShort( 0x8 ),	/* 8 */
/* 820 */	NdrFcShort( 0x0 ),	/* 0 */
/* 822 */	NdrFcShort( 0x6 ),	/* Offset= 6 (828) */
/* 824 */	0x8,		/* FC_LONG */
			0x36,		/* FC_POINTER */
/* 826 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 828 */	
			0x11, 0x0,	/* FC_RP */
/* 830 */	NdrFcShort( 0xffc8 ),	/* Offset= -56 (774) */
/* 832 */	
			0x1d,		/* FC_SMFARRAY */
			0x0,		/* 0 */
/* 834 */	NdrFcShort( 0x8 ),	/* 8 */
/* 836 */	0x1,		/* FC_BYTE */
			0x5b,		/* FC_END */
/* 838 */	
			0x15,		/* FC_STRUCT */
			0x3,		/* 3 */
/* 840 */	NdrFcShort( 0x10 ),	/* 16 */
/* 842 */	0x8,		/* FC_LONG */
			0x6,		/* FC_SHORT */
/* 844 */	0x6,		/* FC_SHORT */
			0x4c,		/* FC_EMBEDDED_COMPLEX */
/* 846 */	0x0,		/* 0 */
			NdrFcShort( 0xfff1 ),	/* Offset= -15 (832) */
			0x5b,		/* FC_END */
/* 850 */	
			0x1a,		/* FC_BOGUS_STRUCT */
			0x3,		/* 3 */
/* 852 */	NdrFcShort( 0x18 ),	/* 24 */
/* 854 */	NdrFcShort( 0x0 ),	/* 0 */
/* 856 */	NdrFcShort( 0xa ),	/* Offset= 10 (866) */
/* 858 */	0x8,		/* FC_LONG */
			0x36,		/* FC_POINTER */
/* 860 */	0x4c,		/* FC_EMBEDDED_COMPLEX */
			0x0,		/* 0 */
/* 862 */	NdrFcShort( 0xffe8 ),	/* Offset= -24 (838) */
/* 864 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 866 */	
			0x11, 0x0,	/* FC_RP */
/* 868 */	NdrFcShort( 0xfeb8 ),	/* Offset= -328 (540) */
/* 870 */	
			0x1b,		/* FC_CARRAY */
			0x0,		/* 0 */
/* 872 */	NdrFcShort( 0x1 ),	/* 1 */
/* 874 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 876 */	NdrFcShort( 0x0 ),	/* 0 */
/* 878 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 880 */	0x0 , 
			0x0,		/* 0 */
/* 882 */	NdrFcLong( 0x0 ),	/* 0 */
/* 886 */	NdrFcLong( 0x0 ),	/* 0 */
/* 890 */	0x1,		/* FC_BYTE */
			0x5b,		/* FC_END */
/* 892 */	
			0x16,		/* FC_PSTRUCT */
			0x3,		/* 3 */
/* 894 */	NdrFcShort( 0x8 ),	/* 8 */
/* 896 */	
			0x4b,		/* FC_PP */
			0x5c,		/* FC_PAD */
/* 898 */	
			0x46,		/* FC_NO_REPEAT */
			0x5c,		/* FC_PAD */
/* 900 */	NdrFcShort( 0x4 ),	/* 4 */
/* 902 */	NdrFcShort( 0x4 ),	/* 4 */
/* 904 */	0x12, 0x20,	/* FC_UP [maybenull_sizeis] */
/* 906 */	NdrFcShort( 0xffdc ),	/* Offset= -36 (870) */
/* 908 */	
			0x5b,		/* FC_END */

			0x8,		/* FC_LONG */
/* 910 */	0x8,		/* FC_LONG */
			0x5b,		/* FC_END */
/* 912 */	
			0x1b,		/* FC_CARRAY */
			0x1,		/* 1 */
/* 914 */	NdrFcShort( 0x2 ),	/* 2 */
/* 916 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 918 */	NdrFcShort( 0x0 ),	/* 0 */
/* 920 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 922 */	0x0 , 
			0x0,		/* 0 */
/* 924 */	NdrFcLong( 0x0 ),	/* 0 */
/* 928 */	NdrFcLong( 0x0 ),	/* 0 */
/* 932 */	0x6,		/* FC_SHORT */
			0x5b,		/* FC_END */
/* 934 */	
			0x16,		/* FC_PSTRUCT */
			0x3,		/* 3 */
/* 936 */	NdrFcShort( 0x8 ),	/* 8 */
/* 938 */	
			0x4b,		/* FC_PP */
			0x5c,		/* FC_PAD */
/* 940 */	
			0x46,		/* FC_NO_REPEAT */
			0x5c,		/* FC_PAD */
/* 942 */	NdrFcShort( 0x4 ),	/* 4 */
/* 944 */	NdrFcShort( 0x4 ),	/* 4 */
/* 946 */	0x12, 0x20,	/* FC_UP [maybenull_sizeis] */
/* 948 */	NdrFcShort( 0xffdc ),	/* Offset= -36 (912) */
/* 950 */	
			0x5b,		/* FC_END */

			0x8,		/* FC_LONG */
/* 952 */	0x8,		/* FC_LONG */
			0x5b,		/* FC_END */
/* 954 */	
			0x1b,		/* FC_CARRAY */
			0x3,		/* 3 */
/* 956 */	NdrFcShort( 0x4 ),	/* 4 */
/* 958 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 960 */	NdrFcShort( 0x0 ),	/* 0 */
/* 962 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 964 */	0x0 , 
			0x0,		/* 0 */
/* 966 */	NdrFcLong( 0x0 ),	/* 0 */
/* 970 */	NdrFcLong( 0x0 ),	/* 0 */
/* 974 */	0x8,		/* FC_LONG */
			0x5b,		/* FC_END */
/* 976 */	
			0x16,		/* FC_PSTRUCT */
			0x3,		/* 3 */
/* 978 */	NdrFcShort( 0x8 ),	/* 8 */
/* 980 */	
			0x4b,		/* FC_PP */
			0x5c,		/* FC_PAD */
/* 982 */	
			0x46,		/* FC_NO_REPEAT */
			0x5c,		/* FC_PAD */
/* 984 */	NdrFcShort( 0x4 ),	/* 4 */
/* 986 */	NdrFcShort( 0x4 ),	/* 4 */
/* 988 */	0x12, 0x20,	/* FC_UP [maybenull_sizeis] */
/* 990 */	NdrFcShort( 0xffdc ),	/* Offset= -36 (954) */
/* 992 */	
			0x5b,		/* FC_END */

			0x8,		/* FC_LONG */
/* 994 */	0x8,		/* FC_LONG */
			0x5b,		/* FC_END */
/* 996 */	
			0x1b,		/* FC_CARRAY */
			0x7,		/* 7 */
/* 998 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1000 */	0x19,		/* Corr desc:  field pointer, FC_ULONG */
			0x0,		/*  */
/* 1002 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1004 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 1006 */	0x0 , 
			0x0,		/* 0 */
/* 1008 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1012 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1016 */	0xb,		/* FC_HYPER */
			0x5b,		/* FC_END */
/* 1018 */	
			0x16,		/* FC_PSTRUCT */
			0x3,		/* 3 */
/* 1020 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1022 */	
			0x4b,		/* FC_PP */
			0x5c,		/* FC_PAD */
/* 1024 */	
			0x46,		/* FC_NO_REPEAT */
			0x5c,		/* FC_PAD */
/* 1026 */	NdrFcShort( 0x4 ),	/* 4 */
/* 1028 */	NdrFcShort( 0x4 ),	/* 4 */
/* 1030 */	0x12, 0x20,	/* FC_UP [maybenull_sizeis] */
/* 1032 */	NdrFcShort( 0xffdc ),	/* Offset= -36 (996) */
/* 1034 */	
			0x5b,		/* FC_END */

			0x8,		/* FC_LONG */
/* 1036 */	0x8,		/* FC_LONG */
			0x5b,		/* FC_END */
/* 1038 */	
			0x15,		/* FC_STRUCT */
			0x3,		/* 3 */
/* 1040 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1042 */	0x8,		/* FC_LONG */
			0x8,		/* FC_LONG */
/* 1044 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 1046 */	
			0x1b,		/* FC_CARRAY */
			0x3,		/* 3 */
/* 1048 */	NdrFcShort( 0x8 ),	/* 8 */
/* 1050 */	0x7,		/* Corr desc: FC_USHORT */
			0x0,		/*  */
/* 1052 */	NdrFcShort( 0xffd8 ),	/* -40 */
/* 1054 */	NdrFcShort( 0x1 ),	/* Corr flags:  early, */
/* 1056 */	0x0 , 
			0x0,		/* 0 */
/* 1058 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1062 */	NdrFcLong( 0x0 ),	/* 0 */
/* 1066 */	0x4c,		/* FC_EMBEDDED_COMPLEX */
			0x0,		/* 0 */
/* 1068 */	NdrFcShort( 0xffe2 ),	/* Offset= -30 (1038) */
/* 1070 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 1072 */	
			0x1a,		/* FC_BOGUS_STRUCT */
			0x3,		/* 3 */
/* 1074 */	NdrFcShort( 0x28 ),	/* 40 */
/* 1076 */	NdrFcShort( 0xffe2 ),	/* Offset= -30 (1046) */
/* 1078 */	NdrFcShort( 0x0 ),	/* Offset= 0 (1078) */
/* 1080 */	0x6,		/* FC_SHORT */
			0x6,		/* FC_SHORT */
/* 1082 */	0x8,		/* FC_LONG */
			0x8,		/* FC_LONG */
/* 1084 */	0x4c,		/* FC_EMBEDDED_COMPLEX */
			0x0,		/* 0 */
/* 1086 */	NdrFcShort( 0xfd5c ),	/* Offset= -676 (410) */
/* 1088 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 1090 */	
			0x12, 0x0,	/* FC_UP */
/* 1092 */	NdrFcShort( 0xfeae ),	/* Offset= -338 (754) */
/* 1094 */	
			0x12, 0x8,	/* FC_UP [simple_pointer] */
/* 1096 */	0x1,		/* FC_BYTE */
			0x5c,		/* FC_PAD */
/* 1098 */	
			0x12, 0x8,	/* FC_UP [simple_pointer] */
/* 1100 */	0x6,		/* FC_SHORT */
			0x5c,		/* FC_PAD */
/* 1102 */	
			0x12, 0x8,	/* FC_UP [simple_pointer] */
/* 1104 */	0x8,		/* FC_LONG */
			0x5c,		/* FC_PAD */
/* 1106 */	
			0x12, 0x8,	/* FC_UP [simple_pointer] */
/* 1108 */	0xb,		/* FC_HYPER */
			0x5c,		/* FC_PAD */
/* 1110 */	
			0x12, 0x8,	/* FC_UP [simple_pointer] */
/* 1112 */	0xa,		/* FC_FLOAT */
			0x5c,		/* FC_PAD */
/* 1114 */	
			0x12, 0x8,	/* FC_UP [simple_pointer] */
/* 1116 */	0xc,		/* FC_DOUBLE */
			0x5c,		/* FC_PAD */
/* 1118 */	
			0x12, 0x0,	/* FC_UP */
/* 1120 */	NdrFcShort( 0xfd08 ),	/* Offset= -760 (360) */
/* 1122 */	
			0x12, 0x10,	/* FC_UP [pointer_deref] */
/* 1124 */	NdrFcShort( 0xfb9e ),	/* Offset= -1122 (2) */
/* 1126 */	
			0x12, 0x10,	/* FC_UP [pointer_deref] */
/* 1128 */	NdrFcShort( 0xfd06 ),	/* Offset= -762 (366) */
/* 1130 */	
			0x12, 0x10,	/* FC_UP [pointer_deref] */
/* 1132 */	NdrFcShort( 0xfd14 ),	/* Offset= -748 (384) */
/* 1134 */	
			0x12, 0x10,	/* FC_UP [pointer_deref] */
/* 1136 */	NdrFcShort( 0xfd22 ),	/* Offset= -734 (402) */
/* 1138 */	
			0x12, 0x10,	/* FC_UP [pointer_deref] */
/* 1140 */	NdrFcShort( 0x2 ),	/* Offset= 2 (1142) */
/* 1142 */	
			0x12, 0x0,	/* FC_UP */
/* 1144 */	NdrFcShort( 0x14 ),	/* Offset= 20 (1164) */
/* 1146 */	
			0x15,		/* FC_STRUCT */
			0x7,		/* 7 */
/* 1148 */	NdrFcShort( 0x10 ),	/* 16 */
/* 1150 */	0x6,		/* FC_SHORT */
			0x1,		/* FC_BYTE */
/* 1152 */	0x1,		/* FC_BYTE */
			0x8,		/* FC_LONG */
/* 1154 */	0xb,		/* FC_HYPER */
			0x5b,		/* FC_END */
/* 1156 */	
			0x12, 0x0,	/* FC_UP */
/* 1158 */	NdrFcShort( 0xfff4 ),	/* Offset= -12 (1146) */
/* 1160 */	
			0x12, 0x8,	/* FC_UP [simple_pointer] */
/* 1162 */	0x2,		/* FC_CHAR */
			0x5c,		/* FC_PAD */
/* 1164 */	
			0x1a,		/* FC_BOGUS_STRUCT */
			0x7,		/* 7 */
/* 1166 */	NdrFcShort( 0x20 ),	/* 32 */
/* 1168 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1170 */	NdrFcShort( 0x0 ),	/* Offset= 0 (1170) */
/* 1172 */	0x8,		/* FC_LONG */
			0x8,		/* FC_LONG */
/* 1174 */	0x6,		/* FC_SHORT */
			0x6,		/* FC_SHORT */
/* 1176 */	0x6,		/* FC_SHORT */
			0x6,		/* FC_SHORT */
/* 1178 */	0x4c,		/* FC_EMBEDDED_COMPLEX */
			0x0,		/* 0 */
/* 1180 */	NdrFcShort( 0xfb98 ),	/* Offset= -1128 (52) */
/* 1182 */	0x5c,		/* FC_PAD */
			0x5b,		/* FC_END */
/* 1184 */	0xb4,		/* FC_USER_MARSHAL */
			0x83,		/* 131 */
/* 1186 */	NdrFcShort( 0x1 ),	/* 1 */
/* 1188 */	NdrFcShort( 0x10 ),	/* 16 */
/* 1190 */	NdrFcShort( 0x0 ),	/* 0 */
/* 1192 */	NdrFcShort( 0xfb88 ),	/* Offset= -1144 (48) */
/* 1194 */	
			0x11, 0x10,	/* FC_RP [pointer_deref] */
/* 1196 */	NdrFcShort( 0x2 ),	/* Offset= 2 (1198) */
/* 1198 */	
			0x2f,		/* FC_IP */
			0x5a,		/* FC_CONSTANT_IID */
/* 1200 */	NdrFcLong( 0x151857b2 ),	/* 353916850 */
/* 1204 */	NdrFcShort( 0x26e0 ),	/* 9952 */
/* 1206 */	NdrFcShort( 0x4f4d ),	/* 20301 */
/* 1208 */	0xac,		/* 172 */
			0xed,		/* 237 */
/* 1210 */	0x4f,		/* 79 */
			0x7e,		/* 126 */
/* 1212 */	0x4b,		/* 75 */
			0x20,		/* 32 */
/* 1214 */	0x65,		/* 101 */
			0xef,		/* 239 */
/* 1216 */	
			0x11, 0x10,	/* FC_RP [pointer_deref] */
/* 1218 */	NdrFcShort( 0xfcbe ),	/* Offset= -834 (384) */

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



/* Standard interface: __MIDL_itf_GoogleDesktopSearchAPI_0000_0000, ver. 0.0,
   GUID={0x00000000,0x0000,0x0000,{0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}} */


/* Object interface: IUnknown, ver. 0.0,
   GUID={0x00000000,0x0000,0x0000,{0xC0,0x00,0x00,0x00,0x00,0x00,0x00,0x46}} */


/* Object interface: IDispatch, ver. 0.0,
   GUID={0x00020400,0x0000,0x0000,{0xC0,0x00,0x00,0x00,0x00,0x00,0x00,0x46}} */


/* Object interface: IGoogleDesktopSearchComponentRegistration, ver. 0.0,
   GUID={0x151857B2,0x26E0,0x4f4d,{0xAC,0xED,0x4F,0x7E,0x4B,0x20,0x65,0xEF}} */

#pragma code_seg(".orpc")
static const unsigned short IGoogleDesktopSearchComponentRegistration_FormatStringOffsetTable[] =
    {
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    0
    };

static const MIDL_STUBLESS_PROXY_INFO IGoogleDesktopSearchComponentRegistration_ProxyInfo =
    {
    &Object_StubDesc,
    GoogleDesktopSearchAPI__MIDL_ProcFormatString.Format,
    &IGoogleDesktopSearchComponentRegistration_FormatStringOffsetTable[-3],
    0,
    0,
    0
    };


static const MIDL_SERVER_INFO IGoogleDesktopSearchComponentRegistration_ServerInfo = 
    {
    &Object_StubDesc,
    0,
    GoogleDesktopSearchAPI__MIDL_ProcFormatString.Format,
    &IGoogleDesktopSearchComponentRegistration_FormatStringOffsetTable[-3],
    0,
    0,
    0,
    0};
CINTERFACE_PROXY_VTABLE(8) _IGoogleDesktopSearchComponentRegistrationProxyVtbl = 
{
    &IGoogleDesktopSearchComponentRegistration_ProxyInfo,
    &IID_IGoogleDesktopSearchComponentRegistration,
    IUnknown_QueryInterface_Proxy,
    IUnknown_AddRef_Proxy,
    IUnknown_Release_Proxy ,
    0 /* IDispatch::GetTypeInfoCount */ ,
    0 /* IDispatch::GetTypeInfo */ ,
    0 /* IDispatch::GetIDsOfNames */ ,
    0 /* IDispatch_Invoke_Proxy */ ,
    (void *) (INT_PTR) -1 /* IGoogleDesktopSearchComponentRegistration::RegisterExtension */
};


EXTERN_C DECLSPEC_SELECTANY const PRPC_STUB_FUNCTION IGoogleDesktopSearchComponentRegistration_table[] =
{
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    NdrStubCall2
};

CInterfaceStubVtbl _IGoogleDesktopSearchComponentRegistrationStubVtbl =
{
    &IID_IGoogleDesktopSearchComponentRegistration,
    &IGoogleDesktopSearchComponentRegistration_ServerInfo,
    8,
    &IGoogleDesktopSearchComponentRegistration_table[-3],
    CStdStubBuffer_DELEGATING_METHODS
};


/* Object interface: IGoogleDesktopSearchComponentRegister, ver. 0.0,
   GUID={0x9B311E80,0xBC95,0x4518,{0xA5,0x8C,0x44,0x6E,0xC9,0xA0,0x82,0xB5}} */

#pragma code_seg(".orpc")
static const unsigned short IGoogleDesktopSearchComponentRegister_FormatStringOffsetTable[] =
    {
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    36,
    84
    };

static const MIDL_STUBLESS_PROXY_INFO IGoogleDesktopSearchComponentRegister_ProxyInfo =
    {
    &Object_StubDesc,
    GoogleDesktopSearchAPI__MIDL_ProcFormatString.Format,
    &IGoogleDesktopSearchComponentRegister_FormatStringOffsetTable[-3],
    0,
    0,
    0
    };


static const MIDL_SERVER_INFO IGoogleDesktopSearchComponentRegister_ServerInfo = 
    {
    &Object_StubDesc,
    0,
    GoogleDesktopSearchAPI__MIDL_ProcFormatString.Format,
    &IGoogleDesktopSearchComponentRegister_FormatStringOffsetTable[-3],
    0,
    0,
    0,
    0};
CINTERFACE_PROXY_VTABLE(9) _IGoogleDesktopSearchComponentRegisterProxyVtbl = 
{
    &IGoogleDesktopSearchComponentRegister_ProxyInfo,
    &IID_IGoogleDesktopSearchComponentRegister,
    IUnknown_QueryInterface_Proxy,
    IUnknown_AddRef_Proxy,
    IUnknown_Release_Proxy ,
    0 /* IDispatch::GetTypeInfoCount */ ,
    0 /* IDispatch::GetTypeInfo */ ,
    0 /* IDispatch::GetIDsOfNames */ ,
    0 /* IDispatch_Invoke_Proxy */ ,
    (void *) (INT_PTR) -1 /* IGoogleDesktopSearchComponentRegister::RegisterComponent */ ,
    (void *) (INT_PTR) -1 /* IGoogleDesktopSearchComponentRegister::UnregisterComponent */
};


EXTERN_C DECLSPEC_SELECTANY const PRPC_STUB_FUNCTION IGoogleDesktopSearchComponentRegister_table[] =
{
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    NdrStubCall2,
    NdrStubCall2
};

CInterfaceStubVtbl _IGoogleDesktopSearchComponentRegisterStubVtbl =
{
    &IID_IGoogleDesktopSearchComponentRegister,
    &IGoogleDesktopSearchComponentRegister_ServerInfo,
    9,
    &IGoogleDesktopSearchComponentRegister_table[-3],
    CStdStubBuffer_DELEGATING_METHODS
};


/* Object interface: IGoogleDesktopSearchEvent, ver. 0.0,
   GUID={0xBDAC0047,0x4759,0x43a1,{0xBA,0x04,0xB1,0x48,0xE1,0x67,0x9E,0x87}} */

#pragma code_seg(".orpc")
static const unsigned short IGoogleDesktopSearchEvent_FormatStringOffsetTable[] =
    {
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    120,
    162
    };

static const MIDL_STUBLESS_PROXY_INFO IGoogleDesktopSearchEvent_ProxyInfo =
    {
    &Object_StubDesc,
    GoogleDesktopSearchAPI__MIDL_ProcFormatString.Format,
    &IGoogleDesktopSearchEvent_FormatStringOffsetTable[-3],
    0,
    0,
    0
    };


static const MIDL_SERVER_INFO IGoogleDesktopSearchEvent_ServerInfo = 
    {
    &Object_StubDesc,
    0,
    GoogleDesktopSearchAPI__MIDL_ProcFormatString.Format,
    &IGoogleDesktopSearchEvent_FormatStringOffsetTable[-3],
    0,
    0,
    0,
    0};
CINTERFACE_PROXY_VTABLE(9) _IGoogleDesktopSearchEventProxyVtbl = 
{
    &IGoogleDesktopSearchEvent_ProxyInfo,
    &IID_IGoogleDesktopSearchEvent,
    IUnknown_QueryInterface_Proxy,
    IUnknown_AddRef_Proxy,
    IUnknown_Release_Proxy ,
    0 /* IDispatch::GetTypeInfoCount */ ,
    0 /* IDispatch::GetTypeInfo */ ,
    0 /* IDispatch::GetIDsOfNames */ ,
    0 /* IDispatch_Invoke_Proxy */ ,
    (void *) (INT_PTR) -1 /* IGoogleDesktopSearchEvent::AddProperty */ ,
    (void *) (INT_PTR) -1 /* IGoogleDesktopSearchEvent::Send */
};


EXTERN_C DECLSPEC_SELECTANY const PRPC_STUB_FUNCTION IGoogleDesktopSearchEvent_table[] =
{
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    NdrStubCall2,
    NdrStubCall2
};

CInterfaceStubVtbl _IGoogleDesktopSearchEventStubVtbl =
{
    &IID_IGoogleDesktopSearchEvent,
    &IGoogleDesktopSearchEvent_ServerInfo,
    9,
    &IGoogleDesktopSearchEvent_table[-3],
    CStdStubBuffer_DELEGATING_METHODS
};


/* Object interface: IGoogleDesktopSearchEventFactory, ver. 0.0,
   GUID={0xA79E51C6,0xDB2D,0x4a44,{0x84,0x8E,0xA8,0xEB,0xB2,0x2E,0x53,0x37}} */

#pragma code_seg(".orpc")
static const unsigned short IGoogleDesktopSearchEventFactory_FormatStringOffsetTable[] =
    {
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    (unsigned short) -1,
    198
    };

static const MIDL_STUBLESS_PROXY_INFO IGoogleDesktopSearchEventFactory_ProxyInfo =
    {
    &Object_StubDesc,
    GoogleDesktopSearchAPI__MIDL_ProcFormatString.Format,
    &IGoogleDesktopSearchEventFactory_FormatStringOffsetTable[-3],
    0,
    0,
    0
    };


static const MIDL_SERVER_INFO IGoogleDesktopSearchEventFactory_ServerInfo = 
    {
    &Object_StubDesc,
    0,
    GoogleDesktopSearchAPI__MIDL_ProcFormatString.Format,
    &IGoogleDesktopSearchEventFactory_FormatStringOffsetTable[-3],
    0,
    0,
    0,
    0};
CINTERFACE_PROXY_VTABLE(8) _IGoogleDesktopSearchEventFactoryProxyVtbl = 
{
    &IGoogleDesktopSearchEventFactory_ProxyInfo,
    &IID_IGoogleDesktopSearchEventFactory,
    IUnknown_QueryInterface_Proxy,
    IUnknown_AddRef_Proxy,
    IUnknown_Release_Proxy ,
    0 /* IDispatch::GetTypeInfoCount */ ,
    0 /* IDispatch::GetTypeInfo */ ,
    0 /* IDispatch::GetIDsOfNames */ ,
    0 /* IDispatch_Invoke_Proxy */ ,
    (void *) (INT_PTR) -1 /* IGoogleDesktopSearchEventFactory::CreateEvent */
};


EXTERN_C DECLSPEC_SELECTANY const PRPC_STUB_FUNCTION IGoogleDesktopSearchEventFactory_table[] =
{
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    STUB_FORWARDING_FUNCTION,
    NdrStubCall2
};

CInterfaceStubVtbl _IGoogleDesktopSearchEventFactoryStubVtbl =
{
    &IID_IGoogleDesktopSearchEventFactory,
    &IGoogleDesktopSearchEventFactory_ServerInfo,
    8,
    &IGoogleDesktopSearchEventFactory_table[-3],
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
    GoogleDesktopSearchAPI__MIDL_TypeFormatString.Format,
    1, /* -error bounds_check flag */
    0x60001, /* Ndr library version */
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

const CInterfaceProxyVtbl * const _GoogleDesktopSearchAPI_ProxyVtblList[] = 
{
    ( CInterfaceProxyVtbl *) &_IGoogleDesktopSearchEventProxyVtbl,
    ( CInterfaceProxyVtbl *) &_IGoogleDesktopSearchComponentRegisterProxyVtbl,
    ( CInterfaceProxyVtbl *) &_IGoogleDesktopSearchComponentRegistrationProxyVtbl,
    ( CInterfaceProxyVtbl *) &_IGoogleDesktopSearchEventFactoryProxyVtbl,
    0
};

const CInterfaceStubVtbl * const _GoogleDesktopSearchAPI_StubVtblList[] = 
{
    ( CInterfaceStubVtbl *) &_IGoogleDesktopSearchEventStubVtbl,
    ( CInterfaceStubVtbl *) &_IGoogleDesktopSearchComponentRegisterStubVtbl,
    ( CInterfaceStubVtbl *) &_IGoogleDesktopSearchComponentRegistrationStubVtbl,
    ( CInterfaceStubVtbl *) &_IGoogleDesktopSearchEventFactoryStubVtbl,
    0
};

PCInterfaceName const _GoogleDesktopSearchAPI_InterfaceNamesList[] = 
{
    "IGoogleDesktopSearchEvent",
    "IGoogleDesktopSearchComponentRegister",
    "IGoogleDesktopSearchComponentRegistration",
    "IGoogleDesktopSearchEventFactory",
    0
};

const IID *  const _GoogleDesktopSearchAPI_BaseIIDList[] = 
{
    &IID_IDispatch,
    &IID_IDispatch,
    &IID_IDispatch,
    &IID_IDispatch,
    0
};


#define _GoogleDesktopSearchAPI_CHECK_IID(n)	IID_GENERIC_CHECK_IID( _GoogleDesktopSearchAPI, pIID, n)

int __stdcall _GoogleDesktopSearchAPI_IID_Lookup( const IID * pIID, int * pIndex )
{
    IID_BS_LOOKUP_SETUP

    IID_BS_LOOKUP_INITIAL_TEST( _GoogleDesktopSearchAPI, 4, 2 )
    IID_BS_LOOKUP_NEXT_TEST( _GoogleDesktopSearchAPI, 1 )
    IID_BS_LOOKUP_RETURN_RESULT( _GoogleDesktopSearchAPI, 4, *pIndex )
    
}

EXTERN_C const ExtendedProxyFileInfo GoogleDesktopSearchAPI_ProxyFileInfo = 
{
    (PCInterfaceProxyVtblList *) & _GoogleDesktopSearchAPI_ProxyVtblList,
    (PCInterfaceStubVtblList *) & _GoogleDesktopSearchAPI_StubVtblList,
    (const PCInterfaceName * ) & _GoogleDesktopSearchAPI_InterfaceNamesList,
    (const IID ** ) & _GoogleDesktopSearchAPI_BaseIIDList,
    & _GoogleDesktopSearchAPI_IID_Lookup, 
    4,
    2,
    0, /* table of [async_uuid] interfaces */
    0, /* Filler1 */
    0, /* Filler2 */
    0  /* Filler3 */
};
#pragma optimize("", on )
#if _MSC_VER >= 1200
#pragma warning(pop)
#endif


#endif /* !defined(_M_IA64) && !defined(_M_AMD64) && !defined(_ARM_) */

