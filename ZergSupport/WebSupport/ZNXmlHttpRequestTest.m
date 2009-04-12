//
//  ZNXmlHttpRequestTest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ModelSupport.h"
#import "ZNXmlHttpRequest.h"

// Model for the response returned by the testbed.
@interface ZNXmlHttpRequestTestModel : ZNModel
{
	NSString* method;
	NSString* headers;
	NSString* body;
}

@property (nonatomic, retain) NSString* method;
@property (nonatomic, retain) NSString* headers;
@property (nonatomic, retain) NSString* body;

@end

@implementation ZNXmlHttpRequestTestModel

@synthesize method, headers, body;
-(void)dealloc {
	[method release];
	[headers release];
	[body release];
	[super dealloc];
}

@end

@interface ZNXmlHttpRequestTest : SenTestCase {
	NSString* service;
	BOOL receivedResponse;
}

@end

@implementation ZNXmlHttpRequestTest

-(void)warmUpHerokuService:(NSString*)herokuService {
  // Issues a request to the testbed, so heroku loads it up on a machine
  [NSString stringWithContentsOfURL:[NSURL URLWithString:herokuService]];
}

-(void)setUp {
	service = @"http://zn-testbed.herokugarden.com/web_support/echo.xml";
	receivedResponse = NO;
  [self warmUpHerokuService:service];
	[ZNXmlHttpRequest deleteCookiesForService:service];
}

-(void)tearDown {
	[service release];
	service = nil;
}

-(void)dealloc {
	[super dealloc];
}

-(void)testOnlineGet {
	[ZNXmlHttpRequest callService:service
                         method:kZNHttpMethodGet
                           data:nil
                 responseModels:[NSDictionary dictionaryWithObjectsAndKeys:
                                 [ZNXmlHttpRequestTestModel class], @"echo",
                                 nil]
                         target:self
                         action:@selector(checkOnlineGetResponse:)];
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:
                                            1.0]];
	
	STAssertEquals(YES, receivedResponse, @"Response never received");
}

-(void)checkOnlineGetResponse:(NSArray*)responseArray {
	receivedResponse = YES;
	STAssertFalse([responseArray isKindOfClass:[NSError class]],
                @"Error occured %@", responseArray);
	
	ZNXmlHttpRequestTestModel* response = [responseArray objectAtIndex:0];
	STAssertTrue([response isKindOfClass:[ZNXmlHttpRequestTestModel class]],
               @"Response not deserialized using proper model");
	
	STAssertEqualStrings(@"get", response.method,
                       @"Request not issued using GET");
}

-(void)testOnlineRequest {
	ZNXmlHttpRequestTestModel* requestModel = [[[ZNXmlHttpRequestTestModel
                                               alloc] init] autorelease];
	requestModel.method = @"Awesome method";
	requestModel.headers = @"Awesome headers";
	requestModel.body = @"Awesome body";
	
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        requestModel, @"model",
                        @"someString", @"stringKey", nil];
	[ZNXmlHttpRequest callService:service
                         method:kZNHttpMethodPut
                           data:dict
                 responseModels:[NSDictionary dictionaryWithObjectsAndKeys:
                                 [ZNXmlHttpRequestTestModel class], @"echo",
                                 nil]
                         target:self
                         action:@selector(checkOnlineResponse:)];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:
                                            1.0]];
	STAssertEquals(YES, receivedResponse, @"Response never received");
}

-(void)checkOnlineResponse:(NSArray*)responseArray {
	receivedResponse = YES;
	STAssertFalse([responseArray isKindOfClass:[NSError class]],
                @"Error occured %@", responseArray);
	
	ZNXmlHttpRequestTestModel* response = [responseArray objectAtIndex:0];
	STAssertTrue([response isKindOfClass:[ZNXmlHttpRequestTestModel class]],
               @"Response not deserialized using proper model");
	
	STAssertEqualStrings(@"put", response.method,
                       @"Request not issued using PUT");
	
	NSString* bodyPath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNXmlHttpRequestTest.body"];
	STAssertEqualStrings([NSString stringWithContentsOfFile:bodyPath],
                       response.body, @"Wrong body in request");
}

-(void)testFileRequest {
	NSString* filePath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNXmlHttpRequestTest.xml"];
	NSString* fileUrl = [[NSURL fileURLWithPath:filePath] absoluteString];
	
	[ZNXmlHttpRequest callService:fileUrl
                         method:kZNHttpMethodGet
                           data:nil
                 responseModels:[NSDictionary dictionaryWithObjectsAndKeys:
                                 [ZNXmlHttpRequestTestModel class], @"model",
                                 [NSNull null], @"nonmodel", nil]
                         target:self
                         action:@selector(checkFileResponse:)];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:
                                             1.0]];	
	STAssertEquals(YES, receivedResponse, @"Response never received");
}

-(void)checkFileResponse:(NSArray*)responseArray {
	receivedResponse = YES;	
	STAssertFalse([responseArray isKindOfClass:[NSError class]],
                @"Error occured %@", responseArray);
	
	ZNXmlHttpRequestTestModel* model = [responseArray objectAtIndex:0];
	STAssertTrue([model isKindOfClass:[ZNXmlHttpRequestTestModel class]],
               @"Model in response not deserialized properly");
	STAssertEqualStrings(@"Body", model.body,
                       @"Model's body not deserialized properly");
	STAssertEqualStrings(@"Headers", model.headers,
                       @"Model's headers not deserialized properly");
	STAssertEqualStrings(@"Method", model.method,
                       @"Model's method not deserialized properly");
  
	NSDictionary* nonmodel = [responseArray objectAtIndex:1];
	STAssertTrue([nonmodel isKindOfClass:[NSDictionary class]],
               @"Non-model in response not deserialized with NSDictionary");
	
	NSDictionary* golden_nonmodel = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"val1", @"key1", @"val2", @"key2",
                                   @"val3", @"keyThree", nil];
	STAssertEqualObjects(golden_nonmodel, nonmodel,
                       @"Non-model deserialized incorrectly");	
}

@end
