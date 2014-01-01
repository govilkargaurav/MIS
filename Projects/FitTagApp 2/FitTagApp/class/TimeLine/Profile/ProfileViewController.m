//
//  ProfileViewController.m
//  FitTagApp
//
//  Created by apple on 2/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "SettingViewController.h"
#import "TimeLineViewController.h"
#import "ActivityViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchChngCell.h"
#import "UIImageView+WebCache.h"
#import "CommentViewController.h"
#import "LikerListViewController.h"
#import "ChallengeDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CacheManager.h"
#import "DraftViewcontrollerViewController.h"
#import <Twitter/Twitter.h>
#import "GlobalClass.h"
#import "TimeLineViewController_copy.h"
@implementation ProfileViewController
@synthesize lblLocationName;
@synthesize tblCreated;
@synthesize lblCreatedTabValue;
@synthesize lblCreatedValue;
@synthesize lblEmail;
@synthesize txtViewBIO;
@synthesize lblWebSite;
@synthesize lblUserName;
@synthesize viewProfileUpper;
@synthesize btnProfileImg;
@synthesize btnFollow;
@synthesize btnClngCreated;
@synthesize btnClngLiked;
@synthesize profileImage;

@synthesize viewMenu,isOpen;
@synthesize profileUser;
@synthesize mutArrayCreatedChlng;
@synthesize lblFollowerCount;
@synthesize lblFollowingCount,lbl1,lbl2,lbl3,lbl4,arrBlockUsers;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    isNavigationgFirstTime = YES;
    
    arrMoviePlayerObjectLike      = [[NSMutableArray alloc]init];
    arrMoviePlayerObjectCreated   = [[NSMutableArray alloc]init];
    
    lblUserName.font = [UIFont fontWithName:@"DynoBold" size:19];
    [lbl1 setFont:[UIFont fontWithName:@"DynoRegular" size:15]];
    [lbl2 setFont:[UIFont fontWithName:@"DynoRegular" size:15]];
    [lbl3 setFont:[UIFont fontWithName:@"DynoRegular" size:15]];
    [lbl4 setFont:[UIFont fontWithName:@"DynoRegular" size:15]];
    
    [txtViewBIO setFont:[UIFont fontWithName:@"DynoRegular" size:13]];
    
    [lblWebSite setFont:[UIFont fontWithName:@"DynoRegular" size:11]];
    [lblLocationName setFont:[UIFont fontWithName:@"DynoRegular" size:13]];
    [lblFollowerCount setFont:[UIFont fontWithName:@"DynoRegular" size:15]];
    [lblFollowingCount setFont:[UIFont fontWithName:@"DynoRegular" size:15]];
    [lblCreatedValue setFont:[UIFont fontWithName:@"DynoRegular" size:14]];
    [lblLikeCount setFont:[UIFont fontWithName:@"DynoRegular" size:14]];
    [lblCreatedTabValue setFont:[UIFont fontWithName:@"DynoRegular" size:15]];
    [lblLikeChallengeCount setFont:[UIFont fontWithName:@"DynoRegular" size:15]];
    
    arrFilterLikeChallenge  = [[NSMutableArray alloc]init];
    appDelegate             = (AppDelegate *)[[UIApplication sharedApplication]delegate];


    _cMgr                   = [CacheManager sharedCacheManager];
    
    if(profileUser == nil){
        
        UIButton *btnback = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnback addTarget:self action:@selector(btnMenuProfilePressed:) forControlEvents:UIControlEventTouchUpInside];
        [btnback setFrame:CGRectMake(0, 0, 40, 44)];
        [btnback setImage:[UIImage imageNamed:@"headerUser"] forState:UIControlStateNormal];
        UIView *view123=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
        [view123 addSubview:btnback];
        
        UIBarButtonItem *btn123=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
        btn123.width=-16;
        UIBarButtonItem *btn132=[[UIBarButtonItem alloc] initWithCustomView:view123];
        self.navigationItem.leftBarButtonItems=[[NSArray alloc]initWithObjects:btn123,btn132,nil];
        
        // Draft challenge button
        PFQuery *draftQuery = [PFQuery queryWithClassName:@"ChallengeDrafts"];
        [draftQuery whereKey:@"userId" equalTo:[PFUser currentUser]];
        [draftQuery countObjectsInBackgroundWithBlock:^(int count,NSError *countingError){
            if(!countingError){
                if(count > 0){
                    UIButton *btnDraftPencil = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btnDraftPencil addTarget:self action:@selector(draftViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [btnDraftPencil setFrame:CGRectMake(0, 0, 35, 35)];
                    [btnDraftPencil setImage:[UIImage imageNamed:@"DraftPencil.png"] forState:UIControlStateNormal];
                    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 35,35)];
                    [view addSubview:btnDraftPencil];
                    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
                    btn.width=-11;
                    UIBarButtonItem *btn1=[[UIBarButtonItem alloc] initWithCustomView:view];
                    self.navigationItem.rightBarButtonItems=[[NSArray alloc]initWithObjects:btn,btn1,nil];
                }
            }
        }];
        
    }else{
        
        //navigation back Button- Arrow
        UIButton *btnback = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnback addTarget:self action:@selector(btnHeaderbackPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btnback setFrame:CGRectMake(0, 0, 40, 44)];
        [btnback setImage:[UIImage imageNamed:@"headerback"] forState:UIControlStateNormal];
        UIView *view123=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
        [view123 addSubview:btnback];
        
        UIBarButtonItem *btn123=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
        btn123.width=-16;
        UIBarButtonItem *btn132=[[UIBarButtonItem alloc] initWithCustomView:view123];
        self.navigationItem.leftBarButtonItems=[[NSArray alloc]initWithObjects:btn123,btn132,nil];
        
        // Draft challenge button
        
    }

    [viewProfileUpper.layer setCornerRadius:10];
    viewProfileUpper.backgroundColor = [UIColor clearColor];
    [[viewProfileUpper layer] setBorderWidth:2.0];
    [[viewProfileUpper layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];

    [btnProfileImg.layer setBorderWidth:1];
    [btnProfileImg.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    btnProfileImg.clipsToBounds=YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    isFirstload = YES;
    [self performSelectorInBackground:@selector(getFollowerAndProfileData) withObject:nil];
    
}

// Show vertical scroller for bio text

-(void)getFollowerAndProfileData{

    PFQuery *queryForLikeComment = [PFQuery queryWithClassName:@"Tbl_follower"];
    [queryForLikeComment whereKey:@"CurrentUserId" equalTo:[[PFUser currentUser]objectId]];
    arrFollower = [[NSMutableArray alloc]initWithArray:[[queryForLikeComment findObjects] mutableCopy]];
    for (int i=0; i<[arrFollower count]; i++) {
        
        btnFollow.tag = i;
        if ([[[arrFollower objectAtIndex:i] objectForKey:@"follower_id"]isEqualToString:[self.profileUser objectId]]){
            objFollow = [arrFollower objectAtIndex:i];
            [btnFollow setImage:[UIImage imageNamed:@"btnUnfollow"] forState:UIControlStateNormal];
            [btnFollow setImage:[UIImage imageNamed:@"btnUnfollow"] forState:UIControlStateHighlighted];
            
            [btnFollow removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            
            [btnFollow addTarget:self action:@selector(btnUnFollowPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
      
    [self getUserCreatedChallenge];
}

-(IBAction)btnFollowPressedProfile:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    [self performSelector:@selector(followUser) withObject:nil afterDelay:0.5];
}

-(void)followUser{
    isFirstload = NO;
    PFObject *follower = [PFObject objectWithClassName:@"Tbl_follower"];
    
    [follower setObject:[self.profileUser objectId] forKey:@"follower_id"];
    [follower setObject:[[PFUser currentUser]objectId] forKey:@"CurrentUserId"];
    [follower setObject:[PFUser currentUser] forKey:@"userId"];
    [follower setObject:[[PFUser currentUser]username] forKey:@"username"];
    
    [follower setObject:[self.profileUser username] forKey:@"following_username"];
    [follower setObject:self.profileUser forKey:@"followerUser"];
    
    [btnFollow setImage:[UIImage imageNamed:@"btnUnfollow"] forState:UIControlStateNormal];
    [btnFollow setImage:[UIImage imageNamed:@"btnUnfollow"] forState:UIControlStateHighlighted];
    [follower saveInBackground];
    
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"objectId" equalTo:self.profileUser.objectId];
    
    // Send push notification to query
    
    if(![[self.profileUser objectId] isEqualToString:[[PFUser currentUser] objectId]]){
        
        if([[self.profileUser objectForKey:@"followNotification"] isEqualToString:@"YES"]){
            PFPush *push = [[PFPush alloc] init];
            [push setChannel:[NSString stringWithFormat:@"user_%@",[self.profileUser objectId]]];
            
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSString stringWithFormat:@"%@ Started following you",[PFUser currentUser].username], @"alert",
                                  @"Increment", @"badge",
                                  @"default",@"sound",
                                  @"follow",@"action",
                                  [[PFUser currentUser] objectId],@"followingUserId",
                                  nil];
            [push setData:data];
            [push sendPushInBackgroundWithBlock:^(BOOL done,NSError *errror){
                if (!errror) {
                }else{
                }
            }];
        }
    }
    
    [self getFollowerAndProfileData];
    [self performSelectorInBackground:@selector(getUserCreatedChallenge) withObject:nil];
}

-(IBAction)btnUnFollowPressed:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    [objFollow deleteInBackground];
    [self performSelector:@selector(unfollowUser) withObject:nil afterDelay:0.5];
}

-(void)unfollowUser{
    
    isFirstload = NO;
    [btnFollow setImage:[UIImage imageNamed:@"btnFollow"] forState:UIControlStateNormal];
    [btnFollow setImage:[UIImage imageNamed:@"btnFollowSel"] forState:UIControlStateHighlighted];
    [btnFollow removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    
    [btnFollow addTarget:self action:@selector(btnFollowPressedProfile:) forControlEvents:UIControlEventTouchUpInside];
    [self getFollowerAndProfileData];
    [self performSelectorInBackground:@selector(getUserCreatedChallenge) withObject:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    appDelegate.controllerName = @"ProfileViewController";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickOnHashTags:) name:@"clickOnHashTagsProfile" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLikeNameButton:) name:@"userLikeNameButtonProfile" object:nil];
    lblFollowingCount.text  = [NSString stringWithFormat:@"%d",[temparrFollower count]];
    lblFollowerCount.text   = [NSString stringWithFormat:@"%d",[temparrFollowing count]];
    lblLikeCount.text       = [NSString stringWithFormat:@"%d",[mutArrayCreatedChlng count]];
    
    [[PFUser currentUser] refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
    lblChallengeAndLike.font = [UIFont fontWithName:@"DynoBold" size:15];

    appDelegate.isTimeline   = FALSE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCommentsInMainView123:) name:@"commentsProfile" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentbackAction123) name:@"commentbackActionProfile" object:nil];
    
       if(self.profileUser == nil){
           
        //Set user Profile detail//
        lblUserName.text = [[PFUser currentUser]objectForKey:@"username"];
        lblEmail.text = [[PFUser currentUser]objectForKey:@"email"];
           
           if ([[PFUser currentUser]objectForKey:@"BIO"] == NULL) {
               txtViewBIO.text = @"No Bio!";
               
               CGRect frame = txtViewBIO.frame;
               frame.size.height = txtViewBIO.contentSize.height;
               txtViewBIO.frame = frame;
               
           }else{
               txtViewBIO.text = [[PFUser currentUser]objectForKey:@"BIO"];
                CGSize challengeNameSize=[[profileUser objectForKey:@"BIO"]sizeWithFont:[UIFont fontWithName:@"DynoBold" size:13]constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
               CGRect frame = txtViewBIO.frame;
               frame.size.height = challengeNameSize.height+20;
               txtViewBIO.frame = frame;
               
           }
           
        lblWebSite.text         = [[PFUser currentUser]objectForKey:@"webSite"];
        lblLocationName.text    = [[PFUser currentUser]objectForKey:@"locationName"];
        
        PFFile *theImage        = [[PFUser currentUser] objectForKey:@"userPhoto"];
        
        [btnProfileImg setImageURL:[NSURL URLWithString:[theImage url]]];
        
        [btnClngCreated setImage:[UIImage imageNamed:@"tabSel"] forState:UIControlStateNormal];
        [btnClngLiked setImage:[UIImage imageNamed:@"tab"] forState:UIControlStateNormal];
        
        [btnFollow setHidden:YES];
        [btnBlock setHidden:YES];
        [imgBlock setHidden:YES];
        
    }else{
        
        //Set user Profile detail//
        lblUserName.text = [profileUser objectForKey:@"username"];
        lblEmail.text    = [profileUser objectForKey:@"email"];
        
        if([profileUser objectForKey:@"BIO"] == NULL){
            txtViewBIO.text = @"!No Bio";
            
            CGRect frame = txtViewBIO.frame;
            frame.size.height = txtViewBIO.contentSize.height;
            txtViewBIO.frame = frame;
        }else{
           txtViewBIO.text = [profileUser objectForKey:@"BIO"];
            CGSize challengeNameSize=[[profileUser objectForKey:@"BIO"]sizeWithFont:[UIFont fontWithName:@"DynoBold" size:13]constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            CGRect frame = txtViewBIO.frame;
            frame.size.height = challengeNameSize.height+20;
            txtViewBIO.frame = frame;
        }
        
        lblWebSite.text         =   [profileUser objectForKey:@"webSite"];
        lblLocationName.text    =   [profileUser objectForKey:@"locationName"];
        
        PFFile *theImage        =   [profileUser objectForKey:@"userPhoto"];
        
        [btnProfileImg setImageURL:[NSURL URLWithString:[theImage url]]];
        
        [btnClngCreated setImage:[UIImage imageNamed:@"tabSel"] forState:UIControlStateNormal];
        [btnClngLiked setImage:[UIImage imageNamed:@"tab"] forState:UIControlStateNormal];
        
        if ([[self.profileUser username] isEqualToString:[[PFUser currentUser]username]]) {
            [btnFollow setHidden:YES];
            [btnBlock setHidden:YES];
            [imgBlock setHidden:YES];
        }else{
            [btnFollow setHidden:NO];
            [btnBlock setHidden:NO];
            [imgBlock setHidden:NO];
        }
    }
    // Set all Controls and views according to size of BIO text
    
    // Website label frames setting
    lblWebSite.frame = CGRectMake(lblWebSite.frame.origin.x,(txtViewBIO.frame.origin.y+txtViewBIO.frame.size.height+3), lblWebSite.frame.size.width, lblWebSite.frame.size.height);
   
    btnOpenUrl.frame = CGRectMake(btnOpenUrl.frame.origin.x,(txtViewBIO.frame.origin.y+txtViewBIO.frame.size.height+3), btnOpenUrl.frame.size.width, btnOpenUrl.frame.size.height);
    
    // Follow button frames setting
    btnFollow.frame = CGRectMake(btnFollow.frame.origin.x,(btnOpenUrl.frame.origin.y+btnOpenUrl.frame.size.height+3), btnFollow.frame.size.width, btnFollow.frame.size.height);
    
    // Following tab frames setting
    lblFollowerCount.frame = CGRectMake(lblFollowerCount.frame.origin.x,(btnFollow.frame.origin.y+btnFollow.frame.size.height+3), lblFollowerCount.frame.size.width, lblFollowerCount.frame.size.height);
    
    btnTabFollower.frame = CGRectMake(btnTabFollower.frame.origin.x,(btnFollow.frame.origin.y+btnFollow.frame.size.height+3), btnTabFollower.frame.size.width, btnTabFollower.frame.size.height);
    
    lbl3.frame = CGRectMake(lbl3.frame.origin.x,(btnFollow.frame.origin.y+btnFollow.frame.size.height), lbl3.frame.size.width, lbl3.frame.size.height);
    
    // Following tab frames setting
    lblFollowingCount.frame = CGRectMake(lblFollowingCount.frame.origin.x,(btnFollow.frame.origin.y+btnFollow.frame.size.height+3), lblFollowingCount.frame.size.width, lblFollowingCount.frame.size.height);
    
    btnTabFollowing.frame = CGRectMake(btnTabFollowing.frame.origin.x,(btnFollow.frame.origin.y+btnFollow.frame.size.height+3), btnTabFollowing.frame.size.width, btnTabFollowing.frame.size.height);
    
    lbl4.frame = CGRectMake(lbl4.frame.origin.x,(btnFollow.frame.origin.y+btnFollow.frame.size.height+3), lbl4.frame.size.width, lbl4.frame.size.height);
    
    // User created tag frames setting
    
    lbl1.frame = CGRectMake(lbl1.frame.origin.x,(btnTabFollower.frame.origin.y+btnTabFollower.frame.size.height), lbl1.frame.size.width, lbl1.frame.size.height);
    
    lblCreatedValue.frame = CGRectMake(lblCreatedValue.frame.origin.x,(btnTabFollower.frame.origin.y+btnTabFollower.frame.size.height+3), lblCreatedValue.frame.size.width, lblCreatedValue.frame.size.height);
    
    btnTabCreated.frame = CGRectMake(btnTabCreated.frame.origin.x,(btnTabFollower.frame.origin.y+btnTabFollower.frame.size.height+3), btnTabCreated.frame.size.width, btnTabCreated.frame.size.height);
    
    // User liked tab frames setting
    
    lbl2.frame = CGRectMake(lbl2.frame.origin.x,(btnTabFollowing.frame.origin.y+btnTabFollowing.frame.size.height), lbl2.frame.size.width, lbl2.frame.size.height);
    
    lblLikeCount.frame = CGRectMake(lblLikeCount.frame.origin.x,(btnTabFollowing.frame.origin.y+btnTabFollowing.frame.size.height+3), lblLikeCount.frame.size.width, lblLikeCount.frame.size.height);
    
    btnLikeTab.frame = CGRectMake(btnLikeTab.frame.origin.x,(btnTabFollowing.frame.origin.y+btnTabFollowing.frame.size.height+2), btnLikeTab.frame.size.width, btnLikeTab.frame.size.height);
    
    anmatidView.frame = CGRectMake(anmatidView.frame.origin.x,anmatidView.frame.origin.y, tblCreated.frame.size.width, btnLikeTab.frame.size.height+btnLikeTab.frame.origin.y+5);
    
    // Table view frames setting
    
    if(isNavigationgFirstTime){
        isNavigationgFirstTime = NO;
        tblCreated.frame = CGRectMake(tblCreated.frame.origin.x,(btnLikeTab.frame.origin.y+btnLikeTab.frame.size.height+3), tblCreated.frame.size.width, tblCreated.frame.size.height);
    }
}

-(void)viewDidUnload{
    
    [self setViewProfileUpper:nil];
    [self setBtnProfileImg:nil];
    [self setBtnFollow:nil];
    [self setBtnClngCreated:nil];
    [self setBtnClngLiked:nil];
    [self setLblUserName:nil];
    [self setLblWebSite:nil];
    [self setTxtViewBIO:nil];
    [self setLblEmail:nil];
    [self setViewMenu:nil];
    
    [self setTblCreated:nil];
    [self setLblCreatedValue:nil];
    [self setLblCreatedTabValue:nil];
    [self setLblCreatedTabValue:nil];
    [self setLblLocationName:nil];
    [self setLblFollowerCount:nil];
    [self setLblFollowingCount:nil];
    [self setBtnProfileImg:nil];
    [self setLbl1:nil];
    [self setLbl2:nil];
    [self setLbl3:nil];
    [self setLbl4:nil];
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark- TableView Delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (isLike == TRUE){
        return [arrFilterLikeChallenge count];
    }else{
        return [arrCopyCreatedChallenge count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    PFUser *objUserInfo;
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i %i",indexPath.row,indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    PFFile *teaserImage;
    
    if (isLike == TRUE) {
        objChallengeInfo = [arrFilterLikeChallenge objectAtIndex:indexPath.row];
        teaserImage = [objChallengeInfo objectForKey:@"teaserfile"];
    }
    else{
        objChallengeInfo = [arrCopyCreatedChallenge objectAtIndex:indexPath.row];
        teaserImage = [objChallengeInfo objectForKey:@"teaserfile"];
    }
    if (cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.tag = indexPath.row + 1;
        
//            objUserInfo = [objChallengeInfo objectForKey:@"userId"];
        
            obj_SearchResult_Cell = [[TimeLineCostumCell alloc] initWithNibName:@"TimeLineCostumCell" bundle:nil andD:objChallengeInfo row:indexPath.row userData:[arrFilterLikeChallenge mutableCopy]];// name:nil index:nil];
            obj_SearchResult_Cell.view.tag = indexPath.row+123123123;
            
            [cell.contentView addSubview:obj_SearchResult_Cell.view];
        
        if([[[teaserImage name] pathExtension]isEqualToString:@"mov"] || [[[teaserImage name] pathExtension]isEqualToString:@"mp4"]){
            
            MPMoviePlayerController *moviePlayer1;
            
            if(isLike == TRUE){
                moviePlayer1 = (MPMoviePlayerController *)[arrMoviePlayerObjectLike objectAtIndex:indexPath.row];
            }else{
                moviePlayer1 = (MPMoviePlayerController *)[arrMoviePlayerObjectCreated objectAtIndex:indexPath.row];
            }
            
            moviePlayer1.view.userInteractionEnabled = YES;
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(moviePlayBackDidFinish:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:moviePlayer1];
            obj_SearchResult_Cell.moviePlayer = moviePlayer1;
            
            // PLace holder image for video
            
            EGOImageView *imgFirstFrameVideoPlayer = [[EGOImageView alloc]initWithFrame:CGRectMake(0.0,0.0,moviePlayer1.view.frame.size.width, moviePlayer1.view.frame.size.height)];
            
            PFFile *videoThumbImage = [objChallengeInfo objectForKey:@"VideoThumbImage"];
            
            if([videoThumbImage url] != nil){
                imgFirstFrameVideoPlayer.imageURL = [NSURL URLWithString:[videoThumbImage url]];
            }else{
                //imgFirstFrameVideoPlayer.image = [UIImage imageNamed:@"Noimage.png"];
            }
            
            imgFirstFrameVideoPlayer.userInteractionEnabled = YES;
            [moviePlayer1.view addSubview:imgFirstFrameVideoPlayer];
            
            // Play Button
            
            UIButton *btnplay = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnplay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            [btnplay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateHighlighted];
            btnplay.tag = indexPath.row+1;
            btnplay.frame = CGRectMake(130.0,147.0,50.0,50.0);
            [btnplay addTarget:self action:@selector(playMyVideo:) forControlEvents:UIControlEventTouchUpInside];
            [imgFirstFrameVideoPlayer addSubview:btnplay];
            
            [cell.contentView addSubview:moviePlayer1.view];
            
            UIActivityIndicatorView *activitycell = [[UIActivityIndicatorView alloc] initWithFrame:moviePlayer1.view.frame];
            [cell.contentView bringSubviewToFront:activitycell];
            [cell.contentView addSubview:activitycell];
            
        }
            obj_SearchResult_Cell = nil;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isLike == TRUE){
        objChallengeInfo = [arrFilterLikeChallenge objectAtIndex:indexPath.row];
    }else{
        objChallengeInfo = [arrCopyCreatedChallenge objectAtIndex:indexPath.row];
    }
    
    NSArray *ary = [objChallengeInfo objectForKey:@"onlyComments"];
    
    NSMutableArray *arrlikes = [[NSMutableArray alloc]init];
    [arrlikes addObjectsFromArray:[objChallengeInfo objectForKey:@"likesAndComments"]];
    
    NSString *string = [objChallengeInfo objectForKey:@"tags"];
    
    CGSize stringSize = [string sizeWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    
    
    CGSize challengeNameSize=[[objChallengeInfo objectForKey:@"challengeName"]sizeWithFont:[UIFont fontWithName:@"DynoBold" size:17]constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];

    
    float height = stringSize.height;
    
    if (height < 30) {
        height = 30;
    }else{
        height = stringSize.height;
    }
    
    int txtHeight;
    
    if ([ary count] > 4){
        txtHeight = 4*20;
    }else{
        txtHeight = [ary count]*20;
    }
    if ([arrlikes count] == 0){
        if(ary.count == 0){
            return 505+height-25+txtHeight-33+30+challengeNameSize.height-25;
        }else if(ary.count == 1){
            return 505+height-33+txtHeight+5-33+30+challengeNameSize.height-25;
        }else if(ary.count == 2){
            return 505+height-33+txtHeight-33+30+challengeNameSize.height-25;
        }else if(ary.count == 3){
            return 505+height-33+txtHeight-10-33+30+challengeNameSize.height-25;
        }else if(ary.count >= 4){
            return 505+height-33+txtHeight-13-33+30+challengeNameSize.height-25;
        }
    }else{
        if(ary.count == 0){
            return 505+height-25+txtHeight+30+challengeNameSize.height-25;
        }else if(ary.count == 1){
            return 505+height-33+txtHeight+5+30+challengeNameSize.height-25;
        }else if(ary.count == 2){
            return 505+height-33+txtHeight+30+challengeNameSize.height-25;
        }else if(ary.count == 3){
            return 505+height-33+txtHeight-10+30+challengeNameSize.height-25;
        }else if(ary.count >= 4){
            return 505+height-33+txtHeight-13+30+challengeNameSize.height-25;
        }
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark Play Video

-(void)moviePlayBackDidFinish:(NSNotification*)notification {
    
    MPMoviePlayerController *moviePlayer = [notification object];
    
    EGOImageView *imgFirstFrameVideoPlayer = [[EGOImageView alloc]initWithFrame:CGRectMake(0.0,0.0,moviePlayer.view.frame.size.width, moviePlayer.view.frame.size.height)];
    
    PFFile *videoThumbImage;
    
    if(isLike == TRUE) {
        PFObject *objChallengeInfoVideoPlay = [arrFilterLikeChallenge objectAtIndex:addPlayButtonAtInadex];
        videoThumbImage = [objChallengeInfoVideoPlay objectForKey:@"VideoThumbImage"];
    }else{
        PFObject *objChallengeInfoVideoPlay = [arrCopyCreatedChallenge objectAtIndex:addPlayButtonAtInadex];
        videoThumbImage = [objChallengeInfoVideoPlay objectForKey:@"VideoThumbImage"];
    }
    
    if([videoThumbImage url] != nil){
        imgFirstFrameVideoPlayer.imageURL = [NSURL URLWithString:[videoThumbImage url]];
    }else{
        //imgFirstFrameVideoPlayer.image = [UIImage imageNamed:@"Noimage.png"];
    }
    
    imgFirstFrameVideoPlayer.userInteractionEnabled = YES;
    [moviePlayer.view addSubview:imgFirstFrameVideoPlayer];
    
    UIButton *btnplay = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnplay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [btnplay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateHighlighted];
    btnplay.tag = addPlayButtonAtInadex+1;
    [btnplay addTarget:self action:@selector(playMyVideo:) forControlEvents:UIControlEventTouchUpInside];
    btnplay.frame = CGRectMake(130.0,147.0,50.0,50.0);
    [imgFirstFrameVideoPlayer addSubview:btnplay];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
}

-(void)playMyVideo:(id)sender{
    
    UIButton *btnSender = (UIButton *)sender;
    PFFile *teaserImage;
    
    if (isLike == TRUE){
        objChallengeInfo = [arrFilterLikeChallenge objectAtIndex:btnSender.tag-1];
        teaserImage      = [objChallengeInfo objectForKey:@"teaserfile"];
    }
    else{
        objChallengeInfo = [arrCopyCreatedChallenge objectAtIndex:btnSender.tag-1];
        teaserImage      = [objChallengeInfo objectForKey:@"teaserfile"];
    }
    
    if([[[teaserImage name] pathExtension]isEqualToString:@"mov"] || [[[teaserImage name] pathExtension]isEqualToString:@"mp4"]){
        MPMoviePlayerController *localMoviePlayer;
        if(isLike == TRUE){
            for (int i = 0; i < [arrMoviePlayerObjectLike count]; i++) {
                localMoviePlayer = (MPMoviePlayerController *)[arrMoviePlayerObjectLike objectAtIndex:i];
                if (localMoviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
                    [localMoviePlayer stop];
                    break;
                }
            }
        }else{
            for (int i=0; i<[arrMoviePlayerObjectCreated count]; i++) {
                localMoviePlayer=(MPMoviePlayerController *)[arrMoviePlayerObjectCreated objectAtIndex:i];
                if (localMoviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
                    [localMoviePlayer stop];
                    break;
                }
            }
        }
                
        addPlayButtonAtInadex = btnSender.tag-1;
        
        MPMoviePlayerController *moviePlayer1;
        
        if(isLike == TRUE){
            moviePlayer1 = (MPMoviePlayerController *)[arrMoviePlayerObjectLike objectAtIndex:btnSender.tag-1];
        }else{
            moviePlayer1 = (MPMoviePlayerController *)[arrMoviePlayerObjectCreated objectAtIndex:btnSender.tag-1];
        }
                        
        [MBProgressHUD showHUDAddedTo:moviePlayer1.view animated:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:moviePlayer1];
        
        if ([[moviePlayer1.view subviews] count]>1){
            
            [[[moviePlayer1.view subviews]objectAtIndex:1] removeFromSuperview];
        }
        
        BOOL success;
        NSArray *ArrLastNameVoice=[[NSString stringWithFormat:@"%@",[teaserImage url]] componentsSeparatedByString:@"/"];
        
        NSString *strVoiceName=[ArrLastNameVoice lastObject];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",strVoiceName]];
        success = [fileManager fileExistsAtPath:writableDBPath];
        if (success){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *newPath = [directory stringByAppendingPathComponent:strVoiceName];
                [moviePlayer1 setContentURL:[NSURL fileURLWithPath:newPath isDirectory:YES]];
                [MBProgressHUD hideHUDForView:moviePlayer1.view animated:YES];
                [moviePlayer1 prepareToPlay];
                [moviePlayer1 play];
                
            });
            
        }else{
            
            NSURL *url = [NSURL URLWithString:[teaserImage url]];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:600.0f];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response,NSData *data, NSError *error) {
                if ([data length] > 0 && error == nil){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),strVoiceName];
                        [data writeToFile:filePath atomically:YES];
                        NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                        NSString *newPath = [directory stringByAppendingPathComponent:strVoiceName];
                        [moviePlayer1 setContentURL:[NSURL fileURLWithPath:newPath isDirectory:YES]];
                        [MBProgressHUD hideHUDForView:moviePlayer1.view animated:YES];
                        [moviePlayer1 prepareToPlay];
                        [moviePlayer1 play];
                        
                    });
                    
                }else if ([data length] == 0 && error == nil){
                }else if (error != nil){
                }
            }];
        }
    }
}

bool isFirstTime,isLastTime;
#pragma mark Animation Methods

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y == 0) {
        isFirstTime = NO;
    }
    if (!isFirstTime){
        if([UIScreen mainScreen].bounds.size.height == 568.0){
            [UIView beginAnimations:nil context:nil];
            
            [anmatidView setFrame:CGRectMake(0,0-btnTabCreated.origin.y, 320, btnTabCreated.frame.origin.y+btnTabCreated.frame.size.height+5)];
            if ([UIScreen mainScreen].bounds.size.height == 568.0) {
                [tblCreated setFrame:CGRectMake(0, anmatidView.origin.y+anmatidView.size.height, 320, 480)];
                
            }else{
                [tblCreated setFrame:CGRectMake(0, anmatidView.origin.y+anmatidView.size.height, 320, 450)];
            }
            [tblLike setFrame:CGRectMake(0,0, 320, 480)];
            [UIView setAnimationDuration:25.0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
           
            [UIView commitAnimations];
            isFirstTime = YES;
            
        }else{
            [UIView beginAnimations:nil context:nil];
            
            [anmatidView setFrame:CGRectMake(0,0-btnTabCreated.origin.y, 320, btnTabCreated.frame.origin.y+btnTabCreated.frame.size.height+5)];
            
            if ([UIScreen mainScreen].bounds.size.height == 568.0) {
                [tblCreated setFrame:CGRectMake(0, anmatidView.origin.y+anmatidView.size.height, 320, 480)];
                
            }else{
                [tblCreated setFrame:CGRectMake(0, anmatidView.origin.y+anmatidView.size.height, 320, 450)];
            }
            
            [tblLike setFrame:CGRectMake(0,0, 320, 435)];
            [UIView setAnimationDuration:3.0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                           
            [UIView commitAnimations];
            isFirstTime = YES;
        }
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView.contentOffset.y < 0){
        
        [UIView beginAnimations:nil context:nil];
        [anmatidView setFrame:CGRectMake(0, 64, 320, btnTabCreated.frame.origin.y+btnTabCreated.frame.size.height+5)];
        [tblCreated setFrame:CGRectMake(0,anmatidView.frame.origin.x+anmatidView.frame.size.height+64, 320, 460)];
        [tblLike setFrame:CGRectMake(0, 0, 320, 460)];
        [UIView setAnimationDuration:3.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView commitAnimations];
    }
}

#pragma mark- textview Delegate method

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
        
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
    return YES;
}

#pragma Mark - Buttons Actions

-(IBAction)btnTakeChallengePressed:(id)sender{
    [timerScrollerFlash invalidate];
    
    PFObject *objchallenge=[mutArrayCreatedChlng objectAtIndex:[sender tag]-1];
    
    ChallengeDetailViewController *chlngDetailVC = [[ChallengeDetailViewController alloc]initWithNibName:@"ChallengeDetailViewController" bundle:nil];
    chlngDetailVC.objChallengeInfo = [mutArrayCreatedChlng objectAtIndex:[sender tag]-1];
    
    PFObject *takeChallengeCount = [PFObject objectWithClassName:@"TakeChallengeCount"];
    [takeChallengeCount setObject:[objchallenge objectId] forKey:@"ChallengeId"];
    [takeChallengeCount setObject:[[PFUser currentUser]objectId] forKey:@"userId"];
    
    [takeChallengeCount saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error){
            //The gameScore saved successfully.
        } else {
            // There was an error saving the gameScore.
        }
    }];
    
    [self.navigationController pushViewController:chlngDetailVC animated:YES];
}

-(IBAction)btnCreatedPressed:(id)sender{
    
    if ([arrCopyCreatedChallenge count] == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        
         dispatch_async(kBgQueue,^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                dispatch_async(kBgQueue, ^{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // Changing selected and deselected Images
                        [btnTabCreated setImage:[UIImage imageNamed:@"selectedTab.png"] forState:UIControlStateNormal];
                        [btnTabCreated setImage:[UIImage imageNamed:@"selectedTab.png"] forState:UIControlStateHighlighted];
                        
                        [btnLikeTab setImage:[UIImage imageNamed:@"unselectedTab.png"] forState:UIControlStateNormal];
                        [btnLikeTab setImage:[UIImage imageNamed:@"unselectedTab.png"] forState:UIControlStateHighlighted];
                        
                        [lblChallengeAndLike setText:@"Challenges Created"];
                        [btnClngCreated setImage:[UIImage imageNamed:@"tabSel"] forState:UIControlStateNormal];
                        [btnClngLiked setImage:[UIImage imageNamed:@"tab"] forState:UIControlStateNormal];
                        [[NSBundle mainBundle] loadNibNamed:@"ProfileViewController" owner:self options:nil];
                        isLike=FALSE;
                        [tblCreated setHidden:NO];
                        [tblLike setHidden:YES];
                        [self viewWillAppear:TRUE];
                        [self getUserCreatedChallenge];
                        [tblCreated removeFromSuperview];
                        
                        if([UIScreen mainScreen].bounds.size.height == 568.0){
                            tblCreated = [[UITableView alloc]initWithFrame:CGRectMake(0, anmatidView.origin.y+anmatidView.size.height, 320, 568)];
                        }else{
                            tblCreated = [[UITableView alloc]initWithFrame:CGRectMake(0, anmatidView.origin.y+anmatidView.size.height, 320, 480)];
                        }
                        
                        anmatidView.frame = CGRectMake(anmatidView.frame.origin.x,anmatidView.frame.origin.y, tblCreated.frame.size.width, btnLikeTab.frame.size.height+btnLikeTab.frame.origin.y+5);
                        
                        [tblCreated setDelegate:self];
                        [tblCreated setDataSource:self];
                        [self.view addSubview:tblCreated];
                        [tblCreated reloadData];
                        
                    });
                });
            });
        });
    }else{
        [btnTabCreated setImage:[UIImage imageNamed:@"selectedTab.png"] forState:UIControlStateNormal];
        [btnTabCreated setImage:[UIImage imageNamed:@"selectedTab.png"] forState:UIControlStateHighlighted];
        
        [btnLikeTab setImage:[UIImage imageNamed:@"unselectedTab.png"] forState:UIControlStateNormal];
        [btnLikeTab setImage:[UIImage imageNamed:@"unselectedTab.png"] forState:UIControlStateHighlighted];
        
        isLike = FALSE;
        [lblChallengeAndLike setText:@"Challenges Created"];
        [tblCreated removeFromSuperview];
        
        if([UIScreen mainScreen].bounds.size.height == 568.0){
            tblCreated = [[UITableView alloc]initWithFrame:CGRectMake(0, anmatidView.origin.y+anmatidView.size.height, 320, 568)];
        }else{
            tblCreated = [[UITableView alloc]initWithFrame:CGRectMake(0, anmatidView.origin.y+anmatidView.size.height, 320, 480)];
        }
        
        anmatidView.frame = CGRectMake(anmatidView.frame.origin.x,anmatidView.frame.origin.y, tblCreated.frame.size.width, btnLikeTab.frame.size.height+btnLikeTab.frame.origin.y+5);
        
        [tblCreated setDelegate:self];
        [tblCreated setDataSource:self];
        [self.view addSubview:tblCreated];
        [tblCreated reloadData];
    }
}

-(IBAction)btnLikedPressed:(id)sender{
    
    [btnClngCreated setImage:[UIImage imageNamed:@"tab"] forState:UIControlStateNormal];
    [btnClngLiked setImage:[UIImage imageNamed:@"tabSel"] forState:UIControlStateNormal];
    isLike=TRUE;
    [tblCreated setHidden:YES];
    [tblLike setHidden:NO];
    [tblLike reloadData];
}

-(IBAction)btnSharePressed:(id)sender{
    
    UIButton *btnSender = (UIButton *)sender;
    buttonIndexForShareDataOnSocial = btnSender.tag-1;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share Challenge"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"Facebook"];
    [actionSheet addButtonWithTitle:@"Twitter"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.destructiveButtonIndex = 2;
    actionSheet.tag = 20;
    [actionSheet showInView:self.view.window];
}

-(IBAction)btnBlockedPressed:(id)sender{
    
    [self getBlockUsers];
    
    if ([arrBlockUserData count]>0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Block user"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        [actionSheet addButtonWithTitle:@"UnBlock this user"];
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.destructiveButtonIndex = 1;
        [actionSheet showInView:self.view.window];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Block user"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        [actionSheet addButtonWithTitle:@"Block this user"];
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.destructiveButtonIndex = 1;
        [actionSheet showInView:self.view.window];
    }
}

-(void)getBlockUsers{
    
    PFQuery *queryForBlockUser=[PFQuery queryWithClassName:@"tbl_BlockedUser"];
    [queryForBlockUser whereKey:@"blockedUserId" equalTo:[profileUser objectId]];
    arrBlockUserData=[[NSMutableArray alloc]initWithArray:[queryForBlockUser findObjects]];
}

#pragma mark ActionSheet Delegate
//Action sheet for Image Capturing

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //For Camera
    
    if(actionSheet.tag == 11){
        
        if (buttonIndex == 1){
            [tblCreated beginUpdates];
            [objChallengeInfo delete];
            [mutArrayCreatedChlng removeObjectAtIndex:buttonTagForDeleteChallenge];
            [tblCreated reloadData];
        }
        if (buttonIndex == 0){
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *emailController = [[MFMailComposeViewController alloc] init];
                emailController.mailComposeDelegate = self;
                NSString *subject=@"FeedBack";
                NSString *mailBody=@"";
                NSArray *recipients=[[NSArray alloc] initWithObjects:@"Feedback@FitTagApp.com", nil];
                
                [emailController setSubject:subject];
                [emailController setMessageBody:mailBody isHTML:YES];
                [emailController setToRecipients:recipients];
                
                [self presentViewController:emailController animated:TRUE completion:nil];
            }
        }
    }else if(actionSheet.tag == 10){
        if (buttonIndex == 0){
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *emailController = [[MFMailComposeViewController alloc] init];
                emailController.mailComposeDelegate = self;
                NSString *subject=@"FeedBack";
                NSString *mailBody=@"";
                NSArray *recipients=[[NSArray alloc] initWithObjects:@"Feedback@FitTagApp.com", nil];
                
                [emailController setSubject:subject];
                [emailController setMessageBody:mailBody isHTML:YES];
                [emailController setToRecipients:recipients];
                
                [self presentViewController:emailController animated:TRUE completion:nil];
            }
        }
    }else if(actionSheet.tag == 20){
        switch (buttonIndex){
            case 0:{
                
                if([[[NSUserDefaults standardUserDefaults]objectForKey:@"facebookShare"] isEqualToString:@"ON"]){
                    [self postToFcaebookUsersWall:buttonIndexForShareDataOnSocial];
                }else{
                    DisplayAlertWithTitle(@"FitTag", @"You have off your share setting for Facebook, Please switch it on in order to share on Facebook.")
                }
                break;
            }
            case 1:{
                
              /*  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"FitTag" message:@"OOPS ! Sorry for inconvenience. We are having some problems with twitter for now. We are working hard to solve the issue. We will get back to you soon." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];*/
                
                // Twitter Temporary block
                
                
                if([[[NSUserDefaults standardUserDefaults]objectForKey:@"twitterShare"] isEqualToString:@"ON"]){
                    
                    if([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]){
                        [self postToTwitterAsTwitt:buttonIndexForShareDataOnSocial];
                    }else{
                        [PFTwitterUtils linkUser:[PFUser currentUser] block:^(BOOL isLinked,NSError *userLinkedError){
                            if(!userLinkedError){
                                [self postToTwitterAsTwitt:buttonIndexForShareDataOnSocial];
                            }else{
                                DisplayAlertWithTitle(@"FitTag", @"There is some problem occur. Please try again")
                            }
                        }];
                    }
                }else{
                    DisplayAlertWithTitle(@"FitTag", @"You have off your share setting for Twitter, Please switch it on in order to share on Twitter.")
                }
                break;
            }
            default:
                break;
        }
    }else{
        if ([arrBlockUserData count]>0){
             if (buttonIndex == 0){
            PFObject *obj=[arrBlockUserData objectAtIndex:0];
                 [obj delete];
             }
        }else{
            if (buttonIndex == 0){
                PFObject *objBlockUser=[PFObject objectWithClassName:@"tbl_BlockedUser"];
                [objBlockUser setObject:[[PFUser currentUser]objectId] forKey:@"blockByUserId"];
                [objBlockUser setObject:[profileUser objectId] forKey:@"blockedUserId"];
                [objBlockUser save];
            }
        }
    }
}

#pragma mark Sharing methods

-(void)postToFcaebookUsersWall:(int )index{
    
    if (isLike == TRUE) {
        objChallengeInfo = [arrFilterLikeChallenge objectAtIndex:buttonIndexForShareDataOnSocial];
    }else{
        objChallengeInfo = [arrCopyCreatedChallenge objectAtIndex:buttonIndexForShareDataOnSocial];
    }
        
    PFFile *teaserImage = [objChallengeInfo objectForKey:@"teaserfile"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"FitTag", @"name",
                                   [objChallengeInfo objectForKey:@"challengeName"], @"caption",
                                   [objChallengeInfo objectForKey:@"tags"], @"description",
                                   [NSString stringWithFormat:@"http://www.fittag.com/challenge_details.php?id=%@",objChallengeInfo.objectId], @"link",
                                   nil];
    
    if([[[teaserImage name] pathExtension]isEqualToString:@"mov"] || [[[teaserImage name] pathExtension]isEqualToString:@"mp4"]){
        [params setObject:[teaserImage url] forKey:@"video"];
    }else{
        [params setObject:[teaserImage url] forKey:@"picture"];
    }
    
    if([PFFacebookUtils session].state == FBSessionStateOpen){
        
        // Invoke the dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:[PFFacebookUtils session]
                                               parameters:params
                                                  handler:
         ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
             if (error) {
                 // Case A: Error launching the dialog or publishing story.
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             }else{
                 if (result == FBWebDialogResultDialogNotCompleted) {
                     // Case B: User clicked the "x" icon
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                 }else{
                     // Case C: Dialog shown and the user clicks Cancel or Share
                     NSDictionary *urlParams;// = [self parseURLParams:[resultURL query]];
                     if (![urlParams valueForKey:@"post_id"]) {
                         // User clicked the Cancel button
                         //[MBProgressHUD hideHUDForView:self.view animated:YES];
                     } else {
                         // User clicked the Share button
                         //[MBProgressHUD hideHUDForView:self.view animated:YES];
                         // NSString *postID = [urlParams valueForKey:@"post_id"];
                     }
                 }
             }
         }];
    }else{
        [PFFacebookUtils linkUser:[PFUser currentUser] permissions:FB_PERMISSIONS block:^(BOOL Success,NSError *errorLink){
            
            if(!errorLink){
                [FBWebDialogs presentFeedDialogModallyWithSession:[PFFacebookUtils session]
                                                       parameters:params
                                                          handler:
                 ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                     if (error) {
                         // Case A: Error launching the dialog or publishing story.
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                     } else {
                         if (result == FBWebDialogResultDialogNotCompleted) {
                             // Case B: User clicked the "x" icon
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                         } else {
                             // Case C: Dialog shown and the user clicks Cancel or Share
                             NSDictionary *urlParams;// = [self parseURLParams:[resultURL query]];
                             if (![urlParams valueForKey:@"post_id"]) {
                                 // User clicked the Cancel button
                             } else {
                                 // User clicked the Share button
                                 //  NSString *postID = [urlParams valueForKey:@"post_id"];
                             }
                         }
                     }
                 }];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"FitTag" message:[errorLink description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

#pragma mark Posting on Twitter

-(void)postToTwitterAsTwitt:(int)index{
    
    // Test code for Twitter image posting
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (isLike == TRUE){
        objChallengeInfo = [arrFilterLikeChallenge objectAtIndex:buttonIndexForShareDataOnSocial];
    }else{
        objChallengeInfo=[arrCopyCreatedChallenge objectAtIndex:buttonIndexForShareDataOnSocial];
    }
    
    NSString *status = @"Check out this challenge from #FitTag by downloading the FitTag App ";
    
    NSString *boundary = @"cce6735153bf14e47e999e68bb183e70a1fa7fc89722fc1efdf03a917340";
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add status param
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"status\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", status] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    
    PFFile *teaserImage = [objChallengeInfo objectForKey:@"teaserfile"];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[teaserImage url]]];
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"media[]\"; filename=\"media.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set URL
    [request setURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update_with_media.json"]];
    
    [[PFTwitterUtils twitter] signRequest:request];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(!error){
            //NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }else{
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark-Mail Controller Delegate Method
// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
    // Notifies users about errors associated with the interface
    switch (result){
            
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
        }
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Navigation Menu
-(IBAction)btnMenuProfilePressed:(id)sender{
    if (!isOpen) {
        [self viewMenuOpenAnim];
    }else{
        [self viewMenuCloseAnim];
    }
}

-(IBAction)btnHomePressed:(id)sender{
    [timerScrollerFlash invalidate];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         //self.viewHome.frame = CGRectMake(0,10, self.viewHome.frame.size.width,176);
                         // sleep(0.1);
                         self.viewMenu.frame = CGRectMake(0,-176, self.viewMenu.frame.size.width,176);
                         isOpen=NO;
                     } completion:^(BOOL finished) {
                         [self.viewMenu removeFromSuperview];
                         
                         NSArray *array = [self.navigationController viewControllers];
                         for(int i=0;i<array.count;i++){
                             if([[array objectAtIndex:i] isKindOfClass:[TimeLineViewController class]]){
                                 [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
                                 break;
                             }
                         }
    }];
}

-(IBAction)btnSettingPressed:(id)sender{
    [timerScrollerFlash invalidate];
    
    [timerScrollerFlash invalidate];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         self.viewMenu.frame = CGRectMake(0,-176, self.viewMenu.frame.size.width,176);
                         isOpen=NO;
                     } completion:^(BOOL finished) {
                         [self.viewMenu removeFromSuperview];
                         bool isContain=NO;
                         NSArray *array = [self.navigationController viewControllers];
                         for(int i=0;i<array.count;i++){
                             if([[array objectAtIndex:i] isKindOfClass:[SettingViewController class]]){
                                 [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
                                 isContain=YES;
                                 break;
                             }
                         }
                         if(!isContain){
                             SettingViewController *settingVC=[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
                             settingVC.title=@"Settings";
                             [self.navigationController pushViewController:settingVC animated:YES];
                         }
                     }];
}

-(IBAction)btnActivityPressed:(id)sender{
    [timerScrollerFlash invalidate];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         
                         self.viewMenu.frame = CGRectMake(0,-176, self.viewMenu.frame.size.width,176);
                         isOpen=NO;
                     } completion:^(BOOL finished) {
                         [self.viewMenu removeFromSuperview];
                         bool isContain=NO;
                         NSArray *array = [self.navigationController viewControllers];
                         for(int i=0;i<array.count;i++){
                             if([[array objectAtIndex:i] isKindOfClass:[ActivityViewController class]]){
                                 [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
                                 isContain=YES;
                                 break;
                             }
                         }
                         if(!isContain){
                             ActivityViewController *activtyVC  =[[ActivityViewController alloc]initWithNibName:@"ActivityViewController" bundle:nil];
                             activtyVC.title=@"Activity";
                             [self.navigationController pushViewController:activtyVC animated:YES];
                         }
                     }];
}

-(void)viewMenuCloseAnim{
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         self.viewMenu.frame = CGRectMake(0,-176, self.viewMenu.frame.size.width,176);
                         isOpen=NO;
                     } completion:^(BOOL finished) {
                         [self.viewMenu removeFromSuperview];
                         
    }];
}

-(void)viewMenuOpenAnim{
    
    [self.view addSubview:viewMenu];
    viewMenu.frame=CGRectMake(0, -176, self.viewMenu.frame.size.width, 176);
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         self.viewMenu.frame = CGRectMake(0,64, self.viewMenu.frame.size.width,176);
                         isOpen=YES;
                     } completion:^(BOOL finished) {
                         
    }];
}

#pragma menu - own methods

-(void)getUserCreatedChallenge{
    
    if (self.profileUser == nil){
        PFQuery *queryForFollowers = [PFQuery queryWithClassName:@"Tbl_follower"];
        
        [queryForFollowers whereKey:@"CurrentUserId" equalTo:[[PFUser currentUser]objectId]];
        [queryForFollowers includeKey:@"followerUser"];
        [queryForFollowers includeKey:@"userId"];
        temparrFollower=[[NSMutableArray alloc]initWithArray:[[queryForFollowers findObjects] mutableCopy]];
        
        NSMutableArray *tempArray1 = [[NSMutableArray alloc]init];
        for (int i = 0; i < [temparrFollower count];i++){
            
            PFObject  *obj=[temparrFollower objectAtIndex:i];
            PFUser *createdUserchallenge=[obj objectForKey:@"userId"];
           
            NSString *strUserId=[createdUserchallenge objectId];
            if([arrBlockUsers containsObject:strUserId]){
            }else{
                [tempArray1 addObject:[temparrFollower objectAtIndex:i]];
            }
        }
        [temparrFollower removeAllObjects];
        temparrFollower=tempArray1;
        lblFollowingCount.text=[NSString stringWithFormat:@"%d",[temparrFollower count]];
        
        if ([temparrFollower count] == 0){
            [btnTabFollowing setHidden:TRUE];
        }else{
            [btnTabFollowing setHidden:FALSE];
        }
        
        PFQuery *queryForFollowing=[PFQuery queryWithClassName:@"Tbl_follower"];
        
        [queryForFollowing whereKey:@"follower_id" equalTo:[[PFUser currentUser]objectId]];
        [queryForFollowing includeKey:@"followerUser"];
        [queryForFollowing includeKey:@"userId"];
        temparrFollowing=[[NSMutableArray alloc]initWithArray:[[queryForFollowing findObjects] mutableCopy]];
        
        NSMutableArray *tempArray2=[[NSMutableArray alloc]init];
        for (int i = 0; i < [temparrFollowing count];i++){
            
            PFObject  *obj=[temparrFollowing objectAtIndex:i];
            PFUser *createdUserchallenge=[obj objectForKey:@"userId"];
            NSString *strUserId=[createdUserchallenge objectId];
            if([arrBlockUsers containsObject:strUserId]){
            }else{
                [tempArray2 addObject:[temparrFollowing objectAtIndex:i]];
            }
        }
        [temparrFollowing removeAllObjects];
        temparrFollowing=tempArray2;
        
        lblFollowerCount.text=[NSString stringWithFormat:@"%d",[temparrFollowing count]];
        
        if ([temparrFollowing count]==0) {
            [btnTabFollower setHidden:TRUE];
        }else{
            [btnTabFollower setHidden:FALSE];
        }
        
        PFQuery *queryForLike=[PFQuery queryWithClassName:@"tbl_Likes"];
        [queryForLike whereKey:@"LikeuserId" equalTo:[[PFUser currentUser]objectId]];
        NSMutableArray *temparrLike=[[NSMutableArray alloc]initWithArray:[[queryForLike findObjects] mutableCopy]];
        lblLikeCount.text=[NSString stringWithFormat:@"%d",[temparrLike count]];
        
        if ([temparrLike count]==0){
            btnLikeTab.enabled = NO;
            //[btnLikeTab setHidden:TRUE];
        }else{
            btnLikeTab.enabled = YES;
            //[btnLikeTab setHidden:FALSE];
        }
    }else{
        
        PFQuery *queryForFollowers=[PFQuery queryWithClassName:@"Tbl_follower"];
        [queryForFollowers whereKey:@"CurrentUserId" equalTo:[self.profileUser objectId]];
        [queryForFollowers includeKey:@"followerUser"];
        
        temparrFollower = [[NSMutableArray alloc]initWithArray:[[queryForFollowers findObjects] mutableCopy]];
        NSMutableArray *tempArray1=[[NSMutableArray alloc]init];
        for (int i = 0; i < [temparrFollower count];i++){
            
            PFObject  *obj=[temparrFollower objectAtIndex:i];
            PFUser *createdUserchallenge=[obj objectForKey:@"userId"];
            NSString *strUserId=[createdUserchallenge objectId];
            if([arrBlockUsers containsObject:strUserId]){
            }else{
                [tempArray1 addObject:[temparrFollower objectAtIndex:i]];
            }
        }
        [temparrFollower removeAllObjects];
        temparrFollower=tempArray1;
        
        lblFollowingCount.text=[NSString stringWithFormat:@"%d",[temparrFollower count]];
        
        if ([temparrFollower count] == 0) {
            [btnTabFollowing setHidden:TRUE];
        }else{
            [btnTabFollowing setHidden:FALSE];
        }
        PFQuery *queryForFollowing = [PFQuery queryWithClassName:@"Tbl_follower"];
        
        [queryForFollowing whereKey:@"follower_id" equalTo:[self.profileUser objectId]];
        [queryForFollowing includeKey:@"followerUser"];
        [queryForFollowing includeKey:@"userId"];
        temparrFollowing = [[NSMutableArray alloc]initWithArray:[[queryForFollowing findObjects] mutableCopy]];
        
        NSMutableArray *tempArray2=[[NSMutableArray alloc]init];
        for (int i = 0; i < [temparrFollowing count];i++){
            PFObject *obj = [temparrFollowing objectAtIndex:i];
            PFUser *createdUserchallenge = [obj objectForKey:@"userId"];
            NSString *strUserId=[createdUserchallenge objectId];
            if([arrBlockUsers containsObject:strUserId]){
            }else{
                [tempArray2 addObject:[temparrFollowing objectAtIndex:i]];
            }
        }
        [temparrFollowing removeAllObjects];
        temparrFollowing=tempArray2;
        lblFollowerCount.text=[NSString stringWithFormat:@"%d",[temparrFollowing count]];
        
        if ([temparrFollowing count]==0) {
            [btnTabFollower setHidden:TRUE];
        }else{
            [btnTabFollower setHidden:FALSE];
        }
        PFQuery *queryForLike=[PFQuery queryWithClassName:@"tbl_Likes"];
        [queryForLike whereKey:@"LikeuserId" equalTo:[self.profileUser objectId]];
        NSMutableArray *temparrLike=[[NSMutableArray alloc]initWithArray:[[queryForLike findObjects] mutableCopy]];
        lblLikeCount.text=[NSString stringWithFormat:@"%d",[temparrLike count]];
        if ([temparrLike count]==0) {
            btnLikeTab.enabled = NO;
            //[btnLikeTab setHidden:TRUE];
        }else{
            btnLikeTab.enabled = YES;
            //[btnLikeTab setHidden:FALSE];
        }
    }
    
    //Create query for all Post object by the current user
    if ([arrCopyCreatedChallenge count] == 0){
        PFQuery *postQuery = [PFQuery queryWithClassName:@"Challenge"];
        [postQuery addDescendingOrder:@"createdAt"];
        [postQuery includeKey:@"userId"];
        if(profileUser==nil){
            [postQuery whereKey:@"userId" equalTo:[PFUser currentUser]];
        }else{
            [postQuery whereKey:@"userId" equalTo:profileUser];
        }
        PFQuery *query = [PFQuery queryWithClassName:@"tbl_Likes"];
        [query whereKey:@"ChallengeId" matchesQuery:postQuery];
        // Run the query
        [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                //Save results and update the table
                
                mutArrayCreatedChlng = [[NSMutableArray alloc]initWithArray:objects];
                
                for (int j=0; j<[mutArrayCreatedChlng count]; j++) {
                    objChallengeInfo=[mutArrayCreatedChlng objectAtIndex:j];
                    PFUser *createdUser=[objChallengeInfo objectForKey:@"userId"];
                    PFQuery *queryForLikeComment=[PFQuery queryWithClassName:@"tbl_Likes"];
                    [queryForLikeComment whereKey:@"ChallengeId" equalTo:[objChallengeInfo objectId]];
                    [queryForLikeComment includeKey:@"userId"];
                    [queryForLikeComment addDescendingOrder:@"createdAt"];
                    NSMutableArray *arrAllData=[[NSMutableArray alloc]initWithArray:[[queryForLikeComment findObjects] mutableCopy]];
                    
                    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
                    
                    for (int k=0; k<[arrAllData count]; k++) {
                        PFObject *objLike=[arrAllData objectAtIndex:k];
                        PFUser *user=[objLike objectForKey:@"userId"];
                        if ([[user username]isEqualToString:[[PFUser currentUser]username]]) {
                            [tempArray insertObject:[arrAllData objectAtIndex:k] atIndex:0];
                        }
                        else{
                            [tempArray addObject:[arrAllData objectAtIndex:k]];
                        }
                        
                    }
                    
                    if ([tempArray count]>0) {
                        [objChallengeInfo addObjectsFromArray:tempArray forKey:@"likesAndComments"];
                    }
                    
                    
                    PFQuery *queryForLikeComment1=[PFQuery queryWithClassName:@"tbl_comments"];
                    [queryForLikeComment1 whereKey:@"ChallengeId" equalTo:[objChallengeInfo objectId]];
                    [queryForLikeComment1 includeKey:@"userId"];
                    //[queryForLikeComment1 setLimit:4];
                    [queryForLikeComment1 addDescendingOrder:@"createdAt"];
                    
                    NSMutableArray *arrAllData1=[[NSMutableArray alloc]initWithArray:[[queryForLikeComment1 findObjects] mutableCopy]];
                    if ([arrAllData1 count]>0) {
                        [objChallengeInfo addObjectsFromArray:arrAllData1 forKey:@"onlyComments"];
                    }
                    if ([[createdUser objectId] isEqualToString:[[PFUser currentUser]objectId]]) {
                    }
                }
            }
            
            [lblCreatedValue setText:[NSString stringWithFormat:@"%d",mutArrayCreatedChlng.count]];
            
            arrCopyCreatedChallenge = [[NSMutableArray alloc]initWithArray:mutArrayCreatedChlng];
            
            // Add movie player in the movie added
            
            [arrMoviePlayerObjectCreated removeAllObjects];
            for (int i=0; i < [arrCopyCreatedChallenge count]; i++){
                MPMoviePlayerController *moviePlayer1 = [[MPMoviePlayerController alloc] init];
                [moviePlayer1 setControlStyle:MPMovieControlStyleDefault];
                [moviePlayer1.view setUserInteractionEnabled:YES];
                [moviePlayer1.view setFrame:CGRectMake(5, 37, 310 , 324)];
                moviePlayer1.movieSourceType = MPMovieSourceTypeFile;
                moviePlayer1.view.hidden = NO;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(moviePlayBackDidFinish:)
                                                             name:MPMoviePlayerPlaybackDidFinishNotification
                                                           object:moviePlayer1];
                moviePlayer1.controlStyle=MPMovieControlStyleNone;
                [arrMoviePlayerObjectCreated addObject:moviePlayer1];
            }
            
            if ([mutArrayCreatedChlng count] == 0){
                btnTabCreated.enabled = NO;
                //[btnTabCreated setHidden:TRUE];
            }else{
                btnTabCreated.enabled = YES;
                //[btnTabCreated setHidden:FALSE];
            }
            
            [tblCreated reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }

    if([UIScreen mainScreen].bounds.size.height == 568.0){
        tblCreated.frame = CGRectMake(0, anmatidView.origin.y+anmatidView.size.height, 320, 568);
    }else{
        tblCreated.frame = CGRectMake(0, anmatidView.origin.y+anmatidView.size.height, 320, 480);
    }
    
    anmatidView.frame = CGRectMake(anmatidView.frame.origin.x,anmatidView.frame.origin.y, tblCreated.frame.size.width, btnLikeTab.frame.size.height+btnLikeTab.frame.origin.y+5);

    
    if(!isFirstload){
        dispatch_async(dispatch_get_main_queue(),^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
}

-(IBAction)btnFollowerTapPressed:(id)sender{
    [timerScrollerFlash invalidate];
    
    LikerListViewController *objLike = [[LikerListViewController alloc]initWithNibName:@"LikerListViewController" bundle:nil];
    objLike.title=@"Followers";
    objLike.arrLikerList=temparrFollowing;
    NSLog(@"%@",temparrFollower);
    objLike.isFollower=TRUE;
    objLike.isLike=FALSE;
    [self.navigationController pushViewController:objLike animated:TRUE];

}

-(IBAction)btnFollowingTapPressed:(id)sender{
    
    [timerScrollerFlash invalidate];
    LikerListViewController *objLike=[[LikerListViewController alloc]initWithNibName:@"LikerListViewController" bundle:nil];
    objLike.arrLikerList=temparrFollower;
    objLike.title=@"Following";
    objLike.isFollower=FALSE;
    objLike.isLike=FALSE;
    [self.navigationController pushViewController:objLike animated:TRUE];
    
}

-(void)getUserLikeChallenge{
    
    isLike = TRUE;
    [mutArrayCreatedChlng removeAllObjects];
    mutArrayCreatedChlng = nil;
    mutArrayCreatedChlng = [[NSMutableArray alloc]init];
    PFQuery *queryForLikeComment = [PFQuery queryWithClassName:@"tbl_Likes"];
    
    if(profileUser == nil){
        [queryForLikeComment whereKey:@"LikeuserId" equalTo:[[PFUser currentUser]objectId]];;
    }else{
        [queryForLikeComment whereKey:@"LikeuserId" equalTo:[profileUser objectId]];
    }
    
    [queryForLikeComment includeKey:@"userId"];
    [queryForLikeComment addDescendingOrder:@"createdAt"];
    NSMutableArray *arrAllData=[[NSMutableArray alloc]initWithArray:[[queryForLikeComment findObjects] mutableCopy]];
    
    for (int h = 0; h < [arrAllData count]; h++) {
        PFObject *objLike=[arrAllData objectAtIndex:h];
        
        PFQuery *postQuery = [PFQuery queryWithClassName:@"Challenge"];
        [postQuery whereKey:@"objectId" equalTo:[objLike objectForKey:@"ChallengeId"]];
        [postQuery addDescendingOrder:@"createdAt"];
        [postQuery includeKey:@"userId"];
        
        // Run the query
        NSMutableArray *tempArray=[[NSMutableArray alloc]initWithArray:[postQuery findObjects]];
        
        //Save results and update the table
        
        for (int j=0; j<[tempArray count]; j++) {
            objChallengeInfo = [tempArray objectAtIndex:j];
            PFUser *createdUser=[objChallengeInfo objectForKey:@"userId"];
            PFQuery *queryForLikeComment=[PFQuery queryWithClassName:@"tbl_Likes"];
            [queryForLikeComment whereKey:@"ChallengeId" equalTo:[objChallengeInfo objectId]];
            [queryForLikeComment includeKey:@"userId"];
            [queryForLikeComment addDescendingOrder:@"createdAt"];
            NSMutableArray *arrAllData=[[NSMutableArray alloc]initWithArray:[[queryForLikeComment findObjects] mutableCopy]];
            
            NSMutableArray *tempArray=[[NSMutableArray alloc]init];
            
            for (int k=0; k<[arrAllData count]; k++) {
                PFObject *objLike=[arrAllData objectAtIndex:k];
                PFUser *user=[objLike objectForKey:@"userId"];
                if ([[user username]isEqualToString:[[PFUser currentUser]username]]) {
                    [tempArray insertObject:[arrAllData objectAtIndex:k] atIndex:0];
                    
                }
                else{
                    [tempArray addObject:[arrAllData objectAtIndex:k]];
                }
            }
            
            if ([tempArray count]>0) {
                [objChallengeInfo addObjectsFromArray:tempArray forKey:@"likesAndComments"];
            }
            
            PFQuery *queryForLikeComment1=[PFQuery queryWithClassName:@"tbl_comments"];
            [queryForLikeComment1 whereKey:@"ChallengeId" equalTo:[objChallengeInfo objectId]];
            [queryForLikeComment1 includeKey:@"userId"];
            [queryForLikeComment1 addDescendingOrder:@"createdAt"];
            
            NSMutableArray *arrAllData1=[[NSMutableArray alloc]initWithArray:[[queryForLikeComment1 findObjects] mutableCopy]];
            if ([arrAllData1 count]>0) {
                [objChallengeInfo addObjectsFromArray:arrAllData1 forKey:@"onlyComments"];
            }
            
            if ([[createdUser objectId] isEqualToString:[[PFUser currentUser]objectId]]) {
            }
 
        }
        
        if ([tempArray count]>0) {
            [mutArrayCreatedChlng addObject:objChallengeInfo];
        }
        
    }
    NSMutableArray *tempArray1=[[NSMutableArray alloc]init];
    for (int i = 0; i < [mutArrayCreatedChlng count];i++){
        
        objChallengeInfo=[mutArrayCreatedChlng objectAtIndex:i];
        PFUser *createdUserchallenge=[objChallengeInfo objectForKey:@"userId"];
        NSString *strUserId=[createdUserchallenge objectId];
        if([arrBlockUsers containsObject:strUserId]){
        }else{
            [tempArray1 addObject:[mutArrayCreatedChlng objectAtIndex:i]];
        }
    }
    [mutArrayCreatedChlng removeAllObjects];
    mutArrayCreatedChlng=tempArray1;
    
    dispatch_async(dispatch_get_main_queue(),^{
        [MBProgressHUD hideHUDForView:self.view animated:TRUE];
        [lblLikeChallengeCount setText:[NSString stringWithFormat:@"%d",mutArrayCreatedChlng.count]];
        lblLikeCount.text=[NSString stringWithFormat:@"%d",[mutArrayCreatedChlng count]];
        arrFilterLikeChallenge=mutArrayCreatedChlng;
        
        [arrMoviePlayerObjectLike removeAllObjects];
        for (int i=0; i<[arrFilterLikeChallenge count]; i++)
        {
            MPMoviePlayerController *moviePlayer1 = [[MPMoviePlayerController alloc] init];
            [moviePlayer1 setControlStyle:MPMovieControlStyleDefault];
            [moviePlayer1.view setUserInteractionEnabled:YES];
            [moviePlayer1.view setFrame:CGRectMake(5, 37, 310 , 324)];
            moviePlayer1.movieSourceType = MPMovieSourceTypeFile;
            moviePlayer1.view.hidden = NO;
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(moviePlayBackDidFinish:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:moviePlayer1];
            moviePlayer1.controlStyle = MPMovieControlStyleNone;
            [arrMoviePlayerObjectLike addObject:moviePlayer1];
        }
        
        [tblCreated reloadData];
    });
}

-(IBAction)btnHeaderbackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Like and comments methods

-(IBAction)likeChallenge:(id)sender{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    
    PFUser *user;
    PFObject *obj;
    
    if(isLike == TRUE){
        objChallengeInfo=[arrFilterLikeChallenge objectAtIndex:[sender tag]-1];
    }else{
        objChallengeInfo=[mutArrayCreatedChlng objectAtIndex:[sender tag]-1];
    }
    
    PFQuery *queryForLikeComment=[PFQuery queryWithClassName:@"tbl_Likes"];
    [queryForLikeComment whereKey:@"ChallengeId" equalTo:[objChallengeInfo objectId]];
    [queryForLikeComment includeKey:@"userId"];
    [queryForLikeComment addDescendingOrder:@"createdAt"];
    NSMutableArray *arrAllData=[[NSMutableArray alloc]initWithArray:[queryForLikeComment findObjects]];
    
    if ([arrAllData count]==0) {
        IsLiked=NO;
    }
    
    for (int i=0; i<[arrAllData count]; i++) {
        obj=[arrAllData objectAtIndex:i];
        user=[obj objectForKey:@"userId"];
        
        if ([[user username] isEqualToString:[[PFUser currentUser] username]]) {
            
            IsLiked=YES;
            break;
        
        }
    }
    
    if (IsLiked==YES) {
        IsLiked=NO;
      //  if ([[user username] isEqualToString:[[PFUser currentUser] username]]) {
        [obj delete];
         if (isLike==TRUE) {
          //   [arrFilterLikeChallenge removeObjectAtIndex:[sender tag]-1];
         }
        NSMutableArray *arr=[[NSMutableArray alloc]initWithArray:[objChallengeInfo objectForKey:@"likesAndComments"]];
        for (int i=0; i<[arr count]; i++) {
            PFObject *objLikes=[arr objectAtIndex:i];
            if ([[objLikes objectForKey:@"LikeuserId"]isEqualToString:[obj objectForKey:@"LikeuserId"]]) {
                [arr removeObjectAtIndex:i];
            }
            
        }
        [objChallengeInfo removeObjectForKey:@"likesAndComments"];
        [objChallengeInfo addObjectsFromArray:arr forKey:@"likesAndComments"];
        
            UITableViewCell *cell1=[tblCreated cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag]-1 inSection:0]];
            NSArray *arry = [cell1.contentView subviews];
            for (UIView *view in arry)
            {
                if ([view isKindOfClass:[UIView class]])
                {
                    NSArray  *ViewSub = [view subviews];
                    for (UITextView *txtView in ViewSub)
                    {
                        if ([txtView isKindOfClass:[UITextView class]])
                        {
                            if (txtView.tag == [sender tag])
                            {
                                if ([txtView.text isEqualToString:@"You Like this"]) {
                                    
                                    txtView.text= [txtView.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"You Like this"] withString:@"Be the first person to like this!!!"];
                                }else{
                                    
                                    txtView.text= [txtView.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"You,"] withString:@""];
                                }
                            }
                            
                        }
                    }
                }
            }
        [MBProgressHUD hideHUDForView:self.view animated:TRUE];
            cell1=nil;
        [tblCreated removeFromSuperview];
        tblCreated=[[UITableView alloc]initWithFrame:CGRectMake(0, 25, 320, 435)];
        [tblCreated setDelegate:self];
        [tblCreated setDataSource:self];
        [self.view addSubview:tblCreated];
        [self.tblCreated scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:[sender tag]-1 inSection:0] atScrollPosition: UITableViewScrollPositionTop animated: NO];
        //}
    }
    else{
        
        if (isLike==TRUE) {
            objChallengeInfo=[arrFilterLikeChallenge objectAtIndex:[sender tag]-1];
        }
        else{
            objChallengeInfo=[mutArrayCreatedChlng objectAtIndex:[sender tag]-1];
        }
        
        PFObject *like = [PFObject objectWithClassName:@"tbl_Likes"];
        PFUser *OwnerUSer=[objChallengeInfo objectForKey:@"userId"];
        [like setObject:[PFUser currentUser] forKey:@"userId"];
        [like setObject:[[PFUser currentUser]objectId] forKey:@"LikeuserId"];
        [like setObject:[objChallengeInfo objectId] forKey:@"ChallengeId"];
        
        [like setObject:[OwnerUSer objectId] forKey:@"CreateduserId"];
        PFFile *teaserImage = [objChallengeInfo objectForKey:@"teaserfile"];
        [like setObject:teaserImage forKey:@"teaserfile"];
        
        
        //Set ACL permissions for added security
        PFACL *commentACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [commentACL setPublicReadAccess:YES];
        [like setACL:commentACL];
        [like saveInBackgroundWithBlock:^(BOOL Done, NSError *error){
            
            if (Done)
            {
                if (isLike==TRUE) {
                    
                    objChallengeInfo=[arrFilterLikeChallenge objectAtIndex:[sender tag]-1];
                }
                else{
                    objChallengeInfo=[mutArrayCreatedChlng objectAtIndex:[sender tag]-1];
                }
                PFQuery *queryForLikeComment=[PFQuery queryWithClassName:@"tbl_Likes"];
                [queryForLikeComment whereKey:@"ChallengeId" equalTo:[objChallengeInfo objectId]];
                [queryForLikeComment includeKey:@"userId"];
                [queryForLikeComment addDescendingOrder:@"createdAt"];
                NSMutableArray *arrAllData=[[NSMutableArray alloc]initWithArray:[queryForLikeComment findObjects]];
                PFObject *obj=[arrAllData objectAtIndex:0];
                PFUser *user=[obj objectForKey:@"userId"];
                if ([[user username] isEqualToString:[[PFUser currentUser] username]]) {
                    IsLiked = YES;
                    
                    [objChallengeInfo removeObjectForKey:@"likesAndComments"];
                    [objChallengeInfo addObjectsFromArray:arrAllData forKey:@"likesAndComments"];
                    if ([objChallengeInfo objectForKey:@"likesAndComments"]) {
                     //   [arrFilterLikeChallenge addObject:objChallengeInfo];
                        [tblCreated removeFromSuperview];

                        if([UIScreen mainScreen].bounds.size.height == 568.0){
                            tblCreated = [[UITableView alloc]initWithFrame:CGRectMake(0, anmatidView.origin.y+anmatidView.size.height, 320, 568)];
                        }else{
                            tblCreated = [[UITableView alloc]initWithFrame:CGRectMake(0, anmatidView.origin.y+anmatidView.size.height, 320, 480)];
                        }
 
                        anmatidView.frame = CGRectMake(anmatidView.frame.origin.x,anmatidView.frame.origin.y, tblCreated.frame.size.width, btnLikeTab.frame.size.height+btnLikeTab.frame.origin.y+5);

                        
                        //tblCreated = [[UITableView alloc]initWithFrame:CGRectMake(0, 25, 320, 435)];
                        [tblCreated setDelegate:self];
                        [tblCreated setDataSource:self];
                        [self.tblCreated scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:[sender tag]-1 inSection:0] atScrollPosition: UITableViewScrollPositionTop animated: NO];
                        [self.view addSubview:tblCreated];
                    }

                }
                UITableViewCell *cell1=[tblCreated cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag]-1 inSection:0]];
                NSArray *arry = [cell1.contentView subviews];
                for (UIView *view in arry)
                {
                    if ([view isKindOfClass:[UIView class]])
                    {
                        NSArray * ViewSub = [view subviews];
                        for (UITextView *txtView in ViewSub)
                        {
                            if ([txtView isKindOfClass:[UITextView class]])
                            {
                                if (txtView.tag == [sender tag])
                                {
                                    if ([[user username] isEqualToString:[[PFUser currentUser] username]]) {
                                        
                                        if ([txtView.text isEqualToString:@"Be the first person to like this!!!"]) {
                                            txtView.text = [NSString stringWithFormat:@"You %@",@"Like this"];
                                        }else{
                                            txtView.text = [NSString stringWithFormat:@"You,%@",txtView.text];
                                        }
                                    }
                                    else{
                                        txtView.text = [NSString stringWithFormat:@"%@,%@",[user username],txtView.text];
                                    }
                                }
                            }
                        }
                    }
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:TRUE];
            }
        }];
    }
}

-(IBAction)btnCommentPressed:(id)sender{
    
    CommentViewController *commentVC=[[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
    commentVC.title = @"Comment";
    commentSenderTag = [sender tag];

    if (isLike == TRUE) {
        objChallengeInfo = [arrFilterLikeChallenge objectAtIndex:[sender tag]-1];
    }else{
        objChallengeInfo = [mutArrayCreatedChlng objectAtIndex:[sender tag]-1];
    }
    
    UITableViewCell *cell1 = [tblCreated cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag]-1 inSection:0]];
    NSArray *arry = [cell1.contentView subviews];
    for (UIView *view in arry)
    {
        if ([view isKindOfClass:[UIView class]])
        {
            NSArray * ViewSub = [view subviews];
            for (UILabel *lbl in ViewSub)
            {
                if ([lbl isKindOfClass:[UILabel class]])
                {
                    if (lbl.tag == [sender tag]+211){
                        lblComment = lbl;
                    }
                    if (lbl.tag == [sender tag]+212){
                        lblComment2 = lbl ;
                    }
                    
                    if (lbl.tag == [sender tag]+213){
                        lblComment3 = lbl ;
                    }
                    if (lbl.tag == [sender tag]+214){
                        lblComment4 = lbl ;
                    }
                }
            }
            
            for (UIButton *btnCmnt2 in ViewSub){
                if ([btnCmnt2 isKindOfClass:[UIButton class]]){
                    if (btnCmnt2.tag == [sender tag]+111){
                        btnComment1 = btnCmnt2;
                    }
                    if (btnCmnt2.tag == [sender tag]+112){
                        btnComment2 = btnCmnt2 ;
                    }
                    if (btnCmnt2.tag == [sender tag]+113){
                        btnComment3 = btnCmnt2 ;
                    }
                    if (btnCmnt2.tag == [sender tag]+114){
                        btnComment4 = btnCmnt2 ;
                    }
                }
            }
        }
    }
    commentVC.isTakeChallenge = FALSE;
    commentVC.challengeId = [objChallengeInfo objectId];
    commentVC.objchallenge = objChallengeInfo;
    commentVC.ChallengeOwner = [objChallengeInfo objectForKey:@"userId"];
    commentVC.strChaleengeName = [objChallengeInfo objectForKey:@"challengeName"];
    [self.navigationController pushViewController:commentVC animated:YES];
}

-(IBAction)btnOlderCommentPressed:(id)sender{
    [timerScrollerFlash invalidate];
    CommentViewController *commentVC=[[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
    commentVC.title=@"Comment";
    commentSenderTag =[sender tag];
    if (isLike == TRUE) {
        objChallengeInfo=[arrFilterLikeChallenge objectAtIndex:[sender tag]-1];
    }else{
        objChallengeInfo=[mutArrayCreatedChlng objectAtIndex:[sender tag]-1];
    }
    UITableViewCell *cell1=[tblCreated cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag]-1 inSection:0]];
    NSArray *arry = [cell1.contentView subviews];
    for (UIView *view in arry){
        if ([view isKindOfClass:[UIView class]]){
            NSArray * ViewSub = [view subviews];
            for (UILabel *lbl in ViewSub){
                if ([lbl isKindOfClass:[UILabel class]]){
                    if (lbl.tag == [sender tag]+211){
                        lblComment = lbl;
                    }
                    if (lbl.tag == [sender tag]+212){
                        lblComment2 = lbl ;
                    }
                    if (lbl.tag == [sender tag]+213){
                        lblComment3 = lbl ;
                    }
                    if (lbl.tag == [sender tag]+214){
                        lblComment4 = lbl ;
                    }
                }
            }
            for (UIButton *btnCmnt2 in ViewSub){
                if ([btnCmnt2 isKindOfClass:[UIButton class]]){
                    if (btnCmnt2.tag == [sender tag]+111){
                        btnComment1 = btnCmnt2 ;
                    }
                    if (btnCmnt2.tag == [sender tag]+112){
                        btnComment2 = btnCmnt2 ;
                    }
                    if (btnCmnt2.tag == [sender tag]+113){
                        btnComment3 = btnCmnt2 ;
                    }
                    if (btnCmnt2.tag == [sender tag]+114){
                        btnComment4 = btnCmnt2 ;
                    }
                }
            }
        }
    }
    commentVC.isTakeChallenge = FALSE;
    commentVC.challengeId=[objChallengeInfo objectId];
    [self.navigationController pushViewController:commentVC animated:YES];
}

-(void)getCommentsInMainView123:(id)sender{
    if(isLike == TRUE){
        if(commentSenderTag > 0){
            objChallengeInfo = [arrFilterLikeChallenge objectAtIndex:commentSenderTag-1];
        }else{
             objChallengeInfo = [arrFilterLikeChallenge objectAtIndex:commentSenderTag];
        }
    }else{
        if(commentSenderTag > 0){
            objChallengeInfo = [mutArrayCreatedChlng objectAtIndex:commentSenderTag-1];
        }else{
            objChallengeInfo = [mutArrayCreatedChlng objectAtIndex:commentSenderTag];
        }
    }
    PFQuery *queryForLikeComment1 = [PFQuery queryWithClassName:@"tbl_comments"];
    [queryForLikeComment1 whereKey:@"ChallengeId" equalTo:[objChallengeInfo objectId]];
    [queryForLikeComment1 includeKey:@"userId"];
    [queryForLikeComment1 addDescendingOrder:@"createdAt"];
    NSMutableArray *arrAllData1 = [[NSMutableArray alloc]initWithArray:[[queryForLikeComment1 findObjects] mutableCopy]];
    [objChallengeInfo removeObjectForKey:@"onlyComments"];
    [objChallengeInfo addObjectsFromArray:arrAllData1 forKey:@"onlyComments"];
    [arrFilterLikeChallenge insertObject:objChallengeInfo atIndex:commentSenderTag-1];
    [tblCreated reloadData];
    [tblLike reloadData];
}
-(void)commentbackAction123{
    [self.tblCreated scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:commentSenderTag-1 inSection:0] atScrollPosition: UITableViewScrollPositionTop animated: YES];
    [self.tblCreated beginUpdates];
    [[NSBundle mainBundle] loadNibNamed:@"ProfileViewController" owner:self options:nil];
    [self.tblCreated scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:commentSenderTag-1 inSection:0] atScrollPosition: UITableViewScrollPositionTop animated: NO];
}
-(IBAction)btnLikeTabPressed:(id)sender{
    if ([arrFilterLikeChallenge count] == 0){
        dispatch_async(kBgQueue,^{
            dispatch_async(dispatch_get_main_queue(),^{
                [lblChallengeAndLike setText:@"Challenges Liked"];
              // Changing the images according to selection of buttons
                [btnLikeTab setImage:[UIImage imageNamed:@"selectedTab.png"] forState:UIControlStateNormal];
                [btnLikeTab setImage:[UIImage imageNamed:@"selectedTab.png"] forState:UIControlStateHighlighted];
                [btnTabCreated setImage:[UIImage imageNamed:@"unselectedTab.png"] forState:UIControlStateNormal];
                [btnTabCreated setImage:[UIImage imageNamed:@"unselectedTab.png"] forState:UIControlStateHighlighted];
                [tblCreated removeFromSuperview];
                if([UIScreen mainScreen].bounds.size.height == 568.0){
                    tblCreated = [[UITableView alloc]initWithFrame:CGRectMake(0, anmatidView.origin.y+anmatidView.size.height, 320, 568)];
                }else{
                    tblCreated = [[UITableView alloc]initWithFrame:CGRectMake(0, anmatidView.origin.y+anmatidView.size.height, 320, 480)];
                }
                anmatidView.frame = CGRectMake(anmatidView.frame.origin.x,anmatidView.frame.origin.y, tblCreated.frame.size.width, btnLikeTab.frame.size.height+btnLikeTab.frame.origin.y+5);
                [tblCreated setDelegate:self];
                [tblCreated setDataSource:self];
                [self.view addSubview:tblCreated];
                [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
                dispatch_async(kBgQueue,^{
                    [self getUserLikeChallenge];
                });
            });
        });
    }
    else{
        isLike=TRUE;
        // Changing the images according to selection of buttons
        [btnLikeTab setImage:[UIImage imageNamed:@"selectedTab.png"] forState:UIControlStateNormal];
        [btnLikeTab setImage:[UIImage imageNamed:@"selectedTab.png"] forState:UIControlStateHighlighted];
        [btnTabCreated setImage:[UIImage imageNamed:@"unselectedTab.png"] forState:UIControlStateNormal];
        [btnTabCreated setImage:[UIImage imageNamed:@"unselectedTab.png"] forState:UIControlStateHighlighted];
        [lblChallengeAndLike setText:@"Challenges Liked"];
        [tblCreated removeFromSuperview];
        if([UIScreen mainScreen].bounds.size.height == 568.0){
            tblCreated = [[UITableView alloc]initWithFrame:CGRectMake(0, anmatidView.origin.y+anmatidView.size.height, 320, 568)];
        }else{
            tblCreated = [[UITableView alloc]initWithFrame:CGRectMake(0, anmatidView.origin.y+anmatidView.size.height, 320, 480)];
        }
        anmatidView.frame = CGRectMake(anmatidView.frame.origin.x,anmatidView.frame.origin.y, tblCreated.frame.size.width, btnLikeTab.frame.size.height+btnLikeTab.frame.origin.y+5);
        [tblCreated setDelegate:self];
        [tblCreated setDataSource:self];
        [self.view addSubview:tblCreated];
        [tblCreated reloadData];
    }
}

-(IBAction)btnReportPressed:(id)sender{
    
    //objChallengeInfo=[arrUserData objectAtIndex:[sender tag]-1];
    objChallengeInfo=[mutArrayCreatedChlng objectAtIndex:[sender tag]-1];
    PFUser  *createdUser123=[objChallengeInfo objectForKey:@"userId"];
    buttonTagForDeleteChallenge=[sender tag]-1;
    if ([[createdUser123 username]isEqualToString:[[PFUser currentUser]username]]){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Report  Challenge" delegate:self cancelButtonTitle:nil  destructiveButtonTitle:nil otherButtonTitles:nil];
        [actionSheet addButtonWithTitle:@"Report this Challenge"];
        [actionSheet addButtonWithTitle:@"Delete this challenge"];
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.destructiveButtonIndex = 0;
        actionSheet.tag = 11;
        [actionSheet showInView:self.view.window];
    }
    else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Report  Challenge" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        [actionSheet addButtonWithTitle:@"Report this Challenge"];
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.destructiveButtonIndex = 1;
        actionSheet.tag = 10;
        [actionSheet showInView:self.view.window];
    }
}
-(IBAction)btnOpenUrlClicked:(id)sender{
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:lblWebSite.text]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:lblWebSite.text]];
    }else{
        DisplayAlertWithTitle(@"FitTag", @"Invalid url, we are unable to open the url")
    }
}
-(void)draftViewButtonPressed:(id)sender{
    [timerScrollerFlash invalidate];
    DraftViewcontrollerViewController *draftVC = [[DraftViewcontrollerViewController alloc]initWithNibName:@"DraftViewcontrollerViewController" bundle:nil];
    [self.navigationController pushViewController:draftVC animated:YES];
}
#pragma mark dynamic description height
-(void)clickOnHashTags :(NSNotification *)notification{
    TimeLineViewController_copy *timelineTagVC = [[TimeLineViewController_copy alloc]initWithNibName:@"TimeLineViewController_copy" bundle:nil];
    timelineTagVC.title = [notification object];
    timelineTagVC.strSelectedTag = [notification object];
    [self.navigationController pushViewController:timelineTagVC animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clickOnHashTagsProfile" object:nil];
}
-(void)userLikeNameButton :(NSNotification *)notification{
    [NSThread detachNewThreadSelector:@selector(selfActivities) toTarget:self withObject:nil];
    NSString *name= [notification object];
    NSString *newStr=name;
    if ([name hasPrefix:@","]) {
        newStr = [name substringFromIndex:1];
    }
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:newStr];
    NSArray *arr = [[NSArray alloc]initWithArray:[query findObjects]];
    PFUser *user = [arr objectAtIndex:0];
    ProfileViewController *obProfile = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    obProfile.profileUser = user;
    obProfile.title = @"Profile";
    [self.navigationController pushViewController:obProfile animated:TRUE];
    [MBProgressHUD hideHUDForView:self.view animated:TRUE];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userLikeNameButtonProfile" object:nil];
}
-(void)selfActivities{
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
}
@end
