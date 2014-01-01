//
//  TrashViewController.h
//  SkyyApp
//
//  Created by Vishal Jani on 9/4/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SHCTableViewCellDelegate.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "SubNoteViewController.h"
#import "AddMoteViewController.h"
@interface TrashViewController : UIViewController<SHCTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource,sendSubNoteDelegate,UIGestureRecognizerDelegate,swipeToSave>{
    AppDelegate *appDelegate;
    IBOutlet UITableView *tblTrash;
    NSMutableArray *arrAllTrash;
    
    UITableView *subNotsTable;
    UILabel*    lblUserName;
    EGOImageView* userProfileImage;
    UIView *sbView;
    
    PFObject *objEditNote;
    PFObject *objEditSubNote;
    
    
    CAGradientLayer* _gradientLayer;
	CGPoint _originalCenter;
	BOOL _deleteOnDragRelease;
	CALayer *_itemCompleteLayer;
	BOOL _markCompleteOnDragRelease;
    
}

@end
