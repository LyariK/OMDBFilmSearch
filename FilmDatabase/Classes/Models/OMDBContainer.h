//
//  OMDBContainer.h
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 08/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface OMDBContainer : MTLModel
<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSMutableArray *mediasList;

@end
