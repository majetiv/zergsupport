//
//  NZMSDate.m
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNMSDate.h"

#import "ZNModelDefinitionAttribute.h"

@implementation ZNMSDate

#pragma mark Lifecycle

-(id)init {
	if ((self = [super init])) {
		osxFormatter = [[NSDateFormatter alloc] init];
		[osxFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
		rssFormatter = [[NSDateFormatter alloc] init];
		[rssFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
	}
	return self;
}

-(void)dealloc {
	[osxFormatter release];
	[rssFormatter release];
	[super dealloc];
}

#pragma mark Boxing

-(NSObject*)boxAttribute:(ZNModelDefinitionAttribute*)attribute
				inInstance:(ZNModel*)instance
			   forceString:(BOOL)forceString {
	NSDate* date = object_getIvar(instance, [attribute runtimeIvar]);
	if (forceString)
		return [osxFormatter stringFromDate:date];
	else
		return date;
}

-(void)unboxAttribute:(ZNModelDefinitionAttribute*)attribute
		 	 inInstance:(ZNModel*)instance
			       from:(NSObject*)boxedObject {
	NSDate* date;
	if ([boxedObject isKindOfClass:[NSString class]]) {
		date = [osxFormatter dateFromString:(NSString*)boxedObject];
		if (!date) {
			date = [rssFormatter dateFromString:(NSString*)boxedObject];
		}
	}
	else if ([boxedObject isKindOfClass:[NSDate class]]) {		
		date = (NSDate*)boxedObject;
	}
  else if ([boxedObject isKindOfClass:[NSNull class]]) {
    date = nil;
  }  
	else
		date = nil;
	
	Ivar runtimeIvar = [attribute runtimeIvar];
	switch ([attribute setterStrategy]) {
		case kZNPropertyWantsCopy: {
			date = [date copy];
			NSDate* oldDate = object_getIvar(instance, runtimeIvar);
			[oldDate release];
			break;
		}
		case kZNPropertyWantsRetain: {
			[date retain];
			NSDate* oldDate = object_getIvar(instance, runtimeIvar);
			[oldDate release];
			break;
		}
	}
	object_setIvar(instance, runtimeIvar, date);
}

@end
