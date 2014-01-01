//
//  HomeScreenViewCtr.m
//  PianoApp
//
//  Created by Apple-Openxcell on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeScreenViewCtr.h"
#import "PasswordsViewctr.h"
#import "NotesViewCtr.h"
#import "ContactsViewCtr.h"
#import "CameraRollViewCtr.h"
#import "AppDelegate.h"
#import "EncryptorViewCtr.h"
#import "DecryptorViewCtr.h"
#import "SubclassInAppHelper.h"
#import "GlobalMethods.h"

@implementation HomeScreenViewCtr

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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    scl_bg.contentSize = CGSizeMake(320, 503);

    // Add iAd Noti 
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddBannerView) name:@"iAdBannerView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RemoveAddBanner) name:@"RemoveiAdBannerView" object:nil];
    // End
    
    [[[[UIApplication sharedApplication].keyWindow subviews] lastObject]addSubview:adBannerObj];
    [self RemoveAddBanner];

    if (isiPhone5)
    {
        adBannerObj.frame = CGRectMake(0, 518, 320, 50);
    }
    else
    {
        adBannerObj.frame = CGRectMake(0, 430, 320, 50);
    }
    
     [GlobalMethods SetInsetToTextField:tfPassword];
    // For Hide Keyboard
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    emptyView.backgroundColor = [UIColor clearColor];
    txtEncryptedText.inputView = emptyView;
    
    btnDecode.enabled = NO;
    
    
    if (AppDel.dicEncrtptedFile)
    {
        btnDecode.enabled = YES;
        [btnDecode setTitleColor:RGBCOLOR(255, 125, 0) forState:UIControlStateNormal];
        [btnDecode setBackgroundColor:RGBCOLOR(51, 51, 51)];
        lblTouchAdd.textColor = RGBCOLOR(51, 51, 51);
        
        NSString *strEncodedText = [NSString stringWithFormat:@"%@",[AppDel.dicEncrtptedFile valueForKey:@"descPianopass"]];
        if ([strEncodedText length] != 0)
            lblTouchAdd.text = [NSString stringWithFormat:@"Text Detected \n Press Decode"];
        else
            lblTouchAdd.text = [NSString stringWithFormat:@"Picture Detected \n Press Decode"];
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)UpgradeToPremiumImages
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"IhavePurchasedApp"])
    {
        txtEncryptedText.userInteractionEnabled = YES;
        [btnUpgradeToPremium setTitle:@"PREMIUM" forState:UIControlStateNormal];
        [btnUpgradeToPremium setTitleColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btnUpgradeToPremium setBackgroundImage:[UIImage imageNamed:@"premiumbg.png"] forState:UIControlStateNormal];
        [btnEncryptor setBackgroundImage:[UIImage imageNamed:@"encryptorbuttonbg_sel.png"] forState:UIControlStateNormal];
    }
    else
    {
        txtEncryptedText.userInteractionEnabled = NO;
        [btnUpgradeToPremium setTitle:@"UPGRADE TO PREMIUM" forState:UIControlStateNormal];
        [btnUpgradeToPremium setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnUpgradeToPremium setBackgroundImage:[UIImage imageNamed:@"upgradetopremiumbg.png"] forState:UIControlStateNormal];
        [btnEncryptor setBackgroundImage:[UIImage imageNamed:@"encryptorbuttonbg.png"] forState:UIControlStateNormal];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //inAppPurchase Notification Fire Declaration Start
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchaseFailed:) name:IAPHelperProductNotPurchasedNotification object:nil];
    // End
    
    [self RemoveAddBanner];
    [self UpgradeToPremiumImages];
}
#pragma mark - Hide Show iAdBannerView
-(void)AddBannerView
{
    AppDel.isiAdVisible = YES;
    [adBannerObj setHidden:NO];
}

-(void)RemoveAddBanner
{
    AppDel.isiAdVisible = NO;
    [adBannerObj setHidden:YES];
}

-(IBAction)btnPassWordsPressed:(id)sender
{
    PasswordsViewctr *obj_PasswordsViewctr=[[PasswordsViewctr alloc]initWithNibName:@"PasswordsViewctr" bundle:nil];
    [self.navigationController pushViewController:obj_PasswordsViewctr animated:YES];
    obj_PasswordsViewctr=nil;
}
-(IBAction)btnNotesPressed:(id)sender
{
    NotesViewCtr *obj_NotesViewCtr=[[NotesViewCtr alloc]initWithNibName:@"NotesViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_NotesViewCtr animated:YES];
    obj_NotesViewCtr=nil;
}
-(IBAction)btnContactsPressed:(id)sender
{
    ContactsViewCtr *obj_ContactsViewCtr=[[ContactsViewCtr alloc]initWithNibName:@"ContactsViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_ContactsViewCtr animated:YES];
    obj_ContactsViewCtr=nil;
}
-(IBAction)btnCameraRoll:(id)sender
{
    CameraRollViewCtr *obj_CameraRollViewCtr=[[CameraRollViewCtr alloc]initWithNibName:@"CameraRollViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_CameraRollViewCtr animated:YES];
    obj_CameraRollViewCtr=nil;
}
-(IBAction)ResetPianoPasscode:(id)sender
{
    [viewPurchase removeFromSuperview];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:APP_NAME delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Reset Piano Password" otherButtonTitles:@"Reset Backup Question", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    sheet.tag = 2;
    [sheet showFromRect:self.view.bounds inView:self.view animated:YES];
}
-(IBAction)btnEncryptPressed:(id)sender
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"IhavePurchasedApp"])
    {
        EncryptorViewCtr *obj_EncryptorViewCtr = [[EncryptorViewCtr alloc]initWithNibName:@"EncryptorViewCtr" bundle:nil];
        [self.navigationController pushViewController:obj_EncryptorViewCtr animated:YES];
        obj_EncryptorViewCtr = nil;
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"Upgrade to premium." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}
-(IBAction)btnDecodePressed:(id)sender
{
    NSString *strPass = [NSString stringWithFormat:@"%@",[AppDel.dicEncrtptedFile valueForKey:@"pwdPianopass"]];
            
    if ([strPass length] > 0)
    {
        [self.view addSubview:ViewPass];
        [self.view bringSubviewToFront:ViewPass];
        
        if (isiPhone5)
            ViewPass.frame = CGRectMake(0, 0, 320, 568);
        else
            ViewPass.frame = CGRectMake(0, 0, 320, 480);
    }                
    else
    {
        [self SendToDecryptAndSaveToNotesandPhotos];
    }
}
-(IBAction)btnPassViewRemove:(id)sender
{
    tfPassword.text = @"";
    [ViewPass removeFromSuperview];
}
-(IBAction)btnSkipOrGoPressed:(id)sender
{
    [tfPassword resignFirstResponder];
    NSString *strPass = [NSString stringWithFormat:@"%@",[AppDel.dicEncrtptedFile valueForKey:@"pwdPianopass"]];
    if ([strPass isEqualToString:tfPassword.text])
    {
        tfPassword.text = @"";
        [ViewPass removeFromSuperview];
        [self SendToDecryptAndSaveToNotesandPhotos];
    }
    else
    {
        [GlobalMethods animateIncorrectPassword:ViewPass];
    }
    
}
-(void)SendToDecryptAndSaveToNotesandPhotos
{
    NSString *strEncodedText = [NSString stringWithFormat:@"%@",[AppDel.dicEncrtptedFile valueForKey:@"descPianopass"]];
    DecryptorViewCtr *obj_DecryptorViewCtr = [[DecryptorViewCtr alloc]initWithNibName:@"DecryptorViewCtr" bundle:nil];
    obj_DecryptorViewCtr.strText = strEncodedText;
    if ([strEncodedText length] == 0)
    {
        UIImage *imgEncrypted = [AppDel.dicEncrtptedFile valueForKey:@"imgPianopass"];
        obj_DecryptorViewCtr.imgDecoded = imgEncrypted;
    }
    [self.navigationController pushViewController:obj_DecryptorViewCtr animated:YES];
    obj_DecryptorViewCtr = nil;
    
    btnDecode.enabled = NO;
    [btnDecode setTitleColor:RGBCOLOR(230, 230, 230) forState:UIControlStateNormal];
    [btnDecode setBackgroundColor:RGBCOLOR(153, 153, 153)];
    lblTouchAdd.textColor = RGBCOLOR(153, 153, 153);
    lblTouchAdd.text = @"No Encrypted Data Found";
}

-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - In App purchase Upgrade To Premium
-(IBAction)btnUpgradeToPremiumPressed:(id)sender
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"IhavePurchasedApp"])
    {
        viewPurchase.center = self.view.center;
        [self.view addSubview:viewPurchase];
        [self.view bringSubviewToFront:viewPurchase];
    }
}


-(IBAction)removePurchaseView:(id)sender{
    [viewPurchase removeFromSuperview];
    self.view.userInteractionEnabled = YES;    
}

-(IBAction)restoreProducts:(id)sender{

    
    [AppDel doshowHUD];
    [SubclassInAppHelper sharedInstance];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (IBAction)getProducts:(id)sender
{
    
    [viewPurchase removeFromSuperview];
    self.view.userInteractionEnabled = YES;
     [AppDel doshowHUD];
    [[SubclassInAppHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success)
        {
            SKProduct *product = [products objectAtIndex:0];
            [[SubclassInAppHelper sharedInstance] buyProduct: product];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get product list or Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}
- (void)productPurchased:(NSNotification *) notification
{
    [self UpgradeToPremiumImages];
    // Method will be called when product purchased successfully.
    // Provide purchased content to user or update the UI.
}

- (void)productPurchaseFailed:(NSNotification *) notification
{
    NSString *status = [[notification userInfo] valueForKey:@"isAlert"];
    if ([status isEqualToString: @"YES"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Unable to purchase the product." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - ActionSheet Delegate Method
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        if (buttonIndex == 0)
        {
           
            //[self getProducts];
        }
        else if (buttonIndex == 1)
        {
           
        }
        else if (buttonIndex == 2)
        {
            return;
        }
    }
    else if (actionSheet.tag == 2)
    {
        if (buttonIndex == 0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"Reset" forKey:@"SetStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (buttonIndex == 1)
        {
            [self.view addSubview:viewForgotPass];
            viewForgotPass.frame = CGRectMake(0, 0, 320, 480);
            [tfAns becomeFirstResponder];
            [GlobalMethods SetViewShadow:viewWriteAns];
            [GlobalMethods SetTfShadow:tfAns];
            [GlobalMethods SetInsetToTextField:tfAns];
            
            lblQuestion.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"RecoveryQue"]];
        }
        else if (buttonIndex == 2)
        {
            return;
        }
    }
}

#pragma mark - iAd Delegate
#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"iAdShowSetFrame" object:nil];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    //NSLog(@"didFailToReceiveAdWithError : %@",[error userInfo].description);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"iAdHideSetFrame" object:nil];
}

#pragma mark Reset Recovery Question

-(IBAction)btnResetQuestPressed:(id)sender
{
    tfAns.text = @"";
    [tfAns resignFirstResponder];
    [viewForgotPass removeFromSuperview];
}
-(IBAction)CheckAnsAndResetPressed:(id)sender
{
    NSString *strString = [tfAns.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (strString.length > 0 && [lblQuestion.text isEqualToString:@"Create recovery question"])
    {
        strQue = [strString copy];
        lblQuestion.text = @"Enter recovery password";
        tfAns.text = @"";
    }
    else if (strString.length > 0 && [lblQuestion.text isEqualToString:@"Enter recovery password"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:strQue forKey:@"RecoveryQue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:strString forKey:@"RecoveryAns"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [tfAns resignFirstResponder];
        [viewForgotPass removeFromSuperview];
        tfAns.text = @"";
    }
    else if (strString.length > 0 && [strString isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"RecoveryAns"]])
    {
        lblQuestion.text = @"Create recovery question";
        tfAns.text = @"";
    }
    else
    {
        [GlobalMethods animateIncorrectPassword:viewWriteAns];
    }
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IAPHelperProductNotPurchasedNotification object:nil];
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
