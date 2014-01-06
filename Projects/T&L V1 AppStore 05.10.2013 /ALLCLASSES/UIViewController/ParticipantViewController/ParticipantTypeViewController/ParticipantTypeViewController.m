//
//  ParticipantTypeViewController.m
//  TLISC
//
//  Created by KPIteng on 4/30/13.
//
//

#import "ParticipantTypeViewController.h"

@interface ParticipantTypeViewController ()

@end

@implementation ParticipantTypeViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnNewParticipantTapped:(id)sender {
    objNewParticipentController = [[NewParticipentController alloc]initWithNibName:@"NewParticipentController" bundle:nil];
    [self.navigationController pushViewController:objNewParticipentController animated:YES];
}

- (IBAction)btnExistingParticipantTapped:(id)sender {
    objImportParticipants = [[ImportParticipants alloc]initWithNibName:@"ImportParticipants" bundle:nil];
    [self.navigationController pushViewController:objImportParticipants animated:YES];
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
