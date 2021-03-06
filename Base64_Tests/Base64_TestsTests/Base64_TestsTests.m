//
//  Base64_TestsTests.m
//  Base64_TestsTests
//
//  Created by Darren Ford on 25/10/12.
//  Copyright (c) 2012 Darren Ford. All rights reserved.
//

#import "Base64_TestsTests.h"

#import "../../NSData+MIGBase64.h"
#import "../../NSString+MIGBase64.h"
#import "../../MIGBase64.h"
#import "../../MIGConverter.h"

/** RFC Test vectors
 10.  Test Vectors
 
 BASE64("") = ""
 BASE64("f") = "Zg=="
 BASE64("fo") = "Zm8="
 BASE64("foo") = "Zm9v"
 BASE64("foob") = "Zm9vYg=="
 BASE64("fooba") = "Zm9vYmE="
 BASE64("foobar") = "Zm9vYmFy"
 */

@implementation Base64_TestsTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testProperty
{
    NSError *error;
    
    NSString *testString  = @"This is a test";
    NSString *testString2 = @"This is a test".Base64;
    
    NSString *result = [testString encodeAsBase64StringUsingLineEndings:NO error:&error];
    STAssertEqualObjects(result, testString2, @"Testing basic encoding");
}

- (void)testRFCEncodeVectors
{
    /*
    STAssertEqualObjects(@"".Base64, @"", @"RFC 1");
    STAssertEqualObjects(@"f".Base64, @"Zg==", @"RFC 2");
    STAssertEqualObjects(@"fo".Base64, @"Zm8=", @"RFC 3");
    STAssertEqualObjects(@"foo".Base64, @"Zm9v", @"RFC 4");
    STAssertEqualObjects(@"foob".Base64, @"Zm9vYg==", @"RFC 5");
    STAssertEqualObjects(@"fooba".Base64, @"Zm9vYmE=", @"RFC 6");
    STAssertEqualObjects(@"foobar".Base64, @"Zm9vYmFy", @"RFC 7");
     */
}

- (void)testRFCDecodeVectors
{
    NSError *error;
    
    NSString *vector = @"";
    NSString *result = [vector decodeBase64AsString:&error];
    STAssertEqualObjects(@"", result, @"RFC 1");
    
    vector = @"Zg==";
    result = [vector decodeBase64AsString:&error];
    STAssertEqualObjects(@"f", result, @"RFC 2");
    
    vector = @"Zm8=";
    result = [vector decodeBase64AsString:&error];
    STAssertEqualObjects(@"fo", result, @"RFC 3");
    
    vector = @"Zm9v";
    result = [vector decodeBase64AsString:&error];
    STAssertEqualObjects(@"foo", result, @"RFC 4");
    
    vector = @"Zm9vYg==";
    result = [vector decodeBase64AsString:&error];
    STAssertEqualObjects(@"foob", result, @"RFC 5");
    
    vector = @"Zm9vYmE=";
    result = [vector decodeBase64AsString:&error];
    STAssertEqualObjects(@"fooba", result, @"RFC 6");
    
    vector = @"Zm9vYmFy";
    result = [vector decodeBase64AsString:&error];
    STAssertEqualObjects(@"foobar", result, @"RFC 7");
    
}

- (void)testWikipediaExample
{
    NSError *error;
    
    NSString *b64Test =
        @"TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb24sIGJ1dCBieSB0aGlz\r\n"
        @"IHNpbmd1bGFyIHBhc3Npb24gZnJvbSBvdGhlciBhbmltYWxzLCB3aGljaCBpcyBhIGx1c3Qgb2Yg\r\n"
        @"dGhlIG1pbmQsIHRoYXQgYnkgYSBwZXJzZXZlcmFuY2Ugb2YgZGVsaWdodCBpbiB0aGUgY29udGlu\r\n"
        @"dWVkIGFuZCBpbmRlZmF0aWdhYmxlIGdlbmVyYXRpb24gb2Yga25vd2xlZGdlLCBleGNlZWRzIHRo\r\n"
        @"ZSBzaG9ydCB2ZWhlbWVuY2Ugb2YgYW55IGNhcm5hbCBwbGVhc3VyZS4=";
    
    NSString *expected = @"Man is distinguished, not only by his reason, but by this singular passion from other animals, which is a lust of the mind, that by a perseverance of delight in the continued and indefatigable generation of knowledge, exceeds the short vehemence of any carnal pleasure.";
    NSString *result = [b64Test decodeBase64AsString:&error];
    STAssertEqualObjects(expected, result, @"Decoding Wikipedia example");
    
    
    NSString *tmp = [expected encodeAsBase64StringUsingLineEndings:YES error:&error];
    STAssertEqualObjects(tmp, b64Test, @"Encoding Wikipedia example");
    
    NSString *tmp2 = [expected encodeAsBase64StringUsingLineEndings:NO error:&error];
    STAssertTrue(![tmp2 isEqualToString:b64Test], @"Encoding Wikipedia example without formatting");
    
    tmp = @"any carnal pleasure.";
    tmp2 = [tmp encodeAsBase64StringUsingLineEndings:NO error:&error];
    STAssertEqualObjects(tmp2, @"YW55IGNhcm5hbCBwbGVhc3VyZS4=", @"Encoding Wikipedia example");
    
    tmp = @"any carnal pleasure";
    tmp2 = [tmp encodeAsBase64StringUsingLineEndings:NO error:&error];
    STAssertEqualObjects(tmp2, @"YW55IGNhcm5hbCBwbGVhc3VyZQ==", @"Encoding Wikipedia example");

    tmp = @"asure.";
    tmp2 = [tmp encodeAsBase64StringUsingLineEndings:NO error:&error];
    STAssertEqualObjects(tmp2, @"YXN1cmUu", @"Encoding Wikipedia example");
    
}

- (void)testSimpleImage
{
    NSError *error;
    
    NSString *encoding =
        @"iVBORw0KGgoAAAANSUhEUgAAACAAAAATBAMAAAADuhLEAAAABGdBTUEAALGP\r\n"
        @"C/xhBQAAAAFzUkdCAdnJLH8AAAAPUExURYSEhP///wAAAP//AP8AACykMFsA\r\n"
        @"AABsSURBVHjahdDBDcMwDENRWhsw9AJRuwCBLuAi+8+UQ+rGTg75NwkPECBg\r\n"
        @"LlDmAuBUoCyZfapbm4Tr1gJlybVvPt/XKMz6boHyX4iWBmGKdBf5i6cwSVpX\r\n"
        @"4fGKnoRpqQsdV+1TmLYkBW4Pyks7gc8WIpISYokAAAAASUVORK5CYII=";
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"mail" ofType:@"png"];
    NSData *image = [NSData dataWithContentsOfFile:path];
    
    NSData *decoded = [encoding decodeBase64AsData:&error];
    STAssertEqualObjects(image, decoded, @"Decoding basic image data");
}

- (void)testBase64Class
{
    NSString *testPhrase = @"Testing class encoding";
    
    MIGBase64 *obj = [MIGBase64 createWithString:testPhrase useFormatting:NO];
    NSData *dat = [NSKeyedArchiver archivedDataWithRootObject:obj];
    MIGBase64 *decObj = [NSKeyedUnarchiver unarchiveObjectWithData:dat];
    
    NSString *str = decObj.string;
    STAssertEqualObjects(str, testPhrase, @"Archive/Unarchive");

    NSString *encoding =
        @"iVBORw0KGgoAAAANSUhEUgAAACAAAAATBAMAAAADuhLEAAAABGdBTUEAALGP\r\n"
        @"C/xhBQAAAAFzUkdCAdnJLH8AAAAPUExURYSEhP///wAAAP//AP8AACykMFsA\r\n"
        @"AABsSURBVHjahdDBDcMwDENRWhsw9AJRuwCBLuAi+8+UQ+rGTg75NwkPECBg\r\n"
        @"LlDmAuBUoCyZfapbm4Tr1gJlybVvPt/XKMz6boHyX4iWBmGKdBf5i6cwSVpX\r\n"
        @"4fGKnoRpqQsdV+1TmLYkBW4Pyks7gc8WIpISYokAAAAASUVORK5CYII=";
    
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"mail" ofType:@"png"];
    NSData *image = [NSData dataWithContentsOfFile:path];
    
    const char *data = encoding.UTF8String;
    obj.base64 = [NSData dataWithBytes:data length:strlen(data)];
    NSData *decoded = obj.data;
 
    STAssertEqualObjects(image, decoded, @"Basic set base64 decoding");
    
    obj.useFormatting = YES;
    dat = [NSKeyedArchiver archivedDataWithRootObject:obj];
    decObj = [NSKeyedUnarchiver unarchiveObjectWithData:dat];
    
    decoded = decObj.data;

    STAssertEqualObjects(image, decoded, @"Basic set Base64 archive/unarchive");
}

- (void)testSpeedNSData
{
    NSMutableData* theData = [NSMutableData dataWithCapacity:1000000];
    for( unsigned int i = 0 ; i < 1000000/4 ; ++i )
    {
        u_int32_t randomBits = arc4random();
        [theData appendBytes:(void*)&randomBits length:4];
    }
    
    NSError *err;
    for (int i = 0; i < 1000; i++)
    {
        NSData *enc = [theData encodeAsBase64DataUsingLineEndings:NO error:&err];
        NSData *data  = [enc decodeFromBase64Data:&err];
    }
}

- (void)testSpeedRawMIG
{
    NSMutableData* theData = [NSMutableData dataWithCapacity:1000000];
    for( unsigned int i = 0 ; i < 1000000/4 ; ++i )
    {
        u_int32_t randomBits = arc4random();
        [theData appendBytes:(void*)&randomBits length:4];
    }
    
    char *result;
    unsigned char *result2;
    unsigned int result_len, result_len2;
    
    for (int i = 0; i < 1000; i++)
    {
        MIG_Result res = MIG_encodeAsBase64(0,
                                            (const unsigned char *)(theData.mutableBytes), theData.length,
                                            &result, &result_len);
        res = MIG_decodeAsBase64(result, result_len, &result2, &result_len2);
        free(result);
        free(result2);
    }
}

@end
