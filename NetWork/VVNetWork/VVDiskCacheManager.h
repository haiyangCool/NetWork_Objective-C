//
//  VVDiskCacheManager.h
//  NetWork
//
//  Created by 王海洋 on 2016/3/12.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVURLResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface VVDiskCacheManager : NSObject

- (void)saveCacheWithResponse:(VVURLResponse *)response
                    cacheKey :(NSString *) key
                   cacheTime :(NSTimeInterval) cacheTime;

- (NSData *_Nullable)fetctCacheWithKey :(NSString *) key ;

- (void) clearAllCache;

@end

NS_ASSUME_NONNULL_END
