//
//  ZNCsvHttpRequest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNCsvHttpRequest.h"

#import "FormatSupport.h"
#import "ModelSupport.h"

@interface ZNCsvHttpRequest ()
    <ZNArrayCsvParserDelegate, ZNModelCsvParserDelegate> 
@end

@implementation ZNCsvHttpRequest

#pragma mark Lifecycle

-(id)initWithURLRequest:(NSURLRequest*)theRequest
            responseClass:(Class)modelClass
       responseProperties:(NSArray*)modelPropertyNames
                   target:(NSObject*)theTarget
                   action:(SEL)theAction {
	if ((self = [super initWithURLRequest:theRequest
                                 target:theTarget
                                 action:theAction])) {
		response = [[NSMutableArray alloc] init];
		if ([ZNModel isModelClass:modelClass]) {
			modelParser = [[ZNModelCsvParser alloc]
                     initWithModelClass:modelClass
                     propertyNames:modelPropertyNames];
			modelParser.delegate = self;
		}
		else {
			arrayParser = [[ZNArrayCsvParser alloc] init];
			arrayParser.delegate = self;
		}
	}
	return self;
}

-(void)dealloc {
	[response release];
	[arrayParser release];
	[modelParser release];
	[super dealloc];
}

+(void)callService:(NSString*)service
              method:(NSString*)method
                data:(NSDictionary*)data
         fieldCasing:(ZNFormatterCasing)fieldCasing
       responseClass:(Class)modelClass
  responseProperties:(NSArray*)modelPropertyNames
              target:(NSObject*)target
              action:(SEL)action {
	NSURLRequest* urlRequest = [self newURLRequestToService:service
                                                   method:method
                                                     data:data
                                              fieldCasing:fieldCasing];
	ZNCsvHttpRequest* request =
      [[ZNCsvHttpRequest alloc] initWithURLRequest:urlRequest
                                     responseClass:modelClass
                                responseProperties:modelPropertyNames
                                            target:target
                                            action:action];
	[request start];
	[urlRequest release];
	[request release];
}

+(void)callService:(NSString*)service
              method:(NSString*)method
                data:(NSDictionary*)data
       responseClass:(Class)modelClass
  responseProperties:(NSArray*)modelPropertyNames
              target:(NSObject*)target
              action:(SEL)action {
  return [self callService:service
                    method:method
                      data:data
               fieldCasing:kZNFormatterSnakeCase
             responseClass:modelClass
        responseProperties:modelPropertyNames
                    target:target
                    action:action];
}

#pragma mark Parser Delegates

-(void)parsedLine:(NSArray*)lineData context:(id)context {
	[response addObject:lineData];
}

-(void)parsedModel:(ZNModel*)model context:(id)context {
	[response addObject:model];
}

#pragma mark Delegate Invocation

-(void)reportData {
	NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];
	if (arrayParser)
		[arrayParser parseData:responseData];
	else
		[modelParser parseData:responseData];
	[arp release];
	[target performSelector:action withObject:response];	
}

@end
