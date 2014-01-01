//
//  Gallery.h
//  MyMite
//
//  Created by Vivek Rajput on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "UIImage+Resize.h"

@class ASIFormDataRequest;

@interface Gallery : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ASIHTTPRequestDelegate>
{
    IBOutlet UIImageView *imgupload,*imgBack;
    IBOutlet UITextView *txtImgDesc;
    ASIFormDataRequest *request;
    NSData *imgdata;
    
    UIToolbar *toolBar;
    //Json
    NSMutableData *responseData;
    NSString *responseString;
    NSDictionary *resultsGallery;
    NSURLConnection *ConnectionRequest;
    NSString *strSet;
}
@property (retain, nonatomic) ASIFormDataRequest *request;
-(IBAction)uploadClicked:(id)sender;
-(void)CallURL;
@end
