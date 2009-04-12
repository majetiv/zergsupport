//
//  ZNMSUInteger.m
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNMSUInteger.h"

#import "ZNModelDefinitionAttribute.h"

@implementation ZNMSUInteger

#pragma mark Boxing

-(NSObject*)boxAttribute:(ZNModelDefinitionAttribute*)attribute
				inInstance:(ZNModel*)instance
			   forceString:(BOOL)forceString {
	NSUInteger value = *((NSInteger*)((uint8_t*)instance +
									  ivar_getOffset([attribute runtimeIvar])));
	if (forceString)
		return [NSString stringWithFormat:@"%u", value];
	else
		return [NSNumber numberWithUnsignedInteger:value];
}

-(void)unboxAttribute:(ZNModelDefinitionAttribute*)attribute
		 	 inInstance:(ZNModel*)instance
			       from:(NSObject*)boxedObject {
	NSUInteger value;
	if ([boxedObject isKindOfClass:[NSString class]]) {
		NSDecimalNumber* decimal = [[NSDecimalNumber alloc]
									initWithString:(NSString*)boxedObject];
		value = [decimal unsignedIntegerValue];
		[decimal release];
	}
	else if ([boxedObject isKindOfClass:[NSNumber class]]) {
		value = [(NSNumber*)boxedObject unsignedIntegerValue];
	}
	else
		value = 0;
	*((NSUInteger*)((uint8_t*)instance +
		 		    ivar_getOffset([attribute runtimeIvar]))) = value;	
}

@end
