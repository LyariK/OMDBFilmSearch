//
//  OMDBSearchTableViewController.m
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 07/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

#import "OMDBSearchTableViewController.h"

#import "OMDBSearchResultCell.h"
#import "OMDBActivityIndicatorCell.h"
#import "OMDBMessageCell.h"
#import "OMDBButtonCell.h"

#import "OMDBContainer+Additions.h"
#import "OMDBMedia+Additions.h"

@interface OMDBSearchTableViewController ()

@property (nonatomic, strong) UITableView *theTableView;

@end

@implementation OMDBSearchTableViewController

- (instancetype)initWithTableView:(UITableView *)TableView {
    if (self = [super init]) {
        self.theTableView = TableView;

        [self setupTableView];
    }

    return self;
}

- (void)setupTableView {
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;

    self.theTableView.rowHeight = 150;

    // Using nib for this cell since it's used in several controllers
    [self.theTableView registerNib:[UINib nibWithNibName:@"OMDBActivityIndicatorCell" bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:[OMDBActivityIndicatorCell reuseIdentifier]];
}

#pragma mark- Setter methods
- (void)setIsContentBeingLoaded:(BOOL)isContentBeingLoaded {
    _isContentBeingLoaded = isContentBeingLoaded;

    [self reloadData];
}

#pragma mark - Public methods
- (void)reloadData {
    [self.theTableView reloadData];
}

#pragma mark - Helper methods
- (OMDBSearchResultCell *)configureSearchResultCell:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.container.mediasList.count) {
        return nil;
    }

    OMDBSearchResultCell *cell = [self.theTableView dequeueReusableCellWithIdentifier:[OMDBSearchResultCell reuseIdentifier] forIndexPath:indexPath];

    OMDBMedia *currentMedia = self.container.mediasList[indexPath.row];

    cell.mediaTitleLabel.text = currentMedia.title;

    // If image already loaded, then show image
    // Otherwise load it
    if (currentMedia.posterImage) {
        cell.mediaImageView.image = currentMedia.posterImage;
    } else if (currentMedia.posterUrl) {
        __weak OMDBSearchResultCell *weakCell = cell;
        __weak OMDBMedia *weakMedia = currentMedia;

        [self.delegate searchTableViewController:self
                           loadImageWithImageUrl:currentMedia.posterUrl
                                   completeBlock:^(UIImage *theImage) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           weakMedia.posterImage = theImage;

                                           weakCell.mediaImageView.image = theImage;
                                       });
                                   }];
    }
    
    return cell;
}

- (OMDBActivityIndicatorCell *)configureActivityIndicatorCell:(NSIndexPath *)indexPath {
    OMDBActivityIndicatorCell *cell = [self.theTableView dequeueReusableCellWithIdentifier:[OMDBActivityIndicatorCell reuseIdentifier] forIndexPath:indexPath];
    [cell.activityIndicator startAnimating];

    return cell;
}

#pragma mark - Setter methods
- (void)setContainer:(OMDBContainer *)container {
    _container = container;

    [self reloadData];
}

#pragma mark - UICollectionViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;

    if (self.container) {
        if (self.container.mediasList.count == 0) {
            // No content found or content is being loaded
            numberOfRows = 1;
        } else {
            if (self.container.isFullyLoaded) {
                // Content is loaded
                return self.container.mediasList.count;
            } else {
                // Found items + 1 cell for activityIndicatorCell / loadMoreCell
                return self.container.mediasList.count + 1;
            }
        }
    } else if (self.isContentBeingLoaded) {
        // Content is being loaded
        numberOfRows = 1;
    }

    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.container.mediasList.count == 0) {
        // Results are being loaded right now
        if (self.isContentBeingLoaded) {
            return [self configureActivityIndicatorCell:indexPath];
        } else {
            // No content found
            OMDBMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:[OMDBMessageCell reuseIdentifier] forIndexPath:indexPath];

            cell.messageLabel.text = @"No results found";

            return cell;
        }
    } else {
        if (self.isContentBeingLoaded) {
            // Found rows + activityIndicatorCell
            if (indexPath.row < self.container.mediasList.count) {
                return [self configureSearchResultCell:indexPath];
            } else {
                return [self configureActivityIndicatorCell:indexPath];
            }
        } else {
            if (self.container.isFullyLoaded) {
                // Loaded all results
                return [self configureSearchResultCell:indexPath];
            } else {
                // Found results + loadMoreCell
                if (indexPath.row < self.container.mediasList.count) {
                    return [self configureSearchResultCell:indexPath];
                } else {
                    OMDBButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:[OMDBButtonCell reuseIdentifier] forIndexPath:indexPath];

                    [cell.button setTitle:@"Load more results" forState:UIControlStateNormal];

                    [cell.button addTarget:self action:@selector(loadMoreButtonClicked) forControlEvents:UIControlEventTouchUpInside];

                    return cell;
                }
            }
        }
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate searchTableViewController:self didChooseMedia:self.container.mediasList[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isContentBeingLoaded && !self.container.isFullyLoaded && indexPath.row >= self.container.mediasList.count) {
        // We don't want buttonCell to be that big
        return 80;
    }

    if (self.isContentBeingLoaded && indexPath.row >= self.container.mediasList.count) {
        // Height for activityIndicatorCell
        return 80;
    }

    return tableView.rowHeight;
}

#pragma mark - Actions methods
- (void)loadMoreButtonClicked {
    [self.delegate searchTableViewControllerRequestedLoadMore:self];
}

@end
