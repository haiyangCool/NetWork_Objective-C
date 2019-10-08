//
//  DemoService.m
//  NetWork
//
//  Created by 王海洋 on 2019/6/17.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import "DemoService.h"

@interface DemoService()
@property (strong, nonatomic) NSURLRequest *request;
//@property (assign , nonatomic) VVAPIManagerServiceEnvironment environment;
@end
@implementation DemoService

@synthesize envirormentMsg;
@synthesize methodType;
@synthesize param;
@synthesize methodName;

- (instancetype) initWithApiAddress:(NSString *)apiAddress param:(NSDictionary *)param requestType:(VVAPIManagerRequestType)type {

    self = [super init];
    if (self) {
        self.request = [self requestWithApiAddress:apiAddress param:param requestType:type];
    }
    return self;
}


- (NSURLRequest *)requestWithApiAddress:(NSString *)apiAddress param:(NSDictionary *)param requestType:(VVAPIManagerRequestType)type {
    return [self generatorRequestWithRequestType:type apiAddress:apiAddress param:param];
}

- (BOOL)handleApiFaild:(VVAPIManagerErrorType)type manager:(VVBaseApiManager *)apiManager {
    
    return false;
}

- (NSString *) serviceBaseUrl :(VVAPIManagerServiceEnvironment) environment {
    if (environment == VVEnvironmentDevelop) {
        return @"http://api.app.pthv.gitv.tv/";
    }
    if (environment == VVEnvironmentRelease) {
        return @"http://api.app.pthv.gitv.tv/";
    }
    return @"http://api.app.pthv.gitv.tv/";
}
// Environment 开发环境or发布环境
- (VVAPIManagerServiceEnvironment) environment {
    return VVEnvironmentDevelop;
}

// Request
- (NSURLRequest *) generatorRequestWithRequestType: (VVAPIManagerRequestType) type apiAddress :(NSString *) apiAddress param :(NSDictionary *) param {
    
    NSMutableString *requestAddress = [[NSMutableString alloc]initWithString:[self serviceBaseUrl:self.environment]];
    NSMutableURLRequest *request = nil;
    switch (type) {
        case VVRequestTypeGET:
            [requestAddress appendFormat:@"%@%@",apiAddress,[self paramStrOfGETWithParam:param]];
            // 不进行缓存
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestAddress] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
            request.HTTPMethod = @"GET";
            break;
        case VVRequestTypePOST:
            [requestAddress appendFormat:@"%@",apiAddress];
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestAddress]];
            request.HTTPMethod = @"POST";

            break;
            
        default:
           
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self serviceBaseUrl:self.environment]]];
            break;
    }
    
    return request;
}

/* Get Param*/
- (NSString *) paramStrOfGETWithParam :(NSDictionary *) param {
    NSMutableString * paramStr = [[NSMutableString alloc]initWithString:@"?"];
    for (NSString *key in param.allKeys) {
        [paramStr appendFormat:@"%@=%@&",key,param[key]];
    }
    [paramStr replaceCharactersInRange:NSMakeRange(paramStr.length-1, 1) withString:@""];
    return [paramStr copy];
}




@end
