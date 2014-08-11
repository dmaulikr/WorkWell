//
//  AppDelegate.m
//  WorkWell
//
//  Created by Aaron Wells on 7/17/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import "AppDelegate.h"
#import "Location.h"
#import "Course.h"

@interface AppDelegate ()
@property (strong, nonatomic)NSDateFormatter *df;

@end

@implementation AppDelegate
// TODO cleanup constants and rework pragma marks to clarify purpose

#pragma mark - CONSTANTS
#define debug 0
#define kMaxNotificationsAllowed 64

#pragma mark - DELEGATE
- (void)demo {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    // MARK: load sample audio into database
//    NSString *fiveMinFile = [[NSBundle mainBundle] pathForResource:@"5_minute_meditation" ofType:@"mp3"];
//    NSURL *fiveMinURL = [NSURL fileURLWithPath:fiveMinFile];
//    
//    NSLog(@"five minute URL: %@", [fiveMinURL path]);
//    NSError *error = nil;
//    AudioFile *audioFile = [NSEntityDescription insertNewObjectForEntityForName:@"AudioFile" inManagedObjectContext:_coreDataHelper.context];
//    [audioFile setData:[NSData dataWithContentsOfURL:fiveMinURL options:NSDataReadingMappedIfSafe error:&error]];
//    if (error) {
//        NSLog(@"Error: %@ '%@'", error, [error localizedDescription]);
//    }
//    audioFile.name = @"Five Minute Meditation";
//    NSLog(@"safe loading!");
    
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AudioFile"];
//    NSError *error = nil;
//    NSArray *fetchedObjects = [_coreDataHelper.context executeFetchRequest:request error:&error];
//    if (error) {NSLog(@"Error: %@", error.localizedDescription);}
//    for (AudioFile *object in fetchedObjects) {
//        [_coreDataHelper.context deleteObject:object];
//    }
    
//    [self updateNotifications];
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AudioFile"];
//    NSError *error = nil;
//    AudioFile *meditationFile = [[_coreDataHelper.context executeFetchRequest:request error:&error] objectAtIndex:0];
//    if (error) {NSLog(@"Error: %@ '%@'", error, [error localizedDescription]);}
//    
//    GuidedMeditation *guidedMeditation;
//    
//    for (int i = 0; i < 10; i++) {
//        guidedMeditation = [NSEntityDescription insertNewObjectForEntityForName:@"GuidedMeditation" inManagedObjectContext:_coreDataHelper.context];
//        guidedMeditation.audioFile = meditationFile;
//        guidedMeditation.title = [NSString stringWithFormat:@"Guided Meditation %02d", i+1];
//    }
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"GuidedMeditation"];
//    NSArray *fetchedObjects = [_coreDataHelper.context executeFetchRequest:request error:nil];
//    for (GuidedMeditation *gm in fetchedObjects) {
//        [_coreDataHelper.context deleteObject:gm];
//    }
    
//    [[NSUserDefaults standardUserDefaults] setObject:@"chacewells" forKey:CurrentUserKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CurrentUserKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];

//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PracticeSession"];
//    NSError *error = nil;
//    NSArray *fetchedObjects = [_coreDataHelper.context executeFetchRequest:request error:&error];
//    for (PracticeSession *ps in fetchedObjects) {
//        [_coreDataHelper.context deleteObject:ps];
//    }
//    Location *loc = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:_coreDataHelper.context];
//    loc.name = @"St Joseph";
//    Course *course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:_coreDataHelper.context];
//    course.name = @"the good one";
    
//    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:_coreDataHelper.context];
//    user.username = @"penguin";
//    user.firstName = @"Bass";
//    user.lastName = @"McGhie";
    
    [_coreDataHelper saveContext];
}

- (CoreDataHelper*)cdh {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    if (!_coreDataHelper) {
        _coreDataHelper = [[CoreDataHelper alloc] init];
        [_coreDataHelper setupCoreData];
    }
    
    return _coreDataHelper;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    [[self cdh] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    [self dateFormatter];
    [self cdh];
    [self demo];
    [self updateNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)scheduleMindfulMinuteNotifications {
    // 
}

- (NSDateFormatter*)dateFormatter {
    _df = [NSDateFormatter new];
    _df.dateStyle = NSDateFormatterShortStyle;
    _df.timeStyle = NSDateFormatterShortStyle;
    return _df;
}

#pragma mark - MINDFUL MINUTE MANAGER

- (void)populateDatabase {
    // MARK: for testing purposes only
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components;
    NSDate *date, *today = [UsefulFunctions startOfDayWithDate:[NSDate date]];
    int i;
    
    /*
     add some notifications to current application
     */
    UILocalNotification *notify;
    
    for (int i=0; i<6; i++) {
        components = [NSDateComponents new];
        components.hour = i + 6;
        
        for (int j=0; j<6; j++) {
            components.day = j + 1;
            components.minute = 30;
            date = [calendar dateByAddingComponents:components toDate:today options:0];
            notify = [UILocalNotification new];
            notify.fireDate = date;
            notify.alertBody = @"This is a notification";
            [[UIApplication sharedApplication] scheduleLocalNotification:notify];
        }
    }
    
    /*
     populate "database" with MindfulMinuteInstances to compare against
     */
    MindfulMinuteInstance *mmi;
    
    for (int i=6; i<12; i++) {
        components = [NSDateComponents new];
        components.hour = i;
        components.minute = 30;
        date = [calendar dateByAddingComponents:components toDate:today options:0];
        mmi = [NSEntityDescription insertNewObjectForEntityForName:@"MindfulMinuteInstance" inManagedObjectContext:_coreDataHelper.context];
        mmi.timeOfDay = [NSNumber numberWithDouble:[UsefulFunctions timeIntervalFromHoursAndMinutesOfDate:date]];
    }
    
    /*
     populate "database" with MindfulMinuteTemplates to derive local notifications
     */
    MindfulMinuteTemplate *mmt;
    
    NSArray *templateAlertBodies = @[@"Stop. Listen", @"Be still", @"Chill out", @"Relax, man.", @"Look out the window or somethin'", @"Breathe deep, brotha. The day's not that long."];
    NSArray *templateSoundNames = @[@"beep-ping.wav", @"zen-temple-bell.wav", @"doorbell.wav", @"ting.wav", @"ship-bell.wav", @"gong.wav"];
    
    i = 0;
    for (NSString *alertBody in templateAlertBodies) {
        mmt = [NSEntityDescription insertNewObjectForEntityForName:@"MindfulMinuteTemplate" inManagedObjectContext:_coreDataHelper.context];
        mmt.alertBody = alertBody;
        mmt.soundName = templateSoundNames[i];
        i++;
    }
    
    [_coreDataHelper saveContext];
}

- (void)displayTemplates {
    NSArray *mmts;
    MindfulMinuteTemplate *mmt;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"MindfulMinuteTemplate"];
    
    NSError *error;
    mmts = [_coreDataHelper.context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Error: %@ '%@'", error, [error localizedDescription]);
    }
    
    for (mmt in mmts) {
        NSLog(@"MindfulMinuteTemplate '%@': '%@'", mmt.alertBody, mmt.soundName);
    }
}

- (void)displayInstances {
    NSArray *mmis;
    MindfulMinuteInstance *mmi;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"MindfulMinuteInstance"];
    NSError *error = nil;
    mmis = [_coreDataHelper.context executeFetchRequest:request error:&error];
    
    int i = 1;
    for (mmi in mmis) {
        NSLog(@"MindfulMinuteInstance %d: %@", i, mmi.timeOfDay);
        i++;
    }
}

- (void)displayNotifications {
    //    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    int i = 1;
    
    for (UILocalNotification *notify in notifications) {
        NSLog(@"Notification %d: %@ '%@'", i, [_df stringFromDate:notify.fireDate], notify.alertBody);
        i++;
    }
}

- (void)clearData {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSArray *fetchedObjects;
    NSDate *today = [UsefulFunctions startOfDayWithDate:[NSDate date]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"MindfulMinuteInstance"];
    NSError *error = nil;
    fetchedObjects = [_coreDataHelper.context executeFetchRequest:request error:&error];
    for (MindfulMinuteInstance *mmi in fetchedObjects) {
        NSLog(@"Deleting MindfulMinuteInstance: %@", [_df stringFromDate:[today dateByAddingTimeInterval:[mmi.timeOfDay doubleValue]]]);
        [_coreDataHelper.context deleteObject:mmi];
    }
    
    error = nil;
    request = [[NSFetchRequest alloc] initWithEntityName:@"MindfulMinuteTemplate"];
    fetchedObjects = [_coreDataHelper.context executeFetchRequest:request error:&error];
    for (MindfulMinuteTemplate *mmt in fetchedObjects) {
        NSLog(@"Deleting MindfulMinuteTemplate: %@, %@", mmt.alertBody, mmt.soundName);
        [_coreDataHelper.context deleteObject:mmt];
    }
    
    [_coreDataHelper saveContext];
}

#pragma mark - NOTIFICATIONS
- (void)updateNotifications {
    // TODO: cleanup code and debugging tools
    int i;
    
    // get MindfulMinuteInstances from "database"
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MindfulMinuteInstance"];
    NSError *error = nil;
    
    NSComparator mmiComparator = ^(id obj1, id obj2) {
        if ([[obj1 timeOfDay] compare:[obj2 timeOfDay]] > NSOrderedSame) {
            return NSOrderedDescending;
        }
        if ([[obj1 timeOfDay] compare:[obj2 timeOfDay]] < NSOrderedSame) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    };
    NSArray *mmis = [[_coreDataHelper.context executeFetchRequest:request error:&error] sortedArrayUsingComparator:mmiComparator];
    
    NSComparator notificationComparator = ^(id obj1, id obj2) {
        if ([[obj1 fireDate] compare:[obj2 fireDate]] > NSOrderedSame)
            return NSOrderedDescending;
        if ([[obj1 fireDate] compare:[obj2 fireDate]] < NSOrderedSame)
            return NSOrderedAscending;
        
        return NSOrderedSame;
    };
    
    //get notifications from application
    NSArray *notifications = [[[UIApplication sharedApplication] scheduledLocalNotifications] sortedArrayUsingComparator:notificationComparator];
    
    // MARK: update to skip notification update when allowableNotificationCount==0
    int remainingAllowableNotificationsCount = (kMaxNotificationsAllowed + notifications.count) / mmis.count;
    int totalAllowableNotificationsCount = kMaxNotificationsAllowed / mmis.count;
    if (debug == 1) {NSLog(@"total notifications allowed for each scheduled time: %d\n", remainingAllowableNotificationsCount);}
    
    if (remainingAllowableNotificationsCount == 0) {
        return;
    }
    
    // set up a dictionary with each MindfulMinuteInstance as the key
    NSMutableArray *mmArray = [NSMutableArray new];
    NSMutableArray *mmSubArray;
    for (int i = 0; i < mmis.count; i++) {
        mmSubArray = [NSMutableArray new];
        [mmSubArray addObject:[mmis objectAtIndex:i]];
        [mmSubArray addObject:[NSMutableArray new]];
        [mmArray addObject:mmSubArray];
        if (debug==1) {
            NSLog(@"MindfulMinute Instance %d: %@", i, [_df stringFromDate:[[UsefulFunctions startOfDayWithDate:[NSDate date]] dateByAddingTimeInterval:[[[mmis objectAtIndex:i] timeOfDay] doubleValue]]]);
        }
        
    }
    
    if (debug==1) {NSLog(@"notifications count: %d", notifications.count);}
    
    // assign notifications to arrays in mmArray
    // MARK: cancel notifications without corresponding MindfulMinuteInstances
    for (UILocalNotification *notification in notifications) {
        BOOL notificationHasCorrespondingMindfulMinuteInstance = NO;
        for (mmSubArray in mmArray) {
            NSMutableArray *notificationArray = [mmSubArray objectAtIndex:1];
            NSTimeInterval mmiTimeOfDay = [[[mmSubArray objectAtIndex:0] timeOfDay] doubleValue];
            NSTimeInterval notificationFireDateTI = [UsefulFunctions timeIntervalFromHoursAndMinutesOfDate:notification.fireDate];
            if (notificationFireDateTI == mmiTimeOfDay) {
                if (debug==1) {NSLog(@"mmiTimeOfDay: %f; notificationFireDateTI: %f", mmiTimeOfDay, notificationFireDateTI);}
                [notificationArray addObject:notification];
                notificationHasCorrespondingMindfulMinuteInstance = YES;
                break;
            }
            // MARK: cancel notification without instance backing it up
//            if (![notificationArray containsObject:notification]) {
//                [[UIApplication sharedApplication] cancelLocalNotification:notification];
//            }
        }
        
        if (!notificationHasCorrespondingMindfulMinuteInstance) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    
    if (debug==1) {
        for (mmSubArray in mmArray) {
            NSLog(@"objects in subarray: %d", [[mmSubArray objectAtIndex:1] count]);
        }
    }
    
    if (debug == 1) {
        i = 1;
        for (mmSubArray in mmArray) {
            int j = 1;
            for (UILocalNotification *theNotification in [mmSubArray objectAtIndex:1]) {
                NSLog(@"set %d - notification %d: %@", i, j, [_df stringFromDate:theNotification.fireDate]);
                j++;
            }
            i++;
        }
    }
    
    if (debug==1) { NSLog(@"mmArray count: %d", mmArray.count); }
    if (debug==1) {
        i = 0;
        for (mmSubArray in mmArray) {
            for (id object in mmSubArray) {
                NSLog(@"%@", [object class]);
            }
            i++;
        }
    }
    
    // load MindfulMinuteTemplates from "database"
    request = [NSFetchRequest fetchRequestWithEntityName:@"MindfulMinuteTemplate"];
    error = nil;
    NSArray *mmts = [_coreDataHelper.context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Error: %@ '%@'", error, [error localizedDescription]);
    }
    
    // build and schedule notifications
    // MARK: exclude Saturday & Sunday notification scheduling
    for (mmSubArray in mmArray) {
        for (int i = ([[mmSubArray objectAtIndex:1] count]); i < totalAllowableNotificationsCount; i++) {
            NSDate *date;
            if (i == 0) {
                date = [UsefulFunctions nextWeekdayWithTimeOfDayFromTimeInterval:[[[mmSubArray objectAtIndex:0] timeOfDay] doubleValue]];
            } else {
                date = [UsefulFunctions dateByAddingDays:1 toDate:[UsefulFunctions nextWeekdayAfterDate:[mmSubArray[1][(i-1)] fireDate]]];
            }
//            NSLog(@"mmSubArray.count index 1: %d - supposed notificationArray index: %d", [mmSubArray[1] count], i-1);
            
            MindfulMinuteTemplate *mmt = [UsefulFunctions randomObjectFromArray:mmts];
            
            UILocalNotification *theNotification = [UILocalNotification new];
            theNotification.fireDate = date;
            theNotification.alertBody = mmt.alertBody;
            theNotification.soundName = mmt.soundName;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:theNotification];
            [[mmSubArray objectAtIndex:1] addObject:theNotification];
            if (debug==1) {
//                NSLog(@"%d '%@': %@", i, theNotification.alertBody, theNotification.soundName);
                NSLog(@"notification scheduled: %@ '%@'", [_df stringFromDate:theNotification.fireDate], theNotification.alertBody);
            }
        }
    }
}

#pragma mark - USER
- (User*) currentUser {
    User *currentUser;
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentUserKey];
    if (username == nil) {
        currentUser = nil;
    } else {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"username = %@", username];
        request.predicate = filter;
        NSError *error = nil;
        @try {
            currentUser = [[_coreDataHelper.context executeFetchRequest:request error:&error] objectAtIndex:0];
            if (error) {NSLog(@"Error: %@ '%@'", error, [error localizedDescription]);}
        } @catch (NSException *e) {
            currentUser = nil;
        }
    }
    
    return currentUser;
}

@end
