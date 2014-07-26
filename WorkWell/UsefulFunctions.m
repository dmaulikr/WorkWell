//
//  UsefulFunctions.m
//  WorkWellNW2
//
//  Created by Aaron Wells on 6/24/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import "UsefulFunctions.h"
#define ALL_CALENDAR_COMPONENTS NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
#define HOURS_MINUTES_SECONDS NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
#define YEAR_MONTH_DAY_COMPONENTS NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit

@implementation UsefulFunctions
+ (NSDictionary *)hoursMinutesSeconds:(NSTimeInterval)timeInterval {
    NSInteger hours, minutes, seconds;
    seconds = (NSInteger) timeInterval;
    hours = seconds / 3600;
    seconds %= 3600;
    minutes = seconds / 60;
    seconds %= 60;
    return @{@"hours":[NSNumber numberWithInteger:hours],@"minutes":[NSNumber numberWithInteger:minutes],@"seconds":[NSNumber numberWithInteger:seconds]};
}

+ (NSDictionary *)timeOfDayWithPeriod:(NSTimeInterval)timeInterval {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[self hoursMinutesSeconds:timeInterval]];
    NSString * period;
    if ([[result objectForKey:@"hours"] integerValue] > 11) {
        period = @"PM";
    } else {
        period = @"AM";
    }
    
    switch ([[result objectForKey:@"hours"] integerValue]) {
        case 0:
        case 12:
            [result setObject:[NSNumber numberWithInt:12] forKey:@"hours"];
            break;
        default:
            break;
    }
    
    if ([[result objectForKey:@"hours"] integerValue] > 23) {
        return nil;
    }
    
    [result setObject:period forKey:@"period"];
    return (NSDictionary*)result;
}

+ (NSTimeInterval)timeIntervalWithHours:(NSUInteger)hours minutes:(NSUInteger)minutes seconds:(NSUInteger)seconds {
    seconds = seconds + (minutes * 60);
    seconds = seconds + (hours * 3600);
    return (NSTimeInterval) seconds;
}

+ (NSDate*)startOfDayWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    return [calendar dateFromComponents:components];
}

+ (NSDate*)nextDateWithTimeOfDayFromDate:(NSDate*)theDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *theDateComponents = [calendar components:HOURS_MINUTES_SECONDS fromDate:theDate],
    *nowComponents = [calendar components:ALL_CALENDAR_COMPONENTS fromDate:now];
    [theDateComponents setYear:[nowComponents year]];
    [theDateComponents setMonth:[nowComponents month]];
    [theDateComponents setDay:[nowComponents day]];
    
    theDate = [calendar dateFromComponents:theDateComponents];
    
    if ([theDate compare:now] < 0) {
        [theDateComponents setDay:(theDateComponents.day + 1)];
        theDate = [calendar dateFromComponents:theDateComponents];
    }
    
    return theDate;
}

+ (NSDate*)nextDateWithTimeOfDayFromTimeInterval:(NSTimeInterval)timeInterval {
    NSDate *today = [self startOfDayWithDate:[NSDate date]];
    return [today dateByAddingTimeInterval:timeInterval];
}

+ (NSDate*)dateByAddingDays:(NSUInteger)days toDate:(NSDate*)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:ALL_CALENDAR_COMPONENTS fromDate:date];
    components.day += days;
    
    return [calendar dateFromComponents:components];
}

+ (NSTimeInterval)timeIntervalFromHoursAndMinutesOfDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:date];
    
    NSTimeInterval interval = [self timeIntervalWithHours:components.hour minutes:components.minute seconds:0];
    return interval;
}

+ (id)randomObjectFromArray:(NSArray*)array {
    return [array objectAtIndex:(arc4random() % array.count)];
}

+ (NSDate*)nextWeekdayAfterDate:(NSDate*)date {
    NSDate *next;
    NSInteger weekday = [self weekdayFromDate:date];
    
    switch (weekday) {
        case 1:
            next = [self dateByAddingDays:1 toDate:date];
            break;
        case 7:
            next = [self dateByAddingDays:2 toDate:date];
            break;
        default:
            next = date;
            break;
    }
    
    return next;
}

+ (NSDate*)nextWeekdayWithTimeOfDayFromTimeInterval:(NSTimeInterval)timeInterval {
    NSDate *date = [self nextDateWithTimeOfDayFromTimeInterval:timeInterval];
    return [self nextWeekdayAfterDate:date];
}

+ (NSInteger)weekdayFromDate:(NSDate*)date {
    NSDateComponents *weekdayComponent = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    return [weekdayComponent weekday];
}
@end
