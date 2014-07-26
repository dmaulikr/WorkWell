//
//  User.h
//  WorkWell
//
//  Created by Aaron Wells on 7/25/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course, Location, PracticeSession;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) Course *course;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) NSSet *practiceSessions;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addPracticeSessionsObject:(PracticeSession *)value;
- (void)removePracticeSessionsObject:(PracticeSession *)value;
- (void)addPracticeSessions:(NSSet *)values;
- (void)removePracticeSessions:(NSSet *)values;

@end
