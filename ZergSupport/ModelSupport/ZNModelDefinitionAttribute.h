//
//  ZNModelDefinitionAttribute.h
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>

enum ZNPropertySetterStrategy {
	kZNPropertyWantsAssign = 0,
	kZNPropertyWantsCopy = 1,
	kZNPropertyWantsRetain = 2,
};

@class ZNMSAttributeType;

@interface ZNModelDefinitionAttribute : NSObject {
	NSString* name;
	NSString* getterName;
	NSString* setterName;
	ZNMSAttributeType* type;
	Ivar runtimeIvar;
	BOOL isAtomic;
	BOOL isReadOnly;
	enum ZNPropertySetterStrategy setterStrategy;
}

@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* getterName;
@property (nonatomic, readonly) NSString* setterName;
@property (nonatomic, readonly) ZNMSAttributeType* type;
@property (nonatomic, readonly) Ivar runtimeIvar;
@property (nonatomic, readonly) BOOL isAtomic;
@property (nonatomic, readonly) BOOL isReadOnly;
@property (nonatomic, readonly) enum ZNPropertySetterStrategy setterStrategy;

+(ZNModelDefinitionAttribute*)newAttributeFromProperty:(objc_property_t)property
												 ofClass:(Class)klass;
@end
