//
//  OMDBMessageCell.h
//  FilmDatabase
//
//  Created by Dilyara Mulyukova on 11/04/16.
//  Copyright © 2016 Dilyara Mulyukova. All rights reserved.
//

@interface OMDBMessageCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

+ (NSString *)reuseIdentifier;

@end
