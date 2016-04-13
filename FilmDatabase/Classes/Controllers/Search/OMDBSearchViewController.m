//
//  OMDBSearchViewController.m
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 07/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

#import "OMDBSearchViewController.h"
#import "OMDBSearchTableViewController.h"
#import "OMDBDetailsViewController.h"

#import "OMDBMediaService.h"

#import "OMDBContainer+Additions.h"

@interface OMDBSearchViewController ()
<UISearchBarDelegate,
OMDBSearchTableViewControllerDelegate>

@property (nonatomic, strong) OMDBSearchTableViewController *tableVC;

@property (nonatomic, strong) OMDBMediaService *mediaService;

@end

@implementation OMDBSearchViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.mediaService = [[OMDBMediaService alloc] init];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableVC = [[OMDBSearchTableViewController alloc] initWithTableView:self.tableView];
    self.tableVC.delegate = self;

    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    [self.tableVC.container clearImages];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.mediaService cancel];
}

#pragma mark - UISearchBarDelegate methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        self.tableVC.container = nil;

        [self.tableVC reloadData];
    }

    // Start search with at least 2 symbols
    if (searchText.length <= 1) {
        return;
    }

    [self startSearch:searchText];
}

#pragma mark - API Methods
- (void)loadSearchResultsForSearchText:(NSString *)searchText {
    [self showActivityIndicator];

    __weak typeof(self) weakSelf = self;

    [self.mediaService getMediaWithSearchString:searchText
                                     pageNumber:[self pageNumberToLoad]
                                   successBlock:^(OMDBContainer *theContainer) {
                                       // As we want to perform UI update on the main thread
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [weakSelf onDidLoadContainer:theContainer];
                                       });
                                   }
                                      failBlock:^(NSString *errorDescription) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [weakSelf onDidFailLoad:errorDescription];
                                          });
                                      }];
}

#pragma mark - Helper methods
- (void)onDidLoadContainer:(OMDBContainer *)theContainer {
    [self hideActivityIndicator];

    // If we load more results => append them
    // Otherwise just use the result
    if (self.tableVC.container) {
        [self.tableVC.container.mediasList addObjectsFromArray:theContainer.mediasList];

        [self.tableVC reloadData];
    } else {
        self.tableVC.container = theContainer;
    }
}

- (void)onDidFailLoad:(NSString *)errorDescription {
    [self hideActivityIndicator];

    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:errorDescription
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)showActivityIndicator {
    self.tableVC.isContentBeingLoaded = YES;
}

- (void)hideActivityIndicator {
    self.tableVC.isContentBeingLoaded = NO;
}

- (void)startSearch:(NSString *)searchText {
    self.tableVC.container = nil;

    [self loadSearchResultsForSearchText:searchText];
}

- (NSInteger)pageNumberToLoad {
    // Suppose that we have 10 elements in eqch result
    // Good to have it in the response
    return self.tableVC.container.mediasList.count / 10 + 1;
}

#pragma mark - OMDBSearchTableViewControllerDelegate methods
- (void)searchTableViewController:(OMDBSearchTableViewController *)searchCollectionVC loadImageWithImageUrl:(NSString *)imageUrl completeBlock:(void (^)(UIImage *))completeBlock {
    [self.mediaService getMediaImageWithUrl:imageUrl
                              completeBlock:completeBlock];
}

- (void)searchTableViewController:(OMDBSearchTableViewController *)searchCollectionVC didChooseMedia:(OMDBMedia *)media {
    OMDBDetailsViewController *detailsController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsViewController"];
    detailsController.media = media;

    [self.navigationController pushViewController:detailsController animated:YES];
}

- (void)searchTableViewControllerRequestedLoadMore:(OMDBSearchTableViewController *)searchTableVC {
    [self loadSearchResultsForSearchText:self.searchBar.text];
}

@end
