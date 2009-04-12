//
//  ZNTargetActionSetTest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/28/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "TestSupport.h"

#import "ZNTargetActionSet.h"

@interface ZNTargetActionSetTest : SenTestCase {
  ZNTargetActionSet* cell;
  BOOL invokedOne;
  BOOL invokedTwo;
  BOOL invokedThree;
}
@end

static const NSString* kArgumentObject = @"Action argument";

@implementation ZNTargetActionSetTest

-(void)one {
  invokedOne = YES;
}
-(void)two {
  invokedTwo = YES;
}
-(void)three {
  invokedThree = YES;
}
-(void)checkStateOne:(BOOL)expectedOne
                  two:(BOOL)expectedTwo
                three:(BOOL)expectedThree {
  STAssertEquals(expectedOne, invokedOne,
                 @"-one wasn't invoked as expected");
  STAssertEquals(expectedTwo, invokedTwo,
                 @"-two wasn't invoked as expected");
  STAssertEquals(expectedThree, invokedThree,
                 @"-three wasn't invoked as expected");
}

-(void)setUp {
  cell = [[ZNTargetActionSet alloc] init];
  invokedOne = NO;
  invokedTwo = NO;
  invokedThree = NO;
}
-(void)tearDown {
  [cell release];
}
-(void)dealloc {
  [super dealloc];
}

-(void)testEmptyCell {
  [cell perform];
  [self checkStateOne:NO two:NO three:NO];
}

-(void)testAdds {
  [cell perform];
  [cell addTarget:self action:@selector(one)];
  [cell addTarget:self action:@selector(three)];
  [cell perform];
  [self checkStateOne:YES two:NO three:YES];
}

-(void)testAddsAndRemoves {
  [cell perform];
  [cell addTarget:self action:@selector(one)];
  [cell addTarget:self action:@selector(two)];
  [cell addTarget:self action:@selector(three)];
  [cell removeTarget:self action:@selector(one)];
  [cell perform];
  [self checkStateOne:NO two:YES three:YES];
}

-(void)testArguments {
  [cell perform];
  [cell addTarget:self action:@selector(checkArgument:)];
  [cell performWithObject:kArgumentObject];
  [self checkStateOne:YES two:NO three:NO];
}

-(void)checkArgument:(NSString*)argument {
  NSLog(@"Argument: %@\n", argument);
  
  STAssertEqualObjects(kArgumentObject, argument, @"Incorrect argument received");
  invokedOne = YES;
}

@end
