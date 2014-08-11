//
//  GuidedMeditation.h
//  WorkWell
//
//  Created by Aaron Wells on 8/2/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AudioFile;

@interface GuidedMeditation : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) AudioFile *audioFile;

@end
