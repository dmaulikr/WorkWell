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
@property (strong, nonatomic)AVAudioPlayer *audioPlayer;

@end

@implementation GuidedMeditationVC

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
    CoreDataHelper *cdh = [(AppDelegate*)[[UIApplication sharedApplication] delegate] cdh];
    GuidedMeditation *guidedMeditation = (GuidedMeditation*)[cdh.context existingObjectWithID:self.selectedMeditationID error:nil];
    NSData *audioData = guidedMeditation.audioFile.data;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData fileTypeHint:@"mp3" error:nil];
    [self.audioPlayer play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
