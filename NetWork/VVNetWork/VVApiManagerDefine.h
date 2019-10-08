//
//  VVApiManaferDefine.h
//  NetWork
//
//  Created by 王海洋 on 2016/3/12.
//  Copyright © 2019 王海洋. All rights reserved.
//

#ifndef VVApiManaferDefine_h
#define VVApiManaferDefine_h
#import <UIKit/UIKit.h>

@class VVBaseApiManager;
@class VVURLResponse;
/* 请求方式*/
typedef NS_ENUM(NSUInteger, VVAPIManagerRequestType) {
    VVRequestTypeGET,
    VVRequestTypePUT,
    VVRequestTypePOST,
    VVRequestTypeDELETE
};

/* 环境*/
typedef NS_ENUM(NSUInteger, VVAPIManagerServiceEnvironment) {
    VVEnvironmentDevelop,
    VVEnvironmentRelease
    
};

/* api 请求失败原因*/
typedef NS_ENUM(NSUInteger, VVAPIManagerErrorType) {
    VVErrorTypeDefaultError,
    VVErrorTypeLackAccessToken,
    VVErrorTypeNeedLogin,
    VVErrorTypeNetNotReach,
    VVErrorTypeRequestTimeOut,
    VVErrorTypeResponseNotCorrect,
    VVErrorTypeResponseDecodeFaild,
    VVErrorTypeParamNotCorrect,
    VVErrorTypeCancelRequest,
    VVErrorTypeDNSFoundFaild,
    VVErrorTypeNoError
};

typedef NS_ENUM(NSUInteger, VVURLResponseStatue) {
  
    VVURLResponseSuccess,
    VVURLResponseNetException,
    VVURLResponseRequestTimeout,
    VVURLResponseCancelRequest,
    VVURLResponseDNSLookupFailed
};

/* 缓存策略*/
typedef NS_OPTIONS(NSUInteger, VVAPIManagerCachePolicy) {
    VVMemoryCache,
    VVDiskCacha,
    VVNoCache,
};

/* 服务方*/
@protocol VVAPIManagerService <NSObject>

@property (copy, nonatomic) NSString *_Nullable methodName;
@property (copy, nonatomic) NSString *_Nullable methodType;
@property (copy, nonatomic) NSDictionary *_Nullable param;
@property (copy, nonatomic) NSString *_Nullable envirormentMsg;

@required
- (NSURLRequest *_Nonnull) requestWithApiAddress :(NSString *_Nonnull) apiAddress param :(NSDictionary *_Nullable) param requestType :(VVAPIManagerRequestType) type;
- (VVAPIManagerServiceEnvironment) environment;
- (NSString *_Nonnull) serviceBaseUrl :(VVAPIManagerServiceEnvironment) environment;
- (BOOL) handleApiFaild :(VVAPIManagerErrorType) type manager :(VVBaseApiManager *_Nonnull) apiManager;

@end

/* Child*/
@protocol VVAPIManagerDelegate <NSObject>

@required

- (NSString *_Nonnull) methodName;
- (NSString *_Nonnull) requestServiceIdentifier;
- (VVAPIManagerRequestType) requestType;
- (id <VVAPIManagerService> _Nonnull) service;

@optional
- (void)cleadData;
- (NSDictionary *_Nullable) reformParam :(NSDictionary *_Nullable) param;
- (NSInteger) loadDataWithParam :(NSDictionary *_Nonnull) param;

@end

/* 参数*/
@protocol VVAPIManagerParamSource <NSObject>

@optional
- (NSDictionary *_Nonnull) paramsterForApi :(VVBaseApiManager *_Nonnull) apiManager;

@end

/* 验证*/
@protocol VVAPIManagerValidator <NSObject>

@required
- (VVAPIManagerErrorType) validatorResponse :(VVURLResponse *_Nonnull) response manager :(VVBaseApiManager *_Nonnull) apiManager;
- (VVAPIManagerErrorType) validatorParam :(NSDictionary *_Nullable) param manager:(VVBaseApiManager * _Nonnull) apiManager;

@end
/* Reformer*/
@protocol VVAPIManagerDataReformer <NSObject>

@required
- (id _Nullable) reformerData :(NSDictionary *_Nonnull)dictionary manager :(VVBaseApiManager *_Nonnull) apiManager;
@end
/*  数据回调*/
@protocol VVAPIManagerDataCallBackDelegate <NSObject>

@required
- (void) managerCallApiSuccess :(VVBaseApiManager *_Nonnull) apiManager;
- (void) managerCallApiFaild :(VVBaseApiManager *_Nonnull) apiManager;
@end

/* 拦截器*/
@protocol VVAPIManagerInterceptor <NSObject>

@optional
// request 执行前
- (BOOL) beforePerformCallApiWithParam :(NSDictionary *_Nullable) param manager :(VVBaseApiManager *_Nonnull) apiManager;
- (void) afterPerformCallApiWithParam :(NSDictionary *_Nullable) param manager :(VVBaseApiManager *_Nonnull) apiManager;

// success
- (BOOL) beforePerformCallSuccessWithResponse :(VVURLResponse *_Nonnull) response manager :(VVBaseApiManager *_Nonnull) apiManager;
- (void) afterPerformCallSuccessWithResponse :(VVURLResponse *_Nonnull) response manager :(VVBaseApiManager *_Nonnull) apiManager;

// faild
- (BOOL) beforePerformCallFaildWithResponse :(VVURLResponse *_Nonnull) response manager :(VVBaseApiManager *_Nonnull) apiManager;
- (void) afterPerformCallFaildWithResponse :(VVURLResponse *_Nonnull) response manager :(VVBaseApiManager *_Nonnull) apiManager;



@end

#endif /* VVApiManaferDefine_h */
