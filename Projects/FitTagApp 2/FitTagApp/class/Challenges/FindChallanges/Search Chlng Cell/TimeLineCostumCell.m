//
//  TimeLineCostumCell.m
//  FitTag
//
//  Created by apple on 3/14/13.

#import "TimeLineCostumCell.h"
#import "UIImageView+WebCache.h"
#import "CommentViewController.h"
#import "GlobalClass.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NSDate+TimeAgo.h"
#import "IFTweetLabel.h"
#import "STTweetLabel.h"
#import "TimeLineViewController_copy.h"
#import "ProfileViewController.h"

@implementation TimeLineCostumCell

@synthesize btnuserName1,btnuserName2,btnuserName3,btnuserName4;
@synthesize lblComment1,lblComment2,lblComment3,lblComment4,delegate,btnLikeLink1,tweetLikeUserNameLabel;
@synthesize txtViewLikes;
@synthesize btnLikeChallenge;
@synthesize btnComment;
@synthesize btnSeeOlgerComment;
@synthesize btnTakeChallenge;
@synthesize moviePlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andD:(PFObject *)dVal  row:(int)rowIndexPath userData:(NSMutableArray *)arrUserData{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        // Custom initialization
        objChallengeInfo=dVal;
        //StrLikesRow=StrLikesName;
        indexpathRow=rowIndexPath;
        arrUserDataClass=arrUserData;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTweetNotification:) name:IFTweetLabelURLNotification object:nil];
    }
    return self;
}
-(void)viewDidLoad{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    //Set Custom font to UILable and UIButton UITestView
    [lblChallengeName setFont:[UIFont fontWithName:@"DynoBold" size:17]];
    [lblTime setFont:[UIFont fontWithName:@"DynoBold" size:10]];
    [txtViewDescriptionTag setFont:[UIFont fontWithName:@"DynoRegular" size:12]];
    [txtViewLikes setFont:[UIFont fontWithName:@"DynoRegular" size:12]];
    [lblLocation setFont:[UIFont fontWithName:@"DynoRegular" size:10]];
    [lblComment1 setFont:[UIFont fontWithName:@"DynoRegular" size:12]];
    [lblComment2 setFont:[UIFont fontWithName:@"DynoRegular" size:12]];
    [lblComment3 setFont:[UIFont fontWithName:@"DynoRegular" size:12]];
    [lblComment4 setFont:[UIFont fontWithName:@"DynoRegular" size:12]];
    [lblUserName.titleLabel setFont:[UIFont fontWithName:@"DynoBold" size:12]];
    [btnuserName1.titleLabel setFont:[UIFont fontWithName:@"DynoBold" size:12]];
    [btnuserName2.titleLabel setFont:[UIFont fontWithName:@"DynoBold" size:12]];
    [btnuserName3.titleLabel setFont:[UIFont fontWithName:@"DynoBold" size:12]];
    [btnuserName4.titleLabel setFont:[UIFont fontWithName:@"DynoBold" size:12]];
    
    // Do any additional setup after loading the view from its nib.
    objUserInfo = [objChallengeInfo objectForKey:@"userId"];
    PFFile *uesrProfileImage = [objUserInfo objectForKey:@"userPhoto"];
    PFFile *teaserImage = [objChallengeInfo objectForKey:@"teaserfile"];
    
    //Checking Tease type is Vedion or Image
    if([[[teaserImage name] pathExtension]isEqualToString:@"mov"] || [[[teaserImage name] pathExtension]isEqualToString:@"mp4"]){
        moviePlayer = [[MPMoviePlayerController alloc] init];
        PFFile *teaserImage = [objChallengeInfo objectForKey:@"teaserVedioThumbNail"];
        EGOImageView *imagThumnail = [[EGOImageView alloc]init];
        [imagThumnail setFrame:CGRectMake(0.0,.0,teaserEgoImageView.size.width,teaserEgoImageView.size.height)];
        [teaserEgoImageView setImageWithURL:[NSURL URLWithString:[teaserImage url]]];
        [teaserEgoImageView sendSubviewToBack:moviePlayer.view];
        
    }else{
        [teaserEgoImageView setImageWithURL:[NSURL URLWithString:[teaserImage url]] placeholderImage:[UIImage imageNamed:@"TeaserBG.png"]];
    }
    
    [profilrEgoImageView setImageWithURL:[NSURL URLWithString:[uesrProfileImage url]] placeholderImage:[UIImage imageNamed:@"nothing.png"]];
    profilrEgoImageView.layer.masksToBounds = YES;
    profilrEgoImageView.clipsToBounds=YES;
    [profilrEgoImageView.layer setBorderWidth:1.5];
    [profilrEgoImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [teaserEgoImageView setImageWithURL:[NSURL URLWithString:[teaserImage url]] placeholderImage:[UIImage imageNamed:@"TeaserBG.png"]];
    
    teaserEgoImageView.layer.masksToBounds = YES;
    teaserEgoImageView.clipsToBounds=YES;
    
    [lblUserName setTitle:[objUserInfo username] forState:UIControlStateHighlighted];
    [lblUserName setTitle:[objUserInfo username] forState:UIControlStateNormal];
    lblChallengeName.text = [objChallengeInfo objectForKey:@"challengeName"];
    
    //Find Challenge name Size
    CGSize challengeNameSize = [[objChallengeInfo objectForKey:@"challengeName"]sizeWithFont:[UIFont fontWithName:@"DynoBold" size:17]constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    lblLocation.text = [objChallengeInfo objectForKey:@"locationName"];
    lblChallengeName.frame = CGRectMake(6, 0, 306, challengeNameSize.height);
    
    //Set Dynamic Height of all UI
    lblLocation.frame = CGRectMake(6.0, lblChallengeName.frame.size.height+lblChallengeName.frame.origin.y, 307.0, 20.0);
    teaserEgoImageView.frame = CGRectMake(5.0, lblLocation.frame.origin.y+lblLocation.frame.size.height+1, 310.0,326.30);
    profilrEgoImageView.frame=CGRectMake(6, teaserEgoImageView.origin.y+teaserEgoImageView.frame.size.height+5, 71, 57);
    lblUserName.frame=CGRectMake(89, teaserEgoImageView.origin.y+teaserEgoImageView.frame.size.height+5, 176, 10);
    btnTakeChallenge.frame=CGRectMake(6, profilrEgoImageView.origin.y+profilrEgoImageView.frame.size.height, 71, 30);
    lblTime.frame=CGRectMake(241, teaserEgoImageView.origin.y+teaserEgoImageView.frame.size.height, 72, 17);
    
    //Find #tag string size
    NSString *string = [objChallengeInfo objectForKey:@"tags"];
    CGSize stringSize = [string sizeWithFont:[UIFont boldSystemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    //Add clickable label for #tag
    STTweetLabel *objSTTweetLabel=[self setTweetLabelForLikeUser:[objChallengeInfo objectForKey:@"tags"] textSize:stringSize];
    [srcView addSubview:objSTTweetLabel];
    [srcView setFrame:CGRectMake(89, lblUserName.origin.y+lblUserName.frame.size.height+2, 200, objSTTweetLabel.size.height)];
    objSTTweetLabel=nil;
    [lblrichTextLblAttherate setText:[objChallengeInfo objectForKey:@"tags"]];
    
    [lineImageView1 setFrame:CGRectMake(90, srcView.size.height+srcView.origin.y+3, 204, 1)];
    [txtViewLikes setFrame:CGRectMake(89, srcView.size.height+srcView.origin.y+5, 215, 33)];
    [lineImageView2 setFrame:CGRectMake(90, txtViewLikes.size.height+txtViewLikes.origin.y, 204, 1)];
    NSDate *CreatedDate = [objChallengeInfo createdAt];
    lblTime.text = [CreatedDate timeAgo];
    
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    [arr addObjectsFromArray:[objChallengeInfo objectForKey:@"likesAndComments"]];
   //Add Dynamic UILable For Comment and User name on bases of comment count
    //Arr is a comment array
    if ([arr count]>0) {
        txtViewLikes.textColor = [UIColor clearColor];
        [txtViewLikes setHidden:NO];
        [lineImageView2 setHidden:NO];
        switch ([arr count]){
                
            case 1:{

                PFObject *objActivity=[arr objectAtIndex:0];
                PFUser *user = [objActivity objectForKey:@"userId"];
                
                if ([[user username] isEqualToString:[[PFUser currentUser] username]]) {
                    txtViewLikes.text = [[NSString stringWithFormat:@"You" @" Like this"] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    [lblrichTextLblAttherate positionAtX:5.0];
                }else{
                    txtViewLikes.text = [[NSString stringWithFormat:@"@%@ %@",[user username],@"Like this"] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    [lblrichTextLblAttherate positionAtX:5.0];
                    
                }
                
                CGSize stringSize = [string sizeWithFont:[UIFont boldSystemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];

                STTweetLabel *objSTTweetLabel1=[self setTweetLabelForLikeUser:txtViewLikes.text textSize:stringSize];
                objSTTweetLabel1.text=txtViewLikes.text;
                [txtViewLikes addSubview:objSTTweetLabel1];
                [txtViewLikes setText:@""];
                
                [btnLikeChallenge setFrame:CGRectMake(89, txtViewLikes.origin.y+txtViewLikes.size.height+8, 28, 25)];
                [btnComment setFrame:CGRectMake(135, txtViewLikes.origin.y+txtViewLikes.size.height+8, 28, 25)];
                [btnShare setFrame:CGRectMake(181, txtViewLikes.origin.y+txtViewLikes.size.height+8, 23, 26)];
                [btnReport setFrame:CGRectMake(254, txtViewLikes.origin.y+txtViewLikes.size.height+8, 59, 32)];
            }
                break;
                
            case 2:{
                
//                NSNotification *notif = [NSNotification notificationWithName:@"userLikeNameButton" object:self];
//                [[NSNotificationCenter defaultCenter] postNotification:notif];
               // lblrichTextLblAttherate = lbluserLikeNameButton;
                PFObject *objActivity=[arr objectAtIndex:0];
                PFUser *user=[objActivity objectForKey:@"userId"];
                
                PFObject *objActivity2=[arr objectAtIndex:1];
                PFUser *user2=[objActivity2 objectForKey:@"userId"];
                
                if ([[user username] isEqualToString:[[PFUser currentUser] username]] ||[[user2 username] isEqualToString:[[PFUser currentUser] username]]) {
                    txtViewLikes.text = [[NSString stringWithFormat:@"You,@%@ %@",[user2 username],@"Likes this"] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    
                    [lblrichTextLblAttherate positionAtX:10.0];
                }else{
                    
                    txtViewLikes.text = [[NSString stringWithFormat:@"@%@ @%@ %@",[user username],[user2 username],@"Likes this"] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    [lblrichTextLblAttherate positionAtX:5.0];
                }
                
                CGSize stringSize = [string sizeWithFont:[UIFont boldSystemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
                
               STTweetLabel *objSTTweetLabel2= [self setTweetLabelForLikeUser:txtViewLikes.text textSize:stringSize];
                objSTTweetLabel2.text=txtViewLikes.text;

                [txtViewLikes addSubview:objSTTweetLabel2];
                [txtViewLikes setText:@""];
                [btnLikeChallenge setFrame:CGRectMake(89,txtViewLikes.origin.y+txtViewLikes.size.height+8, 28, 25)];
                [btnComment setFrame:CGRectMake(135,txtViewLikes.origin.y+txtViewLikes.size.height+8, 28, 25)];
                [btnShare setFrame:CGRectMake(181,txtViewLikes.origin.y+txtViewLikes.size.height+8, 23, 25)];
                [btnReport setFrame:CGRectMake(254,txtViewLikes.origin.y+txtViewLikes.size.height+8, 59, 32)];
                
            }
                break;
            case 3:{
//                NSNotification *notif = [NSNotification notificationWithName:@"userLikeNameButton" object:self];
//                [[NSNotificationCenter defaultCenter] postNotification:notif];
             //   lblrichTextLblAttherate = lbluserLikeNameButton;
                
                PFObject *objActivity=[arr objectAtIndex:0];
                PFUser *user=[objActivity objectForKey:@"userId"];
                
                PFObject *objActivity2=[arr objectAtIndex:1];
                PFUser *user2=[objActivity2 objectForKey:@"userId"];
                
                PFObject *objActivity3=[arr objectAtIndex:2];
                PFUser *user3=[objActivity3 objectForKey:@"userId"];
                if ([[user username] isEqualToString:[[PFUser currentUser] username]] ||[[user2 username] isEqualToString:[[PFUser currentUser] username]] ||[[user3 username] isEqualToString:[[PFUser currentUser] username]]){
                    txtViewLikes.text = [[NSString stringWithFormat:@"You, @%@ @%@ %@",[user2 username],[user3 username],@"Likes this"] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    [lblrichTextLblAttherate positionAtX:10.0];
                }
                else{
                    txtViewLikes.text = [[NSString stringWithFormat:@"@%@ @%@ @%@ %@",[user username],[user2 username],[user3 username],@"Likes this"] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    [lblrichTextLblAttherate positionAtX:5.0];
                }
                
                CGSize stringSize = [string sizeWithFont:[UIFont boldSystemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
                
               STTweetLabel *objSTTweetLabel3= [self setTweetLabelForLikeUser:txtViewLikes.text textSize:stringSize];
                objSTTweetLabel3.text=txtViewLikes.text;

                [txtViewLikes addSubview:objSTTweetLabel3];
                [txtViewLikes setText:@""];
                [btnLikeChallenge setFrame:CGRectMake(89, txtViewLikes.origin.y+txtViewLikes.size.height+8, 28, 25)];
                [btnComment setFrame:CGRectMake(135, txtViewLikes.origin.y+txtViewLikes.size.height+8, 28, 25)];
                [btnShare setFrame:CGRectMake(181, txtViewLikes.origin.y+txtViewLikes.size.height+8, 23, 25)];
                [btnReport setFrame:CGRectMake(254, txtViewLikes.origin.y+txtViewLikes.size.height+8, 59, 32)];
            }
                break;
            default:{
                
//                NSNotification *notif = [NSNotification notificationWithName:@"userLikeNameButton" object:self];
//                [[NSNotificationCenter defaultCenter] postNotification:notif];
                lblrichTextLblAttherate=lbluserLikeNameButton;
                PFObject *objActivity=[arr objectAtIndex:0];
                PFUser *user=[objActivity objectForKey:@"userId"];
                
                PFObject *objActivity2=[arr objectAtIndex:1];
                PFUser *user2=[objActivity2 objectForKey:@"userId"];
                
                PFObject *objActivity3=[arr objectAtIndex:2];
                PFUser *user3=[objActivity3 objectForKey:@"userId"];
                
                
                if ([[user username] isEqualToString:[[PFUser currentUser] username]] ||[[user2 username] isEqualToString:[[PFUser currentUser] username]] ||[[user3 username] isEqualToString:[[PFUser currentUser] username]]) {
                    txtViewLikes.text = [[NSString stringWithFormat:@"You, @%@ @%@ %@ %@",[user2 username],[user3 username],[NSString stringWithFormat:@"& %d people",arr.count-3],@"Likes this"] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    
                    //To find the position of word
                    
                    UITextPosition *Pos2 = [txtViewLikes positionFromPosition: txtViewLikes.endOfDocument offset: nil];
                    UITextPosition *Pos1 = [txtViewLikes positionFromPosition: txtViewLikes.endOfDocument offset: -18];
                    
                    UITextRange *range = [txtViewLikes textRangeFromPosition:Pos1 toPosition:Pos2];
                    
                    CGRect result1 = [txtViewLikes firstRectForRange:(UITextRange *)range ];
                    [lblrichTextLblAttherate positionAtX:10.0];
                    lblrichTextLblAttherate.likerCount=[arr count];
                    btnLikers.frame=CGRectMake(result1.origin.x-20, result1.origin.y-10, result1.size.width, result1.size.height);
                    btnLikers.tag= indexpathRow+1;
                    [txtViewLikes addSubview:btnLikers];
                    [btnLikers setHidden:NO];
                }else{
                    txtViewLikes.text = [[NSString stringWithFormat:@"@%@ @%@ @%@ %@ %@",[user username],[user2 username],[user3 username],[NSString stringWithFormat:@" & %d people",arr.count-3],@"Likes this"] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    [lblrichTextLblAttherate positionAtX:5.0];
                }
                
                CGSize stringSize = [string sizeWithFont:[UIFont boldSystemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
                
               STTweetLabel *objSTTweetLabel4 = [self setTweetLabelForLikeUser:txtViewLikes.text textSize:stringSize];
                objSTTweetLabel4.text=txtViewLikes.text;
                [txtViewLikes addSubview:objSTTweetLabel4];
                [txtViewLikes sendSubviewToBack:lblrichTextLblAttherate];
                [txtViewLikes bringSubviewToFront:btnLikers];
                [txtViewLikes setText:@""];
                
                [btnLikeChallenge setFrame:CGRectMake(89, txtViewLikes.origin.y+txtViewLikes.size.height+8, 28, 25)];
                [btnComment setFrame:CGRectMake(135, txtViewLikes.origin.y+txtViewLikes.size.height+5, 28, 25)];
                [btnShare setFrame:CGRectMake(181, txtViewLikes.origin.y+txtViewLikes.size.height+5, 23, 25)];
                [btnReport setFrame:CGRectMake(254, txtViewLikes.origin.y+txtViewLikes.size.height+5, 59, 32)];
                
            }
                break;
        }
    }
    else{
        
        txtViewLikes.text = @"Be the first person to like this!!!";
        [txtViewLikes setTextColor:[UIColor blackColor]];
        [txtViewLikes setHidden:YES];
        [lineImageView2 setHidden:YES];
        [btnLikeChallenge setFrame:CGRectMake(89, srcView.origin.y+srcView.size.height+8, 28, 25)];
        [btnComment setFrame:CGRectMake(135, srcView.origin.y+srcView.size.height+5, 28, 25)];
        [btnShare setFrame:CGRectMake(181, srcView.origin.y+srcView.size.height+5, 23, 25)];
        [btnReport setFrame:CGRectMake(254, srcView.origin.y+srcView.size.height+5, 59, 32)];
    }
    
    NSMutableArray *arrComments=[[NSMutableArray alloc]init];
    [arrComments addObjectsFromArray:[objChallengeInfo objectForKey:@"onlyComments"]];
    if([arrComments count]>4){
        [btnSeeOlgerComment setHidden:NO];
        int intTotalComment=arrComments.count-4;
        [btnSeeOlgerComment setTitle:[NSString stringWithFormat:@"See %d older comments",intTotalComment] forState:UIControlStateNormal];
        
    }else{
        [btnSeeOlgerComment setHidden:YES];
    }
        if ([arrComments count]==0 && [arr count]==0) {
        [btnLikeChallenge setFrame:CGRectMake(89, lineImageView1.origin.y+2, 28, 25)];
        [btnComment setFrame:CGRectMake(135, lineImageView1.origin.y+2, 28, 25)];
        [btnShare setFrame:CGRectMake(181, lineImageView1.origin.y+2, 23, 25)];
        [btnReport setFrame:CGRectMake(254, lineImageView1.origin.y+2, 59, 32)];
    }else{
        
        [btnLikeChallenge setFrame:CGRectMake(89, txtViewLikes.origin.y+txtViewLikes.size.height+5, 28, 25)];
        [btnComment setFrame:CGRectMake(135, txtViewLikes.origin.y+txtViewLikes.size.height+5, 28, 25)];
        [btnShare setFrame:CGRectMake(181, txtViewLikes.origin.y+txtViewLikes.size.height+5, 23, 25)];
        [btnReport setFrame:CGRectMake(254, txtViewLikes.origin.y+txtViewLikes.size.height+5, 59, 32)];
    }
    if ([arrComments count]>0) {
        
        for (int i=0; i<[arrComments count]; i++) {
            PFObject *objActivity=[arrComments objectAtIndex:i];
            PFUser *user=[objActivity objectForKey:@"userId"];
            CGSize stringsize = [[user username] sizeWithFont:[UIFont fontWithName:@"DynoBold" size:12]];
            if (i==0) {
                
                if ([arr count]==0) {
                    btnuserName1.frame=CGRectMake(btnuserName1.frame.origin.x,srcView.origin.y+srcView.size.height,stringsize.width, stringsize.height);
                    
                }
                else{
                    btnuserName1.frame=CGRectMake(btnuserName1.frame.origin.x,txtViewLikes.origin.y+txtViewLikes.size.height,stringsize.width, stringsize.height);
                }
                
                [btnuserName1 setTitle:[user username] forState:UIControlStateNormal];
                NSNotification *notif = [NSNotification notificationWithName:@"atSelectedAtTag" object:self];
                [[NSNotificationCenter defaultCenter] postNotification:notif];
                
                
                CGSize stringSize =CGSizeMake(166, 15);
                STTweetLabel *objSTTweetLabel3= [self setTweetLabelForLikeUser:txtViewLikes.text textSize:stringSize];
                objSTTweetLabel3.text=[objActivity objectForKey:@"CommentText"];
                [self.view addSubview:objSTTweetLabel3];
                
                
                if ([arr count]==0) {
                    btnuserName1.frame=CGRectMake(btnuserName1.frame.origin.x,srcView.origin.y+srcView.size.height+5,stringsize.width, stringsize.height);
                    
                }else{
                    btnuserName1.frame=CGRectMake(btnuserName1.frame.origin.x,txtViewLikes.origin.y+txtViewLikes.size.height,stringsize.width, stringsize.height);
                }
                if ([arr count]==0) {
                    
                    [objSTTweetLabel3 setFrame:CGRectMake(btnuserName1.origin.x+btnuserName1.size.width+5, srcView.origin.y+srcView.size.height+5, 166, 15)];
                    
                }else{
                    
                    [objSTTweetLabel3 setFrame:CGRectMake(btnuserName1.origin.x+btnuserName1.size.width+5, txtViewLikes.origin.y+txtViewLikes.size.height, 166, 15)];
                }

                [btnLikeChallenge setFrame:CGRectMake(89, btnuserName1.origin.y+btnuserName1.size.height+5, 28, 25)];
                [btnComment setFrame:CGRectMake(135, btnuserName1.origin.y+btnuserName1.size.height+5, 28, 25)];
                [btnShare setFrame:CGRectMake(181, btnuserName1.origin.y+btnuserName1.size.height+5, 23, 25)];
                [btnReport setFrame:CGRectMake(254, btnuserName1.origin.y+btnuserName1.size.height+5, 59, 32)];
                [lblrichTextLblAttherate setWidth:150];
             
            }else if(i == 1){
                
                btnuserName2.Frame=CGRectMake(btnuserName2.frame.origin.x,btnuserName1.frame.origin.y+btnuserName1.size.height,stringsize.width, stringsize.height);
                [btnuserName2 setTitle:[user username] forState:UIControlStateNormal];
                
                NSNotification *notif = [NSNotification notificationWithName:@"atSelectedAtTag" object:self];
                [[NSNotificationCenter defaultCenter] postNotification:notif];
                CGSize stringSize =CGSizeMake(166, 15);
                STTweetLabel *objSTTweetLabel3= [self setTweetLabelForLikeUser:txtViewLikes.text textSize:stringSize];
                objSTTweetLabel3.text=[objActivity objectForKey:@"CommentText"];
                [objSTTweetLabel3 setFrame:CGRectMake(btnuserName2.origin.x+btnuserName2.size.width+5, btnuserName1.frame.origin.y+btnuserName1.size.height, 166, 15)];
                
                [self.view addSubview:objSTTweetLabel3];

                [btnLikeChallenge setFrame:CGRectMake(89, btnuserName2.origin.y+btnuserName2.size.height+5, 28, 25)];
                [btnComment setFrame:CGRectMake(135, btnuserName2.origin.y+btnuserName2.size.height+5, 28, 25)];
                [btnShare setFrame:CGRectMake(181, btnuserName2.origin.y+btnuserName2.size.height+5, 23, 25)];
                [btnReport setFrame:CGRectMake(254, btnuserName2.origin.y+btnuserName2.size.height+5, 59, 32)];
               
                [lblrichTextLblAttherate setWidth:150];
                
            }else if(i == 2){
                btnuserName3.Frame=CGRectMake(btnuserName3.frame.origin.x,btnuserName2.frame.origin.y+btnuserName2.size.height,stringsize.width, stringsize.height);
                
                [btnuserName3 setTitle:[user username] forState:UIControlStateNormal];
                               
                NSNotification *notif = [NSNotification notificationWithName:@"atSelectedAtTag" object:self];
                [[NSNotificationCenter defaultCenter] postNotification:notif];
                CGSize stringSize =CGSizeMake(166, 15);
                STTweetLabel *objSTTweetLabel3 = [self setTweetLabelForLikeUser:txtViewLikes.text textSize:stringSize];
                objSTTweetLabel3.text=[objActivity objectForKey:@"CommentText"];
                [objSTTweetLabel3 setFrame:CGRectMake(btnuserName3.origin.x+btnuserName3.size.width+5, btnuserName2.frame.origin.y+btnuserName2.size.height, 166, 15)];
                
                [self.view addSubview:objSTTweetLabel3];
               
//                NSString *mystr=[objActivity objectForKey:@"CommentText"];
//                if (mystr.length>35) {
//                    mystr=[mystr substringToIndex:35];
//                }
                [btnLikeChallenge setFrame:CGRectMake(89, btnuserName3.origin.y+btnuserName3.size.height+5, 28, 25)];
                [btnComment setFrame:CGRectMake(135, btnuserName3.origin.y+btnuserName3.size.height+5, 28, 25)];
                [btnShare setFrame:CGRectMake(181, btnuserName3.origin.y+btnuserName3.size.height+5, 23, 25)];
                [btnReport setFrame:CGRectMake(254, btnuserName3.origin.y+btnuserName3.size.height+5, 59, 32)];
                [lblrichTextLblAttherate setWidth:150];
            }else if(i == 3){
                btnuserName4.Frame=CGRectMake(btnuserName4.frame.origin.x,btnuserName3.frame.origin.y+btnuserName3.size.height,stringsize.width, stringsize.height);
                [btnuserName4 setTitle:[user username] forState:UIControlStateNormal];
                
                NSNotification *notif = [NSNotification notificationWithName:@"atSelectedAtTag" object:self];
                [[NSNotificationCenter defaultCenter] postNotification:notif];
                CGSize stringSize =CGSizeMake(166, 15);
                STTweetLabel *objSTTweetLabel3= [self setTweetLabelForLikeUser:txtViewLikes.text textSize:stringSize];
                objSTTweetLabel3.text=[objActivity objectForKey:@"CommentText"];
                 [objSTTweetLabel3 setFrame:CGRectMake(btnuserName4.origin.x+btnuserName4.size.width+5, btnuserName3.frame.origin.y+btnuserName3.size.height, 166, 15)];
                [self.view addSubview:objSTTweetLabel3];
//                NSString *mystr=[objActivity objectForKey:@"CommentText"];
//                if (mystr.length>35) {
//                    mystr=[mystr substringToIndex:35];
//                }
                [btnLikeChallenge setFrame:CGRectMake(89, btnuserName4.origin.y+btnuserName3.size.height+5, 28, 25)];
                [btnComment setFrame:CGRectMake(135, btnuserName4.origin.y+btnuserName4.size.height+5, 28, 25)];
                [btnShare setFrame:CGRectMake(181, btnuserName4.origin.y+btnuserName4.size.height+5, 23, 25)];
                [btnReport setFrame:CGRectMake(254, btnuserName4.origin.y+btnuserName4.size.height+5, 59, 32)];
                
            }else{
                break;
            }
        }
    }
    
    [txtViewLikes setTag:indexpathRow+1];
    [btnReport setTag:indexpathRow+1];
    [btnLikeChallenge setTag:indexpathRow+1];
    [lblUserName setTag:indexpathRow+1];
    [btnComment setTag:indexpathRow+1];
    [btnSeeOlgerComment setTag:indexpathRow+1];
    [btnTakeChallenge setTag:indexpathRow+1];
    [btnShare setTag:indexpathRow+1];
    
    //Buttons for UserName Display
    [btnuserName1 setTag:(indexpathRow+1)+111];
    [btnuserName2 setTag:(indexpathRow+1)+112];
    [btnuserName3 setTag:(indexpathRow+1)+113];
    [btnuserName4 setTag:(indexpathRow+1)+114];
    
    //Lable for Comment Display
    [lblComment1 setTag:(indexpathRow+1)+211];
    [lblComment2 setTag:(indexpathRow+1)+212];
    [lblComment3 setTag:(indexpathRow+1)+213];
    [lblComment4 setTag:(indexpathRow+1)+214];
    UIImageView *imgReport=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 33, 8)];
    [imgReport setImage:[UIImage imageNamed:@"btnReport"]];
    [btnReport addSubview:imgReport];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CommentBackAction" object:nil];
}
-(STTweetLabel *)setTweetLabelForLikeUser :(NSString*)text textSize:(CGSize)size{
    STTweetLabel* _tweetLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(0, 0, 200, size.height)];
    [_tweetLabel setFont:[UIFont fontWithName:@"DynoRegular" size:12]];
    [_tweetLabel setTextColor:[UIColor blackColor]];
    [_tweetLabel setText:[objChallengeInfo objectForKey:@"tags"]];
    
    STLinkCallbackBlock callbackBlock = ^(STLinkActionType actionType, NSString *link) {
        
        
        switch (actionType) {
            case STLinkActionTypeAccount:
                [self newUserSelection:link];
                break;
            case STLinkActionTypeHashtag:
                [self newHashSelection:link];
                break;
            case STLinkActionTypeWebsite:
                break;
        }
    };
    [_tweetLabel setCallbackBlock:callbackBlock];
    return _tweetLabel;
}
-(UIButton *)likebtnCreate:(NSString*)strUserName{
    return nil;
}
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
-(void)viewDidUnload {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IFTweetLabelURLNotification object:nil];
    
    btnuserName1 = nil;
    btnuserName2 = nil;
    btnuserName3 = nil;
    btnuserName4 = nil;
    
    lblComment1 = nil;
    lblComment2 = nil;
    lblComment3 = nil;
    lblComment4 = nil;
    [self setBtnTakeChallenge:nil];
    [super viewDidUnload];
}
-(void)handleTweetNotification:(NSNotification *)notification{
}
#pragma mark 
#pragma mark Click on #tag lable And send notification
-(void)newHashSelection:(NSString *)hashName{
    hashName=[hashName substringFromIndex:1];
    if ([appDelegate.controllerName isEqualToString:@"TimeLineViewController_copy"]) {
        NSNotification *notif1 = [NSNotification notificationWithName:@"clickOnHashTagsTimelinecopy" object:hashName];
        [[NSNotificationCenter defaultCenter] postNotification:notif1];
    }
    else if([appDelegate.controllerName isEqualToString:@"ProfileViewController"]){
        NSNotification *notif1 = [NSNotification notificationWithName:@"clickOnHashTagsProfile" object:hashName];
        [[NSNotificationCenter defaultCenter] postNotification:notif1];
    }
    else{
        NSNotification *notif = [NSNotification notificationWithName:@"clickOnHashTags" object:hashName];
        [[NSNotificationCenter defaultCenter] postNotification:notif];
    }
}
#pragma mark
#pragma mark Click on @username lable And send notification
-(void)newUserSelection:(NSString *)userName{
    
    userName=[userName substringFromIndex:1];
    
    if ([appDelegate.controllerName isEqualToString:@"TimeLineViewController_copy"]) {
        NSNotification *notif = [NSNotification notificationWithName:@"userLikeNameButtonTimeLinecopy" object:userName];
        [[NSNotificationCenter defaultCenter] postNotification:notif];;
    }
    else if([appDelegate.controllerName isEqualToString:@"ProfileViewController"]){
        NSNotification *notif = [NSNotification notificationWithName:@"userLikeNameButtonProfile" object:userName];
        [[NSNotificationCenter defaultCenter] postNotification:notif];
    }
    else{
        
        NSNotification *notif = [NSNotification notificationWithName:@"userLikeNameButton" object:userName];
        [[NSNotificationCenter defaultCenter] postNotification:notif];
    }
}
@end
