//
//  ZNSyncController.m
//  ZergSupport
//
//  Created by Victor Costan on 1/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <objc/runtime.h>

#import "ZNSyncController.h"

#import "ZNTargetActionPair.h"

@interface ZNSyncController ()
-(void)doScheduledSync;
-(BOOL)processResults:(NSObject*)results;
@end


@implementation ZNSyncController

@synthesize syncInterval, syncSite, lastSyncTime;

-(id)initWithErrorModelClass:(Class)theErrorModelClass
                  syncInterval:(NSTimeInterval)theSyncInterval {
  if ((self = [super init])) {
    errorModelClass = theErrorModelClass;
    syncInterval = theSyncInterval;
    needsSyncScheduling = NO;
    paused = NO;
    stopped = NO;
  }
  return self;
}

-(void)dealloc {
  [super dealloc];
}

-(void)startSyncing {
  stopped = NO;
  [self doScheduledSync];
}

-(void)stopSyncing {
  stopped = YES;
  paused = NO;
}

-(void)resumeSyncing {
  paused = NO;
  [self sync];
}

-(void)doScheduledSync {
  if (paused || stopped)
    return;
  
  needsSyncScheduling = YES;
  [self sync];
}

-(void)syncOnce {
  if (paused || stopped)
    return;
  [self sync];
}

-(BOOL)processResults:(NSObject*)results {
  if (![results isKindOfClass:[NSArray class]]) {
    // communication error -- try again later
    NSError* error = [results isKindOfClass:[NSError class]] ?
        (NSError*)results : nil;
    [self handleSystemError:error];
    return YES;
  }
  if ([(NSArray*)results count] == 1) {
    // check for service error
    ZNModel* maybeError = [(NSArray*)results objectAtIndex:0];
    if ([maybeError isKindOfClass:errorModelClass])
      return [self handleServiceError:(ZNModel*)maybeError];
  }
  if ([self integrateResults:(NSArray*)results]) {
    [lastSyncTime release];
    lastSyncTime = [[NSDate alloc] initWithTimeIntervalSinceNow:0.0];
    [syncSite perform];
    return YES;
  }
  else
    return NO;
}

-(void)receivedResults:(NSObject*)results {
  if ([self processResults:results]) {
    if (!paused && !stopped && needsSyncScheduling) {
      needsSyncScheduling = NO;
      [self performSelector:@selector(doScheduledSync)
                 withObject:nil
                 afterDelay:syncInterval];
    }
  }
  else
    paused = YES;
}


#pragma mark Subclass Methods.

-(void)sync {
  NSAssert1(NO, @"CacheController %s did not implement -integrateResults:",
            class_getName([self class]));  
}

-(BOOL)integrateResults:(NSArray*)results {
  NSAssert1(NO, @"CacheController %s did not implement -integrateResults:",
            class_getName([self class]));  
  return YES;
}
-(BOOL)handleServiceError:(ZNModel*)error {
  // by default assume service errors are temporary in nature
  return YES;
}
-(void)handleSystemError:(NSError*)error {
  return;
}

@end
