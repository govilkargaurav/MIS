//
//  RegisterViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/10/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "RegisterViewCtr.h"
#import "TermsConditionViewCtr.h"
#import "webService.h"
#import "WSPContinuous.h"
#import "AppDelegate.h"
#import "GlobalMethods.h"

//KeyBoard Animation
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
CGFloat animatedDistance;

@interface RegisterViewCtr ()

@end

@implementation RegisterViewCtr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([GlobalMethods CheckPhoneVersionisiOS7])
    {
        scl_bg.frame = CGRectMake(scl_bg.frame.origin.x, scl_bg.frame.origin.y + 20, scl_bg.frame.size.width, scl_bg.frame.size.height  - 20);
    }
    
    mainDict = [ NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    
    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    
	if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"RegisterVC"];
        lblRegister.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblregister"]];
        lblUsername.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"tfUsername"]];
        lblFirstname.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"tfFirstname"]];
        lblLastname.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"tfLastname"]];
        lblEmail.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"tfEmail"]];
        lblPassword.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"tfPassword"]];
        lblConfirmPass.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"tfConfirmPass"]];
        lblTerm1.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblreadnaccepttnc"]];
        lblTerm2.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbltermsncond"]];
    }

//    if([UserLanguage isEqualToString:@"de"])
//    {
//        AppDel.langDict = [mainDict objectForKey:@"de"];
//        localizationDict = [AppDel.langDict objectForKey:@"RegisterVC"];
//        tfUsername.placeholder= [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"tfUsername"]];
//        tfFirstname.placeholder= [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"tfFirstname"]];
//        tfLastname.placeholder= [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"tfLastname"]];
//        tfEmail.placeholder= [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"tfEmail"]];
//        tfPassword.placeholder= [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"tfPassword"]];
//        tfConfirmPass.placeholder= [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"tfConfirmPass"]];
//    }
    
    scl_bg.contentSize = CGSizeMake(scl_bg.frame.size.width, 630);
    [self tfName:tfUsername];
    [self SetInsetToTextField:tfUsername];
    [self tfName:tfFirstname];
    [self SetInsetToTextField:tfFirstname];
    [self tfName:tfLastname];
    [self SetInsetToTextField:tfLastname];
    [self tfName:tfEmail];
    [self SetInsetToTextField:tfEmail];
    [self tfName:tfPassword];
    [self SetInsetToTextField:tfPassword];
    [self tfName:tfConfirmPass];
    [self SetInsetToTextField:tfConfirmPass];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [self updateui];
}

#pragma mark - Set label Border
-(void)tfName:(UITextField*)tf
{
    [tf.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [tf.layer setBorderWidth: 1.0];
    [tf.layer setMasksToBounds:YES];
}
-(void)SetInsetToTextField:(UITextField*)tf
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    tf.leftView = paddingView;
    tf.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark - IBAction Methods

-(IBAction)btnRegisterPressed:(id)sender
{
    NSString *email = tfEmail.text;
    NSString *emailRegEx = @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:email];
    
    if ([[tfUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 4 || [[tfUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 35)
	{
		lblErrorMsg.text = @"UserName must be between 4 to 35 characters";
	}
    else if ([[tfFirstname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        lblErrorMsg.text = @"Please Enter FirstName";
    }
    else if ([[tfLastname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        lblErrorMsg.text = @"Please Enter LastName";
    }
    else if(!myStringMatchesRegEx)
    {
        lblErrorMsg.text = @"Email is not valid";
    }
    else if ([[tfPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 4 || [[tfPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 35)
    {
        lblErrorMsg.text = @"Password must be between 4 to 35 characters";
    }
    else if(![tfPassword.text isEqualToString:tfConfirmPass.text])
    {
        lblErrorMsg.text=@"Please Enter Same Password";
    }
    else if (!btnAcceptTerm.selected)
    {
        lblErrorMsg.text=@"Please check Terms and Condition";
    }
	else
	{
		[self callWS];
	}
}
-(IBAction)btnCheckUncheckPressed:(id)sender
{
    if ([btnAcceptTerm isSelected])
    {
        [btnAcceptTerm setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        btnAcceptTerm.selected = NO;
    }
    else
    {
        [btnAcceptTerm setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        btnAcceptTerm.selected = YES;
    }
}
-(IBAction)btnTermsandConditionPressed:(id)sender
{
    TermsConditionViewCtr *obj_TermsConditionViewCtr = [[TermsConditionViewCtr alloc]initWithNibName:@"TermsConditionViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_TermsConditionViewCtr animated:YES];
}


#pragma mark - Register Call

-(void)callWS
{
    [AppDel showGlobalProgressHUDWithTitle:@"Please Wait..."];
	WSPContinuous *wsparser;
	wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_Register] action:[webService getSA_Register] message:[webService getSM_Register:tfUsername.text FirstName:tfFirstname.text LastName:tfLastname.text EMail:tfEmail.text Password:tfPassword.text]] rootTag:@"ns1:registerUserSoapOutPart" startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil] endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:errorCode",@"ns1:errorCode",@"ns1:errorLongDesc",@"ns1:userName",@"ns1:email",@"ns1:email",@"ns1:userName",@"ns1:errorLongDesc",nil] otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil] sel:@selector(finishRegister:) andHandler:self];
}

-(void)finishRegister:(NSDictionary*)dictionary
{
   	if ([[[(NSMutableArray *)[dictionary valueForKey:@"array"] objectAtIndex:0] valueForKey:@"ns1:errorCode"] isEqualToString:@"0"])
	{
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"Registration"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        lblErrorMsg.text =[[(NSMutableArray *)[dictionary valueForKey:@"array"] objectAtIndex:0] valueForKey:@"ns1:errorLongDesc"];
    }
    [AppDel dismissGlobalHUD];
}
#pragma mark - UIInterfaceOrientation For iOS < 6

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}
#pragma mark - UIInterfaceOrientation For iOS 6

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
-(BOOL)shouldAutorotate
{
    return YES;
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateui];
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    for (id textField in scl_bg.subviews) {
        
        if ([textField isKindOfClass:[UITextField class]] && [textField isFirstResponder]) {
            [textField resignFirstResponder];
        }
        else if ([textField isKindOfClass:[UITextView class]] && [textField isFirstResponder]) {
            [textField resignFirstResponder];
        }
    }
}
#pragma mark - Set Landscape Frame

-(void)updateui
{
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        if([UserLanguage isEqualToString:@"de"])
        {
            if (isiPhone5) {
                
                lblTerm2.frame = CGRectMake(lblTerm2.frame.origin.x , scl_bg.frame.size.height+95, lblTerm2.frame.size.width, lblTerm2.frame.size.height);
                lblLine.frame = CGRectMake(lblLine.frame.origin.x, scl_bg.frame.size.height+113, 145, lblLine.frame.size.height);
                btnToseeTermsAndCond.frame= CGRectMake(lblTerm2.frame.origin.x , scl_bg.frame.size.height+95, lblTerm2.frame.size.width, lblTerm2.frame.size.height);
            }else{
                
                lblTerm2.frame = CGRectMake(lblTerm2.frame.origin.x , scl_bg.frame.size.height+182, lblTerm2.frame.size.width, lblTerm2.frame.size.height);
                lblLine.frame = CGRectMake(lblLine.frame.origin.x, scl_bg.frame.size.height+200, 145, lblLine.frame.size.height);
                btnToseeTermsAndCond.frame= CGRectMake(lblTerm2.frame.origin.x , scl_bg.frame.size.height+182, lblTerm2.frame.size.width, lblTerm2.frame.size.height);
            }
         
        }
    }
    else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
    {
        if([UserLanguage isEqualToString:@"de"])
        {
            lblLine.frame = CGRectMake(lblLine.frame.origin.x , lblLine.frame.origin.y, 145, lblLine.frame.size.height);
            lblTerm2.frame = CGRectMake(lblTerm2.frame.origin.x , lblTerm2.frame.origin.y, lblTerm2.frame.size.width, lblTerm2.frame.size.height);
        }
    }
}

#pragma mark - UITextField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField.layer setBorderColor: [[UIColor colorWithRed:42.0/255.0 green:176.0/255.0 blue:242.0/255.0 alpha:1.0] CGColor]];
    [textField.layer setBorderWidth: 1.0];
    [textField.layer setMasksToBounds:YES];
    // Below code is used for scroll up View with navigation baar
    CGRect textVWRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textVWRect.origin.y + 0.5 * textVWRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    }else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self tfName:textField];
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
