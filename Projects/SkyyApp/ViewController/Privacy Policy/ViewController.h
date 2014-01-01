//
//  ViewController.h
//  SkyyApp
//
//  Created by Vishal Jani on 9/6/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIScrollViewDelegate>{

    IBOutlet UITextView *txtView;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@end
