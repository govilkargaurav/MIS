//
//  AddCommentView.m
//  Suvi
//
//  Created by Vivek Rajput on 10/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddCommentView.h"
#import "AllFeedsCustomCell.h"
#import "Constants.h"
#import "MyAppManager.h"

@interface AddCommentView ()
{
    IBOutlet UIButton *btnComment;
    IBOutlet UIView *viewUpperBar;
}

@end

@implementation AddCommentView
@synthesize vType_of_post,iActivityID;
@synthesize dictAllData;
@synthesize arrContent,vijays;
#pragma mark - View Did Load

-(void)setVijays:(int)vijays
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    shouldLoadUpdates=NO;
    
    
    vijays=3;
    self.vijays=4;
    
    
    
    self.vijays=6;
    vijays=5;


    lblLikeCount.hidden = YES;
    lblDislikeCount.hidden = YES;
    lblCommentCount.hidden = YES;
    
    [self AddAutoExpandTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFullScreen:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoExitFullScreen:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgapp"]];
    
    action = @"";
    self.arrContent = [[NSMutableArray alloc]init];
    webData = [[NSMutableData alloc]init];
    
    Comment_Count = [[dictAllData valueForKey:@"Comment_counts"] intValue];
    
    [self ChangeLikeImageHeader:[lblLikeCount.text intValue]];
    [self ChangeDisLikeImageHeader:[lblDislikeCount.text intValue]];
    [self ChnageCommentImageHeader:[lblCommentCount.text intValue]];
    
    if (shouldOpenKeyBoardforComment)
    {
        shouldOpenKeyBoardforComment=NO;
        [tfautoExpandPost becomeFirstResponder];
        TblView.frame=CGRectMake(0,48.0+iOS7ExHeight,320,470+iPhone5ExHeight-50-53-216);
    }
    
    if ([[self.dictAllData valueForKey:@"canLike"] isEqualToString:@"No"])
    {
        btnLike.userInteractionEnabled=NO;
        [btnLike setImage:[UIImage imageNamed:@"imgbtnlike-h"] forState:UIControlStateNormal];
    }

    if ([[self.dictAllData valueForKey:@"canUnLike"] isEqualToString:@"No"])
    {
        btnUnLike.userInteractionEnabled=NO;
        [btnUnLike setImage:[UIImage imageNamed:@"imgbtndislike-h"] forState:UIControlStateNormal];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self _GetComment];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
-(void)loadHTML:(NSString *)strHTML
{
    NSString *embedHTML = @"<html><head><style type=\"text/css\">body {background-color: transparent;color: white;} </style></head><body style=\"margin:0\"> <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" width=\"310.0f\" height=\"310.0f\"></embed></body></html>";
    NSString* html = [NSString stringWithFormat:embedHTML,strHTML];
    [webVideo loadHTMLString:html baseURL:nil];
}
-(IBAction)Back:(id)sender
{
    AddViewFlag = 50;
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)PostCliked:(id)sender
{
    NSString *str = [tfautoExpandPost.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([str isEqualToString:@""])
    {
        DisplayAlertWithTitle(@"Note", @"Please Enter Text");
        return;
    }
    else
    {
        [self _AddComment];
    }
}
-(void)_AddComment
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else if([[tfautoExpandPost.text removeNull] isEqualToString:@""])
    {
        DisplayAlertWithTitle(APP_Name, @"Please, enter comment!");
        return;
    }
    else
    {
        action = @"_AddComment";
        [tfautoExpandPost resignFirstResponder];
        [[AppDelegate sharedInstance]showLoader];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
        
        //NSMutableData *postData = [NSMutableData data];
        
        NSMutableDictionary *dictPostParameters=[[NSMutableDictionary alloc]init];
        
        
        [dictPostParameters setObject:[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"] forKey:@"userID"];
        [dictPostParameters setObject:vType_of_post forKey:@"vType_of_post"];
        [dictPostParameters setObject:iActivityID forKey:@"iActivityID"];
        [dictPostParameters setObject:[tfautoExpandPost.text removeNull] forKey:@"bContent"];
        
        NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
        
        [postRequest setURL:[NSURL URLWithString:[NSString stringWithString:[strAddComment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
        [postRequest setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        NSMutableData  *body = [[NSMutableData alloc] init];
        
        [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        for (NSString *theKey in [dictPostParameters allKeys])
        {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",theKey] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n",[dictPostParameters objectForKey:theKey]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postRequest setHTTPBody:body];
        [postRequest setTimeoutInterval:kTimeOutInterval];

        
        connection = [NSURLConnection connectionWithRequest:postRequest delegate:self];
    }
}
-(void)_GetComment
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {        
        action = @"_GetComment";
        [[AppDelegate sharedInstance]showLoader];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
        
        NSMutableData *postData = [NSMutableData data];
        [postData appendData: [[[NSString stringWithFormat:@"userID=%@&iActivityID=%@&vType_of_content=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],iActivityID,vType_of_post]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:strGETAllCommentsWithAllData]];
        
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        [urlRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}
-(void)setZoomInEffect:(UIButton *)btn
{
    [btn setImage:[UIImage imageNamed:@"imgbtnlike-h"] forState:UIControlStateNormal];
    
    btn.transform = CGAffineTransformMakeScale(1.5,1.5);
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [btn.layer addAnimation:transition forKey:nil];
}
-(void)setZoomOutEffect:(UIButton *)btn
{
    btn.transform = CGAffineTransformMakeScale(1,1);
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [btn.layer addAnimation:transition forKey:nil];
    
    [btn setImage:[UIImage imageNamed:@"imgbtnlike"] forState:UIControlStateNormal];
}

-(void)setZoomInEffect2:(UIButton *)btn
{
    [btn setImage:[UIImage imageNamed:@"imgbtndislike-h"] forState:UIControlStateNormal];
    
    btn.transform = CGAffineTransformMakeScale(1.5,1.5);
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [btn.layer addAnimation:transition forKey:nil];
}
-(void)setZoomOutEffect2:(UIButton *)btn
{
    btn.transform = CGAffineTransformMakeScale(1,1);
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [btn.layer addAnimation:transition forKey:nil];
    
    [btn setImage:[UIImage imageNamed:@"imgbtndislike"] forState:UIControlStateNormal];
}

-(IBAction)CommentToPost:(id)sender
{
    [tfautoExpandPost becomeFirstResponder];
}

-(IBAction)Like:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    [self performSelector:@selector(setZoomInEffect:) withObject:btn];
    
    [self performSelector:@selector(setZoomOutEffect:) withObject:btn afterDelay:0.2];
    
    if ([[self.dictAllData valueForKey:@"canLike"] isEqualToString:@"Yes"])
    {
        btnLike.userInteractionEnabled=YES;
        [btnLike setImage:[UIImage imageNamed:@"imgbtnlike"] forState:UIControlStateNormal];
        [self _Like:vType_of_post :iActivityID];
    }
    else
    {
        DisplayAlertWithTitle(@"Note", @"You have already Liked this post");
    }
}
-(void)_Like:(NSString *)type :(NSString *)iActivityIDT
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        action = @"_Like";
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
        NSMutableData *postData = [NSMutableData data];
        [postData appendData: [[[NSString stringWithFormat:@"userID=%@&vType_of_content=%@&iActivityID=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],type,iActivityIDT]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:strLikeFeed]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        [urlRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}

-(IBAction)UNLike:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [self performSelector:@selector(setZoomInEffect2:) withObject:btn];
    [self performSelector:@selector(setZoomOutEffect2:) withObject:btn afterDelay:0.2];
    
    btnUnLike.enabled=NO;
    
    if ([[self.dictAllData valueForKey:@"canUnLike"] isEqualToString:@"Yes"])
    {
        [self _UNLike:vType_of_post :iActivityID];
    }
    else
    {
        DisplayAlertWithTitle(@"Note", @"You have already Disliked this post");
    }
}
-(void)_UNLike:(NSString *)type :(NSString *)iActivityIDT
{
    if ([AppDelegate sharedInstance].InternetConnectionFlag==0)
    {
        DisplayNoInternate;
        return;
    }
    else
    {
        action = @"_UNLike";
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
        
        NSMutableData *postData = [NSMutableData data];
        [postData appendData: [[[NSString stringWithFormat:@"userID=%@&vType_of_content=%@&iActivityID=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]valueForKey:@"admin_id"],type,iActivityIDT]stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *urlRequest;
        urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setURL:[NSURL URLWithString:strUNLikeFeed]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:postData];
        [urlRequest setTimeoutInterval:kTimeOutInterval];

        connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    }
}
-(void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data{
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response{
    [webData setLength:0];
}
-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    [[AppDelegate sharedInstance]hideLoader];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //DisplayAlert(error.localizedDescription);
}
-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    NSString *strData = [[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    [[AppDelegate sharedInstance]hideLoader];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSError *error;
    NSData *storesData = [strData dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:storesData options:NSJSONReadingMutableLeaves error:&error];
    [self setData:dict];
}

-(void)setData:(NSDictionary*)dictionary
{
    if(dictionary==(id)[NSNull null])
    {
        return;
    }
    else
    {
        if ([action isEqualToString:@"_AddComment"])
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kUpdateFriendFeeds" object:nil];
            action = @"";
            NSString *strMSG =[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"MESSAGE"]];
            if([strMSG isEqualToString:@"SUCCESS"])
            {
                //pp12
                [btnComment setTitleColor:viewUpperBar.backgroundColor forState:UIControlStateNormal];
                
                shouldLoadUpdates=YES;
                strPostSuccessful = @"RefreshView";
                tfautoExpandPost.text = @"";
                [self _GetComment];
            }
            else
            {
                DisplayAlertWithTitle(@"Note", strMSG);
                return;
            }
        }
        else if ([action isEqualToString:@"_GetComment"])
        {
            action = @"";
            NSString *strMSG =[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"MESSAGE"]];
            if ([strMSG isEqualToString:@"SUCCESS"])
            {
                CGFloat constrainedSize = 230.0f;
                UIFont *myFont = [UIFont systemFontOfSize:16.0];
                [self.arrContent removeAllObjects];
                
                NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc]initWithDictionary:self.dictAllData];
                [dictTemp setValue:[[dictionary valueForKey:@"ACTIVITY_DATA"]valueForKey:@"canLike"] forKey:@"canLike"];
                [dictTemp setValue:[[dictionary valueForKey:@"ACTIVITY_DATA"]valueForKey:@"hasCommented"] forKey:@"hasCommented"];
                [dictTemp setValue:[[dictionary valueForKey:@"ACTIVITY_DATA"]valueForKey:@"canUnLike"] forKey:@"canUnLike"];
                [dictTemp setValue:[[dictionary valueForKey:@"ACTIVITY_DATA"]valueForKey:@"vLikersIDs_count"] forKey:@"vLikersIDs_count"];
                [dictTemp setValue:[[dictionary valueForKey:@"ACTIVITY_DATA"]valueForKey:@"vUnlikersIDs_count"] forKey:@"vUnlikersIDs_count"];
                
                if ([[[dictionary valueForKey:@"ACTIVITY_DATA"]valueForKey:@"vType_of_content"] isEqualToString:@"nowfriends"])
                {
                    [dictTemp setValue:[[dictionary valueForKey:@"ACTIVITY_DATA"]valueForKey:@"fullname_iFriendsID"] forKey:@"fullname_iFriendsID"];
                    [dictTemp setValue:[[dictionary valueForKey:@"ACTIVITY_DATA"]valueForKey:@"school_iFriendsID"] forKey:@"school_iFriendsID"];[dictTemp setValue:[[dictionary valueForKey:@"ACTIVITY_DATA"]valueForKey:@"hasNoOfFriends_iFriendsID"] forKey:@"hasNoOfFriends_iFriendsID"];
                    [dictTemp setValue:[[dictionary valueForKey:@"ACTIVITY_DATA"]valueForKey:@"nowfriends_path_iFriendsID"] forKey:@"image_path_iFriendsID"];
                }
                
                self.dictAllData = [dictTemp copy];
                
                lblLikeCount.text = [NSString stringWithFormat:@"%@",[[self.dictAllData valueForKey:@"vLikersIDs_count"] removeNull]];
                lblDislikeCount.text =[NSString stringWithFormat:@"%@",[[self.dictAllData valueForKey:@"vUnlikersIDs_count"] removeNull]];
                
                lblCommentCount.text = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"ACTIVITY_DATA"]valueForKey:@"Comment_counts"]removeNull]];
                
                [self ChangeLikeImageHeader:[lblLikeCount.text intValue]];
                [self ChangeDisLikeImageHeader:[lblDislikeCount.text intValue]];
                [self ChnageCommentImageHeader:[lblCommentCount.text intValue]];
                
                
                NSString *strMainLikes = [NSString stringWithFormat:@"%d likes • %d dislikes",[[self.dictAllData valueForKey:@"vLikersIDs_count"] intValue],[[self.dictAllData valueForKey:@"vUnlikersIDs_count"] intValue]];
                NSString* strLikeNoInt = [NSString stringWithFormat:@"%d",[[self.dictAllData valueForKey:@"vLikersIDs_count"] intValue]];
                NSString* strUnLikeNoInt = [NSString stringWithFormat:@" %d",[[self.dictAllData valueForKey:@"vUnlikersIDs_count"] intValue]];
                
                NSMutableAttributedString* attString = [[NSMutableAttributedString alloc]initWithString:strMainLikes];
                [attString setFontName:@"Helvetica-Bold" size:17.0 range:[strMainLikes rangeOfString:strLikeNoInt]];
                [attString setTextColor:RGBCOLOR(62, 162, 131) range:[strMainLikes rangeOfString:strLikeNoInt]];
                
                [attString setFontName:@"Helvetica-Bold" size:17.0 range:[strMainLikes rangeOfString:strUnLikeNoInt]];
                [attString setTextColor:RGBCOLOR(62, 162, 131) range:[strMainLikes rangeOfString:strUnLikeNoInt]];
                
                lblLikesNos.attributedText =attString;
                
                if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"activity"])
                {
                    [btnComment setTitleColor:kColorThought forState:UIControlStateHighlighted];
                    viewUpperBar.backgroundColor=kColorThought;
                }
                else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"location"])
                {
                    [btnComment setTitleColor:kColorLocation forState:UIControlStateHighlighted];
                    viewUpperBar.backgroundColor=kColorLocation;
                }
                else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"video"])
                {
                    [btnComment setTitleColor:kColorVideo forState:UIControlStateHighlighted];
                    viewUpperBar.backgroundColor=kColorVideo;
                }
                else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"image"])
                {
                    [btnComment setTitleColor:kColorImage forState:UIControlStateHighlighted];
                    viewUpperBar.backgroundColor=kColorImage;
                }
                else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"music"])
                {
                    [btnComment setTitleColor:kColorMusic forState:UIControlStateHighlighted];
                    viewUpperBar.backgroundColor=kColorMusic;
                }
                else
                {
                    [btnComment setTitleColor:kColorYellow forState:UIControlStateHighlighted];
                    viewUpperBar.backgroundColor=kColorYellow;
                }
                
                if ([[self.dictAllData valueForKey:@"hasCommented"] isEqualToString:@"Yes"])
                {
                    //pp12
                    [btnComment setTitleColor:viewUpperBar.backgroundColor forState:UIControlStateNormal];
                }
                
                for (int i =0; i<[[[dictionary valueForKey:@"ACTIVITY_DATA"]valueForKey:@"Comments"] count]; i++)
                {
                    NSMutableDictionary *dict = [[[[dictionary valueForKey:@"ACTIVITY_DATA"]valueForKey:@"Comments"]objectAtIndex:i] copy];

                    FeedComment *feedComment = [[FeedComment alloc] init];
                    if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"activity"]) 
                    {
                        feedComment.iActivityID =[NSString stringWithFormat:@"%@",[[dict objectForKey:@"iActivityID"] removeNull]];
                    }
                    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"location"])
                    {
                        feedComment.iActivityID =[NSString stringWithFormat:@"%@",[[dict objectForKey:@"iGroupLocationID"] removeNull]];
                    }
                    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"video"])
                    {
                        feedComment.iActivityID =[NSString stringWithFormat:@"%@",[[dict objectForKey:@"iVideoID"] removeNull]];
                    }   
                    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"image"])
                    {
                        feedComment.iActivityID =[NSString stringWithFormat:@"%@",[[dict objectForKey:@"iImageID"] removeNull]];
                    }
                    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"music"])
                    {
                        feedComment.iActivityID =[NSString stringWithFormat:@"%@",[[dict objectForKey:@"iMusicID"] removeNull]];
                    }
                
                    
                    feedComment.user =[NSString stringWithFormat:@"%@", [dict objectForKey:@"admin_fullname"]];
                    feedComment.admin_fname =[NSString stringWithFormat:@"%@", [dict objectForKey:@"admin_fname"]];
                    feedComment.admin_lname =[NSString stringWithFormat:@"%@", [dict objectForKey:@"admin_lname"]];
                    feedComment.unixTimeStamp = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"unixTimeStamp"] removeNull]];
                    double unixTimeStampDDD =[feedComment.unixTimeStamp integerValue];
                    NSTimeInterval _interval=unixTimeStampDDD;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
                    feedComment.feedDate = date;
                    feedComment.tsInsertDt = [NSString stringWithFormat:@"%@", [dict objectForKey:@"tsInsertDt"]];
                    feedComment.bContent =[NSString stringWithFormat:@"%@", [[dict objectForKey:@"bContent"] removeNull]];
                    
                    CGSize textSize= [[NSString stringWithFormat:@"%@",feedComment.bContent] sizeWithFont:myFont constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)lineBreakMode:NSLineBreakByWordWrapping];
                    feedComment.labelHeightComment = [NSNumber numberWithFloat:textSize.height];
                    
                    feedComment.imgURL = [NSString stringWithFormat:@"%@", [dict objectForKey:@"image_path_Commenter"]];
                                    
                    feedComment.message = [dictionary objectForKey:@"bContent"];
                    [self.arrContent addObject:feedComment];
                }
 
                [self addSectionView];
                tfautoExpandPost.text = @"";
            }
            else
            {
                [self addSectionView];
                DisplayAlertWithTitle(@"Note", strMSG);
                return;
            }
        }
        else if ([action isEqualToString:@"_Like"])
        {
            action = @"";
            NSString *strMSG =[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"MESSAGE"] removeNull]] ;
            
//            btnLike.enabled=([strMSG isEqualToString:@"SUCCESS"])?NO:YES;
//            btnUnLike.enabled=([strMSG isEqualToString:@"SUCCESS"])?YES:NO;
            
            btnLike.userInteractionEnabled=([strMSG isEqualToString:@"SUCCESS"])?NO:YES;
            btnUnLike.userInteractionEnabled=(![strMSG isEqualToString:@"SUCCESS"])?NO:YES;
            
            [btnLike setImage:([strMSG isEqualToString:@"SUCCESS"])?[UIImage imageNamed:@"imgbtnlike-h"]:[UIImage imageNamed:@"imgbtnlike"] forState:UIControlStateNormal];
            [btnUnLike setImage:(![strMSG isEqualToString:@"SUCCESS"])?[UIImage imageNamed:@"imgbtndislike-h"]:[UIImage imageNamed:@"imgbtndislike"] forState:UIControlStateNormal];

            if ([strMSG isEqualToString:@""])
            {
                return;
            }
            else if ([strMSG isEqualToString:@"SUCCESS"])
            {
                action = @"";
                shouldLoadUpdates=YES;
                if ([[self.dictAllData valueForKey:@"canLike"]isEqualToString:@"Yes"] &&
                    [[self.dictAllData valueForKey:@"canUnLike"]isEqualToString:@"Yes"])
                {
                    
                    NSString* strMainLikes = [NSString stringWithFormat:@"%d likes • %d dislikes",[[dictAllData valueForKey:@"vLikersIDs_count"] intValue]+1,[[dictAllData valueForKey:@"vUnlikersIDs_count"] intValue]];
                    NSString* strLikeNoInt = [NSString stringWithFormat:@"%d",[[dictAllData valueForKey:@"vLikersIDs_count"] intValue]+1];
                    NSString* strUnLikeNoInt = [NSString stringWithFormat:@" %d",[[dictAllData valueForKey:@"vUnlikersIDs_count"] intValue]];
                    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc]initWithString:strMainLikes];
                    
                    [attString setFontName:@"Helvetica-Bold" size:17.0 range:[strMainLikes rangeOfString:strLikeNoInt]];
                    [attString setTextColor:RGBCOLOR(62, 162, 131) range:[strMainLikes rangeOfString:strLikeNoInt]];
                    
                    [attString setFontName:@"Helvetica-Bold" size:17.0 range:[strMainLikes rangeOfString:strUnLikeNoInt]];
                    [attString setTextColor:RGBCOLOR(62, 162, 131) range:[strMainLikes rangeOfString:strUnLikeNoInt]];
                    
                    lblLikesNos.attributedText =attString;
                    lblLikeCount.text = [NSString stringWithFormat:@"%d",[[dictAllData valueForKey:@"vLikersIDs_count"] intValue]+1];
                    lblDislikeCount.text =[NSString stringWithFormat:@"%d",[[dictAllData valueForKey:@"vUnlikersIDs_count"] intValue]];
                    
                    [self ChangeLikeImageHeader:[lblLikeCount.text intValue]];
                    [self ChangeDisLikeImageHeader:[lblDislikeCount.text intValue]];
                    [self ChnageCommentImageHeader:[lblCommentCount.text intValue]];
                }
                else
                {
                    
                    NSString* strMainLikes = [NSString stringWithFormat:@"%d likes • %d dislikes",[[dictAllData valueForKey:@"vLikersIDs_count"] intValue]+1,[[dictAllData valueForKey:@"vUnlikersIDs_count"] intValue]-1];
                    
                    NSString* strLikeNoInt = [NSString stringWithFormat:@"%d",[[dictAllData valueForKey:@"vLikersIDs_count"] intValue]+1];
                    NSString* strUnLikeNoInt = [NSString stringWithFormat:@" %d",[[dictAllData valueForKey:@"vUnlikersIDs_count"] intValue]-1];
                    
                    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc]initWithString:strMainLikes];
                    
                    [attString setFontName:@"Helvetica-Bold" size:17.0 range:[strMainLikes rangeOfString:strLikeNoInt]];
                    [attString setTextColor:RGBCOLOR(62, 162, 131) range:[strMainLikes rangeOfString:strLikeNoInt]];
                    
                    [attString setFontName:@"Helvetica-Bold" size:17.0 range:[strMainLikes rangeOfString:strUnLikeNoInt]];
                    [attString setTextColor:RGBCOLOR(62, 162, 131) range:[strMainLikes rangeOfString:strUnLikeNoInt]];
                    
                    lblLikesNos.attributedText =attString;
                    lblLikeCount.text = [NSString stringWithFormat:@"%d",[[dictAllData valueForKey:@"vLikersIDs_count"] intValue]+1];
                    lblDislikeCount.text =[NSString stringWithFormat:@"%d",[[dictAllData valueForKey:@"vUnlikersIDs_count"] intValue]-1];
                    
                    [self ChangeLikeImageHeader:[lblLikeCount.text intValue]];
                    [self ChangeDisLikeImageHeader:[lblDislikeCount.text intValue]];
                    [self ChnageCommentImageHeader:[lblCommentCount.text intValue]];
                }
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:dictAllData];
                
                [dict setValue:lblLikeCount.text forKey:@"vLikersIDs_count"];
                [dict setValue:lblDislikeCount.text forKey:@"vUnlikersIDs_count"];
                
                if ([[dictAllData valueForKey:@"canLike"] isEqualToString:@"Yes"])
                {
                    [dict setValue:@"No" forKey:@"canLike"];
                    [dict setValue:@"Yes" forKey:@"canUnLike"];
                }
                else
                {
                    [dict setValue:@"Yes" forKey:@"canLike"];
                    [dict setValue:@"No" forKey:@"canUnLike"];
                }
                dictAllData = [dict copy];
                [self Like_OR_Dislike_CustomRow:@"likes"];
            }
        }
        else if ([action isEqualToString:@"_UNLike"])
        {
            action = @"";
            NSString *strMSG =[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"MESSAGE"] removeNull]] ;
            btnLike.userInteractionEnabled=(![strMSG isEqualToString:@"SUCCESS"])?NO:YES;
            btnUnLike.userInteractionEnabled=([strMSG isEqualToString:@"SUCCESS"])?NO:YES;
            [btnLike setImage:(![strMSG isEqualToString:@"SUCCESS"])?[UIImage imageNamed:@"imgbtnlike-h"]:[UIImage imageNamed:@"imgbtnlike"] forState:UIControlStateNormal];
            [btnUnLike setImage:([strMSG isEqualToString:@"SUCCESS"])?[UIImage imageNamed:@"imgbtndislike-h"]:[UIImage imageNamed:@"imgbtndislike"] forState:UIControlStateNormal];
            if ([strMSG isEqualToString:@""])
            {
                return;
            }
            if ([strMSG isEqualToString:@"SUCCESS"]) 
            {
                action = @"";
                shouldLoadUpdates=YES;
                if ([[self.dictAllData valueForKey:@"canLike"]isEqualToString:@"Yes"] && [[self.dictAllData valueForKey:@"canUnLike"]isEqualToString:@"Yes"])
                {
                    NSString* strMainLikes = [NSString stringWithFormat:@"%d likes • %d dislikes",[[dictAllData valueForKey:@"vLikersIDs_count"] intValue],[[dictAllData valueForKey:@"vUnlikersIDs_count"] intValue]+1];
                    NSString* strLikeNoInt = [NSString stringWithFormat:@"%d",[[dictAllData valueForKey:@"vLikersIDs_count"] intValue]];
                    NSString* strUnLikeNoInt = [NSString stringWithFormat:@" %d",[[dictAllData valueForKey:@"vUnlikersIDs_count"] intValue]+1];
                    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc]initWithString:strMainLikes];
                    [attString setFontName:@"Helvetica-Bold" size:17.0 range:[strMainLikes rangeOfString:strLikeNoInt]];
                    [attString setTextColor:RGBCOLOR(62, 162, 131) range:[strMainLikes rangeOfString:strLikeNoInt]];
                    [attString setFontName:@"Helvetica-Bold" size:17.0 range:[strMainLikes rangeOfString:strUnLikeNoInt]];
                    [attString setTextColor:RGBCOLOR(62, 162, 131) range:[strMainLikes rangeOfString:strUnLikeNoInt]];
                    
                    lblLikesNos.attributedText =attString;
                    lblLikeCount.text = [NSString stringWithFormat:@"%d",[[dictAllData valueForKey:@"vLikersIDs_count"] intValue]];
                    lblDislikeCount.text =[NSString stringWithFormat:@"%d",[[dictAllData valueForKey:@"vUnlikersIDs_count"] intValue]+1];
                    
                    [self ChangeLikeImageHeader:[lblLikeCount.text intValue]];
                    [self ChangeDisLikeImageHeader:[lblDislikeCount.text intValue]];
                    [self ChnageCommentImageHeader:[lblCommentCount.text intValue]];
                }
                else
                {
                    NSString* strMainLikes = [NSString stringWithFormat:@"%d likes • %d dislikes",[[dictAllData valueForKey:@"vLikersIDs_count"] intValue]-1,[[dictAllData valueForKey:@"vUnlikersIDs_count"] intValue]+1];
                    NSString* strLikeNoInt = [NSString stringWithFormat:@"%d",[[dictAllData valueForKey:@"vLikersIDs_count"] intValue]-1];
                    NSString* strUnLikeNoInt = [NSString stringWithFormat:@" %d",[[dictAllData valueForKey:@"vUnlikersIDs_count"] intValue]+1];
                    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc]initWithString:strMainLikes];
                    
                    [attString setFontName:@"Helvetica-Bold" size:17.0 range:[strMainLikes rangeOfString:strLikeNoInt]];
                    [attString setTextColor:RGBCOLOR(62, 162, 131) range:[strMainLikes rangeOfString:strLikeNoInt]];
                    
                    [attString setFontName:@"Helvetica-Bold" size:17.0 range:[strMainLikes rangeOfString:strUnLikeNoInt]];
                    [attString setTextColor:RGBCOLOR(62, 162, 131) range:[strMainLikes rangeOfString:strUnLikeNoInt]];
                    
                    lblLikesNos.attributedText =attString;
                    lblLikeCount.text = [NSString stringWithFormat:@"%d",[[dictAllData valueForKey:@"vLikersIDs_count"] intValue]-1];
                    lblDislikeCount.text =[NSString stringWithFormat:@"%d",[[dictAllData valueForKey:@"vUnlikersIDs_count"] intValue]+1];
                    
                    [self ChangeLikeImageHeader:[lblLikeCount.text intValue]];
                    [self ChangeDisLikeImageHeader:[lblDislikeCount.text intValue]];
                    [self ChnageCommentImageHeader:[lblCommentCount.text intValue]];
                }
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:dictAllData];
                
                [dict setValue:lblLikeCount.text forKey:@"vLikersIDs_count"];
                [dict setValue:lblDislikeCount.text forKey:@"vUnlikersIDs_count"];

                if ([[dictAllData valueForKey:@"canUnLike"] isEqualToString:@"Yes"])
                {
                    [dict setValue:@"No" forKey:@"canUnLike"];
                    [dict setValue:@"Yes" forKey:@"canLike"];
                }
                else
                {
                    [dict setValue:@"Yes" forKey:@"canUnLike"];
                    [dict setValue:@"No" forKey:@"canLike"];
                }
                
                dictAllData = [dict copy];
                [self Like_OR_Dislike_CustomRow:@"dislikes"];
            }
        }
    }
}

#pragma mark - HEADER UI METHODS
-(void)addSectionView
{
    
    BOOL isFromHome=([[self.dictAllData valueForKey:@"isFromHome"] isEqualToString:@"1"])?YES:NO;
    lblUserName.text = [NSString stringWithFormat:@"%@%@%@", [[self.dictAllData valueForKey:@"admin_fname"]removeNull],([[[self.dictAllData valueForKey:@"admin_fname"]removeNull]length]>0)?@" ":@"",[[self.dictAllData valueForKey:@"admin_lname"] removeNull]];
    
    lblTimeDuration.text =[NSString stringWithFormat:@"%@",[[[self.dictAllData valueForKey:@"feedDate"] FormatedDate] removeNull]];
    
    CGRect labelFrame = lblFeedPost.frame;
    labelFrame.size.height = [[dictAllData valueForKey:@"labelHeight"] floatValue];
    [lblFeedPost setFrame:labelFrame];
    
    NSString* strRange;
    
    if([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"wrote"])
    {
        strRange=[NSString stringWithFormat:@"%@",[[self.dictAllData valueForKey:(isFromHome)?@"vActivityText":@"generalText"] removeNull]];
    }
    else
    {
        if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"location"])
        {
            strRange=[NSString stringWithFormat:@"%@%@",[[self.dictAllData valueForKey:@"vActivityText"] removeNull],([[self.dictAllData valueForKey:@"vImWithflname"] removeNull])?@"":[NSString stringWithFormat:@" with %@",[[self.dictAllData valueForKey:@"vImWithflname"] removeNull]]];
        }
        else
        {
           strRange=[NSString stringWithFormat:@"%@%@%@%@",[self.dictAllData valueForKey:@"vActivityText"],([[[self.dictAllData valueForKey:@"vImWithflname"] removeNull] isEqualToString:@""])?@"":[NSString stringWithFormat:@" with %@",[[self.dictAllData valueForKey:@"vImWithflname"] removeNull]],([[[self.dictAllData valueForKey:@"vIamAt"] removeNull] isEqualToString:@""])?@"":[NSString stringWithFormat:@" - at %@",[[self.dictAllData valueForKey:@"vIamAt"] removeNull]],([[[self.dictAllData valueForKey:@"vIamAt2"] removeNull] isEqualToString:@""])?@"":[NSString stringWithFormat:@" %@",[[self.dictAllData valueForKey:@"vIamAt2"] removeNull]]];
        }
    }
    

    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:strRange];

    [attString setFontName:@"Helvetica" size:14.0 range:NSMakeRange(0, [strRange length])];
   
    NSString *strRange1;
    NSRange rangeFinal1;
    if(![[[self.dictAllData valueForKey:@"vImWithflname"] removeNull] isEqualToString:@""])
    {
        strRange1 = strRange;
        rangeFinal1 = [strRange1 rangeOfString:[self.dictAllData valueForKey:@"vImWithflname"]];
        [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal1];
        [attString setTextColor:[UIColor blackColor] range:rangeFinal1];
    }
    
    NSString* strRange2;
    NSRange rangeFinal2;
    if(![[[self.dictAllData valueForKey:@"vIamAt"] removeNull] isEqualToString:@""])
    {
        strRange2 =strRange;
        rangeFinal2 = [strRange2 rangeOfString:[self.dictAllData valueForKey:@"vIamAt"]];
        [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal2];
        [attString setTextColor:[UIColor blackColor] range:rangeFinal2];
    }
    
    lblFeedPost.attributedText = attString;
    lblFeedPost.numberOfLines = 0;
    lblFeedPost.lineBreakMode = NSLineBreakByWordWrapping;
    [lblFeedPost sizeToFit];
    lblFeedPost.backgroundColor = [UIColor clearColor];
    
    if (lblFeedPost.frame.size.height==1)
    {
        CGRect temppRect=lblFeedPost.frame;
        temppRect.size.height=18.0;
        temppRect.size.width=290.0;
        lblFeedPost.frame=temppRect;
    }
    
    imageViewBGHeader.frame = CGRectMake(5.0,21.0,310.0,47.0+lblFeedPost.frame.size.height);
    
    if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"birthdaywish"])
    {
        imgViewUser.backgroundColor=[UIColor lightGrayColor];
        imgViewUser.image=[UIImage imageNamed:@"birthdaycake.png"];
    }
    else
    {
         NSURL *imgURL = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[self.dictAllData valueForKey:@"imgURL"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [imgViewUser setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"sync.png"]];
    }
        
    CGFloat sectHeight = 0;
    sectHeight = [[dictAllData valueForKey:@"labelHeight"] floatValue]+25.0;
    
    lblFeedPost.hidden = NO;
    
    
    if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"activity"] || ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"wrote"] && isFromHome))
    {
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0,0,320,26+MAX(74, sectHeight))];
        viewSection.frame = CGRectMake(0,0,320,imageViewBGHeader.frame.origin.y+imageViewBGHeader.frame.size.height-2);
        viewLikeDislike.frame = CGRectMake(5,viewSection.frame.origin.y+viewSection.frame.size.height,310,viewLikeDislike.frame.size.height);
        [v addSubview:viewLikeDislike];
        [v addSubview:viewSection];
        [v setFrame:CGRectMake(0,0,320,viewLikeDislike.frame.origin.y+viewLikeDislike.frame.size.height+2)];
        TblView.tableHeaderView = v;
        
        [imageViewBGHeader setImage:[[UIImage imageNamed:@"imgcellheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35.0,0.0,0.0,0.0)]];
    }
    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"image"])
    {
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
        
        imgViewPostImage.clipsToBounds=YES;
        float imageHeight = [[[self.dictAllData valueForKey:@"imageHeight"] removeNull]floatValue];
        float imageWidth = [[[self.dictAllData valueForKey:@"imageWidth"] removeNull]floatValue];
        float heightImgMax = MIN(310, imageHeight);
        float imageoriginy=([[strRange removeNull]length]==0)?52:(lblFeedPost.frame.origin.y+lblFeedPost.frame.size.height+10.0);
        
        if(heightImgMax >= 310)
        {
            if (imageWidth>imageHeight)
            {
                imgViewPostImage.tag = 0;
                imgViewPostImage.frame=CGRectMake(5.0,imageoriginy,310.0,imageHeight*310.0/imageWidth);
            }
            else
            {
                imgViewPostImage.tag = 500500;
                imgViewPostImage.frame=CGRectMake(5.0,imageoriginy,310.0,310.0);
            }
        }
        else
        {
            imgViewPostImage.tag = 0;
            imgViewPostImage.frame=CGRectMake(5.0,imageoriginy,310.0,heightImgMax);
        }
        
        imageViewBGHeader.frame = CGRectMake(5,21, 310,imageoriginy+imgViewPostImage.frame.size.height-21.0);
        
        viewSection.frame = CGRectMake(0,0, 320,imageViewBGHeader.frame.origin.y+imageViewBGHeader.frame.size.height-2);
        
        viewLikeDislike.frame = CGRectMake(5,viewSection.frame.origin.y+viewSection.frame.size.height,310,viewLikeDislike.frame.size.height);
        
        UIButton* btnFullView = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFullView.frame = imgViewPostImage.frame;
        [btnFullView addTarget:self action:@selector(thumbnilImage:) forControlEvents:UIControlEventTouchUpInside];
        
        [v addSubview:viewLikeDislike];
        [v addSubview:viewSection];
        [viewSection addSubview:imgViewPostImage];
        [viewSection addSubview:btnFullView];
        
        NSURL *imgURL2 = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[self.dictAllData valueForKey:@"imgURLPOST"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [imgViewPostImage setImageWithURL:imgURL2 placeholderImage:[UIImage imageNamed:@"sync.png"]];
        
        [imageViewBGHeader setImage:[[UIImage imageNamed:@"imgcellheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35.0,0.0,0.0,0.0)]];
        [v setFrame:CGRectMake(0,0,320,viewLikeDislike.frame.origin.y+viewLikeDislike.frame.size.height+2)];
        
        TblView.tableHeaderView = v;
    }
    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"video"])
    {
        if([[[dictAllData valueForKey:@"strYouTubeId"] removeNull] length]!=0)
        {
            UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
            webViewYoutube.delegate=self;
            
            
            float videowidth = webViewYoutube.frame.size.width;
            float videoheight = webViewYoutube.frame.size.height;
            NSString *embeddedHtml = [NSString stringWithFormat:@"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width =%f\"/></head><body style=\"background:#000;margin-top:0px;margin-left:0px\"><div><object width=\"%f\" height=\"%f\"><param name=\"movie\" value=\"http://www.youtube.com/v/%@&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\"></param><param name=\"wmode\" value=\"transparent\"></param><embed src=\"http://www.youtube.com/v/%@&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"%f\" height=\"%f\"></embed></object></div></body></html>",videowidth,videowidth,videoheight,[self.dictAllData valueForKey:@"strYouTubeId"],[self.dictAllData valueForKey:@"strYouTubeId"],videowidth,videoheight];
            
            [webViewYoutube loadHTMLString:embeddedHtml baseURL:nil];

            lblYouTubeTitle.text = [NSString stringWithFormat:@"%@",[[self.dictAllData valueForKey:@"strYouTubeTitle"]removeNull]];
            
            float imageoriginy=([[strRange removeNull]length]==0)?52:(lblFeedPost.frame.origin.y+lblFeedPost.frame.size.height+10.0);
            
            [viewYoutube setFrame:CGRectMake(5,imageoriginy,310, 90)];
            
            imageViewBGHeader.frame = CGRectMake(5,21, 310,imageoriginy+viewYoutube.frame.size.height-21.0);
            
            viewSection.frame = CGRectMake(0,0, 320,imageViewBGHeader.frame.origin.y+imageViewBGHeader.frame.size.height-2);
            
            viewLikeDislike.frame = CGRectMake(5,viewSection.frame.origin.y+viewSection.frame.size.height,310,viewLikeDislike.frame.size.height);
            
            [v addSubview:viewLikeDislike];
            [v addSubview:viewSection];
            [viewSection addSubview:viewYoutube];
            
            [v setFrame:CGRectMake(0,0,320,viewLikeDislike.frame.origin.y+viewLikeDislike.frame.size.height+2)];
            TblView.tableHeaderView = v;
        }
        else
        {
            UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
            
            [self performSelectorInBackground:@selector(loadHTML:) withObject:[self.dictAllData valueForKey:@"imgURLPOST"]];
  
            float imageoriginy=([[strRange removeNull]length]==0)?52:(lblFeedPost.frame.origin.y+lblFeedPost.frame.size.height+10.0);
            
            [webVideo setFrame:CGRectMake(5,imageoriginy, 310,310)];
            
            
            imageViewBGHeader.frame = CGRectMake(5,21, 310,imageoriginy+webVideo.frame.size.height-21.0);
            
            viewSection.frame = CGRectMake(0,0, 320,imageViewBGHeader.frame.origin.y+imageViewBGHeader.frame.size.height-2);
            
            viewLikeDislike.frame = CGRectMake(5,viewSection.frame.origin.y+viewSection.frame.size.height,310,viewLikeDislike.frame.size.height);
            
            [v addSubview:viewLikeDislike];
            [v addSubview:viewSection];
            [viewSection addSubview:webVideo];
            
            [v setFrame:CGRectMake(0,0,320,viewLikeDislike.frame.origin.y+viewLikeDislike.frame.size.height+2)];
            TblView.tableHeaderView = v;
        }
        
        [imageViewBGHeader setImage:[[UIImage imageNamed:@"imgcellheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35.0,0.0,0.0,0.0)]];
    }
    else if([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"location"])
    {
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
        
        int mapwidth=126;
        int mapheight=84;
        
        NSString *strMapURL=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@&size=%dx%d&maptype=roadmap&sensor=false&scale=5&zoom=15&markers=%@,%@",[[self.dictAllData valueForKey:@"dcLatitude"] removeNull],[[self.dictAllData valueForKey:@"dcLongitude"] removeNull],mapwidth,mapheight,[[self.dictAllData valueForKey:@"dcLatitude"] removeNull],[[self.dictAllData valueForKey:@"dcLongitude"] removeNull]];
        
        NSString *strLocation=[NSString stringWithFormat:@"At %@ %@",[[self.dictAllData valueForKey:@"vIamAt"] removeNull],[[self.dictAllData valueForKey:@"vIamAt2"] removeNull]];
        
        NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:strLocation];
        
        NSRange rangeFinal1 = [strLocation rangeOfString:@"At"];
        [attString setFontName:@"Helvetica" size:14.0 range:rangeFinal1];
        [attString setTextColor:[UIColor darkGrayColor] range:rangeFinal1];
        
        NSRange rangeFinal2 = [strLocation rangeOfString:[[self.dictAllData valueForKey:@"vIamAt"] removeNull]];
        [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal2];
        [attString setTextColor:[UIColor darkGrayColor] range:rangeFinal2];
        
        NSRange rangeFinal3 = [strLocation rangeOfString:[[self.dictAllData valueForKey:@"vIamAt2"] removeNull]];
        [attString setFontName:@"Helvetica" size:14.0 range:rangeFinal3];
        [attString setTextColor:[UIColor darkGrayColor] range:rangeFinal3];
        
        lblMapTitle.attributedText = attString;
        
        CGRect theRect;
        [lblMapTitle sizeToFit];
        theRect=lblMapTitle.frame;
        float lbltitlemaxht=84.0;
        if (lblMapTitle.frame.size.height<lbltitlemaxht)
        {
            theRect.origin.y=((lbltitlemaxht-lblMapTitle.frame.size.height)/2.0);
        }
        else
        {
            theRect.size.height=lbltitlemaxht;
        }
        
        lblMapTitle.frame=theRect;
        
        float imageoriginy=([[strRange removeNull]length]==0)?52:(lblFeedPost.frame.origin.y+lblFeedPost.frame.size.height+10.0);
        
        [viewMap setFrame:CGRectMake(5,imageoriginy, 310, 90)];
        imageViewBGHeader.frame = CGRectMake(5,21, 310,imageoriginy+viewMap.frame.size.height-21.0);
        viewSection.frame = CGRectMake(0,0, 320,imageViewBGHeader.frame.origin.y+imageViewBGHeader.frame.size.height-2);
        
        viewLikeDislike.frame = CGRectMake(5,viewSection.frame.origin.y+viewSection.frame.size.height,310,viewLikeDislike.frame.size.height);
        
        [v addSubview:viewLikeDislike];
        [v addSubview:viewSection];

        [viewSection addSubview:viewMap];
        
        [v setFrame:CGRectMake(0,0,320,viewLikeDislike.frame.origin.y+viewLikeDislike.frame.size.height+2)];
        TblView.tableHeaderView = v;
        
        [imgMapView setImageWithURL:[NSURL URLWithString:[strMapURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"sync.png"]];
        
        [imageViewBGHeader setImage:[[UIImage imageNamed:@"imgcellheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35.0,0.0,0.0,0.0)]];
    }
    else if([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"music"])
    {
        //strAlbumTitle
        NSString *strMusic=[NSString stringWithFormat:@"Listening to %@ %@",[[self.dictAllData valueForKey:@"strYouTubeTitle"] removeNull],[[self.dictAllData valueForKey:@"strYouTubeTitle"] removeNull]];
        
        NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:strMusic];
        
        NSRange rangeFinal1 = [strMusic rangeOfString:@"Listening to"];
        [attString setFontName:@"Helvetica" size:14.0 range:rangeFinal1];
        [attString setTextColor:[UIColor darkGrayColor] range:rangeFinal1];
        
        NSRange rangeFinal2 = [strMusic rangeOfString:[[self.dictAllData valueForKey:@"strYouTubeTitle"] removeNull]];
        [attString setFontName:@"Helvetica-Bold" size:14.0 range:rangeFinal2];
        [attString setTextColor:[UIColor darkGrayColor] range:rangeFinal2];
        
        NSRange rangeFinal3 = [strMusic rangeOfString:[self.dictAllData valueForKey:@"strYouTubeTitle"]];
        [attString setFontName:@"Helvetica" size:14.0 range:rangeFinal3];
        [attString setTextColor:[UIColor darkGrayColor] range:rangeFinal3];
        
        lblMusicTitle.attributedText = attString;
        
        CGRect theRect;
        [lblMusicTitle sizeToFit];
        theRect=lblMusicTitle.frame;
        float lbltitlemaxht=63.0;
        if (lblMusicTitle.frame.size.height<lbltitlemaxht)
        {
            theRect.origin.y=((lbltitlemaxht-lblMusicTitle.frame.size.height)/2.0);
        }
        else
        {
            theRect.size.height=lbltitlemaxht;
        }
        
        lblMusicTitle.frame=theRect;
        
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
        
        float imageoriginy=([[strRange removeNull]length]==0)?52:(lblFeedPost.frame.origin.y+lblFeedPost.frame.size.height+10.0);
        
        [viewMusic setFrame:CGRectMake(5,imageoriginy,310,69)];
        imageViewBGHeader.frame = CGRectMake(5,21, 310,imageoriginy+viewMusic.frame.size.height-21.0);
        viewSection.frame = CGRectMake(0,0, 320,imageViewBGHeader.frame.origin.y+imageViewBGHeader.frame.size.height-2);
        
        viewLikeDislike.frame = CGRectMake(5,viewSection.frame.origin.y+viewSection.frame.size.height,310,viewLikeDislike.frame.size.height);
        
        [v addSubview:viewLikeDislike];
        [v addSubview:viewSection];
        
        [viewSection addSubview:viewMusic];
        
        [v setFrame:CGRectMake(0,0,320,viewLikeDislike.frame.origin.y+viewLikeDislike.frame.size.height+2)];
        TblView.tableHeaderView = v;
        
        if ([[[dictAllData valueForKey:@"strYouTubeId"] removeNull] length]==0)
        {
            [imgMusic setImage:[UIImage imageNamed:@"default_music.png"]];
            imgMusic.userInteractionEnabled=NO;
        }
        else
        {
            [imgMusic setImageWithURL:[NSURL URLWithString:[[[dictAllData valueForKey:@"strYouTubeId"] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"sync.png"]];
        }
        
        [imageViewBGHeader setImage:[[UIImage imageNamed:@"imgcellheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35.0,0.0,0.0,0.0)]];
    }
    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"badge"])
    {
        lblBudgeAct.text = [[self.dictAllData valueForKey:@"vActivityText"] removeNull];
        lblFeedPost.hidden = YES;
        
        CGRect theRect;
        [lblBudgeAct sizeToFit];
        theRect=lblBudgeAct.frame;
        float lbltitlemaxht=42.0;
        if (lblBudgeAct.frame.size.height<lbltitlemaxht)
        {
            theRect.origin.y=((lbltitlemaxht-lblBudgeAct.frame.size.height)/2.0);
        }
        else
        {
            theRect.size.height=lbltitlemaxht;
        }
        
        lblBudgeAct.frame=theRect;
        
        int count= [[self.dictAllData valueForKey:@"badge_friends"]intValue];
        int badgecount=(count>=100)?100:((count>=50)?50:((count>=20)?20:0));
        BOOL isUserPrivate=([[self.dictAllData valueForKey:@"isUserPrivate"] isEqualToString:@"pri"])?YES:NO;
        [imageBudgePro setImage:[UIImage imageNamed:[NSString stringWithFormat:@"badge%@_%d.png",(isUserPrivate)?@"p":@"",badgecount]]];
        
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
        
        float imageoriginy=52.0;
        
        [viewBudge setFrame:CGRectMake(5,imageoriginy,310,48)];
        imageViewBGHeader.frame = CGRectMake(5,21, 310,imageoriginy+viewBudge.frame.size.height-21.0);
        viewSection.frame = CGRectMake(0,0, 320,imageViewBGHeader.frame.origin.y+imageViewBGHeader.frame.size.height-2);
        
        viewLikeDislike.frame = CGRectMake(5,viewSection.frame.origin.y+viewSection.frame.size.height,310,viewLikeDislike.frame.size.height);
        
        [v addSubview:viewLikeDislike];
        [v addSubview:viewSection];
        
        [viewSection addSubview:viewBudge];
        
        [v setFrame:CGRectMake(0,0,320,viewLikeDislike.frame.origin.y+viewLikeDislike.frame.size.height+2)];
        TblView.tableHeaderView = v;
        
        [imageViewBGHeader setImage:[[UIImage imageNamed:@"imgcellheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35.0,0.0,0.0,0.0)]];
    }
    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"profile_update"])
    {
        lblUpdateAct.text = [[self.dictAllData valueForKey:@"vActivityText"] removeNull];
        lblFeedPost.hidden = YES;
        
        CGRect theRect;
        [lblUpdateAct sizeToFit];
        theRect=lblUpdateAct.frame;
        float lbltitlemaxht=84.0;
        if (lblUpdateAct.frame.size.height<lbltitlemaxht)
        {
            theRect.origin.y=((lbltitlemaxht-lblUpdateAct.frame.size.height)/2.0);
        }
        else
        {
            theRect.size.height=lbltitlemaxht;
        }
        
        lblUpdateAct.frame=theRect;

        
        NSURL *imgURLOld = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[self.dictAllData objectForKey:@"strOldProfilePic"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [imageUpdatePro setImageWithURL:imgURLOld placeholderImage:[UIImage imageNamed:@"sync.png"]];
        
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
        
        float imageoriginy=52.0;
        
        [viewUpdatePro setFrame:CGRectMake(5,imageoriginy,310,90)];
        imageViewBGHeader.frame = CGRectMake(5,21, 310,imageoriginy+viewUpdatePro.frame.size.height-21.0);
        viewSection.frame = CGRectMake(0,0, 320,imageViewBGHeader.frame.origin.y+imageViewBGHeader.frame.size.height-2);
        
        viewLikeDislike.frame = CGRectMake(5,viewSection.frame.origin.y+viewSection.frame.size.height,310,viewLikeDislike.frame.size.height);
        
        [v addSubview:viewLikeDislike];
        [v addSubview:viewSection];
        
        [viewSection addSubview:viewUpdatePro];
        
        [v setFrame:CGRectMake(0,0,320,viewLikeDislike.frame.origin.y+viewLikeDislike.frame.size.height+2)];
        TblView.tableHeaderView = v;
        
        [imageViewBGHeader setImage:[[UIImage imageNamed:@"imgcellheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35.0,0.0,0.0,0.0)]];
    }
    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"nowfriends"])
    {
        lblFeedPost.hidden = YES;
        
        lblWroteBy.text = [NSString stringWithFormat:@"👥 %@",[[self.dictAllData valueForKey:@"fullname_iFriendsID"]removeNull]];
        lblSchool.text = [[self.dictAllData valueForKey:@"school_iFriendsID"] removeNull];
        lblNoOfFriends.text = [NSString stringWithFormat:@"%@ friends",[[self.dictAllData valueForKey:@"hasNoOfFriends_iFriendsID"] removeNull]];
        
        NSURL *imgURLFriendNow = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[self.dictAllData valueForKey:@"image_path_iFriendsID"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [imgWriterImage setImageWithURL:imgURLFriendNow placeholderImage:[UIImage imageNamed:@"sync.png"]];
        
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
        
        float imageoriginy=52.0;
        
        [viewNoteOnFriend setFrame:CGRectMake(5,imageoriginy,310,69)];
        imageViewBGHeader.frame = CGRectMake(5,21, 310,imageoriginy+viewNoteOnFriend.frame.size.height-21.0);
        viewSection.frame = CGRectMake(0,0, 320,imageViewBGHeader.frame.origin.y+imageViewBGHeader.frame.size.height-2);
        
        viewLikeDislike.frame = CGRectMake(5,viewSection.frame.origin.y+viewSection.frame.size.height,310,viewLikeDislike.frame.size.height);
        
        [v addSubview:viewLikeDislike];
        [v addSubview:viewSection];
        
        [viewSection addSubview:viewNoteOnFriend];
        
        [v setFrame:CGRectMake(0,0,320,viewLikeDislike.frame.origin.y+viewLikeDislike.frame.size.height+2)];
        TblView.tableHeaderView = v;
        
        [imageViewBGHeader setImage:[[UIImage imageNamed:@"imgcellheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35.0,0.0,0.0,0.0)]];
    }
    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"birthdaywish"])
    {
        lblWroteBy.text = [NSString stringWithFormat:@"%@",[[self.dictAllData valueForKey:@"birthdaywishdOn_Name"]removeNull]];
        lblSchool.text = [[self.dictAllData valueForKey:@"birthdaywishOn_School"] removeNull];
        lblNoOfFriends.text = [NSString stringWithFormat:@"%@ friends",[[self.dictAllData valueForKey:@"birthdaywishOn_hasFriends"] removeNull]];
        
        NSURL *imgURLWroteBy = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[self.dictAllData valueForKey:@"birthdaywishdOn_image_path"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [imgWriterImage setImageWithURL:imgURLWroteBy placeholderImage:[UIImage imageNamed:@"sync.png"]];
        
        
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
        
        float imageoriginy=([[strRange removeNull]length]==0)?52:(lblFeedPost.frame.origin.y+lblFeedPost.frame.size.height+10.0);
        
        [viewNoteOnFriend setFrame:CGRectMake(5,imageoriginy,310,69)];
        imageViewBGHeader.frame = CGRectMake(5,21, 310,imageoriginy+viewNoteOnFriend.frame.size.height-21.0);
        viewSection.frame = CGRectMake(0,0, 320,imageViewBGHeader.frame.origin.y+imageViewBGHeader.frame.size.height-2);
        
        viewLikeDislike.frame = CGRectMake(5,viewSection.frame.origin.y+viewSection.frame.size.height,310,viewLikeDislike.frame.size.height);
        
        [v addSubview:viewLikeDislike];
        [v addSubview:viewSection];
        
        [viewSection addSubview:viewNoteOnFriend];
        
        [v setFrame:CGRectMake(0,0,320,viewLikeDislike.frame.origin.y+viewLikeDislike.frame.size.height+2)];
        TblView.tableHeaderView = v;
        
        [imageViewBGHeader setImage:[[UIImage imageNamed:@"imgcellheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35.0,0.0,0.0,0.0)]];
    }
    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"wrote"])
    {
        lblWroteBy.text = [[self.dictAllData valueForKey:@"wrotedOn_Name"] removeNull];
        lblSchool.text = [[self.dictAllData valueForKey:@"wroteOn_School"] removeNull];
        lblNoOfFriends.text = [NSString stringWithFormat:@"%@ friends",[[self.dictAllData valueForKey:@"wroteOn_hasFriends"] removeNull]];
        
        NSURL *imgURLWroteBy = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[self.dictAllData valueForKey:@"wrotedOn_image_path"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        imgWriterImage.tag = 1001;
        [imgWriterImage setImageWithURL:imgURLWroteBy placeholderImage:[UIImage imageNamed:@"sync.png"]];
        
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
        
        float imageoriginy=([[strRange removeNull]length]==0)?52:(lblFeedPost.frame.origin.y+lblFeedPost.frame.size.height+10.0);
        
        [viewNoteOnFriend setFrame:CGRectMake(5,imageoriginy,310,69)];
        imageViewBGHeader.frame = CGRectMake(5,21, 310,imageoriginy+viewNoteOnFriend.frame.size.height-21.0);
        viewSection.frame = CGRectMake(0,0, 320,imageViewBGHeader.frame.origin.y+imageViewBGHeader.frame.size.height-2);
        
        viewLikeDislike.frame = CGRectMake(5,viewSection.frame.origin.y+viewSection.frame.size.height,310,viewLikeDislike.frame.size.height);
        
        [v addSubview:viewLikeDislike];
        [v addSubview:viewSection];
        
        [viewSection addSubview:viewNoteOnFriend];
        
        [v setFrame:CGRectMake(0,0,320,viewLikeDislike.frame.origin.y+viewLikeDislike.frame.size.height+2)];
        TblView.tableHeaderView = v;
        
        [imageViewBGHeader setImage:[[UIImage imageNamed:@"imgcellheader.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35.0,0.0,0.0,0.0)]];
    }
    
    
    [TblView reloadData];
    if(self.arrContent.count>0 && ([tfautoExpandPost isFirstResponder]))
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.arrContent count]-1 inSection:0];
        if (indexPath)
        {
            [TblView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}


#pragma mark - BUTTON METHODS

- (void)videoFullScreen:(id)sender
{
    AddViewFlag = 50;
    if([[UIApplication sharedApplication]respondsToSelector:@selector(setStatusBarHidden: withAnimation:)])
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:UIStatusBarAnimationNone];
    else
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)videoExitFullScreen:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)thumbnilImage:(id)sender
{
    NSURL *imgURL2 = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[self.dictAllData valueForKey:@"imgURLPOST"]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    PhotoZoomViewController *obj=[[PhotoZoomViewController alloc]init];
    obj.imgURL = imgURL2;
    [self presentModalViewController:obj animated:NO];
}

#pragma LIKE DISLIKE
-(void)ChangeLikeImageHeader:(int)likeCount
{
    lblLikeCount.hidden =(likeCount == 0)?YES:NO;
    [buttonLike setImage:[UIImage imageNamed:[NSString stringWithFormat:@"imglike%@count.png",(likeCount == 0)?@"cntr":@""]] forState:UIControlStateNormal];
}
-(void)ChangeDisLikeImageHeader:(int)dislikeCount
{
    lblDislikeCount.hidden =(dislikeCount == 0)?YES:NO;
    [buttonDislike setImage:[UIImage imageNamed:[NSString stringWithFormat:@"imgdislike%@count.png",(dislikeCount == 0)?@"cntr":@""]] forState:UIControlStateNormal];
}
-(void)ChnageCommentImageHeader:(int)commentCount
{
    lblCommentCount.hidden =(commentCount == 0)?YES:NO;
    [buttonComment setImage:[UIImage imageNamed:[NSString stringWithFormat:@"imgcomment%@count.png",(commentCount == 0)?@"cntr":@""]] forState:UIControlStateNormal];
}
-(void)Like_OR_Dislike_CustomRow:(NSString *)strLikeOrDislike
{
    CGFloat constrainedSize = 230.0f;
    UIFont *myFont = [UIFont systemFontOfSize:14];
    FeedComment *feedComment = [[FeedComment alloc] init];
    if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"activity"])
    {
        feedComment.bContent =[NSString stringWithFormat:@"%@ %@ this thought.",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]objectForKey:@"admin_fname"],strLikeOrDislike];
    }
    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"location"])
    {
        feedComment.bContent =[NSString stringWithFormat:@"%@ %@ this location.",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]objectForKey:@"admin_fname"],strLikeOrDislike];
    }
    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"video"])
    {
        feedComment.bContent =[NSString stringWithFormat:@"%@ %@ this video.",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]objectForKey:@"admin_fname"],strLikeOrDislike];
    }
    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"image"])
    {
        feedComment.bContent =[NSString stringWithFormat:@"%@ %@ this photo.",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]objectForKey:@"admin_fname"],strLikeOrDislike];
    }
    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"music"])
    {
        feedComment.bContent =[NSString stringWithFormat:@"%@ %@ this song.",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]objectForKey:@"admin_fname"],strLikeOrDislike];
    }
    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"wrote"])
    {
        feedComment.bContent =[NSString stringWithFormat:@"%@ %@ this wrote.",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]objectForKey:@"admin_fname"],strLikeOrDislike];
    }
    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"badge"])
    {
        feedComment.bContent =[NSString stringWithFormat:@"%@ %@ this Badge Unlock.",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]objectForKey:@"admin_fname"],strLikeOrDislike];
    }
    else if ([[self.dictAllData valueForKey:@"vType_of_content"] isEqualToString:@"profile_update"])
    {
        feedComment.bContent =[NSString stringWithFormat:@"%@ %@ this profile pic.",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]objectForKey:@"admin_fname"],strLikeOrDislike];
    }
    else if ([[self.dictAllData valueForKey:@"vType_of_content"]
              isEqualToString:@"nowfriends"])
    {
        feedComment.bContent =[NSString stringWithFormat:@"%@ %@ this.",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]objectForKey:@"admin_fname"],strLikeOrDislike];
    }
    
    feedComment.admin_fname =[NSString stringWithFormat:@"%@", [[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]objectForKey:@"admin_fname"]];
    
    feedComment.admin_lname =[NSString stringWithFormat:@"%@", [[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]objectForKey:@"admin_lname"]];
    
    feedComment.user = [NSString stringWithFormat:@"%@ %@", [[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]objectForKey:@"admin_fname"],[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]objectForKey:@"admin_lname"]];
    
    feedComment.feedDate = [NSDate date];
    
    CGSize textSize= [[NSString stringWithFormat:@"%@",feedComment.bContent] sizeWithFont:myFont constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)lineBreakMode:NSLineBreakByWordWrapping];
    feedComment.labelHeightComment = [NSNumber numberWithFloat:textSize.height];
    
    feedComment.imgURL = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DETAIL"]objectForKey:@"image_path"]];
    
    [self.arrContent addObject:feedComment];
    
    [TblView reloadData];
    
    if(self.arrContent.count>0 && ([tfautoExpandPost isFirstResponder]))
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.arrContent count]-1 inSection:0];
        if (indexPath)
        {
            [TblView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}
#pragma mark - EDITOR METHODS

#pragma mark - TABLE VIEW METHODS
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"AddCommentCell" owner:self options:nil];
        cell=myCell;
    }
    
//    myCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellBG.png"]];
    myCell.backgroundColor = self.view.backgroundColor;
    myCell.tag = indexPath.row;
    FeedComment *feedComment = [self.arrContent objectAtIndex:[indexPath row]];
    myCell.lblFullName.text = [NSString stringWithFormat:@"%@",feedComment.user];
    
    CGRect labelFrame = myCell.lblComment.frame;
    labelFrame.size.height = [feedComment.labelHeightComment floatValue];
    [myCell.lblComment setFrame:labelFrame];
    myCell.lblComment.text =[NSString stringWithFormat:@"%@",[feedComment.bContent removeNull]];
    
    labelFrame = CGRectMake(59, myCell.lblComment.frame.origin.y+myCell.lblComment.frame.size.height + 3, 230, 12);
    [myCell.lblDateCell setFrame:labelFrame];
    myCell.lblDateCell.text = [NSString stringWithFormat:@"%@",[[feedComment.feedDate FormatedDate] removeNull]];
    
    NSMutableDictionary *DddAvtar=[NSMutableDictionary dictionary] ;
    [DddAvtar setValue:feedComment.imgURL forKey:@"urlAvtar"];
    [myCell setDict:DddAvtar];
    
    float htx= MAX(57,[feedComment.labelHeightComment floatValue]+39.0)-1.0;

    UIView *viewSeparater=[[UIView alloc]initWithFrame:CGRectMake(0.0,htx,320.0,1.0)];
    viewSeparater.backgroundColor=[UIColor grayColor];
    [cell.contentView addSubview:viewSeparater];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tfautoExpandPost resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrContent count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedComment *feedComment = [self.arrContent objectAtIndex:indexPath.row];
    return MAX(57,[feedComment.labelHeightComment floatValue]+39.0);
}

#pragma mark - EDITOR UI
-(void)AddAutoExpandTextField
{
    containerView = [[UIView alloc] initWithFrame:CGRectMake(-2, self.view.frame.size.height-45, 324, 45)];
    
    tfautoExpandPost = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 7, 250, 25)];
    tfautoExpandPost.contentInset = UIEdgeInsetsMake(0, 2, 0, 2);
    
    tfautoExpandPost.minNumberOfLines = 1;
    tfautoExpandPost.maxNumberOfLines = 6;
    tfautoExpandPost.returnKeyType = UIReturnKeyDefault; //just as an example
    tfautoExpandPost.font = [UIFont systemFontOfSize:15.0f];
    tfautoExpandPost.delegate = self;
    tfautoExpandPost.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    tfautoExpandPost.backgroundColor = [UIColor clearColor];
    tfautoExpandPost.textColor = [UIColor blackColor];
//    tfautoExpandPost.placeHolderTextView = @"Write a comment..";
    
    [[tfautoExpandPost layer] setMasksToBounds:YES];
    [[tfautoExpandPost layer] setCornerRadius:5.0f];
    [[tfautoExpandPost layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[tfautoExpandPost layer] setBorderWidth:1.0f];
    [[tfautoExpandPost layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[tfautoExpandPost layer] setShadowOffset:CGSizeMake(0, 0)];
    [[tfautoExpandPost layer] setShadowRadius:2.0];
    
    [self.view addSubview:containerView];
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(-2, 2, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    tfautoExpandPost.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [containerView addSubview:imageView];
    [containerView addSubview:tfautoExpandPost];
        
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(containerView.frame.size.width -65, 12, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [doneBtn setTitle:@"Post" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    [doneBtn setTitleColor:RGBCOLOR(242, 108, 79) forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

-(void)resignTextView
{
    [self _AddComment];
    [tfautoExpandPost resignFirstResponder];
}

-(void) keyboardWillShow:(NSNotification *)note
{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    TblView.frame=CGRectMake(0, 48.0+iOS7ExHeight, 320,470+iPhone5ExHeight-50-53-216);
    // commit animations
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
    TblView.frame=CGRectMake(0, 48.0+iOS7ExHeight, 320,470+iPhone5ExHeight-50-53);
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

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    TblView.frame=CGRectMake(0, 48.0+iOS7ExHeight, 320,480+iPhone5ExHeight-50-53-216);
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    TblView.frame=CGRectMake(0, 48.0+iOS7ExHeight, 320,480+iPhone5ExHeight-50-53);
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        [self PostCliked:nil];
        return YES;
    }
    return YES;
}

#pragma mark - DEFAULT METHODS
- (void)viewDidUnload
{
    [super viewDidUnload];
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
