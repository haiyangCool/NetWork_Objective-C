//
//  DemoApiManager.m
//  NetWork
//
//  Created by 王海洋 on 2019/6/18.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import "DemoApiManager.h"
#import "DemoService.h"
@implementation DemoApiManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.childDelegate = self;
        self.validator = self;
    }
    return self;
}

#pragma mark VVAPIManagerDelegate, VVAPIManagerValidator

- (NSString *)methodName {
    return @"carousel/getList.json";
}

- (NSString *)requestServiceIdentifier {
    return @"DemoService";
}

- (id<VVAPIManagerService>)service {
    return [[DemoService alloc] init];
}

- (VVAPIManagerRequestType)requestType {
    return VVRequestTypeGET;
}

- (VVAPIManagerErrorType)validatorParam:(NSDictionary *)param manager:(VVBaseApiManager *)apiManager {
    return VVErrorTypeNoError;
}

- (VVAPIManagerErrorType)validatorResponse:(VVURLResponse *)response manager:(VVBaseApiManager *)apiManager {
    return VVErrorTypeNoError;
}


@end
