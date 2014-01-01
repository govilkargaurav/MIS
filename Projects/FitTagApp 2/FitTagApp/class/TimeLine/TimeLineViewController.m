//
//  TimeLineViewController.m
//  FitTagApp
//
//  Created by apple on 2/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.


#import "TimeLineViewController.h"
#import "ProfileViewController.h"
#import "ActivityViewController.h"
#import "CommentViewController.h"
#import "CreateChlng1ViewController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "SearchChngCell.h"
#import "TimeLineCostumCell.h"
#import "GlobalClass.h"
#import "ChallengeDetailViewController.h"
#import "AppUtilityClass.h"
#import "LikerListViewController.h"
#import "TimeLineViewController_copy.h"

static char * const myIndexPathAssociationKey = "Gaurav";

#define kStringArray [NSArray arrayWithObjects:@"Home", @"Profile",@"Activity",@"Setting", nil]

@implementation TimeLineViewController

@synthesize tblTimeline;
@synthesize viewHome;
@synthesize isOpen;
@synthesize _dictDddAvtar;
@synthesize _dictprofileImage;
@synthesize mAryCommentChallenge;
@synthesize activityIndicator,activityIndicatorView,footerActivityIndicator;
@synthesize strSelectedTag;
@synthesize lblNoRec;
int skipIndex = 0;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
#pragma mark - View lifecycle
-(void)viewDidLoad{
    
    // Make Timeline as root view controller
    self.navigationController.viewControllers = [[NSArray alloc]initWithObjects:self,nil];
    arrMoviePlayerObject = [[NSMutableArray alloc]init];
    /* This notification get called from comment View to get latest Comment on feed Cell */
    isPullToRefresh = NO;
    cellBtnTag = 0;
    SingTimeRefresh = YES;
    buttonIndexForShareDataOnSocial = 0;
    
    appdelegateRef = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    arrUserData  = [[NSMutableArray alloc]init];
    arrIndexPath = [[NSMutableArray alloc]init];
    /* This arr we will use for paging response */
    mutArrPagingResponce=[[NSMutableArray alloc] init];
    arrCurrentUserChallenges=[[NSMutableArray alloc]init];
    /* This is pull to refresh method  for TimeLine Screen */
    
    [self setNavigationComponent];
    temparrFollowing=[[NSMutableArray alloc]init];
    isOpen=NO;
    [self getBlockUsers];
    if ([stringWithNIBLoad isEqualToString:@"YES"]) {
        dispatch_async(kBgQueue,^{
            [self getMYFollowers];
            // This Method fetchout all the Likes and Comments from database Table.
        });
    }
    
    arrClickUserLikeChallenge = [[NSMutableArray alloc]init];
    
    arrhudPlace = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCommentsInMainView:) name:@"comments" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentbackAction) name:@"commentbackAction" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    
    appdelegateRef.controllerName=@"TimeLineViewController";
    self.navigationController.navigationBar.translucent = YES;
    //Draft query will fetch all draft challenge which current user saved in drafts
    PFQuery *draftQuery = [PFQuery queryWithClassName:@"ChallengeDrafts"];
    [draftQuery whereKey:@"userId" equalTo:[PFUser currentUser]];
    [draftQuery countObjectsInBackgroundWithBlock:^(int count,NSError *countingError){
        if(!countingError){
            if(count > 0){
                imgViewPencil.hidden = NO;
            }
        }
    }];
    
    // Remove all old step data once leave the step view
    [appdelegateRef.mutArryChallengeImageData removeAllObjects];
    [appdelegateRef.mutArryChallengeStepsData removeAllObjects];
    
    if ([appdelegateRef.arrUserFirstChallenge count] > 0){
        [self addFirstChallenge];
    }
    //At selected notifcation will fire when user click on @usename
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(atSelectedAtTag) name:@"userLikeNameButtonTimeLinecopy" object:nil];
    //At selected notifcation will fire when user click on #tag
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickOnHashTags:) name:@"clickOnHashTags" object:nil];
    //At selected notifcation will fire when user click on @usename in like sections
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLikeNameButton:) name:@"userLikeNameButton" object:nil];
    for(UIView* view in self.navigationController.navigationBar.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
    }
    appdelegateRef.isTimeline=TRUE;
    [super viewWillAppear:animated];
    //Add pull to refersh in timeline view controller
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tblTimeline.bounds.size.height, self.view.frame.size.width, self.tblTimeline.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    _refreshHeaderView.backgroundColor=[UIColor clearColor];
    [self.tblTimeline addSubview:_refreshHeaderView];
    [self.tblTimeline bringSubviewToFront:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    if(self.viewHome.frame.origin.y == 44){
        [self viewHomeCloseAnim];
    }
}
-(void)viewDidUnload{
    
    [self setTblTimeline:nil];
    [self setViewHome:nil];
    [self setLblNoRec:nil];
    [super viewDidUnload];
}
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
-(void)egoRefreshTableHeaderDidTriggerRefresh1:(EGORefreshTableHeaderView*)view{
	
	[self refreshPull];
}
-(BOOL)egoRefreshTableHeaderDataSourceIsLoading1:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
}
-(NSDate*)egoRefreshTableHeaderDataSourceLastUpdated1:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}
-(void)refreshPull{
    
    dispatch_async(kBgQueue,^{
        isPullToRefresh=YES;
        _reloading = YES;
        //This method will fetch all the block user which are block by current user so current user will not get post of blocked user
        [self getBlockUsers];
        //This method will Fetch all the followers of current user
        [self getMYFollowers];
        dispatch_async(dispatch_get_main_queue(),^{
            [self performSelector:@selector(updateUIandReloadViews:) withObject:nil];
        });
    });
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}
#pragma mark
#pragma mark Fetch all followes of logged in user
-(void)getMYFollowers{
    PFQuery *queryForFollowing=[PFQuery queryWithClassName:@"Tbl_follower"];
    [queryForFollowing whereKey:@"CurrentUserId" equalTo:[[PFUser currentUser]objectId]];
    [queryForFollowing includeKey:@"followerUser"];
    [queryForFollowing includeKey:@"userId"];
    temparrFollowing=[[NSMutableArray alloc]initWithArray:[[queryForFollowing findObjects] mutableCopy]];
    [self getUserAndChallengeDate];
}
#pragma mark
#pragma mark Fetch all Challenges likes and comments of cuerrent user's followes in user
-(void)getUserAndChallengeDate{
    @try {
        SingTimeRefresh = YES;
        NSMutableArray *arrObjects=[[NSMutableArray alloc]init];
        NSMutableString *string=[[NSMutableString alloc]init];
        [temparrFollowing addObject:[PFUser currentUser]];
        PFUser *createdUserchallenge1;
        for (int i=0; i<[temparrFollowing count]; i++) {
            PFObject  *obj=[temparrFollowing objectAtIndex:i];
            if ([obj isKindOfClass:[PFUser class]]) {
                createdUserchallenge1=[PFUser currentUser];
            }else{
                createdUserchallenge1=[obj objectForKey:@"followerUser"];
            }
            
            if (createdUserchallenge1) {
                [arrObjects addObject:createdUserchallenge1];
                if (i!=[temparrFollowing count]-1) {
                    [string appendFormat:@"%%@,"];
                }else{
                    [string appendFormat:@"%%@"];
                }
            }
            
        }
        NSPredicate *predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userId IN {%@}",string] argumentArray:arrObjects];
        PFQuery *postQuery = [PFQuery queryWithClassName:@"Challenge" predicate:predicate];
        [postQuery addDescendingOrder:@"createdAt"];
        [postQuery includeKey:@"userId"];
        BOOL isScrollingTable = NO;
        if(isPullToRefresh){
            isScrollingTable = NO;
            isPullToRefresh = NO;
            [postQuery setSkip:0];
            [postQuery setSkip:0];
            [postQuery setLimit:[arrUserData count]];
        }else{
            isScrollingTable = YES;
            [postQuery setSkip:[arrUserData count]+skipIndex];
            [postQuery setLimit:5];
        }
        
        if ([temparrFollowing count]>0) {
            mutArrPagingResponce = [[postQuery findObjects] mutableCopy];
        }
        
        
        for (int i = 0; i < [mutArrPagingResponce count];i++){
            objChallengeInfo = [mutArrPagingResponce objectAtIndex:i];
            
            PFUser *createdUserchallenge = [objChallengeInfo objectForKey:@"userId"];
            if(i == 0 && isScrollingTable == NO){
                
                [arrUserData removeAllObjects];
            }
            NSString *strUserId = [createdUserchallenge objectId];
            
            if([arrLocal containsObject:strUserId]){
                skipIndex = skipIndex+1;
            }else{
                [arrUserData addObject:[mutArrPagingResponce objectAtIndex:i]];
            }
        }
        [arrCurrentUserChallenges removeAllObjects];
        
        for (int j = 0; j<[mutArrPagingResponce count]; j++) {
            objChallengeInfo = [mutArrPagingResponce objectAtIndex:j];
            PFUser *createdUserNew=[objChallengeInfo objectForKey:@"userId"];
            PFQuery *queryForLikeComment=[PFQuery queryWithClassName:@"tbl_Likes"];
            [queryForLikeComment whereKey:@"ChallengeId" equalTo:[objChallengeInfo objectId]];
            [queryForLikeComment includeKey:@"userId"];
            [queryForLikeComment addDescendingOrder:@"createdAt"];
            NSMutableArray *arrAllData = [[NSMutableArray alloc]initWithArray:[[queryForLikeComment findObjects] mutableCopy]];
            
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
            
            if ([objChallengeInfo objectForKey:@"likesAndComments"]) {
                [arrClickUserLikeChallenge addObject:objChallengeInfo];
            }
            if ([[createdUserNew objectId] isEqualToString:[[PFUser currentUser]objectId]]) {
                [arrCurrentUserChallenges addObject:objChallengeInfo];
            }
        }
        appdelegateRef.arrCurrentUserChallegesData=arrCurrentUserChallenges;
        dispatch_async(dispatch_get_main_queue(),^{
            if(arrUserData.count == 0){
                [lblNoRec setHidden:NO];
            }else{
                [lblNoRec setHidden:YES];
                [tblTimeline setTableFooterView:nil];
                [self stopAnimation];
                for (int i = 0; i < [mutArrPagingResponce count]; i++)
                {
                    MPMoviePlayerController *moviePlayer1 = [[MPMoviePlayerController alloc] init];
                    [moviePlayer1 setControlStyle:MPMovieControlStyleDefault];
                    [moviePlayer1.view setUserInteractionEnabled:YES];
                    [moviePlayer1.view setFrame:CGRectMake(5, 37, 310 , 324)];
                    moviePlayer1.movieSourceType = MPMovieSourceTypeFile;
                    moviePlayer1.view.hidden = NO;
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer1];
                    moviePlayer1.controlStyle=MPMovieControlStyleNone;
                    [arrMoviePlayerObject addObject:moviePlayer1];
                }
                
                [tblTimeline reloadData];
                [tblTimeline setHidden:NO];
                SingTimeRefresh=NO;
                _reloading = NO;
                [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tblTimeline];
            }
        });
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
}
#pragma mark
#pragma mark Fetch all Blocked user of current in user
-(void)getBlockUsers{
    @try {
        arrLocal = [[NSMutableArray alloc]init];
        PFQuery *queryForBlockUser = [PFQuery queryWithClassName:@"tbl_BlockedUser"];
        [queryForBlockUser whereKey:@"blockByUserId" equalTo:[[PFUser currentUser]objectId]];
        NSMutableArray *arrBlockUsers=[[NSMutableArray alloc]initWithArray:[queryForBlockUser findObjects]];
        for (int a=0; a<[arrBlockUsers count]; a++) {
            PFObject *objBlockUser=[arrBlockUsers objectAtIndex:a];
            [arrLocal addObject:[objBlockUser objectForKey:@"blockedUserId"]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
}
#pragma mark- TableView Delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrUserData count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i %i",indexPath.row,indexPath.section];
    if (![arrIndexPath containsObject:indexPath]) {
        [arrIndexPath addObject:indexPath];
    }
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.tag = indexPath.row + 1;
        objChallengeInfo = [arrUserData objectAtIndex:indexPath.row];
        PFFile *teaserImage = [objChallengeInfo objectForKey:@"teaserfile"];
        obj_SearchResult_Cell = [[TimeLineCostumCell alloc] initWithNibName:@"TimeLineCostumCell" bundle:nil andD:objChallengeInfo row:indexPath.row userData:[arrUserData mutableCopy]];
        obj_SearchResult_Cell.delegate = self;
        obj_SearchResult_Cell.view.tag = indexPath.row+123123123;
        [cell.contentView addSubview:obj_SearchResult_Cell.view];
        if([[[teaserImage name] pathExtension]isEqualToString:@"mov"] || [[[teaserImage name] pathExtension]isEqualToString:@"mp4"]){
            MPMoviePlayerController *moviePlayer1 = (MPMoviePlayerController *)[arrMoviePlayerObject objectAtIndex:indexPath.row];
            moviePlayer1.view.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer1];
            obj_SearchResult_Cell.moviePlayer = moviePlayer1;
            // Remove previouslly added placeholder Video image from movie player
            for (int i = 0; i < [[moviePlayer1.view subviews]count]; i++) {
                if([[[moviePlayer1.view subviews]objectAtIndex:i] isKindOfClass:[EGOImageView class]]){
                    [[[moviePlayer1.view subviews]objectAtIndex:i] removeFromSuperview];
                }
            }
            // Place holder image for video
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
            UIActivityIndicatorView *activitycell =[[UIActivityIndicatorView alloc] initWithFrame:moviePlayer1.view.frame];
            [cell.contentView bringSubviewToFront:activitycell];
            [cell.contentView addSubview:activitycell];
        }
        obj_SearchResult_Cell = nil;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    objChallengeInfo=[arrUserData objectAtIndex:indexPath.row];
    NSArray *ary=[objChallengeInfo objectForKey:@"onlyComments"];
    NSString *string = [objChallengeInfo objectForKey:@"tags"];
    
    NSMutableArray *arrlikes=[[NSMutableArray alloc]init];
    [arrlikes addObjectsFromArray:[objChallengeInfo objectForKey:@"likesAndComments"]];
    
    CGSize stringSize = [string sizeWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    CGSize challengeNameSize=[[objChallengeInfo objectForKey:@"challengeName"]sizeWithFont:[UIFont fontWithName:@"DynoBold" size:17]constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    float height = stringSize.height;
    
    if (height<30){
        height = 30;
    }else{
        height=stringSize.height;
    }
    int txtHeight;
    
    if ([ary count]>4) {
        txtHeight = 4*20;
    }else{
        txtHeight=[ary count]*20;
    }
    
    if ([arrlikes count] == 0) {
        if(ary.count == 0){
            return 505+height-25+txtHeight-33+challengeNameSize.height-15;
        }else if(ary.count == 1){
            return 505+height-33+txtHeight+5-33+challengeNameSize.height-15;
        }else if(ary.count == 2){
            return 505+height-33+txtHeight-33+challengeNameSize.height-15;
        }else if(ary.count == 3){
            return 505+height-33+txtHeight-33+challengeNameSize.height-15;
        }else if(ary.count >= 4){
            return 505+height-33+txtHeight-13-33+challengeNameSize.height-15;
        }
    }else{
        if(ary.count == 0){
            return 505+height-25+txtHeight+challengeNameSize.height-15;
        }else if(ary.count == 1){
            return 505+height-33+txtHeight+5+challengeNameSize.height-15;
        }else if(ary.count == 2){
            return 505+height-33+txtHeight+challengeNameSize.height-15;
        }else if(ary.count == 3){
            return 505+height-33+txtHeight-10+challengeNameSize.height-15;
        }else if(ary.count >= 4){
            return 505+height-33+txtHeight-13+challengeNameSize.height-15;
        }
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark
#pragma mark Vedio playing methods
-(void)moviePlayBackDidFinish:(NSNotification*)notification {
    
    MPMoviePlayerController *moviePlayer = [notification object];
    
    EGOImageView *imgFirstFrameVideoPlayer = [[EGOImageView alloc]initWithFrame:CGRectMake(0.0,0.0,moviePlayer.view.frame.size.width, moviePlayer.view.frame.size.height)];
    
    PFObject *objChallengeInfoVideoPlay = [arrUserData objectAtIndex:addPlayButtonAtInadex];
    PFFile *videoThumbImage = [objChallengeInfoVideoPlay objectForKey:@"VideoThumbImage"];
    
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
    
    objChallengeInfo = [arrUserData objectAtIndex:btnSender.tag-1];
    PFFile *teaserImage = [objChallengeInfo objectForKey:@"teaserfile"];
    
    if([[[teaserImage name] pathExtension]isEqualToString:@"mov"] || [[[teaserImage name] pathExtension]isEqualToString:@"mp4"]){
        
        for (int i = 0; i < [arrMoviePlayerObject count]; i++) {
            MPMoviePlayerController *localMoviePlayer = (MPMoviePlayerController *)[arrMoviePlayerObject objectAtIndex:i];
            if (localMoviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
                [localMoviePlayer stop];
                break;
            }
        }
        
        addPlayButtonAtInadex = btnSender.tag-1;
        
        MPMoviePlayerController *moviePlayer1 = (MPMoviePlayerController *)[arrMoviePlayerObject objectAtIndex:btnSender.tag-1];
        [MBProgressHUD showHUDAddedTo:moviePlayer1.view animated:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:moviePlayer1];
        
        if ([[moviePlayer1.view subviews] count] > 1){
            for (int i = 0; i < [[moviePlayer1.view subviews] count];i++){
                if([[[moviePlayer1.view subviews]objectAtIndex:i] isKindOfClass:[EGOImageView class]]){
                    [[[moviePlayer1.view subviews]objectAtIndex:i] removeFromSuperview];
                }else{
                    //Don't have EGOImageView as super view
                }
            }
        }
        
        BOOL success;
        NSArray *ArrLastNameVoice = [[NSString stringWithFormat:@"%@",[teaserImage url]] componentsSeparatedByString:@"/"];
        
        NSString *strVoiceName = [ArrLastNameVoice lastObject];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",strVoiceName]];
        success = [fileManager fileExistsAtPath:writableDBPath];
        if (success){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *newPath = [directory stringByAppendingPathComponent:strVoiceName];
                //moviePlayer1.movieSourceType = MPMovieSourceTypeStreaming;
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
                        // moviePlayer1.movieSourceType = MPMovieSourceTypeFile;
                        [moviePlayer1 setContentURL:[NSURL fileURLWithPath:newPath isDirectory:YES]];
                        [MBProgressHUD hideHUDForView:moviePlayer1.view animated:YES];
                        [moviePlayer1 prepareToPlay];
                        [moviePlayer1 play];
                        
                    });
                    
                } else if ([data length] == 0 && error == nil){
                    
                    
                } else if (error != nil){
                    
                    
                }
            }];
            
        }
    }
}
#pragma mark
#pragma mark Button Actions
-(IBAction)btnReportPressed:(id)sender{
    
    objChallengeInfo=[arrUserData objectAtIndex:[sender tag]-1];
    PFUser  *createdUser123=[objChallengeInfo objectForKey:@"userId"];
    buttonTagForDeleteChallenge=[sender tag]-1;
    if ([[createdUser123 username]isEqualToString:[[PFUser currentUser]username]]){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Report Challenge"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        [actionSheet addButtonWithTitle:@"Report this Challenge"];
        [actionSheet addButtonWithTitle:@"Delete this challenge"];
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.destructiveButtonIndex = 0;
        
        actionSheet.tag = 11;
        [actionSheet showInView:self.view.window];
    }
    else{
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Report Challenge"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        [actionSheet addButtonWithTitle:@"Report this Challenge"];
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.destructiveButtonIndex = 1;
        actionSheet.tag = 10;
        [actionSheet showInView:self.view.window];
    }
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
    
    //    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Standard UIActionSheet" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Emphasis" otherButtonTitles:@"Other", @"Buttons", nil];
    //    [actionSheet showInView:self.view.window];
    
}
-(IBAction)unlikeChallenge:(id)sender{
    
}
-(IBAction)btnTakeChallengePressed:(id)sender{
    
    PFObject *objchallenge=[arrUserData objectAtIndex:[sender tag]-1];
    
    ChallengeDetailViewController *chlngDetailVC=[[ChallengeDetailViewController alloc]initWithNibName:@"ChallengeDetailViewController" bundle:nil];
    chlngDetailVC.objChallengeInfo=[arrUserData objectAtIndex:[sender tag]-1];
    
    PFObject *takeChallengeCount = [PFObject objectWithClassName:@"TakeChallengeCount"];
    [takeChallengeCount setObject:[objchallenge objectId] forKey:@"ChallengeId"];
    [takeChallengeCount setObject:[[PFUser currentUser]objectId] forKey:@"userId"];
    
    [takeChallengeCount saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The gameScore saved successfully.
        } else {
            // There was an error saving the gameScore.
        }
    }];
    
    [self.navigationController pushViewController:chlngDetailVC animated:YES];
}
-(IBAction)likeChallenge:(id)sender{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    [self performSelectorInBackground:@selector(LikeChallangeMode:) withObject:sender];
}
-(IBAction)likerBtnPresseb:(id)sender{
    
    objChallengeInfo=[arrUserData objectAtIndex:[sender tag]-1];
    
    NSMutableArray *arrLikers=[[NSMutableArray alloc]initWithArray:[objChallengeInfo objectForKey:@"likesAndComments"]];
    LikerListViewController *OBJLikerListViewController=[[LikerListViewController alloc]initWithNibName:@"LikerListViewController" bundle:nil];
    OBJLikerListViewController.title=@"Likers";
    OBJLikerListViewController.arrLikerList=arrLikers;
    [self.navigationController pushViewController:OBJLikerListViewController animated:TRUE];
}
-(IBAction)btnCommentPressed:(id)sender{
    
    CommentViewController *commentVC=[[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
    commentVC.title = @"Comment";
    commentSenderTag = [sender tag];
    objChallengeInfo = [arrUserData objectAtIndex:[sender tag]-1];
    
    UITableViewCell *cell1 = [tblTimeline cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag]-1 inSection:0]];
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
                    if (lbl.tag == [sender tag]+211)
                    {
                        lblComment = lbl;
                    }
                    if (lbl.tag == [sender tag]+212)
                    {
                        lblComment2 = lbl ;
                    }
                    
                    if (lbl.tag == [sender tag]+213)
                    {
                        lblComment3 = lbl ;
                    }
                    if (lbl.tag == [sender tag]+214)
                    {
                        lblComment4 = lbl ;
                    }
                    
                }
            }
            
            for (UIButton *btnCmnt2 in ViewSub)
            {
                if ([btnCmnt2 isKindOfClass:[UIButton class]])
                {
                    if (btnCmnt2.tag == [sender tag]+111)
                    {
                        btnComment1 = btnCmnt2 ;
                    }
                    if (btnCmnt2.tag == [sender tag]+112)
                    {
                        btnComment2 = btnCmnt2 ;
                    }
                    if (btnCmnt2.tag == [sender tag]+113)
                    {
                        btnComment3 = btnCmnt2 ;
                    }
                    if (btnCmnt2.tag == [sender tag]+114)
                    {
                        btnComment4 = btnCmnt2 ;
                    }
                }
            }
        }
    }
    
    commentVC.challengeId=[objChallengeInfo objectId];
    commentVC.objchallenge=objChallengeInfo;
    commentVC.ChallengeOwner = [objChallengeInfo objectForKey:@"userId"];
    commentVC.strChaleengeName = [objChallengeInfo objectForKey:@"challengeName"];
    commentVC.isTakeChallenge=FALSE;
    [self.navigationController pushViewController:commentVC animated:YES];
}
-(IBAction)btnOlderCommentPressed:(id)sender{
    
    CommentViewController *commentVC=[[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
    commentVC.title=@"Comment";
    commentSenderTag =[sender tag];
    objChallengeInfo=[arrUserData objectAtIndex:[sender tag]-1];
    
    UITableViewCell *cell1 = [tblTimeline cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag]-1 inSection:0]];
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
                    if (lbl.tag == [sender tag]+211)
                    {
                        lblComment = lbl;
                    }
                    if (lbl.tag == [sender tag]+212)
                    {
                        lblComment2 = lbl ;
                    }
                    
                    if (lbl.tag == [sender tag]+213)
                    {
                        lblComment3 = lbl ;
                    }
                    if (lbl.tag == [sender tag]+214)
                    {
                        lblComment4 = lbl ;
                    }
                    
                }
            }
            
            for (UIButton *btnCmnt2 in ViewSub)
            {
                if ([btnCmnt2 isKindOfClass:[UIButton class]])
                {
                    if (btnCmnt2.tag == [sender tag]+111)
                    {
                        btnComment1 = btnCmnt2 ;
                    }
                    if (btnCmnt2.tag == [sender tag]+112)
                    {
                        btnComment2 = btnCmnt2 ;
                    }
                    if (btnCmnt2.tag == [sender tag]+113)
                    {
                        btnComment3 = btnCmnt2 ;
                    }
                    if (btnCmnt2.tag == [sender tag]+114)
                    {
                        btnComment4 = btnCmnt2 ;
                    }
                    
                }
                
            }
            
        }
        
    }
    commentVC.challengeId       = [objChallengeInfo objectId];
    commentVC.ChallengeOwner    = [objChallengeInfo objectForKey:@"userId"];
    commentVC.strChaleengeName  = [objChallengeInfo objectForKey:@"challengeName"];
    commentVC.isTakeChallenge   = FALSE;
    [self.navigationController pushViewController:commentVC animated:YES];
}
-(IBAction)btnOtherUserNamePressed:(id)sender{
    
    UIButton *btn=(UIButton*)sender;
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" containsString:btn.titleLabel.text];
    NSArray *results  = [query findObjects];
    for(PFUser *user in results){
        if([[user username]isEqualToString:btn.titleLabel.text]){
            ProfileViewController *profileVC=[[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
            profileVC.title=@"Profile";
            profileVC.profileUser=user;
            appdelegateRef.arrUserLikeChallenge=arrClickUserLikeChallenge;
            profileVC.title=[profileVC.profileUser username];
            [self.navigationController pushViewController:profileVC animated:YES];
            break;
        }
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
-(IBAction)btnOtherUserNamePressed123:(id)sender{
    
    // UIButton *btn=(UIButton*)sender;
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    objChallengeInfo=[arrUserData objectAtIndex:[sender tag]-1];
    PFUser *user=[objChallengeInfo objectForKey:@"userId"];
    
    ProfileViewController *profileVC=[[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    appdelegateRef.arrUserLikeChallenge=arrClickUserLikeChallenge;
    profileVC.title=@"Profile";
    profileVC.profileUser=user;
    profileVC.title=[profileVC.profileUser username];
    [self.navigationController pushViewController:profileVC animated:YES];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
-(IBAction)btnFindPressed:(id)sender {
    FindChallengesViewConroller *findCalngVC = [[FindChallengesViewConroller alloc]initWithNibName:@"FindChallengesViewConroller" bundle:nil];
    findCalngVC.title = @"Find A Challenge";
    [self.navigationController pushViewController:findCalngVC animated:YES];
}
-(IBAction)btnCreatePressed:(id)sender {
    CreateChlng1ViewController *crtChlng1VC=[[CreateChlng1ViewController alloc]initWithNibName:@"CreateChlng1ViewController" bundle:nil];
    crtChlng1VC.title=@"Step 1";
    [self.navigationController pushViewController:crtChlng1VC animated:YES];
}
-(IBAction)btnHomePressed:(id)sender{
    
    if (!isOpen) {
        [self viewHomeOpenAnim];
    }else{
        [self viewHomeCloseAnim];
    }
    
}
-(IBAction)btnSettingPressed:(id)sender {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         self.viewHome.frame = CGRectMake(0,-176, self.viewHome.frame.size.width,176);
                         isOpen=NO;
                     } completion:^(BOOL finished) {
                         [self.viewHome removeFromSuperview];
                         SettingViewController *settingVC=[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
                         settingVC.title=@"Settings";
                         [self.navigationController pushViewController:settingVC animated:YES];
                     }];
}
-(IBAction)btnActivityPressed:(id)sender {
    
    [UIView animateWithDuration:0.5  delay:0.0  options:UIViewAnimationCurveEaseIn  animations:^{
        self.viewHome.frame = CGRectMake(0,-176, self.viewHome.frame.size.width,176);
        isOpen=NO;
    }
                     completion:^(BOOL finished) {
                         [self.viewHome removeFromSuperview];
                         activtyVC  =[[ActivityViewController alloc]initWithNibName:@"ActivityViewController" bundle:nil];
                         appdelegateRef.arrCurrentUserChallegesData=arrCurrentUserChallenges;
                         activtyVC.title=@"Activity";
                         [self.navigationController pushViewController:activtyVC animated:YES];
                     }];
    
}
-(IBAction)btnProfileAction:(id)sender{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         
                         self.viewHome.frame = CGRectMake(0,-176, self.viewHome.frame.size.width,176);
                         isOpen = NO;
                     } completion:^(BOOL finished) {
                         [self.viewHome removeFromSuperview];
                         ProfileViewController *profileVC = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
                         profileVC.title=@"Profile";
                         appdelegateRef.arrUserLikeChallenge=arrClickUserLikeChallenge;
                         profileVC.arrBlockUsers=arrLocal;
                         [self.navigationController pushViewController:profileVC animated:YES];
                     }];
    
}
-(void)viewHomeCloseAnim{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         self.viewHome.frame = CGRectMake(0,-176, self.viewHome.frame.size.width,176);
                         isOpen=NO;
                     } completion:^(BOOL finished) {
                         
                         [self.viewHome removeFromSuperview];
                     }];
}
-(void)viewHomeOpenAnim{
    
    [self.view addSubview:viewHome];
    viewHome.frame = CGRectMake(0, -176, self.viewHome.frame.size.width, 176);
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         self.viewHome.frame = CGRectMake(0,0, self.viewHome.frame.size.width,176);
                         isOpen=YES;
                     } completion:^(BOOL finished) {
                         
                     }];
}
-(IBAction)btnHeaderbackPressed:(id)sender{
    self.strSelectedTag=@"";
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ActionSheet Delegate
//Action sheet for Image Capturing
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag == 20){
        switch (buttonIndex){
            case 0:{
                if([[[NSUserDefaults standardUserDefaults]objectForKey:@"facebookShare"] isEqualToString:@"ON"]){
                    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
                    [self postToFcaebookUsersWall:buttonIndexForShareDataOnSocial];
                }else{
                    DisplayAlertWithTitle(@"FitTag", @"You have off your share setting for Facebook, Please switch it on in order to share on Facebook.")
                }
                break;
            }
            case 1:{
                /* UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"FitTag" message:@"OOPS ! Sorry for inconvenience. We are having some problems with twitter for now. We are working hard to solve the issue. We will get back to you soon." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];*/
                
                // Twitter Temporary block
                
                {
                    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"twitterShare"] isEqualToString:@"ON"]){
                        
                        if([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]){
                            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
                            [self postToTwitterAsTwitt:buttonIndexForShareDataOnSocial];
                        }else{
                            [PFTwitterUtils linkUser:[PFUser currentUser] block:^(BOOL isLinked,NSError *userLinkedError){
                                if(!userLinkedError){
                                    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
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
                
            }
            default:
                break;
        }
    }else if(actionSheet.tag == 11){
        
        if (buttonIndex==1) {
            [tblTimeline beginUpdates];
            
            [objChallengeInfo delete];
            skipIndex=skipIndex-1;
            [arrUserData removeObjectAtIndex:buttonTagForDeleteChallenge];
            [self performSelector:@selector(updateUIandReloadViews:) withObject:nil];
            
        }
        if (buttonIndex==0) {
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *emailController = [[MFMailComposeViewController alloc] init];
                emailController.mailComposeDelegate = self;
                NSString *subject=@"FeedBack";
                NSString *mailBody=@"";
                NSArray *recipients=[[NSArray alloc] initWithObjects:@"Feedback@FitTagApp.com", nil];
                
                [emailController setSubject:subject];
                [emailController setMessageBody:mailBody isHTML:YES];
                [emailController setToRecipients:recipients];
                
                //[self presentModalViewController:emailController animated:YES];
                
                [self presentViewController:emailController animated:TRUE completion:nil];
            }
        }
        
    }
    else if(actionSheet.tag == 10)
    {
        if (buttonIndex==0) {
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *emailController = [[MFMailComposeViewController alloc] init];
                emailController.mailComposeDelegate = self;
                NSString *subject=@"FeedBack";
                NSString *mailBody=@"";
                NSArray *recipients=[[NSArray alloc] initWithObjects:@"Feedback@FitTagApp.com", nil];
                
                [emailController setSubject:subject];
                [emailController setMessageBody:mailBody isHTML:YES];
                [emailController setToRecipients:recipients];
                
                // [self presentModalViewController:emailController animated:YES];
                [self presentViewController:emailController animated:TRUE completion:nil];
            }
        }
    }
}
#pragma mark-Mail Controller Delegate Method
// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
        }
            
            break;
    }
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)updateUIandReloadViews:(id)sender{
    
    [[NSBundle mainBundle] loadNibNamed:@"TimeLineViewController" owner:self options:nil];
    stringWithNIBLoad = @"NO";
    
    if ([arrIndexPath count]>0) {
        [tblTimeline scrollToRowAtIndexPath:[arrIndexPath objectAtIndex:buttonTagForDeleteChallenge] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tblTimeline.bounds.size.height, self.view.frame.size.width, self.tblTimeline.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    _refreshHeaderView.backgroundColor=[UIColor clearColor];
    
    [self.tblTimeline addSubview:_refreshHeaderView];
    [self.tblTimeline bringSubviewToFront:_refreshHeaderView];
    stringWithNIBLoad = @"YES";
}
-(void)likerBtnPressedDelegate :(NSInteger)senderIndex{
    
}
-(void)LikeChallangeMode:(id)sender{
    PFUser *user;
    PFObject *obj;
    objChallengeInfo = [arrUserData objectAtIndex:[sender tag]-1];
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
        }else{
            IsLiked = NO;
        }
    }
    
    for (int i=0; i<[arrClickUserLikeChallenge count]; i++) {
        PFObject *objAbc=[arrClickUserLikeChallenge objectAtIndex:i];
        if ([[objAbc objectForKey:@"challengeName"] isEqualToString:[objChallengeInfo objectForKey:@"challengeName"]]) {
            [arrClickUserLikeChallenge removeObjectAtIndex:i];
            break;
        }
    }
    
    if (IsLiked==YES) {
        IsLiked=NO;
        if ([[user username] isEqualToString:[[PFUser currentUser] username]]) {
            [obj delete];
            
            NSMutableArray *arr=[[NSMutableArray alloc]initWithArray:[objChallengeInfo objectForKey:@"likesAndComments"]];
            for (int i=0; i<[arr count]; i++) {
                PFObject *objLikes=[arr objectAtIndex:i];
                if ([[objLikes objectForKey:@"LikeuserId"]isEqualToString:[obj objectForKey:@"LikeuserId"]]) {
                    [arr removeObjectAtIndex:i];
                }
                
            }
            [objChallengeInfo removeObjectForKey:@"likesAndComments"];
            [objChallengeInfo addObjectsFromArray:arr forKey:@"likesAndComments"];
            
            
            
            UITableViewCell *cell1=[tblTimeline cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag]-1 inSection:0]];
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
                                    dispatch_async(dispatch_get_main_queue(),^{
                                        txtView.text= [txtView.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"You Like this"] withString:@"Be the first person to like this!!!"];
                                    });
                                    
                                }else{
                                    dispatch_async(dispatch_get_main_queue(),^{
                                        txtView.text= [txtView.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"You"] withString:@""];
                                    });
                                }
                            }
                            
                        }
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                [self.tblTimeline beginUpdates];
                [[NSBundle mainBundle] loadNibNamed:@"TimeLineViewController" owner:self options:nil];
                stringWithNIBLoad = @"NO";
                [self.tblTimeline reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[sender tag]-1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
                
                [self.tblTimeline scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:[sender tag]-1 inSection:0] atScrollPosition: UITableViewScrollPositionTop animated: NO];
                
                _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tblTimeline.bounds.size.height, self.view.frame.size.width, self.tblTimeline.bounds.size.height)];
                _refreshHeaderView.delegate = self;
                _refreshHeaderView.backgroundColor=[UIColor clearColor];
                
                [self.tblTimeline addSubview:_refreshHeaderView];
                [self.tblTimeline bringSubviewToFront:_refreshHeaderView];
                [self.tblTimeline endUpdates];
                stringWithNIBLoad = @"YES";
                [MBProgressHUD hideHUDForView:self.view animated:TRUE];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(),^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
    }
    else{
        
        objChallengeInfo=[arrUserData objectAtIndex:[sender tag]-1];
        PFObject *like = [PFObject objectWithClassName:@"tbl_Likes"];
        PFUser *OwnerUSer = [objChallengeInfo objectForKey:@"userId"];
        
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
                
                // Send push notification to user for like the challenge
                
                // Find devices associated with these users
                PFQuery *pushQuery = [PFInstallation query];
                [pushQuery whereKey:@"owner" equalTo:OwnerUSer];
                
                // Send push notification to query
                
                if(![[OwnerUSer objectId] isEqualToString:[[PFUser currentUser] objectId]]){
                    
                    if([[OwnerUSer objectForKey:@"likeNotification"] isEqualToString:@"YES"]){
                        PFPush *push = [[PFPush alloc] init];
                        //[push setQuery:pushQuery]; // Set our Installation query
                        [push setChannel:[NSString stringWithFormat:@"user_%@",[OwnerUSer objectId]]];
                        
                        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSString stringWithFormat:@"%@ likes your challenge %@",[PFUser currentUser].username,[appdelegateRef removeNull:[objChallengeInfo objectForKey:@"challengeName"]]], @"alert",
                                              @"Increment", @"badge",
                                              @"default",@"sound",
                                              @"like",@"action",
                                              [objChallengeInfo objectId],@"challengeId",
                                              nil];
                        [push setData:data];
                        [push sendPushInBackgroundWithBlock:^(BOOL done,NSError *errror){
                            if (!errror) {
                            }else{
                            }
                        }];
                        
                        //[push sendPushInBackground];
                    }
                }
                
                objChallengeInfo=[arrUserData objectAtIndex:[sender tag]-1];
                createdUser=[objChallengeInfo objectForKey:@"userId"];
                PFQuery *queryForLikeComment=[PFQuery queryWithClassName:@"tbl_Likes"];
                [queryForLikeComment whereKey:@"ChallengeId" equalTo:[objChallengeInfo objectId]];
                [queryForLikeComment includeKey:@"userId"];
                [queryForLikeComment addDescendingOrder:@"createdAt"];
                NSMutableArray *arrAllData=[[NSMutableArray alloc]initWithArray:[queryForLikeComment findObjects]];
                PFObject *obj=[arrAllData objectAtIndex:0];
                PFUser *user=[obj objectForKey:@"userId"];
                if ([[user username] isEqualToString:[[PFUser currentUser] username]]) {
                    IsLiked =YES;
                    
                    [objChallengeInfo removeObjectForKey:@"likesAndComments"];
                    [objChallengeInfo addObjectsFromArray:arrAllData forKey:@"likesAndComments"];
                    if ([objChallengeInfo objectForKey:@"likesAndComments"]) {
                        [arrClickUserLikeChallenge addObject:objChallengeInfo];
                    }
                    
                }
                if ([[createdUser objectId]isEqualToString:[[PFUser currentUser]objectId]]) {
                    [arrCurrentUserChallenges addObject:objChallengeInfo];
                }
                
                UITableViewCell *cell1=[tblTimeline cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag]-1 inSection:0]];
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
                                    if ([[user username] isEqualToString:[[PFUser currentUser] username]]) {
                                        
                                        if ([txtView.text isEqualToString:@"Be the first person to like this!!!"]) {
                                            dispatch_async(dispatch_get_main_queue(),^{
                                                txtView.text= [NSString stringWithFormat:@"You %@",@"Like this"];
                                            });
                                        }
                                        else{
                                            dispatch_async(dispatch_get_main_queue(),^{
                                                txtView.text= [NSString stringWithFormat:@"You,%@",txtView.text];
                                            });
                                        }
                                        
                                    }
                                    else{
                                        dispatch_async(dispatch_get_main_queue(),^{
                                            txtView.text= [NSString stringWithFormat:@"%@,%@",[user username],txtView.text];
                                        });
                                    }
                                    
                                    
                                }
                                
                            }
                        }
                        
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.tblTimeline beginUpdates];
                    [[NSBundle mainBundle] loadNibNamed:@"TimeLineViewController" owner:self options:nil];
                    stringWithNIBLoad = @"NO";
                    
                    [self.tblTimeline reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[sender tag]-1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
                    
                    [self.tblTimeline scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:[sender tag]-1 inSection:0] atScrollPosition: UITableViewScrollPositionTop animated: NO];
                    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tblTimeline.bounds.size.height, self.view.frame.size.width, self.tblTimeline.bounds.size.height)];
                    _refreshHeaderView.delegate = self;
                    _refreshHeaderView.backgroundColor=[UIColor clearColor];
                    
                    [self.tblTimeline addSubview:_refreshHeaderView];
                    [self.tblTimeline bringSubviewToFront:_refreshHeaderView];
                    [self.tblTimeline endUpdates];
                    stringWithNIBLoad = @"YES";
                    [MBProgressHUD hideHUDForView:self.view animated:TRUE];
                });
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }];
    }
}
-(void)test:(id)sender{
}
-(void)getCommentsInMainView:(id)sender{
    if(commentSenderTag <= 0){
        commentSenderTag = 1;
    }
    objChallengeInfo=[arrUserData objectAtIndex:commentSenderTag-1];
    PFQuery *queryForLikeComment1=[PFQuery queryWithClassName:@"tbl_comments"];
    [queryForLikeComment1 whereKey:@"ChallengeId" equalTo:[objChallengeInfo objectId]];
    [queryForLikeComment1 includeKey:@"userId"];
    [queryForLikeComment1 addDescendingOrder:@"createdAt"];
    NSMutableArray *arrAllData1=[[NSMutableArray alloc]initWithArray:[[queryForLikeComment1 findObjects] mutableCopy]];
    [objChallengeInfo removeObjectForKey:@"onlyComments"];
    [objChallengeInfo addObjectsFromArray:arrAllData1 forKey:@"onlyComments"];
}
-(void)commentbackAction{
    
    [self.tblTimeline beginUpdates];
    [[NSBundle mainBundle] loadNibNamed:@"TimeLineViewController" owner:self options:nil];
    [self.tblTimeline scrollToRowAtIndexPath: [NSIndexPath indexPathForRow:commentSenderTag-1 inSection:0] atScrollPosition: UITableViewScrollPositionTop animated: YES];
    stringWithNIBLoad = @"NO";
    [self.tblTimeline reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:commentSenderTag-1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.tblTimeline endUpdates];
    stringWithNIBLoad = @"YES";
}
#pragma mark
#pragma mark - own methods
-(void)setNavigationComponent{
    //Home Button
    if([strSelectedTag isEqualToString:@""] || strSelectedTag == NULL || strSelectedTag == nil){
        UIButton *btnleft = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnleft addTarget:self action:@selector(btnHomePressed:) forControlEvents:UIControlEventTouchUpInside];
        [btnleft setFrame:CGRectMake(0, 0, 40, 44)];
        [btnleft setImage:[UIImage imageNamed:@"headerHome"] forState:UIControlStateNormal];
        UIView *view123=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
        [view123 addSubview:btnleft];
        
        UIBarButtonItem *btn123=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
        btn123.width=-16;
        UIBarButtonItem *btn132=[[UIBarButtonItem alloc] initWithCustomView:view123];
        self.navigationItem.leftBarButtonItems=[[NSArray alloc]initWithObjects:btn123,btn132,nil];
        
        UIButton *btnFitTag = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFitTag addTarget:self action:@selector(btnCreatePressed:) forControlEvents:UIControlEventTouchUpInside];
        [btnFitTag setFrame:CGRectMake(31,0,50,40)];
        [btnFitTag setImage:[UIImage imageNamed:@"headerFit@2x.png"] forState:UIControlStateNormal];
        [btnFitTag setBackgroundColor:[UIColor clearColor]];
        //heasderSearch
        UIButton *btnSearch=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnSearch addTarget:self action:@selector(btnFindPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btnSearch setFrame:CGRectMake(0, 0, 30, 44)];
        [btnSearch setImage:[UIImage imageNamed:@"headerSearch"] forState:UIControlStateNormal];
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
        [view addSubview:btnFitTag];
        [view addSubview:btnSearch];
        UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
        btn.width=-16;
        UIBarButtonItem *btn1=[[UIBarButtonItem alloc] initWithCustomView:view];
        self.navigationItem.rightBarButtonItems=[[NSArray alloc]initWithObjects:btn,btn1,nil];
    }
    else
    {
        UIButton *btnback=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnback addTarget:self action:@selector(btnHeaderbackPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btnback setFrame:CGRectMake(0, 0, 40, 44)];
        [btnback setImage:[UIImage imageNamed:@"headerback"] forState:UIControlStateNormal];
        UIView *view123=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
        [view123 addSubview:btnback];
        UIBarButtonItem *btn123=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
        btn123.width=-16;
        UIBarButtonItem *btn132=[[UIBarButtonItem alloc] initWithCustomView:view123];
        self.navigationItem.leftBarButtonItems=[[NSArray alloc]initWithObjects:btn123,btn132,nil];
    }
}
-(void)viewHomeRemove{
    [self.viewHome removeFromSuperview];
}
#pragma mark
#pragma mark ScrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([stringWithNIBLoad isEqualToString:@"YES"]){
        
        if(!isLoading){
            if (([scrollView contentOffset].y + scrollView.frame.size.height) >= [scrollView contentSize].height){
                isLoading = YES;
                [[NSBundle mainBundle] loadNibNamed:@"FooterLoadingView" owner:self options:nil];
                self.footerActivityIndicator = self.activityIndicator;;
                [tblTimeline setTableFooterView:[self activityIndicatorView]];;
                [self startAnimation];
                dispatch_async(kBgQueue,^{
                    if (SingTimeRefresh==YES) {
                    }else{
                        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                                 selector:@selector(getMYFollowers)
                                                                   object:nil];
                        [self getMYFollowers];
                    }
                });
            }
        }
    }
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
#pragma mark
#pragma mark Animations methods
-(void)startAnimation{
    [[self activityIndicatorView] setHidden:NO];
    [[self footerActivityIndicator] startAnimating];
}
-(void)stopAnimation{
    [[self activityIndicatorView]setHidden:YES];
    [[self footerActivityIndicator] stopAnimating];
    isLoading = NO;
}
#pragma mark
#pragma mark Post on facebook
-(void)postToFcaebookUsersWall:(int )index{
    
    objChallengeInfo = [arrUserData objectAtIndex:index];
    
    PFFile *teaserImage = [objChallengeInfo objectForKey:@"teaserfile"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"FitTag", @"name",
                                   [objChallengeInfo objectForKey:@"challengeName"], @"caption",
                                   [objChallengeInfo objectForKey:@"tags"], @"description",
                                   [NSString stringWithFormat:@"http://www.fittag.com/challenge_details.php?id=%@",objChallengeInfo.objectId], @"link",
                                   nil];
    
    if([[[teaserImage name] pathExtension]isEqualToString:@"mov"] || [[[teaserImage name] pathExtension]isEqualToString:@"mp4"]) {
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
             if(error){
                 // Case A: Error launching the dialog or publishing story.
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             }else{
                 if (result == FBWebDialogResultDialogNotCompleted) {
                     // Case B: User clicked the "x" icon
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                 } else {
                     // Case C: Dialog shown and the user clicks Cancel or Share
                     NSDictionary *urlParams;// = [self parseURLParams:[resultURL query]];
                     if(![urlParams valueForKey:@"post_id"]) {
                         // User clicked the Cancel button
                         //[MBProgressHUD hideHUDForView:self.view animated:YES];
                     }else{
                         // User clicked the Share button
                         //[MBProgressHUD hideHUDForView:self.view animated:YES];
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
#pragma mark
#pragma mark Posting on Twitter
-(void)postToTwitterAsTwitt:(int)index{
    
    // Test code for Twitter image posting
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    objChallengeInfo = [arrUserData objectAtIndex:index];
    
    NSString *status = @"Check out this challenge from #FitTag by downloading the FitTag App";
    
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
        // NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if(!error){
            
        }else{
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark
#pragma mark Click on #Tag And @Username Mehods
-(LORichTextLabel *)atSelectedUser{
    
    UIFont *highlightFont = [UIFont fontWithName:@"DynoRegular" size:12.0];
    LORichTextLabelStyle *atStyle = [LORichTextLabelStyle styleWithFont:highlightFont color:[UIColor redColor]];
    [atStyle addTarget:self action:@selector(atSelected:)];
    LORichTextLabel *label = [[LORichTextLabel alloc] initWithWidth:50.0];
    [label positionAtX:10 andY:0.0 withHeight:21];
    [label setFont:[UIFont fontWithName:@"DynoRegular" size:12.0]];
    label.isCommentView=FALSE;
    label.isLikeUser=FALSE;
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label addStyle:atStyle forPrefix:@"@"];
    lblattheRate=label;
    return lblattheRate;
}
-(LORichTextLabel *)atSelectedAtTag{
    
    UIFont *highlightFont = [UIFont fontWithName:@"DynoRegular" size:12.0];
    LORichTextLabelStyle *atStyle = [LORichTextLabelStyle styleWithFont:highlightFont color:[UIColor redColor]];
    [atStyle addTarget:self action:@selector(atSelected:)];
    LORichTextLabel *label = [[LORichTextLabel alloc] initWithWidth:100.0];
    [label positionAtX:10 andY:0.0 withHeight:21];
    [label setFont:[UIFont fontWithName:@"DynoRegular" size:12.0]];
    label.isCommentView=FALSE;
    label.isLikeUser=FALSE;
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor blackColor]];
    [label addStyle:atStyle forPrefix:@"@"];
    lblattheRate=label;
    return lblattheRate;
}
-(void)atSelected:(id)sender{
    
    NSString *name = [NSString stringWithFormat:@"%@", [self tagFromSender:sender]];
    NSString *newStr = [name substringFromIndex:1];
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:newStr];
    NSArray *arr = [[NSArray alloc]initWithArray:[query findObjects]];
    PFUser *user = [arr objectAtIndex:0];
    ProfileViewController *obProfile = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    obProfile.profileUser = user;
    obProfile.title = @"Profile";
    [self.navigationController pushViewController:obProfile animated:TRUE];
    
}
-(NSString *)tagFromSender:(id)sender {
	return ((UIButton *)sender).titleLabel.text;
}
-(void)clickOnHashTags :(NSNotification *)notification{
    
    TimeLineViewController_copy *timelineTagVC = [[TimeLineViewController_copy alloc]initWithNibName:@"TimeLineViewController_copy" bundle:nil];
    timelineTagVC.title = [notification object];
    timelineTagVC.strSelectedTag = [notification object];
    [self.navigationController pushViewController:timelineTagVC animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clickOnHashTags" object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userLikeNameButton" object:nil];
    
}
-(void)selectUserButtonLikes:(id)sender{
    
    NSString *name= [NSString stringWithFormat:@"%@", [self tagFromSender:sender]];
    NSString *newStr = name;
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
}
#pragma mark
#pragma mark Activities Indicatior
-(void)selfActivities{
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    
}
#pragma mark
#pragma mark Add First Challenge after create challenge
-(void)addFirstChallenge{
    [lblNoRec setHidden:YES];
    //[tblTimeline beginUpdates];
    objChallengeInfo = [appdelegateRef.arrUserFirstChallenge objectAtIndex:0];
    [arrUserData insertObject:objChallengeInfo atIndex:0];
    MPMoviePlayerController *moviePlayer1 = [[MPMoviePlayerController alloc] init];
    [moviePlayer1 setControlStyle:MPMovieControlStyleDefault];
    [moviePlayer1.view setUserInteractionEnabled:YES];
    [moviePlayer1.view setFrame:CGRectMake(5, 37, 310 , 324)];
    moviePlayer1.movieSourceType = MPMovieSourceTypeFile;
    moviePlayer1.view.hidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer1];
    moviePlayer1.controlStyle=MPMovieControlStyleNone;
    [arrMoviePlayerObject addObject:moviePlayer1];
    
    
    [[NSBundle mainBundle] loadNibNamed:@"TimeLineViewController" owner:self options:nil];
    stringWithNIBLoad = @"NO";
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tblTimeline.bounds.size.height, self.view.frame.size.width, self.tblTimeline.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    _refreshHeaderView.backgroundColor=[UIColor clearColor];
    
    [self.tblTimeline addSubview:_refreshHeaderView];
    [self.tblTimeline bringSubviewToFront:_refreshHeaderView];
    stringWithNIBLoad = @"YES";
    
    [appdelegateRef.arrUserFirstChallenge removeAllObjects];
}
@end
