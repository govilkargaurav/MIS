//
//  ViewController.m
//  SkyyApp
//
//  Created by Vishal Jani on 9/6/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [_scrollview setContentSize:CGSizeMake(320,728)];
    self.title=@"Privacy Policy";
    //[self scrollViewHeightSetting];
  //  [txtView set]
    // Do any additional setup after loading the view from its nib.
}
-(void)scrollViewHeightSetting{
    [_scrollview setDelegate:self];
    [_scrollview setFrame:CGRectMake(0, 65, 320, self.view.frame.size.height-68)];
    [_scrollview setIsAccessibilityElement:YES];
    [_scrollview setScrollEnabled:YES];
    [_scrollview setContentSize:CGSizeMake(320, 728)];
    
    // [_scrollView set]

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
