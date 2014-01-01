//
//  ReferMatesViewCtr.h
//  MyMites
//
//  Created by apple on 11/24/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReferMatesViewCtr : UIViewController
{
    IBOutlet UITextField *tfName,*tfEmail;
    
#pragma mark - JSON Parsing
    
    NSMutableData *responseData;
    NSString *responseString;
    NSURLConnection *ConnectionRequest;
}
@end
