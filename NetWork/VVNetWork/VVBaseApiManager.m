//
//  VVBaseApiManager.m
//  NetWork
//
//  Created by 王海洋 on 2016/3/12.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import "VVBaseApiManager.h"
#import "VVCacheCenter.h"
#import "VVApiNetProxy.h"
#import "VVLog.h"
#import "Reachability.h"
@interface VVBaseApiManager()

@property (assign , nonatomic , readwrite) BOOL isLoading;
@property (copy , nonatomic, readwrite) NSString *errorMsg;
@property (strong , nonatomic, readwrite) VVURLResponse *response;
@property (strong , nonatomic) NSMutableArray *requestList;
@property (assign , nonatomic) VVAPIManagerErrorType errorType;

@property (strong , nonatomic , nullable) void (^successBlock) (VVBaseApiManager * apiManager);
@property (strong, nonatomic, nullable) void (^faildBlock) (VVBaseApiManager *apiManager);


@end
@implementation VVBaseApiManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.paramSource = nil;
        self.validator = nil;
        self.childDelegate = nil;
        self.dataDelegate = nil;
        self.interceptor = nil;
        self.service = nil;
        self.response = nil;
        self.isLoading = false;
        self.isLoadCache = true;
        self.memoryCacheTime = 1 * 60;
        self.diskCacheTime = 2 * 60;
        self.errorMsg = @"";
        
        if ([self conformsToProtocol:@protocol(VVAPIManagerDelegate) ]) {
            self.childDelegate = (id <VVAPIManagerDelegate>) self;
            self.service = [self.childDelegate service];
        }else {
            @throw [[NSException alloc]init];
        }
    }
    return self;
}

#pragma mark public methods
- (id)fetchDataWithReformer:(id<VVAPIManagerDataReformer>)reformer {
    if ([reformer respondsToSelector:@selector(reformerData:manager:)]) {
        return [reformer reformerData:self.response.content manager:self];
    }
    return self.response.responseData;
}
- (NSInteger)loadData {
    
    NSDictionary *param = [self.paramSource paramsterForApi:self];
    return [self loadDataWithParam:param];
}
- (NSInteger)loadDataWithParam:(NSDictionary *)param success:(void (^)(VVBaseApiManager * _Nonnull))successCallBack faild:(void (^)(VVBaseApiManager * _Nonnull))faildCallBack {
    self.successBlock = successCallBack;
    self.faildBlock = faildCallBack;
    return [self loadDataWithParam:param];
}
- (void)cancelAllRequest {
    
    for (NSNumber *rid in self.requestList) {
        [[VVApiNetProxy shareInstance] cancelRequestByRequestId:rid];
    }
}
- (void)cancelRequestWithRequestId:(NSInteger)requestId {
    
    [[VVApiNetProxy shareInstance] cancelRequestByRequestId:@(requestId)];
}

- (NSInteger) loadDataWithParam :(NSDictionary *)param {
    
    if (self.isLoading == true) {
        return 0;
    }
    NSDictionary *reformParam = param;
    if ([self.childDelegate respondsToSelector:@selector(reformerData:manager:)]) {
        reformParam = [self.childDelegate reformParam:param];
    }
    
    // 通过拦截期检测
    if ([self beforePerformCallApiWithParam:reformParam]) {
        
        VVAPIManagerErrorType errorType = [self.validator validatorParam:param manager:self];
        if (errorType == VVErrorTypeNoError) {
            
            // 缓存
            VVURLResponse *vResponse = nil;
            if (self.isLoadCache) {
                
                if ((self.cachePolicy == VVMemoryCache)) {
                    vResponse = [self fetchMemroyCacheWithParam:reformParam];
                }
                if ((self.cachePolicy == VVDiskCacha)) {
                    if (vResponse == nil) {
                        vResponse = [self fetchDiskCacheWithParam:reformParam];
                    }
                }
            }
            
            if (vResponse != nil) {
                [self successCallApiWithResponse:vResponse];
                return 0;
            }
            
            // net is Reacheable , call Api
            if ([self netIsReachable]) {
                self.isLoading = true;
                NSURLRequest *reuqest = [self.service requestWithApiAddress:self.childDelegate.methodName  param:reformParam  requestType:self.childDelegate.requestType];
                
                NSNumber *requestId = [[VVApiNetProxy shareInstance] callApiWithRequest:reuqest success:^(VVURLResponse * _Nonnull response) {
                    [self successCallApiWithResponse:response];
                } faild:^(VVURLResponse * _Nonnull response) {
                    // 转换错误信息
                    VVAPIManagerErrorType errType = VVErrorTypeDefaultError;
                    if (response.statue == VVURLResponseNetException) {
                        errType = VVErrorTypeNetNotReach;
                    }
                    if (response.statue == VVURLResponseCancelRequest) {
                        errType = VVErrorTypeCancelRequest;
                    }
                    if (response.statue == VVURLResponseRequestTimeout) {
                        errType = VVErrorTypeRequestTimeOut;
                    }
                    if (response.statue == VVURLResponseDNSLookupFailed) {
                        errType = VVErrorTypeDNSFoundFaild;
                    }
                    [self faildCallApiWithResonse:response errorType:errType];
                    
                }];
                [self.requestList addObject:requestId];
                
                NSMutableDictionary *param = [reformParam mutableCopy];
                param[@"RequestID"] = requestId;
                [self afterPerformCallApiWithParam:param];
                return [requestId integerValue];
                
            }else {
                [self faildCallApiWithResonse:nil errorType:VVErrorTypeNetNotReach];
                return 0;
            }
            
        }else {
            [self faildCallApiWithResonse:nil errorType:VVErrorTypeParamNotCorrect];
            return 0;
        }
        
    }
    return 0;
}


#pragma Mark Private Methods
/**
 SuccessFull call Api

 @param response VVURLResponse
 */
- (void) successCallApiWithResponse :(VVURLResponse *) response {
    
    self.isLoading = false;
    self.response = response;
    // response validator
    VVAPIManagerErrorType eType = [self.validator validatorResponse:response manager:self];
    if (eType == VVErrorTypeNoError) {
        
        if (self.cachePolicy != VVNoCache && response.isCache == NO) {
            if ((self.cachePolicy == VVMemoryCache)) {
                [[VVCacheCenter shareInstance] saveCacheByMemoryWithResponse:response serviceIdentifier:self.childDelegate.requestServiceIdentifier apiName:self.childDelegate.methodName param:[self.paramSource paramsterForApi:self] cacheTime:self.memoryCacheTime];
            }
            if ((self.cachePolicy == VVDiskCacha)) {
                [[VVCacheCenter shareInstance] saveCacheDiskWithResponse:response serviceIdentifier:self.childDelegate.requestServiceIdentifier apiName:self.childDelegate.methodName param:[self.paramSource paramsterForApi:self] cacheTime:self.diskCacheTime];
            }
        }
        
        NSString *rt = [NSString stringWithFormat:@"%lu",self.childDelegate.requestType];
        NSString *logStr = [VVLog logWithService:self.service apiName:self.childDelegate.methodName param:[self.paramSource paramsterForApi:self] requestType:rt response:self.response errorType:@"NO ERROR(SUCCESS)"];
        self.response.log = logStr;
        
        // befor call success
        if ([self beforePerformCallSuccessWithResponse:response]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.dataDelegate respondsToSelector:@selector(managerCallApiSuccess:)]) {
                    [self.dataDelegate managerCallApiSuccess:self];
                }
                if (self.successBlock) {
                    self.successBlock(self);
                }
            });
        }
    
        [self afterPerformCallSuccessWithResponse:response];
        
    }else {
        // response validator faild
        [self faildCallApiWithResonse:response errorType:VVErrorTypeResponseNotCorrect];
    }
}

/**
 Faild call Api

 @param response VVURLResponse
 */
- (void) faildCallApiWithResonse :(VVURLResponse *) response errorType :(VVAPIManagerErrorType)type{
    
    self.isLoading = false;
    self.response = response;
    self.errorType = type;
    [self cancelRequestWithRequestId:response.requestId];
    self.errorMsg = [self errInfoWithErrorType:self.errorType];
    NSString *rt = [NSString stringWithFormat:@"%lu",self.childDelegate.requestType];
    NSString *logStr = [VVLog logWithService:self.service apiName:self.childDelegate.methodName param:[self.paramSource paramsterForApi:self] requestType:rt response:self.response errorType:self.errorMsg];
    self.response.log = logStr;
    BOOL isHanlde = [self.service handleApiFaild:self.errorType manager:self];
    if (isHanlde) {
        return;
    }else {
        // 业务层继续处理
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 拦截器是否对错误进行拦截
            BOOL isIntercpt = [self beforePerformCallFaildWithResponse:self.response];
            if (!isIntercpt) {
                return ;
            }
            if ([self.dataDelegate respondsToSelector:@selector(managerCallApiFaild:)]) {
                [self.dataDelegate managerCallApiFaild:self];
            }
            if (self.faildBlock) {
                self.faildBlock(self);
            }
            [self afterPerformCallFaildWithResponse:self.response];
        });
        
    }
}
/**
 net is useable

 @return boolean
 */
- (BOOL) netIsReachable {
    Reachability *reachablity = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachablity currentReachabilityStatus];
    if (netStatus == ReachableViaWiFi || netStatus == ReachableViaWWAN) {
        return true;
    }
    return false;
}

- (NSString *) errInfoWithErrorType :(VVAPIManagerErrorType) type {
    NSString *err = @"";
    switch (type) {
        case VVErrorTypeNoError:
            err = @"没有错误";
            break;
        case VVErrorTypeNeedLogin:
            err = @"需要登录";
            break;
        case VVErrorTypeLackAccessToken:
            err = @"Token过期";
            break;
        case VVErrorTypeNetNotReach:
            err = @"网络访问错误";
            break;
        case VVErrorTypeParamNotCorrect:
             err = @"参数错误";
            break;
        case VVErrorTypeRequestTimeOut:
            err = @"请求超时";
            break;
        case VVErrorTypeResponseNotCorrect:
            err = @"数据错误";
            break;
        case VVErrorTypeResponseDecodeFaild:
            err = @"数据解析错误";
            break;
        case VVErrorTypeDNSFoundFaild:
            err = @"DNS解析错误";
            break;
        case VVErrorTypeCancelRequest:
            err = @"请求被取消";
            break;

        default:
            err = @"Default";
            break;
    }
    return err;
}

/**
 Memory Cache

 @param param p
 @return VVResponse or nil . nil if cache is nil or out of time
 */
- (VVURLResponse *_Nullable) fetchMemroyCacheWithParam :(NSDictionary *)param {
    
    return [[VVCacheCenter shareInstance] fetchMemoryCacheWithServiceIdentifier:self.childDelegate.requestServiceIdentifier apiName:self.childDelegate.methodName param:param];
}


/**
 Disk Cache

 @param param p
 @return VVResponse or nil. nil  if cache is nil or cache be delete
 */
- (VVURLResponse *_Nullable) fetchDiskCacheWithParam :(NSDictionary *) param {
    return [[VVCacheCenter shareInstance] fetchDiskCacheWithServiceIdentifier:self.childDelegate.requestServiceIdentifier apiName:self.childDelegate.methodName param:param];
}

/**
 Request List

 @return Request List
 */
- (NSMutableArray *)requestList {
    if (_requestList == nil) {
        _requestList = [NSMutableArray arrayWithCapacity:1];
    }
    return _requestList;
}

// interceptor

- (BOOL)beforePerformCallApiWithParam:(NSDictionary *)param {
    if ([self.interceptor respondsToSelector:@selector(beforePerformCallApiWithParam:)]) {
        return [self.interceptor beforePerformCallApiWithParam:param manager:self];
    }else {
        return true;
    }
}

- (void)afterPerformCallApiWithParam:(NSDictionary *)param {
    if ([self.interceptor respondsToSelector:@selector(afterPerformCallApiWithParam:)]) {
        [self.interceptor afterPerformCallApiWithParam:param manager:self];
    }
}


- (BOOL)beforePerformCallSuccessWithResponse:(VVURLResponse *)response {
    if ([self.interceptor beforePerformCallSuccessWithResponse:response manager:self]) {
       return  [self.interceptor beforePerformCallSuccessWithResponse:response manager:self];
    }else {
        return true;
    }
}


- (void)afterPerformCallSuccessWithResponse:(VVURLResponse *)response {
    if ([self.interceptor respondsToSelector:@selector(afterPerformCallSuccessWithResponse:manager:)]) {
        [self.interceptor afterPerformCallSuccessWithResponse:response manager:self];
    }
}

- (BOOL)beforePerformCallFaildWithResponse:(VVURLResponse *)response {
    
    if ([self.interceptor respondsToSelector:@selector(beforePerformCallFaildWithResponse:manager:)]) {
        return [self.interceptor beforePerformCallFaildWithResponse:response manager:self];
    }else {
        return true;
    }
}

- (void)afterPerformCallFaildWithResponse:(VVURLResponse *)response {
    
    if ([self.interceptor respondsToSelector:@selector(afterPerformCallFaildWithResponse:manager:)]) {
        [self.interceptor afterPerformCallFaildWithResponse:response manager:self];
    }
}
@end
