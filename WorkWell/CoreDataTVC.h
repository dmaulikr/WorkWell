//
//  CoreDataTVC.h
//  WorkWell
//
//  Created by Aaron Wells on 7/18/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;

@interface CoreDataTVC : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *frc;

- (void) performFetch;
@end
