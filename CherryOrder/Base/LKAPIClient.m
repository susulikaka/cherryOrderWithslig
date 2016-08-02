//
//  LKAPIClient.m
//  CherryOrder
//
//  Created by admin on 16/7/27.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "LKAPIClient.h"
#import "LKJSONResult.h"
#import "NSDictionary+URL.h"

@interface LKAPIClient ()

@property (nonatomic,strong,readwrite) NSString * accessToken;
@property (nonatomic, strong) NSString          * appCurVersion;
@property (nonatomic, strong) NSString          * phoneModel;

@end

@implementation LKAPIClient

+ (LKAPIClient *)sharedClient {
    static LKAPIClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithHostName:ROOT_URL
                                          apiPath:API
                               customHeaderFields:nil];
    });
    return instance;
}

+ (LKAPIClient *)newClient {
    return [[self alloc] initWithHostName:ROOT_URL
                                  apiPath:API
                       customHeaderFields:nil];
}

- (NSMutableDictionary *)headerParams {
    NSString *appVersion = @"1.0";
    appVersion = [appVersion stringByReplacingOccurrencesOfString:@"."
                                                       withString:@""];
    NSMutableDictionary *headerParams = [@{@"x-device":@"ios",
                                           @"x-os-version":[[UIDevice currentDevice] systemVersion],
                                           @"x-app-version":appVersion,
                                           @"x-model":@"",
                                           @"x-deviceid":@"",
                                           @"x-wifi":@""} mutableCopy];
    if(self.accessToken) {
        [headerParams setValue:self.accessToken forKey:@"token"];
    }
    return headerParams;
}

- (id)initWithHostName:(NSString *)hostName apiPath:(NSString *)apiPath customHeaderFields:(NSDictionary *)headers {
    if (self = [super initWithHostName:hostName apiPath:apiPath customHeaderFields:headers]) {
        [self registerOperationSubclass:[LKOperation class]];
    }
    return self;
}

- (NSDictionary *)paramsWithName {
    LKUser * user = [[UserInfoManager sharedManager] getUserInfo];
    return @{@"name":user.name};
}

- (NSDictionary *)paramsWithCurDate {
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString * timeStr = [formatter stringFromDate:date];
    return @{@"date":timeStr};
}

- (NSDictionary *)paramsWithCurDateAndEndTime {
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString * timeStr = [formatter stringFromDate:date];
    if ([[UserInfoManager sharedManager] getUserInfo].end_time != nil) {
        return @{@"date":timeStr,@"end_time":[[UserInfoManager sharedManager] getUserInfo].end_time};
    } else {
        return @{@"date":timeStr};
    }
}

- (NSDictionary *)paramsWithNameAndCurDate {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[self paramsWithName]];
    [dic addEntriesFromDictionary:[self paramsWithCurDate]];
    return dic;
}

- (LKOperation*)generatorGETLKOperationWithPath:(NSString *)path
                                         params:(NSDictionary *)params
                                     modelClass:(Class)modelClass
                              completionHandler:(ModelBlock)completionBlock
                                   errorHandler:(ErrorBlock) errorBlock {
    NSString *url = path;
    NSMutableDictionary *mutableParams = [params mutableCopy];
    NSString *timestamp = [NSString stringWithFormat:@"%.3f", [[NSDate date] timeIntervalSince1970]];
    [mutableParams setObject:timestamp
                      forKey:@"_t"];
    if (mutableParams) {
        url = [url stringByAppendingFormat:[path rangeOfString:@"?"].location == NSNotFound ? @"?%@" : @"&%@", [mutableParams queryString]];
    }
    return [self generatorGETLKOperation:url
                              modelClass:modelClass
                       completionHandler:completionBlock
                            errorHandler:errorBlock];
}

- (LKOperation*)generatorGETLKOperation:(NSString *)url
                             modelClass:(Class)modelClass
                      completionHandler:(ModelBlock) completionBlock
                           errorHandler:(ErrorBlock) errorBlock {
    LKOperation *op = (LKOperation*) [self operationWithPath:url];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        id result = [completedOperation responseJSON];
        if ([result isKindOfClass:[NSDictionary class]]){
            NSDictionary *deserializedDictionary = (NSDictionary *)result;
            LKJSONResult *jsonResult = [[LKJSONResult alloc] initWithDictionary:deserializedDictionary modelClass:modelClass];
            if (jsonResult.code == 200) {
                completionBlock(jsonResult.result);
            } else {
                LKAPIError *networkError = [[LKAPIError alloc] init];
                networkError.errorCode = [deserializedDictionary[@"code"] integerValue];
                networkError.message = deserializedDictionary[@"data"][@"msg"];
                errorBlock(networkError);
            }
        } else {
            LKAPIError *networkError = [[LKAPIError alloc] init];
            networkError.message = @"服务器出错啦";
            errorBlock(networkError);
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        LKAPIError *networkError = [[LKAPIError alloc] init];
        networkError.errorCode = error.code;
        networkError.message = @"网络错误，请稍后重试～";
        errorBlock(networkError);
    }];
    
    [self enqueueOperation:op];
    return op;
}

- (LKOperation*)sendRequestWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                            method:(NSString *)method
                        modelClass:(Class)modelClass
                 completionHandler:(ModelBlock) completionBlock
                      errorHandler:(ErrorBlock) errorBlock {
    LKOperation *op = (LKOperation*) [self operationWithPath:url params:params httpMethod:method];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        id result = [completedOperation responseJSON];
        if ([result isKindOfClass:[NSDictionary class]]){
            NSDictionary *deserializedDictionary = (NSDictionary *)result;
            LKJSONResult *jsonResult = [[LKJSONResult alloc] initWithDictionary:deserializedDictionary
                                                                     modelClass:modelClass];
            if (jsonResult.code == 200) {
                completionBlock(jsonResult.result);
            } else {
                LKAPIError *networkError = [[LKAPIError alloc] init];
                networkError.errorCode = [deserializedDictionary[@"code"] integerValue];
                networkError.message = deserializedDictionary[@"data"][@"msg"];
                errorBlock(networkError);
            }
        } else {
            LKAPIError *networkError = [[LKAPIError alloc] init];
            networkError.message = @"服务器出错啦";
            errorBlock(networkError);
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        LKAPIError *networkError = [[LKAPIError alloc] init];
        networkError.errorCode = error.code;
        networkError.message = @"网络错误，请稍后重试～";
        errorBlock(networkError);
    }];
    
    [self enqueueOperation:op];
    return op;
}

- (LKOperation *)requestPOSTForAddUser:(NSString *)url
                                params:params
                            modelClass:(Class)modelClass
                     completionHandler:(ModelBlock)completionBlock
                          errorHandler:(ErrorBlock)errorBlock {
    return [self sendRequestWithUrl:url
                             params:params
                             method:@"POST"
                         modelClass:modelClass
                  completionHandler:completionBlock
                       errorHandler:errorBlock];
}

- (LKOperation*)requestPOSTForGetUserInfo:(NSString *)url
                                   params:(NSDictionary *)params
                               modelClass:(Class)modelClass
                        completionHandler:(ModelBlock) completionBlock
                             errorHandler:(ErrorBlock) errorBlock {
    return [self sendRequestWithUrl:url
                             params:params
                             method:@"GET"
                         modelClass:modelClass
                  completionHandler:completionBlock
                       errorHandler:errorBlock];
}

- (LKOperation *)requestPOSTForOrder:(NSString *)url
                          modelClass:(Class)modelClass
                   completionHandler:(ModelBlock)completionBlock
                        errorHandler:(ErrorBlock)errorBlock {
    return [self sendRequestWithUrl:url
                             params:[self paramsWithName]
                             method:@"POST"
                         modelClass:modelClass
                  completionHandler:completionBlock
                       errorHandler:errorBlock];
}

- (LKOperation *)requestDELETEForCancelOrder:(NSString *)url
                                  modelClass:(Class)modelClass
                           completionHandler:(ModelBlock)completionBlock
                                errorHandler:(ErrorBlock)errorBlock {
    return [self sendRequestWithUrl:url
                             params:[self paramsWithName]
                             method:@"DELETE"
                         modelClass:modelClass
                  completionHandler:completionBlock
                       errorHandler:errorBlock];
}

- (LKOperation *)requestGETForcurDateOrderList:(NSString *)url
                                        params:params
                                    modelClass:(Class)modelClass
                             completionHandler:(ModelBlock)completionBlock
                                  errorHandler:(ErrorBlock)errorBlock {
    return [self sendRequestWithUrl:url
                             params:params
                             method:@"GET"
                         modelClass:modelClass
                  completionHandler:completionBlock
                       errorHandler:errorBlock];
}

- (LKOperation *)requestGETForOrderListHistoryOneMonth:(NSString *)url
                                                params:(NSDictionary *)params
                                            modelClass:(Class)modelClass
                                     completionHandler:(ModelBlock)completionBlock
                                          errorHandler:(ErrorBlock)errorBlock {
    return [self sendRequestWithUrl:url
                             params:params
                             method:@"GET"
                         modelClass:modelClass
                  completionHandler:completionBlock
                       errorHandler:errorBlock];
}


- (LKOperation*)requestPOSTForHelpOrder:(NSString *)url
                                 params:(NSDictionary *)params
                             modelClass:(Class)modelClass
                      completionHandler:(ModelBlock) completionBlock
                           errorHandler:(ErrorBlock) errorBlock {
    return [self sendRequestWithUrl:url
                             params:params
                             method:@"POST"
                         modelClass:modelClass
                  completionHandler:completionBlock
                       errorHandler:errorBlock];
}

- (LKOperation*)requestPOSTForSearchUser:(NSString *)url
                                  params:(NSDictionary *)params
                              modelClass:(Class)modelClass
                       completionHandler:(ModelBlock) completionBlock
                            errorHandler:(ErrorBlock) errorBlock {
    return [self sendRequestWithUrl:url
                             params:params
                             method:@"GET"
                         modelClass:modelClass
                  completionHandler:completionBlock
                       errorHandler:errorBlock];

}

- (LKOperation*)requestPOSTForOrderUSerInfo:(NSString *)url
                                     params:(NSDictionary *)params
                                 modelClass:(Class)modelClass
                          completionHandler:(ModelBlock) completionBlock
                               errorHandler:(ErrorBlock) errorBlock {
    return [self sendRequestWithUrl:url
                             params:params
                             method:@"GET"
                         modelClass:modelClass
                  completionHandler:completionBlock
                       errorHandler:errorBlock];

}

- (LKOperation *)requestGETForUserList:(NSString *)url
                                params:params
                            modelClass:(Class)modelClass
                     completionHandler:(ModelBlock)completionBlock
                          errorHandler:(ErrorBlock)errorBlock {
    return [self sendRequestWithUrl:url
                             params:params
                             method:@"GET"
                         modelClass:modelClass
                  completionHandler:completionBlock
                       errorHandler:errorBlock];
}

- (LKOperation*)requestGETForAddUser:(NSString *)url
                              params:(NSDictionary *)params
                              method:(NSString *)method
                          modelClass:(Class)modelClass
                   completionHandler:(ModelBlock) completionBlock
                        errorHandler:(ErrorBlock) errorBlock{
    LKOperation * opt = (LKOperation *)[self operationWithPath:url params:params httpMethod:method];
    [opt addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        id result = [completedOperation responseJSON];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dicSerial = (NSDictionary *)result;
            LKJSONResult * jsonResult = [[LKJSONResult alloc] initWithDictionary:dicSerial modelClass:modelClass];
            if (jsonResult.code == 200) {
                completionBlock(jsonResult.result);
            } else {
                LKAPIError * error = [[LKAPIError alloc] init];
                error.errorCode = [dicSerial[@"code"] integerValue];
                error.message = dicSerial[@"data"][@"msg"];
                errorBlock(error);
            }
        }else {
                LKAPIError * error = [[LKAPIError alloc] init];
                error.message = @"服务器出错啦";
                errorBlock(error);

        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        LKAPIError *networkError = [[LKAPIError alloc] init];
        networkError.errorCode = error.code;
        networkError.message = @"网络错误，请稍后重试～";
        errorBlock(networkError);
        
    }];
    return opt;
}

@end
