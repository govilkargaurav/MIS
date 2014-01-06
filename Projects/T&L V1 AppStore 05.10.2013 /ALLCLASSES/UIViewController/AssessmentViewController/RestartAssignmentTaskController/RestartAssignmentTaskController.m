//
//  RestartAssignmentTaskController.m
//  T&L
//
//  Created by openxcell tech.. on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestartAssignmentTaskController.h"

@implementation RestartAssignmentTaskController
@synthesize promptView;


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
    // Do any additional setup after loading the view from its nib.
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
	return YES;
}


-(IBAction)promptView:(id)sender{
    
    
    promptView=[[UIView alloc] initWithFrame:CGRectMake(0, 133,768,955 )];
    promptView.backgroundColor=[UIColor blackColor];
    promptView.alpha=0.9;
    
    UILabel *titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(250,250,290,25)];
    titleLbl.backgroundColor=[UIColor clearColor];
    titleLbl.textColor=[UIColor grayColor];
    titleLbl.font=[UIFont boldSystemFontOfSize:18];
    titleLbl.text=@"Assessment task 1:Identify flaws in rail";
    [promptView addSubview:titleLbl];
    
    
    UILabel *titleLbl2=[[UILabel alloc] initWithFrame:CGRectMake(250,280,290,25)];
    titleLbl2.backgroundColor=[UIColor clearColor];
    titleLbl2.textColor=[UIColor grayColor];
    titleLbl2.font=[UIFont boldSystemFontOfSize:16];
    titleLbl2.text=@"TL00015 | Version 5.0 | Current ";
    [promptView addSubview:titleLbl2];
    
    
    
    UILabel *titleLbl3=[[UILabel alloc] initWithFrame:CGRectMake(250,310,350,120)];
    titleLbl3.backgroundColor=[UIColor clearColor];
    titleLbl3.textColor=[UIColor whiteColor];
    titleLbl3.font=[UIFont boldSystemFontOfSize:28];
    titleLbl3.lineBreakMode =  NSLineBreakByWordWrapping;
    titleLbl3.numberOfLines = 4;
    titleLbl3.text=@"This will delete existing answer information.";
    [promptView addSubview:titleLbl3];
    
    
    UILabel *titleLbl4=[[UILabel alloc] initWithFrame:CGRectMake(250,440,290,60)];
    titleLbl4.backgroundColor=[UIColor clearColor];
    titleLbl4.textColor=[UIColor whiteColor];
    titleLbl4.font=[UIFont boldSystemFontOfSize:28];
    titleLbl4.text=@"Are you sure?";
    [promptView addSubview:titleLbl4];
    
    
    UIButton *restartNow=[[UIButton alloc] initWithFrame:CGRectMake(250,520 , 147, 46)];
    [restartNow setImage:[UIImage imageNamed:@"restartBtn.png"] forState:UIControlStateNormal];
    [restartNow addTarget:self action:@selector(customActionPressedrestart)forControlEvents:UIControlEventTouchDown];
    [promptView addSubview:restartNow];
    
    
    UIButton *cancleBtn=[[UIButton alloc] initWithFrame:CGRectMake(420,520 , 78, 46)];
    [cancleBtn setImage:[UIImage imageNamed:@"Cancelup.png"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(customActionPressedcancle)forControlEvents:UIControlEventTouchDown];
    [promptView addSubview:cancleBtn];
    
    
    [self.view addSubview:promptView];
    
    
}


-(void)customActionPressedrestart{
    
    
    [self.promptView removeFromSuperview];
    
}


-(void)customActionPressedcancle{
    
    
     [self.promptView removeFromSuperview];
    
}

-(IBAction)removeSuperView:(id)sender{
    
    
    [self.view removeFromSuperview];
    
}



@end
