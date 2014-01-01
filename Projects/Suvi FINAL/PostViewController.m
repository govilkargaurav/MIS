//
//  PostViewController.m
//  Suvi
//
//  Created by Vivek Rajput on 10/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostViewController.h"
#import "OAuthTwitter.h"
#import "OAuthConsumerCredentials.h"
#import "OAuth.h"
#import "CustomLoginPopup.h"
#import "TwitterLoginPopup.h"
#import "FoursquareLoginPopup.h"
#import "NSString+URLEncoding.h"
#import "JSONParser.h"
#import "MyAppManager.h"

@interface PostViewController (PrivateMethods)
-(void)resetUi;
-(void)presentLoginWithFlowType:(TwitterLoginFlowType)flowType;
@end

@implementation PostViewController

@synthesize imgToPost,locationdata,muzikDict,videoURL;
@synthesize isLocationPostingView,isMusicPostingView,isYouTubePostingView;
@synthesize fbGraph,oAuthTwitter,oAuth4sq;
@synthesize facebook;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [imgTextBg setImage:[[UIImage imageNamed:@"imgcellheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35.0,0.0,0.0,0.0)]];
    
    imgTextBg.frame = CGRectMake(5,71+iOS7ExHeight,310,171+iPhone5ExHeight);
    viewpostToolbar.frame = CGRectMake(0,204+iPhone5ExHeight+iOS7ExHeight,320,37);
    txtViewPost.frame = CGRectMake(11, 111+iOS7ExHeight, 299,91+iPhone5ExHeight);
    
    self.navigationController.navigationBarHidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oauth_verifier_received:) name:NOTIFY_OAUTH_VERIFY_RECEIVED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateiamwithlabel:) name:@"IAmWith" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateiamatlabel:) name:@"IAmAt" object:nil];
    
    [self.view addSubview:viewPostMain];
    [txtViewPost becomeFirstResponder];

    issharedonfb=NO;
    issharedontwitter=NO;
    issharedonfoursquare=NO;
    [self updatesocialbuttons];
    
    arrcontacts=[[NSMutableArray alloc]init];
    arrfriends=[[NSMutableArray alloc]init];
    locationdata=[[NSMutableDictionary alloc]init];
    
    if ([strPostSuccessful isEqualToString:@"PostImage"])
    {
        imgTopLabel.image = [UIImage imageNamed:@"bgnavbarimage"];
        imgProfilePic.image = [imgToPost resizedImageToSize:CGSizeMake(45.0, 45.0)];
        lblPostTitle.text=@"What is this photo about?";
        
        viewUpperBorder.backgroundColor=kColorImage;
        [btnIAmAt setTitleColor:kColorImage forState:UIControlStateNormal];
        [btnIAmWith setTitleColor:kColorImage forState:UIControlStateNormal];
    }
    else if ([strPostSuccessful isEqualToString:@"PostVideo"] || isYouTubePostingView)
    {
        imgTopLabel.image = [UIImage imageNamed:@"bgnavbarvideo"];
        lblPostTitle.text=@"What’s this video about?";
        
        viewUpperBorder.backgroundColor=kColorVideo;
        [btnIAmAt setTitleColor:kColorVideo forState:UIControlStateNormal];
        [btnIAmWith setTitleColor:kColorVideo forState:UIControlStateNormal];
    }
    else if (isLocationPostingView) 
    {
        imgTopLabel.image = [UIImage imageNamed:@"bgnavbarplace"];
        imgProfilePic.image=[UIImage imageNamed:@"Location.png"];
        [imgProfilePic setContentMode:UIViewContentModeScaleAspectFit];
        [imgProfilePic setBackgroundColor:[UIColor blackColor]];
        lblPostTitle.text=@"What's up at ...";
        
        viewUpperBorder.backgroundColor=kColorLocation;
        [btnIAmAt setTitleColor:kColorLocation forState:UIControlStateNormal];
        [btnIAmWith setTitleColor:kColorLocation forState:UIControlStateNormal];
        
        [imgImWithAt setImage:[UIImage imageNamed:@"IamWith"]];
        
        CGRect theRect=btnIAmWith.frame;
        theRect.size.width+=155.0;
        btnIAmWith.frame=theRect;
        
        btnIAmAt.hidden=YES;
    }
    else if(isMusicPostingView)
    {
        imgTopLabel.image = [UIImage imageNamed:@"bgnavbarmusic"];
        lblPostTitle.text=[NSString stringWithFormat:@"Listening to %@",[muzikDict valueForKey:@"title"]];
        imgProfilePic.image=[muzikDict valueForKey:@"artwork"];
        [imgProfilePic setContentMode:UIViewContentModeScaleAspectFit];
        [imgProfilePic setBackgroundColor:[UIColor blackColor]];
        
        viewUpperBorder.backgroundColor=kColorMusic;
        
        [btnIAmAt setTitleColor:kColorMusic forState:UIControlStateNormal];
        [btnIAmWith setTitleColor:kColorMusic forState:UIControlStateNormal];
    }
    else
    {
        imgTopLabel.image = [UIImage imageNamed:@"bgnavbarthought"];
        
        viewUpperBorder.backgroundColor=kColorThought;
        [btnIAmAt setTitleColor:kColorThought forState:UIControlStateNormal];
        [btnIAmWith setTitleColor:kColorThought forState:UIControlStateNormal];
    }
    
    [btnIAmAt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [btnIAmWith setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    if (!([strPostSuccessful isEqualToString:@"PostImage"] || isLocationPostingView || isMusicPostingView))
    {
        NSURL *imgURLTemp = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"image_path"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [imgProfilePic setImageWithURL:imgURLTemp placeholderImage:[UIImage imageNamed:@"sync.png"]];
    }
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"LLLL dd, YYYY"];
    lblPostDate.text=[NSString stringWithFormat:@"%@",[dateformatter stringFromDate:[NSDate date]]];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (isLocationPostingView)
    {
        if ([locationdata objectForKey:@"name"])
        {
            lblPostTitle.text=[NSString stringWithFormat:@"What's up at %@?",[locationdata objectForKey:@"name"]];
        }
        else
        {
            IamAtViewController *obj=[[IamAtViewController alloc]init];
            obj.isLocationPostView=YES;
            [self.navigationController pushViewController:obj animated:YES];
        }
    }
}

#pragma mark - IBAction Method
-(IBAction)btnPostClicked:(id)sender
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        [txtViewPost resignFirstResponder];
        
        NSString *strIAmWithNames=[[self arrFinalName] componentsJoinedByString:@","];
        NSString *strIAmWithEmails=[[self arrEmailFinal] componentsJoinedByString:@","];
        
        NSString *strPostTextTMP1 =[NSString stringWithFormat:@"%@",[txtViewPost.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSMutableString *strPostTextTMP2=[[NSMutableString alloc]initWithString:[strPostTextTMP1 removeNull]];
        //NSRange theRange=NSMakeRange(0, strPostTextTMP2.length);
        //[strPostTextTMP2 replaceOccurrencesOfString:@"&" withString:@"\\u0026" options:NSCaseInsensitiveSearch range:theRange];
        NSString *strPostText =[NSString stringWithFormat:@"%@",strPostTextTMP2];
        
        NSString *strUserId =[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]];
        NSString *strUniqueId=[[MyAppManager sharedManager]randomId];
        NSString *strPostTime=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        
        NSMutableDictionary *dictWS=[[NSMutableDictionary alloc]init];
        [dictWS setObject:strUniqueId forKey:@"iActivityID"];
        [dictWS setObject:strUserId forKey:@"iAdminID"];
        [dictWS setObject:strPostTime forKey:@"tsInsertDt"];
        
        NSMutableDictionary *dictParams=[[NSMutableDictionary alloc]init];
        [dictParams setObject:strUserId forKey:@"userID"];
        [dictParams setObject:strPostText forKey:@"vActivityText"];
        [dictParams setObject:strIAmWithEmails forKey:@"vImWithEmailIds"];
        [dictParams setObject:strIAmWithNames forKey:@"vImWithflname"];
        
        [dictParams setObject:strUniqueId forKey:@"iUniqueId"];
        [dictParams setObject:([locationdata objectForKey:@"name"])?[locationdata objectForKey:@"name"]:@"" forKey:@"vIamAt"];
        [dictParams setObject:([[locationdata objectForKey:@"location"]objectForKey:@"address"])?[[locationdata objectForKey:@"location"]objectForKey:@"address"]:@"" forKey:@"vIamAt2"];
        [dictParams setObject:([locationdata objectForKey:@"id"])?[locationdata objectForKey:@"id"]:@"" forKey:@"venueId"];
        
        [dictParams setObject:(issharedonfb)?@"YES":@"NO" forKey:@"facebook_share"];
        [dictParams setObject:(issharedontwitter)?@"YES":@"NO" forKey:@"twitter_share"];
        [dictParams setObject:(issharedonfoursquare)?@"YES":@"NO" forKey:@"foursquare_share"];
        
        if (isMusicPostingView && [strPostSuccessful isEqualToString:@"PostOnly"])
        {
            [dictWS setObject:strMusicPOST forKey:@"POSTURL"];
            
            NSData *data= UIImagePNGRepresentation([muzikDict valueForKey:@"artwork"]);
            NSString *strFileName=[NSString stringWithFormat:@"%@.png",strUniqueId];
            
            if ([[MyAppManager sharedManager] writeDataToFileName:strFileName andData:data toDirectory:kTempUploaderDirectory])
            {
                NSString *dirPath = [[[MyAppManager sharedManager] documentsDirectory] stringByAppendingPathComponent:kTempUploaderDirectory];
                NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,strFileName];
                [dictWS setObject:filePath forKey:@"filePath"];
                [dictWS setObject:strFileName forKey:@"fileName"];
            }
            
            NSString *strAlbumName=[NSString stringWithFormat:@"%@",[muzikDict valueForKey:@"albumtitle"]];
            NSString *strSingersName=[NSString stringWithFormat:@"%@",[muzikDict valueForKey:@"artist"]];
            NSString *strMusicTitle=[NSString stringWithFormat:@"%@",[muzikDict valueForKey:@"title"]];
            NSString *strMusicTitle2=[NSString stringWithFormat:@"%@",([[strAlbumName removeNull]length]!=0)?strAlbumName:strSingersName];
            
            [dictParams setObject:@"music" forKey:@"vType_of_content"];
            [dictParams setObject:[strMusicTitle removeNull] forKey:@"vMusicName"];
            [dictParams setObject:[strMusicTitle2 removeNull] forKey:@"vMusicName2"];
        }
        else if (isLocationPostingView && [strPostSuccessful isEqualToString:@"PostOnly"])
        {
            [dictWS setObject:strPOST forKey:@"POSTURL"];
            
            [dictParams setObject:@"location" forKey:@"vType_of_content"];
            [dictParams setObject:([[locationdata objectForKey:@"location"] objectForKey:@"lat"])?[[locationdata objectForKey:@"location"] objectForKey:@"lat"]:@"" forKey:@"dcLatitude"];
            [dictParams setObject:([[locationdata objectForKey:@"location"] objectForKey:@"lng"])?[[locationdata objectForKey:@"location"] objectForKey:@"lng"]:@"" forKey:@"dcLongitude"];
        }
        else if(isYouTubePostingView && [strPostSuccessful isEqualToString:@"PostOnly"])
        {
            [dictWS setObject:kYouTubeURL forKey:@"POSTURL"];
            
            [dictParams setObject:@"video" forKey:@"vType_of_content"];
            [dictParams setObject:[[[dictYouTube objectForKey:@"entry"] objectForKey:@"title"] objectForKey:@"$t"] forKey:@"vTitle"];
            [dictParams setObject:[dictYouTube objectForKey:@"YouTubeId"] forKey:@"video_url"];
        }
        else if([strPostSuccessful isEqualToString:@"PostOnly"])
        {
            if ([strPostText length]==0)
            {
                txtViewPost.text=@"";
                DisplayAlert(@"Please enter text.");
                return;
            }
            
            [dictWS setObject:strPOST forKey:@"POSTURL"];
            [dictParams setObject:@"activity" forKey:@"vType_of_content"];
        }
        else if ([strPostSuccessful isEqualToString:@"PostImage"])
        {
            [dictWS setObject:strPostPhoto forKey:@"POSTURL"];
            
            NSData *data = UIImagePNGRepresentation(imgToPost);
            NSString *strFileName=[NSString stringWithFormat:@"%@.png",strUniqueId];

            if ([[MyAppManager sharedManager] writeDataToFileName:strFileName andData:data toDirectory:kTempUploaderDirectory])
            {
                [dictWS setObject:[NSString stringWithFormat:@"%f",imgToPost.size.width] forKey:@"imageWidth"];
                [dictWS setObject:[NSString stringWithFormat:@"%f",imgToPost.size.height] forKey:@"imageHeight"];
                
                NSString *dirPath = [[[MyAppManager sharedManager] documentsDirectory] stringByAppendingPathComponent:kTempUploaderDirectory];
                NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,strFileName];
                [dictWS setObject:filePath forKey:@"filePath"];
                [dictWS setObject:strFileName forKey:@"fileName"];
            }
            
            [dictParams setObject:@"image" forKey:@"vType_of_content"];
            

            /*
            [dictWS setObject:strMusicPOST forKey:@"POSTURL"];

            NSData *data= UIImagePNGRepresentation(imgToPost);
            NSString *strFileName=[NSString stringWithFormat:@"%@.png",strUniqueId];
            
            if ([[MyAppManager sharedManager] writeDataToFileName:strFileName andData:data toDirectory:kTempUploaderDirectory])
            {
                NSString *dirPath = [[[MyAppManager sharedManager] documentsDirectory] stringByAppendingPathComponent:kTempUploaderDirectory];
                NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,strFileName];
                [dictWS setObject:filePath forKey:@"filePath"];
                [dictWS setObject:strFileName forKey:@"fileName"];
            }
            
            NSString *strAlbumName=[NSString stringWithFormat:@"Zilla Ghaziyabad-%@",strUniqueId];
            NSString *strSingersName=[NSString stringWithFormat:@"Sunidhi Chauhan"];
            NSString *strMusicTitle=[NSString stringWithFormat:@"Muzik titllle-%@",strUniqueId];
            NSString *strMusicTitle2=[NSString stringWithFormat:@"%@",([[strAlbumName removeNull]length]!=0)?strAlbumName:strSingersName];
            
            [dictParams setObject:@"music" forKey:@"vType_of_content"];
            [dictParams setObject:[strMusicTitle removeNull] forKey:@"vMusicName"];
            [dictParams setObject:[strMusicTitle2 removeNull] forKey:@"vMusicName2"];
             */
            
        }
        else if ([strPostSuccessful isEqualToString:@"PostVideo"])
        {
            
            [dictWS setObject:kYouTubeURL forKey:@"POSTURL"];
            
            NSData *postVideoData = [NSData dataWithContentsOfURL:videoURL];
            NSString *strFileName=[NSString stringWithFormat:@"%@.mp4",strUniqueId];
            
            if ([[MyAppManager sharedManager] writeDataToFileName:strFileName andData:postVideoData toDirectory:kTempUploaderDirectory])
            {
                NSString *dirPath = [[[MyAppManager sharedManager] documentsDirectory] stringByAppendingPathComponent:kTempUploaderDirectory];
                NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,strFileName];
                [dictWS setObject:filePath forKey:@"filePath"];
                [dictWS setObject:strFileName forKey:@"fileName"];
            }
            
            [dictParams setObject:@"video" forKey:@"vType_of_content"];
            [dictParams setObject:@"Video" forKey:@"vTitle"];
        }
        
        [dictWS setObject:dictParams forKey:@"params"];
        
        NSString *dirPath = [[[MyAppManager sharedManager] documentsDirectory] stringByAppendingPathComponent:kTempUploaderDirectory];
        //NSString *strUserId =[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"]];
        NSString *filePath = [NSString stringWithFormat:@"%@/bgpost_%@.plist",dirPath,strUserId];
        NSMutableArray *arrBGPosts;
        
        if ([[[MyAppManager sharedManager] fileManager] fileExistsAtPath:filePath])
        {
            arrBGPosts=[[NSMutableArray alloc]initWithContentsOfFile:filePath];
            [arrBGPosts insertObject:dictWS atIndex:0];
        }
        else
        {
            arrBGPosts=[[NSMutableArray alloc]initWithObjects:dictWS, nil];
        }
        
        [arrBGPosts writeToFile:filePath atomically:YES];
        
        AddViewFlag = 50;;
        
        [[MyAppManager sharedManager]startBackGroundUpload];
        
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
}
-(void)postshared:(NSObject *)sender
{
    if (sender!=nil)
    {
        NSMutableDictionary *responseDict=(NSMutableDictionary *)(sender);
        
        NSString *strMSG =[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"MESSAGE"]];
        if ([strMSG isEqualToString:@"SUCCESS"])
        {
            strPostSuccessful = @"";
            AddViewFlag = 50;
            
            [[NSUserDefaults standardUserDefaults] setObject:[responseDict valueForKey:@"Post_Info"] forKey:@"Post_Info"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                shouldLoadUpdates=NO;
                [self.navigationController dismissModalViewControllerAnimated:NO];
            });
        }
        else
        {
            DisplayAlertWithTitle(@"Note", strMSG);
            return;
        }
    }
    else
    {
    }
}
-(void)postsharingfailed:(id)sender
{

}
-(IBAction)btnBackClicked:(id)sender
{
    AddViewFlag = 50;;
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark - IAMATWITH METHODS
-(IBAction)WithCliked:(id)sender
{
    IamWithViewController *obj=[[IamWithViewController alloc]initWithNibName:@"IamWithViewController" bundle:nil];
    obj.arrsuvifriends=[[NSMutableArray alloc]initWithArray:arrfriends];
    obj.arraddressbookcontacts=[[NSMutableArray alloc]initWithArray:arrcontacts];
    [self.navigationController pushViewController:obj animated:YES];
}
-(IBAction)AtCliked:(id)sender
{
    if ([locationdata objectForKey:@"name"])
    {
        [txtViewPost resignFirstResponder];
        UIActionSheet *actionsheet=[[UIActionSheet alloc]initWithTitle:@"I am at..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Remove",@"Replace", nil];
        actionsheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;
        [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    else
    {
        IamAtViewController *obj=[[IamAtViewController alloc]init];
        [self.navigationController pushViewController:obj animated:YES];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [txtViewPost becomeFirstResponder];
    switch (buttonIndex) {
        case 0:
        {
            [locationdata removeAllObjects];
            issharedonfoursquare=NO;
            [self updatesocialbuttons];
        }
            break;
        case 1:
        {
            IamAtViewController *obj=[[IamAtViewController alloc]init];
            [self.navigationController pushViewController:obj animated:YES];
        }
            break;
            
        default:
            break;
    }
}
-(NSMutableArray *)arrFinalName
{
    NSMutableArray *arrName = [[NSMutableArray alloc]init];
    for (int i=0; i<[arrcontacts count]; i++)
    {
        if ([[arrcontacts objectAtIndex:i] objectForKey:@"isselected"])
        {
            if ([[[arrcontacts objectAtIndex:i] objectForKey:@"isselected"] intValue]==1
                &&[[[arrcontacts objectAtIndex:i] objectForKey:@"FULL_NAME"] length]!=0)
            {
                [arrName addObject:[[arrcontacts objectAtIndex:i] objectForKey:@"FULL_NAME"]];
            }
        }
    }
    
    for (int i=0; i<[arrfriends count]; i++)
    {
        if ([[arrfriends objectAtIndex:i] objectForKey:@"isselected"])
        {
            if ([[[arrfriends objectAtIndex:i] objectForKey:@"isselected"] intValue]==1
                &&[[[arrfriends objectAtIndex:i] objectForKey:@"FULL_NAME"] length]!=0)
            {
                [arrName addObject:[[arrfriends objectAtIndex:i] objectForKey:@"FULL_NAME"]];
            }
            
        }
    }
    
    return arrName;
}
-(NSMutableArray *)arrEmailFinal
{
    NSMutableArray *arrEmail = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[arrcontacts count]; i++) {
        if ([[arrcontacts objectAtIndex:i] objectForKey:@"isselected"]) {
            if ([[[arrcontacts objectAtIndex:i] objectForKey:@"isselected"] intValue]==1
                &&[[[arrcontacts objectAtIndex:i] objectForKey:@"email"] length]!=0)
            {
                [arrEmail addObject:[[arrcontacts objectAtIndex:i] objectForKey:@"email"]];
            }
        }
    }
    
    for (int i=0; i<[arrfriends count]; i++)
    {
        if ([[arrfriends objectAtIndex:i] objectForKey:@"isselected"])
        {
            if ([[[arrfriends objectAtIndex:i] objectForKey:@"isselected"] intValue]==1 &&[[[arrfriends objectAtIndex:i] objectForKey:@"admin_email"] length]!=0 )
            {
                [arrEmail addObject:[[arrfriends objectAtIndex:i] objectForKey:@"admin_email"]];
            }
        }
    }
    return arrEmail;
}
-(void)updateiamwithlabel:(NSNotification *)notification
{
    [arrfriends removeAllObjects];
    [arrcontacts removeAllObjects];
    [arrfriends addObjectsFromArray:[[notification userInfo] objectForKey:@"friendsarray"]];
    [arrcontacts addObjectsFromArray:[[notification userInfo] objectForKey:@"contactsarray"]];
}
-(void)updateiamatlabel:(NSNotification *)notification
{
    [locationdata removeAllObjects];
    [locationdata addEntriesFromDictionary:[[notification userInfo] objectForKey:@"locationdata"]];
}

#pragma mark - SOCIAL METHODS -

-(IBAction)btnfacebookCliked:(id)sender
{
    NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
    if ([[socialdict objectForKey:@"facebook"] isEqualToString:@"Unauthenticate"]) 
    {
        [txtViewPost resignFirstResponder];
        if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
        {
            DisplayNoInternate;
            return;
        }
        else
        {
            [self btnAuthoriseFacebookClicked];
        }
    }
    else
    {
        issharedonfb=!issharedonfb;
        [self updatesocialbuttons];
    }
}
-(IBAction)btntwitterCliked:(id)sender
{
    NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
    if ([[socialdict objectForKey:@"twitter"] isEqualToString:@"Unauthenticate"])
    {
        [txtViewPost resignFirstResponder];
        if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
        {
            DisplayNoInternate;
            return;
        }
        else
        {
            [self btnAuthoriseTwitterClicked];
        }
    }
    else
    {
        issharedontwitter=!issharedontwitter;
        [self updatesocialbuttons];
    }
}
-(IBAction)btnfoursquareCliked:(id)sender
{
    NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
    
    if ([[socialdict objectForKey:@"foursquare"] isEqualToString:@"Unauthenticate"])
    {
        [txtViewPost resignFirstResponder];
        if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
        {
            DisplayNoInternate;
            return;
        }
        else
        {
            [self btnAuthoriseFoursquareClicked];
        }
    }
    else
    {
        if (issharedonfoursquare)
        {
            issharedonfoursquare=!issharedonfoursquare;
            [self updatesocialbuttons];
        }
        else
        {
            if ([locationdata objectForKey:@"name"])
            {
                issharedonfoursquare=!issharedonfoursquare;
                [self updatesocialbuttons];
            }
            else
            {
                DisplayAlert(@"Please choose location to share on foursquare.");
            }
        }
    }
}
-(void)updatesocialbuttons
{
    [btnfacebook setImage:[UIImage imageNamed:[NSString stringWithFormat:@"facebook%@_thumb.png",(issharedonfb)?@"":@"db"]] forState:UIControlStateNormal];
    [btntwitter setImage:[UIImage imageNamed:[NSString stringWithFormat:@"twitter%@_thumb.png",(issharedontwitter)?@"":@"db"]] forState:UIControlStateNormal];
    [btnfoursquare setImage:[UIImage imageNamed:[NSString stringWithFormat:@"foursquare%@_thumb.png",(issharedonfoursquare)?@"":@"db"]] forState:UIControlStateNormal];
}

#pragma mark - FACEBOOK
-(void)btnAuthoriseFacebookClicked
{
    [AppDelegate sharedInstance].facebook = [[Facebook alloc] initWithAppId:kFacebookApp_ID andDelegate:self];
    
    if (![[AppDelegate sharedInstance].facebook isSessionValid]) {
        NSArray *arrPermissions=[[NSArray alloc]initWithObjects:@"publish_stream",@"offline_access",@"user_checkins",@"read_stream",@"email",@"publish_checkins",@"user_photos",@"user_videos",@"friends_checkins",@"publish_actions", nil];
        [[AppDelegate sharedInstance].facebook authorize:arrPermissions];
    }
    else{
        [self fbDidLogin];
    }

//    self.fbGraph = [[FbGraph alloc] initWithFbClientID:kFacebookApp_ID];
//    if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0) )
//    {
//        [fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback)
//                             andExtendedPermissions:kFacebookPermissions];
//    }
//    else
//    {
//        [self performSelector:@selector(fbGraphCallback) withObject:nil afterDelay:0.000000000001];
//    }
}
-(void)fbGraphCallback
{
	if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0) )
    {
        [fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback)
							 andExtendedPermissions:kFacebookPermissions];
	}
    else
    {
        [fbGraph fbcancelcalled];
        
        NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
        [socialdict setObject:fbGraph.accessToken forKey:@"facebook_token"];
        [socialdict setObject:@"Authenticate" forKey:@"facebook"];
        [[NSUserDefaults standardUserDefaults]setObject:socialdict forKey:@"USER_DETAIL"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        issharedonfb=YES;
        [self updatesocialbuttons];
        
        [self performSelectorInBackground:@selector(updatefbcredentials) withObject:nil];
	}
}

- (void)fbDidLogin {
    
//    NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
//    [socialdict setObject:[[AppDelegate sharedInstance].facebook accessToken] forKey:@"facebook_token"];
//    [socialdict setObject:@"Authenticate" forKey:@"facebook"];
//    [[NSUserDefaults standardUserDefaults]setObject:socialdict forKey:@"USER_DETAIL"];
//    //    [[NSUserDefaults standardUserDefaults] setObject:[[AppDelegate sharedInstance].facebook accessToken] forKey:@"FBAccessTokenKey"];
//    //    [[NSUserDefaults standardUserDefaults] setObject:[[AppDelegate sharedInstance].facebook expirationDate] forKey:@"FBExpirationDateKey"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    NSMutableDictionary *socialdict=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DETAIL"]];
    [socialdict setObject:[[AppDelegate sharedInstance].facebook accessToken] forKey:@"facebook_token"];
    [socialdict setObject:@"Authenticate" forKey:@"facebook"];
    [[NSUserDefaults standardUserDefaults]setObject:socialdict forKey:@"USER_DETAIL"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    issharedonfb=YES;
    [self updatesocialbuttons];
    
    [self performSelectorInBackground:@selector(updatefbcredentials) withObject:nil];
}

-(void)updatefbcredentials
{
    NSString  *urlstring1 = [NSString stringWithFormat:@"%@%@",kAuthoriseUnauthoriseSocialNw,[NSString stringWithFormat:@"&func=auth_unauthFacebook&userID=%@&facebook_token=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],fbGraph.accessToken]];
    
    NSURL *urlTwiter = [NSURL URLWithString:[urlstring1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString * jsonRes1 = [NSString stringWithContentsOfURL:urlTwiter encoding:NSUTF8StringEncoding error:nil];
    if (jsonRes1) {
        /*
         NSError *error;
         NSData *storesData = [jsonRes1 dataUsingEncoding:NSUTF8StringEncoding];
         NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:storesData options:NSJSONWritingPrettyPrinted error:&error];
         */
    }
}

#pragma mark - OAUTH
-(void) tokenRequestDidStart:(TwitterLoginPopup *)twitterLogin
{
    [loginPopup startanimator];
}
-(void) tokenRequestDidSucceed:(TwitterLoginPopup *)twitterLogin {
    [loginPopup stopanimator];
}
-(void) tokenRequestDidFail:(TwitterLoginPopup *)twitterLogin {
    [loginPopup stopanimator];
}
-(void) authorizationRequestDidStart:(TwitterLoginPopup *)twitterLogin {
    [loginPopup startanimator];
}
-(void) authorizationRequestDidSucceed:(TwitterLoginPopup *)twitterLogin {
    [loginPopup stopanimator];
}
-(void) authorizationRequestDidFail:(TwitterLoginPopup *)twitterLogin {
    [loginPopup stopanimator];
}
-(void) presentLoginWithFlowType:(TwitterLoginFlowType)flowType {
    
    if (loginPopup) {
        loginPopup = nil;
    }
    
    if (!loginPopup)
    {
        loginPopup = [[CustomLoginPopup alloc] initWithNibName:@"TwitterLoginCallbackFlow" bundle:nil];
        loginPopup.oAuthCallbackUrl = OAUTH_CALLBACK_URL;
        loginPopup.flowType = flowType;
        loginPopup.socialnetworkType=SocialNetworkTwitter;
        loginPopup.oAuth = oAuthTwitter;
        loginPopup.delegate = self;
        loginPopup.uiDelegate = self;
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginPopup];
[nav.navigationBar setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bgnavbar%@",([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)?@"soc":@""]] forBarMetrics:UIBarMetricsDefault];
    [self presentModalViewController:nav animated:YES];
}
-(void)handleOAuthVerifier:(NSString *)oauth_verifier
{
    [loginPopup authorizeOAuthVerifier:oauth_verifier];
}
-(void)oAuthLoginPopupDidCancel:(UIViewController *)popup
{
    [self dismissModalViewControllerAnimated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (socialnwtype==1)
    {
        loginPopup = nil;
    }
    else if(socialnwtype==3)
    {
        loginPopupFSQ = nil;
    }
}
-(void)oAuthLoginPopupDidAuthorize:(UIViewController *)popup
{
    [self dismissModalViewControllerAnimated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (socialnwtype==1)
    {
        loginPopup = nil;
        [oAuthTwitter save];
        issharedontwitter=YES;
        [self resetUi];
    }
    else if(socialnwtype==3)
    {
        loginPopupFSQ = nil;
        [oAuth4sq save];
        issharedonfoursquare=YES;
        [self resetUi];
    }
}
-(void)resetUi
{
    [self updatesocialbuttons];
}
-(void)oauth_verifier_received:(NSNotification *)notification
{
    NSString *stroauth_verifier;
    if ([[notification userInfo] objectForKey:@"oauth_verifier"])
    {
        stroauth_verifier=[NSString stringWithFormat:@"%@",[[notification userInfo] objectForKey:@"oauth_verifier"]];
    }
    
    [self handleOAuthVerifier:stroauth_verifier];
}


#pragma mark - TWITTER
-(void)btnAuthoriseTwitterClicked
{
    if (!oAuthTwitter)
    {
        oAuthTwitter = [[OAuthTwitter alloc] initWithConsumerKey:OAUTH_TWITTER_CONSUMER_KEY andConsumerSecret:OAUTH_TWITTER_CONSUMER_SECRET];
        oAuthTwitter.socialnwtype=1;
        [oAuthTwitter load];
    }
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"twitter"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
    socialnwtype=1;
    [self presentLoginWithFlowType:TwitterLoginCallbackFlow];
}


#pragma mark - FOURSQUARE
-(void)btnAuthoriseFoursquareClicked
{
    if (!oAuth4sq) {
        oAuth4sq = [[OAuth alloc] initWithConsumerKey:OAUTH_FOURSQUARE_CONSUMER_KEY andConsumerSecret:OAUTH_FOURSQUARE_CONSUMER_SECRET];
        oAuth4sq.save_prefix = @"PlainOAuth4sq";
        [oAuth4sq load];
    }
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"foursquare"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
    socialnwtype=3;
    if (loginPopupFSQ) {
        loginPopupFSQ = nil;
    }
    
    loginPopupFSQ = [[FoursquareLoginPopup alloc] init];
    loginPopupFSQ.oAuth = oAuth4sq;
    loginPopupFSQ.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginPopupFSQ];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bgnavbar%@",([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)?@"soc":@""]] forBarMetrics:UIBarMetricsDefault];
    [self presentModalViewController:nav animated:YES];
}

#pragma mark - Video Post

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    lblPostTitle.alpha=0.0;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    lblPostTitle.alpha=(textView.text.length==0)?1.0:0.0;
}

#pragma mark - Extra Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_OAUTH_VERIFY_RECEIVED object:nil];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL)shouldAutorotate
{
    return NO;
}

@end
