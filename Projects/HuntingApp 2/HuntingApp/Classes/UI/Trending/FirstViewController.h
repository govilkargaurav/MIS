//
//  FirstViewController.h
//  HuntingApp
//
//  Created by Habib Ali on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstScreen;
@protocol FirstScreenModelViewDelegate <NSObject>

- (void)dismissModalView:(id)sender;
@end


@interface FirstViewController : UIViewController
{
    UIButton *infoBtn;
    BOOL hasShownFirstView;
    UIView *titleView;
}
@property(nonatomic,assign) id<FirstScreenModelViewDelegate> delegate;
@property (nonatomic, retain) FirstScreen *firstScreen;

- (IBAction)selectGallery:(id)sender;
- (IBAction)showFirstScreen:(id)sender;
- (void)dismissMyView:(id)sender;
@end
