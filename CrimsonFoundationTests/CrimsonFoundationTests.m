//
//  CrimsonFoundationTests.m
//  CrimsonFoundationTests
//
//  Created by Waqar Malik on 9/29/13.
//  Copyright (c) 2013 Crimson Research, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSData+Crypto.h"

@interface CrimsonFoundationTests : XCTestCase
@end

@implementation CrimsonFoundationTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testObfuscate
{
    NSString *mytestString = @"This is my test";
    NSData *testData = [mytestString dataUsingEncoding:NSUTF8StringEncoding];

    NSString *encoded = [testData obfuscatedStringWithKey:@"My Key" options:CRFObfuscationOptionArmor];
    XCTAssertTrue([encoded isEqualToString:@"%19%11I8E%10%3EYM2E%0D(%0AT"], @"Obfuscation Failed");
}

- (void)testCrypto
{
    NSString *myTestString = @"This is my test";
    // MD5 = e749cd3a9507d6bb2e5dcedb8f7dbb45
    // SHA256 62868e848576403035578628691c20a3e8c8d3ea19959763a0565852895ff83d

    NSData *testData = [myTestString dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertNotNil(testData, @"testData is nil");

    NSString *MD5 = [testData MD5String];
    XCTAssertTrue([MD5 isEqualToString:@"e749cd3a9507d6bb2e5dcedb8f7dbb45"], @"MD5 Hash Failed");

    NSString *SHA256 = [testData SHA256String];
    XCTAssertTrue([SHA256 isEqualToString:@"62868e848576403035578628691c20a3e8c8d3ea19959763a0565852895ff83d"], @"SHA256 Hash Failed");

    NSString *myKey = @"My Encryption Key";
    NSData *encryptedData = [testData encryptedDataWithPassphrase:myKey];
    XCTAssertNotNil(encryptedData, @"Encryption Failed");

    NSData *decryptedData = [encryptedData decryptedDataWithPassphrase:myKey];
    XCTAssertNotNil(decryptedData, @"Decryption Failed");
    XCTAssertTrue([testData isEqualToData:decryptedData], @"Encryption/Decription Failed");

    NSData *nilData = nil;
    encryptedData = [nilData encryptedDataWithPassphrase:myKey];
    XCTAssertNil(encryptedData, @"Encryption nil data failed");
    decryptedData = [encryptedData decryptedDataWithPassphrase:myKey];
    XCTAssertNil(decryptedData, @"Decryption nil data failed");
}

- (void)testKeychain
{
}
@end
