//
//  dbhttpclientTests.m
//  dbhttpclientTests
//
//  Created by Daniele Bogo on 03/08/2015.
//  Copyright (c) 2015 Daniele Bogo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <AFNetworking/AFNetworking.h>

#import "DBHTTPClient.h"
#import "DBHTTPClient+NewMethods.h"

// Set the flag for a block completion handler
#define StartBlock() __block BOOL waitingForBlock = YES

// Set the flag to stop the loop
#define EndBlock() waitingForBlock = NO

// Wait and loop until flag is set
#define WaitUntilBlockCompletes() WaitWhile(waitingForBlock)

// Macro - Wait for condition to be NO/false in blocks and asynchronous calls
#define WaitWhile(condition) \
do { \
while(condition) { \
[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]; \
} \
} while(0)


@interface dbhttpclientTests : XCTestCase

@end

@implementation dbhttpclientTests {
    DBHTTPClient *client_;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    client_ = [[DBHTTPClient alloc] initWithURL:@"http://www.bogodaniele.com"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConnecion
{
    StartBlock();
    [client_ GET:@"/test" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        EndBlock();
        XCTAssertNil(responseObject, @"responseObject should be nil");
    }];
    WaitUntilBlockCompletes();
}

@end
