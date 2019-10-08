//
//  VVMemoryCacheManager.m
//  NetWork
//
//  Created by 王海洋 on 2016/3/12.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import "VVMemoryCacheManager.h"
#import "VVCacheObject.h"
@interface VVMemoryCacheManager()
@property (strong, nonatomic) NSCache *cacheManager;

@end

@implementation VVMemoryCacheManager

- (void)saveCacheWithResponse:(VVURLResponse *)response
                     cacheKey:(NSString *)key
                   cacheTime :(NSTimeInterval) cacheTime{
    
    VVCacheObject *cacheObj = [[VVCacheObject alloc]initCacheObjWithData:response.responseData];
    cacheObj.cacheTime = cacheTime;
    [self.cacheManager setObject:cacheObj forKey:key];
}

- (NSData *)fetctCacheWithKey:(NSString *)key {
    
    VVCacheObject *cacheObj = [self.cacheManager objectForKey:key];
    if (cacheObj == nil) {
        return nil;
    }
    if (cacheObj.isOutOfTime || cacheObj.isEmpty) {
        [self.cacheManager removeObjectForKey:key];
        return nil;
    }
    return cacheObj.content;
}

- (void)clearAllCache {
    
    [self.cacheManager removeAllObjects];
}

- (NSCache *)cacheManager {
    
    if (_cacheManager == nil) {
        _cacheManager = [[NSCache alloc] init];
        [_cacheManager setCountLimit:10];
    }
    return _cacheManager;
}

@end
