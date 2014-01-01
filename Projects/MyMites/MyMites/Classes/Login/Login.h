//
//  Login.h
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "FsenetAppDelegate.h"
#import "FbGraph.h"

@interface Login : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,UIWebViewDelegate>
{
    IBOutlet UITextField *tfUsername,*tfPassword;
    IBOutlet UIButton *btnCancel;
    //Json
    NSMutableData *responseData;
    NSString *responseString;
    NSDictionary *results;
    NSURLConnection *ConnectionRequest;
    
    NSString *strSetHideCancelbtn,*strMessageTitle;
    
    //FaceBook Login
    FbGraph *fbGraph;
    NSDictionary *resultfb;
    
    IBOutlet UILabel *lblMessage;
    
}
@property (nonatomic, strong) FbGraph *fbGraph;
@property(nonatomic,strong)NSString *strSetHideCancelbtn,*strMessageTitle;
-(IBAction)CancelCliked:(id)sender;
-(IBAction)LoginCliked:(id)sender;
- (void)fbGraphCallback;
-(void)CallURL:(NSString *)loginstr;
@end
