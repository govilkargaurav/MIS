//
//  ParticipantsQueViewController.h
//  T&L
//
//  Created by openxcell tech.. on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignatureViewController.h"
#import "ParticipantSignView.h"
#import "CustomMoviePlayerViewController.h"
#import "DatabaseAccess.h"

@interface UITextView (ParticipantQueViewCXontroller)
- (void)setContentToHTMLString:(NSString *) contentText;
@end

@interface ParticipantsQueViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ParticipantSignViewControllerDelegate,SignatureViewControllerDelegate,UIWebViewDelegate,UITextViewDelegate>
{
    
    IBOutlet UIButton *btnNextView;
    IBOutlet UILabel *lbl_1,*lbl_2;
    IBOutlet UIWebView *taskinfo;
    
    UIWebView *webView;
    
    NSMutableArray *finalArr,*aryParticpants;
    NSArray *ArrData;
    NSArray *ImgArrData;
    NSIndexPath *path;
    
    int i;
    NSString *checkStr;
    
    
    NSMutableArray *_arrNewOne;
    
    CustomMoviePlayerViewController *moviePlayer;
    //--------KPITEng
    NSMutableArray *arySelectStatus,*aryTextField;
    
    NSMutableArray *arySectionName,*aryQueTitle,*aryForCBoxRButton;
    CGSize size;
    UIFont* question_font;
    IBOutlet UITableView *_tableView;
    NSString *strPushView;
    int tblStart,tblEnd;
    
    //---------- Dynamic TextView -----------
    IBOutlet UITextView *tvWebData,*tvDynamic;
}
@property (nonatomic,strong)NSMutableArray *arySelectStatus,*aryTextField,*aryForCBoxRButton;
@property (nonatomic,strong) NSMutableArray *finalArr;
@property (nonatomic,strong) NSArray *ArrData;
@property (nonatomic,strong) NSArray *ImgArrData;

@property(nonatomic,strong)IBOutlet UIScrollView *_scrollView;
@property(nonatomic,strong)NSMutableArray *imageNmArr;
@property(nonatomic,strong)IBOutlet UITableView *_tableView;
-(IBAction)btnCheckBoxPressed:(id)sender;
-(IBAction)btnRadioButtonPressed:(id)sender;
-(void)complete;
@end
