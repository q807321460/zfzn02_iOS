//
//  JSBaseCoreData.m
//  Smart360
//
//  Created by sun on 15/8/17.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSBaseCoreData.h"

@interface JSBaseCoreData ()

@property (nonatomic, copy) NSString *fileName;

@end

@implementation JSBaseCoreData

#pragma mark Core Data init
- (instancetype)initWithDataBaseFile:(NSString *)fileName {
    if (self = [super init]) {
        self.fileName = fileName;
    }
    
    [self commonInit];
    return self;
}

- (void)commonInit {

}


#pragma mark Core Data setter & getter
- (NSString *)persistentStoreDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths count] > 0 ? paths[0] : NSTemporaryDirectory();
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directoryName = @"DataBase";
    NSString *persistentStoreDirectory = [basePath stringByAppendingPathComponent:directoryName];
    if (![fileManager fileExistsAtPath:persistentStoreDirectory]) {
        [fileManager createDirectoryAtPath:persistentStoreDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return persistentStoreDirectory;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:_fileName withExtension:@"momd"];
    if (!url) {
        url = [[NSBundle mainBundle] URLForResource:_fileName withExtension:@"mom"];
    }
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSString *path = [[self persistentStoreDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", _fileName]];
    NSURL *storeUrl = [NSURL fileURLWithPath:path];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
   
    NSError *error = nil;
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption  : @YES,
                              NSInferMappingModelAutomaticallyOption        : @YES,
                              NSSQLitePragmasOption                         : @{@"synchronous": @"OFF"}
                              };
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        JSlog([error description]);
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    
    return _managedObjectContext;
}

#pragma mark Other
- (void)saveWithSuccessedHandler:(HandleSaveSuccessedBlock)aSuccessedHandler failedHandler:(HandleSaveFailedBlock)aFailedHandler {
    _successedBlock = aSuccessedHandler;
    _failedBlock = aFailedHandler;
}

- (void)saveContext {
    NSManagedObjectContext *manageObjectContext = self.managedObjectContext;
    
    if (!manageObjectContext) {
        return;
    }
    
    if ([manageObjectContext hasChanges]) {
        NSError *error = nil;
        if (![manageObjectContext save:&error]) {
            if (_failedBlock) {
                _failedBlock(error);
            }
        } else {
            if (_successedBlock) {
                _successedBlock();
            }
        }
    }
}

@end
