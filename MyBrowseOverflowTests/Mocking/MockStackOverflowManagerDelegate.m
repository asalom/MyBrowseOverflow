//
//  MockStackOverflowManagerDelegate.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 18/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "MockStackOverflowManagerDelegate.h"

@implementation MockStackOverflowManagerDelegate

- (void)fetchingQuestionsFailedWithError:(NSError *)error {
    self.fetchError = error;
}

- (void)didReceiveQuestions:(NSArray *)questions {
    // silence warning
}

- (void)fetchingQuestionBodyFailedWithError:(NSError *)error {
    // silence warning
}

- (void)didReceiveBodyForQuestion:(Question *)question {
    // silence warning
}

@end
