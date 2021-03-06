//
//  MeditationTimerVC.m
//  WorkWell
//
//  Created by Aaron Wells on 7/29/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import "MeditationTimerVC.h"

@interface MeditationTimerVC ()
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UITextField *minutesField;
@property (weak, nonatomic) IBOutlet UITextField *pacerField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) Reachability *reachability;
@property (strong, nonatomic) NSMutableData *connectionData;
@property (weak) NSTimer *countdownTimer;
@property (weak) NSTimer *pacerTimer;
@property NSTimeInterval timeLeft;
@property NSTimeInterval timeElapsed;
@property NSInteger alertsPlayed;
@property BOOL timerSessionIsInProgress;

- (IBAction)startTimer:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (void)updateTime:(NSTimer*)theTimer;
@end

@implementation MeditationTimerVC
#define debug 1
#define kSecondsPerMinute 60.0
#define kAlertSound @"ting"
#define kAddPracticeSessionPath @"http://localhost/workwell_nw/controllers/add_practice_session.php"

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timerSessionIsInProgress = NO;
    _reachability = [Reachability reachabilityWithHostName:kReachabilityHostName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TIMERS
- (IBAction)startTimer:(id)sender {
    if (self.timerSessionIsInProgress) {
        if ([self.countdownTimer isValid]) {
            [self.countdownTimer invalidate];
            [self.pacerTimer invalidate];
            [self recordSessionInContext];
        } else {
            NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
            self.countdownTimer = timer;
        }
    } else {
        NSTimer *timer;
    
        self.timeLeft = [self.minutesField.text doubleValue] * 60.0;
        self.timeElapsed = 0.0;
        [self updateCountdownLabel];
        timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
        self.countdownTimer = timer;
    
        [self startPacerTimer];
        self.timerSessionIsInProgress = YES;
    }
}

- (void)startPacerTimer {
    if (self.pacerTimer != nil)
        [self.pacerTimer invalidate];
    
    NSTimeInterval pacerInterval = [self.pacerField.text doubleValue] * kSecondsPerMinute;
    
    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:pacerInterval target:self selector:@selector(playAlertOrStopTimer:) userInfo:nil repeats:YES];
    
    self.pacerTimer = timer;
}

#pragma mark - VIEW
- (void)updateTime:(NSTimer*)theTimer {
    
    if (self.timeLeft >= 1.0) {
        --self.timeLeft;
        ++self.timeElapsed;
    } else {
        [theTimer invalidate];
        self.countdownLabel.text = @"00:00";
    }
    
    if ((NSInteger)self.timeLeft % 60 == 0) {
        if (![self.pacerTimer isValid]) {
            [self playAlertSound];
            [self startPacerTimer];
        }
    }
    
    [self updateCountdownLabel];
}

- (void)updateCountdownLabel {
    NSInteger hoursLeft, minutesLeft, secondsLeft;
    hoursLeft = [[[UsefulFunctions hoursMinutesSeconds:self.timeLeft] objectForKey:@"hours"] integerValue];
    minutesLeft = [[[UsefulFunctions hoursMinutesSeconds:self.timeLeft] objectForKey:@"minutes"] integerValue];
    secondsLeft = [[[UsefulFunctions hoursMinutesSeconds:self.timeLeft] objectForKey:@"seconds"] integerValue];
    
    if (hoursLeft > 0)
        self.countdownLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hoursLeft, minutesLeft, secondsLeft];
    else
        self.countdownLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutesLeft, secondsLeft];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.minutesField resignFirstResponder];
    [self.pacerField resignFirstResponder];
}

- (void)playAlertOrStopTimer:(NSTimer*)theTimer {
    [self playAlertSound];
    
    if (self.timeLeft < 1.0) {
        [self recordSessionInContext];
        [theTimer invalidate];
        [self playAlertSound];
        self.alertsPlayed = 1;
        self.pacerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playAlert:) userInfo:nil repeats:YES];
    }
}

#pragma mark - EVENTS
- (void)playAlert:(NSTimer*)theTimer {
    if (self.alertsPlayed > 2) {
        [theTimer invalidate];
        self.alertsPlayed = 0;
        return;
    }
    
    [self playAlertSound];
    
    self.alertsPlayed++;
}

- (void)playAlertSound {
    SystemSoundID soundID;
    NSString *soundFile=[[NSBundle mainBundle] pathForResource:kAlertSound ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundFile], &soundID);
    AudioServicesPlaySystemSound(soundID);
}

#pragma mark - USER DATA
- (void)recordSessionInContext {
    CoreDataHelper *cdh = [(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    PracticeSession *practiceSession = [NSEntityDescription insertNewObjectForEntityForName:@"PracticeSession" inManagedObjectContext:cdh.context];
    practiceSession.date = [NSDate date];
    practiceSession.duration = [NSNumber numberWithDouble:self.timeElapsed];
    practiceSession.guided = [NSNumber numberWithBool:NO];
    practiceSession.user = [(AppDelegate*)[[UIApplication sharedApplication] delegate] currentUser];
    [self sendPracticeSessionToServer:practiceSession];
    [cdh saveContext];
}

#pragma mark - CONNECTION
- (void)sendPracticeSessionToServer:(PracticeSession*)practiceSession {
    NSString *xml = [XMLUtility xmlFromPracticeSession:practiceSession];
    
    if ([_reachability isReachable]) {
        NSString *path = kAddPracticeSessionPath;
        NSURL *url = [NSURL URLWithString:path];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        
        [request setValue:@"text/plain; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [xml length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:[xml dataUsingEncoding:NSUTF8StringEncoding]];
        
        self.connectionData = [[NSMutableData alloc] initWithCapacity:0];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (!connection)
            self.connectionData = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.connectionData appendData:data];
    if (debug==1) NSLog(@"%@ '%@': data received", self.class, NSStringFromSelector(_cmd));
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *string = [[NSString alloc] initWithData:self.connectionData encoding:NSISOLatin1StringEncoding];
    if (debug==1) NSLog(@"Server response: %@", string);
}

@end
