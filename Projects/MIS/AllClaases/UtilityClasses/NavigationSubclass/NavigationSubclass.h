//
//  NavigationSubclass.h
//  MinutesInSeconds
//
//  Created by ChintaN on 7/31/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationSubclass : UIView

- (id)initWithFrame:(CGRect)frame navigationTitleName:(NSString *)strTitle;
@property(nonatomic,strong)UIButton *btnSearchView;
-(void)searchBtnClicked:(id)sender;
-(void)AddMeetingBtnClicked:(id)sender;
@end
