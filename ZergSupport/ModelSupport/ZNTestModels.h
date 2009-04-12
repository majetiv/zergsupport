//
//  ZNTestModels.h
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

// This file contains test models. It should not be used outside testing.

#import "ZNModel.h"

@interface ZNTestParsing : NSObject {
}

// setter strategies

@property (nonatomic, assign) NSString* assign;
@property (copy) NSString* copy;
@property (nonatomic, retain) NSString* retain;
@property (readonly, assign) NSString* ro_assign;
@property (nonatomic, readonly, copy) NSString* ro_copy;
@property (readonly, retain) NSString* ro_retain;

// types

@property (nonatomic) BOOL bool_prop;
@property (nonatomic, copy) NSDate* date_prop;
@property (nonatomic) double double_prop;
@property (nonatomic) NSInteger integer_prop;
@property (nonatomic) NSUInteger uinteger_prop;
@property (nonatomic, retain) NSString* string_prop;

// custom getter / setter

@property (nonatomic, getter=get_pwn, retain) NSString* getter;
@property (nonatomic, setter=set_pwn:, retain) NSString* setter;
@property (getter=superpwn, setter=superpwn:, retain) NSString*
    accessor;

@end

@protocol ZNTestProtocolDef_ZNMS

@property (nonatomic) NSUInteger win1; 
@property (nonatomic) NSUInteger win2; 
@property (nonatomic) NSUInteger win3; 

@end


@interface ZNTestProtocolDef : NSObject <ZNTestProtocolDef_ZNMS>

@property (nonatomic) NSUInteger fail1, fail2;

@end


@interface ZNTestDate : ZNModel {
	NSDate* pubDate;
}

@property (nonatomic, retain) NSDate* pubDate;

@end

@interface ZNTestNumbers : ZNModel {
	BOOL trueVal, falseVal;
	double doubleVal;
	NSInteger integerVal;
	NSUInteger uintegerVal;
	NSString* stringVal;
}

@property (nonatomic) BOOL trueVal, falseVal;
@property (nonatomic) double doubleVal;
@property (nonatomic) NSInteger integerVal;
@property (nonatomic) NSUInteger uintegerVal;
@property (nonatomic, retain) NSString* stringVal;

@end

@protocol ZNTestModel_ZNMS
@end

@interface ZNTestModelWithProtocol : NSObject<ZNTestModel_ZNMS>
@end