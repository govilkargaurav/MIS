//
//  CoreDataUtilityExtension.h
//  Walks
//
//  Created by Usman Aleem on 8/2/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/* 
 * Extension for CoreDataUtility
 */
#import "DAL.h"

@interface DAL ()
//Perform Fetch
/**
 This function will return all records of tableName with no perdicate sorted by sortColumn in Assending order; 
 
 */
- (NSArray*)fetchRecords:(NSString*)tableName 
                  sortBy:(NSString*)sortColumn;


/**
 This function will return all records of tableName with no perdicate sorted by sortColumn in isAssending order; 
 
 */
- (NSArray*)fetchRecords:(NSString*)tableName 
           withPredicate:(NSPredicate*)predicate
                  sortBy:(NSString*)sortColumn
               assending:(BOOL)isAssending;

- (NSArray*)fetchRecords:(NSString*)tableName 
           withPredicate:(NSPredicate*)predicate
         withFetchOffset:(NSInteger)fetchOffset
          withFetchLimit:(NSInteger)fetchLimit
                  sortBy:(NSString*)sortColumn
               assending:(BOOL)isAssending;

- (NSArray*)fetchRecords:(NSString*)tableName 
           withPredicate:(NSPredicate*)predicate
         withFetchOffset:(NSInteger)fetchOffset
          withFetchLimit:(NSInteger)fetchLimit
                  sortBy:(NSString*)sortColumn
               assending:(BOOL)isAssending;


- (NSArray*)fetchRecords:(NSString*)tableName 
           withPredicate:(NSPredicate*)predicate
         withFetchOffset:(NSInteger)fetchOffset
          withFetchLimit:(NSInteger)fetchLimit
                  sortBy:(NSString*)sortColumn
               assending:(BOOL)isAssending 
   InManageObjectContext:(NSManagedObjectContext*)mObjectContext;


- (NSArray*)fetchRecords:(NSString*)tableName 
           withPredicate:(NSPredicate*)predicate
         withFetchOffset:(NSInteger)fetchOffset
          withFetchLimit:(NSInteger)fetchLimit
                  sortBy:(NSString*)sortColumn
               assending:(BOOL)isAssending
       propertiesToFetch:(NSArray*) propertiesToFetch;


- (NSArray*)fetchRecords:(NSString*)tableName 
           withPredicate:(NSPredicate*)predicate
         withFetchOffset:(NSInteger)fetchOffset
          withFetchLimit:(NSInteger)fetchLimit
                  sortBy:(NSString*)sortColumn
               assending:(BOOL)isAssending
       propertiesToFetch:(NSArray*) propertiesToFetch 
   InManageObjectContext:(NSManagedObjectContext*)mObjectContext;

- (NSArray*)fetchRecords:(NSString*)tableName 
           withPredicate:(NSPredicate*)predicate
         withFetchOffset:(NSInteger)fetchOffset
          withFetchLimit:(NSInteger)fetchLimit
                  sortBy:(NSString*)sortColumn
               assending:(BOOL)isAssending
       propertiesToFetch:(NSArray*) propertiesToFetch
   InManageObjectContext:(NSManagedObjectContext *)mObjectContext 
         distinctResults:(BOOL)isDistinct;

// Note: This method will return a predicate
- (NSPredicate *)getPredicateWithParams:(NSDictionary *)parms withpredicateOperatorType:(NSArray *)predicateOperatorType;



//Data Filter
-(id)trimNULL:(id)data;
-(BOOL)nullCheckForID:(id)identifier;
-(NSDate*)unixTimestampToNSDate:(double)unixTimestamp;

@end