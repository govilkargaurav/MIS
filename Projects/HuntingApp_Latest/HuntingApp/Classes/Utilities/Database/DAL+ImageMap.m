//
//  DAL+ImageMap.m
//  HuntingApp
//
//  Created by Habib Ali on 10/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DAL+ImageMap.h"

@implementation DAL (ImageMap)

- (ImageMap *)createImageMapWithPicture:(Picture *)picture andImage:(UIImage *)image
{
    Picture *pic = [self getImageByImageID:picture.pic_id];
    ImageMap *imageMap = nil;
    NSManagedObjectContext *mObjectContext = nil;
    [self managedObjectContext:&mObjectContext];
    if (picture && image)
    {
        @try 
        {
            imageMap = [self getImageMapByURL:pic.image_url];
            if(!imageMap)
            {        
                imageMap = [NSEntityDescription insertNewObjectForEntityForName:@"ImageMap" inManagedObjectContext:mObjectContext];
            }
            [imageMap addPictureObject:picture];
            [imageMap setImage:UIImagePNGRepresentation(image)];
            [imageMap setUrl:pic.image_url];
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
    
    return imageMap;
}

- (ImageMap *)getImageMapByURL:(NSString *)url
{
    ImageMap *imageMap = nil;
    @try {
        NSDictionary *predicateDict = nil;
        predicateDict =  [NSDictionary dictionaryWithObjectsAndKeys:url,@"url",nil];
        NSPredicate *predicate = [self getPredicateWithParams:predicateDict withpredicateOperatorType:nil];
        
        NSArray *array = [self fetchRecords:@"ImageMap" withPredicate:predicate withFetchOffset:0 withFetchLimit:0 sortBy:nil assending:YES];
        
        if([array count])
            imageMap = (ImageMap*) [array objectAtIndex:0];
    }
    @catch (NSException *exception) {
        DLog(@"%s: NSException %@",__func__,[exception description]);
    }
    @finally {
        return imageMap;
    }

}

@end
