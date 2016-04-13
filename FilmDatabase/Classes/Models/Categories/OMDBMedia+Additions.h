//
//  OMDBMedia+Additions.h
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 08/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

#import "OMDBMedia.h"

@interface OMDBMedia (Additions)

@property (nonatomic, strong) UIImage *posterImage;

- (void)clearImage;

@end
