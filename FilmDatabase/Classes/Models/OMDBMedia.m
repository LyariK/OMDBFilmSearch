//
//  OMDBMedia.m
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 07/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

#import "OMDBMedia.h"

@implementation OMDBMedia

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"imdbIdentifier" : @"imdbID",
             @"year" : @"Year",
             @"type" : @"Type",
             @"title" : @"Title",
             @"posterUrl" : @"Poster",
             @"rated" : @"Rated",
             @"releaseDateString" : @"Released",
             @"durationString" : @"Runtime",
             @"genresString" : @"Genre",
             @"directorsString" : @"Director",
             @"writersString" : @"Writer",
             @"actorsString" : @"Actors",
             @"plot" : @"Plot",
             @"mediaLanguagesString" : @"Language",
             @"productionCountriesString" : @"Country",
             @"awardsString" : @"Awards",
             @"metascore" : @"Metascore",
             @"imdbRating" : @"imdbRating",
             @"imdbVotes" : @"imdbVotes"};
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id JSON, BOOL *success, NSError *__autoreleasing *error) {
        NSString *currentType = JSON;
        OMDBMediaType type = OMDBMediaTypeUndefined;

        if ([currentType isEqualToString:@"movie"]) {
            type = OMDBMediaTypeMovie;
        } else if ([currentType isEqualToString:@"series"]) {
            type = OMDBMediaTypeSeries;
        } else if ([currentType isEqualToString:@"episode"]) {
            type = OMDBMediaTypeEpisode;
        }

        return @(type);
    }];
}

+ (NSValueTransformer *)posterUrlJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id JSON, BOOL *success, NSError *__autoreleasing *error) {
        NSString *currentUrl = JSON;

        if ([currentUrl isEqualToString:@"N/A"]) {
            currentUrl = nil;
        }

        return currentUrl;
    }];
}

@end
