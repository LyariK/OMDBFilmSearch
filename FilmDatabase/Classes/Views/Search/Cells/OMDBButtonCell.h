//
//  OMDBButtonCell.h
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 11/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

@interface OMDBButtonCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *button;

+ (NSString *)reuseIdentifier;

@end
