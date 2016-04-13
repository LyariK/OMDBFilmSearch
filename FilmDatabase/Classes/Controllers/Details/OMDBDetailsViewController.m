//
//  OMDBDetailsViewController.m
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 07/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

#import "OMDBDetailsViewController.h"
#import "OMDBDetailsTableViewController.h"

#import "OMDBMediaService.h"

#import "OMDBMedia+Additions.h"

@interface OMDBDetailsViewController ()
<OMDBDetailsTableViewControllerDelegate>

@property (nonatomic, strong) OMDBDetailsTableViewController *tableVC;

@property (nonatomic, strong) OMDBMediaService *mediaService;

@end

@implementation OMDBDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Details";

    self.mediaService = [[OMDBMediaService alloc] init];

    self.tableVC = [[OMDBDetailsTableViewController alloc] initWithTableView:self.tableView];
    self.tableVC.delegate = self;
    self.tableVC.currentMedia = self.media;

    [self loadMediaInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    [self.media clearImage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.mediaService cancel];
}

#pragma mark - URL methods
- (void)loadMediaInfo {
    [self showActivityIndicator];

    __weak __typeof(self) weakSelf = self;

    [self.mediaService getFullMediaInfoWithMediaIdentifier:self.media.imdbIdentifier
                                              successBlock:^(OMDBMedia *theMedia) {
                                                  // As we want to perform UI update on the main thread
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [weakSelf onDidLoadMediaInfoSucceed:theMedia];
                                                  });
                                              }
                                                 failBlock:^(NSString *errorDescription) {
                                                     // As we want to perform UI update on the main thread
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [weakSelf onDidLoadMediaInfoFailed:errorDescription];
                                                     });
                                                 }];
}

#pragma mark - Helper methods
- (void)onDidLoadMediaInfoSucceed:(OMDBMedia *)theMedia {
    [self hideActivityIndicator];

    self.media = theMedia;

    self.tableVC.currentMedia = self.media;

    [self.tableVC reloadData];
}

- (void)onDidLoadMediaInfoFailed:(NSString *)errorDescription {
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

#pragma mark - OMDBDetailsTableViewControllerDelegate methods
- (void)detailsTableViewController:(OMDBDetailsTableViewController *)searchTableVC loadImageWithImageUrl:(NSString *)imageUrl completeBlock:(void (^)(UIImage *))completeBlock {
    [self.mediaService getMediaImageWithUrl:imageUrl
                              completeBlock:completeBlock];
}

@end
