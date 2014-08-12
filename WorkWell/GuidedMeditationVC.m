//
//  GuidedMeditationVC.m
//  WorkWell
//
//  Created by Aaron Wells on 7/29/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import "GuidedMeditationVC.h"
@import AVFoundation;

@interface GuidedMeditationVC ()
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSMutableData *connectionData;
@property (strong, nonatomic) Reachability *reachability;
@property (strong, nonatomic) NSDate *timeStarted;

@end

@implementation GuidedMeditationVC
#define kAddPracticeSessionPath @"http://localhost/workwell_nw/controllers/add_practice_session.php"
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
    self.timeStarted = [NSDate date];
    _reachability = [Reachability reachabilityWithHostName:kReachabilityHostName];
    CoreDataHelper *cdh = [(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    GuidedMeditation *guidedMeditation = (GuidedMeditation*)[cdh.context existingObjectWithID:self.selectedMeditationID error:nil];
    NSData *audioData = guidedMeditation.audioFile.data;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData fileTypeHint:@"mp3" error:nil];
    [self.audioPlayer play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    CoreDataHelper *cdh = [(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    NSDate *now = [NSDate date];
    NSTimeInterval duration = [now timeIntervalSinceDate:self.timeStarted];
    PracticeSession *practiceSession = [NSEntityDescription insertNewObjectForEntityForName:@"PracticeSession" inManagedObjectContext:cdh.context];
    practiceSession.date = now;
    practiceSession.duration = [NSNumber numberWithDouble:duration];
    practiceSession.guided = [NSNumber numberWithBool:YES];
    practiceSession.user = (User*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] currentUser];
    [cdh saveContext];
    
    [self sendPracticeSessionToServer:practiceSession];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CONNECTION
- (void)sendPracticeSessionToServer:(PracticeSession*)practiceSession {
    NSString *xml = [XMLUtility xmlFromPracticeSession:practiceSession];
    
    if ([_reachability isReachable]) {
        NSString *path = kAddPracticeSessionPath;
        NSURL *url = [NSURL URLWithString:path];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        
        [request setValue:[NSString stringWithFormat:@"%d", [xml length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
        
        self.connectionData = [[NSMutableData alloc] initWithCapacity:0];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (!connection) self.connectionData = nil;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Dice" message:@"Could not reach server. Session not saved" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (debug==1) NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    [self.connectionData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        
        NSString *string = [[NSString alloc] initWithData:self.connectionData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", string);
    }
}

@end
