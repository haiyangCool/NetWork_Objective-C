//
//  VVMemoryCacheObject.h
//  NetWork
//
//  Created by 王海洋 on 2019/6/17.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VVCacheObject : NSObject
@property (assign, nonatomic, readonly) BOOL isOutOfTime;
@property (assign, nonatomic, readonly) BOOL isEmpty;
@property (strong, nonatomic, readonly) NSData *content;
@property (assign , nonatomic) NSTimeInterval cacheTime;

- (instancetype) initCacheObjWithData :(NSData *_Nonnull) data;
- (void) updateCacheObjectWithData :(NSData *_Nonnull) data;

@end

NS_ASSUME_NONNULL_END
