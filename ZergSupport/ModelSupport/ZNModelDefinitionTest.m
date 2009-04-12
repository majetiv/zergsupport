//
//  ZNModelDefinitionTest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"
#import "ZNTestModels.h"

#import "ZNModelDefinitionAttribute.h"
#import "ZNModelDefinition.h"

@interface ZNModelDefinitionTest : SenTestCase {
}
@end

@implementation ZNModelDefinitionTest

-(void)testDefinitionUsesProtocol {
	ZNModelDefinition *defn = [[ZNModelDefinition
							    newDefinitionForClass:[ZNTestProtocolDef class]]
							   autorelease];
	STAssertEquals(3U, [defn.attributes count],
				   @"Parsing metadata for model using protocol - method count");

	STAssertNotNil([defn attributeNamed:@"win1"],
				   @"Parsing metadata for model using protocol - has win1");
	STAssertNotNil([defn attributeNamed:@"win2"],
				   @"Parsing metadata for model using protocol - has win2");
	STAssertNotNil([defn attributeNamed:@"win3"],
				   @"Parsing metadata for model using protocol - has win3");
}

-(void)testDefinitionFallsBackToClass {
	ZNModelDefinition *defn = [[ZNModelDefinition
							    newDefinitionForClass:[ZNTestParsing class]]
							   autorelease];
	STAssertEquals(15U, [defn.attributes count],
				   @"Parsing metadata for model using class - method count");
	
	ZNModelDefinitionAttribute* prop = [defn attributeNamed:@"ro_copy"];
	STAssertEqualStrings(@"ro_copy", [prop name], @"Attribute matches name");
	STAssertEquals(kZNPropertyWantsCopy, [prop setterStrategy],
				   @"Attribute matches name");
	STAssertEquals(YES, [prop isReadOnly], @"Attribute matches name");
}

@end
