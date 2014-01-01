//
//  SubNoteViewController.h
//  SkyyApp
//
//  Created by Vishal Jani on 9/10/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//
@protocol sendSubNoteDelegate <NSObject>

-(void)sendSubnote :(NSString *)subNote selectIndex:(NSInteger )index;
-(void)sendEditSubnote :(NSString *)subNote selectIndex:(NSInteger )index;

-(void)cancelSubNote;
@end
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SubNoteViewController : UIViewController<UITextViewDelegate,UIGestureRecognizerDelegate>{
    IBOutlet UIButton *btnSend;
    IBOutlet UITextView *txtSubNoteView;
    CGFloat animatedDistance;
    
    IBOutlet UIView *newView;
    
    IBOutlet UILabel *lblTextCount;
    IBOutlet UIButton *btnCancel;
    
    
    CAGradientLayer* _gradientLayer;
	CGPoint _originalCenter;
	BOOL _deleteOnDragRelease;
	CALayer *_itemCompleteLayer;
	BOOL _markCompleteOnDragRelease;
	UILabel *_tickLabel;
	UILabel *_crossLabel;
}
@property(nonatomic,retain)id<sendSubNoteDelegate>delegate;
@property(nonatomic)NSInteger index;
@property(nonatomic)BOOL isEditSubNote;
@property(nonatomic,retain)NSString *strSubNote;
@end
