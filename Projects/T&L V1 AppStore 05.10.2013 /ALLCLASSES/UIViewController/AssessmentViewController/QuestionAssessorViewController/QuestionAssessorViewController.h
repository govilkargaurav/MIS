//
//  QuestionAssessorViewController.h
//  T&L
//
//  Created by openxcell tech.. on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SignatureViewController.h"
#import "DatabaseAccess.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CustomMoviePlayerViewController.h"

@interface QuestionAssessorViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SignatureViewControllerDelegate,UIWebViewDelegate,UITextViewDelegate>

{
    
    UIButton *cellbutton;
    UIButton *cellbutton2;
    NSMutableDictionary *_downloadStatusDict;
    NSMutableDictionary *_downloadStatusDict2;
    NSString *buttonStatus;
    
    UIButton *Expandbutton;
    NSArray *ArrExpand;
    NSMutableDictionary *selectedIndexes;
    
    NSMutableArray *finalArr;
    NSArray *ArrData;
    
    NSIndexPath *path;
    int i,VideoID;
    NSString *checkStr;
    IBOutlet UIButton *btnContinue;
    //--------KPITEng
    NSMutableArray *arySelectStatus,*aryTextField,*aryassessment_task_part_id,*aryVidoes,*arrAssessorComment;
    
    CustomMoviePlayerViewController *moviePlayer;
    NSMutableArray *arySectionName,*aryNewTemp,*aryQueTitle,*aryTFAnswer,*aryAutoID;
    NSMutableDictionary *dictTextField;
    NSMutableArray *aryForCBoxRButton;
    IBOutlet UIView *viewOnTop;
    UIWebView *webView,*webViewKeyPoint;
    IBOutlet UILabel *lbl_1,*lbl_2;
    
    CGSize size;
    UIFont* question_font;
    NSMutableArray *aryQueOpn,*aryKeyPointValues;
}
@property(nonatomic,strong)NSMutableArray *_allQuestion,*aryassessment_task_part_id,*_arrNewOne,*aryVidoes,*aryForCBoxRButton;
@property (nonatomic,strong)NSMutableArray *arySelectStatus,*aryTextField;
@property(nonatomic,strong)NSMutableArray *buttonArray2;
@property(nonatomic,strong)NSMutableArray *buttonArray;
@property(nonatomic,strong)UITableView *_tableView;

@property (nonatomic,strong) NSMutableArray *finalArr;
@property (nonatomic,strong) NSArray *ArrData;


-(void)createTableView;
-(void)customActionPressed:(id)sender;
-(void)customActionPressed2:(id)sender;

//- (BOOL)cellIsSelected:(NSIndexPath *)indexPath;
-(IBAction)btnCheckBoxPressed:(id)sender;
-(IBAction)btnRadioButtonPressed:(id)sender;


@end
