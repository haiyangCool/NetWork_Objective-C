//
//  VVApiNetProxy.m
//  NetWork
//
//  Created by 王海洋 on 2016/3/12.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import "VVApiNetProxy.h"
#import "VVLog.h"
@interface VVApiNetProxy()
@property (strong , nonatomic) NSMutableDictionary *requestDic;
@end

@implementation VVApiNetProxy

+ (instancetype)shareInstance {
    
    static dispatch_once_t once_t ;
    static VVApiNetProxy *instance = nil;
    dispatch_once(&once_t, ^{
        instance = [[VVApiNetProxy alloc]init];
    });
    return instance;
}

- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(VVCallBack)success faild:(VVCallBack)faild {
    NSURLSession *session = [NSURLSession sharedSession];
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [session dataTaskWithRequest:request  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"data = %@, response = %@",data,response);
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSInteger requestId = (NSInteger)[dataTask taskIdentifier];
        VVURLResponse *vResponse = [[VVURLResponse alloc] initResponseWithDataString:dataString request:request requestId:requestId error:error];
        NSString *logStr = [VVLog logWithRequest:request responseMsg:dataString error:error];
        vResponse.log = logStr;
        if (error == nil) {
            success(vResponse);
        }else {
            faild(vResponse);
        }
        
    }];
    NSNumber *requestId = @([dataTask taskIdentifier]);
    [_requestDic setObject:dataTask forKey:requestId];
    [dataTask resume];
    return requestId;
}

- (void)cancelRequestByRequestId :(NSNumber *) requestId {
    
    NSURLSessionDataTask *dataTask = self.requestDic[requestId];
    [dataTask cancel];
    [self.requestDic removeObjectForKey:requestId];
}

- (void)cancelAllRequest {
    
    for (NSURLSessionDataTask *task in _requestDic) {
        [task cancel];
    }
    [self.requestDic removeAllObjects];
}

- (NSMutableDictionary *)requestDic {
    if (_requestDic == nil) {
        _requestDic = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return _requestDic;
}

@end
