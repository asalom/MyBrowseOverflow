//
//  MockStackOverflowCommunicator.m
//  MyBrowseOverflow
//
//  Created by Alex Salom on 18/5/15.
//  Copyright (c) 2015 Alex Salom © alexsalom.es. All rights reserved.
//

#import "MockStackOverflowCommunicator.h"

@implementation MockStackOverflowCommunicator

@synthesize wasAskedToFetchQuestions    = _wasAskedToFetchQuestions;

- (BOOL)wasAskedToFetchQuestions {
    return _wasAskedToFetchQuestions;
}

- (void)searchForQuestionsWithTag:(NSString *)tag {
    _wasAskedToFetchQuestions = YES;
}

@end
