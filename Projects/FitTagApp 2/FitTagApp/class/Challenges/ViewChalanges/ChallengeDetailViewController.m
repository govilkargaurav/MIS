//
//  ChallengeDetailViewController.m
//  FitTag
//
//  Created by Mic mini 5 on 3/5/13.


#import "ChallengeDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CommentViewController.h"
#import "LikerListViewController.h"
#import "GlobalClass.h"

#define degreesToRadians(x)(x * M_PI / 180)

@implementation ChallengeDetailViewController
@synthesize pageControll;
@synthesize scrollViewImage;
@synthesize lblDiscription;
@synthesize viewEquipment;
@synthesize objChallengeInfo,objUserInfo,aryStepsData,lblLableNo,imgViewLabel;
@synthesize player;

CGFloat xOffset = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = YES;

}
-(void)viewDidLoad{
    
    [super viewDidLoad];
    __block BOOL isFirstStep = YES;
    mutDictStepsVideoPlayer = [[NSMutableDictionary alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    buttonIndexForShareDataOnSocial = 0;
    appdelegateRef = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    arrAllTakeChallenges = [[NSMutableArray alloc]init];
    lblLableNo = [[UILabel alloc] initWithFrame:CGRectMake(1, 20, 33, 36)];
    lblLableNo.textAlignment = NSTextAlignmentCenter;
    lblLableNo.font = [UIFont fontWithName:@"DynoBold" size:21];
    lblLableNo.backgroundColor = [UIColor clearColor];
    lblLableNo.textColor = [UIColor whiteColor];
    lblLableNo.text = @"1";
    [imgViewLabel addSubview:lblLableNo];
    lblEqupment.font = [UIFont boldSystemFontOfSize:20.0];
    
    lblLikerCount.font = [UIFont fontWithName:@"DynoRegular" size:12];
    btnLikers.titleLabel.font = [UIFont fontWithName:@"DynoRegular" size:12];
    lblDiscription.font = [UIFont fontWithName:@"DynoRegular" size:10];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
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
    //Done Button
    UIButton *btnChlng = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnChlng addTarget:self action:@selector(btnSkipPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnChlng setFrame:CGRectMake(0, 0, 40, 44)];
    [btnChlng setImage:[UIImage imageNamed:@"headertagchalange"] forState:UIControlStateNormal];
   
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    [view addSubview:btnChlng];
    
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn.width=-10;
    UIBarButtonItem *btn1=[[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItems=[[NSArray alloc]initWithObjects:btn,btn1,nil];
    NSArray *aryEqp = [[[[self.objChallengeInfo objectForKey:@"equipments"]componentsSeparatedByString:@","] reverseObjectEnumerator] allObjects];
    aryStepsData = [objChallengeInfo objectForKey:@"myArray"];
    
    if([aryStepsData count] == 0){
        btnShare.enabled = NO;
    }
    [self setEquipmentView:aryEqp];
    objUserInfo = [objChallengeInfo objectForKey:@"userId"];
    
    // Do any additional setup after loading the view from its nib.
    pageControll.numberOfPages = [aryStepsData count];
    
    PFQuery *queryForTakeChallenge = [PFQuery queryWithClassName:@"Tbl_TakeChallengs"];
    
    [queryForTakeChallenge whereKey:@"Challenge_Id" equalTo:[objChallengeInfo objectId]];
    [queryForTakeChallenge addDescendingOrder:@"createdAt"];
    [queryForTakeChallenge findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            arrAllTakeChallenges = [objects mutableCopy];
            for (int i = 0; i < aryStepsData.count; i++) {
                if ([objects count] == 0) {
                    PFObject *objTakeChallengs = [PFObject objectWithClassName:@"Tbl_TakeChallengs"];
                    [objTakeChallengs setObject:[objChallengeInfo objectId] forKey:@"Challenge_Id" ];
                    [objTakeChallengs save];
                }
                CGRect frame;
                if([UIScreen mainScreen].bounds.size.height == 568.0){
                    frame.origin.x = self.scrollViewImage.frame.size.width * i;
                    frame.origin.y = 0;
                    frame.size.width = 297.0;
                    frame.size.height= 437.0-45;
                }else{
                    frame.origin.x = self.scrollViewImage.frame.size.width * i;
                    frame.origin.y = 0;
                    frame.size = self.scrollViewImage.frame.size;
                }
                
                PFFile *pfile;
                bool isNoImage=NO ;
                NSString *strOnlyText = @"";
                
                    NSMutableDictionary *dic = [aryStepsData objectAtIndex:i];
                    
                    if([[dic objectForKey:@"onlyText"]isEqualToString:@"noImage"]){
                        strOnlyText = [dic objectForKey:@"text"];
                        
                        if(isFirstStep){
                            isFirstStep = NO;
                            lblDiscription.text = [strOnlyText uppercaseString];
                            
                            // Dynamic height for description step
                            
                            CGRect frame = lblDiscription.frame;
                            frame.size.height = lblDiscription.contentSize.height;
                            lblDiscription.frame = CGRectMake(lblDiscription.frame.origin.x,lblDiscription.frame.origin.y, lblDiscription.frame.size.width, frame.size.height);
                        }
                        
                        isNoImage = YES;
                    }else{
                        pfile = [dic objectForKey:@"image"];
                        if (i==0) {
                            firstVedio=pfile;
                        }
                        
                    }
               
                if(isNoImage){
                    //UITextView
                    UITextView *textView = [[UITextView alloc]initWithFrame:frame];
                    [textView setFont:[UIFont fontWithName:@"DynoRegular" size:26]];
                    [textView setEditable:NO];
                    textView.text = [[NSString stringWithFormat:@"\n\n%@",strOnlyText] uppercaseString];
                    [self.scrollViewImage addSubview:textView];
                    
                }else{
                    if([[[pfile name] pathExtension]isEqualToString:@"jpg"]){
                        EGOImageView *egoImgView = [[EGOImageView alloc] initWithFrame:frame];
                        [egoImgView setImageURL:[NSURL URLWithString:[pfile url]]];
                        [egoImgView setContentMode:UIViewContentModeScaleToFill];
                        [self.scrollViewImage addSubview:egoImgView];
                        if(isFirstStep){
                            isFirstStep = NO;
                            lblDiscription.text = [[dic objectForKey:@"text"] uppercaseString];
                            CGRect frame = lblDiscription.frame;
                            frame.size.height = lblDiscription.contentSize.height;
                            lblDiscription.frame = CGRectMake(lblDiscription.frame.origin.x,lblDiscription.frame.origin.y, lblDiscription.frame.size.width, frame.size.height);
                        }
                        
                    }else if([[[pfile name] pathExtension]isEqualToString:@"mov"] || [[[pfile name] pathExtension]isEqualToString:@"mp4"]){
                        NSURL *url = [NSURL URLWithString:[pfile url]];
                        MPMoviePlayerController *moviePlayer1 = [[MPMoviePlayerController alloc] init];
                        moviePlayer1.view.frame = frame;
                        [moviePlayer1 setControlStyle:MPMovieControlStyleDefault];
                        [moviePlayer1.view setUserInteractionEnabled:YES];
                        moviePlayer1.movieSourceType = MPMovieSourceTypeStreaming;
                        [moviePlayer1 setContentURL:url];
                        [moviePlayer1.view setBackgroundColor:[UIColor clearColor]];
                        [self.scrollViewImage setBackgroundColor:[UIColor clearColor]];
                        [moviePlayer1 prepareToPlay];
                        [self.scrollViewImage addSubview:moviePlayer1.view];
                        NSString *strMoviplayerKey = [NSString stringWithFormat:@"%d",i];
                        [mutDictStepsVideoPlayer setObject:moviePlayer1 forKey:strMoviplayerKey];
                        moviePlayer1 = nil;
                        if(isFirstStep){
                            isFirstStep = NO;
                            lblDiscription.text = [[dic objectForKey:@"text"] uppercaseString];
                            CGRect frame = lblDiscription.frame;
                            frame.size.height = lblDiscription.contentSize.height;
                            lblDiscription.frame = CGRectMake(lblDiscription.frame.origin.x,lblDiscription.frame.origin.y, lblDiscription.frame.size.width, frame.size.height);
                        }
                    }else{
                        UITextView *textView = [[UITextView alloc]initWithFrame:frame];
                        [textView setFont:[UIFont fontWithName:@"DynoRegular" size:12]];
                        [textView setEditable:NO];
                        textView.text = [strOnlyText uppercaseString];
                        [self.scrollViewImage addSubview:textView];
                    }
                }
            }
            if ([arrAllTakeChallenges count] == 0){
                [self FindTakeChallenges];
            }
            [self findLikes];
            [self rearrangeViewAccordingToData];
            if([[[firstVedio name] pathExtension]isEqualToString:@"mov"] || [[[firstVedio name] pathExtension]isEqualToString:@"mp4"]){
            
                [self playFirstVideo];
            }
            [MBProgressHUD hideHUDForView:self.view animated:TRUE];
        }
    }];
    
    self.scrollViewImage.contentSize = CGSizeMake(self.scrollViewImage.frame.size.width * (aryStepsData.count), self.scrollViewImage.frame.size.height);
    
    imgViewLabel.layer.anchorPoint = CGPointMake(0.5, 0.0);
    [self hanging];
    
    if([UIScreen mainScreen].bounds.size.height == 568.0){
        scrollviewVertical.frame = CGRectMake(0.0,-23.0,scrollviewVertical.size.width, scrollviewVertical.frame.size.height+30);
        [imgBG setFrame:CGRectMake(6, 18, 306, 405)];
        [lblDiscription setFrame:CGRectMake(5, 418, 280,22)];
        [btnLike setFrame:CGRectMake(9, 458, 24,24)];
        [btnCOMMENT setFrame:CGRectMake(45, 461, 24, 24)];
        [btnShare setFrame:CGRectMake(80, 460, 24,24)];
        [imgShare setFrame:CGRectMake(267, 467, 33, 8)];
        [btnReport setFrame:CGRectMake(257, 461, 24, 24)];
        [btnLikers setFrame:CGRectMake(56, 438, 111, 21)];
        [lblLikerCount setFrame:CGRectMake(11, 438, 42, 21)];
        [lblCommentCount setFrame:CGRectMake(47, 461, 22, 17)];
        [scrollViewImage setFrame:CGRectMake(12, 21, 295, 400)];
        [pageControll setFrame:CGRectMake(141, scrollViewImage.frame.origin.y+scrollViewImage.frame.size.height-20, 38, 36)];
    }else{
        [imgBG setFrame:CGRectMake(6, 18, 306, scrollViewImage.frame.origin.y+scrollViewImage.frame.size.height-10)];
        [lblDiscription setFrame:CGRectMake(5, 330, 280,22)];
        [btnLike setFrame:CGRectMake(9, 367, 24, 24)];
        [btnCOMMENT setFrame:CGRectMake(45, 369, 24, 24)];
        [btnShare setFrame:CGRectMake(80, 369, 24, 24)];
        [imgShare setFrame:CGRectMake(267, 379, 33, 8)];
        [btnReport setFrame:CGRectMake(257, 369, 24, 24)];
        [pageControll setFrame:CGRectMake(141, 394, 38, 36)];
        [btnLikers setFrame:CGRectMake(36, 350, 111, 21)];
        [lblLikerCount setFrame:CGRectMake(11, 350, 42, 21)];
        [pageControll setFrame:CGRectMake(141, scrollViewImage.frame.origin.y+scrollViewImage.frame.size.height-10, 38, 36)];
    }
}
-(void)playFirstVideo{
    pageControlBeingUsed = NO;
    MPMoviePlayerController *moviePlayer = [mutDictStepsVideoPlayer objectForKey:@"0"];
    NSURL *url = [NSURL URLWithString:[firstVedio url]];
    [moviePlayer setControlStyle:MPMovieControlStyleDefault];
    [moviePlayer.view setUserInteractionEnabled:YES];
    moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    [moviePlayer setContentURL:url];
    [moviePlayer.view setBackgroundColor:[UIColor clearColor]];
    [self.scrollViewImage setBackgroundColor:[UIColor clearColor]];
    [moviePlayer prepareToPlay];
    [moviePlayer play];
}
-(void)FindTakeChallenges{
    PFQuery *queryForTakeChallenge = [PFQuery queryWithClassName:@"Tbl_TakeChallengs"];
    [queryForTakeChallenge whereKey:@"Challenge_Id" equalTo:[objChallengeInfo objectId]];
    [queryForTakeChallenge addDescendingOrder:@"createdAt"];
    [arrAllTakeChallenges addObjectsFromArray:[queryForTakeChallenge findObjects]];
}
-(void)findLikes{
    if ([arrAllTakeChallenges count] > 0){
        objTakeChallenge = [arrAllTakeChallenges objectAtIndex:self.pageControll.currentPage];
        [objTakeChallenge removeObjectForKey:@"likesAndComments"];
        PFQuery *postQuery = [PFQuery queryWithClassName:@"tbl_comments_takeChallenge"];
        [postQuery whereKey:@"ChallengeId" equalTo:[objTakeChallenge objectId]];
        [postQuery countObjectsInBackgroundWithBlock:^(int totalCount,NSError *error){
            if(!error){
                lblCommentCount.text = [NSString stringWithFormat:@"%d",totalCount];
            }else{
            }
        }];
        PFQuery *queryForLikeComment = [PFQuery queryWithClassName:@"tbl_Likes_TakeChallenge"];
        [queryForLikeComment whereKey:@"TakeChallengeID" equalTo:[objTakeChallenge objectId]];
        [queryForLikeComment includeKey:@"userId"];
        [queryForLikeComment addDescendingOrder:@"createdAt"];
        arrAllDataLike = [[NSMutableArray alloc]initWithArray:[queryForLikeComment findObjects]];
        if ([arrAllDataLike count] > 0){
            [btnLikers setEnabled:TRUE];
        }
        lblLikerCount.text = [NSString stringWithFormat:@"%d",[arrAllDataLike count]];
        [objTakeChallenge addObjectsFromArray:arrAllDataLike forKey:@"likesAndComments"];
    }
}
- (IBAction)changePage:(id)sender {
    CGRect frame;
    frame.origin.x = self.scrollViewImage.frame.size.width * self.pageControll.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollViewImage.frame.size;
    [self.scrollViewImage scrollRectToVisible:frame animated:YES];
    [self performSelectorInBackground:@selector(findLikes) withObject:nil];
    [self hanging];
}
-(void)viewDidAppear:(BOOL)animated{

}
-(void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened{

}
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
-(void)viewDidUnload {
    [self setScrollViewImage:nil];
    [self setViewEquipment:nil];
    [self setPageControll:nil];
    [self setLblDiscription:nil];
    [self setLblLableNo:nil];
    [self setImgViewLabel:nil];
    [super viewDidUnload];
}

#pragma Mark - Scrollview Delegate Method

-(void)scrollViewDidScroll:(UIScrollView *)sender{
    
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollViewImage.frame.size.width;
    int page = floor((self.scrollViewImage.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControll.currentPage = page;
    
    [lblLableNo setText:[NSString stringWithFormat:@"%d",page+1]];
   
    NSMutableDictionary *dic = [aryStepsData objectAtIndex:page];
    lblDiscription.text      = [[dic objectForKey:@"text"] uppercaseString];
    
    // Change height of steps textview
    
    CGRect frame = lblDiscription.frame;
    frame.size.height = lblDiscription.contentSize.height;
    lblDiscription.frame = CGRectMake(lblDiscription.frame.origin.x,lblDiscription.frame.origin.y, lblDiscription.frame.size.width, frame.size.height);
    
    [self rearrangeViewAccordingToData];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
    [self hanging];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageControlBeingUsed = NO;
        for(NSString *strKeys in mutDictStepsVideoPlayer){
        MPMoviePlayerController *moviePlayer = [mutDictStepsVideoPlayer objectForKey:strKeys];
        if (moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
            [moviePlayer stop];
            break;
        }
    }
    NSString *strcurrentPlayerKey = [NSString stringWithFormat:@"%d",self.pageControll.currentPage];
    [[mutDictStepsVideoPlayer objectForKey:strcurrentPlayerKey] prepareToPlay];
    [[mutDictStepsVideoPlayer objectForKey:strcurrentPlayerKey] play];
    [self performSelectorInBackground:@selector(findLikes) withObject:nil];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
}

#pragma mark- Popup Delegate method
-(void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index{
    [self.pv dismiss:YES];
    CGRect frame = scrollViewImage.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    self.pageControll.currentPage = index;
    [self performSelectorInBackground:@selector(findLikes) withObject:nil];
    [scrollViewImage scrollRectToVisible:frame animated:YES];
}

#pragma mark -own methods

-(void)setEquipmentView:(NSArray*)aryEquString{
    
    UIFont *myFont = [UIFont fontWithName:@"DynoBold" size:14.0];
    // Get the width of a string ...
    CGSize size = [@" " sizeWithFont:myFont];
    CGFloat MINeqpHeight=100;
    
    const CGFloat width = 250;
    const CGFloat height = size.height;
    const CGFloat margin = 1;
    CGFloat y = 0;
    
    //Lable
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,-20, 320, 64)];
    label.font=[UIFont fontWithName:@"DynoBold" size:17.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    // label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(1, 1);
    label.text = @"Equipment";
    //Scroll
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(20,25, 280, 0)];
    
    scrollView.backgroundColor = [UIColor whiteColor];
    
    int i = 1;
    for(NSString *string in aryEquString) {
        
        UILabel *lblEqup = [[UILabel alloc] initWithFrame:CGRectMake(20, y, width, height)];
        lblEqup.font = myFont;
        lblEqup.backgroundColor=[UIColor clearColor];
        lblEqup.textColor=[UIColor blackColor];
        lblEqup.text = [NSString stringWithFormat:@"%3d) %@",i,string];
        [scrollView addSubview:lblEqup];
        
        y += height + margin;
        i++;
    }
    
    scrollView.contentSize = CGSizeMake(width, y - margin);
    if(y > 355)
        y = 355;
    
    scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, y);
    
    scrollView.layer.cornerRadius = 5;
   
    MINeqpHeight = y+60;
    
    UIImageView *imgEqpBack = [[UIImageView alloc]initWithFrame:CGRectMake(xOffset, 0, 320, MINeqpHeight-20)];
    [imgEqpBack setImage:[[UIImage imageNamed:@"EquipmentList"]stretchableImageWithLeftCapWidth:0 topCapHeight:90]];
    
    UIImageView *imgPullBtn = [[UIImageView alloc]initWithFrame:CGRectMake(xOffset, MINeqpHeight-20, 320, 20)];
    [imgPullBtn setImage:[UIImage imageNamed:@"Equipmentbutton"]];
    
    StyledPullableView* pullDownView = [[StyledPullableView alloc] initWithFrame:CGRectMake(xOffset, 0, 320, MINeqpHeight)];
    
    pullDownView.openedCenter = CGPointMake(160 + xOffset,(MINeqpHeight/2));
    pullDownView.closedCenter = CGPointMake(160 + xOffset, -((MINeqpHeight/2)-20));
    pullDownView.animate = YES;
    pullDownView.delegate = self;
    pullDownView.center = pullDownView.closedCenter;
    [pullDownView addSubview:imgPullBtn];
    [pullDownView addSubview:imgEqpBack];
    [pullDownView addSubview:label];
    [pullDownView addSubview:scrollView];
    
    [self.view addSubview:pullDownView];
}

-(IBAction)btnHeaderbackPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnSkipPressed:(id)sender{
    NSMutableArray *kStringArray=[[NSMutableArray alloc]init];
    if ([aryStepsData count]>0) {
        for(int i=1;i<aryStepsData.count+1;i++){
            [kStringArray addObject:[NSString stringWithFormat:@"Step     %d",i]];
        }
        CGPoint point=CGPointMake(310,-10);
        self.pv = [PopoverView showPopoverAtPoint:point
                                           inView:self.view
                                  withStringArray:kStringArray
                                         delegate:self];
    }
    
    
}

-(IBAction)btnReportPressed:(id)sender{
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

-(IBAction)btnLikePressed:(id)sender{
    dispatch_async(dispatch_get_main_queue(),^{
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        dispatch_async(kBgQueue,^{
            [self LikeChallangeMode:sender];
        });
    });
}

-(void)LikeChallangeMode:(id)sender{
    
    dispatch_async(dispatch_get_main_queue(),^{
        objTakeChallenge = [arrAllTakeChallenges objectAtIndex:self.pageControll.currentPage];
        PFUser *user;
        PFObject *obj;
        PFQuery *queryForLikeComment=[PFQuery queryWithClassName:@"tbl_Likes_TakeChallenge"];
        [queryForLikeComment whereKey:@"TakeChallengeID" equalTo:[objTakeChallenge objectId]];
        [queryForLikeComment includeKey:@"userId"];
        [queryForLikeComment addDescendingOrder:@"createdAt"];
        
        NSMutableArray *arrAllData=[[NSMutableArray alloc]initWithArray:[queryForLikeComment findObjects]];
        
        if ([arrAllData count] == 0){
            IsLiked=NO;
        }
        for (int i = 0; i < [arrAllData count]; i++) {
            obj=[arrAllData objectAtIndex:i];
            user=[obj objectForKey:@"userId"];
            
            if ([[user username] isEqualToString:[[PFUser currentUser] username]]) {
                IsLiked=YES;
                break;
            }
        }
        if (IsLiked == YES){
            IsLiked = NO;
            if ([[user username] isEqualToString:[[PFUser currentUser] username]]) {
                [obj delete];
                [self findLikes];
                
                dispatch_async(dispatch_get_main_queue(),^{
                    [MBProgressHUD hideHUDForView:self.view animated:TRUE];
                });
            }
        }else{
            PFObject *like = [PFObject objectWithClassName:@"tbl_Likes_TakeChallenge"];
            
            [like setObject:[PFUser currentUser] forKey:@"userId"];
            [like setObject:[[PFUser currentUser]objectId] forKey:@"LikeuserId"];
            [like setObject:[objTakeChallenge objectId] forKey:@"TakeChallengeID"];
            
            //Set ACL permissions for added security
            PFACL *commentACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [commentACL setPublicReadAccess:YES];
            [like setACL:commentACL];
            [like saveInBackgroundWithBlock:^(BOOL Done, NSError *error){
                if (!error) {
                    [self findLikes];
                    dispatch_async(dispatch_get_main_queue(),^{
                        [MBProgressHUD hideHUDForView:self.view animated:TRUE];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(),^{
                        [MBProgressHUD hideHUDForView:self.view animated:TRUE];
                    });
                    DisplayAlertWithTitle(@"FitTag", @"Unable to Like this step, please try again.")
                }
            }];
        }
    });
}

-(IBAction)btnCommentPressed:(id)sender{
    objTakeChallenge=[arrAllTakeChallenges objectAtIndex:self.pageControll.currentPage];
    CommentViewController *commentVC=[[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
    commentVC.title=@"Comment";
    commentVC.delegate=self;
    commentVC.challengeId = [objTakeChallenge objectId];
    commentVC.isTakeChallenge=TRUE;
    
    appdelegateRef.isTimeline=FALSE;
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma commentView Delegate Method

-(void)commentCount:(NSInteger)arrCount{
    [lblCommentCount setText:[NSString stringWithFormat:@"%d",arrCount]];
}

-(IBAction)btnSharePressed:(id)sender{
    
    UIButton *btnSender = (UIButton *)sender;
    
    buttonIndexForShareDataOnSocial = btnSender.tag-1;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share  Challenge" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"Facebook"];
    [actionSheet addButtonWithTitle:@"Twitter"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.destructiveButtonIndex = 2;
    actionSheet.tag = 20;
    [actionSheet showInView:self.view.window];
}

#pragma mark ActionSheet Delegate
//Action sheet for Image Capturing

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(actionSheet.tag == 20){
        
        switch (buttonIndex){
            case 0:{
                
                if([[[NSUserDefaults standardUserDefaults]objectForKey:@"facebookShare"] isEqualToString:@"ON"]){ // 22vinod
                    [self postToFcaebookUsersWall:buttonIndexForShareDataOnSocial];
                }else{
                    DisplayAlertWithTitle(@"FitTag", @"You have off your share setting for Facebook, Please switch it on in order to share on Facebook.")
                }
                break;
            }
            case 1:{
                
                /*UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"FitTag" message:@"OOPS ! Sorry for inconvenience. We are having some problems with twitter for now. We are working hard to solve the issue. We will get back to you soon." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
        // action for Roport this Challenge
    }
    if(actionSheet.tag == 10){
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
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)postToFcaebookUsersWall:(int )index{
    
    
  //  PFFile *teaserImage = [objChallengeInfo objectForKey:@"teaserfile"];
    PFFile *teaserImage;
   // PFFile *teaserImage = [objChallengeInfo objectForKey:@"teaserfile"];
    
    PFObject *obj=[aryStepsData objectAtIndex:self.pageControll.currentPage];
    PFFile *image = [obj objectForKey:@"image"];
    if (image) {
        teaserImage=image;
    }else{
        teaserImage = [objChallengeInfo objectForKey:@"teaserfile"];
    }
    NSString *strChallengeTags=@"";
    
    if([aryStepsData objectAtIndex:self.pageControll.currentPage] != nil){
        strChallengeTags = [[aryStepsData objectAtIndex:self.pageControll.currentPage] objectForKey:@"text"];
    }else{
        // prevent sharing if no step created.
    }
    
    [params removeAllObjects];
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"FitTag", @"name",[objChallengeInfo objectForKey:@"challengeName"], @"caption", strChallengeTags, @"description", [NSString stringWithFormat:@"http://www.fittag.com/challenge_details.php?id=%@",objChallengeInfo.objectId], @"link", nil];
    
    if([[[teaserImage name] pathExtension]isEqualToString:@"mov"] || [[[teaserImage name] pathExtension]isEqualToString:@"mp4"]){
        [params setObject:[teaserImage url] forKey:@"video"];
    }else{
        [params setObject:[teaserImage url] forKey:@"picture"];
    }
    if([PFFacebookUtils session].state == FBSessionStateOpen){
               
        [FBWebDialogs presentFeedDialogModallyWithSession:[PFFacebookUtils session]
                                               parameters:params
                                                  handler:
         ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
             if (error) {
                 // Case A: Error launching the dialog or publishing story.
             } else {
                 if (result == FBWebDialogResultDialogNotCompleted) {
                     // Case B: User clicked the "x" icon
                 } else {
                     // Case C: Dialog shown and the user clicks Cancel or Share
                     NSMutableDictionary *urlParams;// = [self parseURLParams:[resultURL query]];
                     if (![urlParams valueForKey:@"post_id"]) {
                         // User clicked the Cancel button
                     } else {
                         // User clicked the Share button
                        // NSString *postID = [urlParams valueForKey:@"post_id"];
                     }
                 }
             }
         }];
    }else{
        [PFFacebookUtils linkUser:[PFUser currentUser] permissions:FB_PERMISSIONS block:^(BOOL Success,NSError *error){
            
            if(!error){
                [FBWebDialogs presentFeedDialogModallyWithSession:[PFFacebookUtils session]
                                                       parameters:params
                                                          handler:
                 ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                     if (error) {
                         // Case A: Error launching the dialog or publishing story.
                     } else {
                         if (result == FBWebDialogResultDialogNotCompleted) {
                             // Case B: User clicked the "x" icon
                         } else {
                             // Case C: Dialog shown and the user clicks Cancel or Share
                             NSMutableDictionary *urlParams;// = [self parseURLParams:[resultURL query]];
                             if (![urlParams valueForKey:@"post_id"]) {
                                 // User clicked the Cancel button
                             }else{
                                 // User clicked the Share button
                                // NSString *postID = [urlParams valueForKey:@"post_id"];
                             }
                         }
                     }
                 }];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"FitTag" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

-(void)postToTwitterAsTwitt:(int)index{
    
    // Test code for Twitter image posting
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *status = [objChallengeInfo objectForKey:@"tags"];
    
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
    
    if(imageData){
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
        
        }else{
        
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)hanging{
     
    [self.view.layer removeAllAnimations];
    
    [imgViewLabel.layer removeAllAnimations];
    imgViewLabel.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
     
                     animations:^{
                         // Do your animations here.
                         imgViewLabel.transform = CGAffineTransformMakeRotation(degreesToRadians(45));
                     }
                     completion:^(BOOL finished)
     {
         [self.view.layer removeAllAnimations];
         if(!finished){
             imgViewLabel.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
         }
         
         if (finished){
             // Do your method here after your animation.
             [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^
              {
                  imgViewLabel.transform = CGAffineTransformMakeRotation(degreesToRadians(-45));
              }
                              completion:^(BOOL finished){
                                  [imgViewLabel.layer removeAllAnimations];
                                  if(!finished){
                                      imgViewLabel.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
                                  }
                                  if (finished) {
                                      // Do your method here after your animation.
                                      [UIView animateWithDuration:0.25f delay:0.0f  options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                                          // Do your animations here.
                                          imgViewLabel.transform = CGAffineTransformMakeRotation(degreesToRadians(35));
                                      }
                                                       completion:^(BOOL finished)
                                       {
                                           [imgViewLabel.layer removeAllAnimations];
                                           if(!finished){
                                               imgViewLabel.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
                                           }
                                           if (finished){
                                               // Do your method here after your animation.
                                               [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^
                                                {
                                                    // Do your animations here.
                                                    imgViewLabel.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
                                                }
                                                                completion:nil];
                                           }
                                       }];
                                  }
                              }];
         }
     }];
}

-(IBAction)peopleLikeThis:(id)sender{
    
    objTakeChallenge = [arrAllTakeChallenges objectAtIndex:self.pageControll.currentPage];
    [self findLikes];
    NSMutableArray *arrLikers = [[NSMutableArray alloc]initWithArray:[objTakeChallenge objectForKey:@"likesAndComments"]];
    
    if ([arrLikers count] > 0){
        [btnLikers setEnabled:TRUE];
        LikerListViewController *OBJLikerListViewController = [[LikerListViewController alloc]initWithNibName:@"LikerListViewController" bundle:nil];
        OBJLikerListViewController.title = @"Likers";
        OBJLikerListViewController.arrLikerList = arrLikers;
        [self.navigationController pushViewController:OBJLikerListViewController animated:TRUE];
    }else{
        [btnLikers setEnabled:FALSE];
    }
}

#pragma mark change controls place

-(void)rearrangeViewAccordingToData{
    
    [btnLikers setFrame:CGRectMake(36, lblDiscription.frame.size.height+lblDiscription.frame.origin.y, 111, 21)];
    
    [lblLikerCount setFrame:CGRectMake(11, lblDiscription.frame.size.height+lblDiscription.frame.origin.y, 42, 21)];
    
    [btnLike setFrame:CGRectMake(9,btnLikers.frame.size.height+btnLikers.frame.origin.y , 24,24)];
    
    [btnCOMMENT setFrame:CGRectMake(45, btnLikers.frame.size.height+btnLikers.frame.origin.y, 24, 24)];
    [lblCommentCount setFrame:CGRectMake(45, btnLikers.frame.size.height+btnLikers.frame.origin.y, 22, 17)];
    
    [btnShare setFrame:CGRectMake(80, btnLikers.frame.size.height+btnLikers.frame.origin.y, 24,24)];
    [imgShare setFrame:CGRectMake(267, btnLikers.frame.size.height+btnLikers.frame.origin.y, 33, 8)];
    
    [btnReport setFrame:CGRectMake(257, btnLikers.frame.size.height+btnLikers.frame.origin.y, 43, 29)];
    
    if([UIScreen mainScreen].bounds.size.height == 568.0) {
        scrollviewVertical.contentSize = CGSizeMake(scrollviewVertical.frame.size.width,btnShare.frame.origin.y+btnShare.frame.size.height+50);
    }else{
        scrollviewVertical.contentSize = CGSizeMake(scrollviewVertical.frame.size.width,btnShare.frame.origin.y+btnShare.frame.size.height+100);
    }
}

@end
