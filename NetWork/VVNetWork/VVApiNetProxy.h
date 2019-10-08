//
//  VVApiNetProxy.h
//  NetWork
//
//  Created by 王海洋 on 2016/3/12.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVURLResponse.h"
#import "VVApiManagerDefine.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^VVCallBack)(VVURLResponse *_Nonnull response);
@interface VVApiNetProxy : NSObject

+ (instancetype)shareInstance;

- (NSNumber *) callApiWithRequest :(NSURLRequest *) request success :(VVCallBack)success faild :(VVCallBack) faild;

- (void)cancelRequestByRequestId :(NSNumber *) requestId ;
- (void) cancelAllRequest;
@end

NS_ASSUME_NONNULL_END
