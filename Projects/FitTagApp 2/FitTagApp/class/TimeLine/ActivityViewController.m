//
//  ActivityViewController.m
//  FitTag
//
//  Created by Mic mini 5 on 3/2/13.
//
//

#import "ActivityViewController.h"
#import "ActivityCell.h"
#import "SettingViewController.h"
#import "TimeLineViewController.h"
#import "ProfileViewController.h"
#import "NSDate+TimeAgo.h"
#import "ChallengeDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface ActivityViewController ()

@end
@implementation ActivityViewController
int const LIKE=0;
int const FOLLOWING=1;
int const COMMENT =2;
@synthesize viewMenu,isOpen,tblActivity;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidLoad{
    
    [super viewDidLoad];
    UIButton *btnback=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnback addTarget:self action:@selector(btnMenuActivityPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnback setFrame:CGRectMake(0, 0, 40, 44)];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [btnback setImage:[UIImage imageNamed:@"headerActivity"] forState:UIControlStateNormal];
    UIView *view123=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
    [view123 addSubview:btnback];
    
    UIBarButtonItem *btn123=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:NULL action:NULL];
    btn123.width=-16;
    UIBarButtonItem *btn132=[[UIBarButtonItem alloc] initWithCustomView:view123];
    self.navigationItem.leftBarButtonItems=[[NSArray alloc]initWithObjects:btn123,btn132,nil];
    arrAllData=[[NSMutableArray alloc]init];
   

    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    [self performSelector:@selector(getData) withObject:nil afterDelay:1.0];
        
}

-(void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidUnload {
    [self setTblActivity:nil];
    [self setViewMenu:nil];
    [super viewDidUnload];
}
#pragma mark
#pragma mark Get Comment On Like Information On Challeng of login user
-(void)getData{
    @try {
        PFQuery *quryForLike=[PFQuery queryWithClassName:@"tbl_comments"];
        [quryForLike whereKey:@"CreateduserId" equalTo:[[PFUser currentUser]objectId]];
        [quryForLike includeKey:@"userId"];
        NSArray *arr=[[NSArray alloc]initWithArray:[quryForLike findObjects]];
        [arrAllData addObjectsFromArray:arr];
        
        PFQuery *quryForLikeComment=[PFQuery queryWithClassName:@"tbl_Likes"];
        [quryForLikeComment whereKey:@"CreateduserId" equalTo:[[PFUser currentUser]objectId]];
        [quryForLikeComment includeKey:@"userId"];
        NSArray *arrComment=[[NSArray alloc]initWithArray:[quryForLikeComment findObjects]];
        [arrAllData addObjectsFromArray:arrComment];
        
        [self performSelectorInBackground:@selector(getCurrentUserFollowing) withObject:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"exception");
    }
}
#pragma mark
#pragma mark Get Following
-(void)getCurrentUserFollowing{
    @try {
        PFQuery *queryForfollower=[PFQuery queryWithClassName:@"Tbl_follower"];
        [queryForfollower whereKey:@"follower_id" equalTo:[[PFUser currentUser]objectId]];
        [queryForfollower includeKey:@"userId"];
        
        [queryForfollower addDescendingOrder:@"createdAt"];
        [arrAllData addObjectsFromArray:[[queryForfollower findObjects] mutableCopy]];
        
        NSMutableArray *array1=[[NSMutableArray alloc]init];
        for (int i=0; i<[arrAllData count]; i++) {
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            PFObject *objFollow=[arrAllData objectAtIndex:i];
            [dict setObject:objFollow forKey:@"New"];
            [dict setValue:[self changetodatestring:[objFollow createdAt] ] forKey:@"Date"];
            [array1 addObject:dict];
        }
        
        NSSortDescriptor * descriptor =[NSSortDescriptor sortDescriptorWithKey: @"Date" ascending: NO  comparator:^NSComparisonResult(id obj1, id obj2)
                                        {
                                            return [obj1 compare: obj2 options: NSNumericSearch];
                                        }];
        NSArray * sortedArray =[array1 sortedArrayUsingDescriptors:[NSArray arrayWithObject: descriptor]];
        
        NSMutableArray *temparry=[[NSMutableArray alloc]init];
        for (int k=0; k<[sortedArray count]; k++) {
            [temparry addObject:[[sortedArray objectAtIndex:k] objectForKey:@"New"]];
        }
        arrAllData=temparry;
        [MBProgressHUD hideHUDForView:self.view animated:TRUE];
        [tblActivity reloadData];
    
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
}
#pragma mark
#pragma Change Date in to string
-(NSString *)changetodatestring:(NSDate *)date{
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* wakeTime = [df stringFromDate:date];
    
    return wakeTime;
}
#pragma mark- TableView Delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrAllData count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell"];
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if (cell == nil) {
        cell = [[ActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  
    }
    [cell.imgViewUserProfile.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [cell.imgViewUserProfile .layer setBorderWidth:1.0];
    [cell.imgViewUserProfile .layer setBackgroundColor:[UIColor grayColor].CGColor];
    [cell.imgViewUserProfile .layer setCornerRadius:4.0];
    
    [cell.btnUserName.titleLabel setFont:[UIFont fontWithName:@"DynoBold" size:17]];
    
    cell.btnUserName.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [cell.lblComment setFont:[UIFont fontWithName:@"DynoRegular" size:17]];
    [cell.lblTime setFont:[UIFont fontWithName:@"DynoRegular" size:13]];
    
    PFObject *objFollow1 = [arrAllData objectAtIndex:indexPath.row];
    PFUser *folloowUSer = [objFollow1 objectForKey:@"userId"];
    PFFile *uesrProfileImage = [folloowUSer objectForKey:@"userPhoto"];
    
    [cell.imgViewUserProfile setImageURL:[NSURL URLWithString:[uesrProfileImage url]]];
    
    NSDate *CreatedDate=[objFollow1 createdAt];
    cell.lblTime.text=[CreatedDate timeAgo];
    
    [cell.btnUserName setTitle:[folloowUSer username] forState:UIControlStateNormal];
    [cell.btnUserName setTag:indexPath.row];
    [cell.btnUserName addTarget:self action:@selector(goToProfile:) forControlEvents:UIControlEventTouchUpInside];
    if ([[objFollow1 parseClassName] isEqualToString:@"Tbl_follower"]) {
         cell.lblTitle.text=@"Started following you";
        [cell.imgViewContent setHidden:TRUE];
        [cell.imgViewContentBg setHidden:TRUE];
    }
    else if ([[objFollow1 parseClassName] isEqualToString:@"tbl_Likes"]){
    
       cell.lblTitle.text=@"Likes your challenge";
        
       PFFile *teaserImage = [objFollow1 objectForKey:@"teaserfile"];
        NSLog(@"%@",teaserImage.url);
       [cell.imgViewContent setImageWithURL:[NSURL URLWithString:[teaserImage url]]];
        
    }else{
        cell.lblTitle.text = @"Commented on your challenge";
        PFFile *teaserImage = [objFollow1 objectForKey:@"teaserfile"];
        [cell.imgViewContent setImageWithURL:[NSURL URLWithString:[teaserImage url]]];
}
   
    [cell.imgViewContent setTag:indexPath.row];
    [cell.imgViewContent setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod:)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    [tap setDelegate:self];
    [cell.imgViewContent addGestureRecognizer:tap];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
#pragma mark
#pragma mark Go to Take challeng Screen on Click of Challenge picture
-(void)myTapMethod:(UITapGestureRecognizer *)tapGestureRecognizer{
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    
    PFObject *objFollow = [arrAllData objectAtIndex:[[tapGestureRecognizer view]tag]];
    PFQuery *postQuery  = [PFQuery queryWithClassName:@"Challenge"];
    [postQuery whereKey:@"objectId" equalTo:[objFollow objectForKey:@"ChallengeId"]];
    [postQuery addDescendingOrder:@"createdAt"];
    [postQuery includeKey:@"userId"];
    
    NSMutableArray *arrFirstChallenge= [[postQuery findObjects] mutableCopy];
    
    
    
    if ([arrFirstChallenge count]==0) {
       DisplayLocalizedAlert(@"This challenge has deleted")
    }
    else{
    ChallengeDetailViewController *chlngDetailVC=[[ChallengeDetailViewController alloc]initWithNibName:@"ChallengeDetailViewController" bundle:nil];
    chlngDetailVC.objChallengeInfo=[arrFirstChallenge objectAtIndex:0];
        [self.navigationController pushViewController:chlngDetailVC animated:YES];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
}
-(void)goToProfile:(id)sender{
    UIButton *btn  = (UIButton *)sender;
    NSString *name = btn.titleLabel.text;
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:name];
    NSArray *arr   = [[NSArray alloc]initWithArray:[query findObjects]];
    PFUser *user   = [arr objectAtIndex:0];
    ProfileViewController *obProfile = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    obProfile.profileUser = user;
    obProfile.title = @"Profile";
    [self.navigationController pushViewController:obProfile animated:TRUE];
}
#pragma mark
#pragma mark Button Actions
-(IBAction)btnHeaderbackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnMenuActivityPressed:(id)sender{
    if (!isOpen){
        [self viewMenuOpenAnim];
    }else{
        [self viewMenuCloseAnim];
    }
}
-(IBAction)btnHomePressed:(id)sender{
    
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
-(IBAction)btnSettingPressed:(id)sender {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         self.viewMenu.frame = CGRectMake(0,-176, self.viewMenu.frame.size.width,176);
                         isOpen = NO;
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
                             SettingViewController *settingVC = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
                             settingVC.title=@"Settings";
                             [self.navigationController pushViewController:settingVC animated:YES];
                             
                         }
                         
                     }];
    
    
}
-(IBAction)btnProfileAction:(id)sender{
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
                             if([[array objectAtIndex:i] isKindOfClass:[ProfileViewController class]]){
                                 [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
                                 isContain=YES;
                                 break;
                             }
                         }
                         if(!isContain){
                             ProfileViewController *profileVC=[[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
                             profileVC.title=@"Profile";
                             [self.navigationController pushViewController:profileVC animated:YES];
                         }
                         
                     }];
    
}
#pragma mark 
#pragma mark Menu animations Methods
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
    
    // viewHome.alpha=0.0;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         self.viewMenu.frame = CGRectMake(0,64, self.viewMenu.frame.size.width,176);
                         isOpen=YES;
                     } completion:^(BOOL finished) {
                         
    }];
}

@end
