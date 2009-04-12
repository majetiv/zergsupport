//
//  ZNTargetActionPair.h
//  ZergSupport
//
//  Created by Victor Costan on 1/28/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

#import "ZNTargetActionSite.h"

// Wraps a target and an action to be invoked on the target.
//
// Intended to come in handy for senders in the Target-Action paradigm.
// Target-Action pairs are immutable, and implement -hash and -isEquals:, so
// they can be added to sets.
@interface ZNTargetActionPair : NSObject <ZNTargetActionSite> {
  id target;
  SEL action;
}
@property (nonatomic, readonly, assign) id target;
@property (nonatomic, readonly, assign) SEL action;

// Designated initializer.
-(id)initWithTarget:(id)target action:(SEL)action;

// Creates a new cell that goes to the autorelease pool.
+(id)pairWithTarget:(id)target action:(SEL)action;

@end
