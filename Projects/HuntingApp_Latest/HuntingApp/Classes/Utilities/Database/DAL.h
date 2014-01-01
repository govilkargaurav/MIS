//
//  CoreDataUtility.h
//  Bridges
//
//  Created by Usman Aleem on 8/2/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

/* 
 * Singleton Class for DataModel and CoreData operations 
 */

/**
 @brief The class encapsulate all persistence layer tasks.Singleton class
 */

@interface DAL : NSObject {
    
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectContext *mObjectContextThread;
    //NSManagedObjectContext *managedObjectContextForInsert;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectContext *mObjectContextThread;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

//Shared Instance of CoreDataUtility and ManagedObjectContext
+ (DAL*)sharedInstance;
- (NSManagedObjectContext*) context;

//Fetch
//-(NSArray*)fetchDirtyRecords:(NSString*)Entity withSecondAttribute:(NSString*)secondAttr;

//Save Context
- (BOOL)saveContext;
- (BOOL)resetDataStore;

//- (BOOL) saveInsertContext;

//Add offline data
//- (BOOL)addDataToDB;

- (void)managedObjectContext:(NSManagedObjectContext**)mObjectContext;
- (void)managedObjectContextInThread:(NSManagedObjectContext**)mObjectContext;
- (BOOL)saveContext:(NSManagedObjectContext*)mObjectContext;



@end