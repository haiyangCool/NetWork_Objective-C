//
//  VVCacheCenter.m
//  NetWork
//
//  Created by 王海洋 on 2016/3/12.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import "VVCacheCenter.h"
#import "VVMemoryCacheManager.h"
#import "VVDiskCacheManager.h"
@interface VVCacheCenter ()

@property (strong , nonatomic) VVMemoryCacheManager *memoryCahceManager;
@property (strong , nonatomic) VVDiskCacheManager   *diskCacheManager;

@end

@implementation VVCacheCenter

+ (instancetype)shareInstance {
    static dispatch_once_t once_t;
    static VVCacheCenter *instance = nil;
    dispatch_once(&once_t, ^{
        instance = [[VVCacheCenter alloc] init];
    });
    return instance;
}


- (void)saveCacheByMemoryWithResponse:(VVURLResponse *)response
                    serviceIdentifier:(NSString *)identifier
                              apiName:(NSString *)apiName
                                param:(NSDictionary *)param
                           cacheTime :(NSTimeInterval) cacheTime{
    
    [self.memoryCahceManager saveCacheWithResponse:response cacheKey:[self cacheKeyWithServiceIdentifier:identifier apiName:apiName param:param] cacheTime:cacheTime];
}

- (void)saveCacheDiskWithResponse:(VVURLResponse *)response
                serviceIdentifier:(NSString *)identifier
                          apiName:(NSString *)apiName
                            param:(NSDictionary *)param
                       cacheTime :(NSTimeInterval) cacheTime{
 
    [self.diskCacheManager saveCacheWithResponse:response cacheKey:[self cacheKeyWithServiceIdentifier:identifier apiName:apiName param:param] cacheTime:cacheTime];
}

- (VVURLResponse *)fetchMemoryCacheWithServiceIdentifier:(NSString *)identifier apiName:(NSString *)apiName param:(NSDictionary *)param {
    
    NSData *cacheData = [self.memoryCahceManager fetctCacheWithKey:[self cacheKeyWithServiceIdentifier:identifier apiName:apiName param:param]];
    if (cacheData != nil) {
        return [[VVURLResponse alloc] initResponseWithData:cacheData];
    }
    return nil;
}

- (VVURLResponse *)fetchDiskCacheWithServiceIdentifier:(NSString *)identifier apiName:(NSString *)apiName param:(NSDictionary *)param {
    
    NSData *cacheData = [self.diskCacheManager fetctCacheWithKey:[self cacheKeyWithServiceIdentifier:identifier apiName:apiName param:param]];
    if (cacheData != nil) {
        return [[VVURLResponse alloc] initResponseWithData:cacheData];
    }
    return nil;
}

- (void)clearMemoryCache {
    
    [self.memoryCahceManager clearAllCache];
}

- (void)clearDiskCache {
    [self.diskCacheManager clearAllCache];
}

/* Cache Key*/
- (NSString *) cacheKeyWithServiceIdentifier :(NSString *) identifier
                                     apiName :(NSString *) apiName
                                       param :(NSDictionary *) param {
    NSMutableString *key = [[NSMutableString alloc]init];
    [key appendString:identifier];
    [key appendString:apiName];
    for (NSString *kp in param.allKeys) {
        [key appendFormat:@"%@=%@",kp,param[kp]];
    }
    return [key copy];
}

- (VVMemoryCacheManager *)memoryCahceManager {
    if (_memoryCahceManager == nil) {
        _memoryCahceManager = [[VVMemoryCacheManager alloc] init];
    }
    return _memoryCahceManager;
}

- (VVDiskCacheManager *)diskCacheManager {
    if (_diskCacheManager == nil) {
        _diskCacheManager = [[VVDiskCacheManager alloc] init];
    }
    return _diskCacheManager;
}

@end
