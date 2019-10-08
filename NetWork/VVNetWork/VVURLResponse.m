//
//  VVURLResponse.m
//  NetWork
//
//  Created by 王海洋 on 2016/3/12.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import "VVURLResponse.h"

static NSString * const VVERRORMSGKEY = @"VVERRORMSGKEY";
static NSString * const VVERRORSTATUEKEY = @"VVERRORMSGKEY";

@interface VVURLResponse()

@property (nonatomic, strong) NSString *responseStr;
@property (nonatomic, strong) id content;
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, assign) BOOL isCache;
@property (assign, nonatomic) NSInteger requestId;
@property (assign, nonatomic) VVURLResponseStatue statue;
@property (copy, nonatomic) NSString *errorMessage;


@end
@implementation VVURLResponse

- (instancetype)initResponseWithDataString:(NSString *)apiDataStr request:(NSURLRequest *)request requestId:(NSInteger)requestId error:(NSError *)error {
    self = [super init];
    if (self) {
        self.responseStr = apiDataStr;
        self.responseData = [self.responseStr dataUsingEncoding:NSUTF8StringEncoding];
        self.content = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:NULL];
        self.errorMessage = @"Success";
        self.statue = [self errorStatueWithError:error];
        self.isCache = false;        
    }
    return self;
}

- (instancetype)initResponseWithData:(NSData *)data {
    
    self = [super init];
    if (self) {
    
        self.responseData = data;
        self.responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.content = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:NULL];
        self.isCache = true;
        self.requestId = 0;
        self.statue = VVURLResponseSuccess;
        self.errorMessage = @"Success";
    }
    
    return self;
}


- (VVURLResponseStatue) errorStatueWithError :(NSError *_Nullable)error {
    
    VVURLResponseStatue statue = VVURLResponseSuccess;
    if (error == nil) {}
    if (error.code == NSURLErrorTimedOut) {
        _errorMessage = @"NSURLErrorTimedOut";
        statue = VVURLResponseRequestTimeout;
    }
    if (error.code == NSURLErrorCancelled) {
        _errorMessage = @"NSURLErrorCancelled";
        statue = VVURLResponseCancelRequest;
    }
    if (error.code == NSURLErrorDNSLookupFailed) {
        _errorMessage = @"NSURLErrorDNSLookupFailed";
        statue = VVURLResponseDNSLookupFailed;
    }
   
    return statue;
}
@end

