//
//  ZNMSBoolean.m
//  ZergSupport
//
//  Created by Victor Costan on 1/15/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNMSBoolean.h"

#import "ZNModelDefinitionAttribute.h"

@implementation ZNMSBoolean

#pragma mark Boxing

-(NSObject*)boxAttribute:(ZNModelDefinitionAttribute*)attribute
				inInstance:(ZNModel*)instance
			   forceString:(BOOL)forceString {
	BOOL value = *((BOOL*)((uint8_t*)instance +
						   ivar_getOffset([attribute runtimeIvar])));
	if (forceString)
		return value ? @"true" : @"false";
	else
		return [NSNumber numberWithBool:value];
}

-(void)unboxAttribute:(ZNModelDefinitionAttribute*)attribute
		 	 inInstance:(ZNModel*)instance
			       from:(NSObject*)boxedObject {
	BOOL value;
	if ([boxedObject isKindOfClass:[NSString class]]) {
		value = [(NSString*)boxedObject boolValue];
	}
	else if ([boxedObject isKindOfClass:[NSNumber class]]) {
		value = [(NSNumber*)boxedObject boolValue];
	}
	else
		value = NO;
	*((BOOL*)((uint8_t*)instance +
			  ivar_getOffset([attribute runtimeIvar]))) = value;
}

@end
