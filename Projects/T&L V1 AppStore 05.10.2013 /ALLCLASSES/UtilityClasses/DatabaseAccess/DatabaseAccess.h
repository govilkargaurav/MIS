//
//  DatabaseAccess.h
//  Database
//
//  Created by apple on 01/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@interface DatabaseAccess : NSObject {
	NSString *string;
}
//-----------------------Departments Query----------------------------
+(void)insertAddDepartment:(NSString*)deptname uid:(int)uid superadminid:(int)superadminid;
+(NSArray*)getAddDepartment:(int)uid parent:(int)parent;
//+(void)deleteAddDepartment:(NSString *)deptid;
+(void)updateAddDepartment:(NSString *)deptid deptname:(NSString *)deptname;

#pragma mark -
#pragma mark - ViewController's Method
+(BOOL)isrecordExistin_tbl_resources:(NSString *)strQuery;
+(void)insert_tbl_Resources:(NSString *)ResourceID UnitCode:(NSString*)UnitCode UnitName:(NSString*)UnitName Version:(NSString*)Version Status:(NSString*)Status Resourceinfo:(NSString *)Resourceinfo Published:(NSString*)Published Published_date:(NSString *)Published_date Progress:(NSString *)Progress SectorID:(NSString*)SectorID SectorName:(NSString*)SectorName SectorColor:(NSString*)SectorColor CoverImage:(NSString *)CoverImage assessor_introduction:(NSString*)assessor_introduction assessortextcount:(NSString*)assessorcount participant_introduction:(NSString*)participant_introduction participanttextcount:(NSString*)participanttextcount resourcetype:(NSString*)resourcetype DownloadStatus:(NSString*)DownloadStatus;

+(void)INSERT_UPDATE_DELETE:(NSString *)strQuery;
+(void)DBINSERT:(NSMutableArray *)aryDBINSERT;



#pragma mark -
#pragma mark - ResourceListViewController's Method
+(NSMutableArray *)getall_tbl_Resources:(NSString*)strQuery;
+(NSMutableArray *)getAllParticipantName_ME:(NSString *)strQuery;
+(NSMutableArray *)getAllRecordTbl_Participants:(NSString *)strQuery;

#pragma mark - 
#pragma mark - AssessmentViewControllers' Method
+(NSMutableArray *)getallTasks:(NSString *)strQuery;

#pragma mark -
#pragma mark - Contextualisation Methods 
+(NSMutableArray *) getalltblcontext:(NSString *)strQuery;
+(NSMutableArray *) getalltblcontextoptionanswer:(NSString *)strQuery;
+(NSMutableArray *)getalltblcontextOption:(NSString*)strQuery;

#pragma mark -
#pragma mark - ThirdPartyResult's Method
+(NSMutableArray *) getThirdpartyresults_answer:(NSString*)strQuery;
+(NSMutableArray *) getthirdpartyresults:(NSString *)strQuery;
+(NSMutableArray *) getthirdpartyresults_detail:(NSString *)strQuery;
+(void)insert_thrdpartydetail:(NSString*)reportid resourceid:(NSString *)resourceid name:(NSString*)name position:(NSString*)position organization:(NSString*)organization officeadd:(NSString*)officeadd city:(NSString *)city state:(NSString *)state postcode:(NSString *)postcode phone:(NSString*)phone email:(NSString *)email assid:(NSString *)assid parid:(NSString*)partid;


#pragma mark -
#pragma mark - System Validation
+(NSMutableArray *)get_tbl_SysValidation:(NSString *)strQuery;
+(NSMutableArray *) get_tbl_SysValidationOptions:(NSString *)strQuery;
+(NSMutableArray *) get_tbl_SysValidationOptionsAnswer:(NSString *)strQuery;


#pragma mark -
#pragma mark - Results Method
+(NSMutableArray *) get_tbl_ResultsOptions:(NSString *)strQuery;
+(NSMutableArray *) get_tbl_ResultsOptionsAnswer:(NSString *)strQuery;
+(NSMutableArray *)get_tbl_Results:(NSString *)strQuery;
+(void)insert_tbl_ResultOptionsAnswer:(NSString*)ResultTaskTextID AssessmentTaskID:(NSString*)AssessmentTaskID Description:(NSString*)Description ResourceID:(NSString*)ResourceID AssTaskPartName:(NSString*)AssTaskPartName ParticipantID:(NSString*)ParticipantID Status:(NSString*)Status AssessorID:(NSString*)AssessorID Assessment_Task_Part_ID:(NSString*)Assessment_Task_Part_ID;


#pragma mark - Competency Mappint View's Method
+(NSMutableArray *)get_tbl_Competency:(NSString*)strQuery;
+(NSMutableArray *)get_tbl_CompetencyTask:(NSString *)strQuery;
+(NSMutableArray *)get_tbl_CompetencyTaskAnswer:(NSString *)strQuery;
+(NSMutableArray *)get_assessmentTasktitle:(NSString *)strQuery;
+(NSMutableArray *)get_tbl_CompetencyTaskQuestions:(NSString *)strQuery;


#pragma mark -
#pragma mark - AssessmentViewController's Method
+(int)getNoOfRecord:(NSString *)strQuery;
+(NSMutableArray *)getFromQuestionAnswer_UserID:(NSString *)strQuery;

#pragma mark -
#pragma mark - NewAssessorViewController's Method
+(void)insert_tbl_assessor:(NSString*)ass_name ass_jobtitle:(NSString*)ass_jobtitle ass_org:(NSString*)ass_org ass_empid:(NSString*)ass_empid ass_officeadd:(NSString*)ass_officeadd ass_city:(NSString*)ass_city ass_state:(NSString*)ass_state ass_phonenumber:(NSString*)ass_phonenumber asss_postcode:(NSString*)asss_postcode  ass_email:(NSString*)ass_email ass_supervisor:(NSString*)ass_supervisor ass_pinnumber:(NSString*)ass_pinnumber ass_secque:(NSString*)ass_secque ass_answer:(NSString*)ass_answer;
+(NSMutableArray *)get_assessor_information:(NSString *)strQuery;

#pragma mark -
#pragma mark - QuestionAssessorView's Method
+(NSMutableArray *)getallRecord_assessment_task_part_id:(NSString*)assessment_task_id;
+(NSMutableArray *)getallQuestion:(NSString *)strAssessmentTaskId strAssessmentTaskPartId:(NSString *)strAssessmentTaskPartId UserID:(NSString*)UserID;
+(NSMutableArray *)getOptionUsingQuestionID:(NSString *)questionID asstaskpartid:(NSString*)asstaskpartid;
+(NSMutableArray *)getanswer_result_tblQuestionOption:(NSString *)strQuery;
+(NSMutableArray *)getallQuestion:(NSString *)strassessment_task_part_id ASS_TASK_PART_ID:(NSString *)ASS_TASK_PART_ID;


#pragma -
#pragma mark - AllParticipant's Remaining Assessment Task
//+(NSMutableArray *)checkRecordExits_tblQuestionAnswer:(NSString*)sqlStmt;

#pragma mark -
#pragma mark - NParticipant
+(NSMutableArray *)get_ResumeTaskInfo:(NSString *)strQuery;
+(NSMutableArray *)get_All_ResumeTaskInfo:(NSString *)strQuery;

#pragma mark - tbl_ResumeFTask
+(NSMutableArray *)get_ResumeFTask:(NSString *)strQuery;

#pragma mark - tbl_Learning_Resources
+(NSMutableArray *)get_learningResources:(NSString *)strQuery;
+(NSMutableArray *)get_learningResourcesText:(NSString *)strQuery;
+(NSMutableArray *)get_learningResourcesFiles:(NSString *)strQuery;

#pragma mark - PDF Creation Data retrive
+(NSMutableArray *)result_tblQuestionOptionForPDFCreation:(NSString *)StrQuery;
+(NSMutableArray *)result_tblContextualisationOptionAnswerForPDFCreation:(NSString *)StrQuery;
+(NSMutableArray *)result_tblThirdPartyDetailForPDFCreation:(NSString *)StrQuery;
+(NSMutableArray *)result_tblThirdPartyReportsAnswerForPDFCreation:(NSString *)StrQuery;
+(NSMutableArray *)result_tblSysValidationOptionsAnswerForPDFCreation:(NSString *)StrQuery;
+(NSMutableArray *)result_tblResultsOptionsAnswerForPDFCreation:(NSString *)StrQuery;
+(NSMutableArray *)result_tblCompetencyTaskAnswerForPDFCreation:(NSString *)StrQuery;
+(NSMutableArray *)result_tblResultsOptionsCompetecyAnswerForPDFCreation:(NSString *)StrQuery;

@end
