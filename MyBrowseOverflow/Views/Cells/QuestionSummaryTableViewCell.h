//
//  QuestionSummaryTableViewCell.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 27/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionSummaryTableViewCell : UITableViewCell
@property (strong) IBOutlet UILabel *titleLabel;
@property (strong) IBOutlet UILabel *nameLabel;
@property (strong) IBOutlet UILabel *scoreLabel;
@property (strong) IBOutlet UIImageView *avatarView;
@end
