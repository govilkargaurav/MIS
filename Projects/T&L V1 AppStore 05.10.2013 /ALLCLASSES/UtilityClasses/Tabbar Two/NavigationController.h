//
//  NavigationController.h
//  T&L
//
//  Created by openxcell tech.. on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationController : UIViewController
@property (nonatomic,strong)IBOutlet UIButton *btn1;
@property (nonatomic,strong)IBOutlet UIButton *btn2;
@property (nonatomic,strong)IBOutlet UIButton *btn3;
@property (nonatomic,strong)IBOutlet UILabel  *lbl1;
@property (nonatomic,strong)IBOutlet UILabel  *lbl2;

- (void) setFocusButton:(int) btnIndex;
@end
