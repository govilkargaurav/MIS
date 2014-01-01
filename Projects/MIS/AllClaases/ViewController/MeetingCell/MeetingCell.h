//
//  MeetingCell.h
//  MinutesInSeconds
//
//  Created by ChintaN on 7/29/13.
//  Copyright (c) 2013 openxcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingCell : UIViewController
{
    int indexpathrow;
}
@property(nonatomic,strong)IBOutlet UIButton *btnNote;
@property(nonatomic,strong)IBOutlet UIButton *btnMic;
@property(nonatomic,strong)IBOutlet UIButton *btnMail;
@property(nonatomic,strong)IBOutlet UIButton *btnDelete;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil indexpath:(int)indextpathRow;
@end