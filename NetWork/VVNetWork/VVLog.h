//
//  VVLog.h
//  NetWork
//
//  Created by 王海洋 on 2017/5/23.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVApiManagerDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface VVLog : NSObject

+ (NSString *) logWithRequest :(NSURLRequest *_Nullable) request
                  responseMsg :(NSString *_Nullable) responseMsg
                        error :(NSError *_Nullable) error;

+ (NSString *) logWithService :(id <VVAPIManagerService>) service
                      apiName :(NSString *) apiName
                        param :(NSDictionary *) param
                  requestType :(NSString *) requestType
                     response :(VVURLResponse *) response
                    errorType :(NSString *) errorType;

@end

NS_ASSUME_NONNULL_END
