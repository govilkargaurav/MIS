//
//  ViewProfileViewCtr.h
//  MyMites
//
//  Created by Apple-Openxcell on 9/5/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ViewProfileViewCtr : UIViewController <MFMailComposeViewControllerDelegate>
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
    IBOutlet UIScrollView *scrlFullDetail;
    IBOutlet UIButton *btnChangePhoto,*btnEditProfile;
    IBOutlet UIButton *btnEmail,*btnMobile,*btnPhone;
    int y;
    
#pragma mark - JSON Parsing
    
    NSMutableData *responseData;
    NSString *responseString;
    NSDictionary *DicResults;
    NSURLConnection *ConnectionRequest;
}
-(void)CallURL;
-(CGSize)text:(NSString*)strTextContent;
-(NSString *)strGetAppendedstring:(NSString*)strFinal forappend:(NSString*)appendstr;
- (NSString *)removeNull:(NSString *)str;
@end
