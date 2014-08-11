//
//  AddUserVC.m
//  WorkWell
//
//  Created by Aaron Wells on 7/31/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import "AddUserVC.h"

@interface AddUserVC ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

- (IBAction)doneEditingUser:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
@end

@implementation AddUserVC

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
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - INTERACTION
- (IBAction)doneEditingUser:(id)sender {
    CoreDataHelper *cdh = [(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    NSError *error = nil;
    User *user = (User*)[cdh.context existingObjectWithID:self.selectedUserID error:&error];
    user.username = self.usernameTextField.text;
    [cdh saveContext];
    [(UINavigationController*)self.parentViewController popViewControllerAnimated:YES];
}

- (IBAction)hideKeyboard:(id)sender {
    NSArray *keyboards = @[self.usernameTextField, self.passwordTextField, self.confirmPasswordTextField];
    for (int i = 0; i < keyboards.count; i++) {
        [[keyboards objectAtIndex:i] resignFirstResponder];
    }
}
@end
