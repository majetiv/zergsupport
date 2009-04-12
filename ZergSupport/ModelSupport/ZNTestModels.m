//
//  ZNTestModels.m
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNTestModels.h"

@implementation ZNTestParsing

@dynamic assign, copy, retain, ro_assign, ro_copy, ro_retain;
@dynamic bool_prop, date_prop, double_prop, integer_prop, string_prop;
@dynamic uinteger_prop;
@dynamic getter, setter, accessor;

@end

@implementation ZNTestProtocolDef

@dynamic win1, win2, win3, fail1, fail2;

@end

@implementation ZNTestDate
@synthesize pubDate;

-(void)dealloc {
	[pubDate release];
	[super dealloc];
}

@end

@implementation ZNTestNumbers
@synthesize trueVal, falseVal;
@synthesize doubleVal, integerVal, uintegerVal, stringVal;

-(void)dealloc {
	[stringVal release];
	[super dealloc];
}
@end
