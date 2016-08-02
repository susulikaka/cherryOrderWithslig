//
//  LKAPIClient.h
//  CherryOrder
//
//  Created by admin on 16/7/27.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import <MKNetworkKit/MKNetworkKit.h>
#import "LKOperation.h"
#import "LKUser.h"
#import "LKJSonModel.h"

typedef void (^ModelBlock)(LKJSonModel* aModelBaseObject);
typedef void (^ArrayBlock)(NSMutableArray* listOfModelBaseObjects);
typedef void (^ErrorBlock)(LKAPIError* engineError);
typedef void (^SimpleMsgBlock)(LKMSimpleMsg* simpleMsg);

@interface LKAPIClient : MKNetworkEngine

+ (LKAPIClient *)sharedClient;
+ (LKAPIClient *)newClient;
- (NSMutableDictionary *)headerParams;

- (LKOperation*)requestPOSTForGetUserInfo:(NSString *)url
                                   params:(NSDictionary *)params
                               modelClass:(Class)modelClass
                        completionHandler:(ModelBlock) completionBlock
                             errorHandler:(ErrorBlock) errorBlock;

- (LKOperation*)requestPOSTForAddUser:(NSString *)url
                               params:(NSDictionary *)params
                           modelClass:(Class)modelClass
                    completionHandler:(ModelBlock) completionBlock
                         errorHandler:(ErrorBlock) errorBlock;

- (LKOperation*)requestPOSTForOrder:(NSString *)url
                         modelClass:(Class)modelClass
                  completionHandler:(ModelBlock) completionBlock
                       errorHandler:(ErrorBlock) errorBlock;

- (LKOperation *)requestDELETEForCancelOrder:(NSString *)url
                                  modelClass:(Class)modelClass
                           completionHandler:(ModelBlock)completionBlock
                                errorHandler:(ErrorBlock)errorBlock ;

- (LKOperation *)requestGETForcurDateOrderList:(NSString *)url
                                        params:params
                                    modelClass:(Class)modelClass
                             completionHandler:(ModelBlock)completionBlock
                                  errorHandler:(ErrorBlock)errorBlock;
- (LKOperation *)requestGETForUserList:(NSString *)url
                                params:params
                            modelClass:(Class)modelClass
                    completionHandler:(ModelBlock)completionBlock
                          errorHandler:(ErrorBlock)errorBlock;

- (LKOperation *)requestGETForOrderListHistoryOneMonth:(NSString *)url
                                                params:(NSDictionary *)params
                                            modelClass:(Class)modelClass
                                     completionHandler:(ModelBlock)completionBlock
                                          errorHandler:(ErrorBlock)errorBlock;

- (LKOperation*)requestPOSTForHelpOrder:(NSString *)url
                               params:(NSDictionary *)params
                           modelClass:(Class)modelClass
                    completionHandler:(ModelBlock) completionBlock
                         errorHandler:(ErrorBlock) errorBlock;

- (LKOperation*)requestPOSTForSearchUser:(NSString *)url
                               params:(NSDictionary *)params
                           modelClass:(Class)modelClass
                    completionHandler:(ModelBlock) completionBlock
                         errorHandler:(ErrorBlock) errorBlock;

- (LKOperation*)requestPOSTForOrderUSerInfo:(NSString *)url
                               params:(NSDictionary *)params
                           modelClass:(Class)modelClass
                    completionHandler:(ModelBlock) completionBlock
                         errorHandler:(ErrorBlock) errorBlock;

@end
