//
//  NParticipantViewController.h
//  TLISC
//
//  Created by OpenXcell-Macmini3 on 11/8/12.
//
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
#import "HelpViewController.h"
#import "SortResumeAssessmentViewController.h"
#import "PopoverFilter.h"

@interface NParticipantViewController : UIViewController
{
    IBOutlet UITableView *_tableView;
    NSMutableArray *_getallParticipantsArr;
    UIButton *cellbutton;
    UIPopoverController *popoverController;
    IBOutlet UIImageView *ivTopBarSelected;
    IBOutlet UITextField *tfSearchField;
    
    NSString *strSectorName;
}
-(IBAction)btnSortTapped:(id)sender;
-(IBAction)btnFilterTapped:(id)sender;
-(IBAction)btnSearchTapped:(id)sender;
-(void)reloadTableWithSortOption;
@end
