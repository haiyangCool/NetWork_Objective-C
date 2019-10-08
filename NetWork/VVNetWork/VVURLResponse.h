//
//  VVURLResponse.h
//  NetWork
//
//  Created by 王海洋 on 2016/3/12.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVApiManagerDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface VVURLResponse : NSObject

@property (nonatomic, strong, readonly) NSString *responseStr;
@property (nonatomic, strong, readonly) NSData *responseData;
@property (nonatomic, strong, readonly) id content;
@property (nonatomic, copy) NSString *log;
@property (nonatomic, assign, readonly) BOOL isCache;
@property (assign, nonatomic, readonly) NSInteger requestId;
@property (assign, nonatomic, readonly) VVURLResponseStatue statue;
@property (copy, nonatomic, readonly) NSString *errorMessage;


- (instancetype)initResponseWithDataString:(NSString *) apiDataStr
                                  request :(NSURLRequest *) request
                                 requestId:(NSInteger) requestId
                                    error :(NSError *) error;

- (instancetype)initResponseWithData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
