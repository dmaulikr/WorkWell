//
//  AppDelegate.h
//  WorkWell
//
//  Created by Aaron Wells on 7/17/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
#import "User.h"
#import "PracticeSession.h"
#import "MindfulMinuteTemplate.h"
#import "MindfulMinuteInstance.h"
#import "UsefulFunctions.h"
#import "AudioFile.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) CoreDataHelper *coreDataHelper;

- (CoreDataHelper*)cdh;
- (void)scheduleMindfulMinuteNotifications;
@end