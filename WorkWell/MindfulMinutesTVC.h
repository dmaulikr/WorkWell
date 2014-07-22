//
//  MindfulMinutesTVC.h
//  WorkWell
//
//  Created by Aaron Wells on 7/18/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import "CoreDataTVC.h"
@class CoreDataHelper, MindfulMinuteInstance, AppDelegate, UsefulFunctions, MindfulMinuteVC;

@interface MindfulMinutesTVC : CoreDataTVC <UIActionSheetDelegate>

@property (strong, nonatomic) UIActionSheet *clearConfirmActionSheet;

@end