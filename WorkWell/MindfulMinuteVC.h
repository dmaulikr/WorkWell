//
//  MindfulMinuteVC.h
//  WorkWell
//
//  Created by Aaron Wells on 7/18/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MindfulMinuteInstance, MindfulMinuteTemplate, CoreDateHelper;
@import CoreData;

@interface MindfulMinuteVC : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectID *selectedMindfulMinuteInstanceID;

@end
