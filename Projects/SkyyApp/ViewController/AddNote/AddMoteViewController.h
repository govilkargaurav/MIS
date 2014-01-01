//
//  AddMoteViewController.h
//  SkyyApp
//
//  Created by Vishal Jani on 9/5/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//
#import <Parse/Parse.h>
@protocol swipeToSave <NSObject>

-(void)swipwToSaveNote :(NSString *)note;
-(void)swipwToEditNote :(NSString *)note;
-(void)swipeToRightToSaveOnlyHome :(NSString *)note;
-(void)cancelSendNote;
-(void)setNotification;
@end

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GlobalClass.h"
@interface AddMoteViewController : UIViewController<UIGestureRecognizerDelegate>
{

    CAGradientLayer* _gradientLayer;
	CGPoint _originalCenter;
	BOOL _deleteOnDragRelease;
	CALayer *_itemCompleteLayer;
	BOOL _markCompleteOnDragRelease;
	UILabel *_tickLabel;
	UILabel *_crossLabel;
    
    IBOutlet UIButton *btnSave;
      IBOutlet UIButton *btnClose;
    IBOutlet UITextView *txtNoteView;
    CGFloat animatedDistance;
    IBOutlet UIView *newView;
    IBOutlet UILabel *lblTextCount;
}

-(IBAction) setNotificationValue:(id)sender;
@property(nonatomic,retain)id<swipeToSave> delegate;
@property (nonatomic)BOOL isEdit;
@property (nonatomic)NSString *strEdit;
@end
