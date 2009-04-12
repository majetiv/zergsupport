//
//  SenTestCase+FixturesTest.m
//  ZergSupport
//
//  Created by Victor Costan on 2/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ModelSupport.h"


@interface ZNFixtureTestModel1 : ZNModel {
  NSString* name;
  double cash;
}
@property (nonatomic, retain) NSString* name;
@property (nonatomic) double cash;
@end

@implementation ZNFixtureTestModel1
@synthesize name, cash;
-(void)dealloc {
  [name release];
  [super dealloc];
}
@end

@interface ZNFixtureTestModel2 : ZNModel {
  BOOL nope;
}
@property (nonatomic) BOOL nope;
@end

@implementation ZNFixtureTestModel2
@synthesize nope;
@end


@interface SenTestCaseFixturesTest : SenTestCase
@end


@implementation SenTestCaseFixturesTest
-(void)testLoadFixtures {
  NSArray* loadedFixtures = [self fixturesFrom:@"SenTestCase+FixturesTest.xml"];
  
  STAssertEquals(3U, [loadedFixtures count],
                 @"Incorrect number of fixtures loaded");

  ZNFixtureTestModel1* fixture1 = [loadedFixtures objectAtIndex:0];
  STAssertTrue([fixture1 isKindOfClass:[ZNFixtureTestModel1 class]],
               @"Wrong model class instantiated for first fixture");
  STAssertEqualStrings(@"First Name", fixture1.name,
                       @"Wrong value for first fixture's string property");
  STAssertEqualsWithAccuracy(3.141592, fixture1.cash, 0.0000001,
                             @"Wrong value for first fixture's float property");
  
  ZNFixtureTestModel2* fixture2 = [loadedFixtures objectAtIndex:1];
  STAssertTrue([fixture2 isKindOfClass:[ZNFixtureTestModel2 class]],
               @"Wrong model class instantiated for second fixture");
  STAssertEquals(NO, fixture2.nope,
                 @"Wrong value for 2nd fixture's boolean property");

  ZNFixtureTestModel1* fixture3 = [loadedFixtures objectAtIndex:2];
  STAssertTrue([fixture3 isKindOfClass:[ZNFixtureTestModel1 class]],
               @"Wrong model class instantiated for third fixture");  
  STAssertEqualStrings(@"Third Name", fixture3.name,
                       @"Wrong value for third fixture's string property");
  STAssertEqualsWithAccuracy(1.0, fixture3.cash, 0.0000001,
                             @"Wrong value for 3rd fixture's float property");
}
@end
