//
//  UsefulFunctions.h
//  WorkWellNW2
//
//  Created by Aaron Wells on 6/24/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User, Location, Course, PracticeSession;

@interface UsefulFunctions : NSObject
+ (NSDate*)dateByAddingDays:(NSUInteger)days toDate:(NSDate*)date;
+ (NSDictionary *)hoursMinutesSeconds:(NSTimeInterval)timeInterval;
+ (NSDate*)nextDateWithTimeOfDayFromDate:(NSDate*)theDate;
+ (NSDate*)nextDateWithTimeOfDayFromTimeInterval:(NSTimeInterval)timeInterval;
+ (NSDate*)nextWeekdayAfterDate:(NSDate*)date;
+ (NSDate*)nextWeekdayWithTimeOfDayFromTimeInterval:(NSTimeInterval)timeInterval;
+ (NSDate*)startOfDayWithDate:(NSDate*)date;
+ (NSTimeInterval)timeIntervalFromHoursAndMinutesOfDate:(NSDate*)date;
+ (NSTimeInterval)timeIntervalWithHours:(NSUInteger)hours minutes:(NSUInteger)minutes seconds:(NSUInteger)seconds;
+ (NSDictionary *)timeOfDayWithPeriod:(NSTimeInterval)timeInterval;
+ (NSInteger)weekdayFromDate:(NSDate*)date;

+ (NSString*)UNIXFormattedStringFromDate:(NSDate*)date;
+ (NSString*)UNIXformattedStringWithUTCTimeFromDate:(NSDate*)date;

+ (id)randomObjectFromArray:(NSArray*)array;

+ (NSString*)xmlFromUser:(User*)user;
+ (NSString*)xmlFromPracticeSession:(PracticeSession*)practiceSession;

@end
