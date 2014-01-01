//
//  OverlayViewController.m
//  TableView
//
//  Created by iPhone SDK Articles on 1/17/09.
//  Copyright www.iPhoneSDKArticles.com 2009. 
//

#import "OverlayViewController.h"
#import "NotesViewCtr.h"
#import "PasswordsViewctr.h"
#import "ContactsViewCtr.h"
#import "CameraRollViewCtr.h"

@implementation OverlayViewController

@synthesize rvController;
@synthesize rvController1;
@synthesize rvController2;
@synthesize rvController3;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[rvController doneSearching_Clicked];
    [rvController1 doneSearching_Clicked];
    [rvController2 doneSearching_Clicked];
    [rvController3 doneSearching_Clicked];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}




@end
