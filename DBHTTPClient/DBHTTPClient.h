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


typedef void (^AFHTTPSessionManagerBlockSuccess)(NSURLSessionDataTask *task, id responseObject);
typedef void (^AFHTTPSessionManagerBlockError)(NSURLSessionDataTask *task, NSError *error);


@interface DBHTTPClient : AFHTTPSessionManager

@property (nonatomic, copy) AFHTTPSessionManagerBlockError errorBlock;
@property (nonatomic, copy) AFHTTPSessionManagerBlockSuccess successBlock;

@property (nonatomic, assign, getter=areAllOperationsCancelled) BOOL cancelAllOperations;

+ (instancetype)client;

- (instancetype)initWithURL:(NSString *)URL;
- (instancetype)initWithURL:(NSString *)URL sessionConfiguration:(NSURLSessionConfiguration *)configuration;

- (void)startReachabilityMonitor;
- (void)checkAndCancelAllOperations;

- (NSDictionary *)authParameter;
- (NSDictionary *)parameters:(NSDictionary *)dictionary includingAuthentication:(BOOL)auth;

@end