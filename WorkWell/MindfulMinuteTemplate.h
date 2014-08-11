//
//  MindfulMinuteTemplate.h
//  WorkWell
//
//  Created by Aaron Wells on 8/2/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MindfulMinuteTemplate : NSManagedObject

@property (nonatomic, retain) NSString * alertBody;
@property (nonatomic, retain) NSString * soundName;

@end
