//
//  MyAppManager.h
//  DriversSafety
//
//  Created by Gagan Mishra on 3/8/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Constants.h"
#import "WSManager.h"
#define kAppDelegate (AppDelegate *)[[UIApplication sharedApplication]delegate];

@interface MyAppManager : NSObject
{
    AppDelegate *appDelegate;
    NSMutableArray *arrAllFeeds;
    NSMutableArray *arrMyFeeds;
    NSFileManager *fileManager;
    NSString *documentsDirectory;
}

+(id)sharedManager;
@property (nonatomic,strong) NSMutableArray *arrAllFeeds;
@property (nonatomic,strong) NSMutableArray *arrMyFeeds;
@property (nonatomic,strong) NSFileManager *fileManager;
@property (nonatomic,strong) NSString *documentsDirectory;

-(void)createDirectoryInDocumentsFolderWithName:(NSString *)dirName;
-(BOOL)writeDataToFileName:(NSString *)strFileName andData:(NSData *)fileData toDirectory:(NSString *)strDirName;
-(NSString *)randomId;
-(NSString *)strTempUploaderDirPath;
-(NSString *)strImageNameFromURL:(NSString *)strURL;

-(void)startBackGroundUpload;
-(void)feedshared:(NSObject *)sender;
-(void)feedsharingfailed:(NSObject *)sender;

@end
