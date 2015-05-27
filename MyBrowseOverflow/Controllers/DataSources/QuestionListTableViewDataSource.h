//
//  QuestionListTableViewDataSource.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 27/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Topic;

@interface QuestionListTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>
@property (strong) Topic *topic;
@end
