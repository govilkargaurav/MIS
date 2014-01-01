//
//  ChangePassword.h
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"

@interface ChangePassword : UIViewController<UITextFieldDelegate>
{
    IBOutlet UILabel *lblEmailId;
    IBOutlet UITextField *tfOldPass,*tfNewPass,*tfRePass;
    NSUserDefaults *Info;
    //Json
    NSMutableData *responseData;
    NSString *responseString;
    NSDictionary *results;
    NSURLConnection *ConnectionRequest;
}
-(IBAction)Back:(id)sender;
@end
