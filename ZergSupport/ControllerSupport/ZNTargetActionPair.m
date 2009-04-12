//
//  ZNTargetActionPair.m
//  ZergSupport
//
//  Created by Victor Costan on 1/28/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNTargetActionPair.h"


@implementation ZNTargetActionPair
@synthesize target, action;

-(id)initWithTarget:(id)theTarget action:(SEL)theAction {
  if ((self = [super init])) {
    target = theTarget;
    action = theAction;
  }
  return self;
}

-(void)dealloc {
  [super dealloc];
}

+(id)pairWithTarget:(id)theTarget action:(SEL)theAction {
  return [[[ZNTargetActionPair alloc] initWithTarget:theTarget
                                              action:theAction] autorelease];
}

-(void)perform {
  [target performSelector:action];
}

-(void)performWithObject:(id)object {
  [target performSelector:action withObject:object];
}

-(BOOL)isEqual:(id)other {
  if (!other || other->isa != self->isa)
    return NO;
  ZNTargetActionPair* otherPair = (ZNTargetActionPair*)other;
  if (target != otherPair->target || action != otherPair->action)
    return NO;
  return YES;
}

-(NSUInteger)hash {
  return (NSUInteger)target +(NSUInteger)action;
}
@end
