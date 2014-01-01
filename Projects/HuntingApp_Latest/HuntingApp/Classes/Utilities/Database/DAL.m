//
//  CoreDataUtility.h
//  Walks
//
//  Created by Usman Aleem on 8/2/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DAL.h"
#import "CoreDataUtilityExtension.h"

/*
 * Singleton Class for DataModel and CoreData operations
 */

@implementation DAL

@synthesize managedObjectContext;
@synthesize mObjectContextThread;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

static DAL *CDUtility = nil;

#pragma mark -
#pragma mark Init

+ (DAL *)sharedInstance {
    if (CDUtility == nil) {
        CDUtility = [[super allocWithZone:NULL] init];
        [[NSNotificationCenter defaultCenter] addObserver:CDUtility
                                                 selector:@selector(loadManagedObjectFromNotification:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:nil];
    }
    return CDUtility;
}
-(id) init {
    self = [super init];
    if (self) {
    }
    return self;
}
+ (id)allocWithZone:(NSZone *)zone{
    return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

- (id)retain{
    return self;
}

- (NSUInteger)retainCount{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (id)autorelease{
    return self;
}

- (oneway void) release {
    
    
}
- (NSManagedObjectContext*) context
{
    return self.managedObjectContext;
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext != nil)
    {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)mObjectContextThread
{
    
    RELEASE_SAFELY(mObjectContextThread);
    
    if (mObjectContextThread != nil)
    {
        return mObjectContextThread;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        mObjectContextThread = [[NSManagedObjectContext alloc] init];
        [mObjectContextThread setPersistentStoreCoordinator:coordinator];
    }
    return mObjectContextThread;
}


/**
 Take manageObjectContext by refrence and alloc init it.
 */
-(void)managedObjectContextInThread:(NSManagedObjectContext**)mObjectContext
{
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        (*mObjectContext) = [[NSManagedObjectContext alloc] init];
        [(*mObjectContext) setPersistentStoreCoordinator:coordinator];
    }
    
}

/**
 Take manageObjectContext by refrence and decide if its a main thread the return self.managedObjectContext otherwise alloc init it.
 */
- (void)managedObjectContext:(NSManagedObjectContext**)mObjectContext
{
    
    //    if ([NSThread isMainThread]) {
    //        //If current thread is main thread then use usual managed object context
    //        *mObjectContext = self.managedObjectContext;
    //    }
    //    else{
    //        //Else use a new managed object context for thread
    //        [self managedObjectContextInThread:&*mObjectContext];
    //    }
    *mObjectContext = self.managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
	if (managedObjectModel != nil) {
		return managedObjectModel;
	}
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kCDMomdFileName withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
	//managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]] retain];
    
	return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:kCoreDataStorePath];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
    // If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:kDefaultCDStorePath ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	NSURL *storeURL = [NSURL fileURLWithPath:storePath];
	
    NSError *error = nil;
    
    // For migration
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;
}



#pragma mark -
#pragma mark Temp Methods

- (NSString *) genRandStringLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%c", [letters characterAtIndex: rand()%[letters length]]];
        
    }
    return randomString;
}



#pragma mark -
#pragma mark fetchedRecords

- (NSArray*)fetchRecords:(NSString*)tableName
                  sortBy:(NSString*)sortColumn
{
    @try {
        return [self fetchRecords:tableName
                    withPredicate:nil
                           sortBy:sortColumn
                        assending:YES];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSExcetion %@",__func__,[exception description]);
    }
    
    
    
}

- (NSArray*)fetchRecords:(NSString*)tableName
           withPredicate:(NSPredicate*)predicate
                  sortBy:(NSString*)sortColumn
               assending:(BOOL)isAssending
{
    @try {
        return [self fetchRecords:tableName
                    withPredicate:predicate
                  withFetchOffset:0
                   withFetchLimit:0
                           sortBy:sortColumn
                        assending:isAssending];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSExcetion %@",__func__,[exception description]);
    }
    
    
}

- (NSArray*)fetchRecords:(NSString*)tableName
           withPredicate:(NSPredicate*)predicate
         withFetchOffset:(NSInteger)fetchOffset
          withFetchLimit:(NSInteger)fetchLimit
                  sortBy:(NSString*)sortColumn
               assending:(BOOL)isAssending

{
    
    @try {
        NSManagedObjectContext *mObjectContext;
        [self managedObjectContext:&mObjectContext];
        
        return [self fetchRecords:tableName
                    withPredicate:predicate
                  withFetchOffset:fetchOffset
                   withFetchLimit:fetchLimit
                           sortBy:sortColumn
                        assending:isAssending
            InManageObjectContext:mObjectContext];
        
        
    }
    @catch (NSException *exception) {
        DLog(@"func :%s exception : %@",__func__,[exception description]);
    }
}

- (NSArray*)fetchRecords:(NSString*)tableName
           withPredicate:(NSPredicate*)predicate
         withFetchOffset:(NSInteger)fetchOffset
          withFetchLimit:(NSInteger)fetchLimit
                  sortBy:(NSString*)sortColumn
               assending:(BOOL)isAssending
   InManageObjectContext:(NSManagedObjectContext *)mObjectContext

{
    //DLog(@"fetchRecords with manageobject");
    NSArray *fetchResults = nil;
    @try {
        
        // Define our table/entity to use
        NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:mObjectContext];
        // Setup the fetch request
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:entity];
        //DLog(@"chkPoint 1");
        //Set fetch Limit and fetch Offset
        [request setFetchLimit:fetchLimit];
        [request setFetchOffset:fetchOffset];
        
        //Set optionol parameters//
        if(sortColumn)
        {
            NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:sortColumn ascending:isAssending] autorelease];
            NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil] autorelease];
            if(sortDescriptors) {
                [request setSortDescriptors:sortDescriptors];
            }//if sortDescriptors
        }
        //DLog(@"chkPoint 2");
        if(predicate)
            [request setPredicate:predicate];
        //optional parameters//
        
        
        // Fetch the records and handle an error
        NSError *error;
        
        fetchResults = [NSArray arrayWithArray:[mObjectContext executeFetchRequest:request error:&error]];
        //DLog(@"chkPoint 3");
        //TODO
    }
    @catch (NSException *exception) {
        DLog(@"func :%s exception : %@",__func__,[exception description]);
    }
    @finally {
        return fetchResults;
    }
}



- (NSArray*)fetchRecords:(NSString*)tableName
           withPredicate:(NSPredicate*)predicate
         withFetchOffset:(NSInteger)fetchOffset
          withFetchLimit:(NSInteger)fetchLimit
                  sortBy:(NSString*)sortColumn
               assending:(BOOL)isAssending
       propertiesToFetch:(NSArray*) propertiesToFetch
{
    
    @try {
        NSManagedObjectContext *mObjectContext;
        [self managedObjectContext:&mObjectContext];
        
        [self fetchRecords:tableName
             withPredicate:predicate
           withFetchOffset:fetchOffset
            withFetchLimit:fetchLimit
                    sortBy:sortColumn
                 assending:isAssending
         propertiesToFetch:propertiesToFetch
     InManageObjectContext:mObjectContext];
    }
    @catch (NSException *exception) {
        DLog(@"func :%s exception : %@",__func__,[exception description]);
    }
    
}

- (NSArray*)fetchRecords:(NSString*)tableName
           withPredicate:(NSPredicate*)predicate
         withFetchOffset:(NSInteger)fetchOffset
          withFetchLimit:(NSInteger)fetchLimit
                  sortBy:(NSString*)sortColumn
               assending:(BOOL)isAssending
       propertiesToFetch:(NSArray*) propertiesToFetch
   InManageObjectContext:(NSManagedObjectContext *)mObjectContext
{
    NSArray *fetchResults = nil;
    @try {
        // Define our table/entity to use
        NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:mObjectContext];
        // Setup the fetch request
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:entity];
        
        //Set fetch properties
        [request setPropertiesToFetch:propertiesToFetch];
        [request setResultType:NSDictionaryResultType];
        
        //Set fetch Limit and fetch Offset
        [request setFetchLimit:fetchLimit];
        [request setFetchOffset:fetchOffset];
        
        //Set optionol parameters//
        if(sortColumn)
        {
            NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:sortColumn ascending:isAssending] autorelease];
            NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil] autorelease];
            if(sortDescriptors) {
                [request setSortDescriptors:sortDescriptors];
            }//if sortDescriptors
        }
        
        if(predicate)
            [request setPredicate:predicate];
        //optional parameters//
        
        
        // Fetch the records and handle an error
        NSError *error;
        
        fetchResults = [NSArray arrayWithArray:[self.managedObjectContext executeFetchRequest:request error:&error]];
        
    }
    @catch (NSException *exception) {
        DLog(@"func :%s exception : %@",__func__,[exception description]);
    }
    @finally {
        return fetchResults;
    }
}

- (NSArray*)fetchRecords:(NSString*)tableName
           withPredicate:(NSPredicate*)predicate
         withFetchOffset:(NSInteger)fetchOffset
          withFetchLimit:(NSInteger)fetchLimit
                  sortBy:(NSString*)sortColumn
               assending:(BOOL)isAssending
       propertiesToFetch:(NSArray*) propertiesToFetch
   InManageObjectContext:(NSManagedObjectContext *)mObjectContext
         distinctResults:(BOOL)isDistinct
{
    NSArray *fetchResults = nil;
    @try {
        // Define our table/entity to use
        NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:mObjectContext];
        // Setup the fetch request
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:entity];
        if (isDistinct)
            [request setReturnsDistinctResults:YES];
        //Set fetch properties
        [request setPropertiesToFetch:propertiesToFetch];
        [request setResultType:NSDictionaryResultType];
        
        //Set fetch Limit and fetch Offset
        [request setFetchLimit:fetchLimit];
        [request setFetchOffset:fetchOffset];
        
        //Set optionol parameters//
        if(sortColumn)
        {
            NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:sortColumn ascending:isAssending] autorelease];
            NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil] autorelease];
            if(sortDescriptors) {
                [request setSortDescriptors:sortDescriptors];
            }//if sortDescriptors
        }
        
        if(predicate)
            [request setPredicate:predicate];
        //optional parameters//
        
        
        // Fetch the records and handle an error
        NSError *error;
        
        fetchResults = [NSArray arrayWithArray:[self.managedObjectContext executeFetchRequest:request error:&error]];
        
    }
    @catch (NSException *exception) {
        DLog(@"func :%s exception : %@",__func__,[exception description]);
    }
    @finally {
        return fetchResults;
    }
}


#pragma mark -
#pragma mark Save Context

- (BOOL)saveContext
{
    BOOL isSave = YES;
    NSError *error = nil;
    
    if (self.managedObjectContext != nil) {
        [self.managedObjectContext lock];
        
        if ([self.managedObjectContext hasChanges] &&
            ![self.managedObjectContext save:&error]) {
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            isSave = NO;
        }
        [self.managedObjectContext unlock];
        
    }
    return isSave;
}


- (BOOL)saveContext:(NSManagedObjectContext*)mObjectContext
{
    BOOL isSave = YES;
    NSError *error = nil;
    //DLog(@"saveContext with mObjectContext");
    if (mObjectContext != nil) {
        
        if ([mObjectContext hasChanges] &&
            ![mObjectContext save:&error]) {
            DLog(@"%s: Unresolved error %@, %@",__func__, error, [error userInfo]);
            isSave = NO;
        }
    }
    //DLog(@"saveContext with mObjectContext chkPoint 1");
    return isSave;
}

- (BOOL)resetDataStore
{
    [[self managedObjectContext] lock];
    [[self managedObjectContext] reset];
    NSPersistentStore *store = [[[self persistentStoreCoordinator] persistentStores] lastObject];
    BOOL resetOk = NO;
    
    if (store)
    {
        NSURL *storeUrl = store.URL;
        NSError *error;
        
        if ([[self persistentStoreCoordinator] removePersistentStore:store error:&error])
        {
            [[self persistentStoreCoordinator] release];
            persistentStoreCoordinator = nil;
            [[self managedObjectContext] release];
            managedObjectContext = nil;
            
            if (![[NSFileManager defaultManager] removeItemAtPath:storeUrl.path error:&error])
            {
                DLog(@"\nresetDatastore. Error removing file of persistent store: %@",
                      [error localizedDescription]);
                resetOk = NO;
            }
            else
            {
                //now recreate persistent store
                [self persistentStoreCoordinator];
                [[self managedObjectContext] unlock];
                resetOk = YES;
            }
        }
        else
        {
            DLog(@"\nresetDatastore. Error removing persistent store: %@",
                  [error localizedDescription]);
            resetOk = NO;
        }
        return resetOk;
    }
    else
    {
        DLog(@"\nresetDatastore. Could not find the persistent store");
        return resetOk;
    }
}



//This method will return the predicate depends upon the params
- (NSPredicate *)getPredicateWithParams:(NSDictionary *)parms withpredicateOperatorType:(NSArray *)predicateOperatorType {
    
    NSPredicate *predicate = nil;
    NSMutableArray *subpredicates = [[[NSMutableArray alloc] init] autorelease];
    NSInteger index = 0;
    
    for (NSString *key in [parms allKeys]) {
        
        NSString *value = [parms valueForKey:key];
        
        NSExpression *leftExpression = [NSExpression expressionForKeyPath:key];
        NSExpression *rightExpression = [NSExpression expressionForConstantValue:value];
        
        predicate = [NSComparisonPredicate predicateWithLeftExpression:leftExpression
                                                       rightExpression:rightExpression
                                                              modifier:NSDirectPredicateModifier
                                                                  type: (predicateOperatorType) ?[[predicateOperatorType objectAtIndex:index] intValue] :NSEqualToPredicateOperatorType
                                                               options:NSCaseInsensitivePredicateOption];
        [subpredicates addObject:predicate];
        
        index ++;
        
        predicate = nil;
    }
    predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
    
    return predicate;
}



#pragma mark -
#pragma mark Data Filter Methods

-(id)trimNULL:(id)data{
    //DLog(@"data type %@",[data class]);
    if(!data || [data isEqual:[NSNull null]])
        if([data isKindOfClass:[NSString class]])
            return @"";
        else if([data isKindOfClass:[NSDecimalNumber class]])
            return [NSNumber numberWithInt:0];
        else return 0;
        else
            return data;
}

-(BOOL)nullCheckForID:(id)identifier
{
    //DLog(@"identifier type %@",[identifier class]);
    if([identifier isKindOfClass:[NSString class]] && (!identifier || [identifier isEqualToString:@""]))
        return FALSE;
    else if([identifier isKindOfClass:[NSDecimalNumber class]] && (identifier == [NSNull null]))
        return FALSE;
    else if(![identifier isKindOfClass:[NSString class]] && ![identifier isKindOfClass:[NSDecimalNumber class]])
        return FALSE;
    return TRUE;
}

-(NSDate*)unixTimestampToNSDate:(double)unixTimestamp
{
    //NSCalendar *calendar = [[NSCalendar currentCalendar] retain];
    //NSDate *date = [NSDate dateWithTimeIntervalSince1970:(unixTimestamp - ([[calendar timeZone] secondsFromGMT]))];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTimestamp];
    return date;
}


#pragma notification
- (void)loadManagedObjectFromNotification:(NSNotification *)saveNotification
{
    if ([NSThread isMainThread]) {
        @synchronized(self.managedObjectContext){
            [self.managedObjectContext mergeChangesFromContextDidSaveNotification:saveNotification];
        }
    } else {
        [self performSelectorOnMainThread:@selector(loadManagedObjectFromNotification:) withObject:saveNotification waitUntilDone:YES];
    }
}

@end