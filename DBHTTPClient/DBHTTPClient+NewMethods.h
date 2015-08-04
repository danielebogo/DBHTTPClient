//
//  DBHTTPClient+NewMethods.h
//  dbhttpclient
//
//  Created by Daniele Bogo on 04/08/2015.
//  Copyright (c) 2015 Daniele Bogo. All rights reserved.
//

#import "DBHTTPClient.h"

@interface DBHTTPClient (NewMethods)

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(AFHTTPSessionManagerBlockSuccess)success;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(AFHTTPSessionManagerBlockSuccess)success;

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(id)parameters
                      success:(AFHTTPSessionManagerBlockSuccess)success;

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(id)parameters
                         success:(AFHTTPSessionManagerBlockSuccess)success;

@end