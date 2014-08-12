//
//  AddUserVC.h
//  WorkWell
//
//  Created by Aaron Wells on 7/31/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoVC.h"
#import "Reachability.h"
#import "XMLUtility.h"

@interface AddUserVC : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (strong, nonatomic)NSManagedObjectID *selectedUserID;

@end
