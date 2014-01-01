//
//  LoginViewCtr.m
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/16/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import "LoginViewCtr.h"
#import "webService.h"
#import "WSPContinuous.h"
#import "Header.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "IIViewDeckController.h"
#import "ListViewCtr.h"
#import "TaskViewCtr.h"
#import "TempRightViewCtr.h"

//KeyBoard Animation
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 264;
CGFloat animatedDistance;

@interface LoginViewCtr ()

@end

@implementation LoginViewCtr

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
    
    tfUsername.text = @"iphone123";
    tfPass.text = @"iphone123";
    
    mainDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    
    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    
	if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"RegisterVC"];
        lblUsername.text = [NSString stringWithFormat:@"%@ oder %@",[localizationDict valueForKey:@"lblusername"],[localizationDict valueForKey:@"lblemail"]];
        lblPassword.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblpassword"]];
    }
    
    scl_bg.contentSize = CGSizeMake(scl_bg.frame.size.width, 310);
    
    [self tfName:tfUsername];
    [self SetInsetToTextField:tfUsername];
    [self tfName:tfPass];
    [self SetInsetToTextField:tfPass];

    NSString *loginStatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"Login"];
	if ([loginStatus isEqualToString:@"LoggedIn"])
	{
        [self PushOnMain];
    }

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    tf.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
}
#pragma mark - IBAction Methods
-(IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnLoginPressed:(id)sender
{
	if ([tfUsername.text length] < 4 || [tfUsername.text length] > 35)
	{
		lblErrorDesc.text = @"UserName must be between 4 to 35 characters";
	}
    else if ([tfPass.text length] < 4 || [tfPass.text length] > 35)
    {
        lblErrorDesc.text = @"Password must be between 4 to 35 characters";
    }
	else
	{
		[AppDel showGlobalProgressHUDWithTitle:@"Please Wait..."];
		WSPContinuous *wsparser;
		wsparser = [[WSPContinuous alloc] initWithRequestForThread:[webService getURq_getansascreen:[webService getWS_Login] action:[webService getSA_Login] message:[webService getSM_Login:tfUsername.text Password:tfPass.text AccessToken:strAccesstoken]]
														   rootTag:@"ns1:loginUserSoapOutPart"
													   startingTag:[NSDictionary dictionaryWithObjectsAndKeys:nil]
														 endingTag:[NSDictionary dictionaryWithObjectsAndKeys:@"ns1:ACK",@"ns1:errorCode",@"ns1:errorLongDesc",@"ns1:errorLongDesc",@"ns1:errorCode",@"ns1:ACK",nil]
														 otherTags:[NSDictionary dictionaryWithObjectsAndKeys:nil]
															   sel:@selector(finishLogin:)
														andHandler:self];
	}
	
}

#pragma mark - Login Response

-(void)finishLogin:(NSDictionary*)dictionary
{
	if ([[[(NSMutableArray *)[dictionary valueForKey:@"array"] objectAtIndex:0] valueForKey:@"ns1:errorCode"] isEqualToString:@"0"])
	{
		strAckNo = [[(NSMutableArray *)[dictionary valueForKey:@"array"] objectAtIndex:0] valueForKey:@"ns1:ACK"];
		
        [[NSUserDefaults standardUserDefaults] setObject:strAckNo forKey:@"ACK"];
		[[NSUserDefaults standardUserDefaults] setObject:@"LoggedIn" forKey:@"Login"];
		[[NSUserDefaults standardUserDefaults] synchronize];
        
        [self PushOnMain];
        
       /* ViewController *obj_ViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        [self.navigationController pushViewController:obj_ViewController animated:YES];*/
	}
    else
    {
        lblErrorDesc.text =[[(NSMutableArray *)[dictionary valueForKey:@"array"] objectAtIndex:0] valueForKey:@"ns1:errorLongDesc"];
    }
    [AppDel dismissGlobalHUD];
    
}
-(void)PushOnMain
{
    ListViewCtr *obj_MainLeftViewCtr = [[ListViewCtr alloc] initWithNibName:@"ListViewCtr" bundle:nil];
    TempRightViewCtr *obj_MainRightViewCtr = [[TempRightViewCtr alloc] initWithNibName:@"TempRightViewCtr" bundle:nil];
    TaskViewCtr *obj_MainCenterViewCtr = [[TaskViewCtr alloc] initWithNibName:@"TaskViewCtr" bundle:nil];
    
    UINavigationController *obj_Nav = [[UINavigationController alloc] initWithRootViewController:obj_MainCenterViewCtr];
    
    UINavigationController *obj_Nav_Right = [[UINavigationController alloc] initWithRootViewController:obj_MainRightViewCtr];
    AppDel.deckController =  [[IIViewDeckController alloc] initWithCenterViewController:obj_Nav leftViewController:obj_MainLeftViewCtr  rightViewController:obj_Nav_Right];
    AppDel.deckController.centerhiddenInteractivity = NO;
    AppDel.deckController.leftLedge = 448;
    AppDel.deckController.rightLedge = 448;
    [self.navigationController pushViewController:AppDel.deckController animated:YES];
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

-(void)keyboardHide
{
    
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
