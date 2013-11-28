//
//  NSData+Crypto.h
//  CrimsonKit
//
//  Created by Waqar Malik on 2/2/11.
//  Copyright 2011 Crimson Research, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, CRFObfuscationOption)
{
    CRFObfuscationOptionNone = 0,
    CRFObfuscationOptionArmor = 1 << 1
};

@interface NSData (Crypto)
- (NSData *)SHA256 NS_RETURNS_NOT_RETAINED;
- (NSString *)SHA256String NS_RETURNS_NOT_RETAINED;

- (NSData *)MD5 NS_RETURNS_NOT_RETAINED;
- (NSString *)MD5String NS_RETURNS_NOT_RETAINED;

- (NSData *)encryptedDataWithPassphrase:(in NSString *)key NS_RETURNS_NOT_RETAINED;
- (NSData *)decryptedDataWithPassphrase:(in NSString *)key NS_RETURNS_NOT_RETAINED;

- (NSData *)obfuscatedDataWithKey:(in NSString *)key NS_RETURNS_NOT_RETAINED;
- (NSString *)obfuscatedStringWithKey:(in NSString *)key options:(in CRFObfuscationOption)options NS_RETURNS_NOT_RETAINED;
@end
