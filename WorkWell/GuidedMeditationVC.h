//
//  GuidedMeditationVC.h
//  WorkWell
//
//  Created by Aaron Wells on 7/29/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Reachability.h"
#import "PracticeSession.h"
#import "User.h"
#import "XMLUtility.h"

@interface GuidedMeditationVC : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSManagedObjectID *selectedMeditationID;

@end
