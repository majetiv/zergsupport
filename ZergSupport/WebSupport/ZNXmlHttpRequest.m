//
//  ZNXmlHttpRequest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNXmlHttpRequest.h"

#import "FormatSupport.h"
#import "ModelSupport.h"

@interface ZNXmlHttpRequest () <ZNModelXmlParserDelegate> 
@end

@implementation ZNXmlHttpRequest

#pragma mark Lifecycle

-(id)initWithURLRequest:(NSURLRequest*)theRequest
         responseModels:(NSDictionary*)theResponseModels
         responseCasing:(ZNFormatterCasing)responseCasing
                 target:(NSObject*)theTarget
                 action:(SEL)theAction {
	if ((self = [super initWithURLRequest:theRequest
                                 target:theTarget
                                 action:theAction])) {
		response = [[NSMutableArray alloc] init];
		responseParser = [[ZNModelXmlParser alloc]
                      initWithSchema:theResponseModels
                      documentCasing:responseCasing];
		responseParser.delegate = self;
	}
	return self;
}

-(void)dealloc {
	[response release];
	[responseParser release];
	[super dealloc];
}

+(void)callService:(NSString*)service
            method:(NSString*)method
              data:(NSDictionary*)data
       fieldCasing:(ZNFormatterCasing)fieldCasing
    responseModels:(NSDictionary*)responseModels
    responseCasing:(ZNFormatterCasing)responseCasing
            target:(NSObject*)target
            action:(SEL)action {
	NSURLRequest* urlRequest = [self newURLRequestToService:service
                                                   method:method
                                                     data:data
                                              fieldCasing:fieldCasing];
	ZNXmlHttpRequest* request =
  [[ZNXmlHttpRequest alloc] initWithURLRequest:urlRequest
                                responseModels:responseModels
                                responseCasing:responseCasing
                                        target:target
                                        action:action];
	[request start];
	[urlRequest release];
	[request release];
}

+(void)callService:(NSString*)service
            method:(NSString*)method
              data:(NSDictionary*)data
    responseModels:(NSDictionary*)responseModels
            target:(NSObject*)target
            action:(SEL)action {
  return [self callService:service
                    method:method
                      data:data
               fieldCasing:kZNFormatterSnakeCase
            responseModels:responseModels
            responseCasing:kZNFormatterSnakeCase
                    target:target
                    action:action];
}

#pragma mark ZNModelXmlParser Delegate

-(void)parsedItem:(NSDictionary*)itemData
             name:(NSString*)itemName
          context:(id)context {
  [response addObject:itemData];  
}
-(void)parsedModel:(ZNModel*)model
           context:(id)context {
  [response addObject:model];
}

#pragma mark Delegate Invocation

-(void)reportData {
	NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];
	[responseParser parseData:responseData];
	[arp release];
	[target performSelector:action withObject:response];	
}

@end
