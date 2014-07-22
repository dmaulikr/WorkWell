//
//  AppDelegate.m
//  WorkWell
//
//  Created by Aaron Wells on 7/17/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
#define debug 1

- (void)demo {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
//    MindfulMinuteInstance *mindfulMinute;
//    NSTimeInterval timeOfDay = [UsefulFunctions timeIntervalWithHours:7 minutes:25 seconds:0];
//    for (int i=0; i<10; ++i) {
//        mindfulMinute = [NSEntityDescription insertNewObjectForEntityForName:@"MindfulMinuteInstance" inManagedObjectContext:_coreDataHelper.context];
//        mindfulMinute.timeOfDay = [NSNumber numberWithDouble:timeOfDay];
//    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MindfulMinuteInstance"];
    NSArray *instances = [_coreDataHelper.context executeFetchRequest:request error:nil];
    
    for (MindfulMinuteInstance *instance in instances) {
        [_coreDataHelper.context deleteObject:instance];
    }
//    NSArray *templates = @[@"Stop. Pay attention.", @"Relax. Breathe deeply.", @"Take a moment to appreciate your surroundings.", @"Close your eyes for a moment."];
//    
//    for (NSString *alertBody in templates) {
//        MindfulMinuteTemplate *template = [NSEntityDescription insertNewObjectForEntityForName:@"MindfulMinuteTemplate" inManagedObjectContext:_coreDataHelper.context];
//        template.alertBody = alertBody;
//    }
    
//    AudioFile *audio = [NSEntityDescription insertNewObjectForEntityForName:@"AudioFile" inManagedObjectContext:_coreDataHelper.context];
//    
//    NSString *audioFile = [[NSBundle mainBundle] pathForResource:@"tibetan_bell" ofType:@"mp3"];
//    NSURL *audioURL = [NSURL fileURLWithPath:audioFile];
//    audio.data = [NSData dataWithContentsOfURL:audioURL];
//    
//    [_coreDataHelper saveContext];
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
    
    [self cdh];
    [self demo];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)scheduleMindfulMinuteNotifications {
    // 
}

@end
