//
//  JSBaseCoreData.h
//  Smart360
//
//  Created by sun on 15/8/17.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HandleSaveSuccessedBlock)();
typedef void (^HandleSaveFailedBlock)(NSError *error);

@interface JSBaseCoreData : NSObject

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, copy) HandleSaveSuccessedBlock successedBlock;
@property (nonatomic, copy) HandleSaveFailedBlock    failedBlock;

- (instancetype)initWithDataBaseFile:(NSString *)fileName;

@end
