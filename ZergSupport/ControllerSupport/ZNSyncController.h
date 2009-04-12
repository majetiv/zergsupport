//
//  ZNSyncController.h
//  ZergSupport
//
//  Created by Victor Costan on 1/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>

@class ZNModel;
@protocol ZNTargetActionSite;

// Generic superclass for controllers that synchronize some cached data with a
// server periodically, using a communication controller.
@interface ZNSyncController : NSObject {
  Class errorModelClass;
  NSTimeInterval syncInterval;
  id<ZNTargetActionSite> syncSite;
  NSDate* lastSyncTime;

 @private
  BOOL needsSyncScheduling;
  BOOL paused;
  BOOL stopped;
}

// The most recent time that a sync succeeded. nil means 'never'.
@property (nonatomic, readonly, retain) NSDate* lastSyncTime;
// The interval between synchronization attempts.
@property (nonatomic) NSTimeInterval syncInterval;
// Site that gets activated when a sync succeeds.
@property (nonatomic, retain) id<ZNTargetActionSite> syncSite;

// Designated initializer.
-(id)initWithErrorModelClass:(Class)errorModelClass
                  syncInterval:(NSTimeInterval)syncInterval;

// Called by cache clients to start the periodic syncing.
-(void)startSyncing;

// Called by cache clients to stop the periodic syncing.
-(void)stopSyncing;

// Called by cache clients to force a one-time sync.
-(void)syncOnce;

// Subclasses should configure their communication controllers to invoke this
// method to report results.
-(void)receivedResults:(NSObject*)results;

// Subclasses should override this method to issue a communication request.
-(void)sync;

// Subclasses should override this method to update the cache. Implementations
// can return NO to indicate an error has occured, and periodic syncing should
// stop. In that case, implementations must call -resumeSyncing to resume
// periodic syncing once the error is handled.
-(BOOL)integrateResults:(NSArray*)results;

// Subclasses can override this method to handle an error returned by the
// service. The return value has the same semantics as for the
// -integrateResults: method.
-(BOOL)handleServiceError:(ZNModel*)error;

// Subclasses should override this method to handle a system error.
-(void)handleSystemError:(NSError*)error;

// Called by subclasses to resume periodic syncing stopped when
// -integrateResults: returns false.
-(void)resumeSyncing;

@end
