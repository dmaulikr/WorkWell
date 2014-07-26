//
//  MindfulMinutesTVC.m
//  WorkWell
//
//  Created by Aaron Wells on 7/18/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import "MindfulMinutesTVC.h"
#import "CoreDataHelper.h"
#import "MindfulMinuteInstance.h"
#import "AppDelegate.h"
#import "UsefulFunctions.h"
#import "MindfulMinuteVC.h"
@import AVFoundation;

@interface MindfulMinutesTVC()
@property (strong, nonatomic) AVAudioPlayer *player;

- (IBAction)remove:(id)sender;
@end

@implementation MindfulMinutesTVC
#define debug 0

#pragma mark - DATA
- (void)configureFetch {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MindfulMinuteInstance"];
    
    request.sortDescriptors =
    [NSArray arrayWithObjects:
     [NSSortDescriptor sortDescriptorWithKey:@"timeOfDay"
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
    self.clearConfirmActionSheet.delegate = self;
    
//    CoreDataHelper *cdh = [(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AudioFile"];
//    AudioFile *audioFile = [[cdh.context executeFetchRequest:request error:nil] objectAtIndex:0];
//    self.player = [[AVAudioPlayer alloc] initWithData:audioFile.data fileTypeHint:@"mp3" error:nil];
//    NSLog(@"playing: %@", [self.player play]?@"YES":@"NO");
    
    // Respond to changes in underlying store
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performFetch)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    static NSString *cellIdentifier = @"Mindful Minute Cell";
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                    forIndexPath:indexPath];
    
    MindfulMinuteInstance *mindfulMinute = [self.frc objectAtIndexPath:indexPath];
    
    NSDate *date = [UsefulFunctions startOfDayWithDate:[NSDate date]];
    date = [date dateByAddingTimeInterval:[mindfulMinute.timeOfDay doubleValue]];
    NSDateFormatter *df = [NSDateFormatter new];
    df.timeStyle = NSDateFormatterShortStyle;
    cell.textLabel.text = [df stringFromDate:date];
    
    // make selected items red; either update data model and reimplement this code or delete this section
//    if (item.listed.boolValue) {
//        cell.textLabel.textColor =
//        [UIColor colorWithRed:0.8 green:0.4 blue:0.4 alpha:1.0];
//    }
//    else {
//        cell.textLabel.textColor = [UIColor blackColor];
//    }
    
    return cell;
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    return nil; // we don't want a section index.
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Time of Day";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MindfulMinuteInstance *deleteTarget = [self.frc objectAtIndexPath:indexPath];
        [self.frc.managedObjectContext deleteObject:deleteTarget];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    // Implement if you add a boolean later which would indicate a mindful minute notification instance is turned on
    
//    NSManagedObjectID *itemid = [[self.frc objectAtIndexPath:indexPath] objectID];
//    Item *item = (Item*)[self.frc.managedObjectContext existingObjectWithID:itemid error:nil];
//    if (item.listed.boolValue) {
//        item.listed = [NSNumber numberWithBool:NO];
//    }
//    else {
//        item.listed = [NSNumber numberWithBool:YES];
//        item.collected = [NSNumber numberWithBool:NO];
//    }
}

- (IBAction)remove:(id)sender {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    CoreDataHelper *cdh = [(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MindfulMinuteInstance"];
    NSArray *notifications = [cdh.context executeFetchRequest:request error:nil];
    
    if (notifications.count > 0) {
        self.clearConfirmActionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete all notifications (swipe to single-delete)?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
        [self.clearConfirmActionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nothing to Delete" message:@"Add mindfulness notifications by pressing the '+' icon on the 'Mindful Minutes' tab. Remove all notifications by clicking the trash can icon on the 'Mindful Minutes' tab." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    
    notifications = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet == self.clearConfirmActionSheet) {
        if (buttonIndex == [actionSheet destructiveButtonIndex]) {
            [self performSelector:@selector(removeAll)];
        }
    }
}

- (void) removeAll {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    CoreDataHelper *cdh = [(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    NSArray *notifications = [cdh.context executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"MindfulMinuteInstance"] error:nil];
    for (MindfulMinuteInstance *notification in notifications) {
        [cdh.context deleteObject:notification];
    }
    
    [self.tableView reloadData];
}

#pragma mark - SEGUE

// passes a new Mindful Minute Instance to View for editing
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    MindfulMinuteVC *mmVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"Add MindfulMinute Segue"]) {
        CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        MindfulMinuteInstance *mmInstance =
        [NSEntityDescription insertNewObjectForEntityForName:@"MindfulMinuteInstance"
                                      inManagedObjectContext:cdh.context];
        mmVC.selectedMindfulMinuteInstanceID = mmInstance.objectID;
    }
    else {
        NSLog(@"Unidentified Segue Attempted!");
    }
}

// passes selected Mindful Minute Instance to View for editing
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    MindfulMinuteVC *mindfulMinuteVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MindfulMinuteVC"];
    mindfulMinuteVC.selectedMindfulMinuteInstanceID = [[self.frc objectAtIndexPath:indexPath] objectID];
    [self.navigationController pushViewController:mindfulMinuteVC animated:YES];
}
@end