//
//  OMDBService.h
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 11/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

@interface OMDBService : NSObject

@property (nonatomic, strong) NSString *hostUrl;

- (void)getContentWithUrl:(NSString *)url
             successBlock:(void (^) (NSData *))success
                failBlock:(void (^) (NSString *errorDescription))fail;

- (void)downloadContentWithUrl:(NSString *)url
                  successBlock:(void (^) (NSData *))success
                     failBlock:(void (^) (NSString *errorDescription))fail;

- (void)cancel;

@end
