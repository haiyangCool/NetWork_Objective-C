//
//  VVCacheCenter.h
//  NetWork
//
//  Created by 王海洋 on 2016/3/12.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVURLResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface VVCacheCenter : NSObject

+ (instancetype)shareInstance;

- (void) saveCacheByMemoryWithResponse :(VVURLResponse *) response
                     serviceIdentifier :(NSString *)identifier
                               apiName :(NSString *) apiName
                                 param :(NSDictionary *) param
                             cacheTime :(NSTimeInterval) cacheTime;

- (void) saveCacheDiskWithResponse:(VVURLResponse *)response
                 serviceIdentifier:(NSString *)identifier
                          apiName :(NSString *) apiName
                            param :(NSDictionary *) param
                        cacheTime :(NSTimeInterval) cacheTime;

- (VVURLResponse *) fetchMemoryCacheWithServiceIdentifier :(NSString *) identifier
                                                  apiName :(NSString *) apiName
                                                    param :(NSDictionary *) param;
- (VVURLResponse *) fetchDiskCacheWithServiceIdentifier :(NSString *) identifier
                                                apiName :(NSString *) apiName
                                                  param :(NSDictionary *) param;

- (void) clearMemoryCache;
- (void) clearDiskCache;

@end

NS_ASSUME_NONNULL_END
