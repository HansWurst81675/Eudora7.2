 /* ==================================================================================

    Eudora Extended Message Services API SDK Windows
    This SDK supports EMSAPI version 6
    Copyright 1995-2003 QUALCOMM Inc.
 Copyright (c) 2016, Computer History Museum 
All rights reserved. 
Redistribution and use in source and binary forms, with or without modification, are permitted (subject to 
the limitations in the disclaimer below) provided that the following conditions are met: 
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. 
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following 
   disclaimer in the documentation and/or other materials provided with the distribution. 
 * Neither the name of Computer History Museum nor the names of its contributors may be used to endorse or promote products 
   derived from this software without specific prior written permission. 
NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE 
COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH 
DAMAGE. 


    Send comments and questions to <eudora-emsapi@qualcomm.com>

    Filname: emsapi-win.h

    Note: this file is generated automatically by a script and must be
    kept in synch with other translation API definitions, so it should
    probably never be edited manually.

/* =================================================================================== */

#ifndef __EMS_WIN__
#define __EMS_WIN__

/* ===== CONSTANTS AND RETURN VALUES ================================================= */

/* ----- Translator return codes --- store as a long --------------------------------- */
#define EMSR_OK                        (0L)        /* The translation operation succeeded */
#define EMSR_UNKNOWN_FAIL              (1L)        /* Failed for unspecified reason */
#define EMSR_CANT_TRANS                (2L)        /* Don't know how to translate this */
#define EMSR_INVALID_TRANS             (3L)        /* The translator ID given was invalid */
#define EMSR_NO_ENTRY                  (4L)        /* The value requested doesn't exist */
#define EMSR_NO_INPUT_FILE             (5L)        /* Couldn't find input file */
#define EMSR_CANT_CREATE               (6L)        /* Couldn't create the output file */
#define EMSR_TRANS_FAILED              (7L)        /* The translation failed. */
#define EMSR_INVALID                   (8L)        /* Invalid argument(s) given */
#define EMSR_NOT_NOW                   (9L)        /* Translation can be done not in current context */
#define EMSR_NOW                      (10L)        /* Indicates translation can be performed right away */
#define EMSR_ABORTED                  (11L)        /* Translation was aborted by user */
#define EMSR_DATA_UNCHANGED           (12L)        /* Trans OK, data was not changed */
#define	EMSR_NOT_IN_THIS_MODE		  (14L)		   /* Can't perform this operation in this mode (paid, ad, free) */


/* ----- Translator types --- store as a long ---------------------------------------- */
#define EMST_NO_TYPE                   (-1L)
#define EMST_LANGUAGE                  (0x10L)
#define EMST_TEXT_FORMAT               (0x20L)
#define EMST_GRAPHIC_FORMAT            (0x30L)
#define EMST_COMPRESSION               (0x40L)
#define EMST_COALESCED                 (0x50L)
#define EMST_SIGNATURE                 (0x60L)
#define EMST_PREPROCESS                (0x70L)
#define EMST_CERT_MANAGEMENT           (0x80L)


/* ----- Translator info flags and contexts --- store as a long ---------------------- */
/* Used both as bit flags and as constants */
#define EMSF_ON_ARRIVAL                (0x0001L)   /* Call on message arrival */
#define EMSF_ON_DISPLAY                (0x0002L)   /* Call when user views message */
#define EMSF_ON_REQUEST                (0x0004L)   /* Call when selected from menu */
#define EMSF_Q4_COMPLETION             (0x0008L)   /* Queue and call on complete composition of a message */
#define EMSF_Q4_TRANSMISSION           (0x0010L)   /* Queue and call on transmission of a message */
#define EMSF_JUNK_MAIL                 (0x0020L)   /* Call for scoring or marking a message as junk or not (NEW in Eudora/EMSAPI 6.0) */
#define EMSF_WHOLE_MESSAGE             (0x0200L)   /* Works on the whole message even if it has sub-parts. (e.g. signature) */
#define EMSF_REQUIRES_MIME             (0x0400L)   /* Items presented for translation should be MIME entities with canonical
                                                      end of line representation, proper transfer encoding and headers */
#define EMSF_GENERATES_MIME            (0x0800L)   /* Data produced will be MIME format */
#define EMSF_ALL_HEADERS               (0x1000L)   /* All headers in & out of trans when MIME format is used */
#define EMSF_BASIC_HEADERS             (0x2000L)   /* Just the basic to, from, subject, cc, bcc headers */
#define EMSF_DEFAULT_Q_ON              (0x4000L)   /* Causes queued translation to be on for a new message by default */
#define EMSF_TOOLBAR_PRESENCE          (0x8000L)   /* Appear on the Toolbar */
#define EMSF_ALL_TEXT                 (0x10000L)   /* ON_REQUEST WANTS WHOLE MESSAGE */
#define EMSF_PREFER_PLAIN            (0x100000L)   /* EMSF_JUNK_MAIL prefers plain text (NEW in Eudora/EMSAPI 6.0) - more efficient when off */
#define EMSF_SOLELY_HEADERS          (0x200000L)   /* EMSF_JUNK_MAIL operates solely on headers (NEW in Eudora/EMSAPI 6.0) */
#define EMSF_BODY_OPTIONAL           (0x400000L)   /* EMSF_JUNK_MAIL can operate on either just headers or the full message  (NEW in Eudora/EMSAPI 6.0) */
/* all other flag bits in the long are RESERVED and may not be used */


/* ----- The version of the API defined by this include file ------------------------- */
#define EMS_VERSION                    (6)         /* Used in plugin init */
#define EMS_COMPONENT                  'EuTL'      /* Macintosh component type */
#define EMS_PB_VERSION                 (3)


/* ----- Translator and translator type specific return codes ------------------------ */
#define EMSC_SIGOK                     (1L)        /* A signature verification succeeded */
#define EMSC_SIGBAD                    (2L)        /* A signature verification failed */
#define EMSC_SIGUNKNOWN                (3L)        /* Result of verification unknown */

/* ----- NEW in Eudora/EMSAPI 6.0 - IDLE Events  ------------------------------------- */
/* Note that it is possible to have both EMSIDLE_UI_ALLOWED and EMSIDLE_QUICK set, in that
 * case the plug-in should only do a UI operation if it's absolutely essential (i.e., errors only).
 * If EMSIDLE_UI_ALLOWED is NOT set, then using the progress
 */

/* ----- NEW in Eudora/EMSAPI 6.0 - Values for ems_idle flags ------------------------ */
#define EMSFIDLE_UI_ALLOWED            (0x0001L)   /* Interactions with user are allowed */
#define EMSFIDLE_QUICK                 (0x0002L)   /* Now is NOT the time to do something lengthy */
#define EMSFIDLE_OFFLINE               (0x0004L)   /* Eudora is in "offline" mode */
#define EMSFIDLE_PRE_SEND              (0x0008L)   /* Eudora is about to send mail */
#define EMSFIDLE_TRANSFERRING          (0x0010L)   /* Currently transferring mail */


/* ----- NEW in Eudora/EMSAPI 6.0 - Values for emsGetMailBox flags ------------------- */
#define EMSFGETMBOX_ALLOW_NEW          (0x0001L)   /* Allow creation of new mailboxes */
#define EMSFGETMBOX_ALLOW_OTHER        (0x0002L)   /* Allow selection of "other" mailboxes */
#define EMSFGETMBOX_DISALLOW_NON_LOCAL (0x0004L)   /* Disallow selection of non-local (e.g. IMAP) mailboxes */


/* ----- NEW in Eudora/EMSAPI 6.0 - Values for emsJunkInfo context flags ------------- */
#define EMSFJUNK_SCORE_ON_ARRIVAL      (0x0001L)   /* Score incoming message as it arrives */
#define EMSFJUNK_RESCORE               (0X0002L)   /* Rescore message (by user or automatically - see EMSFJUNK_USER_INITIATED) */
#define EMSFJUNK_MARK_IS_JUNK          (0x0004L)   /* Message is being marked as JUNK (by user or filter - see EMSFJUNK_USER_INITIATED) */
#define EMSFJUNK_MARK_NOT_JUNK         (0x0008L)   /* Message is being marked as NOT junk */
#define EMSFJUNK_USER_INITIATED        (0x0010L)   /* User (not filter or any other automatic mechanism) initiated action */


/* ========== FORWARD TYPDEFS ======================================================== */
typedef struct emsProgressDataS *emsProgressDataP;
typedef struct emsGetDirectoryDataS *emsGetDirectoryDataP;
typedef struct emsRegenerateDataS *emsRegenerateDataP; 
typedef struct emsGetMailBoxDataS *emsGetMailBoxDataP;
typedef struct emsGetPersonalityDataS *emsGetPersonalityDataP;
typedef struct emsGetPersonalityInfoDataS *emsGetPersonalityInfoDataP;
typedef struct emsCreateMailBoxDataS *emsCreateMailBoxDataP;
typedef struct emsCreateMessageDataS *emsCreateMessageDataP;
typedef struct emsIsInAddressBookDataS *emsIsInAddressBookDataP;


/* ===== NEW in Eudora/EMSAPI 6.0 = CALL BACK FUNCTIONS FROM EUDORA ACROSS THE API === */
typedef short            (*emsPrivateFunction)();                                             /* Private function - not to be used */
typedef short            (*emsProgress)(emsProgressDataP);                                    /* The progress function  */
typedef short            (*emsAllocate)(void **, size_t);                                     /* The Eudora allocation function  */
typedef short            (*emsGetMailBox)(emsAllocate, emsGetMailBoxDataP);                   /* Displays dialog with list of mailboxes and returns mailbox user chooses */
typedef short            (*emsGetPersonality)(emsAllocate, emsGetPersonalityDataP);           /* Displays dialog with list of personalities and returns personality user chooses */
typedef short            (*emsRegenerate)(emsRegenerateDataP);                                /* Causes Eudora to reload either plugin filters or plugin nicknames */
typedef short            (*emsGetDirectory)(emsGetDirectoryDataP);                            /* Retrieves location of specified Eudora folder */
typedef short            (*emsGetPersonalityInfo)(emsAllocate, emsGetPersonalityInfoDataP);   /* Retrieves email address for specified personality */
typedef short            (*emsCreateMailBox)(emsAllocate, emsCreateMailBoxDataP);             /* Creates mailbox */
typedef short            (*emsCreateMessage)(emsCreateMessageDataP);                          /* Creates email message */
typedef short            (*emsIsInAddressBook)(emsIsInAddressBookDataP);                      /* Checks to see if the indicated address is in any Eudora address book */


/* ===== DATA STRUCTURES ============================================================= */
/* All strings on Windows are NULL terminated C strings */

/* ----- Progress Data --------------------------------------------------------------- */
typedef struct emsProgressDataS * emsProgressDataP;
typedef struct emsProgressDataS {
    long                     size;               /* Size of this data structure */
    long                     value;              /* Range of Progress, percent complete */
    LPSTR                    message;            /* Progress Message */
} emsProgressData;

/* ----- NEW in Eudora/EMSAPI 6.0 - Mailbox Data ------------------------------------- */
typedef struct emsMBoxS *emsMBoxP;
typedef struct emsMBoxS {
    long                     size;               /* Size of this data structure */
    LPSTR                    name;
    long                     hash;
} emsMBox;

/* ----- NEW in Eudora/EMSAPI 6.0 - GetMailBoxFunction Data -------------------------- */
typedef struct emsGetMailBoxDataS *emsGetMailBoxDataP;
typedef struct emsGetMailBoxDataS{
    long                     size;               /* IN: Size of this data structure */
    long                     flags;              /* IN: see flags above */
    LPSTR                    prompt;             /* IN: Prompt for user */
    emsMBoxP                 mailbox;            /* OUT: the chosen mailbox */
} emsGetMailBoxData;

/* ----- User Address ---------------------------------------------------------------- */
typedef struct emsAddressS *emsAddressP; 
typedef struct emsAddressS {
    long                     size;               /* Size of this data structure */
    LPSTR                    address;            /* Actual email address */
    LPSTR                    realname;           /* Real name portion of email address */
    emsAddressP              next;               /* Linked list of addresses */
} emsAddress;

/* ----- NEW in Eudora/EMSAPI 6.0 - GetPersonalityData ------------------------------- */
typedef struct emsGetPersonalityDataS *emsGetPersonalityDataP;
typedef struct emsGetPersonalityDataS{
    long                     size;               /* IN: Size of this data structure */
    LPSTR                    prompt;             /* IN: Prompt for user, Set to NULL for standard */
    BOOL                     defaultPers;        /* IN: set to 1 for defause, otherwise selection dialog comes up */
    long                     persCount;          /* OUT: Number of personalities */
    emsAddressP              personality;        /* OUT: the chosen personality */
    LPSTR                    personalityName;    /* OUT: the text name of the chosen personality */
} emsGetPersonalityData;

/* ----- NEW in Eudora/EMSAPI 6.0 - GetPersonalityInfo ------------------------------- */
typedef struct emsGetPersonalityInfoDataS *emsGetPersonalityInfoDataP;
typedef struct emsGetPersonalityInfoDataS{
    long                     size;               /* IN: Size of this data structure */
    LPSTR                    personalityName;    /* IN: name of Personality */
    emsAddressP              personality;        /* OUT: the chosen personality */
} emsGetPersonalityInfoData;

/* ----- NEW in Eudora/EMSAPI 6.0 - CreateMailBox Data ------------------------------- */
typedef struct emsCreateMailBoxDataS *emsCreateMailBoxDataP;
typedef struct emsCreateMailBoxDataS {
    long                     size;               /* IN: Size of this data structure */
    emsMBoxP                 parentFolder;       /* IN: relative path off of EMS_MailDir to the parent folder, or NULL for default location */
    LPSTR                    name;               /* IN: name for the new mailbox or folder */
    BOOL                     createFolder;       /* IN: set to 1 to create a folder, 0 to create a mailbox */
    emsMBoxP                 mailboxOrFolder;    /* OUT: the created mailbox or folder */
} emsCreateMailBoxData;

/* ----- NEW in Eudora/EMSAPI 6.0 - CreateMessage Data ------------------------------- */
typedef struct emsCreateMessageDataS *emsCreateMessageDataP;
typedef struct emsCreateMessageDataS {
    long                     size;               /* IN: Size of this data structure */
    LPSTR                    file;               /* IN: Path to file with which to create new message */
    BOOL                     shouldDisplay;      /* IN: set to 1 to display message for editing, 0 to immediately queue */
    LPSTR                    personality;        /* IN: Personality that message should be from */
} emsCreateMessageData;

typedef enum { emsAddressNotChecked, emsAddressNotInAB, emsAddressIsInAB } 
AddressInABStatus;

/* ----- NEW in Eudora/EMSAPI 6.0 - InInAddressBook Data ----------------------------- */
typedef struct emsIsInAddressBookDataS *emsIsInAddressBookDataP;
typedef struct emsIsInAddressBookDataS {
    long                     size;               /* IN: Size of this data structure */
    emsAddressP              address;            /* IN: Address to check */
    AddressInABStatus        addressStatus;      /* OUT: Indicates whether or not the address is known */
} emsIsInAddressBookData;

/* ----- NEW in Eudora/EMSAPI 6.0 - Type of Updated Files ---------------------------- */
typedef enum { emsRegenerateFilters, emsRegenerateNicknames} 
RegenerateType;

/* ----- NEW in Eudora/EMSAPI 6.0 - Regenerate Data ---------------------------------- */
typedef struct emsRegenerateDataS *emsRegenerateDataP; 
typedef struct emsRegenerateDataS {
    long            size;                        /* IN: Size of this data structure */
    RegenerateType  which;                       /* IN: What type of file this is */
    char            path[_MAX_PATH + 1];         /* IN: The File Path */
} emsRegenerateData;


/* ----- GetDirectory ---------------------------------------------------------------- */
typedef enum { 
    EMS_EudoraDir,           /* Eudora folder, contains all otherfolders */
    EMS_AttachmentsDir,      /* Attachments folder */
    EMS_PluginFiltersDir,    /* Filters folder for plug-ins */
    EMS_PluginNicknamesDir,  /* Nicknames folder for plug-ins */
    EMS_ConfigDir,           /* Folder for plug-ins' preferences */
    EMS_MailDir,             /* Folder containing mailboxes */
    EMS_NicknamesDir,        /* Eudora nicknames folder */
    EMS_SignaturesDir,       /* Signatures folder */
    EMS_SpoolDir,            /* Spool folder */
    EMS_StationeryDir        /* Stationery folder */
} DirectoryEnum;

typedef struct emsGetDirectoryDataS *emsGetDirectoryDataP;
typedef struct emsGetDirectoryDataS{
    long                     size;                         /* IN: Size of this data structure */
    DirectoryEnum            which;                        /* IN: Which directory? */
    char                     directory[_MAX_PATH + 1];     /* OUT: Path for directory */
} emsGetDirectoryData;

/* ----- MIME Params ----------------------------------------------------------------- */
typedef struct emsMIMEparamS *emsMIMEparamP;
typedef struct emsMIMEparamS {
    long                     size;
    LPSTR                    name;               /* Mime parameter name (e.g., charset) */
    LPSTR                    value;              /* param value (e.g. us-ascii) */
    emsMIMEparamP            next;               /* Pointer to next parameter in linked list of parameters */
} emsMIMEparam;

/* ----- MIME Info ------------------------------------------------------------------- */
typedef struct emsMIMEtypeS *emsMIMEtypeP; 
typedef struct emsMIMEtypeS {
    long                     size;
    LPSTR                    version;            /* The MIME-Version header */
    LPSTR                    type;               /* Top-level MIME type */      
    LPSTR                    subType;            /* MIME sub-type */
    emsMIMEparamP            params;             /* MIME parameter list */
    LPSTR                    contentDisp;        /* Content-Disposition */
    emsMIMEparamP            contentParams;      /* Pointer to first parameter in linked list of parameters */
} emsMIMEtype;

/* ----- Header Data ----------------------------------------------------------------- */
typedef struct emsHeaderDataS *emsHeaderDataP; 
typedef struct emsHeaderDataS {
    long                     size;               /* Size of this data structure */
    emsAddressP              to;                 /* To Header */
    emsAddressP              from;               /* From Header */
    LPSTR                    subject;            /* Subject Header */
    emsAddressP              cc;                 /* cc Header */
    emsAddressP              bcc;                /* bcc Header */
    LPSTR                    rawHeaders;         /* The 822 headers */
} emsHeaderData;

/* ----- NEW in Eudora/EMSAPI 6.0 - structure to hold the callback functions --------- */
/* Each callback is called with a pointer to a parameter block */
typedef struct emsCallBackS *emsCallBacksP;
typedef struct emsCallBackS {
    long                               size;                /* Size of this data structure */
    emsProgress                        EMSProgressCB;
    emsGetMailBox                      EMSGetMailBoxCB;
    emsPrivateFunction                 EMSPrivateFunctionDontCall1;
    emsGetPersonality                  EMSGetPersonalityCB;
    emsRegenerate                      EMSRegenerateCB;
    emsGetDirectory                    EMSGetDirectoryCB;
    emsPrivateFunction                 EMSPrivateFunctionDontCall2;
    emsGetPersonalityInfo              EMSGetPersonalityInfoCB;
    emsPrivateFunction                 EMSPrivateFunctionDontCall3;
    emsPrivateFunction                 EMSPrivateFunctionDontCall4;
    emsPrivateFunction                 EMSPrivateFunctionDontCall5;
    emsCreateMailBox                   EMSCreateMailBoxCB;
    emsCreateMessage                   EMSCreateMessageCB;
    emsIsInAddressBook                 EMSIsInAddressBook;
} emsCallBack;

/* ----- How Eudora is configured ---------------------------------------------------- */
typedef struct emsMailConfigS *emsMailConfigP; 
typedef struct emsMailConfigS {
    long                     size;               /* Size of this data structure */
    HWND                     * eudoraWnd;        /* Eudora's main window */
    LPSTR                    configDir;          /* Optional directory for config file */
    emsAddress               userAddr;           /* Users full name from Eudora config */
    emsCallBacksP            callBacks;          /* NEW in Eudora/EMSAPI 6.0: Pointer to callback structure */
    short                    eudAPIMinorVersion; /* NEW in Eudora/EMSAPI 6.0: Minor API version - used when calls are being added during beta or
                                                    when an EMSAPI change is done for a minor version release */
} emsMailConfig;

/* ----- Plugin Info ----------------------------------------------------------------- */
typedef struct emsPluginInfoS *emsPluginInfoP; 
typedef struct emsPluginInfoS {
    long                     size;               /* Size of this data structure */
    long                     numTrans;           /* Place to return num of translators */
    long                     numAttachers;       /* Place to return num of attach hooks */
    long                     numSpecials;        /* Place to return num of special hooks */
    LPSTR                    desc;               /* Return for string description of plugin */
    long                     id;                 /* Place to return unique plugin id */
    HICON                    * icon;             /* Return for plugin icon data */
    long                     idleTimeFreq;       /* NEW in Eudora/EMSAPI 6.0: Return 0 for no idle time, otherwise initial idle frequency in milliseconds */
} emsPluginInfo;

/* ----- Translator Info ------------------------------------------------------------- */
typedef struct emsTranslatorS *emsTranslatorP; 
typedef struct emsTranslatorS {
    long                     size;               /* Size of this data structure */
    long                     id;                 /* ID of translator to get info for */
    long                     type;               /* translator type, e.g., EMST_xxx */
    ULONG                    flags;              /* translator flags */
    LPSTR                    desc;               /* translator string description */
    HICON                    * icon;             /* Return for plugin icon data */
    LPSTR                    properties;         /* Properties for queued translations */
} emsTranslator;

/* ----- Menu Item Info -------------------------------------------------------------- */
typedef struct emsMenuS *emsMenuP; 
typedef struct emsMenuS {
    long                     size;               /* Size of this data structure */
    long                     id;                 /* ID of translator to get info for */
    LPSTR                    desc;               /* translator string description */
    HICON                    * icon;             /* Return for plugin icon data */
    long                     flags;              /* any special flags*/
} emsMenu;

/* ----- Translation Data ------------------------------------------------------------ */
typedef struct emsDataFileS *emsDataFileP; 
typedef struct emsDataFileS {
    long                     size;               /* Size of this data structure */
    long                     context;
    emsMIMEtypeP             info;               /* MIME type of data to check */
    emsHeaderDataP           header;             /* EMSF_BASIC_HEADERS & EMSF_ALL_HEADERS determine contents */
    LPSTR                    fileName;           /* The input file name */
} emsDataFile;

/* ----- Resulting Status Data ------------------------------------------------------- */
typedef struct emsResultStatusS *emsResultStatusP; 
typedef struct emsResultStatusS {
    long                     size;               /* Size of this data structure */
    LPSTR                    desc;               /* Returned string for display with the result */
    LPSTR                    error;              /* Place to return string with error message */
    long                     code;               /* Return for translator-specific result code */
} emsResultStatus;

/* ----- Idle Data ------------------------------------------------------------------- */
typedef struct emsIdleDataS *emsIdleDataP; 
typedef struct emsIdleDataS {
    long                     size;               /* Size of this data structure */
    long                     flags;              /* Idle Flags */
    long                     idleTimeFreq;       /* In/Out: current->new request idle */
    emsProgress              Progress;           /* Progress Func */
} emsIdleData;

/* ----- NEW in Eudora/EMSAPI 6.0 - Junk Info ---------------------------------------- */
typedef struct emsJunkInfoS *emsJunkInfoP;
typedef struct emsJunkInfoS {
    long                     size;               /* Size of this data structure */
    long                     context;            /* Junk context flags see EMSJUNK #defines */
    long                     pluginID;           /* For ems_user_mark_junk ID of plugin that assigned previous junk score, or 0 if user marked  */
} emsJunkInfo;

/* ----- NEW in Eudora/EMSAPI 6.0 - Message Information for Junk Scoring ------------- */
typedef struct emsMessageInfoS *emsMessageInfoP;
typedef struct emsMessageInfoS {
    long                     size;               /* Size of this data structure */
    long                     context;            /* Reserved for future use */
    unsigned long            messageID;          /* Uniquely identifies message for months - generally ok to persist */
    AddressInABStatus        fromAddressStatus;  /* Indicates whether from address is known */
    emsHeaderDataP           header;             /* EMSF_BASIC_HEADERS & EMSF_ALL_HEADERS determine contents */
    emsMIMEtypeP             textType;           /* MIME type of text to check */
    long                     textSize;           /* Size of text of message (if provided) */
    char *                   text;               /* Pointer to text of message if provided in format indicated by textType or NULL */
} emsMessageInfo;

/* ----- NEW in Eudora/EMSAPI 6.0 - Junk Score --------------------------------------- */
typedef struct emsJunkScoreS *emsJunkScoreP;
typedef struct emsJunkScoreS {
    long                     size;               /* Size of this data structure */
    char                     score;              /* Junk score between 0 and 100 with a special value of -1.
                                                    -1 => white list - absolutely NOT junk - use sparingly or not at all;
                                                     0 => NOT junk; 100 => absolutely junk */
} emsJunkScore;

/* ----- NEW - Type of Mode Event Notifications --------------- */
typedef enum { EMS_GetDowngradeInfo, EMS_ModeChanged } 
ModeEventEnum;
typedef enum { EMS_ModeFree, EMS_ModeSponsored, EMS_ModePaid, EMS_ModeCustom = 250 } 
ModeTypeEnum;

/* ----- NEW - EudoraModeNotification Data --------------------- */
typedef struct emsEudoraModeNotificationDataS *emsEudoraModeNotificationDataP;
typedef struct emsEudoraModeNotificationDataS {
    long                     size;                         /* IN: Size of this data structure */
    ModeEventEnum            modeEvent;                    /* IN: Notification of change or request for downgrade text */
    ModeTypeEnum             isFullFeatureSet;             /* IN: Is Eudora is now running with full features (i.e. not light)? */
    ModeTypeEnum             needsFullFeatureSet;          /* OUT: Does the plugin need full feature set? */
    BOOL                     downgradeWasBeingUsed;        /* OUT: Return whether or not plugin was being used */
	short					 productCode;				   /* IN:  App product code */
	unsigned long			 modeFlags;					   /* OUT: Modes that we will function in */
} emsEudoraModeNotificationData;


/* ===== FUNCTION PROTOTYPES ========================================================= */

/* ----- Get the API Version number this plugin implements --------------------------- */
extern "C" long WINAPI
ems_plugin_version(
    short                    * api_version      /* Place to return api version */
);

/* ----- Initialize plugin and get its basic info ------------------------------------ */
extern "C" long WINAPI
ems_plugin_init(
    void                     ** globals,         /* Out: Return for allocated instance structure */
    short                    eudAPIMajorVersion, /* In: The major API version eudora is using */
    emsMailConfigP           mailConfig,         /* In: Eudoras mail configuration */
    emsPluginInfoP           pluginInfo          /* Out: Return Plugin Information */
);

/* ----- Get details about a translator in a plugin ---------------------------------- */
extern "C" long WINAPI
ems_translator_info(
    void                     * globals,          /* In: Allocated instance structure returned in ems_plugin_init */
    emsTranslatorP           transInfo           /* In/Out: Return Translator Information */
);

/* ----- Check and see if a translation can be performed ----------------------------- */
extern "C" long WINAPI
ems_can_translate(
    void                     * globals,          /* In: Allocated instance structure returned in ems_plugin_init */
    emsTranslatorP           trans,              /* In: Translator Info */
    emsDataFileP             inTransData,        /* In: What to translate */
    emsResultStatusP         transStatus         /* Out: Translations Status information */
);

/* ----- Actually perform a translation on a file ------------------------------------ */
extern "C" long WINAPI
ems_translate_file(
    void                     * globals,          /* In: Allocated instance structure returned in ems_plugin_init */
    emsTranslatorP           trans,              /* In: Translator Info */
    emsDataFileP             inFile,             /* In: What to translate */
    emsProgress              progress,           /* Func to report progress/check for abort */
    emsDataFileP             outFile,            /* Out: Result of the translation */
    emsResultStatusP         transStatus         /* Out: Translations Status information */
);

/* ----- End use of a plugin and clean up -------------------------------------------- */
extern "C" long WINAPI
ems_plugin_finish(
    void                     * globals           /* In: Allocated instance structure returned in ems_plugin_init */
);

/* ----- EMS plug-in allocate memory ------------------------------------------------- */
extern "C" short
ems_allocate(
    void                     ** mem,
    size_t                   size
);

/* ----- Free memory allocated by EMS plug-in ---------------------------------------- */
extern "C" long WINAPI
ems_free(
    void                     * mem               /* Memory to free */
);

/* ----- Call the plug-ins configuration Interface ----------------------------------- */
extern "C" long WINAPI
ems_plugin_config(
    void                     * globals,          /* In: Allocated instance structure returned in ems_plugin_init */
    emsMailConfigP           mailConfig          /* In: Eudora mail info */
);

/* ----- Manage properties for queued translations ----------------------------------- */
extern "C" long WINAPI
ems_queued_properties(
    void                     * globals,          /* In: Allocated instance structure returned in ems_plugin_init */
    emsTranslatorP           trans,              /* In/Out: The translator */
    long                     * selected          /* In/Out: State of this translator */
);

/* ----- Info about menu hook to attach/insert composed object ----------------------- */
extern "C" long WINAPI
ems_attacher_info(
    void                     * globals,          /* In: Allocated instance structure returned in ems_plugin_init */
    emsMenuP                 attachMenu          /* Out: The menu */
);

/* ----- Call an attacher hook to compose some special object ------------------------ */
extern "C" long WINAPI
ems_attacher_hook(
    void                     * globals,          /* In: Allocated instance structure returned in ems_plugin_init */
    emsMenuP                 attachMenu,         /* In: The menu */
    LPSTR                    attachDir,          /* In: Location to put attachments */
    long                     * numAttach,        /* Out: Number of files attached */
    emsDataFileP             ** attachFiles      /* Out: Name of files written */
);

/* ----- Info about special menu items hooks ----------------------------------------- */
extern "C" long WINAPI
ems_special_info(
    void                     * globals,          /* In: Allocated instance structure returned in ems_plugin_init */
    emsMenuP                 specialMenu         /* Out: The menu */
);

/* ----- Call a special menu item hook ----------------------------------------------- */
extern "C" long WINAPI
ems_special_hook(
    void                     * globals,          /* In: Allocated instance structure returned in ems_plugin_init */
    emsMenuP                 specialMenu         /* In: The menu */
);

/* ----- NEW in Eudora/EMSAPI 6.0 - idle function ------------------------------------ */
extern "C" long WINAPI
ems_idle(
    void                     * globals,          /* In: Allocated instance structure returned in ems_plugin_init */
    emsIdleDataP             idleData            /* In/Out: idle omfp */
);

/* ----- NEW in Eudora/EMSAPI 6.0 - called to score junk ----------------------------- */
extern "C" long WINAPI
ems_score_junk(
    void                     * globals,          /* In: Allocated instance structure returned in ems_plugin_init */
    emsTranslatorP           trans,              /* In: Translator Info */
    emsJunkInfoP             junkInfo,           /* In: Junk information */
    emsMessageInfoP          message,            /* In: Message to score */
    emsJunkScoreP            junkScore,          /* Out: Junk score */
    emsResultStatusP         status              /* Out: Status information */
);

/* ----- NEW in Eudora/EMSAPI 6.0 - called to mark as junk or not junk --------------- */
extern "C" long WINAPI
ems_user_mark_junk(
    void                     * globals,          /* In: Allocated instance structure returned in ems_plugin_init */
    emsTranslatorP           trans,              /* In: Translator Info */
    emsJunkInfoP             junkInfo,           /* In: Junk information */
    emsMessageInfoP          message,            /* In: Message that is either being marked as Junk or Not Junk */
    emsJunkScoreP            junkScore,          /* In: Previous junk score */
    emsResultStatusP         status              /* Out: Status information */
);

/* ----- V5 notification of mode changes --------------------------------------------- */
extern "C" long WINAPI
ems_eudora_mode_notification(
    void                               * globals,                    /* In: Allocated instance structure returned in ems_plugin_init */
    emsEudoraModeNotificationDataP     eudoraModeNotificationData    /* In/Out: Mode notification information */
);

#endif /* __EMS_WIN__ */
