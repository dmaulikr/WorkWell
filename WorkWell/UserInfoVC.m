//
//  UserInfoVC.m
//  WorkWell
//
//  Created by Aaron Wells on 7/30/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import "UserInfoVC.h"
#import "AddUserVC.h"

@interface UserInfoVC ()
@property (weak, nonatomic) IBOutlet PickerTF_User *userPickerTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet PickerTF_Location *locationTextField;
@property (weak, nonatomic) IBOutlet PickerTF_Course *courseTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBarButton;

- (IBAction)hideKeyboard:(id)sender;
@end

@implementation UserInfoVC
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
    self.userPickerTextField.delegate = self;
    self.userPickerTextField.pickerDelegate = self;
    self.locationTextField.delegate = self;
    self.locationTextField.pickerDelegate = self;
    self.courseTextField.delegate = self;
    self.courseTextField.pickerDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInterface) name:NSManagedObjectContextDidSaveNotification object:nil];
    [self refreshInterface];
}

- (void)viewDidDisappear:(BOOL)animated {
    if (debug==1){NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PICKERS
- (void)selectedObjectID:(NSManagedObjectID *)objectID changedForPickerTF:(CoreDataPickerTF *)pickerTF {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSError *error;
    
    if (pickerTF == self.userPickerTextField) {
        User *user = (User*)[cdh.context existingObjectWithID:objectID error:&error];
        if (error) {NSLog(@"Error selecting object on picker: %@, %@", error, error.localizedDescription);}
        self.selectedUserID = user.objectID;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:user.username forKey:CurrentUserKey];
    } else if (pickerTF == self.locationTextField) {
        Location *location = (Location*)[cdh.context existingObjectWithID:objectID error:&error];
        if (error) {NSLog(@"Error selecting object on picker: %@, %@", error, error.localizedDescription);}
        User *user = (User*)[cdh.context existingObjectWithID:self.selectedUserID error:&error];
        if (error) {NSLog(@"Error getting object from view: %@, %@", error, error.localizedDescription);}
        user.location = location;
    } else if (pickerTF == self.courseTextField) {
        Course *course = (Course*)[cdh.context existingObjectWithID:objectID error:&error];
        if (error) {NSLog(@"Error selecting object on picker: %@, %@", error, error.localizedDescription);}
        User *user = (User*)[cdh.context existingObjectWithID:self.selectedUserID error:&error];
        if (error) {NSLog(@"Error getting object from view: %@, %@", error, error.localizedDescription);}
        user.course = course;
    } else {
        NSLog(@"The selected object on the picker for an unhandled text-field changed");
    }
        
    [self refreshInterface];
}

- (void)selectedObjectClearedForPickerTF:(CoreDataPickerTF *)pickerTF {
//    if (self.selectedUserID) {
//        CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
//        User *user = (User*)[cdh.context existingObjectWithID:self.selectedUserID error:nil];
//        
//        if (pickerTF == self.userPickerTextField) {
//            user = nil;
//            self.userPickerTextField.text = @"";
//        }
//        [self refreshInterface];
//    }
}

#pragma mark - INTERFACE
- (void) refreshInterface {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    User *user;
    
    if (debug==1) NSLog(@"User ID: %@", self.selectedUserID);
    if (self.selectedUserID) {
        user = (User*)[cdh.context existingObjectWithID:self.selectedUserID error:nil];
        [self updateTextFieldsWithUser:user];
    } else {
        @try {
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
            [request setFetchLimit:1];
            user = [[cdh.context executeFetchRequest:request error:nil] objectAtIndex:0];
            [self updateTextFieldsWithUser:user];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:user.username forKey:CurrentUserKey];
            [userDefaults synchronize];
        }
        @catch (NSException *exception) {
            self.userPickerTextField.text = @"No users added yet";
        }
    }
}

- (void)updateTextFieldsWithUser:(User*)user {
    self.userPickerTextField.selectedObjectID = user.objectID;
    self.userPickerTextField.text = user.username;
    self.firstNameTextField.text = user.firstName;
    self.lastNameTextField.text = user.lastName;
    self.locationTextField.text = user.location.name;
    self.courseTextField.text = user.course.name;
}

#pragma mark - DATA
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"UserInfoAddUser"]) {
        AddUserVC *addUserVC = (AddUserVC*)segue.destinationViewController;
        CoreDataHelper *cdh = [(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
        addUserVC.selectedUserID = [[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:cdh.context] objectID];
    } else {
        NSLog(@"Unidentified segue attempted!");
    }
}

- (IBAction)hideKeyboard:(id)sender {
    NSArray *keyboards = @[self.userPickerTextField, self.firstNameTextField, self.lastNameTextField, self.locationTextField, self.courseTextField];
    for (int i = 0; i < keyboards.count; i++) {
        [[keyboards objectAtIndex:i] resignFirstResponder];
    }
}
@end