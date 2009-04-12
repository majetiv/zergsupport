//
//  ZNFormURLEncoderTest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ModelSupport.h"
#import "ZNFormFieldFormatter.h"
#import "ZNFormURLEncoder.h"

@interface ZNFormURLEncoderTestModel: ZNModel {
	NSString* key11;
	NSUInteger key12;
}

@property (nonatomic, retain) NSString* key11;
@property (nonatomic) NSUInteger key12;
@end

@implementation ZNFormURLEncoderTestModel

@synthesize key11, key12;

-(void)dealloc {
	[key11 release];
	[super dealloc];
}
@end



@interface ZNFormURLEncoderTest : SenTestCase {
	ZNFormURLEncoderTestModel* testModel;
  ZNFormFieldFormatter* identityFormatter;
  ZNFormFieldFormatter* snakeFormatter;
}

@end


@implementation ZNFormURLEncoderTest

-(void)setUp {
	testModel = [[ZNFormURLEncoderTestModel alloc] initWithProperties:nil];
	testModel.key11 = @"val11";
	testModel.key12 = 31415;
  
  identityFormatter = [ZNFormFieldFormatter identityFormatter];
  snakeFormatter = [ZNFormFieldFormatter formatterFromPropertiesTo:
                    kZNFormatterSnakeCase];
}

-(void)tearDown {
  [testModel release];
}

-(void)dealloc {
	[super dealloc];
}

-(void)testEmptyEncoding {
	NSDictionary* dict = [NSDictionary dictionary];
	NSData* data = [ZNFormURLEncoder copyEncodingFor:dict
                               usingFieldFormatter:identityFormatter];
	NSString* string = [[NSString alloc] initWithData:data
											 encoding:NSUTF8StringEncoding];
	STAssertEqualStrings(@"",
						 string,
						 @"Empty dictionary");
	[data release];
	[string release];
}

-(void)testEasyOneLevel {
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"val1", @"key1", @"val2", @"key2", nil];
	NSData* data = [ZNFormURLEncoder copyEncodingFor:dict
                               usingFieldFormatter:identityFormatter];
	NSString* string = [[NSString alloc] initWithData:data
											 encoding:NSUTF8StringEncoding];
	STAssertEqualStrings(@"key1=val1&key2=val2",
						 string,
						 @"Empty dictionary");
	[data release];
	[string release];	
}

-(void)testEncodedOneLevel {
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"val\0001", @"key\n1", @"val = 2", @"key&2", nil];
	NSData* data = [ZNFormURLEncoder copyEncodingFor:dict
                               usingFieldFormatter:identityFormatter];
	NSString* string = [[NSString alloc] initWithData:data
											 encoding:NSUTF8StringEncoding];
	STAssertEqualStrings(@"key%0A1=val%001&key%262=val%20%3D%202",
						 string,
						 @"Escapes in keys and values");
	[data release];
	[string release];
}

-(void)testSubDictionary {
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"val1", @"key1",
						  [NSDictionary dictionaryWithObjectsAndKeys:
						   @"val21", @"key21", @"val22", @"key22", nil],
						  @"key2", nil];
	NSData* data = [ZNFormURLEncoder copyEncodingFor:dict
                               usingFieldFormatter:identityFormatter];
	NSString* string = [[NSString alloc] initWithData:data
											 encoding:NSUTF8StringEncoding];
	// This is dependent on how NSStrings hash. Wish it weren't.
	STAssertEqualStrings(@"key1=val1&key2%5Bkey22%5D=val22&key2%5Bkey21%5D=val21",
						 string,
						 @"Dictionary nested in another dictionary");
	[data release];
	[string release];
}

-(void)testSubSubDictionary {
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"val1", @"key1",
						  [NSDictionary dictionaryWithObjectsAndKeys:
						   [NSDictionary dictionaryWithObjectsAndKeys:
							@"val211", @"key211", nil],
						   @"key21", nil],
						  @"key2", nil];
	NSData* data = [ZNFormURLEncoder copyEncodingFor:dict
                               usingFieldFormatter:identityFormatter];
	NSString* string = [[NSString alloc] initWithData:data
											 encoding:NSUTF8StringEncoding];
	STAssertEqualStrings(@"key1=val1&key2%5Bkey21%5D%5Bkey211%5D=val211",
						 string,
						 @"2 levels of nested dictionaries");
	[data release];
	[string release];
}

-(void)testSubArray {
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  @"val1", @"key1",
						  [NSArray arrayWithObjects:
						   @"val21", @"val22", nil],
						  @"key2", nil];
	NSData* data = [ZNFormURLEncoder copyEncodingFor:dict
                               usingFieldFormatter:identityFormatter];
	NSString* string = [[NSString alloc] initWithData:data
											 encoding:NSUTF8StringEncoding];
	// This is dependent on how NSStrings hash. Wish it weren't.
	STAssertEqualStrings(@"key1=val1&key2%5B%5D=val21&key2%5B%5D=val22",
						 string,
						 @"Array nested inside dictionary");
	[data release];
	[string release];	
}

-(void)testModel {
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  testModel, @"key1", nil];
	NSData* data = [ZNFormURLEncoder copyEncodingFor:dict
                               usingFieldFormatter:identityFormatter];
	NSString* string = [[NSString alloc] initWithData:data
											 encoding:NSUTF8StringEncoding];
	// This is dependent on how NSStrings hash. Wish it weren't.
	STAssertEqualStrings(@"key1%5Bkey11%5D=val11&key1%5Bkey12%5D=31415",
						 string,
						 @"Empty dictionary");
	[data release];
	[string release];
}

-(void)testKeyFormatting {
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"val1", @"keyOne",
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSDictionary dictionaryWithObjectsAndKeys:
                          @"val211", @"keyTwoOneOne", nil],
                         @"keyTwoOne", nil],
                        @"keyTwo", nil];
	NSData* data = [ZNFormURLEncoder copyEncodingFor:dict
                               usingFieldFormatter:snakeFormatter];
	NSString* string = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
	STAssertEqualStrings(@"key_one=val1&key_two%5Bkey_two_one%5D"
                       @"%5Bkey_two_one_one%5D=val211",
                       string,
                       @"2 levels of nested dictionaries with key formatting");
	[data release];
	[string release];
}

@end
