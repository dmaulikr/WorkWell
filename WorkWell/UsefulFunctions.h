//
//  UsefulFunctions.h
//  WorkWellNW2
//
//  Created by Aaron Wells on 6/24/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsefulFunctions : NSObject
+ (NSDate*)startOfDayWithDate:(NSDate*)date;
+ (NSDate*)nextDateWithTimeOfDayFromDate:(NSDate*)theDate;
+ (NSDate*)nextDateWithTimeOfDayFromTimeInterval:(NSTimeInterval)timeInterval;
+ (NSTimeInterval)timeIntervalWithHours:(NSUInteger)hours minutes:(NSUInteger)minutes seconds:(NSUInteger)seconds;
+ (NSTimeInterval)timeIntervalFromHoursAndMinutesOfDate:(NSDate*)date;
+ (NSDate*)dateByAddingDays:(NSUInteger)days toDate:(NSDate*)date;
+ (id)randomObjectFromArray:(NSArray*)array;
+ (NSDate*)nextWeekdayAfterDate:(NSDate*)date;
+ (NSDate*)nextWeekdayWithTimeOfDayFromTimeInterval:(NSTimeInterval)timeInterval;
+ (NSInteger)weekdayFromDate:(NSDate*)date;

@end
