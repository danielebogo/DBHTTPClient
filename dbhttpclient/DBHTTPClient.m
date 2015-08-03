//
//  DBHTTPClient.m
//  dbhttpclient
//
//  Created by Daniele Bogo on 03/08/2015.
//  Copyright (c) 2015 Daniele Bogo. All rights reserved.
//

#import "DBHTTPClient.h"


NSString *const kDBActionLogout = @"kDBActionLogout";


@implementation DBHTTPClient
@synthesize responseSerializer = _responseSerializer;
@synthesize requestSerializer = _requestSerializer;
@synthesize reachabilityManager = _reachabilityManager;


#pragma mark - Factory methods

+ (instancetype)client
{
    return [self new];
}


#pragma mark - Life cycle

- (instancetype)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:@""]];
    if (self) {
        _responseSerializer = [AFJSONResponseSerializer serializer];
        _responseSerializer.acceptableContentTypes = [self db_contentTypes];
        
        _requestSerializer = [AFJSONRequestSerializer serializer];
        _requestSerializer.allowsCellularAccess = YES;
        
        [self startReachabilityMonitor];
    }
    return self;
}


#pragma mark - Override Methods

- (AFHTTPRequestOperationBlockError)errorBlock
{
    __weak typeof(self) weakSelf = self;
    AFHTTPRequestOperationBlockError errorBlock = ^(NSURLSessionDataTask *task, NSError *error) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        if ( strongSelf.successBlock ) {
            strongSelf.successBlock(task, nil);
        }
        
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
        
        NSLog(@"Error %@", errorData);
//        [weakSelf db_actionForStatusCode:task.response];
    };
    
    return errorBlock;
}


#pragma mark - Public methods

- (void)startReachabilityMonitor
{
    NSOperationQueue *operationQueue = self.operationQueue;
    [_reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [_reachabilityManager startMonitoring];
}

- (void)checkAndCancelAllOperations
{
    if (self.operationQueue.operationCount > 0) {
        [self.operationQueue cancelAllOperations];
        _cancelAllOperations = YES;
    }
}

- (NSDictionary *)authParameter
{
    return [self parameters:nil includingAuthentication:YES];
}

- (NSDictionary *)parameters:(NSDictionary *)dictionary includingAuthentication:(BOOL)auth
{
    return nil;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = [_requestSerializer requestWithMethod:method
                                                               URLString:[self db_absoluteURLStringFrom:URLString]
                                                              parameters:parameters
                                                                   error:nil];
#ifdef DEBUG
    [request setTimeoutInterval:25];
#else
    [request setTimeoutInterval:25];
#endif
    
    return [self db_addDefaultHeaderFieldsForRequest:request];
}


#pragma mark - Private methods

- (NSMutableURLRequest *)db_addDefaultHeaderFieldsForRequest:(NSMutableURLRequest *)request
{
    //////////////////////////////////////////////////////////////////////
    //                                                                  //
    //  If you use default values within your request, add values here  //
    //                                                                  //
    //////////////////////////////////////////////////////////////////////
    
    //    [request setValue:@"value" forHTTPHeaderField:@"key-field"];
    return request;
}

- (NSSet *)db_contentTypes
{
    return [NSSet setWithObjects:@"application/json", @"text/plain", @"text/html", nil];
}

- (NSString *)db_absoluteURLStringFrom:(NSString *)URLString
{
    return [[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString];
}

- (void)db_actionForStatusCode:(NSInteger)statusCode
{
    switch (statusCode) {
        case 401:
            [[NSNotificationCenter defaultCenter] postNotificationName:kDBActionLogout object:nil];
            break;
            
        default:
            break;
    }
}



@end