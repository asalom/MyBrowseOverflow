//
//  EmptyTableViewDataSource.h
//  MyBrowseOverflow
//
//  Created by Alex Salom on 22/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicTableViewDataSource : NSObject <UITableViewDataSource>
@property (strong) NSArray *topics;
@end
