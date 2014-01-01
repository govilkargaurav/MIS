//
//  DAL+Comment.m
//  HuntingApp
//
//  Created by Habib Ali on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DAL+Comment.h"

@implementation DAL (Comment)

- (Comment *)addCommentAndEditPictureWithParams:(NSDictionary *)params inPicture:(NSString *)picID
{
    Picture *picture = [self getImageByImageID:picID];
    Comment *comment = nil;
    NSManagedObjectContext *mObjectContext = nil;
    [self managedObjectContext:&mObjectContext];
    NSString *date = [params objectForKey:COMMENT_DATE_KEY];
    NSString *content = [params objectForKey:KWEB_SERVICE_CONTENT];
    NSString *name = [params objectForKey:KWEB_SERVICE_NAME];
    NSString *userID = [params objectForKey:KWEB_SERVICE_USERID];
    NSNumber *comment_id = [NSNumber numberWithInt:[[params objectForKey:COMMENT_ID_KEY] intValue]];
    if (picture && date && content && name && userID)
    {
        @try 
        {
            comment = [self getCommentByID:comment_id];
            if(!comment)
            {        
                comment = [NSEntityDescription insertNewObjectForEntityForName:COMMENT_ENTITY inManagedObjectContext:mObjectContext];
            }
            [comment setComment_id:comment_id];
            [comment setDate:date];
            [comment setDesc:content];
            [comment setUser_id:userID];
            [comment setUser_name:name];
            [picture addCommentsObject:comment];
        }
        @catch (NSException *exception) 
        {
            DLog(@"%s: NSException %@",__func__,[exception description]);
        }
        @finally {
            if (![self saveContext])
                DLog(@"Context not saved");
        }
    }
    
    return comment;

}

- (Comment *)getCommentByID:(NSNumber * )ID
{
    Comment *comment = nil;
    @try {
        NSDictionary *predicateDict = nil;
        predicateDict =  [NSDictionary dictionaryWithObjectsAndKeys:ID,COMMENT_ID_KEY,nil];
        NSPredicate *predicate = [self getPredicateWithParams:predicateDict withpredicateOperatorType:nil];
        
        NSArray *array = [self fetchRecords:COMMENT_ENTITY withPredicate:predicate withFetchOffset:0 withFetchLimit:0 sortBy:nil assending:YES];
        
        if([array count])
            comment = (Comment*) [array objectAtIndex:0];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally {
        return comment;
    }

    
}

@end
