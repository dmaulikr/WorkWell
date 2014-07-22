//
//  MindfulMinuteVC.m
//  WorkWell
//
//  Created by Aaron Wells on 7/18/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import "MindfulMinuteVC.h"
#import "AppDelegate.h"
#import "CoreDataHelper.h"

@interface MindfulMinuteVC ()
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;

- (IBAction)done:(id)sender;
- (IBAction)updateMindfulMinuteInstance:(id)sender;
@end

@implementation MindfulMinuteVC
#define debug 1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateTimePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - INTERACTION
- (IBAction)done:(id)sender {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    [self.navigationController popViewControllerAnimated:YES];
}

//  gets time of day from timePicker and adds to current MindfulMinuteInstance
- (IBAction)updateMindfulMinuteInstance:(id)sender {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    CoreDataHelper *cdh = [(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    
    NSError *error = nil;
    MindfulMinuteInstance *mmI = (MindfulMinuteInstance*)[cdh.context existingObjectWithID:self.selectedMindfulMinuteInstanceID error:&error];
    if (error) {NSLog(@"Error: %@ '%@'", error, [error localizedDescription]);}
    
    NSTimeInterval interval = [UsefulFunctions timeIntervalFromHoursAndMinutesOfDate:self.timePicker.date];
    
    mmI.timeOfDay = [NSNumber numberWithDouble:interval];
}

#pragma mark - VIEW
- (void)updateTimePicker {
    // TODO: if new object, set picker to current time
    NSDate *theDate = [UsefulFunctions startOfDayWithDate:[NSDate date]];
    CoreDataHelper *cdh = [(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    MindfulMinuteInstance *mmI = (MindfulMinuteInstance*)[cdh.context existingObjectWithID:self.selectedMindfulMinuteInstanceID error:nil];
    NSTimeInterval instanceTime = [mmI.timeOfDay doubleValue];
    theDate = [theDate dateByAddingTimeInterval:instanceTime];
    self.timePicker.date = theDate;
}

#pragma mark - BUSINESS
// calls to business logic occur here
// TODO - add functions to AppDelegate to schedule notifications based on MindfulMinuteInstances

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
