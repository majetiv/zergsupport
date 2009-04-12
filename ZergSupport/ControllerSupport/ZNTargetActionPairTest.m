//
//  ZNTargetActionCellTest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/28/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNTargetActionPair.h"

@interface ZNTargetActionPairTest : SenTestCase {
  BOOL invoked;
}

@end

static const NSString* kArgumentObject = @"Argument for TargetAction pair";

@implementation ZNTargetActionPairTest

-(void)setUp {
  invoked = NO;
}

-(void)testPlainInvoke {
  ZNTargetActionPair* pair = [[ZNTargetActionPair alloc]
                              initWithTarget:self
                              action:@selector(blankAction)];
  STAssertEquals(self, pair.target, @"Pair does not contain correct target");
  STAssertEquals(@selector(blankAction), pair.action,
                 @"Pair does not contain correct action");
  
  [pair perform];
  STAssertTrue(invoked, @"Pair did not invoke action");
  [pair release];
}

-(void)blankAction {
  invoked = YES;
}

-(void)testArgumentInvoke {
  ZNTargetActionPair* pair = [ZNTargetActionPair 
                              pairWithTarget:self
                              action:@selector(checkArgument:)];
  STAssertEquals(self, pair.target, @"Pair does not contain correct target");
  STAssertEquals(@selector(checkArgument:), pair.action,
                 @"Pair does not contain correct action");
  
  [pair performWithObject:kArgumentObject];
  STAssertTrue(invoked, @"Pair did not invoke action");  
}

-(void)checkArgument:(NSString*)argument {
  STAssertEqualObjects(kArgumentObject, argument, @"Incorrect argument received");
  invoked = YES;
}

@end
