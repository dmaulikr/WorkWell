//
//  GuidedMeditationsTVC.m
//  WorkWell
//
//  Created by Aaron Wells on 7/28/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import "GuidedMeditationsTVC.h"
#import "GuidedMeditation.h"
#import "GuidedMeditationVC.h"
#import "CoreDataHelper.h"
#import "AudioFile.h"
#import "AppDelegate.h"

@interface GuidedMeditationsTVC ()

@end

@implementation GuidedMeditationsTVC
#define debug 1

#pragma mark - DATA

- (void)configureFetch {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    
    NSFetchRequest *request =
    [NSFetchRequest fetchRequestWithEntityName:@"GuidedMeditation"];
    
    request.sortDescriptors =
    [NSArray arrayWithObjects:
     [NSSortDescriptor sortDescriptorWithKey:@"title"
                                   ascending:YES],
     nil];
    
    [request setFetchBatchSize:50];
    self.frc =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                        managedObjectContext:cdh.context
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    
    self.frc.delegate = self;
}

#pragma mark - VIEW

- (void)viewDidLoad {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    
    // Respond to changes in underlying store
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performFetch)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    static NSString *cellIdentifier = @"Guided Meditation Cell";
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                    forIndexPath:indexPath];
    GuidedMeditation *guidedMeditation = [self.frc objectAtIndexPath:indexPath];
    NSMutableString *title = [NSMutableString stringWithString:guidedMeditation.title];
    [title replaceOccurrencesOfString:@"(null)"
                           withString:@""
                              options:0
                                range:NSMakeRange(0, [title length])];
    cell.textLabel.text = title;
    
    // make selected items red
//      TODO: save if useful later
//    if (item.listed.boolValue) {
//        cell.textLabel.textColor = [UIColor colorWithRed:0.8 green:0.4 blue:0.4 alpha:1.0];
//    } else {
//        cell.textLabel.textColor = [UIColor blackColor];
//    }
    
    return cell;
    
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    return nil; // we don't want a section index.
}

#pragma mark - DATASOURCE

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Meditation Title";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - INTERACTION

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    GuidedMeditationVC *gmVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GuidedMeditationVC"];
    gmVC.selectedMeditationID = [[self.frc objectAtIndexPath:indexPath] objectID];
    [self.navigationController pushViewController:gmVC animated:YES];
}

@end
