//
//  Help.h
//  AIS
//
//  Created by System Administrator on 11/23/11.
//  Copyright 2011 koenxcell. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Help : UIViewController <UIWebViewDelegate>{
        
    IBOutlet UIScrollView *scrollV;
    int indexCount;
    NSMutableArray *txtVAry;
    
    UIFont *font;
     
}
-(void)loadDocument:(NSString*)documentName inView:(UIWebView*)webView;

-(void)addTextViewWithText:(NSString*)text;
-(void)addImageViewWithImage:(UIImage*)image;
@end
