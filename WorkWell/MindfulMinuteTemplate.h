//
//  MindfulMinuteTemplate.h
//  WorkWell
//
//  Created by Aaron Wells on 7/19/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AudioFile;

@interface MindfulMinuteTemplate : NSManagedObject

@property (nonatomic, retain) NSString * alertBody;
@property (nonatomic, retain) AudioFile *audioFile;

@end
