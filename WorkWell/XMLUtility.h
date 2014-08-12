//
//  XMLUtility.h
//  WorkWell
//
//  Created by Aaron Wells on 8/11/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User, Location, Course, PracticeSession, UsefulFunctions;

@interface XMLUtility : NSObject


+ (NSString*)xmlFromUser:(User*)user;
+ (NSString*)xmlFromPracticeSession:(PracticeSession*)practiceSession;
@end
