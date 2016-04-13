//
//  OMDBMedia.h
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 07/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

typedef enum {
    OMDBMediaTypeUndefined = 0,
    OMDBMediaTypeMovie = 1,
    OMDBMediaTypeSeries = 2,
    OMDBMediaTypeEpisode = 3
} OMDBMediaType;

#import "Mantle.h"

@interface OMDBMedia : MTLModel
<MTLJSONSerializing>

@property (nonatomic, strong) NSString *imdbIdentifier;

// Short description
@property (nonatomic, strong) NSString *posterUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) OMDBMediaType type;
// Good to have this one as integer
@property (nonatomic, strong) NSString *year;

// Full description
@property (nonatomic, strong) NSString *rated;
@property (nonatomic, strong) NSString *durationString;
@property (nonatomic, strong) NSString *genresString;
@property (nonatomic, strong) NSString *directorsString;
@property (nonatomic, strong) NSString *writersString;
@property (nonatomic, strong) NSString *actorsString;
@property (nonatomic, strong) NSString *plot;
@property (nonatomic, strong) NSString *mediaLanguagesString;
@property (nonatomic, strong) NSString *productionCountriesString;
@property (nonatomic, strong) NSString *awardsString;

// Would be good to have this one as a NSDate for future use
@property (nonatomic, strong) NSString *releaseDateString;

// Good to have these in CGFloat in case we need to compare medias
@property (nonatomic, strong) NSString *imdbRating;
@property (nonatomic, strong) NSString *imdbVotes;
@property (nonatomic, strong) NSString *metascore;

@end
