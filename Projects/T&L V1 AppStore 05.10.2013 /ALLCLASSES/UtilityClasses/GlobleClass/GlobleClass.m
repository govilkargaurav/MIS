//
//  GlobleClass.m
//  T&L
//
//  Created by openxcell tech.. on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobleClass.h"

@implementation GlobleClass

NSMutableDictionary *_downloadStatusDict=nil;
NSMutableDictionary *_downloadStatusDict2=nil;
NSMutableArray *aryAllQueParticipant=nil;
NSMutableArray *aryAllOptionParticipant=nil;
NSMutableArray *aryAllCBoxRButtonParticipant = nil;
NSString *navigationStr=@"";
NSString *btnImgChangeStr=@"";
NSString *navigationString=@"";
NSString *magicStr=@"";
NSString *magicStr2=@"";
NSString *magicStr3=@"";
NSString *btnImgChangeStr1=@"";
NSString *strDataAvailable = @"";
NSString *showAlert = @"";
NSString *rID_Resource = @"786";
NSString *ParticipatnsContinue = @"NONE";

/***********************************For JSON Parsing***********************************/
NSString *globle_SectorName=@"Default";
NSMutableDictionary *copyMutableDictionary=nil;
NSString *viewWillAppearStr=@"";
NSString *globle_resource_id=@"";
NSString *globle_assessment_task_id=@"";
NSString *globle_participant_id=@"";
NSString *callViewWillAppearParticipantView = @"YES";

//----------------for resource value---------
NSString *globle_UnitName = @"";
NSString *globle_strUnitCode = @"";
NSString *globle_strVersion = @"";
NSString *globle_UnitInfo = @"";
NSString *globle_SectorCover = @"";
NSString *globle_ParticipantName = @"";
NSString *globle_strAssLocation = @"";
NSString *globle_strAssName = @"";
NSInteger globle_QuestionCount= 0;
NSMutableArray *aryTField,*aryYNResult = nil;
NSMutableArray *arAllResourcesGloble = nil;

//---  Assessor & Participant Login Info global ----
NSMutableArray *aryParticipantInfoGlobal = nil;

//--- TL Small Icon On Right Side --------
NSString *globle_SectorIcon = @"";
NSString *strSortType = @"";
NSString *sortResumeAssType = @"";
NSString *globlestrIconName = @"";


//------- Sort For Which View ----
NSString *sortViewName = @"";

//------- Filter ------
NSString *strFilterType = @"";
NSMutableDictionary *dictAllResources;


NSString *tabFocus = @"";

///----- Context --- resource ----
NSString *contResourceID;
NSString *contextualisationDescription;


//-------new global assessor information ----------
NSMutableArray *newglobalassessorinfo;
NSMutableArray *aryResultOpn;
NSString *strDescription;
NSMutableArray *arySysValidationOption;
NSMutableArray *arySysValidationAnswer;
NSMutableArray *aryCompetency,*aryCompetencyTask;
NSMutableArray *aryCompetencyAnswer;

NSString *asstaskOutline;

//------- Assessor To Participant Move -----
NSString *AsParYsNo = @"YES";

//------- NParticipant -----
NSString *PName = @"";
NSString *PDate = @"";


/* -----------------Calculate Time Duration --------------*/
NSDate *StartTime,*EndTime;

/* ----------------- Task In Edit Mode -------------------*/
NSString *taskEditMode = @"NONE";
NSMutableArray *aryResumeInfo;

/* ----------------- Learning Resources -------------------*/
NSString *FilterFromView;

/*------------------First | Second Tab Selected Index------*/
NSString *strFTabSelectedID,*strSTabSelectedID;
@end
