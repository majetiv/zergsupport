//
//  ZNFormURLEncoder.m
//  ZergSupport
//
//  Created by Victor Costan on 1/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNFormURLEncoder.h"

#import "ModelSupport.h"
#import "ZNFormFieldFormatter.h"

@interface ZNFormURLEncoder ()
-(id)initWithOutput:(NSMutableData*)theOutput
       fieldFormatter:(ZNFormFieldFormatter*)theFieldFormatter;

-(void)encode:(NSObject*)object keyPrefix:(NSString*)keyPrefix;

-(void)encodeKey:(NSString*)key
             value:(NSObject*)value
         keyPrefix:(NSString*)keyPrefix;
@end


@implementation ZNFormURLEncoder

+(NSData*)copyEncodingFor:(NSDictionary*)dictionary
        usingFieldFormatter:(ZNFormFieldFormatter*)formatter {
  NSMutableData* output = [[NSMutableData alloc] init];
  ZNFormURLEncoder* encoder =
      [[ZNFormURLEncoder alloc] initWithOutput:output fieldFormatter:formatter];
	[encoder encode:dictionary keyPrefix:@""];
  [encoder release];
	return output;
}

-(id)initWithOutput:(NSMutableData*)theOutput
       fieldFormatter:(ZNFormFieldFormatter*)theFieldFormatter {
  if ((self = [super init])) {
    output = theOutput;
    fieldFormatter = theFieldFormatter;
  }
  return self;
}

-(void)dealloc {
  [super dealloc];
}

-(void)encode:(NSObject*)object keyPrefix:(NSString*)keyPrefix {	
	if ([object isKindOfClass:[NSArray class]]) {
		NSUInteger count = [(NSArray*)object count];
		for (NSUInteger i = 0; i < count; i++) {
			[self encodeKey:@""
                value:[(NSArray*)object objectAtIndex:i]
            keyPrefix:keyPrefix];
		}
	}
	else {
		for (NSString* key in (NSDictionary*)object) {
      NSString* formattedKey = [fieldFormatter copyFormattedName:key];
			[self encodeKey:formattedKey
                value:[(NSDictionary*)object objectForKey:key]
            keyPrefix:keyPrefix];
      [formattedKey release];
		}
	}
}

-(void)encodeKey:(NSString*)key
             value:(NSObject*)value
         keyPrefix:(NSString*)keyPrefix {
	NSAssert([key isKindOfClass:[NSString class]],
           @"Attempting to encode non-String key!");
	
	if ([value isKindOfClass:[NSDictionary class]] ||
      [value isKindOfClass:[NSArray class]] ||
      [value isKindOfClass:[ZNModel class]]) {
		NSObject* realValue = [value isKindOfClass:[ZNModel class]] ?
        [(ZNModel*)value copyToDictionaryForcingStrings:YES] : value;
		
		NSString* newPrefix;
		if ([keyPrefix length] != 0)
			newPrefix = [[NSString alloc] initWithFormat:@"%@[%@]", keyPrefix, key];
		else
			newPrefix = [key retain];
		[self encode:realValue keyPrefix:newPrefix];
		[newPrefix release];
    
		if (realValue != value)
			[realValue release];
	}
	else {
		NSAssert([value isKindOfClass:[NSString class]],
             @"Attempting to encode non-String value!");
		
    if ([output length] != 0)
      [output appendBytes:"&" length:1];
		
		NSString* outputKey;
		if ([keyPrefix length] != 0)
			outputKey = [[NSString alloc] initWithFormat:@"%@[%@]", keyPrefix, key];
		else
			outputKey = [key retain];
		NSString* encodedKey = (NSString*)
		CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)outputKey,
                                            NULL,
                                            (CFStringRef)@"&=",
                                            kCFStringEncodingUTF8);
		[outputKey release];
		[output appendBytes:[encodedKey cStringUsingEncoding:NSUTF8StringEncoding]
                 length:[encodedKey length]];
		[encodedKey release];
		[output appendBytes:"=" length:1];
		
		NSString* encodedValue = (NSString*)
		    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                (CFStringRef)value,
                                                NULL,
                                                (CFStringRef)@"&=",
                                                kCFStringEncodingUTF8);
		[output appendBytes:[encodedValue cStringUsingEncoding:NSUTF8StringEncoding]
                 length:[encodedValue length]];
		[encodedValue release];
	}	
}

@end
