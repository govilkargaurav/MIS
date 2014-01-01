//
//  ShareSettingViewController.m
//  FitTag
//
//  Created by apple on 3/14/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ShareSettingViewController.h"

@implementation ShareSettingViewController
@synthesize switchFacebook;
@synthesize switchTwitter;
@synthesize switchContect,lbl3,lbl2,lbl1;

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
-(void)viewDidLoad{
     
     [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    lbl1.font = [UIFont fontWithName:@"DynoBold" size:14];
    lbl2.font = [UIFont fontWithName:@"DynoBold" size:14];
    lbl3.font = [UIFont fontWithName:@"DynoBold" size:14];
}

- (void)viewDidUnload
{
    [self setSwitchFacebook:nil];
    [self setSwitchTwitter:nil];
    [self setSwitchContect:nil];
    [self setLbl1:nil];
    [self setLbl2:nil];
    [self setLbl3:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark-button Actions

-(IBAction)btnHeaderbackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)facebookSettingChange:(id)sender{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"facebookShare"];
    
    if(switchFacebook.isOn){
        [[NSUserDefaults standardUserDefaults]setObject:@"ON" forKey:@"facebookShare"];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"OFF" forKey:@"facebookShare"];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(IBAction)twitterSettingChanged:(id)sender{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"twitterShare"];
    
    if(switchTwitter.isOn){
        [[NSUserDefaults standardUserDefaults]setObject:@"ON" forKey:@"twitterShare"];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"OFF" forKey:@"twitterShare"];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(IBAction)contactSettingZChanged:(id)sender{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"contactShare"];
    
    if(switchContect.isOn){
        [[NSUserDefaults standardUserDefaults]setObject:@"ON" forKey:@"contactShare"];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"OFF" forKey:@"contactShare"];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}
@end
