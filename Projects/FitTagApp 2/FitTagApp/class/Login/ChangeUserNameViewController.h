//
//  ChangeUserNameViewController.h
//  FitTag
//
//  Created by Vishal Jani on 10/3/13.
//
//
@protocol changeUserName <NSObject>

-(void)userName :(NSString *)strUserName;

@end
#import <UIKit/UIKit.h>

@interface ChangeUserNameViewController : UIViewController<UITextFieldDelegate>{

    CGFloat animatedDistance;

}
@property (strong, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property(nonatomic,retain)id<changeUserName>delegate;
- (IBAction)btnDonePressed:(id)sender;

@end
