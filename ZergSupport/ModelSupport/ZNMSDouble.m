//
//  ZNMSDouble.m
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNMSDouble.h"

#import "ZNModelDefinitionAttribute.h"

@implementation ZNMSDouble

#pragma mark Boxing

-(NSObject*)boxAttribute:(ZNModelDefinitionAttribute*)attribute
				inInstance:(ZNModel*)instance
			   forceString:(BOOL)forceString {
	double value = *((double*)((uint8_t*)instance +
							   ivar_getOffset([attribute runtimeIvar])));
	if (forceString)
		return [NSString stringWithFormat:@"%f", value];
	else
		return [NSNumber numberWithDouble:value];
}

-(void)unboxAttribute:(ZNModelDefinitionAttribute*)attribute
		 	 inInstance:(ZNModel*)instance
			       from:(NSObject*)boxedObject {
	double value;
	if ([boxedObject isKindOfClass:[NSString class]])
		value = [(NSString*)boxedObject doubleValue];
	else if ([boxedObject isKindOfClass:[NSNumber class]]) {
		value = [(NSNumber*)boxedObject doubleValue];
	}
	else
		value = 0.0;
	*((double*)((uint8_t*)instance + ivar_getOffset([attribute runtimeIvar]))) =
	    value;
}

@end
