//
//  OMDBSearchTableViewController.h
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 07/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

@protocol OMDBSearchTableViewControllerDelegate;

@class OMDBContainer;
@class OMDBMedia;

@interface OMDBSearchTableViewController : UIViewController
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, weak) id<OMDBSearchTableViewControllerDelegate> delegate;

@property (nonatomic, strong) OMDBContainer *container;

@property (nonatomic, assign) BOOL isContentBeingLoaded;

- (instancetype)initWithTableView:(UITableView *)TableView;

- (void)reloadData;

@end

@protocol OMDBSearchTableViewControllerDelegate <NSObject>

- (void)searchTableViewController:(OMDBSearchTableViewController *)searchTableVC loadImageWithImageUrl:(NSString *)imageUrl completeBlock:(void (^) (UIImage *))completeBlock;
- (void)searchTableViewController:(OMDBSearchTableViewController *)searchTableVC didChooseMedia:(OMDBMedia *)media;
- (void)searchTableViewControllerRequestedLoadMore:(OMDBSearchTableViewController *)searchTableVC;

@end