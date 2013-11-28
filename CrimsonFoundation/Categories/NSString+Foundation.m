//
//  NSString+Foundation.m
//  CrimsonFoundation
//
//  Created by Waqar Malik on 9/29/13.
//  Copyright (c) 2013 Crimson Research, Inc. All rights reserved.
//

#import "NSString+Foundation.h"

@implementation NSString (Foundation)
+ (id)infoValueForKey:(in NSString *)key
{
	if([[NSBundle mainBundle] localizedInfoDictionary][key])
    {
		return [[NSBundle mainBundle] localizedInfoDictionary][key];
    }
	return [[NSBundle mainBundle] infoDictionary][key];
}
@end
