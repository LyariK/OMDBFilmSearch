//
//  OMDBBasicInfoCell.h
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 08/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

@interface OMDBBasicInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *mediaImageView;

+ (NSString *)reuseIdentifier;

@end
