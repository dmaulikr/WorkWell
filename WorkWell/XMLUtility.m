//
//  XMLUtility.m
//  WorkWell
//
//  Created by Aaron Wells on 8/11/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import "XMLUtility.h"
#import "User.h"
#import "Location.h"
#import "Course.h"
#import "PracticeSession.h"
#import "UsefulFunctions.h"

@implementation XMLUtility

+ (NSString*)xmlFromUser:(User*)user {
    NSString *xml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><User><Username>%@</Username><Password>%@</Password><FirstName>%@</FirstName><LastName>%@</LastName><Location><Name>%@</Name></Location><Course><Name>%@</Name></Course></User>",
                     user.username ? user.username : @"",
                     user.password ? user.password : @"",
                     user.firstName ? user.firstName : @"",
                     user.lastName ? user.lastName : @"",
                     user.location ? user.location.name : @"",
                     user.course ? user.course.name : @""];
    return xml;
}
+ (NSString*)xmlFromPracticeSession:(PracticeSession *)practiceSession {
    NSString *xml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><PracticeSession><Id></Id><Date>%@</Date><Duration>%f</Duration><Guided>%d</Guided><Username>%@</Username></PracticeSession>",
                     [UsefulFunctions UNIXformattedStringWithUTCTimeFromDate:practiceSession.date],
                     [practiceSession.duration doubleValue],
                     [practiceSession.guided boolValue],
                     practiceSession.user.username];
    return xml;
}
@end
