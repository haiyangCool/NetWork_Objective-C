//
//  DemoService.h
//  NetWork
//
//  Created by 王海洋 on 2019/6/17.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVNetWork/VVApiManagerDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface DemoService : NSObject <VVAPIManagerService>
@property (strong, nonatomic, readonly) NSURLRequest *request;

- (instancetype) initWithApiAddress:(NSString *)apiAddress param:(NSDictionary *)param requestType:(VVAPIManagerRequestType)type;

@end


NS_ASSUME_NONNULL_END
