//
//  AudioFile.h
//  WorkWell
//
//  Created by Aaron Wells on 7/19/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GuidedMeditation, MindfulMinuteTemplate;

@interface AudioFile : NSManagedObject

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *guidedMeditations;
@property (nonatomic, retain) NSSet *mindfulMinuteTemplates;
@end

@interface AudioFile (CoreDataGeneratedAccessors)

- (void)addGuidedMeditationsObject:(GuidedMeditation *)value;
- (void)removeGuidedMeditationsObject:(GuidedMeditation *)value;
- (void)addGuidedMeditations:(NSSet *)values;
- (void)removeGuidedMeditations:(NSSet *)values;

- (void)addMindfulMinuteTemplatesObject:(MindfulMinuteTemplate *)value;
- (void)removeMindfulMinuteTemplatesObject:(MindfulMinuteTemplate *)value;
- (void)addMindfulMinuteTemplates:(NSSet *)values;
- (void)removeMindfulMinuteTemplates:(NSSet *)values;

@end
