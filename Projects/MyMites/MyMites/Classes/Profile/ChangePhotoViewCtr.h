//
//  ChangePhotoViewCtr.h
//  MyMites
//
//  Created by Apple-Openxcell on 9/26/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@class ASIFormDataRequest;
@interface ChangePhotoViewCtr : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ASIHTTPRequestDelegate>
{
    IBOutlet UIImageView *imgProfile;
    NSString *strProfileLink;
    ASIFormDataRequest *request;
    NSData *imgdata;
}
@property (nonatomic,strong)NSString *strProfileLink;
@property (retain, nonatomic) ASIFormDataRequest *request;
@end
