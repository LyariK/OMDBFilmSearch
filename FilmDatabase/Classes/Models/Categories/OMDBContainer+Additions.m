//
//  OMDBContainer+Additions.m
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 08/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

#import "OMDBContainer+Additions.h"

#import "OMDBMedia+Additions.h"

@implementation OMDBContainer (Additions)

#pragma mark - Methods
- (BOOL)isFullyLoaded {
    return (self.mediasList.count == self.total);
}

- (void)clearImages {
    for (OMDBMedia *media in self.mediasList) {
        [media clearImage];
    }
}

@end
