//
//  AnswerTableViewCell.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 5/6/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *acceptedIndicator;
@property (nonatomic, weak) IBOutlet UILabel *personName;
@property (nonatomic, weak) IBOutlet UIImageView *personAvatar;
@property (nonatomic, weak) IBOutlet UIWebView *bodyWebView;

@end
