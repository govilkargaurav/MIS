//
//  ActivityViewController.h
//  FitTag
//
//  Created by Mic mini 5 on 3/2/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ActivityViewController : UIViewController<UIGestureRecognizerDelegate>{
    NSMutableArray * arrAllData;
    AppDelegate *appDelegate;
}
@property (strong, nonatomic) IBOutlet UITableView *tblActivity;
@property (strong, nonatomic) IBOutlet UIView *viewMenu;
@property(nonatomic)bool isOpen;
#pragma mark Menu Animations
-(void)viewMenuOpenAnim;
-(void)viewMenuCloseAnim;
@end
