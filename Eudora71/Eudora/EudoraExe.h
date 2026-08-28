

/* this ALWAYS GENERATED file contains the definitions for the interfaces */


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


/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 475
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif /* __RPCNDR_H_VERSION__ */

#ifndef COM_NO_WINDOWS_H
#include "windows.h"
#include "ole2.h"
#endif /*COM_NO_WINDOWS_H*/

#ifndef __EudoraExe_h__
#define __EudoraExe_h__

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

#ifndef DECLSPEC_XFGVIRT
#if defined(_CONTROL_FLOW_GUARD_XFG)
#define DECLSPEC_XFGVIRT(base, func) __declspec(xfg_virtual(base, func))
#else
#define DECLSPEC_XFGVIRT(base, func)
#endif
#endif

/* Forward Declarations */ 

#ifndef __IEuApplication_FWD_DEFINED__
#define __IEuApplication_FWD_DEFINED__
typedef interface IEuApplication IEuApplication;

#endif 	/* __IEuApplication_FWD_DEFINED__ */


#ifndef __IEuMessage_FWD_DEFINED__
#define __IEuMessage_FWD_DEFINED__
typedef interface IEuMessage IEuMessage;

#endif 	/* __IEuMessage_FWD_DEFINED__ */


#ifndef __IEuMessages_FWD_DEFINED__
#define __IEuMessages_FWD_DEFINED__
typedef interface IEuMessages IEuMessages;

#endif 	/* __IEuMessages_FWD_DEFINED__ */


#ifndef __IEuFolder_FWD_DEFINED__
#define __IEuFolder_FWD_DEFINED__
typedef interface IEuFolder IEuFolder;

#endif 	/* __IEuFolder_FWD_DEFINED__ */


#ifndef __IEuFolders_FWD_DEFINED__
#define __IEuFolders_FWD_DEFINED__
typedef interface IEuFolders IEuFolders;

#endif 	/* __IEuFolders_FWD_DEFINED__ */


#ifndef __IEuApplicationEvents_FWD_DEFINED__
#define __IEuApplicationEvents_FWD_DEFINED__
typedef interface IEuApplicationEvents IEuApplicationEvents;

#endif 	/* __IEuApplicationEvents_FWD_DEFINED__ */


#ifndef __EuApplication_FWD_DEFINED__
#define __EuApplication_FWD_DEFINED__

#ifdef __cplusplus
typedef class EuApplication EuApplication;
#else
typedef struct EuApplication EuApplication;
#endif /* __cplusplus */

#endif 	/* __EuApplication_FWD_DEFINED__ */


#ifndef __EuMessage_FWD_DEFINED__
#define __EuMessage_FWD_DEFINED__

#ifdef __cplusplus
typedef class EuMessage EuMessage;
#else
typedef struct EuMessage EuMessage;
#endif /* __cplusplus */

#endif 	/* __EuMessage_FWD_DEFINED__ */


#ifndef __EuMessages_FWD_DEFINED__
#define __EuMessages_FWD_DEFINED__

#ifdef __cplusplus
typedef class EuMessages EuMessages;
#else
typedef struct EuMessages EuMessages;
#endif /* __cplusplus */

#endif 	/* __EuMessages_FWD_DEFINED__ */


#ifndef __EuFolder_FWD_DEFINED__
#define __EuFolder_FWD_DEFINED__

#ifdef __cplusplus
typedef class EuFolder EuFolder;
#else
typedef struct EuFolder EuFolder;
#endif /* __cplusplus */

#endif 	/* __EuFolder_FWD_DEFINED__ */


#ifndef __EuFolders_FWD_DEFINED__
#define __EuFolders_FWD_DEFINED__

#ifdef __cplusplus
typedef class EuFolders EuFolders;
#else
typedef struct EuFolders EuFolders;
#endif /* __cplusplus */

#endif 	/* __EuFolders_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"
#include "ocidl.h"

#ifdef __cplusplus
extern "C"{
#endif 


/* interface __MIDL_itf_EudoraExe_0000_0000 */
/* [local] */ 





typedef /* [public][public][helpstring] */ 
enum __MIDL___MIDL_itf_EudoraExe_0000_0000_0001
    {
        hfAttachments	= 0,
        hfBcc	= 1,
        hfCc	= 2,
        hfEmbeddedContent	= 3,
        hfFrom	= 4,
        hfHeaderDate	= 5,
        hfHeaderStatus	= 6,
        hfInReplyTo	= 7,
        hfMessageID	= 8,
        hfPersona	= 9,
        hfPrecedence	= 10,
        hfPriority	= 11,
        hfPriorityMatch	= 12,
        hfReferences	= 13,
        hfReplyTo	= 14,
        hfSubject	= 15,
        hfTo	= 16
    } 	enHeaderField;

typedef /* [public][public][public][helpstring] */ 
enum __MIDL___MIDL_itf_EudoraExe_0000_0000_0002
    {
        msUnread	= 0,
        msRead	= 1,
        msReplied	= 2,
        msForwarded	= 3,
        msRedirect	= 4,
        msUnsendable	= 5,
        msSendable	= 6,
        msQueued	= 7,
        msSent	= 8,
        msUnsent	= 9,
        msTimeQueued	= 10
    } 	enMessageStatus;



extern RPC_IF_HANDLE __MIDL_itf_EudoraExe_0000_0000_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_EudoraExe_0000_0000_v0_0_s_ifspec;

#ifndef __IEuApplication_INTERFACE_DEFINED__
#define __IEuApplication_INTERFACE_DEFINED__

/* interface IEuApplication */
/* [unique][hidden][oleautomation][helpstring][dual][uuid][object] */ 


EXTERN_C const IID IID_IEuApplication;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("EDA10001-AAAA-11d0-B3C5-00805F8AA4FB")
    IEuApplication : public IDispatch
    {
    public:
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Application( 
            /* [retval][out] */ IEuApplication **pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Caption( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [helpstring][id][propput] */ HRESULT STDMETHODCALLTYPE put_Caption( 
            /* [in] */ BSTR newVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Folders( 
            /* [retval][out] */ IEuFolders **pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_FullName( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Height( 
            /* [retval][out] */ long *pVal) = 0;
        
        virtual /* [helpstring][id][propput] */ HRESULT STDMETHODCALLTYPE put_Height( 
            /* [in] */ long newVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_InBox( 
            /* [retval][out] */ IEuFolder **pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Interactive( 
            /* [retval][out] */ BOOL *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Left( 
            /* [retval][out] */ long *pVal) = 0;
        
        virtual /* [helpstring][id][propput] */ HRESULT STDMETHODCALLTYPE put_Left( 
            /* [in] */ long newVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Name( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Path( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Parent( 
            /* [retval][out] */ IEuApplication **pVal) = 0;
        
        virtual /* [hidden][helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_ProcessID( 
            /* [retval][out] */ long *pVal) = 0;
        
        virtual /* [hidden][helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_RefCount( 
            /* [retval][out] */ long *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_RootFolder( 
            /* [retval][out] */ IEuFolder **pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_StatusBar( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [helpstring][id][propput] */ HRESULT STDMETHODCALLTYPE put_StatusBar( 
            /* [in] */ BSTR newVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Top( 
            /* [retval][out] */ long *pVal) = 0;
        
        virtual /* [helpstring][id][propput] */ HRESULT STDMETHODCALLTYPE put_Top( 
            /* [in] */ long newVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_VersionBuild( 
            /* [retval][out] */ short *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_VersionMajor( 
            /* [retval][out] */ short *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_VersionMinor( 
            /* [retval][out] */ short *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_VersionMinor2( 
            /* [retval][out] */ short *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Visible( 
            /* [retval][out] */ BOOL *pVal) = 0;
        
        virtual /* [helpstring][id][propput] */ HRESULT STDMETHODCALLTYPE put_Visible( 
            /* [in] */ BOOL newVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Width( 
            /* [retval][out] */ long *pVal) = 0;
        
        virtual /* [helpstring][id][propput] */ HRESULT STDMETHODCALLTYPE put_Width( 
            /* [in] */ long newVal) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE CloseEudora( void) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE CheckMail( 
            /* [optional][in] */ VARIANT Password) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE CompactFolders( void) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE EmptyTrash( void) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Folder( 
            BSTR Name,
            BOOL FindRecursive,
            /* [retval][out] */ IEuFolder **pVal) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE FolderByID( 
            long ID,
            BOOL FindRecursive,
            /* [retval][out] */ IEuFolder **pVal) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE QueueMessage( 
            BSTR To,
            BSTR Subject,
            BSTR Cc,
            BSTR Bcc,
            BSTR Attach,
            BSTR Body) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE SendQueuedMessages( void) = 0;
        
    };
    
    
#else 	/* C style interface */

    typedef struct IEuApplicationVtbl
    {
        BEGIN_INTERFACE
        
        DECLSPEC_XFGVIRT(IUnknown, QueryInterface)
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IEuApplication * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            _COM_Outptr_  void **ppvObject);
        
        DECLSPEC_XFGVIRT(IUnknown, AddRef)
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IEuApplication * This);
        
        DECLSPEC_XFGVIRT(IUnknown, Release)
        ULONG ( STDMETHODCALLTYPE *Release )( 
            IEuApplication * This);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfoCount)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            IEuApplication * This,
            /* [out] */ UINT *pctinfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfo)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            IEuApplication * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetIDsOfNames)
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            IEuApplication * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [range][in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        DECLSPEC_XFGVIRT(IDispatch, Invoke)
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            IEuApplication * This,
            /* [annotation][in] */ 
            _In_  DISPID dispIdMember,
            /* [annotation][in] */ 
            _In_  REFIID riid,
            /* [annotation][in] */ 
            _In_  LCID lcid,
            /* [annotation][in] */ 
            _In_  WORD wFlags,
            /* [annotation][out][in] */ 
            _In_  DISPPARAMS *pDispParams,
            /* [annotation][out] */ 
            _Out_opt_  VARIANT *pVarResult,
            /* [annotation][out] */ 
            _Out_opt_  EXCEPINFO *pExcepInfo,
            /* [annotation][out] */ 
            _Out_opt_  UINT *puArgErr);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_Application)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Application )( 
            IEuApplication * This,
            /* [retval][out] */ IEuApplication **pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_Caption)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Caption )( 
            IEuApplication * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, put_Caption)
        /* [helpstring][id][propput] */ HRESULT ( STDMETHODCALLTYPE *put_Caption )( 
            IEuApplication * This,
            /* [in] */ BSTR newVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_Folders)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Folders )( 
            IEuApplication * This,
            /* [retval][out] */ IEuFolders **pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_FullName)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_FullName )( 
            IEuApplication * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_Height)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Height )( 
            IEuApplication * This,
            /* [retval][out] */ long *pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, put_Height)
        /* [helpstring][id][propput] */ HRESULT ( STDMETHODCALLTYPE *put_Height )( 
            IEuApplication * This,
            /* [in] */ long newVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_InBox)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_InBox )( 
            IEuApplication * This,
            /* [retval][out] */ IEuFolder **pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_Interactive)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Interactive )( 
            IEuApplication * This,
            /* [retval][out] */ BOOL *pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_Left)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Left )( 
            IEuApplication * This,
            /* [retval][out] */ long *pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, put_Left)
        /* [helpstring][id][propput] */ HRESULT ( STDMETHODCALLTYPE *put_Left )( 
            IEuApplication * This,
            /* [in] */ long newVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_Name)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Name )( 
            IEuApplication * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_Path)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Path )( 
            IEuApplication * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_Parent)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Parent )( 
            IEuApplication * This,
            /* [retval][out] */ IEuApplication **pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_ProcessID)
        /* [hidden][helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_ProcessID )( 
            IEuApplication * This,
            /* [retval][out] */ long *pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_RefCount)
        /* [hidden][helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_RefCount )( 
            IEuApplication * This,
            /* [retval][out] */ long *pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_RootFolder)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_RootFolder )( 
            IEuApplication * This,
            /* [retval][out] */ IEuFolder **pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_StatusBar)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_StatusBar )( 
            IEuApplication * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, put_StatusBar)
        /* [helpstring][id][propput] */ HRESULT ( STDMETHODCALLTYPE *put_StatusBar )( 
            IEuApplication * This,
            /* [in] */ BSTR newVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_Top)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Top )( 
            IEuApplication * This,
            /* [retval][out] */ long *pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, put_Top)
        /* [helpstring][id][propput] */ HRESULT ( STDMETHODCALLTYPE *put_Top )( 
            IEuApplication * This,
            /* [in] */ long newVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_VersionBuild)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_VersionBuild )( 
            IEuApplication * This,
            /* [retval][out] */ short *pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_VersionMajor)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_VersionMajor )( 
            IEuApplication * This,
            /* [retval][out] */ short *pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_VersionMinor)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_VersionMinor )( 
            IEuApplication * This,
            /* [retval][out] */ short *pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_VersionMinor2)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_VersionMinor2 )( 
            IEuApplication * This,
            /* [retval][out] */ short *pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_Visible)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Visible )( 
            IEuApplication * This,
            /* [retval][out] */ BOOL *pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, put_Visible)
        /* [helpstring][id][propput] */ HRESULT ( STDMETHODCALLTYPE *put_Visible )( 
            IEuApplication * This,
            /* [in] */ BOOL newVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, get_Width)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Width )( 
            IEuApplication * This,
            /* [retval][out] */ long *pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, put_Width)
        /* [helpstring][id][propput] */ HRESULT ( STDMETHODCALLTYPE *put_Width )( 
            IEuApplication * This,
            /* [in] */ long newVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, CloseEudora)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *CloseEudora )( 
            IEuApplication * This);
        
        DECLSPEC_XFGVIRT(IEuApplication, CheckMail)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *CheckMail )( 
            IEuApplication * This,
            /* [optional][in] */ VARIANT Password);
        
        DECLSPEC_XFGVIRT(IEuApplication, CompactFolders)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *CompactFolders )( 
            IEuApplication * This);
        
        DECLSPEC_XFGVIRT(IEuApplication, EmptyTrash)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *EmptyTrash )( 
            IEuApplication * This);
        
        DECLSPEC_XFGVIRT(IEuApplication, Folder)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Folder )( 
            IEuApplication * This,
            BSTR Name,
            BOOL FindRecursive,
            /* [retval][out] */ IEuFolder **pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, FolderByID)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *FolderByID )( 
            IEuApplication * This,
            long ID,
            BOOL FindRecursive,
            /* [retval][out] */ IEuFolder **pVal);
        
        DECLSPEC_XFGVIRT(IEuApplication, QueueMessage)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *QueueMessage )( 
            IEuApplication * This,
            BSTR To,
            BSTR Subject,
            BSTR Cc,
            BSTR Bcc,
            BSTR Attach,
            BSTR Body);
        
        DECLSPEC_XFGVIRT(IEuApplication, SendQueuedMessages)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *SendQueuedMessages )( 
            IEuApplication * This);
        
        END_INTERFACE
    } IEuApplicationVtbl;

    interface IEuApplication
    {
        CONST_VTBL struct IEuApplicationVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IEuApplication_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IEuApplication_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define IEuApplication_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define IEuApplication_GetTypeInfoCount(This,pctinfo)	\
    ( (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo) ) 

#define IEuApplication_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    ( (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo) ) 

#define IEuApplication_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    ( (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId) ) 

#define IEuApplication_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    ( (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr) ) 


#define IEuApplication_get_Application(This,pVal)	\
    ( (This)->lpVtbl -> get_Application(This,pVal) ) 

#define IEuApplication_get_Caption(This,pVal)	\
    ( (This)->lpVtbl -> get_Caption(This,pVal) ) 

#define IEuApplication_put_Caption(This,newVal)	\
    ( (This)->lpVtbl -> put_Caption(This,newVal) ) 

#define IEuApplication_get_Folders(This,pVal)	\
    ( (This)->lpVtbl -> get_Folders(This,pVal) ) 

#define IEuApplication_get_FullName(This,pVal)	\
    ( (This)->lpVtbl -> get_FullName(This,pVal) ) 

#define IEuApplication_get_Height(This,pVal)	\
    ( (This)->lpVtbl -> get_Height(This,pVal) ) 

#define IEuApplication_put_Height(This,newVal)	\
    ( (This)->lpVtbl -> put_Height(This,newVal) ) 

#define IEuApplication_get_InBox(This,pVal)	\
    ( (This)->lpVtbl -> get_InBox(This,pVal) ) 

#define IEuApplication_get_Interactive(This,pVal)	\
    ( (This)->lpVtbl -> get_Interactive(This,pVal) ) 

#define IEuApplication_get_Left(This,pVal)	\
    ( (This)->lpVtbl -> get_Left(This,pVal) ) 

#define IEuApplication_put_Left(This,newVal)	\
    ( (This)->lpVtbl -> put_Left(This,newVal) ) 

#define IEuApplication_get_Name(This,pVal)	\
    ( (This)->lpVtbl -> get_Name(This,pVal) ) 

#define IEuApplication_get_Path(This,pVal)	\
    ( (This)->lpVtbl -> get_Path(This,pVal) ) 

#define IEuApplication_get_Parent(This,pVal)	\
    ( (This)->lpVtbl -> get_Parent(This,pVal) ) 

#define IEuApplication_get_ProcessID(This,pVal)	\
    ( (This)->lpVtbl -> get_ProcessID(This,pVal) ) 

#define IEuApplication_get_RefCount(This,pVal)	\
    ( (This)->lpVtbl -> get_RefCount(This,pVal) ) 

#define IEuApplication_get_RootFolder(This,pVal)	\
    ( (This)->lpVtbl -> get_RootFolder(This,pVal) ) 

#define IEuApplication_get_StatusBar(This,pVal)	\
    ( (This)->lpVtbl -> get_StatusBar(This,pVal) ) 

#define IEuApplication_put_StatusBar(This,newVal)	\
    ( (This)->lpVtbl -> put_StatusBar(This,newVal) ) 

#define IEuApplication_get_Top(This,pVal)	\
    ( (This)->lpVtbl -> get_Top(This,pVal) ) 

#define IEuApplication_put_Top(This,newVal)	\
    ( (This)->lpVtbl -> put_Top(This,newVal) ) 

#define IEuApplication_get_VersionBuild(This,pVal)	\
    ( (This)->lpVtbl -> get_VersionBuild(This,pVal) ) 

#define IEuApplication_get_VersionMajor(This,pVal)	\
    ( (This)->lpVtbl -> get_VersionMajor(This,pVal) ) 

#define IEuApplication_get_VersionMinor(This,pVal)	\
    ( (This)->lpVtbl -> get_VersionMinor(This,pVal) ) 

#define IEuApplication_get_VersionMinor2(This,pVal)	\
    ( (This)->lpVtbl -> get_VersionMinor2(This,pVal) ) 

#define IEuApplication_get_Visible(This,pVal)	\
    ( (This)->lpVtbl -> get_Visible(This,pVal) ) 

#define IEuApplication_put_Visible(This,newVal)	\
    ( (This)->lpVtbl -> put_Visible(This,newVal) ) 

#define IEuApplication_get_Width(This,pVal)	\
    ( (This)->lpVtbl -> get_Width(This,pVal) ) 

#define IEuApplication_put_Width(This,newVal)	\
    ( (This)->lpVtbl -> put_Width(This,newVal) ) 

#define IEuApplication_CloseEudora(This)	\
    ( (This)->lpVtbl -> CloseEudora(This) ) 

#define IEuApplication_CheckMail(This,Password)	\
    ( (This)->lpVtbl -> CheckMail(This,Password) ) 

#define IEuApplication_CompactFolders(This)	\
    ( (This)->lpVtbl -> CompactFolders(This) ) 

#define IEuApplication_EmptyTrash(This)	\
    ( (This)->lpVtbl -> EmptyTrash(This) ) 

#define IEuApplication_Folder(This,Name,FindRecursive,pVal)	\
    ( (This)->lpVtbl -> Folder(This,Name,FindRecursive,pVal) ) 

#define IEuApplication_FolderByID(This,ID,FindRecursive,pVal)	\
    ( (This)->lpVtbl -> FolderByID(This,ID,FindRecursive,pVal) ) 

#define IEuApplication_QueueMessage(This,To,Subject,Cc,Bcc,Attach,Body)	\
    ( (This)->lpVtbl -> QueueMessage(This,To,Subject,Cc,Bcc,Attach,Body) ) 

#define IEuApplication_SendQueuedMessages(This)	\
    ( (This)->lpVtbl -> SendQueuedMessages(This) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __IEuApplication_INTERFACE_DEFINED__ */


#ifndef __IEuMessage_INTERFACE_DEFINED__
#define __IEuMessage_INTERFACE_DEFINED__

/* interface IEuMessage */
/* [unique][hidden][oleautomation][helpstring][dual][uuid][object] */ 


EXTERN_C const IID IID_IEuMessage;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("EDA10004-AAAA-11d0-B3C5-00805F8AA4FB")
    IEuMessage : public IDispatch
    {
    public:
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_AttachmentListAsString( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Body( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_BodyAsHTML( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_BodyAsSimpleText( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Date( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_From( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_HeaderInfo( 
            /* [in] */ enHeaderField HeaderField,
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_ID( 
            /* [retval][out] */ long *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Index( 
            /* [retval][out] */ long *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_RawMessage( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [hidden][helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_RefCount( 
            /* [retval][out] */ long *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Priority( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Status( 
            /* [retval][out] */ enMessageStatus *pVal) = 0;
        
        virtual /* [helpstring][id][propput] */ HRESULT STDMETHODCALLTYPE put_Status( 
            /* [in] */ enMessageStatus newVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Subject( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_To( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Move( 
            IEuFolder *NewParentFolder) = 0;
        
    };
    
    
#else 	/* C style interface */

    typedef struct IEuMessageVtbl
    {
        BEGIN_INTERFACE
        
        DECLSPEC_XFGVIRT(IUnknown, QueryInterface)
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IEuMessage * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            _COM_Outptr_  void **ppvObject);
        
        DECLSPEC_XFGVIRT(IUnknown, AddRef)
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IEuMessage * This);
        
        DECLSPEC_XFGVIRT(IUnknown, Release)
        ULONG ( STDMETHODCALLTYPE *Release )( 
            IEuMessage * This);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfoCount)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            IEuMessage * This,
            /* [out] */ UINT *pctinfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfo)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            IEuMessage * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetIDsOfNames)
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            IEuMessage * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [range][in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        DECLSPEC_XFGVIRT(IDispatch, Invoke)
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            IEuMessage * This,
            /* [annotation][in] */ 
            _In_  DISPID dispIdMember,
            /* [annotation][in] */ 
            _In_  REFIID riid,
            /* [annotation][in] */ 
            _In_  LCID lcid,
            /* [annotation][in] */ 
            _In_  WORD wFlags,
            /* [annotation][out][in] */ 
            _In_  DISPPARAMS *pDispParams,
            /* [annotation][out] */ 
            _Out_opt_  VARIANT *pVarResult,
            /* [annotation][out] */ 
            _Out_opt_  EXCEPINFO *pExcepInfo,
            /* [annotation][out] */ 
            _Out_opt_  UINT *puArgErr);
        
        DECLSPEC_XFGVIRT(IEuMessage, get_AttachmentListAsString)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_AttachmentListAsString )( 
            IEuMessage * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuMessage, get_Body)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Body )( 
            IEuMessage * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuMessage, get_BodyAsHTML)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_BodyAsHTML )( 
            IEuMessage * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuMessage, get_BodyAsSimpleText)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_BodyAsSimpleText )( 
            IEuMessage * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuMessage, get_Date)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Date )( 
            IEuMessage * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuMessage, get_From)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_From )( 
            IEuMessage * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuMessage, get_HeaderInfo)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_HeaderInfo )( 
            IEuMessage * This,
            /* [in] */ enHeaderField HeaderField,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuMessage, get_ID)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_ID )( 
            IEuMessage * This,
            /* [retval][out] */ long *pVal);
        
        DECLSPEC_XFGVIRT(IEuMessage, get_Index)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Index )( 
            IEuMessage * This,
            /* [retval][out] */ long *pVal);
        
        DECLSPEC_XFGVIRT(IEuMessage, get_RawMessage)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_RawMessage )( 
            IEuMessage * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuMessage, get_RefCount)
        /* [hidden][helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_RefCount )( 
            IEuMessage * This,
            /* [retval][out] */ long *pVal);
        
        DECLSPEC_XFGVIRT(IEuMessage, get_Priority)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Priority )( 
            IEuMessage * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuMessage, get_Status)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Status )( 
            IEuMessage * This,
            /* [retval][out] */ enMessageStatus *pVal);
        
        DECLSPEC_XFGVIRT(IEuMessage, put_Status)
        /* [helpstring][id][propput] */ HRESULT ( STDMETHODCALLTYPE *put_Status )( 
            IEuMessage * This,
            /* [in] */ enMessageStatus newVal);
        
        DECLSPEC_XFGVIRT(IEuMessage, get_Subject)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Subject )( 
            IEuMessage * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuMessage, get_To)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_To )( 
            IEuMessage * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuMessage, Move)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Move )( 
            IEuMessage * This,
            IEuFolder *NewParentFolder);
        
        END_INTERFACE
    } IEuMessageVtbl;

    interface IEuMessage
    {
        CONST_VTBL struct IEuMessageVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IEuMessage_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IEuMessage_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define IEuMessage_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define IEuMessage_GetTypeInfoCount(This,pctinfo)	\
    ( (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo) ) 

#define IEuMessage_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    ( (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo) ) 

#define IEuMessage_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    ( (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId) ) 

#define IEuMessage_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    ( (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr) ) 


#define IEuMessage_get_AttachmentListAsString(This,pVal)	\
    ( (This)->lpVtbl -> get_AttachmentListAsString(This,pVal) ) 

#define IEuMessage_get_Body(This,pVal)	\
    ( (This)->lpVtbl -> get_Body(This,pVal) ) 

#define IEuMessage_get_BodyAsHTML(This,pVal)	\
    ( (This)->lpVtbl -> get_BodyAsHTML(This,pVal) ) 

#define IEuMessage_get_BodyAsSimpleText(This,pVal)	\
    ( (This)->lpVtbl -> get_BodyAsSimpleText(This,pVal) ) 

#define IEuMessage_get_Date(This,pVal)	\
    ( (This)->lpVtbl -> get_Date(This,pVal) ) 

#define IEuMessage_get_From(This,pVal)	\
    ( (This)->lpVtbl -> get_From(This,pVal) ) 

#define IEuMessage_get_HeaderInfo(This,HeaderField,pVal)	\
    ( (This)->lpVtbl -> get_HeaderInfo(This,HeaderField,pVal) ) 

#define IEuMessage_get_ID(This,pVal)	\
    ( (This)->lpVtbl -> get_ID(This,pVal) ) 

#define IEuMessage_get_Index(This,pVal)	\
    ( (This)->lpVtbl -> get_Index(This,pVal) ) 

#define IEuMessage_get_RawMessage(This,pVal)	\
    ( (This)->lpVtbl -> get_RawMessage(This,pVal) ) 

#define IEuMessage_get_RefCount(This,pVal)	\
    ( (This)->lpVtbl -> get_RefCount(This,pVal) ) 

#define IEuMessage_get_Priority(This,pVal)	\
    ( (This)->lpVtbl -> get_Priority(This,pVal) ) 

#define IEuMessage_get_Status(This,pVal)	\
    ( (This)->lpVtbl -> get_Status(This,pVal) ) 

#define IEuMessage_put_Status(This,newVal)	\
    ( (This)->lpVtbl -> put_Status(This,newVal) ) 

#define IEuMessage_get_Subject(This,pVal)	\
    ( (This)->lpVtbl -> get_Subject(This,pVal) ) 

#define IEuMessage_get_To(This,pVal)	\
    ( (This)->lpVtbl -> get_To(This,pVal) ) 

#define IEuMessage_Move(This,NewParentFolder)	\
    ( (This)->lpVtbl -> Move(This,NewParentFolder) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __IEuMessage_INTERFACE_DEFINED__ */


#ifndef __IEuMessages_INTERFACE_DEFINED__
#define __IEuMessages_INTERFACE_DEFINED__

/* interface IEuMessages */
/* [unique][hidden][oleautomation][helpstring][dual][uuid][object] */ 


EXTERN_C const IID IID_IEuMessages;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("EDA10005-AAAA-11d0-B3C5-00805F8AA4FB")
    IEuMessages : public IDispatch
    {
    public:
        virtual /* [id][propget] */ HRESULT STDMETHODCALLTYPE get_Item( 
            /* [in] */ long Index,
            /* [retval][out] */ VARIANT *ppFolder) = 0;
        
        virtual /* [restricted][id][propget] */ HRESULT STDMETHODCALLTYPE get__NewEnum( 
            /* [retval][out] */ IUnknown **ppEnum) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Count( 
            /* [retval][out] */ long *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_ItemByID( 
            /* [in] */ long ID,
            /* [retval][out] */ VARIANT *ppFolder) = 0;
        
        virtual /* [hidden][helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_RefCount( 
            /* [retval][out] */ long *pVal) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE RemoveByID( 
            long ID) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE UpdateList( void) = 0;
        
    };
    
    
#else 	/* C style interface */

    typedef struct IEuMessagesVtbl
    {
        BEGIN_INTERFACE
        
        DECLSPEC_XFGVIRT(IUnknown, QueryInterface)
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IEuMessages * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            _COM_Outptr_  void **ppvObject);
        
        DECLSPEC_XFGVIRT(IUnknown, AddRef)
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IEuMessages * This);
        
        DECLSPEC_XFGVIRT(IUnknown, Release)
        ULONG ( STDMETHODCALLTYPE *Release )( 
            IEuMessages * This);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfoCount)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            IEuMessages * This,
            /* [out] */ UINT *pctinfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfo)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            IEuMessages * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetIDsOfNames)
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            IEuMessages * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [range][in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        DECLSPEC_XFGVIRT(IDispatch, Invoke)
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            IEuMessages * This,
            /* [annotation][in] */ 
            _In_  DISPID dispIdMember,
            /* [annotation][in] */ 
            _In_  REFIID riid,
            /* [annotation][in] */ 
            _In_  LCID lcid,
            /* [annotation][in] */ 
            _In_  WORD wFlags,
            /* [annotation][out][in] */ 
            _In_  DISPPARAMS *pDispParams,
            /* [annotation][out] */ 
            _Out_opt_  VARIANT *pVarResult,
            /* [annotation][out] */ 
            _Out_opt_  EXCEPINFO *pExcepInfo,
            /* [annotation][out] */ 
            _Out_opt_  UINT *puArgErr);
        
        DECLSPEC_XFGVIRT(IEuMessages, get_Item)
        /* [id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Item )( 
            IEuMessages * This,
            /* [in] */ long Index,
            /* [retval][out] */ VARIANT *ppFolder);
        
        DECLSPEC_XFGVIRT(IEuMessages, get__NewEnum)
        /* [restricted][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get__NewEnum )( 
            IEuMessages * This,
            /* [retval][out] */ IUnknown **ppEnum);
        
        DECLSPEC_XFGVIRT(IEuMessages, get_Count)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Count )( 
            IEuMessages * This,
            /* [retval][out] */ long *pVal);
        
        DECLSPEC_XFGVIRT(IEuMessages, get_ItemByID)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_ItemByID )( 
            IEuMessages * This,
            /* [in] */ long ID,
            /* [retval][out] */ VARIANT *ppFolder);
        
        DECLSPEC_XFGVIRT(IEuMessages, get_RefCount)
        /* [hidden][helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_RefCount )( 
            IEuMessages * This,
            /* [retval][out] */ long *pVal);
        
        DECLSPEC_XFGVIRT(IEuMessages, RemoveByID)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *RemoveByID )( 
            IEuMessages * This,
            long ID);
        
        DECLSPEC_XFGVIRT(IEuMessages, UpdateList)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *UpdateList )( 
            IEuMessages * This);
        
        END_INTERFACE
    } IEuMessagesVtbl;

    interface IEuMessages
    {
        CONST_VTBL struct IEuMessagesVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IEuMessages_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IEuMessages_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define IEuMessages_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define IEuMessages_GetTypeInfoCount(This,pctinfo)	\
    ( (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo) ) 

#define IEuMessages_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    ( (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo) ) 

#define IEuMessages_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    ( (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId) ) 

#define IEuMessages_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    ( (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr) ) 


#define IEuMessages_get_Item(This,Index,ppFolder)	\
    ( (This)->lpVtbl -> get_Item(This,Index,ppFolder) ) 

#define IEuMessages_get__NewEnum(This,ppEnum)	\
    ( (This)->lpVtbl -> get__NewEnum(This,ppEnum) ) 

#define IEuMessages_get_Count(This,pVal)	\
    ( (This)->lpVtbl -> get_Count(This,pVal) ) 

#define IEuMessages_get_ItemByID(This,ID,ppFolder)	\
    ( (This)->lpVtbl -> get_ItemByID(This,ID,ppFolder) ) 

#define IEuMessages_get_RefCount(This,pVal)	\
    ( (This)->lpVtbl -> get_RefCount(This,pVal) ) 

#define IEuMessages_RemoveByID(This,ID)	\
    ( (This)->lpVtbl -> RemoveByID(This,ID) ) 

#define IEuMessages_UpdateList(This)	\
    ( (This)->lpVtbl -> UpdateList(This) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __IEuMessages_INTERFACE_DEFINED__ */


#ifndef __IEuFolder_INTERFACE_DEFINED__
#define __IEuFolder_INTERFACE_DEFINED__

/* interface IEuFolder */
/* [unique][hidden][oleautomation][helpstring][dual][uuid][object] */ 


EXTERN_C const IID IID_IEuFolder;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("EDA10014-AAAA-11d0-B3C5-00805F8AA4FB")
    IEuFolder : public IDispatch
    {
    public:
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_bCanContainMessages( 
            /* [retval][out] */ BOOL *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_bCanContainSubFolders( 
            /* [retval][out] */ BOOL *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_bContainsUnreadMessages( 
            /* [retval][out] */ BOOL *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_bIsImapFolder( 
            /* [retval][out] */ BOOL *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Level( 
            /* [retval][out] */ short *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Folders( 
            /* [retval][out] */ IEuFolders **pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_FullName( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_ID( 
            /* [retval][out] */ long *pVal) = 0;
        
        virtual /* [hidden][helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Index( 
            /* [retval][out] */ long *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Messages( 
            /* [retval][out] */ IEuMessages **pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Name( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Path( 
            /* [retval][out] */ BSTR *pVal) = 0;
        
        virtual /* [hidden][helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_RefCount( 
            /* [retval][out] */ long *pVal) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Move( 
            IEuFolder *NewParentFolder) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Open( void) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Resynchronize( void) = 0;
        
    };
    
    
#else 	/* C style interface */

    typedef struct IEuFolderVtbl
    {
        BEGIN_INTERFACE
        
        DECLSPEC_XFGVIRT(IUnknown, QueryInterface)
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IEuFolder * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            _COM_Outptr_  void **ppvObject);
        
        DECLSPEC_XFGVIRT(IUnknown, AddRef)
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IEuFolder * This);
        
        DECLSPEC_XFGVIRT(IUnknown, Release)
        ULONG ( STDMETHODCALLTYPE *Release )( 
            IEuFolder * This);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfoCount)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            IEuFolder * This,
            /* [out] */ UINT *pctinfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfo)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            IEuFolder * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetIDsOfNames)
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            IEuFolder * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [range][in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        DECLSPEC_XFGVIRT(IDispatch, Invoke)
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            IEuFolder * This,
            /* [annotation][in] */ 
            _In_  DISPID dispIdMember,
            /* [annotation][in] */ 
            _In_  REFIID riid,
            /* [annotation][in] */ 
            _In_  LCID lcid,
            /* [annotation][in] */ 
            _In_  WORD wFlags,
            /* [annotation][out][in] */ 
            _In_  DISPPARAMS *pDispParams,
            /* [annotation][out] */ 
            _Out_opt_  VARIANT *pVarResult,
            /* [annotation][out] */ 
            _Out_opt_  EXCEPINFO *pExcepInfo,
            /* [annotation][out] */ 
            _Out_opt_  UINT *puArgErr);
        
        DECLSPEC_XFGVIRT(IEuFolder, get_bCanContainMessages)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_bCanContainMessages )( 
            IEuFolder * This,
            /* [retval][out] */ BOOL *pVal);
        
        DECLSPEC_XFGVIRT(IEuFolder, get_bCanContainSubFolders)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_bCanContainSubFolders )( 
            IEuFolder * This,
            /* [retval][out] */ BOOL *pVal);
        
        DECLSPEC_XFGVIRT(IEuFolder, get_bContainsUnreadMessages)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_bContainsUnreadMessages )( 
            IEuFolder * This,
            /* [retval][out] */ BOOL *pVal);
        
        DECLSPEC_XFGVIRT(IEuFolder, get_bIsImapFolder)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_bIsImapFolder )( 
            IEuFolder * This,
            /* [retval][out] */ BOOL *pVal);
        
        DECLSPEC_XFGVIRT(IEuFolder, get_Level)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Level )( 
            IEuFolder * This,
            /* [retval][out] */ short *pVal);
        
        DECLSPEC_XFGVIRT(IEuFolder, get_Folders)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Folders )( 
            IEuFolder * This,
            /* [retval][out] */ IEuFolders **pVal);
        
        DECLSPEC_XFGVIRT(IEuFolder, get_FullName)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_FullName )( 
            IEuFolder * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuFolder, get_ID)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_ID )( 
            IEuFolder * This,
            /* [retval][out] */ long *pVal);
        
        DECLSPEC_XFGVIRT(IEuFolder, get_Index)
        /* [hidden][helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Index )( 
            IEuFolder * This,
            /* [retval][out] */ long *pVal);
        
        DECLSPEC_XFGVIRT(IEuFolder, get_Messages)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Messages )( 
            IEuFolder * This,
            /* [retval][out] */ IEuMessages **pVal);
        
        DECLSPEC_XFGVIRT(IEuFolder, get_Name)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Name )( 
            IEuFolder * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuFolder, get_Path)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Path )( 
            IEuFolder * This,
            /* [retval][out] */ BSTR *pVal);
        
        DECLSPEC_XFGVIRT(IEuFolder, get_RefCount)
        /* [hidden][helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_RefCount )( 
            IEuFolder * This,
            /* [retval][out] */ long *pVal);
        
        DECLSPEC_XFGVIRT(IEuFolder, Move)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Move )( 
            IEuFolder * This,
            IEuFolder *NewParentFolder);
        
        DECLSPEC_XFGVIRT(IEuFolder, Open)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Open )( 
            IEuFolder * This);
        
        DECLSPEC_XFGVIRT(IEuFolder, Resynchronize)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Resynchronize )( 
            IEuFolder * This);
        
        END_INTERFACE
    } IEuFolderVtbl;

    interface IEuFolder
    {
        CONST_VTBL struct IEuFolderVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IEuFolder_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IEuFolder_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define IEuFolder_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define IEuFolder_GetTypeInfoCount(This,pctinfo)	\
    ( (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo) ) 

#define IEuFolder_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    ( (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo) ) 

#define IEuFolder_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    ( (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId) ) 

#define IEuFolder_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    ( (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr) ) 


#define IEuFolder_get_bCanContainMessages(This,pVal)	\
    ( (This)->lpVtbl -> get_bCanContainMessages(This,pVal) ) 

#define IEuFolder_get_bCanContainSubFolders(This,pVal)	\
    ( (This)->lpVtbl -> get_bCanContainSubFolders(This,pVal) ) 

#define IEuFolder_get_bContainsUnreadMessages(This,pVal)	\
    ( (This)->lpVtbl -> get_bContainsUnreadMessages(This,pVal) ) 

#define IEuFolder_get_bIsImapFolder(This,pVal)	\
    ( (This)->lpVtbl -> get_bIsImapFolder(This,pVal) ) 

#define IEuFolder_get_Level(This,pVal)	\
    ( (This)->lpVtbl -> get_Level(This,pVal) ) 

#define IEuFolder_get_Folders(This,pVal)	\
    ( (This)->lpVtbl -> get_Folders(This,pVal) ) 

#define IEuFolder_get_FullName(This,pVal)	\
    ( (This)->lpVtbl -> get_FullName(This,pVal) ) 

#define IEuFolder_get_ID(This,pVal)	\
    ( (This)->lpVtbl -> get_ID(This,pVal) ) 

#define IEuFolder_get_Index(This,pVal)	\
    ( (This)->lpVtbl -> get_Index(This,pVal) ) 

#define IEuFolder_get_Messages(This,pVal)	\
    ( (This)->lpVtbl -> get_Messages(This,pVal) ) 

#define IEuFolder_get_Name(This,pVal)	\
    ( (This)->lpVtbl -> get_Name(This,pVal) ) 

#define IEuFolder_get_Path(This,pVal)	\
    ( (This)->lpVtbl -> get_Path(This,pVal) ) 

#define IEuFolder_get_RefCount(This,pVal)	\
    ( (This)->lpVtbl -> get_RefCount(This,pVal) ) 

#define IEuFolder_Move(This,NewParentFolder)	\
    ( (This)->lpVtbl -> Move(This,NewParentFolder) ) 

#define IEuFolder_Open(This)	\
    ( (This)->lpVtbl -> Open(This) ) 

#define IEuFolder_Resynchronize(This)	\
    ( (This)->lpVtbl -> Resynchronize(This) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __IEuFolder_INTERFACE_DEFINED__ */


#ifndef __IEuFolders_INTERFACE_DEFINED__
#define __IEuFolders_INTERFACE_DEFINED__

/* interface IEuFolders */
/* [unique][hidden][oleautomation][helpstring][dual][uuid][object] */ 


EXTERN_C const IID IID_IEuFolders;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("EDA10015-AAAA-11d0-B3C5-00805F8AA4FB")
    IEuFolders : public IDispatch
    {
    public:
        virtual /* [id][propget] */ HRESULT STDMETHODCALLTYPE get_Item( 
            /* [in] */ long Index,
            /* [retval][out] */ VARIANT *ppFolder) = 0;
        
        virtual /* [restricted][id][propget] */ HRESULT STDMETHODCALLTYPE get__NewEnum( 
            /* [retval][out] */ IUnknown **ppEnum) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Count( 
            /* [retval][out] */ long *pVal) = 0;
        
        virtual /* [hidden][helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_RefCount( 
            /* [retval][out] */ long *pVal) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE Add( 
            BSTR Name,
            BOOL bCanContainMessages) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE RemoveByID( 
            long ID) = 0;
        
    };
    
    
#else 	/* C style interface */

    typedef struct IEuFoldersVtbl
    {
        BEGIN_INTERFACE
        
        DECLSPEC_XFGVIRT(IUnknown, QueryInterface)
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IEuFolders * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            _COM_Outptr_  void **ppvObject);
        
        DECLSPEC_XFGVIRT(IUnknown, AddRef)
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IEuFolders * This);
        
        DECLSPEC_XFGVIRT(IUnknown, Release)
        ULONG ( STDMETHODCALLTYPE *Release )( 
            IEuFolders * This);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfoCount)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            IEuFolders * This,
            /* [out] */ UINT *pctinfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfo)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            IEuFolders * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetIDsOfNames)
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            IEuFolders * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [range][in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        DECLSPEC_XFGVIRT(IDispatch, Invoke)
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            IEuFolders * This,
            /* [annotation][in] */ 
            _In_  DISPID dispIdMember,
            /* [annotation][in] */ 
            _In_  REFIID riid,
            /* [annotation][in] */ 
            _In_  LCID lcid,
            /* [annotation][in] */ 
            _In_  WORD wFlags,
            /* [annotation][out][in] */ 
            _In_  DISPPARAMS *pDispParams,
            /* [annotation][out] */ 
            _Out_opt_  VARIANT *pVarResult,
            /* [annotation][out] */ 
            _Out_opt_  EXCEPINFO *pExcepInfo,
            /* [annotation][out] */ 
            _Out_opt_  UINT *puArgErr);
        
        DECLSPEC_XFGVIRT(IEuFolders, get_Item)
        /* [id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Item )( 
            IEuFolders * This,
            /* [in] */ long Index,
            /* [retval][out] */ VARIANT *ppFolder);
        
        DECLSPEC_XFGVIRT(IEuFolders, get__NewEnum)
        /* [restricted][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get__NewEnum )( 
            IEuFolders * This,
            /* [retval][out] */ IUnknown **ppEnum);
        
        DECLSPEC_XFGVIRT(IEuFolders, get_Count)
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_Count )( 
            IEuFolders * This,
            /* [retval][out] */ long *pVal);
        
        DECLSPEC_XFGVIRT(IEuFolders, get_RefCount)
        /* [hidden][helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE *get_RefCount )( 
            IEuFolders * This,
            /* [retval][out] */ long *pVal);
        
        DECLSPEC_XFGVIRT(IEuFolders, Add)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *Add )( 
            IEuFolders * This,
            BSTR Name,
            BOOL bCanContainMessages);
        
        DECLSPEC_XFGVIRT(IEuFolders, RemoveByID)
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE *RemoveByID )( 
            IEuFolders * This,
            long ID);
        
        END_INTERFACE
    } IEuFoldersVtbl;

    interface IEuFolders
    {
        CONST_VTBL struct IEuFoldersVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IEuFolders_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IEuFolders_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define IEuFolders_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define IEuFolders_GetTypeInfoCount(This,pctinfo)	\
    ( (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo) ) 

#define IEuFolders_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    ( (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo) ) 

#define IEuFolders_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    ( (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId) ) 

#define IEuFolders_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    ( (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr) ) 


#define IEuFolders_get_Item(This,Index,ppFolder)	\
    ( (This)->lpVtbl -> get_Item(This,Index,ppFolder) ) 

#define IEuFolders_get__NewEnum(This,ppEnum)	\
    ( (This)->lpVtbl -> get__NewEnum(This,ppEnum) ) 

#define IEuFolders_get_Count(This,pVal)	\
    ( (This)->lpVtbl -> get_Count(This,pVal) ) 

#define IEuFolders_get_RefCount(This,pVal)	\
    ( (This)->lpVtbl -> get_RefCount(This,pVal) ) 

#define IEuFolders_Add(This,Name,bCanContainMessages)	\
    ( (This)->lpVtbl -> Add(This,Name,bCanContainMessages) ) 

#define IEuFolders_RemoveByID(This,ID)	\
    ( (This)->lpVtbl -> RemoveByID(This,ID) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __IEuFolders_INTERFACE_DEFINED__ */



#ifndef __EudoraLib_LIBRARY_DEFINED__
#define __EudoraLib_LIBRARY_DEFINED__

/* library EudoraLib */
/* [helpstring][version][uuid] */ 


EXTERN_C const IID LIBID_EudoraLib;

#ifndef __IEuApplicationEvents_DISPINTERFACE_DEFINED__
#define __IEuApplicationEvents_DISPINTERFACE_DEFINED__

/* dispinterface IEuApplicationEvents */
/* [helpstring][uuid] */ 


EXTERN_C const IID DIID_IEuApplicationEvents;

#if defined(__cplusplus) && !defined(CINTERFACE)

    MIDL_INTERFACE("EDA30001-AAAA-11d0-B3C5-00805F8AA4FB")
    IEuApplicationEvents : public IDispatch
    {
    };
    
#else 	/* C style interface */

    typedef struct IEuApplicationEventsVtbl
    {
        BEGIN_INTERFACE
        
        DECLSPEC_XFGVIRT(IUnknown, QueryInterface)
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IEuApplicationEvents * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            _COM_Outptr_  void **ppvObject);
        
        DECLSPEC_XFGVIRT(IUnknown, AddRef)
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IEuApplicationEvents * This);
        
        DECLSPEC_XFGVIRT(IUnknown, Release)
        ULONG ( STDMETHODCALLTYPE *Release )( 
            IEuApplicationEvents * This);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfoCount)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            IEuApplicationEvents * This,
            /* [out] */ UINT *pctinfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetTypeInfo)
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            IEuApplicationEvents * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        DECLSPEC_XFGVIRT(IDispatch, GetIDsOfNames)
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            IEuApplicationEvents * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [range][in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        DECLSPEC_XFGVIRT(IDispatch, Invoke)
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            IEuApplicationEvents * This,
            /* [annotation][in] */ 
            _In_  DISPID dispIdMember,
            /* [annotation][in] */ 
            _In_  REFIID riid,
            /* [annotation][in] */ 
            _In_  LCID lcid,
            /* [annotation][in] */ 
            _In_  WORD wFlags,
            /* [annotation][out][in] */ 
            _In_  DISPPARAMS *pDispParams,
            /* [annotation][out] */ 
            _Out_opt_  VARIANT *pVarResult,
            /* [annotation][out] */ 
            _Out_opt_  EXCEPINFO *pExcepInfo,
            /* [annotation][out] */ 
            _Out_opt_  UINT *puArgErr);
        
        END_INTERFACE
    } IEuApplicationEventsVtbl;

    interface IEuApplicationEvents
    {
        CONST_VTBL struct IEuApplicationEventsVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IEuApplicationEvents_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IEuApplicationEvents_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define IEuApplicationEvents_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define IEuApplicationEvents_GetTypeInfoCount(This,pctinfo)	\
    ( (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo) ) 

#define IEuApplicationEvents_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    ( (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo) ) 

#define IEuApplicationEvents_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    ( (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId) ) 

#define IEuApplicationEvents_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    ( (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */


#endif 	/* __IEuApplicationEvents_DISPINTERFACE_DEFINED__ */


EXTERN_C const CLSID CLSID_EuApplication;

#ifdef __cplusplus

class DECLSPEC_UUID("EDA20001-AAAA-11d0-B3C5-00805F8AA4FB")
EuApplication;
#endif

EXTERN_C const CLSID CLSID_EuMessage;

#ifdef __cplusplus

class DECLSPEC_UUID("EDA20014-AAAA-11d0-B3C5-00805F8AA4FB")
EuMessage;
#endif

EXTERN_C const CLSID CLSID_EuMessages;

#ifdef __cplusplus

class DECLSPEC_UUID("EDA20004-AAAA-11d0-B3C5-00805F8AA4FB")
EuMessages;
#endif

EXTERN_C const CLSID CLSID_EuFolder;

#ifdef __cplusplus

class DECLSPEC_UUID("EDA20005-AAAA-11d0-B3C5-00805F8AA4FB")
EuFolder;
#endif

EXTERN_C const CLSID CLSID_EuFolders;

#ifdef __cplusplus

class DECLSPEC_UUID("EDA20015-AAAA-11d0-B3C5-00805F8AA4FB")
EuFolders;
#endif
#endif /* __EudoraLib_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

unsigned long             __RPC_USER  BSTR_UserSize(     unsigned long *, unsigned long            , BSTR * ); 
unsigned char * __RPC_USER  BSTR_UserMarshal(  unsigned long *, unsigned char *, BSTR * ); 
unsigned char * __RPC_USER  BSTR_UserUnmarshal(unsigned long *, unsigned char *, BSTR * ); 
void                      __RPC_USER  BSTR_UserFree(     unsigned long *, BSTR * ); 

unsigned long             __RPC_USER  VARIANT_UserSize(     unsigned long *, unsigned long            , VARIANT * ); 
unsigned char * __RPC_USER  VARIANT_UserMarshal(  unsigned long *, unsigned char *, VARIANT * ); 
unsigned char * __RPC_USER  VARIANT_UserUnmarshal(unsigned long *, unsigned char *, VARIANT * ); 
void                      __RPC_USER  VARIANT_UserFree(     unsigned long *, VARIANT * ); 

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif


