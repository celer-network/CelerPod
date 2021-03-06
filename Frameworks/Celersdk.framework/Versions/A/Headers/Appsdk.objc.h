// Objective-C API for talking to github.com/celer-network/appservice/appsdk Go package.
//   gobind -lang=objc github.com/celer-network/appservice/appsdk
//
// File is generated by gobind. Do not edit.

#ifndef __Appsdk_H__
#define __Appsdk_H__

@import Foundation;
#include "Universe.objc.h"


@class AppsdkGroup;
@class AppsdkGroupClient;
@class AppsdkGroupResp;
@class AppsdkRoundResp;
@protocol AppsdkGroupCallback;
@class AppsdkGroupCallback;

@protocol AppsdkGroupCallback <NSObject>
- (void)onRecvGroup:(AppsdkGroupResp*)resp err:(NSString*)err;
@end

/**
 * Redefined proto types to comply with go bind interface
 */
@interface AppsdkGroup : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
- (NSString*)myId;
- (void)setMyId:(NSString*)v;
- (long)size;
- (void)setSize:(long)v;
- (NSString*)users;
- (void)setUsers:(NSString*)v;
- (NSString*)stake;
- (void)setStake:(NSString*)v;
- (long)code;
- (void)setCode:(long)v;
@end

@interface AppsdkGroupClient : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
/**
 * NewGroupClient connects to svr
 */
- (instancetype)init:(NSString*)svr ksjson:(NSString*)ksjson pass:(NSString*)pass cb:(id<AppsdkGroupCallback>)cb;
- (BOOL)createPrivate:(AppsdkGroup*)gr error:(NSError**)error;
- (BOOL)joinPrivate:(AppsdkGroup*)gr error:(NSError**)error;
- (BOOL)leave:(AppsdkGroup*)gr error:(NSError**)error;
- (BOOL)quickMatch:(AppsdkGroup*)gr error:(NSError**)error;
- (BOOL)rematch:(AppsdkGroup*)gr error:(NSError**)error;
@end

@interface AppsdkGroupResp : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
- (AppsdkGroup*)g;
- (void)setG:(AppsdkGroup*)v;
- (NSString*)ownerId;
- (void)setOwnerId:(NSString*)v;
- (AppsdkRoundResp*)round;
- (void)setRound:(AppsdkRoundResp*)v;
@end

@interface AppsdkRoundResp : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
- (int64_t)id_;
- (void)setID:(int64_t)v;
- (long)firstMoverIdx;
- (void)setFirstMoverIdx:(long)v;
@end

/**
 * NewGroupClient connects to svr
 */
FOUNDATION_EXPORT AppsdkGroupClient* AppsdkNewGroupClient(NSString* svr, NSString* ksjson, NSString* pass, id<AppsdkGroupCallback> cb, NSError** error);

@class AppsdkGroupCallback;

@interface AppsdkGroupCallback : NSObject <goSeqRefInterface, AppsdkGroupCallback> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (void)onRecvGroup:(AppsdkGroupResp*)resp err:(NSString*)err;
@end

#endif
