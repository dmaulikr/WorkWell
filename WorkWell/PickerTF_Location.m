//
//  PickerTF_Location.m
//  WorkWell
//
//  Created by Aaron Wells on 8/6/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import "PickerTF_Location.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "Location.h"

@implementation PickerTF_Location

#define debug 1

- (void)fetch {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
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
        Location *selectedObject = (Location*)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
        if (self.data.count > 0) {
            int i = 0;
            for (Location *loc in self.data) {
                if (loc.name == selectedObject.name) {
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
    
    Location *loc = [self.data objectAtIndex:row];
    return loc.name;
}

@end
