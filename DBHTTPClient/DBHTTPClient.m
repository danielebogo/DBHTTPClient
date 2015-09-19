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
    return [self initWithURL:@""];
}

- (instancetype)initWithURL:(NSString *)URL
{
    self = [super initWithBaseURL:[NSURL URLWithString:URL]];
    if (self) {
        [self db_setupClient];
    }
    return self;
}

- (instancetype)initWithURL:(NSString *)URL sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:[NSURL URLWithString:URL] sessionConfiguration:configuration];
    if (self) {
        [self db_setupClient];
    }
    return self;
}


#pragma mark - Override Methods

- (AFHTTPSessionManagerBlockError)errorBlock
{
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManagerBlockError errorBlock = ^(NSURLSessionDataTask *task, NSError *error) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        if ( strongSelf.successBlock ) {
            strongSelf.successBlock(task, nil);
        }
        
        [weakSelf db_actionForStatusCode:((NSHTTPURLResponse *)task.response).statusCode];
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


#pragma mark - Private methods

- (void)db_setupClient
{
    _responseSerializer = [AFJSONResponseSerializer serializer];
    _responseSerializer.acceptableContentTypes = [self db_contentTypes];
    
    _requestSerializer = [AFJSONRequestSerializer serializer];
    _requestSerializer.allowsCellularAccess = YES;
    
    [self startReachabilityMonitor];
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