//
//  StatsTVC.m
//  WorkWell
//
//  Created by Aaron Wells on 7/30/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import "StatsTVC.h"
#import "UserInfoVC.h"

@interface StatsTVC ()
@property (strong, nonatomic)NSManagedObjectID *selectedUserID;

@end

@implementation StatsTVC
#define debug 1

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"User Stats";
    } else {
        return @"Current User";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    User *currentUser = [(AppDelegate*)[[UIApplication sharedApplication] delegate] currentUser];
    self.selectedUserID = currentUser.objectID;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"User Stats Cell" forIndexPath:indexPath];
        // MARK: TOTAL SESSIONS CELL
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Total Sessions to Date";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", currentUser.practiceSessions.count];
        // MARK: TIME PRACTICED CELL
        } else if (indexPath.row == 1) {
            NSDictionary *userHMS = [self totalTimePracticedForUser:currentUser];
            cell.textLabel.text = @"Total Time Practiced";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", [[userHMS objectForKey:@"hours"] integerValue], [[userHMS objectForKey:@"minutes"] integerValue], [[userHMS objectForKey:@"seconds"] integerValue]];
        // MARK: SESSIONS PER WEEK CELL
        } else {
            NSInteger weeks = [self weeksSinceFirstPracticeSessionForUser:currentUser];
            weeks += 1;
            cell.textLabel.text = @"Sessions Per Week";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", (currentUser.practiceSessions.count / weeks) ];
        }
    // MARK: CURRENT USER CELL
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Current User Cell" forIndexPath:indexPath];
        cell.textLabel.text = currentUser.username;
    }
    return cell;
}

- (NSDictionary*)totalTimePracticedForUser:(User*)user {
    NSTimeInterval timePracticed = 0;
    for (PracticeSession *ps in user.practiceSessions) {
        timePracticed += [ps.duration doubleValue];
    }
    NSDictionary *result = [UsefulFunctions hoursMinutesSeconds:timePracticed];
    return result;
}

- (NSInteger)weeksSinceFirstPracticeSessionForUser:(User*)user {
    @try {
        NSSortDescriptor *dateAscending = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
        NSArray *dateFirstPracticeSessions = [user.practiceSessions sortedArrayUsingDescriptors:[NSArray arrayWithObjects:dateAscending, nil]];
        NSDate *firstSessionDate = [[dateFirstPracticeSessions objectAtIndex:0] date];
        NSDateComponents *week = [[NSCalendar currentCalendar] components:NSWeekCalendarUnit fromDate:firstSessionDate toDate:[NSDate date] options:0];
        return week.week;
    } @catch (NSException *e) {
        if (debug==1) {NSLog(@"Exception: %@ '%@'", e.name, e.reason);}
        return 1;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UserInfoVC *userInfoVC = (UserInfoVC*)segue.destinationViewController;
    userInfoVC.selectedUserID = self.selectedUserID;
}

@end
