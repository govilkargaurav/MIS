//
//  AutoCompletionViewController.h
//  Suvi
//
//  Created by Gagan Mishra on 2/25/13.
//
//

#import <UIKit/UIKit.h>

@interface AutoCompletionViewController : UIViewController <UITextFieldDelegate>
{
    UITextField *txtsearchname;
    UIButton *btnDropDownMask;
    NSMutableArray *arrsuggestion;
}

@end
