//
//  ZNMSRegistryTest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/14/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"
#import "ZNTestModels.h"

#import "ZNModelDefinition.h"
#import "ZNMSRegistry.h"

@interface ZNMSRegistryTest: SenTestCase {
	ZNMSRegistry* registry;
}
@end

@implementation ZNMSRegistryTest

-(void)setUp {
	registry = [[ZNMSRegistry alloc] init];
}

-(void)tearDown {
	[registry release];
}

-(void)dealloc {
	[super dealloc];
}

-(void)testNamedClassRegistration {
	ZNModelDefinition *defn =
	   [registry definitionForModelClassNamed:@"ZNTestParsing"];
	
	STAssertEqualStrings(@"ZNTestParsing", [defn name],
	                     @"Registering named model located wrong class");						 
	STAssertEquals(15U, [defn.attributes count],
				   @"Registering named model definition located wrong class");	
}

-(void)testObjectClassRegistration {
	ZNModelDefinition *defn =
	    [registry definitionForModelClass:[ZNTestParsing class]];
	
	STAssertEqualStrings(@"ZNTestParsing", [defn name],
	                     @"Registering named model located wrong class");						 
	STAssertEquals(15U, [defn.attributes count],
				   @"Registering named model definition located wrong class");	
}

-(void)testRegistrationCachesDefinitions {
	STAssertEquals([registry definitionForModelClassNamed:@"ZNTestParsing"],
				   [registry definitionForModelClass:[ZNTestParsing class]],
				   @"Looking up same class twice gave different definitions");
}

@end