//
//  AudioFile.h
//  WorkWell
//
//  Created by Aaron Wells on 7/25/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GuidedMeditation;

@interface AudioFile : NSManagedObject

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *guidedMeditations;
@end

@interface AudioFile (CoreDataGeneratedAccessors)

- (void)addGuidedMeditationsObject:(GuidedMeditation *)value;
- (void)removeGuidedMeditationsObject:(GuidedMeditation *)value;
- (void)addGuidedMeditations:(NSSet *)values;
- (void)removeGuidedMeditations:(NSSet *)values;

@end
