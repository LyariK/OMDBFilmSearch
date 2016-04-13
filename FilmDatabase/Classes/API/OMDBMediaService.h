//
//  OMDBMediaService.h
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 07/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

#import "OMDBService.h"

@class OMDBContainer;
@class OMDBMedia;

@interface OMDBMediaService : OMDBService

- (void)getMediaWithSearchString:(NSString *)searchString
                      pageNumber:(NSInteger)pageNumber
                    successBlock:(void (^) (OMDBContainer *))success
                       failBlock:(void (^) (NSString *errorDescription))fail;

- (void)getFullMediaInfoWithMediaIdentifier:(NSString *)mediaId
                               successBlock:(void (^) (OMDBMedia *))success
                                  failBlock:(void (^) (NSString *errorDescription))fail;

- (void)getMediaImageWithUrl:(NSString *)imageUrl
               completeBlock:(void (^) (UIImage *))complete;

@end
