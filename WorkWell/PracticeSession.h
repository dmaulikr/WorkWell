//
//  PracticeSession.h
//  WorkWell
//
//  Created by Aaron Wells on 7/25/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface PracticeSession : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * guided;
@property (nonatomic, retain) User *user;

@end
