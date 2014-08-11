//
//  PickerTF_User.m
//  WorkWell
//
//  Created by Aaron Wells on 7/30/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import "PickerTF_User.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "User.h"

@implementation PickerTF_User

#define debug 1

- (void)fetch {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    [request setFetchBatchSize:50];
    NSError *error;
    self.data = [cdh.context executeFetchRequest:request error:&error];
    if (error) {NSLog(@"Error populating picker: %@, %@", error, error.localizedDescription);}
}

- (void)selectDefaultRow {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    if (self.selectedObjectID) {
        // Set DEFAULT row to match CURRENTLY SELECTED object
        CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        User *selectedObject = (User*)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
        if (self.data.count > 0) {
            int i = 0;
            for (User *user in self.data) {
                if (user.username == selectedObject.username) {
                    [self.picker selectRow:i inComponent:0 animated:NO];
                    [self.pickerDelegate selectedObjectID:self.selectedObjectID changedForPickerTF:self];
                    break;
                }
                i++;
            }
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    User *user = [self.data objectAtIndex:row];
    return user.username;
}

@end