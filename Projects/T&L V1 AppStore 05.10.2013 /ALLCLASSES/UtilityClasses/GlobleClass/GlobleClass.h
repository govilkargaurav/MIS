//
//  GlobleClass.h
//  T&L
//
//  Created by openxcell tech.. on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobleClass : NSObject

extern NSMutableDictionary *_downloadStatusDict;
extern NSMutableDictionary *_downloadStatusDict2;
extern NSMutableArray *aryAllQueParticipant,*aryAllOptionParticipant,*aryAllCBoxRButtonParticipant;
extern NSString *navigationStr;
extern NSString *btnImgChangeStr;
extern NSString *navigationString;
extern NSString *magicStr;
extern NSString *magicStr2;
extern NSString *magicStr3;
extern NSString *btnImgChangeStr1;
extern NSString *strDataAvailable;
extern NSString *showAlert;
extern NSString *rID_Resource;
extern NSString *ParticipatnsContinue;




/***********************************For JSON Parsing***********************************/

extern NSString *viewWillAppearStr;
extern NSMutableDictionary *copyMutableDictionary;
extern NSString *globle_SectorName;

extern NSString *globle_resource_id;
extern NSString *globle_assessment_task_id;
extern NSString *globle_participant_id;

extern NSString *globle_UnitName;
extern NSString *globle_strUnitCode;
extern NSString *globle_strVersion;
extern NSString *globle_UnitInfo;
extern NSString *globle_SectorCover;
extern NSString *globle_strAssName;
extern NSString *globle_strAssLocation;
extern NSString *globle_ParticipantName;
extern NSInteger globle_QuestionCount;
extern NSMutableArray *aryTField,*aryYNResult;
extern NSString *callViewWillAppearParticipantView;
extern NSString *globlestrIconName;

//---  Assessor & Participant Login Info global ----
extern NSMutableArray *aryParticipantInfoGlobal;
extern NSMutableArray *arAllResourcesGloble;

//--------  Sort for which view  ----------
extern NSString *sortViewName;

//--- TL Small Icon On Right Side --------
extern NSString *globle_SectorIcon;
extern NSString *strSortType,*sortResumeAssType;

//-------  Filter -----
extern NSString *strFilterType;
extern NSMutableDictionary *dictAllResources;
//------ tab focus   -----
extern NSString *tabFocus;


//--- contextualisation - resourceid at inserttime--
extern NSString *contResourceID;

//----- contextualisation description ----
extern NSString *contextualisationDescription;


//-------new global assessor information ----------
extern NSMutableArray *newglobalassessorinfo;

//------globle class when loging-----
extern NSMutableArray *aryResultOpn;
extern NSString *strDescription;
extern NSMutableArray *arySysValidationOption;
extern NSMutableArray *arySysValidationAnswer;
extern NSMutableArray *aryCompetency,*aryCompetencyTask;

extern NSMutableArray *aryCompetencyAnswer;

extern NSString *asstaskOutline;


//------- Assessor To Participant Move -----
extern NSString *AsParYsNo;

//-------- NParticipant ----
extern NSString *PName,*PDate;

/* -----------------Calculate Time Duration --------------*/
extern NSDate *StartTime,*EndTime;

/* ----------------- Task In Edit Mode -------------------*/
extern NSString *taskEditMode;
extern NSMutableArray *aryResumeInfo;

/* ----------------- Learning Resources -------------------*/
extern NSString *FilterFromView;

/*------------------First | Second Tab Selected Index------*/
extern NSString *strFTabSelectedID,*strSTabSelectedID;


@end


