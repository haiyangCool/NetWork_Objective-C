//
//  VVDiskCacheManager.m
//  NetWork
//
//  Created by 王海洋 on 2016/3/12.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import "VVDiskCacheManager.h"
static const NSString * VVDISKCACHEHEAD = @"VVDISKCACHEHEAD";
static const NSString * VVDISKCACHECONTENT = @"VVDISKCACHECONTENT";
static const NSString * VVDISKCACHEUPDATETIME = @"VVDISKCACHEUPDATETIME";
static const NSString * VVDISKCACHECACHETIME = @"VVDISKCACHECACHETIME";


@interface VVDiskCacheManager()
@property (strong , nonatomic) NSUserDefaults *disCacheManager;
@end

@implementation VVDiskCacheManager

- (void)saveCacheWithResponse:(VVURLResponse *)response
                     cacheKey:(NSString *)key
                   cacheTime :(NSTimeInterval) cacheTime{
    
    NSMutableString *cacheKey = [[NSMutableString alloc]initWithFormat:@"%@%@",VVDISKCACHEHEAD,key];
    if (response.responseData) {
        NSData *cacheData = [NSJSONSerialization dataWithJSONObject:@{
                                                                      VVDISKCACHECONTENT:response.content,
                                                                      VVDISKCACHEUPDATETIME:@([NSDate date].timeIntervalSince1970),
                                                                      VVDISKCACHECACHETIME:@(cacheTime)
                                                                      }
                                                            options:0
                                                              error:NULL];
        
        [self.disCacheManager setObject:cacheData forKey:cacheKey];
        [self.disCacheManager synchronize];
    }
   
}

- (NSData *)fetctCacheWithKey:(NSString *)key {
    
    NSData *diskData = nil;
    NSMutableString *cacheKey = [[NSMutableString alloc]initWithFormat:@"%@%@",VVDISKCACHEHEAD,key];

    NSData *data = [self.disCacheManager dataForKey:cacheKey];
    if (data != nil) {
        NSDictionary *dataInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSDate *updateTime = [NSDate dateWithTimeIntervalSince1970:[dataInfo[VVDISKCACHEUPDATETIME] doubleValue]];
        NSTimeInterval cacheTime= [dataInfo[VVDISKCACHECACHETIME] doubleValue];
        NSTimeInterval outOfTime = [[NSDate date] timeIntervalSinceDate:updateTime];
        
        if (outOfTime < cacheTime) {
            diskData = [NSJSONSerialization dataWithJSONObject:dataInfo[VVDISKCACHECONTENT] options:0 error:NULL];
        }else {
            
            [self.disCacheManager removeObjectForKey:cacheKey];
            [self.disCacheManager synchronize];
        }
    }
    
    
    return diskData;

}

- (void)clearAllCache {
    
    NSDictionary *defaultDic = [self.disCacheManager dictionaryRepresentation];
    NSArray *keys = [[defaultDic allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", VVDISKCACHEHEAD]];
    
    for (NSString *key in keys) {
        [self.disCacheManager removeObjectForKey:key];
    }
    [self.disCacheManager synchronize];
}

- (NSUserDefaults *)disCacheManager {
    if (_disCacheManager == nil) {
        _disCacheManager = [NSUserDefaults standardUserDefaults];
    }
    return _disCacheManager;
}
@end
