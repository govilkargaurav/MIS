//
//  ViewController.h
//  MinutesInSeconds
//
//  Created by ChintaN on 7/29/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKRevealingTableViewCell.h"
#import "NavigationSubclass.h"
#import "AwesomeMenu.h"
#import "DAL.h"
#import "PopOverViewController.h"
#import<MessageUI/MessageUI.h>

@interface ViewController : UIViewController<ZKRevealingTableViewCellDelegate,AwesomeMenuDelegate,MJSecondPopupDelegate,UITextFieldDelegate,MFMailComposeViewControllerDelegate>
{
    
    IBOutlet UIView *searchView;
    IBOutlet UITextField *txtField;
    IBOutlet UIButton *btnSearch;
    IBOutlet UIView *dateSearchView;
    
    IBOutlet UIButton *btnFrom;
    IBOutlet UIButton *btnTo;
    //keep referance of selected date button
    UIButton *selectedDateButton;
    // this for date picker view
    UIDatePicker *DatepickerView;
    UIToolbar *DatetoolBar;
    UIView *datePickerBackGroundView;
}
@property (nonatomic,strong)NSMutableArray *arrChildOfParantMeeting;
@property (nonatomic,strong) DAL *databaseOBJ;
@property (nonatomic,strong) NSMutableArray *resStatusArray;
@property (nonatomic, retain) ZKRevealingTableViewCell *currentlyRevealedCell;
@property (nonatomic, strong) IBOutlet UITableView *tblView;
@property (nonatomic, strong) NavigationSubclass *titleView;
@property (nonatomic, strong) UILabel *lblNavigationImage;

-(IBAction)SearchByDateButtonAction:(id)sender;
- (IBAction)SearchButtonAction:(id)sender;
-(void)OpenSearchViewAction:(id)sender;
-(void)AddMeetingBtnClicked:(id)sender;
- (IBAction)TodateAction:(id)sender;
- (IBAction)FromDateAction:(id)sender;
@end
