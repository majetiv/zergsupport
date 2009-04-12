//
//  ZNMSInteger.m
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNMSInteger.h"

#import "ZNModelDefinitionAttribute.h"

@implementation ZNMSInteger

#pragma mark Boxing

-(NSObject*)boxAttribute:(ZNModelDefinitionAttribute*)attribute
				inInstance:(ZNModel*)instance
			   forceString:(BOOL)forceString {
	NSInteger value = *((NSInteger*)((uint8_t*)instance +
									 ivar_getOffset([attribute runtimeIvar])));
	if (forceString)
		return [NSString stringWithFormat:@"%i", value];
	else
		return [NSNumber numberWithInteger:value];
}

-(void)unboxAttribute:(ZNModelDefinitionAttribute*)attribute
		 	 inInstance:(ZNModel*)instance
			       from:(NSObject*)boxedObject {
	NSInteger value;
	if ([boxedObject isKindOfClass:[NSString class]])
		value = [(NSString*)boxedObject integerValue];
	else if ([boxedObject isKindOfClass:[NSNumber class]]) {
		value = [(NSNumber*)boxedObject integerValue];
	}
	else
		value = 0;
	*((NSInteger*)((uint8_t*)instance +
				   ivar_getOffset([attribute runtimeIvar]))) = value;
}

@end
