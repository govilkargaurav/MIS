//
//  Home.m
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Home.h"
#import "AppConstat.h"
#import "Login.h"
#import "GlobalClass.h"
#import "ViewProfileViewCtr.h"
#import "PointsViewCtr.h"
#import "MessageListViewCtr.h"
#import "MateCommentsViewCtr.h"
#import "RatingViewCtr.h"
#import "Proffession.h"
#import "Gallery.h"
#import "AddMate.h"
#import "MyMate.h"
#import "ChangePassword.h"
#import "FbGraph.h"
#import "ReferMatesViewCtr.h"
#import "FullProfessionViewCtr.h"

@implementation Home

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *Info = [NSUserDefaults standardUserDefaults];
    if (![[Info valueForKey:@"Login"] isEqualToString:@"LoginValue"]) 
    {
        Login *objLogin = [[Login alloc]initWithNibName:@"Login" bundle:nil];
        objLogin.strSetHideCancelbtn=@"Yes";
        objLogin.strMessageTitle = @"Please login to access this feature.";
        [self presentModalViewController:objLogin animated:NO];
    }
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Dealloc
#pragma mark - IBAction Methods
-(IBAction)ProfileClicked:(id)sender
{
    ViewProfileViewCtr *obj_ViewProfileViewCtr = [[ViewProfileViewCtr alloc]initWithNibName:@"ViewProfileViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_ViewProfileViewCtr animated:YES];
    obj_ViewProfileViewCtr = nil;
}

-(IBAction)MyMateClicked:(id)sender
{
    MyMate *objMyMate = [[MyMate alloc]initWithNibName:@"MyMate" bundle:nil];
    [self.navigationController pushViewController:objMyMate animated:YES];
    objMyMate = nil;
}
-(IBAction)ProffessionClicked:(id)sender
{
    FullProfessionViewCtr *obj_FullProfessionViewCtr = [[FullProfessionViewCtr alloc]initWithNibName:@"FullProfessionViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_FullProfessionViewCtr animated:YES];
    obj_FullProfessionViewCtr = nil;
}
-(IBAction)GalleryClicked:(id)sender
{
    Gallery *objGallery = [[Gallery alloc]initWithNibName:@"Gallery" bundle:nil];
    [self.navigationController pushViewController:objGallery animated:YES];
    objGallery = nil;
}
-(IBAction)RatingsClicked:(id)sender
{
    RatingViewCtr *obj_RatingViewCtr = [[RatingViewCtr alloc]initWithNibName:@"RatingViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_RatingViewCtr animated:YES];
    obj_RatingViewCtr = nil;

}
-(IBAction)AddMateClicked:(id)sender
{
    AddMate *objAddMate = [[AddMate alloc]initWithNibName:@"AddMate" bundle:nil];
    [self.navigationController pushViewController:objAddMate animated:YES];
    objAddMate = nil;
}
-(IBAction)btnPointsPressed:(id)sender
{
    PointsViewCtr *obj_PointsViewCtr = [[PointsViewCtr alloc]initWithNibName:@"PointsViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_PointsViewCtr animated:YES];
    obj_PointsViewCtr = nil;
}
-(IBAction)btnMessagePressed:(id)sender
{
    MessageListViewCtr *obj_MessageListViewCtr = [[MessageListViewCtr alloc]initWithNibName:@"MessageListViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_MessageListViewCtr animated:YES];
    obj_MessageListViewCtr = nil;
}
-(IBAction)btnCommentsPressed:(id)sender
{
    MateCommentsViewCtr *obj_MateCommentsViewCtr = [[MateCommentsViewCtr alloc]initWithNibName:@"MateCommentsViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_MateCommentsViewCtr animated:YES];
    obj_MateCommentsViewCtr = nil;
}
-(IBAction)btnReferMatePressed:(id)sender
{
    ReferMatesViewCtr *obj_ReferMatesViewCtr = [[ReferMatesViewCtr alloc]initWithNibName:@"ReferMatesViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_ReferMatesViewCtr animated:YES];
    obj_ReferMatesViewCtr = nil;
}
-(IBAction)PasswordClicked:(id)sender
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Type"] isEqualToString:@"FB"]) 
    {
        DisplayAlertWithTitle(APP_Name, @"You can not change the password because you are logged in with facebook.");
    }
    else
    {
        ChangePassword *objChangePassword = [[ChangePassword alloc]initWithNibName:@"ChangePassword" bundle:nil];
        [self.navigationController pushViewController:objChangePassword animated:YES];
        objChangePassword = nil; 
    }  
}
-(IBAction)LogoutClicked:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Log Out" otherButtonTitles:@"Cancel",nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showFromTabBar:self.parentViewController.tabBarController.tabBar];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex == 0 )
        {
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Type"] isEqualToString:@"FB"])
            {
                FbGraph *fbGraph;
                fbGraph.accessToken=nil;
                NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
                {
                    [cookies deleteCookie:cookie];
                }
            }
            NSUserDefaults *Info = [NSUserDefaults standardUserDefaults];
            [Info removeObjectForKey:@"Login"];
            [Info removeObjectForKey:@"Register"];
            [Info removeObjectForKey:@"iUserID"];
            [Info removeObjectForKey:@"vEmail"];
            [Info removeObjectForKey:@"Type"];
            [Info synchronize];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"pushIt0" object:self];
        }
    else
    {
        return;
    }
}
#pragma mark - Extra Methods
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
