//
//  ChlngFrndStep3ViewController.m
//  FitTagApp
//
//  Created by apple on 2/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ChlngFrndStep3ViewController.h"
#import "TimeLineViewController.h"
#import "FrndChlngCell.h"
#import "TwitterFollowerList.h"
#import "InviteContactForChallenge.h"

@implementation ChlngFrndStep3ViewController

@synthesize tblFrndChallenge,challengeName;
@synthesize pfObjchallengeInfop;
@synthesize objCreateChallengeModel;
@synthesize _arrayImageData;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegateRefrence = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    [lbl1 setFont:[UIFont fontWithName:@"DynoBold" size:15]];
    [lbl2 setFont:[UIFont fontWithName:@"DynoBold" size:15]];
    [lbl3 setFont:[UIFont fontWithName:@"DynoBold" size:15]];
    [lbl4 setFont:[UIFont fontWithName:@"DynoBold" size:12]];

    appDelegateRefrence = (AppDelegate *) [[UIApplication sharedApplication]delegate];

    arrEmailIds = [[NSMutableArray alloc]init];
    //[self.navigationItem setHidesBackButton:NO];
    
    //navigation back Button- Arrow
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

-(void)viewDidUnload{
    
    [self setTblFrndChallenge:nil];
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark- TableView Delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrUserForChallenge count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FrndChlngCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FrndChlngCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    PFObject *objUser=[arrUserForChallenge objectAtIndex:indexPath.row];
    cell.lblFrndName.text=[objUser objectForKey:@"username"];
    PFFile *theImage = [objUser objectForKey:@"userPhoto"];
    [cell.imgProfileview setImageURL:[NSURL URLWithString:[theImage url]]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark- Button Action Event
- (IBAction)btnClngFBPressed:(id)sender{
    
    if([PFFacebookUtils session].state == FBSessionStateOpen){
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity: 4];
        
        // set the frictionless requests parameter to "1"
        [params setObject: @"1" forKey:@"frictionless"];
        [params setObject:[NSString stringWithFormat:@"%@ just challenged you on FitTag (www.fittagapp.com). Do you accept the challenge?",[PFUser currentUser].username] forKey:@"message"];
        [params setObject:FACEBOOKCLIENTID forKey:@"app_id"];
        
        [FBWebDialogs presentRequestsDialogModallyWithSession:[PFFacebookUtils session]
            message:[NSString stringWithFormat:@"%@ just challenged you on FitTag",[PFUser currentUser].username] title:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
              if (error) {
                  // Case A: Error launching the dialog or sending request.
              } else {
                  if (result == FBWebDialogResultDialogNotCompleted) {
                      //Case B: User clicked the "x" icon
                  } else {
                      //Case C: Dialog shown and the user clicks Cancel or Send
                  }
              }
        }];
        
    }else{
        [PFFacebookUtils linkUser:[PFUser currentUser] permissions:FB_PERMISSIONS block:^(BOOL Success,NSError *error){
            
            if(!error){
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity: 4];
                
                // set the frictionless requests parameter to "1"
                [params setObject: @"1" forKey:@"frictionless"];
                [params setObject: [NSString stringWithFormat:@"%@ just challenged you on FitTag (www.fittagapp.com). Do you accept the challenge?",[PFUser currentUser].username] forKey:@"message"];
                [params setObject:FACEBOOKCLIENTID forKey:@"app_id"];
                
                [FBWebDialogs presentRequestsDialogModallyWithSession:[PFFacebookUtils session] message:[NSString stringWithFormat:@"%@ just challenged you on FitTag",[PFUser currentUser].username] title:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error){
                      if (error) {
                          // Case A: Error launching the dialog or sending request.
                      } else {
                          if (result == FBWebDialogResultDialogNotCompleted) {
                              //Case B: User clicked the "x" icon
                          } else {
                              //Case C: Dialog shown and the user clicks Cancel or Send
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

-(IBAction)btnTwitterPressed:(id)sender{
    
   /* UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"FitTag" message:@"OOPS ! Sorry for inconvenience. We are having some problems with twitter for now. We are working hard to solve the issue. We will get back to you soon." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];*/
    
    // Twitter Temporary block

    
    TwitterFollowerList *twitterFollowersVC = [[TwitterFollowerList alloc]initWithNibName:@"TwitterFollowerList" bundle:nil];
    [self.navigationController pushViewController:twitterFollowersVC animated:YES];
}

-(IBAction)btnContectPressed:(id)sender{
    InviteContactForChallenge *inviteContactFriendsVC = [[InviteContactForChallenge alloc]initWithNibName:@"InviteContactForChallenge" bundle:nil];
    inviteContactFriendsVC.strChallengeName = self.challengeName;
    [self.navigationController pushViewController:inviteContactFriendsVC animated:YES];
}
 
-(IBAction)btnDonePressed:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelectorInBackground:@selector(uploadImageOnServer) withObject:nil];
    [self performSelectorInBackground:@selector(uploadMultipleImage) withObject:nil];
}

-(void)uploadImageOnServer{
    // Save the user created challenge
    
    if(self.objCreateChallengeModel.teaserDataImage){
        [self uploadImage:self.objCreateChallengeModel.teaserDataImage TeaserVedio:nil];
    }else{
        NSData *imageData = UIImageJPEGRepresentation(self.objCreateChallengeModel.thumbNail, 0.05f);
        [self uploadTeaserThumImage:imageData];
        [self uploadImage:nil TeaserVedio:self.objCreateChallengeModel.teaserDataVideo];
    }
}

-(IBAction)btnHeaderbackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getFirstChallenge{
    @try {
        PFQuery *postQuery = [PFQuery queryWithClassName:@"Challenge"];
        [postQuery whereKey:@"challengeName" equalTo:self.challengeName];
        [postQuery addDescendingOrder:@"createdAt"];
        [postQuery includeKey:@"userId"];
        
        [postQuery whereKeyExists:@"objectId"];
        NSMutableArray *arrFirstChallenge = [[postQuery findObjects] mutableCopy];
        [appDelegateRefrence.arrUserFirstChallenge removeAllObjects];
        appDelegateRefrence.arrUserFirstChallenge = arrFirstChallenge;
        
        NSArray *array = [self.navigationController viewControllers];
        for(int i = 0; i < array.count; i++){
            if([[array objectAtIndex:i] isKindOfClass:[TimeLineViewController class]]){
                [self.navigationController popToViewController:[array objectAtIndex:i] animated:YES];
                break;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception");
    }
}

#pragma mark upload Media image

-(void)uploadTeaserThumImage :(NSData *)thumbImageData{
    
    // Save challenge teaser thum Image on server
    PFFile *teaserImageFile = [PFFile fileWithName:@"teaserImage.jpg" data:thumbImageData];
    [teaserImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(!error){
            //Hide determinate HUD
            [self.pfObjchallengeInfop setObject:teaserImageFile forKey:@"VideoThumbImage"];
            [self.pfObjchallengeInfop saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error){
                    //[MBProgressHUD hideHUDForView:self.view animated:YES];
                }else{
                    
                }
            }];
        }
    }];
}

-(void)uploadImage:(NSData *)teaserImageDate TeaserVedio:(NSData *)teaserVediaDate{
    
    if (teaserImageDate){
        PFFile *teaserImageFile = [PFFile fileWithName:@"teaserImage.jpg" data:teaserImageDate];
        [teaserImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
            [self.pfObjchallengeInfop setObject:teaserImageFile forKey:@"teaserfile"];
                [self.pfObjchallengeInfop saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                    if (!error) {
                        [self performSelector:@selector(getFirstChallenge) withObject:nil afterDelay:1.0];
                        [MBProgressHUD hideHUDForView:self.view animated:YES];                    }
                    else{
                        
                    }
                }];
            }
            
        }];
    }else if(teaserVediaDate){
        
        PFFile *vedioTeaserfile = [PFFile fileWithName:@"vedioTeaser.mp4" data:teaserVediaDate];
        [vedioTeaserfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                //Hide determinate HUD
                
                [self.pfObjchallengeInfop setObject:vedioTeaserfile forKey:@"teaserfile"];
                //[activitie save];
                [self.pfObjchallengeInfop saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error){
                        //[MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                    }
                    else{
                        
                    }
                }];
            }
        }];
    }
}

#pragma mark Upload step data

-(void)uploadMultipleImage{
    
    NSMutableArray *arrImageFiles = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [self._arrayImageData count]; i++) {
        
        NSDictionary *dictactorName = [self._arrayImageData objectAtIndex:i];
        NSString *actorName = [[dictactorName allKeys] objectAtIndex:0];
        
        if ([actorName isEqualToString:@"image"]) {
            
            PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:[dictactorName objectForKey:@"image"]];
            [imageFile save];
            NSMutableDictionary *dictStepDataAndText = [[NSMutableDictionary alloc]init];
            [dictStepDataAndText setObject:imageFile forKey:@"image"];
            [dictStepDataAndText setObject:[dictactorName objectForKey:@"text"] forKey:@"text"];
            
            [arrImageFiles addObject:dictStepDataAndText];
        }else if([actorName isEqualToString:@"onlyText"]){
            NSString *strNoImage = [dictactorName objectForKey:@"onlyText"];
            
            PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:[dictactorName objectForKey:@"textImage"]];
            [imageFile save];
            
            NSMutableDictionary *dictStepDataAndText = [[NSMutableDictionary alloc]init];
            [dictStepDataAndText setObject:strNoImage forKey:@"onlyText"];
            [dictStepDataAndText setObject:[dictactorName objectForKey:@"text"] forKey:@"text"];
            [dictStepDataAndText setObject:imageFile forKey:@"textImage"];
            
            [arrImageFiles addObject:dictStepDataAndText];
        }else {
            
            PFFile *videoFile = [PFFile fileWithName:@"video.mp4" data:[dictactorName objectForKey:@"vedio"]];
            [videoFile save];
            
            NSMutableDictionary *dictStepDataAndText = [[NSMutableDictionary alloc]init];
            [dictStepDataAndText setObject:videoFile forKey:@"image"];
            [dictStepDataAndText setObject:[dictactorName objectForKey:@"text"] forKey:@"text"];
            
            [arrImageFiles addObject:dictStepDataAndText];
        }
    }
    
    [self.pfObjchallengeInfop setObject:arrImageFiles forKey:@"myArray"];
    
    // Saving challenge into draft for future use
    [self.pfObjchallengeInfop saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(!error){
            dispatch_async(dispatch_get_main_queue(),^{
            });
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    return YES;
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return YES;
}
@end
