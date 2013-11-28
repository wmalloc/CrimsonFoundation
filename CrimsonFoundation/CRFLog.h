//
//  CrimsonLog.h
//  Crimson
//
//  Created by Waqar Malik on 9/28/13.
//  Copyright (c) 2013 Crimson Research, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DDLog.h>

#ifdef DEBUG
static const NSInteger ddLogLevel               = LOG_FLAG_VERBOSE | LOG_FLAG_INFO | LOG_FLAG_WARN | LOG_FLAG_ERROR;
static const NSInteger ddLogLevelAPI            = LOG_FLAG_VERBOSE | LOG_FLAG_INFO | LOG_FLAG_WARN | LOG_FLAG_ERROR;
static const NSInteger ddLogLevelApplication    = LOG_FLAG_VERBOSE | LOG_FLAG_INFO | LOG_FLAG_WARN | LOG_FLAG_ERROR;
static const NSInteger ddLogLevelNetwork        = LOG_FLAG_VERBOSE | LOG_FLAG_INFO | LOG_FLAG_WARN | LOG_FLAG_ERROR;
static const NSInteger ddLogLevelEvent          = LOG_FLAG_VERBOSE | LOG_FLAG_INFO | LOG_FLAG_WARN | LOG_FLAG_ERROR;
static const NSInteger ddLogLevelLocation       = LOG_FLAG_VERBOSE | LOG_FLAG_INFO | LOG_FLAG_WARN | LOG_FLAG_ERROR;
static const NSInteger ddLogLevelConfig         = LOG_FLAG_VERBOSE | LOG_FLAG_INFO | LOG_FLAG_WARN | LOG_FLAG_ERROR;
static const NSInteger ddLogLevelUI             = LOG_FLAG_VERBOSE | LOG_FLAG_INFO | LOG_FLAG_WARN | LOG_FLAG_ERROR;
static const NSInteger ddLogLevelPairing        = LOG_FLAG_VERBOSE | LOG_FLAG_INFO | LOG_FLAG_WARN | LOG_FLAG_ERROR;
static const NSInteger ddLogLevelModel          = LOG_FLAG_VERBOSE | LOG_FLAG_INFO | LOG_FLAG_WARN | LOG_FLAG_ERROR;
static const NSInteger ddLogLevelViral          = LOG_FLAG_VERBOSE | LOG_FLAG_INFO | LOG_FLAG_WARN | LOG_FLAG_ERROR;
#else
static const NSInteger ddLogLevel               = LOG_LEVEL_ERROR;
static const NSInteger ddLogLevelAPI            = LOG_LEVEL_ERROR;
static const NSInteger ddLogLevelApplication    = LOG_LEVEL_ERROR;
static const NSInteger ddLogLevelNetwork        = LOG_LEVEL_ERROR;
static const NSInteger ddLogLevelEvent          = LOG_LEVEL_ERROR;
static const NSInteger ddLogLevelLocation       = LOG_LEVEL_ERROR;
static const NSInteger ddLogLevelConfig         = LOG_LEVEL_ERROR;
static const NSInteger ddLogLevelUI             = LOG_LEVEL_ERROR;
static const NSInteger ddLogLevelPairing        = LOG_LEVEL_ERROR;
static const NSInteger ddLogLevelModel          = LOG_LEVEL_ERROR;
static const NSInteger ddLogLevelViral          = LOG_LEVEL_ERROR;
#endif

// Components
typedef NS_ENUM (NSInteger, CRFLogLevel)
{
    CRFLogLevelGeneral,
    CRFLogLevelAPI,
    CRFLogLevelApplication,
    CRFLogLevelNetwork,
    CRFLogLevelEvent,
    CRFLogLevelLocation,
    CRFLogLevelConfig,
    CRFLogLevelUI,
    CRFLogLevelPairing,
    CRFLogLevelModel,
    CRFLogLevelViral,
};

// Helper macros for log contexts
#define LOG_CONTEXT_GENERAL      CRFLogLevelGeneral
#define LOG_CONTEXT_API          CRFLogLevelAPI
#define LOG_CONTEXT_APPLICATION  CRFLogLevelApplication
#define LOG_CONTEXT_NETWORK      CRFLogLevelNetwork
#define LOG_CONTEXT_EVENT        CRFLogLevelEvent
#define LOG_CONTEXT_LOCATION     CRFLogLevelLocation
#define LOG_CONTEXT_CONFIG       CRFLogLevelConfig
#define LOG_CONTEXT_UI           CRFLogLevelUI
#define LOG_CONTEXT_PAIRING      CRFLogLevelPairing
#define LOG_CONTEXT_MODEL        CRFLogLevelModel
#define LOG_CONTEXT_VIRAL        CRFLogLevelViral

#define LOG_CONTEXT_START        LOG_CONTEXT_GENERAL
#define LOG_CONTEXT_END          LOG_CONTEXT_VIRAL

extern NSInteger CRFLogContextForComponent(NSInteger component);
extern NSInteger CRFLogLevelForComponent(NSInteger component);
extern void CRFLogSetupLogger(void);

#define CRFLog(frmt, ...)                     ASYNC_LOG_OBJC_MAYBE(CRFLogLevelForComponent(CRFLogLevelGeneral), LOG_FLAG_VERBOSE, CRFLogContextForComponent(CRFLogLevelGeneral), frmt, ##__VA_ARGS__)
#define CRFLogError(component, frmt, ...)     ASYNC_LOG_OBJC_MAYBE(CRFLogLevelForComponent(component), LOG_FLAG_ERROR,   CRFLogContextForComponent(component), frmt, ##__VA_ARGS__)
#define CRFLogWarn(component, frmt, ...)      ASYNC_LOG_OBJC_MAYBE(CRFLogLevelForComponent(component), LOG_FLAG_WARN,    CRFLogContextForComponent(component), frmt, ##__VA_ARGS__)
#define CRFLogInfo(component, frmt, ...)      ASYNC_LOG_OBJC_MAYBE(CRFLogLevelForComponent(component), LOG_FLAG_INFO,    CRFLogContextForComponent(component), frmt, ##__VA_ARGS__)
#define CRFLogVerbose(component, frmt, ...)   ASYNC_LOG_OBJC_MAYBE(CRFLogLevelForComponent(component), LOG_FLAG_VERBOSE, CRFLogContextForComponent(component), frmt, ##__VA_ARGS__)
