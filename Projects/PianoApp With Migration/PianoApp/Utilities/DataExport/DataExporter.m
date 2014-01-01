//
//  DataExporter.m
//  InfoMe
//
//  Created by Mubin Lakadia on 21/08/12.
//  Copyright (c) 2012 Sevenstar Infotech. All rights reserved.
//

#import "DataExporter.h"
#import "NSData+CocoaDevUsersAdditions.h"
#define kDataKey        @"Data"
#define kDataFile       @"data.plist"

@implementation DataExporter

+ (NSString *)getPrivateDocsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];   
    
    return documentsDirectory;
    
}

+ (NSString *)nextInfoMeDocPath {
    
    // Get private docs dir
    NSString *documentsDirectory = [DataExporter getPrivateDocsDir];
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    // Search for an available name
    int maxNumber = 0;
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"infomedoc" options:NSCaseInsensitiveSearch] == NSOrderedSame) {            
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
        }
    }
    
    // Get available name
    NSString *availableName = [NSString stringWithFormat:@"%d.infomedoc", maxNumber+1];
    return [documentsDirectory stringByAppendingPathComponent:availableName];
    
}
+(BOOL)createDataPath:(NSString *)theDataPath
{
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:theDataPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return success;    
}

+(NSString *)saveDataFromDictionary:(NSMutableDictionary *)preexportdata
{
    NSString *tldataPath =[DataExporter nextInfoMeDocPath];
    [DataExporter createDataPath:tldataPath];
    NSString *dataPath = [tldataPath stringByAppendingPathComponent:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];          
    [archiver encodeObject:preexportdata forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
    [archiver release];
    [data release];
    
   // NSLog(@"the datapath=%@",dataPath);
    return dataPath;
}

+(NSMutableDictionary *)getDictionaryFromURL:(NSURL *)importURL
{
   // NSLog(@"The import url:%@",importURL);
    NSData *zippedData = [NSData dataWithContentsOfURL:importURL];    
    //NSString *tldataPath =[DataExporter nextInfoMeDocPath];
    //[DataExporter createDataPath:tldataPath];
    //NSString *dataPath = [tldataPath stringByAppendingPathComponent:kDataFile];
    //[zippedData writeToFile:dataPath atomically:YES];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:zippedData];
    NSMutableDictionary *importeddata = [[unarchiver decodeObjectForKey:kDataKey] retain];
    [unarchiver finishDecoding];
    [unarchiver release];
    return importeddata;
}
+(NSMutableDictionary *)getDictionaryFromData:(NSData *)importData
{
    //NSString *tldataPath =[DataExporter nextInfoMeDocPath];
    //[DataExporter createDataPath:tldataPath];
    //NSString *dataPath = [tldataPath stringByAppendingPathComponent:kDataFile];
    //[importData writeToFile:dataPath atomically:YES];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:importData];
    NSMutableDictionary *importeddata = [[unarchiver decodeObjectForKey:kDataKey] retain];
    [unarchiver finishDecoding];
    [unarchiver release];
    
//    NSString *strmsg=[NSString stringWithFormat:@"The data is as:%@",importeddata];
//    UIAlertView *alertx=[[UIAlertView alloc]initWithTitle:@"Test Alert!" message:strmsg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//    [alertx show];
//    [alertx release];
    
    return importeddata;
}
@end
