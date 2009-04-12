//
//  ZNCsvHttpRequestTest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ModelSupport.h"
#import "ZNCsvHttpRequest.h"

// Model for the response returned by the testbed.
@interface ZNCsvHttpRequestTestModel : ZNModel
{
	NSString* name;
	double askPrice;
	double bidPrice;
	double previousClose;
}

@property (nonatomic, readonly, retain) NSString* name;
@property (nonatomic, readonly) double askPrice;
@property (nonatomic, readonly) double bidPrice;
@property (nonatomic, readonly) double previousClose;
@end

@implementation ZNCsvHttpRequestTestModel

@synthesize name, askPrice, bidPrice, previousClose;
-(void)dealloc {
	[name release];
	[super dealloc];
}

@end

@interface ZNCsvHttpRequestTest : SenTestCase {
	NSString* service;
	NSArray* onlineData;
	BOOL receivedResponse;
}

@end

@implementation ZNCsvHttpRequestTest

-(void)warmUpHerokuService:(NSString*)herokuService {
  // Issues a request to the testbed, so heroku loads it up on a machine
  [NSString stringWithContentsOfURL:[NSURL URLWithString:herokuService]];
}

-(void)setUp {
	service = @"http://zn-testbed.herokugarden.com/web_support/csv.csv";
	receivedResponse = NO;
  [self warmUpHerokuService:service];
	[ZNCsvHttpRequest deleteCookiesForService:service];
	onlineData = [[NSArray alloc] initWithObjects:@"foo", @"bar", @"xbar", nil];
}

-(void)tearDown {
	[service release];
	[onlineData release];
}

-(void)dealloc {
	[super dealloc];
}

-(void)testOnlineRequest {
	[ZNCsvHttpRequest callService:service
                         method:kZNHttpMethodPut
                           data:[NSDictionary dictionaryWithObject:onlineData
                                                            forKey:@"data"]
                  responseClass:nil
             responseProperties:nil
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
	
	ZNCsvHttpRequestTestModel* array = [responseArray objectAtIndex:0];	
	STAssertEqualObjects(onlineData, array,
                       @"Response not deserialized properly");
}

-(void)testFileRequest {
	NSString* filePath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:
                        @"ZNCsvHttpRequestTest.csv"];
	NSString* fileUrl = [[NSURL fileURLWithPath:filePath] absoluteString];
	
	[ZNCsvHttpRequest callService:fileUrl
                         method:kZNHttpMethodGet
                           data:nil
                  responseClass:[ZNCsvHttpRequestTestModel class]
             responseProperties:[NSArray arrayWithObjects:
                                 @"name", @"askPrice", @"bidPrice",
                                 @"previousClose", nil]
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
	
	ZNCsvHttpRequestTestModel* model = [responseArray objectAtIndex:0];
	STAssertTrue([model isKindOfClass:[ZNCsvHttpRequestTestModel class]],
               @"Model in response not deserialized properly");
	STAssertEqualStrings(@"Apple Inc.", model.name, @"First stock name");
	STAssertEqualsWithAccuracy(79.51, model.askPrice, 0.0001,
                             @"First stock ask price");
	STAssertEqualsWithAccuracy(79.20, model.bidPrice, 0.0001,
                             @"First stock bid price");
	STAssertEqualsWithAccuracy(78.20, model.previousClose, 0.0001,
                             @"First stock previous close");	
}

@end
