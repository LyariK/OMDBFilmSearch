//
//  OMDBMedia+Additions.m
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 08/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

#import "OMDBMedia+Additions.h"

#import <objc/runtime.h>

@implementation OMDBMedia (Additions)

#pragma mark - Properties
- (UIImage *)posterImage {
    return objc_getAssociatedObject(self, @selector(posterImage));
}

- (void)setPosterImage:(UIImage *)thePosterImage {
    objc_setAssociatedObject(self, @selector(posterImage), thePosterImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - methods
- (void)clearImage {
    self.posterImage = nil;
}

@end
