//
//  OMDBDetailsTableViewController.m
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 07/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

#import "OMDBDetailsTableViewController.h"

#import "OMDBBasicInfoCell.h"
#import "OMDBInfoCell.h"
#import "OMDBActivityIndicatorCell.h"

#import "OMDBMedia+Additions.h"

@interface OMDBDetailsTableViewController ()

@property (nonatomic, strong) UITableView *theTableView;

@end

@implementation OMDBDetailsTableViewController

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        self.theTableView = tableView;

        self.isContentBeingLoaded = NO;

        [self setupCollectionView];
    }

    return self;
}

- (void)setupCollectionView {
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;

    self.theTableView.rowHeight = UITableViewAutomaticDimension;
    self.theTableView.estimatedRowHeight = 100;

    // Using nib for this cell since it's used in several controllers
    [self.theTableView registerNib:[UINib nibWithNibName:@"OMDBActivityIndicatorCell" bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:[OMDBActivityIndicatorCell reuseIdentifier]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setter methods
- (void)setIsContentBeingLoaded:(BOOL)isContentBeingLoaded {
    _isContentBeingLoaded = isContentBeingLoaded;

    [self reloadData];
}

#pragma mark - Public methods
- (void)reloadData {
    [self.theTableView reloadData];
}

#pragma mark - Helper methods
- (NSInteger)numberOfItems {
    return 13;
}

- (NSInteger)imageRow {
    return 0;
}

- (NSInteger)titleRow {
    return 1;
}

- (NSInteger)plotRow {
    return 2;
}

- (NSInteger)ratingRow {
    return 3;
}

- (NSInteger)genreRow {
    return 4;
}

- (NSInteger)directorsRow {
    return 5;
}

- (NSInteger)writersRow {
    return 6;
}

- (NSInteger)runtimeRow {
    return 7;
}

- (NSInteger)yearRow {
    return 8;
}

- (NSInteger)countriesRow {
    return 9;
}

- (NSInteger)releaseRow {
    return 10;
}

- (NSInteger)awardsRow {
    return 11;
}

- (NSInteger)imdbRatingRow {
    return 12;
}

- (OMDBInfoCell *)configureCellForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [self numberOfItems]) {
        return nil;
    }

    OMDBInfoCell *infoCell = [self.theTableView dequeueReusableCellWithIdentifier:[OMDBInfoCell reuseIdentifier] forIndexPath:indexPath];

    NSString *titleString = @"";
    NSString *contentString = @"";

    if (indexPath.row == [self titleRow]) {
        titleString = @"Title";
        contentString = self.currentMedia.title;
    } else if (indexPath.row == [self plotRow]) {
        titleString = @"Plot";
        contentString = self.currentMedia.plot;
    } else if (indexPath.row == [self ratingRow]) {
        titleString = @"Rating";
        contentString = self.currentMedia.rated;
    } else if (indexPath.row == [self genreRow]) {
        titleString = @"Genre";
        contentString = self.currentMedia.genresString;
    } else if (indexPath.row == [self directorsRow]) {
        titleString = @"Directed by";
        contentString = self.currentMedia.directorsString;
    } else if (indexPath.row == [self writersRow]) {
        titleString = @"Written by";
        contentString = self.currentMedia.writersString;
    } else if (indexPath.row == [self runtimeRow]) {
        titleString = @"Runtime";
        contentString = self.currentMedia.durationString;
    } else if (indexPath.row == [self yearRow]) {
        titleString = @"Year";
        contentString = self.currentMedia.year;
    } else if (indexPath.row == [self countriesRow]) {
        titleString = @"Countries";
        contentString = self.currentMedia.productionCountriesString;
    } else if (indexPath.row == [self releaseRow]) {
        titleString = @"Release date";
        contentString = self.currentMedia.releaseDateString;
    } else if (indexPath.row == [self awardsRow]) {
        titleString = @"Awards";
        contentString = self.currentMedia.awardsString;
    } else if (indexPath.row == [self imdbRatingRow]) {
        titleString = @"IMDB Rating";
        contentString = self.currentMedia.imdbRating;
    }

    infoCell.infoTitleLabel.text = titleString;
    infoCell.infoContentLabel.text = contentString;

    return infoCell;
}

#pragma mark - UITableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isContentBeingLoaded) {
        return 1;
    }

    return [self numberOfItems];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isContentBeingLoaded) {
        // Height for activityIndicatorCell
        return 250;
    }

    if (indexPath.row == [self imageRow]) {
        return 250;
    }

    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isContentBeingLoaded) {
        OMDBActivityIndicatorCell *cell = [tableView dequeueReusableCellWithIdentifier:[OMDBActivityIndicatorCell reuseIdentifier]];

        [cell.activityIndicator startAnimating];

        return cell;
    }

    if (indexPath.row == [self imageRow]) {
        OMDBBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[OMDBBasicInfoCell reuseIdentifier] forIndexPath:indexPath];

        // If image already loaded, then show image
        // Otherwise load it
        if (self.currentMedia.posterImage) {
            cell.mediaImageView.image = self.currentMedia.posterImage;
        } else if (self.currentMedia.posterUrl) {
            __weak OMDBBasicInfoCell *weakCell = cell;
            __weak OMDBMedia *weakMedia = self.currentMedia;

            [self.delegate detailsTableViewController:self
                                loadImageWithImageUrl:self.currentMedia.posterUrl
                                        completeBlock:^(UIImage *theImage) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                weakMedia.posterImage = theImage;

                                                weakCell.mediaImageView.image = theImage;
                                            });
                                        }];
        }
        
        return cell;
    }

    return [self configureCellForIndexPath:indexPath];
}

@end
