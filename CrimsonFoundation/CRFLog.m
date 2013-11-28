//
//  CrimsonLog.m
//  Crimson
//
//  Created by Waqar Malik on 9/28/13.
//  Copyright (c) 2013 Crimson Research, Inc. All rights reserved.
//

#import "CRFLog.h"
#import <DDASLLogger.h>
#import <DDTTYLogger.h>

NSInteger CRFLogContextForComponent(NSInteger component)
{
    return component;
}

NSInteger CRFLogLevelForComponent(NSInteger component)
{
    switch (component)
    {
        case CRFLogLevelGeneral: return ddLogLevel;
        case CRFLogLevelAPI: return ddLogLevelAPI;
        case CRFLogLevelApplication: return ddLogLevelApplication;
        case CRFLogLevelNetwork: return ddLogLevelNetwork;
        case CRFLogLevelEvent: return ddLogLevelEvent;
        case CRFLogLevelLocation: return ddLogLevelLocation;
        case CRFLogLevelConfig: return ddLogLevelConfig;
        case CRFLogLevelUI: return ddLogLevelUI;
        case CRFLogLevelPairing: return ddLogLevelPairing;
        case CRFLogLevelModel: return ddLogLevelModel;
        case CRFLogLevelViral: return ddLogLevelViral;
    }

    assert(false && "Log component must match a ddLogLevel. This means there is a log component that must be added above.");

    return ddLogLevel;
}

void CRFLogSetupLogger(void)
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

#if TARGET_IPHONE_SIMULATOR
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];

    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:LOG_FLAG_ERROR context: LOG_CONTEXT_API];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor magentaColor] backgroundColor:nil forFlag:LOG_FLAG_WARN context: LOG_CONTEXT_API];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor magentaColor] backgroundColor:nil forFlag:LOG_FLAG_INFO context: LOG_CONTEXT_API];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor magentaColor] backgroundColor:nil forFlag:LOG_FLAG_VERBOSE context: LOG_CONTEXT_API];
#endif
}
