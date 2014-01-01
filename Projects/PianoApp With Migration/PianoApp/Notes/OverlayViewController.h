//
//  OverlayViewController.h
//  TableView
//
//  Created by iPhone SDK Articles on 1/17/09.
//  Copyright www.iPhoneSDKArticles.com 2009. 
//

#import <UIKit/UIKit.h>

@class NotesViewCtr;
@class PasswordsViewctr;
@class ContactsViewCtr;
@class CameraRollViewCtr;

@interface OverlayViewController : UIViewController {

	NotesViewCtr *rvController;
    PasswordsViewctr *rvController1;
    ContactsViewCtr *rvController2;
    CameraRollViewCtr *rvController3;
}

@property (nonatomic, strong) NotesViewCtr *rvController;
@property (nonatomic, strong) PasswordsViewctr *rvController1;
@property (nonatomic, strong) ContactsViewCtr *rvController2;
@property (nonatomic, strong) CameraRollViewCtr *rvController3;

@end
