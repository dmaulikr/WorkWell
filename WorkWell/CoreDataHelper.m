//
//  CoreDataHelper.m
//  WorkWell
//
//  Created by Aaron Wells on 7/17/14.
//  Copyright (c) 2014 Aaron Wells. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper
#define debug 1

#pragma mark - FILES
NSString * kStoreFilename = @"WorkWell.sqlite";

#pragma mark - DIRECTORIES
- (NSString *)applicationDocumentsDirectory {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
}

- (NSURL *)applicationStoresDirectory {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    NSURL *storesDirectory = [[NSURL fileURLWithPath:[self applicationDocumentsDirectory]] URLByAppendingPathComponent:@"Stores"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtURL:storesDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
            if (debug==1) {NSLog(@"Successfully created Stores directory");}
        } else {NSLog(@"FAILED to create Stores directory: %@", error);}
    } else {if (debug==1) {NSLog(@"Skipped creating Stores directory (it already exists)");}}
    
    return storesDirectory;
}

- (NSURL *)storeURL {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    return [[self applicationStoresDirectory] URLByAppendingPathComponent:kStoreFilename];
}

#pragma mark - SETUP
- (id)init {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    self = [super init];
    if (!self) {return nil;}
    
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_context setPersistentStoreCoordinator:_coordinator];
    return self;
}

- (void)loadStore {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:[NSNumber numberWithBool:YES]
                forKey:NSMigratePersistentStoresAutomaticallyOption];
//    [options setObject:[NSNumber numberWithBool:YES]
//                forKey:NSInferMappingModelAutomaticallyOption];
    
    NSError *error = nil;
    _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                                  URL:[self storeURL]
                                              options:options error:&error];
    if (!_store) {NSLog(@"Failed to add store. Error: %@", error);abort();}
    else         {NSLog(@"Successfully added store: %@", _store);}
}

- (void)setupCoreData {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    [self loadStore];
}

#pragma mark - SAVING
- (void)saveContext {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    if ([_context hasChanges]) {
        NSError *error = nil;
        if ([_context save:&error]) {NSLog(@"_context SAVED changes to persistent store");}
        else {NSLog(@"Failed to save _context: %@", error);abort();}
    }
}

@end
