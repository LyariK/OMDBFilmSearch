//
//  OMDBInfoCell.h
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 08/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

@interface OMDBInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *infoTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoContentLabel;

+ (NSString *)reuseIdentifier;

@end
