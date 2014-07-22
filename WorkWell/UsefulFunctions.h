//
//  UsefulFunctions.h
//  WorkWellNW2
//
//  Created by Aaron Wells on 6/24/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsefulFunctions : NSObject
+ (NSDictionary *)hoursMinutesSeconds:(NSTimeInterval)timeInterval;
+ (NSDictionary *)timeOfDayWithPeriod:(NSTimeInterval)timeInterval;
+ (NSTimeInterval)timeIntervalWithHours:(NSUInteger)hours minutes:(NSUInteger)minutes seconds:(NSUInteger)seconds;
+ (NSDate*)startOfDayWithDate:(NSDate *)date;
+ (NSTimeInterval)timeIntervalFromHoursAndMinutesOfDate:(NSDate *)date;

@end
