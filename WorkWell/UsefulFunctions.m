//
//  UsefulFunctions.m
//  WorkWellNW2
//
//  Created by Aaron Wells on 6/24/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import "UsefulFunctions.h"
#import "User.h"
#import "Location.h"
#import "Course.h"
#import "PracticeSession.h"

#define YEAR_MONTH_DAY_HOUR_MINUTE_SECOND_COMPONENTS NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
#define HOURS_MINUTES_SECONDS NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
#define YEAR_MONTH_DAY_COMPONENTS NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit

@implementation UsefulFunctions

#pragma mark - DATE CONVERSIONS
+ (NSDate*)dateByAddingDays:(NSUInteger)days toDate:(NSDate*)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:YEAR_MONTH_DAY_HOUR_MINUTE_SECOND_COMPONENTS fromDate:date];
    components.day += days;
    
    return [calendar dateFromComponents:components];
}

+ (NSDictionary *)hoursMinutesSeconds:(NSTimeInterval)timeInterval {
    NSInteger hours, minutes, seconds;
    seconds = (NSInteger) timeInterval;
    hours = seconds / 3600;
    seconds %= 3600;
    minutes = seconds / 60;
    seconds %= 60;
    return @{@"hours":[NSNumber numberWithInteger:hours],@"minutes":[NSNumber numberWithInteger:minutes],@"seconds":[NSNumber numberWithInteger:seconds]};
}

+ (NSDate*)nextDateWithTimeOfDayFromDate:(NSDate*)theDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *theDateComponents = [calendar components:HOURS_MINUTES_SECONDS fromDate:theDate],
    *nowComponents = [calendar components:YEAR_MONTH_DAY_HOUR_MINUTE_SECOND_COMPONENTS fromDate:now];
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

+ (NSDate*)startOfDayWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    return [calendar dateFromComponents:components];
}

+ (NSTimeInterval)timeIntervalFromHoursAndMinutesOfDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:date];
    
    NSTimeInterval interval = [self timeIntervalWithHours:components.hour minutes:components.minute seconds:0];
    return interval;
}

+ (NSTimeInterval)timeIntervalWithHours:(NSUInteger)hours minutes:(NSUInteger)minutes seconds:(NSUInteger)seconds {
    seconds = seconds + (minutes * 60);
    seconds = seconds + (hours * 3600);
    return (NSTimeInterval) seconds;
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

+ (NSInteger)weekdayFromDate:(NSDate*)date {
    NSDateComponents *weekdayComponent = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    return [weekdayComponent weekday];
}

#pragma mark - UNIX TIME STRINGS
+ (NSString*)UNIXFormattedStringFromDate:(NSDate*)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString*)UNIXformattedStringWithUTCTimeFromDate:(NSDate*)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDateComponents *components = [calendar components:YEAR_MONTH_DAY_HOUR_MINUTE_SECOND_COMPONENTS fromDate:date];
    
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    date = [calendar dateFromComponents:components];
    
    return [self UNIXFormattedStringFromDate:date];
}

#pragma mark - ARRAYS
+ (id)randomObjectFromArray:(NSArray*)array {
    return [array objectAtIndex:(arc4random() % array.count)];
}

#pragma mark - XML
+ (NSString*)xmlFromUser:(User*)user {
    NSString *xml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><User><Username>%@</Username><Password>%@</Password><FirstName>%@</FirstName><LastName>%@</LastName><Location><Name>%@</Name></Location><Course><Name>%@</Name></Course></User>",
                     user.username,
                     user.password,
                     user.firstName,
                     user.lastName,
                     user.location.name,
                     user.course.name];
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
