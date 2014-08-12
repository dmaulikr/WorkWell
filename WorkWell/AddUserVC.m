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
@property (strong, nonatomic) Reachability *reachability;
@property (strong, nonatomic) NSMutableData *connectionData;

- (IBAction)doneEditingUser:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
@end

@implementation AddUserVC
#define debug 1
#define kAddUserURLPath @"http://localhost/workwell_nw/controllers/add_user.php"

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
    _reachability = [Reachability reachabilityWithHostName:kReachabilityHostName];
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
    @try {
        [self validatePassword];
        NSError *error = nil;
        User *user = (User*)[cdh.context existingObjectWithID:self.selectedUserID error:&error];
        user.username = self.usernameTextField.text;
        user.password = self.passwordTextField.text;
        
        [cdh saveContext];
    
        if ([_reachability isReachable]) {
            [self addUserToServer:user];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Connect" message:@"Could not connect to server. User not added" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    } @catch (NSException *e) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:e.name message:e.reason delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    
    [(UINavigationController*)self.parentViewController popViewControllerAnimated:YES];
}

- (void)validatePassword {
    if (! [self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        @throw [NSException exceptionWithName:@"Unmatched passwords" reason:@"Passwords do not match. Please confirm your password." userInfo:nil];
    }
    if ([self.passwordTextField.text length] < 1) {
        @throw [NSException exceptionWithName:@"No Password Provided" reason:@"You must enter a password to add a user." userInfo:nil];
    }
}

- (void)addUserToServer:(User*)user {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    NSString *userXML = [XMLUtility xmlFromUser:user];
    
        NSString *path = kAddUserURLPath;
        NSURL *url = [NSURL URLWithString:path];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        
        [request setValue:[NSString stringWithFormat:@"%d", [userXML length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:[userXML dataUsingEncoding:NSUTF8StringEncoding]];
        
        self.connectionData = [[NSMutableData alloc] initWithCapacity:0];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (!connection) self.connectionData = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.connectionData increaseLengthBy:[data length]];
    [self.connectionData appendData:data];
    if (debug==1) {NSLog(@"%@ '%@': data received", self.class, NSStringFromSelector(_cmd));}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        NSLog(@"%@", [[NSString alloc] initWithData:self.connectionData encoding:NSUTF8StringEncoding]);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error: %@ '%@'", error, error.localizedDescription);
}

- (IBAction)hideKeyboard:(id)sender {
    NSArray *keyboards = @[self.usernameTextField, self.passwordTextField, self.confirmPasswordTextField];
    for (int i = 0; i < keyboards.count; i++) {
        [[keyboards objectAtIndex:i] resignFirstResponder];
    }
}
@end
