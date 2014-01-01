//
//  LoginViewController.m
//  LawyerApp
//
//  Created by Openxcell Game on 6/6/13.
//  Copyright (c) 2013 Openxcell Game. All rights reserved.
//

#import "LoginViewController.h"
#import "LawyerInfoViewController.h"
#import "FTAnimationManager.h"
#import "FTAnimation+UIView.h"
#import "SignUpViewController.h"
#import "JSONParsingAsync.h"
#pragma mark - KeyBoard Methods
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 200;

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize loadingActivityIndicator;
@synthesize appdelegate;
CGFloat animatedDistance;
@synthesize queue=_queue;
@synthesize txtFldPassword;
@synthesize txtFldUserName;
@synthesize btnLogin;
@synthesize btnSignUp;
@synthesize globalTextField;
@synthesize ArrLawyerInfo;
@synthesize btnRememberMe;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)backBtnPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissModalViewControllerAnimated:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _queue = [[NSOperationQueue alloc] init];
    // Do any additional setup after loading the view from its nib.
    [self performSelector:@selector(animationBegin:) withObject:self afterDelay:0.2];
    [self.navigationController setNavigationBarHidden:TRUE];
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"USER_NAME"]) {
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"USER_NAME"]);
        txtFldUserName.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"USER_NAME"]];
        [btnRememberMe setImage:[UIImage imageNamed:@"rememberme_full.png"] forState:UIControlStateNormal];
        ISREMEBER=YES;
    }

    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"PASSWORD"]) {
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"PASSWORD"]);
        txtFldPassword.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"PASSWORD"]];
    }
}

#pragma mark FTAnimation Done
-(void)animationBegin:(id)sender{
    [btnLogin popIn:1.0 delegate:self];
//    [btnSignUp popIn:1.0 delegate:self];
    btnLogin.alpha=1;
//    btnSignUp.alpha=1;
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    txtFldUserName.text=@"";
//    txtFldPassword.text=@"";
    self.title=@"Login";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - TextField Delegate Method

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    globalTextField = textField;
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

-(IBAction)lawyerInfo:(id)sender{
    
    LawyerInfoViewController *lawyerInfo =[[LawyerInfoViewController alloc] initWithNibName:@"LawyerInfoViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:lawyerInfo animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [globalTextField resignFirstResponder];
    
}
-(IBAction)btnPressed:(id)sender{
    
    if ([sender tag]==1) {
        
//        if ([txtFldUserName.text isEqualToString:@""] || [txtFldUserName.text isEqualToString:@""]) {
//            DisplayAlert(@"Please Enter Valid Crendentials");
//            return;
//        }
        
        APP_DELEGATE;
        INTERNET_NOT_AVAILABLE
        
        [_queue addOperationWithBlock:^{
            
            id jsonObject = [[JSONParsingAsync sharedManager] getserviceResponse:@"http://yolokiifr.trawire.com/webservice/insert_data.php?query=SELECT%20code,name%20FROM%20user%20where%20createdate%20%3E%20%271900-01-01%2010:10:00%27&action=select"];
            NSDictionary *jsonDictionary;
            NSArray *jsonArray;
            
            if ([jsonObject isKindOfClass:[NSArray class]]) {
                jsonArray = (NSArray *)jsonObject;
            }else if([jsonObject isKindOfClass:[NSDictionary class]]){
                jsonDictionary = (NSDictionary *)jsonObject;
            }
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                
                ArrLawyerInfo = [[NSMutableArray alloc] init];
                ArrLawyerInfo = [[jsonDictionary valueForKey:@"user_info"] mutableCopy];
                if ([[jsonDictionary valueForKey:@"message"] isEqualToString:@"Email Id or password did not match"]) {
                    
                    DisplayAlert([jsonDictionary valueForKey:@"message"]);
                    return ;
                }else if ([[jsonDictionary valueForKey:@"isSubscribed"] isEqualToString:@"yes"]){
                    
                    DisplayAlert([jsonDictionary valueForKey:@"You are not subscribed user. Please contact to admin or purchase "]);
                    return ;
                }
                LawyerInfoViewController *infoCtlr = [[LawyerInfoViewController alloc] initWithNibName:@"LawyerInfoViewController" bundle:[NSBundle mainBundle]];
                infoCtlr.arrLawyerInfo= ArrLawyerInfo;
                [self.navigationController pushViewController:infoCtlr animated:YES];
                
            }];
        }];
        
    }else{
        
        SignUpViewController *signup=[[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
        [self.navigationController pushViewController:signup animated:YES];
        
    }
    
}

#pragma mark-
#pragma mark Remember Me

-(IBAction)rememberMe:(id)sender{
    
    if (ISREMEBER==YES) {
        ISREMEBER=NO;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USER_NAME"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PASSWORD"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [btnRememberMe setImage:[UIImage imageNamed:@"rememberme_empty.png"] forState:UIControlStateNormal];
        return;
    }
    
    ISREMEBER=YES;
    [[NSUserDefaults standardUserDefaults] setValue:txtFldUserName.text forKey:@"USER_NAME"];
    [[NSUserDefaults standardUserDefaults]setValue:txtFldPassword.text forKey:@"PASSWORD"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [btnRememberMe setImage:[UIImage imageNamed:@"rememberme_full.png"] forState:UIControlStateNormal];
    
}

@end
