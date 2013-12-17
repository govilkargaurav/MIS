//
//  PopOverViewController.h
//  MinutesInSeconds
//
//  Created by KPIteng on 10/7/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MJSecondPopupDelegate;
@interface PopOverViewController : UIViewController
{
    IBOutlet UITableView *tblView;
    IBOutlet UILabel *lblTitel;
    IBOutlet UIButton *btnDone;
    IBOutlet UIButton *btnCancel;
}

@property(nonatomic,strong)NSDictionary *SelectedSubMeeting;
@property(nonatomic,strong)NSString *popOverType;
@property(nonatomic,strong)NSMutableArray *subMeentingList;
@property (assign, nonatomic) id <MJSecondPopupDelegate>delegate;
@property(nonatomic,strong)NSIndexPath *indexPath;
@end

@protocol MJSecondPopupDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(PopOverViewController * )secondDetailViewController;
@end