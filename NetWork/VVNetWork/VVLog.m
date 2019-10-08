//
//  VVLog.m
//  NetWork
//
//  Created by 王海洋 on 2019/6/18.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import "VVLog.h"
#import "VVURLResponse.h"
@implementation VVLog
+ (NSString *) logWithRequest :(NSURLRequest *_Nullable) request responseMsg :(NSString *_Nullable) responseMsg error :(NSError *_Nullable) error {
    NSMutableString *logMsg = [NSMutableString stringWithString:@"***** VV Log message ****** \n"];
    [logMsg appendFormat:@"Request Type     : \t\t\t\t %@ \n",request.HTTPMethod];
    [logMsg appendFormat:@"Request Api      : \t\t\t\t %@ \n",request.URL.absoluteString];
    [logMsg appendFormat:@"Request PM(Body) : \t\t\t\t %@ \n",[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]];
    [logMsg appendFormat:@"Response Msg     : \t\t\t\t %@ \n",responseMsg];
    [logMsg appendFormat:@"Response is Cache: \t\t\t\t %@ \n",@"false"];
    [logMsg appendFormat:@"Error messag     : \t\t\t\t %ld \n",error.code];
    return logMsg;
}

+ (NSString *) logWithService :(id <VVAPIManagerService>) service apiName :(NSString *) apiName param :(NSDictionary *) param requestType :(NSString *) requestType response :(VVURLResponse *) response errorType :(NSString *) errorType {
    NSMutableString *logMsg = [NSMutableString stringWithString:@"***** VV Log message ******\n"];
    [logMsg appendFormat:@"Request Environment: \t\t\t\t %lu \n",service.environment];
    [logMsg appendFormat:@"Service Address    : \t\t\t\t %@ \n",[service serviceBaseUrl:service.environment]];
    [logMsg appendFormat:@"Request Type       : \t\t\t\t %@ \n",requestType];
    [logMsg appendFormat:@"Request Api        : \t\t\t\t %@ \n",apiName];
    [logMsg appendFormat:@"Request PM(Body)   : \t\t\t\t %@ \n",param];
    [logMsg appendFormat:@"Response is Cache  : \t\t\t\t %d \n",response.isCache];
    [logMsg appendFormat:@"Error messag       : \t\t\t\t %@ \n",response.errorMessage];
    [logMsg appendFormat:@"VVAPIManagerErrorType messag   : \t %@\n",errorType];
    [logMsg appendFormat:@"Response           : \t\t\t\t %@ \n",response.responseStr];


    return logMsg;
}
@end
