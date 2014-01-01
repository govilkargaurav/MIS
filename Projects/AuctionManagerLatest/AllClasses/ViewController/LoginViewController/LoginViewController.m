//
//  LoginViewController.m
//  PropertyInspector
//
//  Created by apple on 10/15/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "ThreadManager.h"
#import "BusyAgent.h"
#import "LoginModel.h"
#import "AlertManger.h"
#import "HomeViewController.h"
#import "RegisterModel.h"


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


// Keyboard Animation Constant

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;

// Use Global Class which should inherit from NSObject Class while declaring global objects.
@interface LoginViewController ()
{
    NSURLRequest *requestMain;

    IBOutlet UITextField *_loginTextField;
    IBOutlet UITextField *_passwordTextField;
    BOOL isValidemailId,isTextFieldsBlank;
}

@property(nonatomic,retain)NSUUID *strUDID;
@property(nonatomic,strong)NSString *UDIDSTRING;
@property(nonatomic,retain)HomeViewController *homeController;
-(BOOL)checkEmailValidation;
-(void)getDeviceAunthnticityResponse;
-(void)busyViewinSecondryThread;

@end

@implementation LoginViewController

CGFloat animatedDistance;
@synthesize homeController;
@synthesize strUDID;
@synthesize UDIDSTRING;

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
    
    /* GET UDID OF DEVICE FOR 5.0 OR 6.0 OS VERSION */
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
        
    {
    UIDevice *device = [UIDevice currentDevice];
    UDIDSTRING = [device uniqueIdentifier];
    }
    
    else
        self.UDIDSTRING = [UIDevice currentDevice].uniqueIdentifier;
    
    
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"LOGIN_NAME"]!=nil) {
        
        _loginTextField.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"LOGIN_NAME"];
        
    }else{
        
        _loginTextField.text=nil;
        _passwordTextField.text=nil;
        
    }
        
    UDIDSTRING=[UDIDSTRING stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
       
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBarHidden = YES;
    _passwordTextField.text=nil;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Text fields delegate Method

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
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
-(void)textFieldDidEndEditing:(UITextField *)textField{

    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// the user pressed the "Done" button, so dismiss the keyboard
	
    if(textField == _loginTextField)	{
        
		[_loginTextField resignFirstResponder];
        [_passwordTextField becomeFirstResponder];
		
	}else if(textField==_passwordTextField){
        
        [_passwordTextField resignFirstResponder];
        
    }
	
	return YES;
}


#pragma mark VALIDATION CHECK

-(void)validationCheck{
    
    NSString *string_login=_loginTextField.text;
    NSString *string_password=_passwordTextField.text;
    
 /* TO REMOVE WHITE SPACE FROM STRING */
    
    string_login = [string_login stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    string_password = [string_password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    if([string_login length] == 0 || [string_password length] == 0){
        
        isTextFieldsBlank = YES;
        
    }else{
        
        isValidemailId = [self checkEmailValidation];
        isTextFieldsBlank = NO;
    }
   
}

/* TO MAKE SURE THAT EMAIL SHOULD BE IN "test@test.testmail.com" FORMATE */

-(BOOL)checkEmailValidation{
    NSString *strEmail;
    
    strEmail  = [_loginTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:strEmail];
}


#pragma mark LOGIN METHOD CALLED

-(IBAction)loginWebServices:(id)sender{
    
    
    [NSThread detachNewThreadSelector:@selector(busyViewinSecondryThread) toTarget:self withObject:nil];
    
    
    
    
    [self validationCheck];
    
    if(isTextFieldsBlank){
        
        
        [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"Please fill the blank fields" cancelButtonTitle:@"OK"];
        [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
        
    }else{
        
        if(isValidemailId){
    
    //@"f1997d2020e252c188bd5ad33cf0ccfc00000000"
            
            
                NSString *soapMessage = [[NSString stringWithFormat:@"%@username=%@&password=%@&deviceId=%@",WEB_LOGIN_URL,_loginTextField.text,_passwordTextField.text,UDIDSTRING]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            
                ////NSLog(@"SOAP MES:-->%@",soapMessage);
                        
                [[ThreadManager getInstance]makeRequest:REQ_LOGIN_KEY:soapMessage:[NSData dataWithContentsOfURL:[NSURL URLWithString:soapMessage]]];
                    
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(getDeviceAunthnticityResponse) name:NOTIFICATION_LOGIN_URL object:nil];

        
        }else{
            
                [[BusyAgent defaultAgent]makeBusy:NO showBusyIndicator:NO];
                [[AlertManger defaultAgent]showAlertWithTitle:APP_NAME message:@"Failed Authentication.\nPlease call 1-888-410-AH4R for help resetting your password" cancelButtonTitle:@"OK"];
            
        }
                
    }
    
}

/* THIS METHOD WILL CALL AFTER COMPLETION OF LOGIN WEBSERVICES CALLED. THIS WILL GET CALLED BY NSNOTIFICATIONCENTER. */


-(void)getDeviceAunthnticityResponse{
    
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_LOGIN_URL object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_ERROR_KEY object:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [[BusyAgent defaultAgent] makeBusy:NO showBusyIndicator:NO];
            
        
        if ([responseStr isEqualToString:@"true"]) {
            
            
            [[NSUserDefaults standardUserDefaults]setValue:_loginTextField.text forKey:@"LOGIN_NAME"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            homeController=[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
            self.navigationItem.title=@"Back";
            [self.navigationController pushViewController:homeController animated:YES];
            
            
        }else{
                    
            
            [[AlertManger defaultAgent] showAlertWithTitle:APP_NAME message:@"Failed Authentication.\nPlease call 1-888-410-AH4R for help resetting your password" cancelButtonTitle:@"OK"];
            
            }

        });
    
}


#pragma Mark FORGOT PASSWORD

-(IBAction)forgetPassword:(id)sender{
    
    
    [[AlertManger defaultAgent] showAlertWithTitle:APP_NAME message:@"Please call 1-888-410-AH4R for help resetting your password." cancelButtonTitle:@"OK"];
    
    
}

/* THIS METHOD WILL CALL FOR STATUS INDICATOR RUNNING IN SECONDRY THREAD. */

-(void)busyViewinSecondryThread{
    
    
    [[BusyAgent defaultAgent]makeBusy:YES showBusyIndicator:YES];
    
}

#pragma mark REGISTRATION WEBSERVICES GET CALLED

-(IBAction)deviceRegistration:(id)sender{
    
    [NSThread detachNewThreadSelector:@selector(busyViewinSecondryThread) toTarget:self withObject:nil];
    NSString *soapMessage = [[NSString stringWithFormat:@"%@username=%@&password=%@&deviceId=%@",WEB_GET_REGISTER,_loginTextField.text,_passwordTextField.text,self.UDIDSTRING]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ////NSLog(@"SOAP MES:-->%@",soapMessage);
    
    [[ThreadManager getInstance]makeRequest:REQ_REGISTER_KEY:soapMessage:[NSURL URLWithString:soapMessage]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getuserAuthenticityResponse) name:NOTIFICATION_GET_REGISTER_KEY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getTagListError) name:NOTIFICATION_ERROR_KEY object:nil];

}


/* THIS METHOD WILL CALL AFTER COMPLETION OF REGISTRATION WEBSERVICES CALLED. THIS WILL GET CALLED BY NSNOTIFICATIONCENTER. */

-(void)getuserAuthenticityResponse{
    
    
	[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_GET_REGISTER_KEY object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_ERROR_KEY object:nil];
    
	dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [[BusyAgent defaultAgent] makeBusy:NO showBusyIndicator:NO];

/* statusRegister IS A GLOBAL VARIABLE. IT WILL CONTAIN VALUE FOR RESGISTRATION WEBSERVICE RETURN. THIS IS WRITTEN IN MODEL CLASS. */
        
        if ([statusRegister isEqualToString:@"true"]) {
            
            [[AlertManger defaultAgent] showAlertWithTitle:APP_NAME message:@"Registered Successfully." cancelButtonTitle:@"OK"];
                       
            
        }else{
            
            
            [[AlertManger defaultAgent] showAlertWithTitle:APP_NAME message:@"A device is already registered with this account.\nPlease call 1-888-410-AH4R for assistance." cancelButtonTitle:@"OK"];
            
        }
        
    });
    
}


@end
