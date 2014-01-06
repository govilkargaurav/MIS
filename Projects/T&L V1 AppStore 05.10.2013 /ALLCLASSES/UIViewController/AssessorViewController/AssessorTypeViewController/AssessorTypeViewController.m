//
//  AssessorTypeViewController.m
//  TLISC
//
//  Created by KPIteng on 5/1/13.
//
//

#import "AssessorTypeViewController.h"
#import "NewAssessorViewController.h"

@interface AssessorTypeViewController ()

@end

@implementation AssessorTypeViewController
@synthesize strNextPushController;

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
    appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //------Topbar Image Set
    [ivTopBarSelected setImage:[appDel topbarselectedImage:strFTabSelectedID]];
    
    lblUnitName.text = globle_UnitName;
    [lblUnitInfo setText:[NSString stringWithFormat:@"%@ | %@ | %@",globle_strUnitCode,globle_strVersion,globle_UnitInfo]];
    
    [lblIconName setText:globle_SectorName];
    [lblIconName.text uppercaseString];
    [ivIcon setImage:[UIImage imageNamed:globle_SectorIcon]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnNewAssessorTapped:(id)sender{
    
    NSLog(@"%@",strNextPushController);
    NewAssessorViewController *objNewAssessorViewController = [[NewAssessorViewController alloc]initWithNibName:@"NewAssessorViewController" bundle:nil];
    objNewAssessorViewController.strPushViewController = strNextPushController;
    objNewAssessorViewController.strSelectedView = [NSString stringWithFormat:@"%d",[sender tag]];
    [self.navigationController pushViewController:objNewAssessorViewController animated:YES];
}


- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnHomePressed:(id)sender
{
    NSNotification *notif = [NSNotification notificationWithName:@"popToViewController" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(IBAction)btnLearningPressed:(id)sender
{
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_12" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(IBAction)btnAssessmentPressed:(id)sender
{
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_13" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

-(IBAction)btnResourcePressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSNotification *notif = [NSNotification notificationWithName:@"SetTabBar_14" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}
@end
