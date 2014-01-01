//
//  PhotoScrollViewCtr.h
//  MyMites
//
//  Created by Apple-Openxcell on 9/27/12.
//  Copyright (c) 2012 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScrollViewCtr : UIViewController <UIScrollViewDelegate,UIWebViewDelegate>
{
    IBOutlet UIScrollView *scl_Photo;
    NSUInteger indexclick;
    IBOutlet UILabel *lblTitle;
    UIWebView *webview;
    BOOL HideShow;
    NSDictionary *DicPhoto;
    UITextView *txtDesc;
    
    //Json
    NSMutableData *responseData;
    NSString *responseString;
    NSURLConnection *ConnectionRequest;
}
@property(nonatomic,readwrite)NSUInteger indexclick;
@property(nonatomic,strong) NSDictionary *DicPhoto;
- (void)layoutScrollImages;
-(void)CallCountImg;
-(void)ReloadAllView;
-(void)activityRunning;
-(void)GetAllPhoto;
-(void)CallURL;
@end
