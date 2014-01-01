//
//  ViewController.m
//  MyU
//
//  Created by Vijay on 7/5/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "HomeViewController.h"
#import "NSString+Utilities.h"
#import "MyAppManager.h"
#import "LeftSideViewController.h"
#import "RightSideViewController.h"
#import "WSManager.h"
#import "DBManager.h"
#import "ALPickerView.h"
#import "GlobalVariables.h"
#import <OHAttributedLabel/OHAttributedLabel.h>
#import "GRAlertView.h"

@interface LoginViewController () <UITextFieldDelegate,ALPickerViewDelegate,UIAlertViewDelegate,OHAttributedLabelDelegate>
{
    IBOutlet UITextField *txtUserId;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtUniversity;
    IBOutlet UIView *viewContainer;
    IBOutlet UIImageView *viewSplash;
    ALPickerView *pickerView;
    NSMutableArray *arrUniversityNames;
    NSInteger selecteduni;
    
    IBOutlet UIImageView *imgLogo;
    IBOutlet UIView *viewloginbox;
    IBOutlet UILabel *lblActivation;
    IBOutlet UIView *viewActivation;
    IBOutlet UIButton *btnResend;
    
}
@end

@implementation LoginViewController

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    viewSplash.image=[UIImage imageNamed:[NSString stringWithFormat:@"Default%@.png",(IS_DEVICE_iPHONE_5)?@"-568@2x":@"@2x"]];
    viewSplash.hidden=([[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"] || [[NSUserDefaults standardUserDefaults] objectForKey:@"uni_info"])?NO:YES;
    
    selecteduni=-1;
    arrUniversityNames=[[NSMutableArray alloc]init];

    pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0,460+iPhone5ExHeight+iOS7, 320.0, 216.0)];
    [self.view addSubview:pickerView];
    pickerView.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin;
    pickerView.delegate=self;
    [pickerView reloadAllComponents];
    
    [self syncuniversities];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"])
    {
        [self performSelector:@selector(autologintohome) withObject:nil afterDelay:0.0];
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"uni_info"])
    {
        isAppInGuestMode=YES;
        [self performSelector:@selector(autologintohome) withObject:nil afterDelay:0.0];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    viewActivation.alpha = 0.0;;
    if (shouldInviteToSignUp)
    {
        shouldInviteToSignUp=NO;
        RegistrationViewController *obj=[[RegistrationViewController alloc]init];
        [self.navigationController pushViewController:obj animated:YES];
    }
}
-(IBAction)btnLoginClicked:(id)sender
{
    selectedMenuIndex=0;
    [self.view endEditing:YES];
    [self hidePicker];
        
    if ([[txtUserId.text removeNull]length]==0)
    {
        kGRAlert(@"Please enter user-id");
    }
    else if ([[txtPassword.text removeNull]length]==0)
    {
        kGRAlert(@"Please enter password");
    }
    else
    {
        [self loginWithUserName:[txtUserId.text removeNull] andPassword:[txtPassword.text removeNull]];
    }
}

-(void)autologintohome
{
    [self navigatetohome:NO];
}
-(void)navigatetohomescreen
{
    [self navigatetohome:YES];
}

/*
 "user_info" = {
 bio = "";
 birthday = "05-08-2013";
 "can_add_news" = 0;
 department = "";
 email = "vijay@openxcell.info";
 faculty = no;
 gender = Male;
 "graduation_year" = "";
 id = 76;
 major = "";
 name = "Vijay Hirpara";
 "phone_number" = "";
 "profile_picture" = "http://www.openxcellaus.info/myu/admin/files/38d3c3aa3809ad04f510ff8b3bfd933f.png";
 thumbnail = "";
 "university_email" = "";
 "university_name" = "California University";
 username = vijayhirpara;
 };
 */
//NSLog(@"the data: %@",dictUserInfo);
/*
 {
 abbreviation = KU;
 address = Shuwaikh;
 id = 2;
 "uni_picture" = "http://www.openxcellaus.info/myu/admin/files/university/thumbnails/1a2c1bbb9be2d5f8f342839573b81db7.gif";
 universityid = 12;
 universityname = "Kuwait University";
 }
 */
-(void)navigatetohome:(BOOL)animated
{
    if (isAppInGuestMode)
    {
        dictUserInfo=[[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"uni_info"]];
        
        strUserId=[[NSString alloc]initWithFormat:@"0"];
        strUserUniId=[[NSString alloc]initWithFormat:@""];
        strUserProfilePic=[[NSString alloc]initWithFormat:@""];
        strSubscribedUni=[[NSMutableString alloc]initWithFormat:@"%@",[dictUserInfo objectForKey:@"universityid"]];
        canPostNews=NO;
        
        
        UIViewController * leftSideDrawerViewController = [[LeftSideViewController alloc] init];
        UINavigationController *navLeft = [[UINavigationController alloc] initWithRootViewController:leftSideDrawerViewController];
        navLeft.navigationBarHidden = YES;
        
        
        UIViewController * centerViewController = [[HomeViewController alloc] init];
        UINavigationController *navCentre = [[UINavigationController alloc] initWithRootViewController:centerViewController];
        navCentre.navigationBarHidden = YES;
        
        MMDrawerController * drawerController = [[MMDrawerController alloc]
                                                 initWithCenterViewController:navCentre
                                                 leftDrawerViewController:navLeft
                                                 rightDrawerViewController:nil];
        drawerController.navigationController.navigationBarHidden = YES;
        [drawerController setMaximumLeftDrawerWidth:250.0];
        
        [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeParallax];
        
        drawerController.centerHiddenInteractionMode =MMDrawerAnimationTypeSwingingDoor;
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        
        [drawerController
         setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible)
         {
             MMDrawerControllerDrawerVisualStateBlock block;
             block = [[MMExampleDrawerVisualStateManager sharedManager]
                      drawerVisualStateBlockForDrawerSide:drawerSide];
             if(block){
                 block(drawerController, drawerSide, percentVisible);
             }
         }];
        
        viewSplash.hidden=YES;

        [self presentModalViewController:drawerController animated:animated];
    }
    else
    {
        dictUserInfo=[[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_info"]];
        strUserId=[[NSString alloc]initWithFormat:@"%@",[dictUserInfo valueForKey:@"id"]];
        strUserUniId=[[NSString alloc]initWithFormat:@"%@",[[dictUserInfo valueForKey:@"university"] removeNull]];
        strUserProfilePic=[[NSString alloc]initWithFormat:@"%@",[[dictUserInfo valueForKey:@"thumbnail"] removeNull]];
        strSubscribedUni=[[NSMutableString alloc]initWithFormat:@"%@",[[dictUserInfo valueForKey:@"uni_list"] removeNull]];
        NSString *canAddNews=[[[NSString alloc]initWithFormat:@"%@",[dictUserInfo valueForKey:@"can_add_news"]] removeNull];
        canPostNews=([canAddNews isEqualToString:@"1"])?YES:NO;
        
        [self setField:strUserId forKey:@"kXMPPmyJID"];
        [self setField:strUserId forKey:@"kXMPPmyPassword"];
        IsRegestration = @"NO";
        
        
        UIViewController * leftSideDrawerViewController = [[LeftSideViewController alloc] init];
        UINavigationController *navLeft = [[UINavigationController alloc] initWithRootViewController:leftSideDrawerViewController];
        navLeft.navigationBarHidden = YES;
        
        UIViewController * centerViewController = [[HomeViewController alloc] init];
        UINavigationController *navCentre = [[UINavigationController alloc] initWithRootViewController:centerViewController];
        navCentre.navigationBarHidden = YES;

        
        UIViewController * rightSideDrawerViewController = [[RightSideViewController alloc] init];
        UINavigationController *navRight = [[UINavigationController alloc] initWithRootViewController:rightSideDrawerViewController];
        navRight.navigationBarHidden = YES;
        
        
        MMDrawerController * drawerController = [[MMDrawerController alloc]
                                                 initWithCenterViewController:navCentre
                                                 leftDrawerViewController:navLeft
                                                 rightDrawerViewController:navRight];
        drawerController.navigationController.navigationBarHidden = YES;
        [drawerController setMaximumLeftDrawerWidth:250.0];
        [drawerController setMaximumRightDrawerWidth:250.0];
        
        //MMDrawerAnimationTypeSlide,
        //MMDrawerAnimationTypeSlideAndScale,
        //MMDrawerAnimationTypeSwingingDoor,
        //MMDrawerAnimationTypeParallax,
        
        [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeParallax];
        [[MMExampleDrawerVisualStateManager sharedManager] setRightDrawerAnimationType:MMDrawerAnimationTypeParallax];
        
        drawerController.centerHiddenInteractionMode =MMDrawerAnimationTypeSwingingDoor;
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        
        [drawerController
         setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible)
         {
             MMDrawerControllerDrawerVisualStateBlock block;
             block = [[MMExampleDrawerVisualStateManager sharedManager]
                      drawerVisualStateBlockForDrawerSide:drawerSide];
             if(block){
                 block(drawerController, drawerSide, percentVisible);
             }
         }];
        
        
        if (![[[self appDelegate] xmppStream] isConnected])
        {
            [[self appDelegate] connect];
        }else{
            [[self appDelegate] disconnect];
            [[self appDelegate] connect];
        }
        
        viewSplash.hidden=YES;
        [self presentModalViewController:drawerController animated:animated];
    }
}

#pragma mark - WS METHODS
-(void)syncuniversities
{
    NSDictionary *dictPara=[NSDictionary dictionaryWithObject:@"" forKey:@"lastsyncedtimestamp"];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kLoadUniversityURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(universitysynced:) withfailureHandler:nil withCallBackObject:self];
    [obj startRequest];
}
-(void)universitysynced:(id)sender
{
    NSDictionary *dictResponse=(NSDictionary *)sender;
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        if ([dictResponse objectForKey:@"university_list"])
        {
            [arrUniversityNames removeAllObjects];
            [arrUniversityNames addObjectsFromArray:[dictResponse objectForKey:@"university_list"]];
            [pickerView reloadAllComponents];
        }
    }
}

-(void)loginWithUserName:(NSString *)strUserName andPassword:(NSString *)strPassword
{
    NSDictionary *dictPara;
    
#if TARGET_IPHONE_SIMULATOR
    dictPara=[NSDictionary dictionaryWithObjectsAndKeys:[strUserName removeNull],@"username",[strPassword removeNull],@"password",@"IOS_SIMULATOR",@"device_token", nil];
#elif TARGET_OS_IPHONE
    dictPara=[NSDictionary dictionaryWithObjectsAndKeys:[strUserName removeNull],@"username",[strPassword removeNull],@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"],@"device_token", nil];
#endif
    
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kLoginURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(logindone:) withfailureHandler:@selector(loginfailed:) withCallBackObject:self];
    [[MyAppManager sharedManager]showLoader];
    [obj startRequest];
}
-(void)logindone:(id)sender
{
    [[MyAppManager sharedManager]hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        NSMutableDictionary *dictUserInfo =[[NSMutableDictionary alloc]initWithDictionary:[dictResponse objectForKey:@"user_info"]];
        [[NSUserDefaults standardUserDefaults] setObject:dictUserInfo forKey:@"user_info"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        txtUserId.text=@"";
        txtPassword.text=@"";
        [self navigatetohomescreen];
    }
    else if([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"0"] &&
            [[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]] isEqualToString:@"Your account is not activated!"])
    {
        viewActivation.alpha = 1.0;
        lblActivation.text = [NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"email"]];
        CGSize lblSize = [lblActivation.text sizeWithFont:lblActivation.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, 21.0) lineBreakMode:NSLineBreakByWordWrapping];
        if (lblSize.width < 225)
        {
            [btnResend setFrame:CGRectMake(lblActivation.frame.origin.x + lblSize.width + 5.0, btnResend.frame.origin.y, btnResend.frame.size.width, btnResend.frame.size.height)];
        }
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
/* SET USERNAME AND PASSWORD IN USER DEFAULT TO GET IN */
- (void)setField:(NSString *)field forKey:(NSString *)key
{
    if (field != nil)
    {
        if ([key isEqualToString:@"kXMPPmyJID"]) {
            field = [NSString stringWithFormat:@"%@%@",field,DOMAIN_NAME];
        }
        [[NSUserDefaults standardUserDefaults] setObject:field forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}


-(void)loginfailed:(id)sender
{
    [[MyAppManager sharedManager]hideLoader];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}

#pragma mark - BUTTON METHODS
-(IBAction)btnRegisterClicked:(id)sender
{
    [self.view endEditing:YES];
    [self hidePicker];
    
    RegistrationViewController *obj=[[RegistrationViewController alloc]init];
    [self.navigationController pushViewController:obj animated:YES];
}
-(IBAction)btnUniversityClicked:(id)sender
{
    if ([arrUniversityNames count]>0) {
        viewActivation.alpha = 0.0;
        if (IS_DEVICE_iPHONE_5)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.5];
            [viewContainer setFrame:CGRectMake(0,-107.0,320,460+iPhone5ExHeight)];
            [viewloginbox setFrame:CGRectMake(0,188+45,320,viewloginbox.frame.size.height)];
            [pickerView setFrame:CGRectMake(0,460+iPhone5ExHeight-216.0+iOS7,320,216.0)];
            [UIView commitAnimations];
        }
        else
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.5];
            [viewContainer setFrame:CGRectMake(0,-195.0,320,460+iPhone5ExHeight)];
            [viewloginbox setFrame:CGRectMake(0,188+53,320,viewloginbox.frame.size.height)];
            CGRect rectLogo=imgLogo.frame;
            rectLogo.origin.x=119.0+20.0;
            rectLogo.origin.y=30.0-18.0;
            rectLogo.size.width=41.0;
            rectLogo.size.height=30.0;
            [imgLogo setFrame:rectLogo];
            [pickerView setFrame:CGRectMake(0,460+iPhone5ExHeight-216.0+iOS7,320,216.0)];
            [UIView commitAnimations];
        }
    }
    else
    {
        kGRAlert(kUniversityNotLoadedAlert);
    }
}
- (IBAction)btnForgetPassClicked:(id)sender
{
    [self.view endEditing:YES];
    [self hidePicker];
    GRAlertView *alert = [[GRAlertView alloc]initWithTitle:@"Forgot Password" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].placeholder = @"Enter Your Email";
    [alert show];
}
#pragma mark - AlerView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            if (![[[alertView textFieldAtIndex:0].text removeNull] isValidEmail])
            {
                kGRAlert(@"Please enter valid email");
            }
            else
            {
                [self ForgetPass:[alertView textFieldAtIndex:0].text];
            }
            break;
        default:
            break;
    }
}
-(void)ForgetPass:(NSString *)strEmail
{
    NSMutableDictionary *dictPara = [NSMutableDictionary dictionary];
    [dictPara setValue:strEmail forKey:@"email_address"];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kForgetPassURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(ForgetPassDone:) withfailureHandler:@selector(ForgetPassfailed:) withCallBackObject:self];
    [[MyAppManager sharedManager]showLoader];
    [obj startRequest];
}
-(void)ForgetPassDone:(id)sender
{
    [[MyAppManager sharedManager]hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        kGRAlert(@"Password Sent successfully on your email");
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}

-(void)ForgetPassfailed:(id)sender
{
    [[MyAppManager sharedManager]hideLoader];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}
- (IBAction)btnResendClicked:(id)sender
{
    NSMutableDictionary *dictPara = [NSMutableDictionary dictionary];
    [dictPara setValue:lblActivation.text forKey:@"email_address"];
    WSManager *obj=[[WSManager alloc]initWithURL:[NSURL URLWithString:[kResendURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] postPara:dictPara postData:nil withsucessHandler:@selector(ResendDone:) withfailureHandler:@selector(Resendfailed:) withCallBackObject:self];
    [[MyAppManager sharedManager]showLoader];
    [obj startRequest];
}

-(void)ResendDone:(id)sender
{
    [[MyAppManager sharedManager]hideLoader];
    
    NSDictionary *dictResponse=(NSDictionary *)sender;
    if ([[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"SUCCESS"]] isEqualToString:@"1"])
    {
        kGRAlert(@"Activation link successfully sent on your email");
        viewActivation.alpha = 0.0;
    }
    else
    {
        NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"message"]];
        
        if ([[strErrorMessage removeNull] length]>0) {
            kGRAlert([strErrorMessage removeNull])
        }
    }
}
-(void)Resendfailed:(id)sender
{
    [[MyAppManager sharedManager]hideLoader];
    NSDictionary *dictResponse=(NSDictionary *)sender;
    NSString *strErrorMessage=[NSString stringWithFormat:@"%@",[dictResponse objectForKey:@"error"]];
    if ([[strErrorMessage removeNull] length]>0)
    {
        kGRAlert([strErrorMessage removeNull])
    }
}
#pragma mark - Text Field Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==txtUserId)
    {
        [txtPassword becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength>60)?NO:YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hidePicker];
    
    if (textField==txtUserId)
    {
        if (!IS_DEVICE_iPHONE_5)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.2];
            [viewContainer setFrame:CGRectMake(0,-26.0,320,460+iPhone5ExHeight)];
            [UIView commitAnimations];
        }
    }
    else if(textField==txtPassword)
    {
        if (!IS_DEVICE_iPHONE_5)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.2];
            [viewContainer setFrame:CGRectMake(0,-26.0,320,460+iPhone5ExHeight)];
            [UIView commitAnimations];
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2];
    [viewContainer setFrame:CGRectMake(0,0,320,460+iPhone5ExHeight)];
    [UIView commitAnimations];
}

#pragma mark - PICKERVIEW
- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView
{
	return [arrUniversityNames count];
}
- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row
{
	return [[arrUniversityNames objectAtIndex:row] objectForKey:@"universityname"];
}
- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row
{
	return ((row==selecteduni)?YES:NO);
}

- (void)pickerView:(ALPickerView *)pickerViews didCheckRow:(NSInteger)row
{
    selecteduni=row;
    txtUniversity.text=[[arrUniversityNames objectAtIndex:selecteduni] objectForKey:@"universityname"];
    [self hidePicker];
    
    isAppInGuestMode=YES;
    NSMutableDictionary *dictUserInfo =[[NSMutableDictionary alloc]initWithDictionary:[arrUniversityNames objectAtIndex:selecteduni]];
    [[NSUserDefaults standardUserDefaults] setObject:dictUserInfo forKey:@"uni_info"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    txtUniversity.text = @"";
    [self navigatetohome:YES];
    
}
- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row
{

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *theTouch=[touches anyObject];
    if (theTouch.view==viewContainer)
    {
        [self hidePicker];
        [self.view endEditing:YES];
    }
}
-(void)hidePicker
{
    if (IS_DEVICE_iPHONE_5)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];
        [viewContainer setFrame:CGRectMake(0,0,320,460+iPhone5ExHeight)];
        [viewloginbox setFrame:CGRectMake(0,188.0,320,viewloginbox.frame.size.height)];
        [pickerView setFrame:CGRectMake(0,self.view.frame.size.height,320,216.0)];
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];
        [viewContainer setFrame:CGRectMake(0,0,320,460+iPhone5ExHeight)];
        [pickerView setFrame:CGRectMake(0,self.view.frame.size.height,320,216.0)];
        [viewloginbox setFrame:CGRectMake(0,188.0,320,viewloginbox.frame.size.height)];
        CGRect rectLogo=imgLogo.frame;
        rectLogo.origin.x=119.0;
        rectLogo.origin.y=30.0;
        rectLogo.size.width=82.0;
        rectLogo.size.height=60.0;
        [imgLogo setFrame:rectLogo];
        [UIView commitAnimations];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
