//
//  OMDBActivityIndicatorCell.h
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 11/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

@interface OMDBActivityIndicatorCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

+ (NSString *)reuseIdentifier;

@end
