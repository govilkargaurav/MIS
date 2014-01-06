//
//  EditParticipantInfoViewController.m
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 11/28/12.
//
//

#import "EditParticipantInfoViewController.h"

@interface EditParticipantInfoViewController ()

@end

@implementation EditParticipantInfoViewController

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
    NSLog(@"%@",aryParticipantInfoGlobal);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
    [participantsNameField setText:[[aryParticipantInfoGlobal objectAtIndex:0] valueForKey:@"part_name"]];
    [jobTitleField setText:[[aryParticipantInfoGlobal objectAtIndex:0] valueForKey:@"job_title"]];
    [companyField setText:[[aryParticipantInfoGlobal objectAtIndex:0] valueForKey:@"company"]];
    [empIdStuIdField setText:[[aryParticipantInfoGlobal objectAtIndex:0] valueForKey:@"empId_stuNo"]];
    [addressField setText:[[aryParticipantInfoGlobal objectAtIndex:0] valueForKey:@"address"]];
    [suburbCityField setText:[[aryParticipantInfoGlobal objectAtIndex:0] valueForKey:@"suburb_city"]];
    [stateField setText:[[aryParticipantInfoGlobal objectAtIndex:0] valueForKey:@"state"]];
    [postcodeField setText:[[aryParticipantInfoGlobal objectAtIndex:0] valueForKey:@"post_date"]];
    [countryField setText:[[aryParticipantInfoGlobal objectAtIndex:0] valueForKey:@"country"]];
    [emailField setText:[[aryParticipantInfoGlobal objectAtIndex:0] valueForKey:@"email"]];
    [phoneNoField setText:[[aryParticipantInfoGlobal objectAtIndex:0] valueForKey:@"ph_no"]];
    [superviserFiled setText:[[aryParticipantInfoGlobal objectAtIndex:0] valueForKey:@"superviser"]];
    //participantsID
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

-(IBAction)btnSaveTapped:(id)sender
{
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE TBL_PARTICIPANTS SET PART_NAME = '%@',JOB_TITLE = '%@',EMPID_STUNO = '%@',COMPANY = '%@', ADDRESS = '%@',SUBURB_CITY = '%@',STATE = '%@',POST_DATE = '%@', COUNTRY = '%@', EMAIL = '%@', PH_NO = '%@', SUPERVISER = '%@' WHERE CAST(PARTICIPANTSID AS INT) = %@",participantsNameField.text,jobTitleField.text,empIdStuIdField.text,companyField.text,addressField.text,suburbCityField.text,stateField.text,postcodeField.text,countryField.text,emailField.text,phoneNoField.text,superviserFiled.text,[[aryParticipantInfoGlobal objectAtIndex:0] valueForKey:@"participantsID"]];
    
    NSLog(@"%@",strQuery);
    
    [DatabaseAccess INSERT_UPDATE_DELETE:strQuery];
    
    aryParticipantInfoGlobal = [[NSMutableArray alloc]initWithArray:[DatabaseAccess getAllRecordTbl_Participants:[NSString stringWithFormat:@"Select *from tbl_participants where empId_stuNo = '%@'", empIdStuIdField.text]]];
    NSLog(@"%@",aryParticipantInfoGlobal);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
