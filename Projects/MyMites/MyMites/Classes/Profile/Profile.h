//
//  Profile.h
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Profile : UIViewController
{
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblEmail;
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblOccupation;
    IBOutlet UIImageView *imgProfile;
    
#pragma mark - JSON Parsing
    
    NSMutableData *responseData;
    NSString *responseString;
    NSDictionary *results;
    NSURLConnection *ConnectionRequest;
}
-(void)CallURL;
@end
