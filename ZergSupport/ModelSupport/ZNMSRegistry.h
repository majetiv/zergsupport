//
//  ZNMSAttributeTypes.h
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

@class ZNModelDefinition;
@class ZNMSAttributeType;

@interface ZNMSRegistry : NSObject {
	ZNMSAttributeType* booleanType;
	ZNMSAttributeType* dateType;
	ZNMSAttributeType* doubleType;
	ZNMSAttributeType* integerType;
	ZNMSAttributeType* stringType;
	ZNMSAttributeType* uintegerType;
	
	NSMutableDictionary* modelDefinitions;
}

@property (nonatomic, readonly) ZNMSAttributeType* booleanType;
@property (nonatomic, readonly) ZNMSAttributeType* dateType;
@property (nonatomic, readonly) ZNMSAttributeType* doubleType;
@property (nonatomic, readonly) ZNMSAttributeType* integerType;
@property (nonatomic, readonly) ZNMSAttributeType* stringType;
@property (nonatomic, readonly) ZNMSAttributeType* uintegerType;

-(ZNModelDefinition*)definitionForModelClass:(Class)klass;

-(ZNModelDefinition*)definitionForModelClassNamed:(NSString*)className;

// The singleton ZNMSRegistry instance.
+(ZNMSRegistry*)sharedRegistry;

@end
