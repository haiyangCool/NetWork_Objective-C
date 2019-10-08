//
//  VVMemoryCacheObject.m
//  NetWork
//
//  Created by 王海洋 on 2019/6/17.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import "VVCacheObject.h"

@interface VVCacheObject() 
@property (strong , nonatomic) NSData *content;
@property (assign , nonatomic) NSDate *updateTime;

@end
@implementation VVCacheObject


- (instancetype)initCacheObjWithData:(NSData *)data {
    self = [super init];
    if (self) {
        [self updateCacheObjectWithData:data];
    }
    return self;
}

- (void)updateCacheObjectWithData:(NSData *)data {
    self.content = data;
    self.updateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}


- (BOOL)isOutOfTime {
    
    NSTimeInterval timeInterval = [[NSDate date]timeIntervalSinceDate:self.updateTime];
    return timeInterval > self.cacheTime;
}

- (BOOL)isEmpty {
    return self.content == nil;
}
#pragma mark - Private method
@end
