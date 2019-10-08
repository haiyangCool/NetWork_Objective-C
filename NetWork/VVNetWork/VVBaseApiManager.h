//
//  VVBaseApiManager.h
//  NetWork
//
//  Created by 王海洋 on 2016/3/12.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVApiManagerDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface VVBaseApiManager : NSObject

@property (weak , nonatomic) id<VVAPIManagerDataCallBackDelegate> _Nullable dataDelegate;
@property (weak , nonatomic) id<VVAPIManagerService> _Nullable service;
@property (weak , nonatomic) id<VVAPIManagerValidator> _Nullable validator;
@property (weak , nonatomic) id<VVAPIManagerParamSource> _Nullable paramSource;
@property (weak , nonatomic) id<VVAPIManagerInterceptor> _Nullable interceptor;
@property (weak , nonatomic) NSObject<VVAPIManagerDelegate>* _Nullable childDelegate;

@property (assign , nonatomic, readonly) BOOL isLoading;
@property (assign , nonatomic) BOOL isLoadCache;
@property (assign , nonatomic, readwrite) VVAPIManagerCachePolicy cachePolicy;
@property (assign , nonatomic) NSTimeInterval memoryCacheTime;
@property (assign , nonatomic) NSTimeInterval diskCacheTime;
@property (strong , nonatomic, readonly) VVURLResponse *_Nonnull response;
@property (assign , nonatomic, readonly) VVAPIManagerErrorType errorType;
@property (copy , nonatomic, readonly) NSString *_Nonnull errorMsg;

// public methods
- (NSInteger) loadData;
- (NSInteger) loadDataWithParam :(NSDictionary *_Nonnull)param
                         success:(void (^)(VVBaseApiManager *_Nonnull apiManager))successCallBack
                          faild :(void (^) (VVBaseApiManager *_Nonnull apiManager))faildCallBack;

- (id _Nullable) fetchDataWithReformer :(id <VVAPIManagerDataReformer> _Nullable) reformer;

- (void) cancelAllRequest;
- (void) cancelRequestWithRequestId :(NSInteger)requestId;

// interceptor
- (BOOL) beforePerformCallApiWithParam :(NSDictionary *) param;
- (void) afterPerformCallApiWithParam  :(NSDictionary *) param;

- (BOOL) beforePerformCallSuccessWithResponse :(VVURLResponse *) response;
- (void) afterPerformCallSuccessWithResponse  :(VVURLResponse *) response;

- (BOOL) beforePerformCallFaildWithResponse :(VVURLResponse *) response;
- (void) afterPerformCallFaildWithResponse :(VVURLResponse *) response;

@end

NS_ASSUME_NONNULL_END
