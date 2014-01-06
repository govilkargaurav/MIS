//
//  NAssessmentViewController.h
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
#import "JSON.h"
#import "ARCMacro.h"
#import "PopoverSort.h"
#import "AppDelegate.h"
#import "AssessorTypeViewController.h"
@class YLProgressBar;

@interface NAssessmentViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    int aryCount,aryCount_1,hun,rem;
    float progressValue;
    
    
    NSString *strAssessmentTaskPartID_QUE;
    
    UIButton *cellbutton,*cellbutton2;
    UIPopoverController *popoverController;
    IBOutlet UILabel *lblPartName,*lblRName,*lblRInfo,*lblBackGround,*lblProgressValue,*lblIconName,*lblPName,*lblSecName,*lblResource_1,*lblResource_2;
    IBOutlet UIImageView *imgThumb,*ivIcon,*ivResource,*ivSector,*ivTopBarSelected;
    
    NSMutableData *responseData;
    NSMutableArray *aryThirdPartyAnswer,*arySysValidation,*arySysValidationOptionAnswer,*aryResults,*aryResultsOptionsAnswer,*aryOtherOption,*aryContexOptionAnswer;
    
    PopoverSort *_popOverSort;
    AppDelegate *appDel;
    AssessorTypeViewController *objAssessorTypeViewController;
        
    IBOutlet UIView *viewSendEmail,*viewInfo;
    
}
@property (nonatomic,strong) IBOutlet YLProgressBar *progressView;
@property(nonatomic,strong)NSMutableArray *assessment_task_part_id;
@property(nonatomic,strong)NSString *strAssessmentTaskPartID_QUE;
@property(nonatomic,strong)NSMutableArray *_getallTasks;
@property(nonatomic,strong)UITableView *_tableView;
@property(nonatomic,strong)NSURLRequest *request;
@property(nonatomic,strong)NSMutableArray *getallAssessmentTaskpartidArr,*_aryAssessmentIdDb,*_aryAssessmentIdExists,*_aryQuestionOption;
@property(nonatomic,strong)NSMutableDictionary *dictAssesements;
-(void)createTableView;
-(IBAction)btnHomePressed:(id)sender;
-(IBAction)btnLearningPressed:(id)sender;
-(IBAction)btnAssessmentPressed:(id)sender;
-(IBAction)btnResourcePressed:(id)sender;
-(IBAction)sortDropDown:(id)sender;
-(IBAction)loginViewPushed:(NSString*)str;
- (IBAction)btnSendMeTapped:(id)sender;
@end
