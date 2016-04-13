//
//  OMDBSearchResultCell.h
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 08/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

@interface OMDBSearchResultCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *mediaTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mediaImageView;

+ (NSString *)reuseIdentifier;

@end
