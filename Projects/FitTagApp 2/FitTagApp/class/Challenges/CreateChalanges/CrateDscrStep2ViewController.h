//
//  CrateDscrStep2ViewController.h
//  FitTagApp
//
//  Created by apple on 2/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIInputToolbar.h"
#import "CreateChaalengeModel.h"
#import "addEquipmentViewController.h"
#import "AppDelegate.h"
#import "GCPlaceholderTextView.h"

@interface CrateDscrStep2ViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,addEquipmentInStepSecondView,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIInputToolbarDelegate>{
    NSMutableData *vedioData;
    
    PFObject *activitie;
    UIInputToolbar *inputToolbar;
    @private
    BOOL keyboardIsVisible;
    
    // Grid View varibles and controllers
    IBOutlet UITableView *tblViewChallengeStep;
    
    // Custom Grid view for adding multiple steps
    IBOutlet UITableViewCell *customTableCell;
    
    IBOutlet UIButton *btnNext;
    IBOutlet UIButton *btnDelete1,*btnDelete2,*btnDelete3,*btnDelete4;
    IBOutlet UIButton *btnprofile1,*btnprofile2,*btnprofile3,*btnprofile4;
    
    IBOutlet UIImageView *imageBG1,*imageBG2,*imageBG3,*imageBG4;
    IBOutlet UIImageView *imageView1,*imageView2,*imageView3,*imageView4;
    IBOutlet UILabel *nameLabel1,*nameLabel2,*nameLabel3,*nameLabel4;
    
    NSMutableArray *mutArrChaalengeSteps;
    NSMutableDictionary *dictData;
    UIImagePickerController *imgPickerController;
    int clickedIndex,addDeleteButtonAt;
    NSMutableArray *_arrayImageData;
    
    AppDelegate *appdelegateRefrence;
    
    // step image
    IBOutlet UIView *imgDisplayView,*textAddView;
    IBOutlet UIImageView *imgViewStep;
    IBOutlet GCPlaceholderTextView *txtViewAddText;

    IBOutlet UITextView *txtViewComment;
    int textIndexInSteps;
    BOOL isDraftChallenge;
    
}
@property (nonatomic, strong) UIInputToolbar *inputToolbar;
@property(nonatomic,strong)CreateChaalengeModel *objCreateChallengeModel;
@property (strong, nonatomic) IBOutlet UIButton *btnImageFromLibrary;
@property(nonatomic,strong)PFObject *PFObjDraftChallenge;

- (IBAction)btnStep1Pressed:(id)sender;
- (IBAction)btnEquipmentPressed:(id)sender;
- (IBAction)btnDescriptionPressed:(id)sender;
- (IBAction)btnNextPressed:(id)sender;

-(void)opeImagePickerConntroller;
-(void)uploadImageOnServer;
-(void)uploadImage:(NSData *)teaserImageDate TeaserVedio:(NSData *)teaserVediaDate;
-(void)getChallengeDraftsImagesAndOtherData;

// Grid view methods

-(NSString *)removeNull:(NSString *)str;
-(void)profileViewButtonClick:(id)sender;
-(void)deleteImage:(id)sender;
-(void)saveChallengeAsDraft;

-(IBAction)btnRemoveAnimatedView:(id)sender;
-(IBAction)btnRemoveAnimatedViewForAddText:(id)sender;
-(IBAction)btnCancelViewForAddText:(id)sender;

@end
