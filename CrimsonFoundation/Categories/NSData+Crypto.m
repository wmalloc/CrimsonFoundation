//
//  NSData+Crypto.m
//  CrimsonKit
//
//  Created by Waqar Malik on 2/2/11.
//  Copyright 2011 Crimson Research, Inc. All rights reserved.
//

#if !__has_feature(objc_arc)
#  error Please compile this class with ARC (-fobjc-arc).
#endif

#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+Crypto.h"

@implementation NSData (Crypto)
- (NSData *)SHA256
{
    if(0 < [self length])
    {
        uint8_t *buffer = NULL;
        
        if(!(buffer = (uint8_t *)malloc(CC_SHA256_DIGEST_LENGTH)))
        {
            return nil;
        }
        
        CC_SHA256([self bytes], (CC_LONG)self.length, buffer);
    
        // dataWithBytesNoCopy takes ownership of buffer and will free() it
        // when the NSData object that owns it is released.
        return [NSData dataWithBytesNoCopy:buffer length:CC_SHA256_DIGEST_LENGTH];
    }
    
    return nil;
}

- (NSString *)SHA256String
{
    NSData *sha256Data = [self SHA256];
	NSMutableString *stringValue = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    uint8_t *bytes = (uint8_t *)[sha256Data bytes];
	for(NSUInteger i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
	{
        uint8_t c = bytes[i];
		[stringValue appendFormat:@"%02x", c];
	}

	return stringValue;
}

- (NSData *)MD5
{
    if(0 < [self length])
    {
        uint8_t *buffer = NULL;
        
        if(!(buffer = (uint8_t *)malloc(CC_SHA256_DIGEST_LENGTH)))
        {
            return nil;
        }
        
        CC_MD5([self bytes], (CC_LONG)self.length, buffer);
        
        // dataWithBytesNoCopy takes ownership of buffer and will free() it
        // when the NSData object that owns it is released.
        return [NSData dataWithBytesNoCopy:buffer length:CC_SHA256_DIGEST_LENGTH];
    }
    
    return nil;
}

- (NSString *)MD5String
{
    NSData *md5Data = [self MD5];
	NSMutableString *stringValue = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    uint8_t *bytes = (uint8_t *)[md5Data bytes];
	for(NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
	{
        uint8_t c = bytes[i];
		[stringValue appendFormat:@"%02x", c];
	}

	return stringValue;
}

- (NSData *)encryptedDataWithPassphrase:(in NSString *)key
{
    NSParameterAssert(key);
    
    uint8_t *buffer = NULL;
    size_t bufferSize = 0;
    CCCryptorStatus error = kCCParamError;
    NSUInteger plainTextLength = 0;
    char keyBuffer[kCCKeySizeAES256 + 1];
    
    // make sure there's data to encrypt
    error = ((plainTextLength = [self length]) == 0);
    
    if(!error)
    {
        bzero(keyBuffer, sizeof(keyBuffer));
        [key getCString:keyBuffer maxLength:sizeof(keyBuffer) encoding:NSUTF8StringEncoding];
    }
    
    // create an output buffer with room for pad bytes
    if(!error)
    {
        bufferSize = kCCBlockSizeAES128 + plainTextLength + kCCBlockSizeAES128;     // iv + cipher + padding
        error = !(buffer = (uint8_t *)malloc( bufferSize));
    }
    
    // encrypt the data
    if(!error)
    {
        error = SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, buffer);
        NSAssert(0 == error, @"unable to genreate random data");
        // generate a random iv and prepend it to the output buffer.  the
        // decryptor needs to be aware of this.
        if(0 == error)
        {
            error = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                            keyBuffer, kCCKeySizeAES256, buffer, [self bytes], plainTextLength,
                            buffer + kCCBlockSizeAES128, bufferSize - kCCBlockSizeAES128, &bufferSize );
        }
    }
    
    if(error)
    {
        if(buffer)
        {
            free(buffer);
        }
        
        return nil;
    }
    
    // dataWithBytesNoCopy takes ownership of buffer and will free() it
    // when the NSData object that owns it is released.
    return [NSData dataWithBytesNoCopy:buffer length:bufferSize + kCCBlockSizeAES128];
}

- (NSData *)decryptedDataWithPassphrase:(in NSString *)key
{
    NSParameterAssert(key);
    
    uint8_t *buffer = NULL;
    size_t bufferSize = 0;
    CCCryptorStatus error = kCCParamError;
    NSUInteger plainTextLength = [self length];
    char keyBuffer[kCCKeySizeAES256 + 1];

    // make sure there's data to decrypt
    error = (plainTextLength == 0);
    
    if(!error)
    {
        bzero(keyBuffer, sizeof(keyBuffer));
        [key getCString:keyBuffer maxLength:sizeof(keyBuffer) encoding:NSUTF8StringEncoding];
    }
    
    // create an output buffer with room for pad bytes
    if(!error)
    {
        bufferSize = kCCBlockSizeAES128 + plainTextLength + kCCBlockSizeAES128;     // iv + cipher + padding
        error = !(buffer = (uint8_t *)malloc(bufferSize));
    }
    
    if(!error)
    {
        // get the iv from data
        [self getBytes:buffer length:kCCBlockSizeAES128];
        
        // get the data by removing the iv
        NSData *subdata = [self subdataWithRange:NSMakeRange(kCCBlockSizeAES128, plainTextLength - kCCBlockSizeAES128)];
        error = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                        keyBuffer, kCCKeySizeAES256, buffer, [subdata bytes], plainTextLength - kCCBlockSizeAES128,
                        buffer + kCCBlockSizeAES128, bufferSize - kCCBlockSizeAES128, &bufferSize );
    }
    
    if(error)
    {
        if(buffer)
        {
            free(buffer);
            buffer = NULL;
        }
        
        return nil;
    }
    
    NSData *data = [NSData dataWithBytes:buffer+kCCBlockSizeAES128 length:bufferSize];
    // dataWithBytesNoCopy takes ownership of buffer and will free() it
    // when the NSData object that owns it is released.
    free(buffer);
    buffer = NULL;
    return data;
}

- (NSData *)obfuscatedDataWithKey:(in NSString *)key
{
    NSParameterAssert(nil != key);

    // Create data object from the string
    NSData *data = [self copy];

    // Get pointer to data to obfuscate
    char *dataPtr = (char *) [data bytes];

    // Get pointer to key data
    char *keyData = (char *) [[key dataUsingEncoding:NSUTF8StringEncoding] bytes];

    // Points to each char in sequence in the key
    char *keyPtr = keyData;
    int keyIndex = 0;

    // For each character in data, xor with current value in key
    for (int x = 0; x < [data length]; x++)
    {
        // Replace current character in data with
        // current character xor'd with current key value.
        // Bump each pointer to the next character
        *dataPtr = *dataPtr ^ *keyPtr;
        dataPtr++;
        keyPtr++;

        // If at end of key data, reset count and
        // set key pointer back to start of key value
        if (++keyIndex == [key length])
        {
            keyIndex = 0, keyPtr = keyData;
        }
    }

    return data;
}

- (NSString *)obfuscatedStringWithKey:(in NSString *)key options:(in CRFObfuscationOption)options
{
    NSParameterAssert(nil != key);

    NSString *string = [[NSString alloc] initWithData:[self obfuscatedDataWithKey:key] encoding:NSUTF8StringEncoding];
    if(options & CRFObfuscationOptionArmor)
    {
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }

    return string;
}
@end
