//
//  AboutViewController.m
//  FitTag
//
//  Created by Vishal Jani on 5/14/13.
//
//

#import "AboutViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AboutViewController ()

@end

@implementation AboutViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
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
    
    // Make icon raound rect
    [FittageIcone.layer setCornerRadius:5.0];
    lblVersion.font = [UIFont fontWithName:@"DynoRegular" size:14];
    txtViewWelcomeTextDescription.font = [UIFont fontWithName:@"DynoRegular" size:14];
    txtViewWelcomeTextDescription.text = @"Welcome to Fittag where you can explore and take challenges to reach your goals. It’s a free, fun, and simple way to connect, compare and challenge your fitness. Fittag is your step-by-step guide to everything #Fit. You can Fittag anyone, anytime, anywhere!";
}

#pragma mark Back action

-(IBAction)btnHeaderbackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(IBAction)btnReviewAppStorePressed:(id)sender {
    NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
    str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
    str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
    
    // Here is the app id from itunesconnect
    str = [NSString stringWithFormat:@"%@651353306", str];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(IBAction)btnFollowOnTwitterPressed:(id)sender{
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"http://www.twitter.com/FitTag"]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/FitTag"]];
    }else{
        DisplayAlertWithTitle(@"FitTag", @"we are unable to open this page, Please try after some time.")
    }
}

-(IBAction)btnLikeOnFacebookPressed:(id)sender{
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"http://www.facebook.com/FitTag"]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/FitTag"]];
    }else{
        DisplayAlertWithTitle(@"FitTag", @"we are unable to open this page, Please try after some time.")
    }
}

@end
