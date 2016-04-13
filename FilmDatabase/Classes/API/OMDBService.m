//
//  OMDBService.m
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 11/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

#import "OMDBService.h"

@interface OMDBService ()

@property (nonatomic, strong) NSURLSession *currentSession;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

@implementation OMDBService

- (instancetype)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForRequest = 2.0;
        sessionConfig.timeoutIntervalForResource = 5.0;

        self.currentSession = [NSURLSession sessionWithConfiguration:sessionConfig];

        self.hostUrl = kOMDB_SERVICE_HOST_URL;
    }

    return self;
}

#pragma mark - Siblings methods
- (void)getContentWithUrl:(NSString *)url
             successBlock:(void (^) (NSData *))success
                failBlock:(void (^) (NSString *errorDescription))fail {
    __weak __typeof(self) weakSelf = self;

    self.dataTask = [self.currentSession dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [weakSelf onFail:[self getErrorDescriptionWithError:error] failBlock:fail];
        } else {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *) response;
            if (httpResp.statusCode == kOMDB_SERVICE_STATUS_CODE_200) {
                [weakSelf onDidLoadSucceed:data successBlock:success];
            } else {
                [weakSelf onFail:[self serviceUnavailableError] failBlock:fail];
            }
        }
    }];

    [self.dataTask resume];
}

- (void)downloadContentWithUrl:(NSString *)url
                  successBlock:(void (^) (NSData *))success
                     failBlock:(void (^) (NSString *errorDescription))fail {
    __weak __typeof(self) weakSelf = self;

    self.dataTask = (NSURLSessionDataTask *)[self.currentSession downloadTaskWithURL:[NSURL URLWithString:url]
                                           completionHandler:^(NSURL *location,
                                                               NSURLResponse *response,
                                                               NSError *error) {
                                               if (error) {
                                                   [weakSelf onFail:[self getErrorDescriptionWithError:error] failBlock:fail];
                                               }

                                               [weakSelf onDidLoadSucceed:[NSData dataWithContentsOfURL:location] successBlock:success];
                                           }];
    [self.dataTask resume];
}

- (void)cancel {
    [self.dataTask cancel];
}

#pragma mark - Error handler methods
- (void)onFail:(NSString *)errorDescription failBlock:(void (^) (NSString *errorDescription))fail {
    if (fail && errorDescription && ![errorDescription isEqualToString:@""]) {
        fail(errorDescription);
    }
}

- (void)onDidLoadSucceed:(NSData *)data successBlock:(void (^) (NSData *))success {
    if (success) {
        success(data);
    }
}

- (NSString *)getErrorDescriptionWithError:(NSError *)error {
    NSString *errorDescription = error.localizedDescription;

    if (error.code == NSURLErrorTimedOut) {
        errorDescription = @"Temporary problems, please, try again";
    } else if (error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorNetworkConnectionLost) {
        errorDescription = @"Internet connection seems to be offline. Please, make sure you're connected to the internet";
    } else if (error.code == NSURLErrorCannotFindHost || error.code == NSURLErrorCannotConnectToHost) {
        errorDescription = [self serviceUnavailableError];
    } else if (error.code == NSURLErrorCancelled) {
        // No need to notify user about cancelled request in this case
        errorDescription = nil;
    }

    return errorDescription;
}

- (NSString *)serviceUnavailableError {
    return @"Service is currently unavailable. Please, try again later";
}

@end
