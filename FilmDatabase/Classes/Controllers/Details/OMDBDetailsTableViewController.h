//
//  OMDBDetailsTableViewController.h
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 07/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

@protocol OMDBDetailsTableViewControllerDelegate;

@class OMDBMedia;

@interface OMDBDetailsTableViewController : UIViewController
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, weak) id<OMDBDetailsTableViewControllerDelegate> delegate;

@property (nonatomic, strong) OMDBMedia *currentMedia;

@property (nonatomic, assign) BOOL isContentBeingLoaded;

- (instancetype)initWithTableView:(UITableView *)tableView;

- (void)reloadData;

@end

@protocol OMDBDetailsTableViewControllerDelegate <NSObject>

- (void)detailsTableViewController:(OMDBDetailsTableViewController *)searchTableVC
             loadImageWithImageUrl:(NSString *)imageUrl
                     completeBlock:(void (^) (UIImage *))completeBlock;

@end