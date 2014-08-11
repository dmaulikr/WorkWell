//
//  UserInfoVC.h
//  WorkWell
//
//  Created by Aaron Wells on 7/30/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerTF_User.h"
#import "PickerTF_Location.h"
#import "PickerTF_Course.h"
#import "User.h"
#import "AppDelegate.h"
#import "Location.h"
#import "Course.h"
@class AddUserVC;

@interface UserInfoVC : UIViewController <UITextFieldDelegate, CoreDataPickerTFDelegate>
@property (strong, nonatomic)NSManagedObjectID *selectedUserID;

@end
