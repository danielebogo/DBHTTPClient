//
//  DBHTTPClient.h
//  dbhttpclient
//
//  Created by Daniele Bogo on 03/08/2015.
//  Copyright (c) 2015 Daniele Bogo. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@import Foundation;


extern NSString *const kDBActionLogout;


typedef void (^AFHTTPRequestOperationBlockError)(NSURLSessionDataTask *task, id responseObject);
typedef void (^AFHTTPRequestOperationBlockSuccess)(NSURLSessionDataTask *task, NSError *error);


@interface DBHTTPClient : AFHTTPSessionManager

@property (nonatomic, copy) AFHTTPRequestOperationBlockError errorBlock;
@property (nonatomic, copy) AFHTTPRequestOperationBlockSuccess successBlock;

@property (nonatomic, assign, getter=areAllOperationsCancelled) BOOL cancelAllOperations;

+ (instancetype)client;

- (void)startReachabilityMonitor;
- (void)checkAndCancelAllOperations;

- (NSDictionary *)authParameter;
- (NSDictionary *)parameters:(NSDictionary *)dictionary includingAuthentication:(BOOL)auth;
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters;

@end