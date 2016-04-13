//
//  OMDBContainer.m
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 08/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

#import "OMDBContainer.h"

#import "OMDBMedia.h"

@implementation OMDBContainer

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"mediasList" : @"Search",
             @"total" : @"totalResults"};
}

+ (NSValueTransformer *)totalJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id JSON, BOOL *success, NSError *__autoreleasing *error) {
        return @([JSON integerValue]);
    }];
}

+ (NSValueTransformer *)mediasListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OMDBMedia class]];
}

@end
