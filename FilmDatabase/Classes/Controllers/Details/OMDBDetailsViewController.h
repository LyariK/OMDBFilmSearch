//
//  OMDBDetailsViewController.h
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 07/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

@class OMDBMedia;

@interface OMDBDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) OMDBMedia *media;

@end
