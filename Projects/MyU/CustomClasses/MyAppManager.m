//
//  MyAppManager.m
//  DriversSafety
//
//  Created by Gagan Mishra on 3/8/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "MyAppManager.h"
#import <OHAttributedLabel/OHAttributedLabel.h>
#import <OHAttributedLabel/NSAttributedString+Attributes.h>
#import <OHAttributedLabel/OHASBasicHTMLParser.h>
#import <OHAttributedLabel/OHASBasicMarkupParser.h>
#import "NSString+Utilities.h"

@implementation MyAppManager
@synthesize fileManager,documentsDirectory,imgPickerCamera,imgPickerLibrary,dateFormatter;
@synthesize viewLoadOverlay,imgLoader;

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
        dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        dictHome=[[NSMutableDictionary alloc]init];
        arrHome=[[NSMutableArray alloc]init];
        arrHomeModel=[[NSMutableArray alloc]init];
        dictNews=[[NSMutableDictionary alloc]init];
        arrNews=[[NSMutableArray alloc]init];
        arrNewsModel=[[NSMutableArray alloc]init];
        arrPosts=[[NSMutableArray alloc]init];
        arrUserNewsModel=[[NSMutableArray alloc]init];
        arrProfessors=[[NSMutableArray alloc]init];
        arrProfessorRatings=[[NSMutableArray alloc]init];
        dictProfessorRatings=[[NSMutableDictionary alloc]init];
        arrAppUsers=[[NSMutableArray alloc]init];
        arrNotifications=[[NSMutableArray alloc]init];
        arrJoinedGroups=[[NSMutableArray alloc]init];
        arrUnJoinedGroups=[[NSMutableArray alloc]init];
        dictGroups=[[NSMutableDictionary alloc]init];
        strRules=[[NSMutableString alloc]init];
        dictImages=[[NSMutableDictionary alloc]init];
        dictGuestModeUni=[[NSMutableDictionary alloc]init];
        dictUpdatedGroupSettings=[[NSMutableDictionary alloc]init];
        
        viewLoadOverlay=[[UIView alloc]init];
        viewLoadOverlay.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
        imgLoader=[[UIImageView alloc]init];
        [imgLoader setImage:[UIImage imageNamed:@"spinner.png"]];
        imgLoader.frame=CGRectMake(0, 0, 35, 35);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];

        SDWebImageManager.sharedManager.imageDownloader.executionOrder = SDWebImageDownloaderLIFOExecutionOrder;
    }
    return self;
}

-(void)signOutFromApp
{
    [dictHome removeAllObjects];
    [arrHome removeAllObjects];
    [arrHomeModel removeAllObjects];
    [dictNews removeAllObjects];
    [arrNews removeAllObjects];
    [arrNewsModel removeAllObjects];
    [arrPosts removeAllObjects];
    [arrJoinedGroups removeAllObjects];
    [arrUnJoinedGroups removeAllObjects];
    [arrUserNewsModel removeAllObjects];
    [arrProfessors removeAllObjects];
    [arrProfessorRatings removeAllObjects];
    [dictProfessorRatings removeAllObjects];
    [dictUpdatedGroupSettings removeAllObjects];
    [arrAppUsers removeAllObjects];
    [arrNotifications removeAllObjects];
    [dictGroups removeAllObjects];
    [dictGuestModeUni removeAllObjects];
    [dictUserInfo removeAllObjects];
    isAppInGuestMode=NO;
    shouldBackToRoot=NO;
    shouldBackToChat=NO;
    shouldUpdateGroupSettings=NO;
    selectedMenuIndex=0;
    unread_notificationcount=0;
    [UIApplication sharedApplication].applicationIconBadgeNumber=unread_notificationcount;

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_info"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uni_info"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)saveObject:(NSString *)strData ForKey:(NSString *)theKey
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[strData removeNull] forKey:theKey];
    [defaults synchronize];
}
-(NSString *)theObjectForKey:(NSString *)theKey
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *strData=[NSString stringWithFormat:@"%@",[defaults objectForKey:theKey]];
    return [strData removeNull];
}

-(void)showLoaderInMainThread
{
    [self performSelectorOnMainThread:@selector(showLoader) withObject:nil waitUntilDone:NO];
}
-(void)hideLoaderInMainThread
{
    [self performSelectorOnMainThread:@selector(hideLoader) withObject:nil waitUntilDone:NO];
}

-(void)showSpinnerInView:(UIView *)theView
{
    viewLoadOverlay.frame=CGRectMake(0, 0,theView.frame.size.width,theView.frame.size.height);
    viewLoadOverlay.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
    imgLoader=[[UIImageView alloc]init];
    [imgLoader setImage:[UIImage imageNamed:@"spinner.png"]];
    imgLoader.frame=CGRectMake(0, 0, 35, 35);
    imgLoader.center=viewLoadOverlay.center;
    
    [theView addSubview:viewLoadOverlay];
    [theView addSubview:imgLoader];
    
    CABasicAnimation *fullRotation;
    fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    fullRotation.duration = 1.2f;
    fullRotation.repeatCount = MAXFLOAT;
    [imgLoader.layer addAnimation:fullRotation forKey:@"3600"];
}
-(void)hideSpinner
{
    [imgLoader.layer removeAnimationForKey:@"3600"];
    [viewLoadOverlay removeFromSuperview];
}
-(void)showLoader
{
    hud=[MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
}
-(void)showLoaderWithtext:(NSString *)strText
{
    hud =[MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = strText;
}
-(void)showLoaderWithtext:(NSString *)strText andDetailText:(NSString *)strDetailText
{
    hud =[MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = strText;
    hud.detailsLabelText = strDetailText;
}
-(void)hideLoader
{
    [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
}


-(void)customiseAppereance
{
    [[OHAttributedLabel appearance] setLinkColor:RGBCOLOR(58.0,156.0,178.0)];
    
    uint32_t styles[] = {
        kCTUnderlineStyleSingle | kCTUnderlinePatternSolid,
        kCTUnderlineStyleDouble | kCTUnderlinePatternSolid,
        kOHBoldStyleTraitSetBold,
        kCTUnderlineStyleSingle | kCTUnderlinePatternDash,
        kCTUnderlineStyleNone
    };
    uint32_t style = styles[4];
    [[OHAttributedLabel appearance] setLinkUnderlineStyle:style];
    
    UIColor* colors[] = {
        [UIColor colorWithWhite:0.4 alpha:0.3],
        [UIColor colorWithRed:0.3 green:0.3 blue:1.0 alpha:0.3],
        [UIColor colorWithRed:0.3 green:0.7 blue:0.3 alpha:0.3],
        nil
    };
    UIColor* color = colors[1];
    [[OHAttributedLabel appearance] setHighlightedLinkColor:color];
}
-(void)updatenotificationbadge
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strUserId,@"userid",nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kBadgeNotificationURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
    [obj startRequest];
}

-(void)createDirectoryInDocumentsFolderWithName:(NSString *)dirName
{
    NSString *dirPath = [documentsDirectory stringByAppendingPathComponent:dirName];
    BOOL isDir=YES;
    BOOL isDirExists = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if (!isDirExists) [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
}

@end
