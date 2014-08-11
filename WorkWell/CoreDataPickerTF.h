//
//  CoreDataPickerTF.h
//  WorkWell
//
//  Created by Aaron Wells on 7/30/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

@class CoreDataPickerTF;

@protocol CoreDataPickerTFDelegate <NSObject>
- (void)selectedObjectID:(NSManagedObjectID*)objectID changedForPickerTF:(CoreDataPickerTF*)pickerTF;

@optional
- (void)selectedObjectClearedForPickerTF:(CoreDataPickerTF*)pickerTF;

@end

@interface CoreDataPickerTF : UITextField
<UIKeyInput, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id <CoreDataPickerTFDelegate> pickerDelegate;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic) BOOL showToolbar;
@property (nonatomic, strong) NSManagedObjectID *selectedObjectID;

@end