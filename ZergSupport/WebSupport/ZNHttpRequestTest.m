//
//  ZNHttpRequestTest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "FormatSupport.h"
#import "ModelSupport.h"
#import "ZNHttpRequest.h"

// Model that tests serialization.
@interface ZNHttpRequestTestModel : ZNModel
{
	NSString* textVal;
	NSUInteger uintVal;
	BOOL trueVal;
	NSDate* nilVal;
}

@property (nonatomic, retain) NSString* textVal;
@property (nonatomic) NSUInteger uintVal;
@property (nonatomic) BOOL trueVal;
@property (nonatomic, retain) NSDate* nilVal;

@end

@implementation ZNHttpRequestTestModel

@synthesize textVal, uintVal, trueVal, nilVal;

-(void)dealloc {
	[textVal release];
	[nilVal release];
	[super dealloc];
}

@end


@interface ZNHttpRequestTest : SenTestCase {
	NSString* service;
	BOOL receivedResponse;
}

@end

@implementation ZNHttpRequestTest

-(void)warmUpHerokuService:(NSString*)herokuService {
  // Issues a request to the testbed, so heroku loads it up on a machine
  [NSString stringWithContentsOfURL:[NSURL URLWithString:herokuService]];
}

-(void)setUp {
	service = @"http://zn-testbed.herokugarden.com/web_support/echo.xml";
	receivedResponse = NO;
  [self warmUpHerokuService:service];
	[ZNHttpRequest deleteCookiesForService:service];
}

-(void)tearDown {
	[service release];
	service = nil;
}

-(void)dealloc {
	[super dealloc];
}

-(void)testOnlineRequest {
	ZNHttpRequestTestModel* requestModel = [[[ZNHttpRequestTestModel alloc] init]
                                          autorelease];
	requestModel.textVal = @"Something\0special";
	requestModel.uintVal = 3141592;
	requestModel.trueVal = YES;
	requestModel.nilVal = nil;
	
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        requestModel, @"model",
                        @"someString", @"stringKey", nil];
	[ZNHttpRequest callService:service
                      method:kZNHttpMethodPut
                        data:dict
                 fieldCasing:kZNFormatterSnakeCase
                      target:self
                      action:@selector(checkOnlineAndFileResponse:)];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:
                                            1.0]];
	
	STAssertEquals(YES, receivedResponse, @"Response never received");
}

-(void)checkOnlineAndFileResponse:(NSData*)response {
	receivedResponse = YES;
	STAssertFalse([response isKindOfClass:[NSError class]],
                @"Error occured %@", response);
	
	NSString* responseString =
  [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];	
	NSString* bodyPath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNHttpRequestTest.put"];
	STAssertEqualStrings([NSString stringWithContentsOfFile:bodyPath],
                       responseString, @"Wrong request");
}

-(void)testFileRequest {
	NSString* filePath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNHttpRequestTest.put"];
	NSString* fileUrl = [[NSURL fileURLWithPath:filePath] absoluteString];
	
	[ZNHttpRequest callService:fileUrl
                      method:kZNHttpMethodGet
                        data:nil
                 fieldCasing:kZNFormatterSnakeCase   
                      target:self
                      action:@selector(checkOnlineAndFileResponse:)];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:
                                            1.0]];
	
	STAssertEquals(YES, receivedResponse, @"Response never received");
}

@end
