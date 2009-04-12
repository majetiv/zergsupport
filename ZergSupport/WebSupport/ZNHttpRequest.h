//
//  ZNHttpRequest.h
//  ZergSupport
//
//  Created by Victor Costan on 1/21/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

enum ZNFormatterCasing;

// Superclass for classes facilitating HTTP requests.
//
// ZNHttpRequest subclasses implement asynchronous calls to HTTP services. They
// encode request parameters to application/x-www-form-urlencoded, and parse
// responses into Model Support models or NSDictionaries.
//
// The intended way of making HTTP calls is using class methods whose names
// starts with callService. The method parameters vary between subclasses, 
// due to the difference in supported response formats. However, the arguments
// in the +callService method of ZNHttpRequest should be common to all
// implementations.
@interface ZNHttpRequest : NSObject {
	NSMutableData* responseData;
	NSURLRequest* urlRequest;
	NSObject* target;
	SEL action;	
}

#pragma mark Public Interface

+(void)deleteCookiesForService:(NSString*)service;

// Issues a request against a HTTP service, returns the unparsed response.
//
// Subclasses should provide a convenience method like this.
//
// args:
//   service: a NSString with the URL of the service to be called
//   method: the HTTP method to use (one of the kZNHttpMethod* constants)
//   data: the form data to send in the HTTP request, as a NSDictionary where
//         the keys are field names, and the values can be strings, arrays,
//         dictionaries, or Model Support models; for non-string values, the
//         field names will be decorated according to the Rails convention,
//         as in: arrayItem[], hash[hashKey][subhashKey]
//   fieldCasing: the case convention of the HTTP service; for example, specify
//                kZNFormatterSnakeCase when talking to Rails servers, so models
//                can use the appropriate convention on both the iPhone and the
//                Rails server
//   target:(Target-Action) indicates the receiver for the parsed HTTP response
//   action:(Target-Action) indicates the receiver for the parsed HTTP response 
//
// returns:
//   nothing, the parsed HTTP response is returned via Target-Action invocation;
//   the invocation will contain an argument that is either an NSData instance
//   in case of success, or an NSError if something went wrong
+(void)callService:(NSString*)service
            method:(NSString*)method
              data:(NSDictionary*)data
       fieldCasing:(enum ZNFormatterCasing)fieldCasing
            target:(NSObject*)target
            action:(SEL)action;

#pragma mark Methods for Subclasses

// Designated initializer.
-(id)initWithURLRequest:(NSURLRequest*)request
                 target:(id)target
                 action:(SEL)action;

// Creates a NSURLRequest encapsulating data coming from a model.
//
// Subclasses should use this in a convenience method that assembles the request
// and starts it.
+(NSURLRequest*)newURLRequestToService:(NSString*)service
                                method:(NSString*)method
                                  data:(NSDictionary*)data
                           fieldCasing:(enum ZNFormatterCasing)fieldCasing;

// Subclasses should call this on the assembled request.
-(void)start;

// Subclasses should parse responseData and message the result to the delegate.
-(void)reportData;

// Subclasses can override this to provide custom parsing for the error.
-(void)reportError:(NSError*) error;

@end

#pragma mark HTTP Method Constants

// GET
extern NSString* kZNHttpMethodGet;
// POST
extern NSString* kZNHttpMethodPost;
// PUT
extern NSString* kZNHttpMethodPut;
// DELETE
extern NSString* kZNHttpMethodDelete;
