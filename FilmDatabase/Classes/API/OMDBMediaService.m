//
//  OMDBMediaService.m
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 07/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

#import "OMDBMediaService.h"

#import "OMDBContainer.h"
#import "OMDBMedia+Additions.h"

@implementation OMDBMediaService

#pragma mark - Requests methods
- (void)getMediaWithSearchString:(NSString *)searchString
                      pageNumber:(NSInteger)pageNumber
                    successBlock:(void (^) (OMDBContainer *))success
                       failBlock:(void (^) (NSString *errorDescription))fail {
    // To make sure searchString is properly escaped
    NSString *url = [self searchResultUrlWithSearchString:[searchString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] pageNumber:pageNumber];

    __weak __typeof(self) weakSelf = self;

    // Cancel previous search request before starting a new one
    [self cancel];

    [self getContentWithUrl:url successBlock:^(NSData *data) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (success) {
            success([MTLJSONAdapter modelOfClass:[OMDBContainer class] fromJSONDictionary:jsonObject error:nil]);
        }
    } failBlock:^(NSString *errorDescription) {
        [weakSelf onDidLoadFailed:errorDescription failBlock:fail];
    }];
}

- (void)getFullMediaInfoWithMediaIdentifier:(NSString *)mediaId
                               successBlock:(void (^) (OMDBMedia *))success
                                  failBlock:(void (^) (NSString *errorDescription))fail {
    NSString *url = [self mediaFullInfoUrlWithMediaId:mediaId];

    __weak __typeof(self) weakSelf = self;

    [self getContentWithUrl:url successBlock:^(NSData *data) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (success) {
            success([MTLJSONAdapter modelOfClass:[OMDBMedia class] fromJSONDictionary:jsonObject error:nil]);
        }
    } failBlock:^(NSString *errorDescription) {
        [weakSelf onDidLoadFailed:errorDescription failBlock:fail];
    }];
}

- (void)getMediaImageWithUrl:(NSString *)imageUrl
               completeBlock:(void (^) (UIImage *))complete {
    [self downloadContentWithUrl:imageUrl successBlock:^(NSData *imageData) {
        UIImage *downloadedImage = [UIImage imageWithData:imageData];

        if (complete) {
            complete(downloadedImage);
        }
    } failBlock:nil];
}

#pragma mark - Error handler methods
- (void)onDidLoadFailed:(NSString *)errorDescription failBlock:(void (^) (NSString *errorDescription))fail {
    if (fail) {
        fail(errorDescription);
    }
}

#pragma mark - Url composing methods
- (NSString *)searchResultUrlWithSearchString:(NSString *)searchString pageNumber:(NSInteger)pageNumber {
    return [NSString stringWithFormat:@"%@?s=%@&page=%d", self.hostUrl, searchString, pageNumber];
}

- (NSString *)mediaFullInfoUrlWithMediaId:(NSString *)mediaId {
    return [NSString stringWithFormat:@"%@?i=%@", self.hostUrl, mediaId];
}

@end
