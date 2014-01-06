//
//  AssessmentsVIewController.h
//  T&L
//
//  Created by openxcell tech.. on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "ARCMacro.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "EditParticipantInfoViewController.h"
#import "AssessorTypeViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@class YLProgressBar;
@interface AssessmentsVIewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,MFMailComposeViewControllerDelegate>{
    
    AppDelegate *appDel;
    
    int aryCount,aryCount_1,hun,rem;
    float progressValue;
    NSString *strAssessmentTaskPartID_QUE,*strGoToNextView;
    
    IBOutlet UILabel *lblPartName,*lblRName,*lblRInfo,*lblBackGround,*lblProgressValue,*lblIconName;
    IBOutlet UIImageView *imgThumb,*ivIcon,*ivTopBarSelected;
    
    NSData *pdfDataDownload;
    NSMutableData *responseData;
    NSMutableArray *aryOtherOption,*aryContexOptionAnswer,*aryThirdPartyAnswer,*arySysValidation,*arySysValidationOptionAnswer,*aryResults,*aryResultsOptionsAnswer,*aryJSONRoot,*aryJSONRequestAssessor,*aryJSONRequestContextualisation,*aryThirdPartyUserInfo,*aryThirdPartyQuery,*aryJSONRequestSysValidation,*aryJSONRequestResults,*aryJSONRequestCompetency,*aryJSONRequestResultsCompetency;
    NSMutableDictionary *dictJSONRoot;
    
    UIButton *cellbutton,*cellbutton2;
    IBOutlet UIView *viewSendEmail,*viewInfo,*pdfView;
    IBOutlet UIWebView *pdfWebView;
    IBOutlet UIButton *btnEmailPDF,*exitButton,*btnSendEmail;
    IBOutlet UITextField *tfEmailAddress;
    
    
    UIPopoverController *popoverController;
    EditParticipantInfoViewController *objEditParticipantInfoViewController;
    ASIFormDataRequest *ASIRequest;
    AssessorTypeViewController *objAssessorTypeViewController;
}
@property (nonatomic,strong) IBOutlet YLProgressBar *progressView;
@property(nonatomic,strong)NSMutableArray *assessment_task_part_id;
@property(nonatomic,strong)NSString *strAssessmentTaskPartID_QUE;
@property(nonatomic,strong)NSMutableArray *_getallTasks;
@property(nonatomic,strong)UITableView *_tableView;
@property(nonatomic,strong)NSURLRequest *request;
@property(nonatomic,strong)NSMutableArray *getallAssessmentTaskpartidArr,*_aryAssessmentIdDb,*_aryAssessmentIdExists,*_aryQuestionOption;
@property(nonatomic,strong)NSMutableDictionary *dictAssesements;
-(IBAction)loginViewPushed:(NSString*)sender;
- (IBAction)btnSendMeTapped:(id)sender;
@end
