//
//  ZNAttributeType.m
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNMSAttributeType.h"

#import "ZNModelDefinitionAttribute.h"
#import "ZNMSRegistry.h"


@implementation ZNMSAttributeType

+(ZNMSAttributeType*)newTypeFromString:(const char*)encodedType {
	switch (*encodedType) {
		case '@':
			encodedType++;
			if (*encodedType == '"') {
				// class following the type
				if (!strncmp(encodedType, "\"NSString\"", 10))
					return [[ZNMSRegistry sharedRegistry] stringType];
				else if (!strncmp(encodedType, "\"NSDate\"", 8))
					return [[ZNMSRegistry sharedRegistry] dateType];
				else
					return nil;
			}
			else
				return [[ZNMSRegistry sharedRegistry] stringType];
		case 'c':
			return [[ZNMSRegistry sharedRegistry] booleanType];
		case 'd':
			return [[ZNMSRegistry sharedRegistry] doubleType];
		case 'i':
			return [[ZNMSRegistry sharedRegistry] integerType];
		case 'I':
			return [[ZNMSRegistry sharedRegistry] uintegerType];
		default:
			return nil;
	}
}

-(NSObject*)boxAttribute:(ZNModelDefinitionAttribute*)attribute
				inInstance:(ZNModel*)instance
			   forceString:(BOOL)forceString {
	NSAssert1(FALSE,
			  @"Attribute type %s did not implement -boxInstanceVar",
			  class_getName([self class]));
	return [NSNull null];
}

-(void)unboxAttribute:(ZNModelDefinitionAttribute*)attribute
			 inInstance:(ZNModel*)instance
				   from:(NSObject*)boxedObject {
	NSAssert1(FALSE,
			  @"Attribute type %s did not implement -unboxInstanceVar",
			  class_getName([self class]));
}

@end
