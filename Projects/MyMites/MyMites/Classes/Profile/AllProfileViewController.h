//
//  AllProfileViewController.h
//  MyMites
//
//  Created by apple on 9/13/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AllProfileViewController : UIViewController <MFMailComposeViewControllerDelegate>
{    
    IBOutlet UILabel *lblFname,*lblFnameHeading;
    IBOutlet UILabel *lblLname,*lblLnameHeading;
    IBOutlet UILabel *lblEmail,*lblEmailHeading;
    IBOutlet UILabel *lblAddress,*lblAddressHeading;
    IBOutlet UILabel *lblOccupation,*lblOccupationHeading;
    IBOutlet UILabel *lblMobileNo,*lblMobileNoHeading;
    IBOutlet UILabel *lblPhoneno,*lblPhonenoHeading;
    IBOutlet UILabel *lblCoveringArea,*lblCoveringAreaHeading;

    IBOutlet UIImageView *imgProfile;
    IBOutlet UIScrollView *scrlUserProfile;
    IBOutlet UIButton *btnEmail,*btnMobile,*btnPhone;
    int y;
    
#pragma mark - JSON Parsing
    
    NSMutableData *responseData;
    NSString *responseString;
    NSMutableDictionary *results;
    NSURLConnection *ConnectionRequest;
    
    NSString *strConnHidden;
    
}
@property(nonatomic,retain)NSMutableDictionary *statuses;
@property(nonatomic,strong)NSURLRequest *requestMain;
@property(nonatomic,strong)IBOutlet UIButton *connectBtn;
@property(nonatomic,strong)NSString *connectedMes;
@property(nonatomic,strong)NSString *strConnHidden;
-(void)busyAgent;
-(IBAction)connectProfile:(id)sender;
-(CGSize)text:(NSString*)strTextContent;
-(NSString *)strGetAppendedstring:(NSString*)strFinal forappend:(NSString*)appendstr;
- (NSString *)removeNull:(NSString *)str;
@end
