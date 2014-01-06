//
//  TabbarController.m
//  T&L
//
//  Created by openxcell tech.. on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TabbarController.h"
#import "GlobleClass.h"
@implementation TabbarController

@synthesize currentViewController;
@synthesize QAviewController,QAViewNavController,participantsViewController,participantsNavViewController;
@synthesize loginVeiw,loginViewNavController;
@synthesize questionAsseessorView,questionAsseessorNavCnTlr;

static TabbarController *_sharedInstance;


+ (TabbarController *) sharedInstance {
    
	if (!_sharedInstance) {
		_sharedInstance = [[TabbarController alloc]initWithNibName:@"TabbarController" bundle:nil];
	}
	return _sharedInstance;
}

-(void) releaseResources {
	_sharedInstance=nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withViewType:(int) vType {
    if (self ==[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}


-(IBAction) showQAview{
	if(currentViewController != nil) {
		[self.currentViewController viewWillDisappear:YES];
		[self.loginVeiw.view removeFromSuperview];		
	}		
	
	if(self.loginVeiw == nil) {
		self.loginVeiw = [[KeypadVC alloc] initWithNibName:@"KeypadVC" bundle:nil];				
		[self.loginViewNavController viewWillAppear:YES];
	} else {
		[loginViewNavController popToRootViewControllerAnimated:NO];	
		[self.loginViewNavController viewWillAppear:YES];				
	}		
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	
	if (version >= 3.2 && loginViewNavController.view.frame.origin.y <= 0.000000)
	{
		
		loginViewNavController.view.frame = CGRectMake( 0, 0, 768, 1024);
	}
	
	[self.view addSubview:loginViewNavController.view];
	currentViewController = loginViewNavController;	
    
    
}

-(IBAction) showparticipantQueView{
	if(currentViewController != nil) {
		[self.currentViewController viewWillDisappear:YES];
		[self.questionAsseessorView.view removeFromSuperview];		
	}		
	
	if(self.questionAsseessorView == nil) 
    {
        //ParticipatnsContinue = @"NO";
		self.questionAsseessorView = [[QuestionAssessorViewController alloc] initWithNibName:@"QuestionAssessorViewController" bundle:nil];				
		[self.questionAsseessorNavCnTlr viewWillAppear:YES];
	} else 
    {
        //ParticipatnsContinue = @"NO";
		[questionAsseessorNavCnTlr popToRootViewControllerAnimated:NO];	
		[self.questionAsseessorNavCnTlr viewWillAppear:YES];				
	}		
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	
	if (version >= 3.2 && questionAsseessorNavCnTlr.view.frame.origin.y <= 0.000000)
	{
		
		questionAsseessorNavCnTlr.view.frame = CGRectMake( 0, 0, 768, 1024);
	}
	
	[self.view addSubview:questionAsseessorNavCnTlr.view];
	currentViewController = questionAsseessorNavCnTlr;	
        
}


-(IBAction) showParticipatsview{
	if(currentViewController != nil) {
		[self.currentViewController viewWillDisappear:YES];
		[self.participantsViewController.view removeFromSuperview];		
	}		
	
	if(self.participantsViewController == nil) {
		self.participantsViewController = [[ParticipantsQueViewController alloc] initWithNibName:@"ParticipantsQueViewController" bundle:nil];				
		[self.participantsNavViewController viewWillAppear:YES];
	} else {
		[participantsNavViewController popToRootViewControllerAnimated:NO];	
		[self.participantsNavViewController viewWillAppear:YES];				
	}		
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	
	if (version >= 3.2 && participantsNavViewController.view.frame.origin.y <= 0.000000)
	{
		
		participantsNavViewController.view.frame = CGRectMake( 0, 0, 768, 1024);
	}
	
	[self.view addSubview:participantsNavViewController.view];
	currentViewController = participantsNavViewController;	
    
}


- (void)loadView {
	[super loadView];
	[self setWantsFullScreenLayout:YES];
	
	//[self showAboutUsScreenView];
}
- (IBAction) hideTabViewController {
	
    
    
    navigationStr=@"1";
    
    [self dismissModalViewControllerAnimated:YES];

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

@end
