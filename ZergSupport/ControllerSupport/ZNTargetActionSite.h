//
//  ZNTargetActionSite.h
//  ZergSupport
//
//  Created by Victor Costan on 1/28/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

// A poor man's closure.
@protocol ZNTargetActionSite

// Performs the actions on the targets.
-(void)perform;

// Performs the actions on the targets, supplying an argument.
-(void)performWithObject:(id)object;
@end
