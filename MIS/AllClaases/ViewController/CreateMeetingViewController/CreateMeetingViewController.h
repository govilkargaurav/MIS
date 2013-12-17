//
//  CreateMeetingViewController.h
//  MinutesInSeconds
//
//  Created by ChintaN on 7/30/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NavigationSubclass.h"
#import "UIScrollViewSubclass.h"
#import "KNMultiItemSelector.h"
#import "DAL.h"
#import "ATMHudDelegate.h"
#import "ATMHud.h"

@interface CreateMeetingViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,KNMultiItemSelectorDelegate,ATMHudDelegate>{
    IBOutlet UITextField *txtFldTitle;
    IBOutlet UIScrollViewSubclass *scrlView;
    IBOutlet UITextField *txtFldDateTime;
    IBOutlet UITextField *txtFldAttendees;
    IBOutlet UILabel *lblVoiceNotes;
    IBOutlet UIButton *btnAddMeeting;
    UIDatePicker *DatepickerView;
    UIToolbar *DatetoolBar;
    UIView *datePickerBackGroundView;
    IBOutlet UITextField *txtFldTime;
    UITextView *txtViewLocal;
    IBOutlet UIImageView *imageComment;
    IBOutlet UIImageView *BtnbackGroundOfDone;
    NSMutableArray *arrContact;
    NSData *dataOfSelectedImages;
      BOOL isCalanderPopOver;
}
@property(nonatomic,assign)Boolean isCreateNewChield;
@property (nonatomic, retain) ATMHud *hud;
@property (nonatomic,strong)NSString *strMeetingID;
@property (nonatomic,strong)NSString *strIDOfAttendees;
@property (nonatomic,strong) NSMutableArray *arrDatabseAttendeesTbl;
@property (nonatomic,strong)DAL *databaseOBJ;
@property (nonatomic,strong)NSMutableArray *arrPeoplePhNumber;
@property (nonatomic,strong)NSMutableArray *_arrPeopleInfo;
@property (nonatomic, strong)NSMutableDictionary *_dictPeopleInfo;
@property (nonatomic, strong) NavigationSubclass *titleView;
@property (nonatomic, strong) UILabel *lblNavigationImage;
@property (nonatomic, strong) IBOutlet UITextView *txtView;
@property (nonatomic,strong)NSMutableArray *arrOfLastObject;
-(IBAction)indexButtonDidTouch:(id)sender;
-(void)saveAttendeesTodatabase: completion completion:(void (^)(void))completionBlock;
- (IBAction)SetTitleAction:(id)sender;
- (IBAction)CommentAction:(id)sender;
@end
