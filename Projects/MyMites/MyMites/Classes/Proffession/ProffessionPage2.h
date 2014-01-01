//
//  ProffessionPage2.h
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProffessionPage2 : UIViewController<UITextFieldDelegate,UITextViewDelegate>
{
    //Json
    NSMutableData *responseData;
    NSString *responseString;
    NSDictionary *results;
    NSURLConnection *ConnectionRequest;
    NSMutableArray *ArryOccupation;
    

    // IBOutlet Declaration
    IBOutlet UITextField *tfExp,*tfEmail,*tfWebSite;
    
    NSDictionary *d;
}
@property(nonatomic,strong)NSString *tfBussName;
@property(nonatomic,strong)NSString *tfBussCategory;
@property(nonatomic,strong)NSString *occupationField;
@property(nonatomic,strong)NSString *txtDesc;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andD:(NSDictionary*)dVal;
-(IBAction)SaveClicked:(id)sender;
-(void)activityRunning;
@end
