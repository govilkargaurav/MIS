//
//  CreateChlng1ViewController.h
//  FitTagApp
//
//  Created by apple on 2/19/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"
#import <Parse/Parse.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMEdia.h>
#import <CoreMedia/CoreMedia.h>
#import "AddLocationView.h"
#import "CreateChaalengeModel.h"
@interface CreateChlng1ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,setLocation,UITableViewDataSource,UITableViewDelegate>{
    PFObject *activitie;
    NSData *vedioData;
    
    UIImage *selectedImage;
    IBOutlet UIButton *btnTeaser;
    CreateChaalengeModel *objCreateChallengeModel;
    IBOutlet UILabel *lblTextCount;
    
    // Controls and variables for show #Tags
    NSMutableArray *mutArrAllTags,*mutArrSearchedTAgs,*mutArrEventTagResponse;
    UITableView *tblViewHashTags;
    UIView *popOverViewHasTags;
    
    UIImage *thumbnail;
    IBOutlet UIImageView *tempImageView;
}

@property (strong, nonatomic) IBOutlet UILabel *lblLocation;

@property (strong, nonatomic) IBOutlet UITextField *txtFieldChanlangeName;
@property (strong, nonatomic) IBOutlet GCPlaceholderTextView *txtViewTags;
@property (strong, nonatomic) IBOutlet UIButton *btnLocation;
@property(nonatomic,strong)NSMutableArray *mutArrDraftChallenge;
@property(nonatomic,assign)int buttonIndex;

-(IBAction)btnAddTeaserPressed:(id)sender;
-(IBAction)btnNextPressed:(id)sender;
-(void)uploadImage:(NSData *)imageData;
-(BOOL)validationForCreateChallenge;
-(IBAction)locationSwitchValueChange:(id)sender;
-(NSString *)removeNull:(NSString *)str;
-(void)getAllHashTags;
-(UIImage *)scaleAndRotateImage:(UIImage *)image;

@end
