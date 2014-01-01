//
//  MyAppManager.m
//  DriversSafety
//
//  Created by Gagan Mishra on 3/8/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "MyAppManager.h"

@implementation MyAppManager
@synthesize fileManager,documentsDirectory;
@synthesize arrAllFeeds,arrMyFeeds;

+(id)sharedManager
{
    static MyAppManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(id)init
{
    if (self = [super init])
    {
        appDelegate=kAppDelegate;
        fileManager=[[NSFileManager alloc]init];
        arrAllFeeds=[[NSMutableArray alloc]init];
        arrMyFeeds=[[NSMutableArray alloc]init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
        
        isBackGroundUploadRunning=NO;
    }
    return self;
}

-(void)createDirectoryInDocumentsFolderWithName:(NSString *)dirName
{
    NSString *dirPath = [documentsDirectory stringByAppendingPathComponent:dirName];
    BOOL isDir=YES;
    BOOL isDirExists = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if (!isDirExists) [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
}

-(NSString *)strImageNameFromURL:(NSString *)strURL
{
    NSMutableString *strImageName=[[NSMutableString alloc]initWithString:[strURL removeNull]];
    NSRange theRange=NSMakeRange(0, strImageName.length);
    [strImageName replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:theRange];
    [strImageName replaceOccurrencesOfString:@"\\" withString:@"" options:NSCaseInsensitiveSearch range:theRange];
    [strImageName replaceOccurrencesOfString:@"/" withString:@"" options:NSCaseInsensitiveSearch range:theRange];

    return strImageName;
}

-(NSString *)strTempUploaderDirPath
{
    return [documentsDirectory stringByAppendingPathComponent:kTempUploaderDirectory];
}

-(NSString *)strBGPostDirPath
{
    return [documentsDirectory stringByAppendingPathComponent:kBGPostDirectory];
}

-(NSString *)randomId
{
    //NSString *strRandomId=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSString *strRandomId=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSString *strRandomId2=[strRandomId stringByReplacingOccurrencesOfString:@"." withString:@""];
    //NSString *strRandomId3=[strRandomId2 substringFromIndex:5];
    return strRandomId2;
}

-(BOOL)writeDataToFileName:(NSString *)strFileName andData:(NSData *)fileData toDirectory:(NSString *)strDirName
{
    NSString *dirPath = [documentsDirectory stringByAppendingPathComponent:strDirName];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,strFileName];
    return [fileData writeToFile:filePath atomically:YES];
}

-(void)startBackGroundUpload
{
    if (isUserLoggedIn)
    {
        NSString *dirPath = [[[MyAppManager sharedManager] documentsDirectory] stringByAppendingPathComponent:kTempUploaderDirectory];
        NSString *strUserId =[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]];
        NSString *filePath = [NSString stringWithFormat:@"%@/bgpost_%@.plist",dirPath,strUserId];
        if ([[[MyAppManager sharedManager] fileManager] fileExistsAtPath:filePath])
        {
            NSMutableArray *arrBGPosts=[[NSMutableArray alloc]initWithContentsOfFile:filePath];
            
            if ([arrBGPosts count]>0)
            {
                if (!isBackGroundUploadRunning)
                {
                    isBackGroundUploadRunning=YES;
                    WSManager *objWS=[[WSManager alloc]initWithWSData:[arrBGPosts lastObject] withsucessHandler:@selector(feedshared:) withfailureHandler:@selector(feedsharingfailed:) withCallBackObject:self shouldRespond:YES];
                    [objWS startRequest];
                }
            }
        }
    }
}
-(void)feedshared:(NSObject *)sender
{
    isBackGroundUploadRunning=NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyBGPostRefresh object:nil];
    [self startBackGroundUpload];
}
-(void)feedsharingfailed:(NSObject *)sender
{
    isBackGroundUploadRunning=NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyBGPostRefresh object:nil];
    [self startBackGroundUpload];
}
@end
