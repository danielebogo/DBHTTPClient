//
//  DBHTTPClient+NewMethods.m
//  dbhttpclient
//
//  Created by Daniele Bogo on 04/08/2015.
//  Copyright (c) 2015 Daniele Bogo. All rights reserved.
//

#import "DBHTTPClient+NewMethods.h"

@implementation DBHTTPClient (NewMethods)

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(AFHTTPSessionManagerBlockSuccess)success
{
    self.successBlock = success;
    
    NSURLSessionDataTask *dataTask = [super GET:URLString
                                     parameters:parameters
                                        success:self.successBlock
                                        failure:self.errorBlock];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(AFHTTPSessionManagerBlockSuccess)success
{
    self.successBlock = success;
    
    NSURLSessionDataTask *dataTask = [super POST:URLString
                                     parameters:parameters
                                        success:self.successBlock
                                        failure:self.errorBlock];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(id)parameters
                      success:(AFHTTPSessionManagerBlockSuccess)success
{
    self.successBlock = success;
    
    NSURLSessionDataTask *dataTask = [super PUT:URLString
                                     parameters:parameters
                                        success:self.successBlock
                                        failure:self.errorBlock];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(id)parameters
                         success:(AFHTTPSessionManagerBlockSuccess)success
{
    self.successBlock = success;
    
    NSURLSessionDataTask *dataTask = [super DELETE:URLString
                                        parameters:parameters
                                           success:self.successBlock
                                           failure:self.errorBlock];
    
    [dataTask resume];
    
    return dataTask;
}

@end
