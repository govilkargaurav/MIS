//
//  AboutViewController.h
//  FitTag
//
//  Created by Vishal Jani on 5/14/13.
//
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController{
    IBOutlet UIImageView *FittageIcone;
    IBOutlet UILabel *lblVersion;
    IBOutlet UITextView *txtViewWelcomeTextDescription;
}
- (IBAction)btnReviewAppStorePressed:(id)sender;
- (IBAction)btnFollowOnTwitterPressed:(id)sender;
- (IBAction)btnLikeOnFacebookPressed:(id)sender;


@end
