//
//  ChatViewController.m
//  ChatPRJ
//
//  Created by Vijay on 7/22/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "ChatViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "NSString+Utilities.h"
#import "UIImage+Utilities.h"
#import "HPGrowingTextView.h"
#import "WebViewPController.h"
#import "ImagePreviewController.h"
#import "PhotoReviewViewController.h"
#import "GlobalVariables.h"
#import "PullToRefreshView.h"

@interface ChatViewController () <HPGrowingTextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIBubbleTableViewDataSource,OHAttributedLabelDelegate,PullToRefreshViewDelegate>
{
    IBOutlet UIBubbleTableView *tblChat;
    NSMutableArray *arrChatData;
    NSMutableArray *arrChatJSON;
    UIView *containerView;
    HPGrowingTextView *textView;
    UIButton *btnCamera;
    UIButton *btnSend;
    IBOutlet UIView *viewPopUp;
    IBOutlet UIView *viewTBLFooter;
    IBOutlet UIButton *btnSettings;
    BOOL isPopOverVisible;
    BOOL isImageFromCamera;
    PullToRefreshView *pull;
    float lastsynctimestamp;
    float latestfeedtime;
    NSMutableArray *arrLoadOldChats;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UILabel *lblTyping;
}

@property (nonatomic,strong) UIImagePickerController *imgPicker;

@end

@implementation ChatViewController

@synthesize imgPicker,_dictGroupInfo,dictGroupSettings;
@synthesize arrOnetoOneChat;
@synthesize strTheUserId;
@synthesize strGroupId;
@synthesize strGroupOrPersonName,isFlag;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* This webservice will return you latest 25 record in assending order */
    
    
    if (isGroupChat) {
        [activityIndicator startAnimating];
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strGroupId,group_id,strUserId,@"user_id",nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[GET_ALL_OLD_CHATS_WITHOUT_TIMESTAMP stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(OldChatLoading:) withfailureHandler:@selector(failToloadOldChat:) withCallBackObject:self];
        [obj startRequest];
    }else{
        
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strTheUserId,SELF_ID_KEY,strUserId,FRIEND_ID_KEY,nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[GET_ONE_to_ONE_CHAT stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(loadOldChat:) withfailureHandler:@selector(failToloadOldChat:) withCallBackObject:self];
        [obj startRequest];
        
        
        
    }
    
    btnSettings.hidden=([strUserId isEqualToString:[[dictGroupSettings objectForKey:@"group_admin_id"] removeNull]])?NO:YES;
    if (!isGroupChat) {
        btnSettings.hidden=YES;
    }
    
    arrChatData = [[NSMutableArray alloc] init];
    arrChatJSON = [[NSMutableArray alloc] init];

    pull=[[PullToRefreshView alloc] initWithScrollView:(UIScrollView *)tblChat];
    [pull setDelegate:self];
    [tblChat addSubview:pull];
    [tblChat reloadData];
    
    /* Recived Chat */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatloaded:) name:@"MSG_RECEIVED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNOTIFICATIONOneToOneChat:) name:@"NOTI_RECEIVED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(typingLblShow:) name:@"TYPINGSHOW" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(typingLblHide:) name:@"TYPINGHIDE" object:nil];
    //return;
    [self performSelector:@selector(addchattable)];
    
    arrOnetoOneChat = [[NSMutableArray alloc] init];
    
    if (isGroupChat) {
        
        lblTitleMenu.text = strGroupOrPersonName;
    }else{
        
        lblTitleMenu.text = strGroupOrPersonName;
    }
}


-(void)loadOldChat:(id)sender{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    arrOnetoOneChat = [[NSMutableArray alloc] init];
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [arrOnetoOneChat addObjectsFromArray:[dictResponse objectForKey:@"message"]];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0)
        {
            //kGRAlert([strErrorMessage removeNull])
        }
    }
    if (!ISFirstTimeInChatView && isGroupChat) {
        
        
    }else{
        [self showOneToOneChat:arrOnetoOneChat];
    }
    
}
-(void)failToloadOldChat:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        //kGRAlert([strErrorMessage removeNull])
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (!isGroupChat)
//    {
//        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//        BOOL isPrivateMessageOff=([[dictUserInfo objectForKey:@"private_message_notification"] integerValue])?NO:YES;
//        BOOL isPushNotificationOff=(types == UIRemoteNotificationTypeNone)?YES:NO;
//        
//        if (isPushNotificationOff && isPrivateMessageOff)
//        {
//            kGRAlert(@"Please switch ON notifications from your myU app settings and your device settings to enjoy private messaging!!!");
//        }
//        else if(isPushNotificationOff)
//        {
//            kGRAlert(@"Please switch ON notifications from your iPhone settings to enjoy private messaging of myU!!!");
//        }
//        else if(isPrivateMessageOff)
//        {
//            kGRAlert(@"Please switch ON notifications from your myU app settings to enjoy private messaging!!!");
//        }
//    }
}

-(void)typingLblShow:(NSNotification *)notification
{
    NSLog(@"Hiiid %@",[[notification userInfo] objectForKey:@"from"]);

    if (!isGroupChat)
    {
        NSString *strTempUserId=[[[[notification userInfo] objectForKey:@"from"] componentsSeparatedByString:@"@"] objectAtIndex:0];

        if ([strTempUserId isEqualToString:strTheUserId])
        {
            lblTyping.hidden = NO;
        }
        else
        {
            NSLog(@"ott...");
        }
    }
}

-(void)typingLblHide:(NSNotification *)notification
{
    NSLog(@"Hiiid %@",[[notification userInfo] objectForKey:@"from"]);

    NSString *strTempUserId=[[[[notification userInfo] objectForKey:@"from"] componentsSeparatedByString:@"@"] objectAtIndex:0];

    if ([strTempUserId isEqualToString:strTheUserId])
    {
        lblTyping.hidden = YES;
    }
    else
    {
        NSLog(@"ott...yy");
    }
}

#pragma mark - GET OLD CHAT FIRST TIME
/* This webservice will return you latest 25 record in assending order */

-(void)OldChatLoading:(id)sender{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    
    [arrChatData removeAllObjects];
    arrChatData = nil;
    arrChatData = [[NSMutableArray alloc] init];
    [arrChatJSON removeAllObjects];
    arrChatJSON = nil;
    arrChatJSON = [[NSMutableArray alloc] init];
    
    if ([arrLoadOldChats count]>0) {
        [arrLoadOldChats removeAllObjects];
        arrLoadOldChats = nil;
    }
    arrLoadOldChats = [[NSMutableArray alloc] init];
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        arrLoadOldChats = [dictResponse valueForKey:@"chat_arr"];
        for (int i = 0; i<[arrLoadOldChats count]; i++) {
            NSDictionary *dicInfo = [NSDictionary dictionaryWithObjectsAndKeys:[[arrLoadOldChats objectAtIndex:i] valueForKey:@"post_content"],@"XMPPMessage",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"postuser_id"],@"XMPPStream",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"postuser_profilepic"],@"postuser_profilepic",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"post_timestamp"],@"post_timestamp",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"postuser_id"],@"postuser_id",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"postuser_name"],@"postuser_name",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"post_type"],@"post_type",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"post_imageurl"],@"posted_image",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"post_image_height"],@"post_image_height",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"post_image_width"],@"post_image_width",nil];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"MSG_RECEIVED" object:nil userInfo:dicInfo];
        }
        [activityIndicator stopAnimating];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
        [activityIndicator stopAnimating];
    }
    
    
}
-(void)failToloadUsers:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
    [activityIndicator stopAnimating];
}
/**/



-(void)showOneToOneChat:(id)sender{
    
    for (int i =0; i<[arrOnetoOneChat count]; i++) {
        NSString *body = [[arrOnetoOneChat objectAtIndex:i] valueForKey:@"message"];
        NSString *postuser_profilepic = [[arrOnetoOneChat objectAtIndex:i] valueForKey:@"user_thumbnail"];
        NSString *post_timestamp = [[arrOnetoOneChat objectAtIndex:i] valueForKey:@"timestamp"];
        NSString *postuser_id = [[arrOnetoOneChat objectAtIndex:i] valueForKey:@"user_id"];
        NSString *postuser_name = [[arrOnetoOneChat objectAtIndex:i] valueForKey:@"user_name"];
        NSString *post_type = @"text";
        
        NSDictionary *dicInfo = [NSDictionary dictionaryWithObjectsAndKeys:body,@"XMPPMessage",postuser_profilepic,@"postuser_profilepic",post_timestamp,@"post_timestamp",postuser_id,@"postuser_id",postuser_name,@"postuser_name",post_type,@"post_type",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MSG_RECEIVED" object:nil userInfo:dicInfo];
    }
    
}

-(void)showNOTIFICATIONOneToOneChat:(NSNotification *)sender{
    [arrOnetoOneChat removeAllObjects];
    arrOnetoOneChat = [[NSMutableArray alloc] initWithObjects:sender.userInfo, nil];
    for (int i =0; i<[arrOnetoOneChat count]; i++) {
        NSString *body = [[arrOnetoOneChat objectAtIndex:i] valueForKey:@"message"];
        NSString *postuser_profilepic = [[arrOnetoOneChat objectAtIndex:i] valueForKey:@"user_thumbnail"];
        NSString *post_timestamp = [[arrOnetoOneChat objectAtIndex:i] valueForKey:@"timestamp"];
        NSString *postuser_id = [[arrOnetoOneChat objectAtIndex:i] valueForKey:@"user_id"];
        NSString *postuser_name = [[arrOnetoOneChat objectAtIndex:i] valueForKey:@"user_name"];
        NSString *post_type = @"text";
        if (!postuser_profilepic) {
            postuser_profilepic = strProfilePicURLofFriend;
        }
        
        NSDictionary *dicInfo = [NSDictionary dictionaryWithObjectsAndKeys:body,@"XMPPMessage",postuser_profilepic,@"postuser_profilepic",post_timestamp,@"post_timestamp",postuser_id,@"postuser_id",postuser_name,@"postuser_name",post_type,@"post_type",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MSG_RECEIVED" object:nil userInfo:dicInfo];
    }
}

-(void)addchattable
{
    tblChat.bubbleDataSource = self;
 
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    tblChat.snapInterval =24.0*60.0*60.0;
    //tblChat.snapInterval =120.0;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    tblChat.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    tblChat.typingBubble = NSBubbleTypingTypeNobody;
    
    tblChat.tableFooterView=viewTBLFooter;
    
    [tblChat reloadData];
    
    [self addChatField];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignkboard)];
    tapGesture.numberOfTapsRequired=1;
    [tblChat addGestureRecognizer:tapGesture];
    
    CGPoint offset = CGPointMake(0.0,(tblChat.contentSize.height>tblChat.frame.size.height)?(tblChat.contentSize.height-tblChat.frame.size.height):0.0);
    [tblChat setContentOffset:offset animated:NO];
    
    [self performSelector:@selector(allocpicker) withObject:nil afterDelay:1.0];
}

#pragma mark - WS METHODS
-(void)loadchats
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strGroupId,@"group_id",nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kChatGetLatest stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(chatloaded:) withfailureHandler:@selector(chatloadfailed:) withCallBackObject:self];
    [obj startRequest];
}
-(void)chatloaded:(NSNotification *)sender
{
    if (isGroupChat)
    {
        NSDictionary *dictResponse = sender.userInfo;
        if (![dictResponse objectForKey:@"postuser_id"]) {
            return;
        }
        NSDictionary *dictUser =  [_dictGroupInfo valueForKey:[dictResponse objectForKey:@"postuser_id"]];
        BOOL isChatMine=([[[dictResponse objectForKey:@"postuser_id"] removeNull] isEqualToString:strUserId])?YES:NO;
        BOOL isImageCell=([[[dictResponse objectForKey:@"post_type"] removeNull] isEqualToString:@"image"])?YES:NO;
        
        if (isImageCell)
        {
            NSBubbleData *theBubble = [NSBubbleData dataWithImage:nil date:[NSDate dateWithTimeIntervalSinceNow:0] type:(isChatMine)?BubbleTypeMine:BubbleTypeSomeoneElse imglink:[[dictResponse objectForKey:@"posted_image"] removeNull] linkdelegate:self username:[[dictUser valueForKey:@"username"] removeNull] imagetag:[arrChatJSON count] imagesize:CGSizeMake([[[dictResponse objectForKey:@"post_image_width"] removeNull] floatValue], [[[dictResponse objectForKey:@"post_image_height"] removeNull] floatValue]) showAvtar:YES dateActual:[NSDate dateWithTimeIntervalSince1970:[[dictResponse objectForKey:@"post_timestamp"] floatValue]]];
            theBubble.avatar=[[dictUser objectForKey:@"profile_picture"] removeNull];
            [arrChatData addObject:theBubble];
            
            NSMutableDictionary *dictBubble=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[[dictResponse objectForKey:@"XMPPMessage"] removeNull],@"post_content",@"1",@"islocal",[dictResponse objectForKey:@"post_timestamp"],@"post_timestamp",[[dictResponse objectForKey:@"postuser_id"] removeNull],@"postuser_id",[[dictUser valueForKey:@"username"] removeNull],@"postuser_name",[[dictResponse objectForKey:@"postuser_profilepic"] removeNull],@"postuser_profilepic",[dictResponse objectForKey:@"post_image_height"],@"post_image_height",[dictResponse objectForKey:@"post_image_width"],@"post_image_width",[[dictResponse objectForKey:@"posted_image"] removeNull],@"post_imageurl",nil];
            [arrChatJSON addObject:dictBubble];
        }
        else
        {
//
            NSData *charlieSendData = [[[dictResponse objectForKey:@"XMPPMessage"] removeNull] dataUsingEncoding:NSUTF8StringEncoding];
            NSString *charlieSendString = [[NSString alloc] initWithData:charlieSendData encoding:NSNonLossyASCIIStringEncoding];
            NSBubbleData *theBubble = [NSBubbleData dataWithText:charlieSendString date:[NSDate dateWithTimeIntervalSinceNow:0] type:(isChatMine)?BubbleTypeMine:BubbleTypeSomeoneElse linkdelegate:self username:[[dictUser valueForKey:@"username"] removeNull] showAvtar:[self shouldShowAvtarImage:(isChatMine)?BubbleTypeMine:BubbleTypeSomeoneElse] dateActual:[NSDate dateWithTimeIntervalSince1970:[[dictResponse objectForKey:@"post_timestamp"] floatValue]]];
            theBubble.avatar=[[dictUser valueForKey:@"profile_picture"] removeNull];
            [arrChatData addObject:theBubble];
            
            NSMutableDictionary *dictBubble=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[[dictResponse objectForKey:@"XMPPMessage"] removeNull],@"post_content",@"0",@"islocal",[dictResponse objectForKey:@"post_timestamp"],@"post_timestamp",[[dictResponse objectForKey:@"postuser_id"] removeNull],@"postuser_id",[[dictUser valueForKey:@"username"] removeNull],@"postuser_name",[[dictResponse objectForKey:@"postuser_profilepic"] removeNull],@"postuser_profilepic",@"",@"post_image_height",@"",@"post_image_width",@"",@"post_imageurl",nil];
            [arrChatJSON addObject:dictBubble];
        }
        
        [tblChat reloadData];
        CGPoint offset = CGPointMake(0.0,(tblChat.contentSize.height>tblChat.frame.size.height)?(tblChat.contentSize.height-tblChat.frame.size.height):0.0);
        [tblChat setContentOffset:offset animated:NO];
        
    }else
    {
        NSDictionary *dictResponse = sender.userInfo;
        if (![dictResponse objectForKey:@"postuser_id"]) {
            return;
        }
        
        BOOL isChatMine=([[[dictResponse objectForKey:@"postuser_id"] removeNull] isEqualToString:strUserId])?YES:NO;
        
        if (!isChatMine && ![[[dictResponse objectForKey:@"postuser_id"] removeNull] isEqualToString:strTheUserId])
        {
            NSLog(@"Other user's chat found...");
            return;
        }
        
        if ([[dictResponse objectForKey:@"XMPPMessage"] removeNull]==nil) {
            return;
        }
        
        NSBubbleData *theBubble = [NSBubbleData dataWithText:[[dictResponse objectForKey:@"XMPPMessage"] removeNull] date:[NSDate dateWithTimeIntervalSince1970:[[[dictResponse objectForKey:@"post_timestamp"] removeNull] floatValue]] type:(isChatMine)?BubbleTypeMine:BubbleTypeSomeoneElse linkdelegate:self username:[[dictResponse valueForKey:@"postuser_name"] removeNull] showAvtar:[self shouldShowAvtarImage:(isChatMine)?BubbleTypeMine:BubbleTypeSomeoneElse] dateActual:[NSDate dateWithTimeIntervalSince1970:[[[dictResponse objectForKey:@"post_timestamp"] removeNull] floatValue]]];
        
        theBubble.avatar=[[dictResponse valueForKey:@"postuser_profilepic"] removeNull];
        [arrChatData addObject:theBubble];
        
        NSMutableDictionary *dictBubble=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[[dictResponse objectForKey:@"XMPPMessage"] removeNull],@"post_content",@"0",@"islocal",[[dictResponse objectForKey:@"post_timestamp"] removeNull],@"post_timestamp",[[dictResponse objectForKey:@"postuser_id"] removeNull],@"postuser_id",[[dictResponse valueForKey:@"postuser_name"] removeNull],@"postuser_name",[[dictResponse objectForKey:@"postuser_profilepic"] removeNull],@"postuser_profilepic",@"",@"post_image_height",@"",@"post_image_width",@"",@"post_imageurl",nil];
        [arrChatJSON addObject:dictBubble];
        
        [tblChat reloadData];
        CGPoint offset = CGPointMake(0.0,(tblChat.contentSize.height>tblChat.frame.size.height)?(tblChat.contentSize.height-tblChat.frame.size.height):0.0);
        [tblChat setContentOffset:offset animated:NO];
    }
    
}

-(void)chatloadfailed:(id)sender
{
    [self performSelector:@selector(refreshchats) withObject:nil afterDelay:20.0];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}
-(void)refreshchats
{
    NSString *strTimeStamp=[NSString stringWithFormat:@"%f",lastsynctimestamp];
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strGroupId,@"group_id",strTimeStamp,@"latest_timestamp",nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kChatRefresh stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(chatrefreshed:) withfailureHandler:@selector(chatrefreshfailed:) withCallBackObject:self];
    [obj startRequest];
}
-(void)chatrefreshed:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    
    
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        if ([[dictResponse objectForKey:@"chat_arr"] count]>0)
        {
            [arrChatData removeAllObjects];
            [arrChatJSON addObjectsFromArray:[dictResponse objectForKey:@"chat_arr"]];
            
            //[self refreshtable];
        }
        
        lastsynctimestamp=[[dictResponse objectForKey:@"current_timestamp"] floatValue];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
    
    [self performSelector:@selector(refreshchats) withObject:nil afterDelay:8.0];
}
-(void)chatrefreshfailed:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}
-(void)allocpicker
{
    imgPicker=[[UIImagePickerController alloc]init];
    imgPicker.delegate=self;
}
-(void)resignkboard
{
    [textView resignFirstResponder];
    [self disMissMenu];
}
-(IBAction)btnBackClicked:(id)sender
{
    if (isFlag)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyUpdateData object:nil];
    }
    
    if (isGroupChat)
    {
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strGroupId,group_id,strUserId,USER_ID,nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[POST_OLD_TIMESTAMP stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(postOldTimestamp:) withfailureHandler:@selector(FailtopostOldTimestamp:) withCallBackObject:self];
        [obj startRequest];
    }
    else
    {
        //&user_id=142&sender_id=143
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strTheUserId,@"sender_id",strUserId,@"user_id",nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kUpdateChatNotificationURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:nil withfailureHandler:nil withCallBackObject:self];
        [obj startRequest];
    }
    
   
    ISFirstTimeInChatView = NO;
    TotalNumbersOfChat = [arrChatData count]+2;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:^{}];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    shouldBackToChat=NO;
    if (shouldBackToRoot)
    {
        shouldBackToRoot=NO;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self dismissViewControllerAnimated:NO completion:^{}];
    }
    
    if (shouldUpdateGroupSettings)
    {
        shouldUpdateGroupSettings=NO;
        [dictGroupSettings removeAllObjects];
        [dictGroupSettings addEntriesFromDictionary:dictUpdatedGroupSettings];
        
        if (isGroupChat) {
            lblTitleMenu.text = [[dictGroupSettings objectForKey:@"group_name"] removeNull];
        }
    }
    [self performSelector:@selector(isChatFirstTime) withObject:nil afterDelay:3.0];
    
    
}

-(void)isChatFirstTime{
    
    ISFirstTimeInChatView = NO;
}

#pragma mark - Post Old time stamp 

-(void)postOldTimestamp:(id)sender{
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    arrLoadOldChats = [[NSMutableArray alloc] init];
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        NSLog(@"Sucsess");
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0)
        {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}

-(void)FailtopostOldTimestamp:(id)sender{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        //kGRAlert([strErrorMessage removeNull])
    }
}

-(void)btnImageZoomClicked:(id)sender
{
    BOOL isLocal=([[[[arrChatJSON objectAtIndex:[(UIButton *)sender tag]] objectForKey:@"islocal"]removeNull]length]==0)?NO:YES;
    ImagePreviewController *obj=[[ImagePreviewController alloc]initWithNibName:@"ImagePreviewController" bundle:nil];
    obj.strURL=(isLocal)?[[NSString alloc]initWithFormat:@"%@",[[[arrChatJSON objectAtIndex:[(UIButton *)sender tag]] objectForKey:@"post_imageurl"]removeNull]]:[[NSString alloc]initWithFormat:@"%@",[[[arrChatJSON objectAtIndex:[(UIButton *)sender tag]] objectForKey:@"post_imageurl"]removeNull]];
    //obj.imgPreview=(isLocal)?[[arrChatJSON objectAtIndex:[(UIButton *)sender tag]] objectForKey:@"post_image"]:nil;
    [self presentViewController:obj animated:YES completion:^{}];
}

-(void)lblChatTapped:(UITapGestureRecognizer *)sender
{
    NSLog(@"Hiiiii 2224");
}
-(void)lblChatPressed:(UILongPressGestureRecognizer *)sender
{
    NSLog(@"UIGestureRecognizer");
    
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"UIGestureRecognizerStateBegan");
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"UIGestureRecognizerStateEnded");
    }
    else if (sender.state == UIGestureRecognizerStateCancelled)
    {
        NSLog(@"UIGestureRecognizerStateCancelled");
    }
}

-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
    NSString *strURL=[NSString stringWithFormat:@"%@",linkInfo.URL];
    if ([[strURL removeNull] length]>0)
    {
        WebViewPController *obj=[[WebViewPController alloc]initWithNibName:@"WebViewPController" bundle:nil];
        obj.strLink=[strURL removeNull];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:obj animated:NO completion:^{}];
    }
    
    return NO;
}

#pragma mark - TABLEVIEW METHODS
- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [arrChatData count];
}
- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [arrChatData objectAtIndex:row];
}

#pragma mark - BUTTON METHODS
- (IBAction)btnSettingsClicked:(id)sender
{
    ChatSettingsViewController *obj=[[ChatSettingsViewController alloc]initWithNibName:@"ChatSettingsViewController" bundle:nil];
    obj.strGroupId = strGroupId;
    obj.dictGroupSettings=dictGroupSettings;
    obj.dictGroupUsers=_dictGroupInfo;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:obj animated:NO completion:^{}];
}

-(void)btnAddImageClicked:(id)sender
{

    if (isPopOverVisible)
    {
        [self disMissMenu];
    }
    else
    {
        CGRect rectPopUp;
        rectPopUp.origin.x=7.5;
        rectPopUp.origin.y=containerView.frame.origin.y+btnCamera.frame.origin.y-80.0;
        rectPopUp.size=CGSizeMake(30.0, 75.0);
        [self.view addSubview:viewPopUp];
        
        CGRect rectOrigin;
        rectOrigin.origin.x=btnCamera.frame.origin.x;
        rectOrigin.origin.y=containerView.frame.origin.y+btnCamera.frame.origin.y;
        rectOrigin.size=btnCamera.frame.size;
        viewPopUp.frame=rectOrigin;
        
        isPopOverVisible=YES;
        
        [UIView animateWithDuration:0.2 animations:^(void)
         {
             viewPopUp.alpha = 1.0f;
             viewPopUp.frame = rectPopUp;
         } completion:^(BOOL completed) {
             viewPopUp.hidden = NO;
         }];
    }
}
-(void)disMissMenu
{
    if (isPopOverVisible)
    {
        isPopOverVisible=NO;
        CGRect rectOrigin;
        rectOrigin.origin.x=btnCamera.frame.origin.x;
        rectOrigin.origin.y=containerView.frame.origin.y+btnCamera.frame.origin.y;
        rectOrigin.size=btnCamera.frame.size;
        
        [UIView animateWithDuration:0.2 animations:^(void)
         {
             viewPopUp.alpha = 0;
             viewPopUp.frame = rectOrigin;
         } completion:^(BOOL finished) {
             [viewPopUp removeFromSuperview];
         }];
    }
}

-(IBAction)btnAlbumClicked:(id)sender
{
    [self disMissMenu];
    
    if (!imgPicker) {
        [self allocpicker];
    }

    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgPicker animated:YES completion:^{}];
}

-(IBAction)btnCameraClicked:(id)sender
{
    [self disMissMenu];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [[[UIAlertView alloc]initWithTitle:nil message:@"This device doesn't support camera." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
    else
    {
        if (!imgPicker) {
            [self allocpicker];
        }
        
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imgPicker animated:YES completion:^{}];
    }
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
    {
        [picker dismissViewControllerAnimated:YES completion:^{
        [self performSelector:@selector(presentimagereview:) withObject:image afterDelay:0.5];
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imagechoosed:) name:@"ImagePicked" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imagecanceled:) name:@"ImageCanceled" object:nil];
        
    }
    else
    {
        [picker dismissViewControllerAnimated:YES completion:^{
             [self performSelector:@selector(presentimagereview:) withObject:image afterDelay:0.5];
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imagechoosed:) name:@"ImagePicked" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imagecanceled:) name:@"ImageCanceled" object:nil];
       
    }
}

-(void)presentimagereview:(id)sender
{
    PhotoReviewViewController *obj=[[PhotoReviewViewController alloc]initWithNibName:@"PhotoReviewViewController" bundle:nil];
    obj.imgPreview=(UIImage *)sender;
    [self presentViewController:obj animated:YES completion:^{}];
}
- (UIImage *)imageReduceSize:(CGSize)newSize :(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = newSize.width/newSize.height;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = newSize.height / actualHeight;
            actualWidth = imgRatio* actualWidth;
            actualHeight = newSize.height;
        }
        else{
            imgRatio = newSize.width / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = newSize.width;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

-(void)imagechoosed:(NSNotification *)notification
{
    
    UIImage *image=[notification.userInfo objectForKey:@"image"];
    image = [self imageReduceSize:[UIScreen mainScreen].bounds.size:image];
    NSData *dataF = UIImagePNGRepresentation(image);

    NSDictionary *dictData=[NSDictionary dictionaryWithObjectsAndKeys:dataF,@"file",nil];
    NSDictionary *dictParamerter = [NSDictionary dictionaryWithObjectsAndKeys:strGroupId,group_id,strUserId,USER_ID, nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[UPLOAD_CHAT_IMAGE stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictParamerter postData:dictData withsucessHandler:@selector(imageuploaded:) withfailureHandler:@selector(imageuploadfailed:) withCallBackObject:self];
    [[MyAppManager sharedManager] showLoader];
    [obj startRequest];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImagePicked" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImageCanceled" object:nil];
}


-(void)imageuploaded:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        NSString *str = [NSString stringWithFormat:@"%@%@",strGroupId,GROUP_CHAT_DOMAIN];
        NSString *strTimeStamp=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:@"nodata"];
        ISFirstTimeInChatView = NO;
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"groupchat"];
        [message addAttributeWithName:@"to" stringValue:str];
        [message addAttributeWithName:@"postuser_profilepic" stringValue:strUserProfilePic];
        [message addAttributeWithName:@"post_timestamp" stringValue:strTimeStamp];
        [message addAttributeWithName:@"postuser_id" stringValue:strUserId];
        [message addAttributeWithName:@"posted_image" stringValue:[dictResponse valueForKey:@"image_url"]];
        [message addAttributeWithName:@"postuser_name" stringValue:[[dictUserInfo objectForKey:@"name"] removeNull]];
        [message addAttributeWithName:@"post_type" stringValue:@"image"];
        [message addAttributeWithName:@"post_image_height" stringValue:[[dictResponse objectForKey:@"height"] removeNull]];
        [message addAttributeWithName:@"post_image_width" stringValue:[[dictResponse objectForKey:@"width"] removeNull]];
        [message addChild:body];
        [[[self appDelegate] xmppStream] sendElement:message];
        
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0)
        {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)imageuploadfailed:(id)sender
{
    [[MyAppManager sharedManager] hideLoader];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

-(void)imagecanceled:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImagePicked" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImageCanceled" object:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
}
-(void)btnSendClicked:(id)sender
{
    
    if ([[textView.text removeNull] length]>0)
    {
        if (isGroupChat) {
            tblChat.typingBubble = NSBubbleTypingTypeNobody;
            NSString *str = [NSString stringWithFormat:@"%@%@",strGroupId,GROUP_CHAT_DOMAIN];
            NSString *strTimeStamp=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
            NSData *charlieSendData = [textView.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
            NSString *charlieSendString = [[NSString alloc] initWithData:charlieSendData encoding:NSUTF8StringEncoding];
            [body setStringValue:charlieSendString];
            ISFirstTimeInChatView = NO;
            NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
            [message addAttributeWithName:@"type" stringValue:@"groupchat"];
            [message addAttributeWithName:@"to" stringValue:str];
            [message addAttributeWithName:@"post_type" stringValue:@"text"];
            [message addAttributeWithName:@"postuser_profilepic" stringValue:strUserProfilePic];
            [message addAttributeWithName:@"post_timestamp" stringValue:strTimeStamp];
            [message addAttributeWithName:@"postuser_id" stringValue:strUserId];
            [message addAttributeWithName:@"postuser_name" stringValue:[[dictUserInfo objectForKey:@"name"] removeNull]];
            [message addAttributeWithName:@"posted_image" stringValue:@"nodata"];
            [message addAttributeWithName:@"post_image_height" stringValue:@"nodata"];
            [message addAttributeWithName:@"post_image_width" stringValue:@"nodata"];
            [message addChild:body];
            [[[self appDelegate] xmppStream] sendElement:message];
            
            NSString *strTimeStamp2=[NSString stringWithFormat:@"%f",latestfeedtime];
            NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strGroupId,@"group_id",strUserId,@"user_id",strTimeStamp,@"post_temp_id",textView.text,@"chat_text",strTimeStamp2,@"post_latesttimestamp",nil];
            
            WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kChatAdd stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(chatsent:) withfailureHandler:@selector(chatnotsent:) withCallBackObject:self];
            [obj startRequest];
            
        }else{
            NSString *strTimeStamp=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            NSString *body = textView.text;
            NSString *postuser_profilepic = strUserProfilePic;
            NSString *post_timestamp = strTimeStamp;
            NSString *postuser_id = strUserId;
            NSString *postuser_name = [[dictUserInfo objectForKey:@"name"] removeNull];
            NSString *post_type = @"text";
            NSDictionary *dicInfo = [NSDictionary dictionaryWithObjectsAndKeys:body,@"XMPPMessage",postuser_profilepic,@"postuser_profilepic",post_timestamp,@"post_timestamp",postuser_id,@"postuser_id",postuser_name,@"postuser_name",post_type,@"post_type",nil];
           
            
            /**/
            tblChat.typingBubble = NSBubbleTypingTypeNobody;
            NSString *str = [NSString stringWithFormat:@"%@%@",strTheUserId,DOMAIN_NAME];
            NSString *strTimeStamp1=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            NSXMLElement *body1 = [NSXMLElement elementWithName:@"body"];
            NSData *charlieSendData = [textView.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
            NSString *charlieSendString = [[NSString alloc] initWithData:charlieSendData encoding:NSUTF8StringEncoding];
            [body1 setStringValue:charlieSendString];
            NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
            [message addAttributeWithName:@"type" stringValue:@"chat"];
            [message addAttributeWithName:@"to" stringValue:str];
            [message addAttributeWithName:@"post_type" stringValue:@"text"];
            [message addAttributeWithName:@"postuser_profilepic" stringValue:strUserProfilePic];
            [message addAttributeWithName:@"post_timestamp" stringValue:strTimeStamp1];
            [message addAttributeWithName:@"postuser_id" stringValue:strUserId];
            [message addAttributeWithName:@"postuser_name" stringValue:[[dictUserInfo objectForKey:@"name"] removeNull]];
            [message addAttributeWithName:@"posted_image" stringValue:@"nodata"];
            [message addAttributeWithName:@"post_image_height" stringValue:@"nodata"];
            [message addAttributeWithName:@"is_single_chat" stringValue:@"YES"];
            [message addAttributeWithName:@"post_image_width" stringValue:@"nodata"];
            [message addChild:body1];
            [[[self appDelegate] xmppStream] sendElement:message];
            
            /**/
            
            NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strTheUserId,RECIEVER_ID_KEY,strUserId,SELF_ID_KEY,textView.text,MESSAGE_KEY,nil];
            WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[SEND_ONE_TO_ONE_MES stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(chatSent:) withfailureHandler:@selector(failtoSendChat:) withCallBackObject:self];
            [obj startRequest];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"MSG_RECEIVED" object:nil userInfo:dicInfo];
            
        }
    }
    
    textView.text = @"";
    [textView resignFirstResponder];
}

-(void)chatSent:(id)sender{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        NSLog(@"SUCCESS");
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0)
        {
            kGRAlert([strErrorMessage removeNull])
        }
    }

    
}

-(void)failtoSendChat:(id)sender{
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

- (XMPPStream *)xmppStream {
	return [[self appDelegate] xmppStream];
}
- (AppDelegate *)appDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)refreshlastsynctime
{
    for (int i=0;i<[arrChatJSON count];i++)
    {
        NSDictionary *dictChat=[[NSDictionary alloc]initWithDictionary:[arrChatJSON objectAtIndex:i]];
        
        if (![dictChat objectForKey:@"islocal"])
        {
            if ([[dictChat objectForKey:@"post_timestamp"] floatValue] > latestfeedtime)
            {
                latestfeedtime=[[dictChat objectForKey:@"post_timestamp"] floatValue];
            }            
        }
    }
}
-(void)chatsent:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        NSLog(@"Success");
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)chatnotsent:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

-(BOOL)shouldShowAvtarImage:(NSBubbleType)bubbleType
{
    return YES;
    
    if ([arrChatData count]>0)
    {
        NSBubbleData *thebubbleData=(NSBubbleData *)[arrChatData lastObject];
        NSTimeInterval lasttimeinterval=[thebubbleData.date timeIntervalSinceReferenceDate];
        NSTimeInterval currenttimeinterval=[[NSDate date] timeIntervalSinceReferenceDate];
        if ((currenttimeinterval-lasttimeinterval)>30.0)
        {
            return YES;
        }
        else
        {
            if (thebubbleData.type==bubbleType)
            {
                return NO;
            }
            else
            {
                return YES;
            }
        }
    }
    else
    {
        return YES;
    }
}

#pragma mark - TEXTVIEW METHODS


-(void)addChatField
{
    
    
    if (isGroupChat) {
        containerView=[[UIView alloc] initWithFrame:CGRectMake(0.0,self.view.frame.size.height-40.0,320.0,40.0)];
        textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(40.0,3,210,40)];
        textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        textView.minNumberOfLines = 1;
        textView.maxNumberOfLines = 6;
        //textView.maxHeight = 200.0f;
        textView.returnKeyType = UIReturnKeyDefault;
        textView.font = [UIFont systemFontOfSize:15.0f];
        textView.delegate = self;
        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        textView.backgroundColor = [UIColor whiteColor];
        textView.placeholder = @"Add your chat here...";
        textView.animateHeightChange = YES;
        [self.view addSubview:containerView];
        
        UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
        UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
        entryImageView.frame = CGRectMake(40, 0, 218, 40);
        entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
        UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
        imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [containerView addSubview:imageView];
        [containerView addSubview:textView];
        [containerView addSubview:entryImageView];
        
        btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSend.frame = CGRectMake(containerView.frame.size.width - 60,6, 51, 30);
        btnSend.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [btnSend setTitle:@"" forState:UIControlStateNormal];
        [btnSend setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
        btnSend.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
        btnSend.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [btnSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnSend addTarget:self action:@selector(btnSendClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnSend setBackgroundImage:[UIImage imageNamed:@"btnSend.png"] forState:UIControlStateNormal];
        [btnSend setBackgroundImage:[UIImage imageNamed:@"btnSenddb.png"] forState:UIControlStateDisabled];
        btnSend.enabled=NO;
        [containerView addSubview:btnSend];
        
        btnCamera = [[UIButton alloc]init];
        btnCamera.frame = CGRectMake(6,6, 32, 30);
        btnCamera.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [btnCamera setTitle:@"" forState:UIControlStateNormal];
        [btnCamera setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
        btnCamera.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
        btnCamera.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [btnCamera setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnCamera addTarget:self action:@selector(btnAddImageClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnCamera setBackgroundImage:[UIImage imageNamed:@"btnchatimg.png"] forState:UIControlStateNormal];
//        if (!isGroupChat) {
//            btnCamera.hidden=YES;
//        }
        [containerView addSubview:btnCamera];
        
        containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }else{
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
        
        textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, 40)];
        textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        textView.minNumberOfLines = 1;
        textView.maxNumberOfLines = 6;
        // you can also set the maximum height in points with maxHeight
        // textView.maxHeight = 200.0f;
        textView.returnKeyType = UIReturnKeyGo; //just as an example
        textView.font = [UIFont systemFontOfSize:15.0f];
        textView.delegate = self;
        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        textView.backgroundColor = [UIColor whiteColor];
        textView.placeholder = @"Add your comment...";
        
        // textView.text = @"test\n\ntest";
        // textView.animateHeightChange = NO; //turns off animation
        
        [self.view addSubview:containerView];
        
        UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
        UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
        entryImageView.frame = CGRectMake(5, 0, 248, 40);
        entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
        UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
        imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [containerView addSubview:imageView];
        [containerView addSubview:textView];
        [containerView addSubview:entryImageView];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(containerView.frame.size.width - 60, 6, 51, 30);
        doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [doneBtn setTitle:@"" forState:UIControlStateNormal];
        
        [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
        doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
        doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(btnSendClicked:) forControlEvents:UIControlEventTouchUpInside];
        [doneBtn setBackgroundImage:[UIImage imageNamed:@"btnSend.png"] forState:UIControlStateNormal];
        [containerView addSubview:doneBtn];
        containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        if (isAppInGuestMode) {
            UIButton *btnGuestMode = [UIButton buttonWithType:UIButtonTypeCustom];
            btnGuestMode.frame = CGRectMake(0,0,320,40.0);
            [btnGuestMode addTarget:self action:@selector(alertIfGuestMode) forControlEvents:UIControlEventTouchUpInside];
            [containerView addSubview:btnGuestMode];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
}

-(void)alertIfGuestMode
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Guest Mode" message:kGuestPrompt delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign-Up", nil];
    alert.tag=24;
    [alert show];
}

-(void) keyboardWillShow:(NSNotification *)note
{
    [self isChatFirstTime];
    XMPPPresence *presence = [XMPPPresence presence];
    [presence addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@%@",strTheUserId,DOMAIN_NAME]];
    [presence addAttributeWithName:@"type" stringValue:@"available"];
    [presence addAttributeWithName:@"mes" stringValue:@"up"];
    [[[self appDelegate] xmppStream] sendElement:presence];
    
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	containerView.frame = containerFrame;
    tblChat.frame=CGRectMake(0.0, 44.0+iOS7, 320.0,376.0+iPhone5ExHeight-216.0);
    CGPoint offset = CGPointMake(0.0,(tblChat.contentSize.height>tblChat.frame.size.height)?(tblChat.contentSize.height-tblChat.frame.size.height):0.0);
    [tblChat setContentOffset:offset animated:NO];
    
    if (isPopOverVisible)
    {
        CGRect rectPopUp;
        rectPopUp.origin.x=7.5;
        rectPopUp.origin.y=containerView.frame.origin.y+btnCamera.frame.origin.y-80.0;
        rectPopUp.size=CGSizeMake(30.0, 75.0);
        viewPopUp.frame=rectPopUp;
    }
    
	[UIView commitAnimations];
}
-(void) keyboardWillHide:(NSNotification *)note
{
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	containerView.frame = containerFrame;
    tblChat.frame=CGRectMake(0.0, 44.0+iOS7, 320.0,376.0+iPhone5ExHeight);
    CGPoint offset = CGPointMake(0.0,(tblChat.contentSize.height>tblChat.frame.size.height)?(tblChat.contentSize.height-tblChat.frame.size.height):0.0);
    [tblChat setContentOffset:offset animated:NO];
    
    if (isPopOverVisible)
    {
        CGRect rectPopUp;
        rectPopUp.origin.x=7.5;
        rectPopUp.origin.y=containerView.frame.origin.y+btnCamera.frame.origin.y-80.0;
        rectPopUp.size=CGSizeMake(30.0, 75.0);
        viewPopUp.frame=rectPopUp;
    }
    
	[UIView commitAnimations];
}
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}

-(void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView{
    
    XMPPPresence *presence = [XMPPPresence presence];
    [presence addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@%@",strTheUserId,DOMAIN_NAME]];
    [presence addAttributeWithName:@"type" stringValue:@"available"];
    [presence addAttributeWithName:@"mes" stringValue:@"down"];
    [[[self appDelegate] xmppStream] sendElement:presence];
}

-(void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    btnSend.enabled=([[textView.text removeNull] length]>0)?YES:NO;
}

#pragma mark - EXTRA METHODS
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)viewDidUnload {
    btnSettings = nil;
    [super viewDidUnload];
}




/* GET ALL OLD CHAT */
#pragma mark - get old chat
-(void)getOldChatWithTimeStamp:(id)sender{
    
    NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:[[arrChatJSON objectAtIndex:0]valueForKey:@"post_timestamp"],@"oldest_timestamp",strGroupId,group_id,nil];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kChatViewMore stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(getallOldChat:) withfailureHandler:@selector(failTogetOldChat:) withCallBackObject:self];
    [obj startRequest];
}

-(void)getallOldChat:(id)sender{
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    arrLoadOldChats = [[NSMutableArray alloc] init];
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [arrChatData removeAllObjects];
        arrLoadOldChats = [dictResponse valueForKey:@"chat_arr"];
        for (int i = 0; i<[arrLoadOldChats count]; i++) {
            
            NSDictionary *dicInfo = [NSDictionary dictionaryWithObjectsAndKeys:[[arrLoadOldChats objectAtIndex:i] valueForKey:@"post_content"],@"XMPPMessage",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"postuser_id"],@"XMPPStream",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"postuser_profilepic"],@"postuser_profilepic",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"post_timestamp"],@"post_timestamp",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"postuser_id"],@"postuser_id",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"postuser_name"],@"postuser_name",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"post_type"],@"post_type",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"post_imageurl"],@"posted_image",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"post_image_height"],@"post_image_height",[[arrLoadOldChats objectAtIndex:i] valueForKey:@"post_image_width"],@"post_image_width",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MSG_RECEIVED" object:nil userInfo:dicInfo];
        }
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0)
        {
            kGRAlert([strErrorMessage removeNull])
        }
    }
    [pull setState:PullToRefreshViewStateNormal];
}

-(void)failTogetOldChat :(id)sender{

    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
    [pull setState:PullToRefreshViewStateNormal];
}

#pragma mark - PULL TO REFRESH
-(void)closePullToRefresh
{
    [pull setState:PullToRefreshViewStateNormal];
}
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view
{
    if (isGroupChat) {
        if ([arrChatData count]>0) {
            
            [self performSelector:@selector(getOldChatWithTimeStamp:) withObject:nil afterDelay:0.01];
        }else{
              [pull setState:PullToRefreshViewStateNormal];
        }
        
    }else{
        NSDictionary *dictPara=[NSDictionary dictionaryWithObjectsAndKeys:strTheUserId,SELF_ID_KEY,strUserId,FRIEND_ID_KEY,nil];
        WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[GET_ONE_to_ONE_CHAT stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(loadOldChatSingle:) withfailureHandler:@selector(failToloadOldChatSignle:) withCallBackObject:self];
        [obj startRequest];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (((scrollView.contentOffset.y+300)>(scrollView.contentSize.height-scrollView.frame.size.height)))
    {
//        [self viewmoreblogs];
    }
}



-(void)loadOldChatSingle:(id)sender{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    if (arrOnetoOneChat) {
        [arrOnetoOneChat removeAllObjects];
        arrOnetoOneChat = nil;
    }
    [arrChatData removeAllObjects];
    arrOnetoOneChat = [[NSMutableArray alloc] init];
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        [arrOnetoOneChat addObjectsFromArray:[dictResponse objectForKey:@"message"]];
        [self showOneToOneChat:arrOnetoOneChat];
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        if ([[strErrorMessage removeNull] length]>0)
        {
            //kGRAlert([strErrorMessage removeNull])
        }
    }
    [pull setState:PullToRefreshViewStateNormal];
}


-(void)failToloadOldChatSignle:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSLog(@"The Response is %@",dictResponse);
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
    [pull setState:PullToRefreshViewStateNormal];
}

-(void)dealloc{
    [tblChat removeObserver:pull forKeyPath:@"contentOffset"];
}

@end
