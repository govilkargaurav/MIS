//
//  SettingsViewController.h
//  NewsStand
//
//  Created by openxcell technolabs on 4/17/13.
//  Copyright (c) 2013 fgbfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AppConstat.h"
#import "SLPickerView.h"
#import "NSString+Valid.h"

@interface SettingsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource,UIPopoverControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    
    //edition
    IBOutlet UIButton *btnEdition;
    IBOutlet UILabel *lblEdition;
    IBOutlet UIImageView *imgEdition;
    NSMutableArray *arrEdition;
    
    //Zone
    IBOutlet UIButton *btnZone;
    IBOutlet UILabel *lblZone;
    IBOutlet UIImageView *imgZone;
    NSMutableArray *arrZone;
    
    //Ad
    IBOutlet UIButton *btnOnOff;
    IBOutlet UIImageView *imgAd;
    IBOutlet UILabel *lblAd;
    
    //Push Notification
    IBOutlet UIButton *btnPushOnOff;
    IBOutlet UIImageView *imgPush;
    IBOutlet UILabel *lblPush;
    
    IBOutlet UIButton *btnDone;
    IBOutlet UIImageView *imgSep,*imgSep1;
    
    IBOutlet UIImageView *imgBg;
    IBOutlet UIImageView *imgHeader;
    
    IBOutlet UILabel *lblEditionTitle,*lblZoneTitle;
    NSString *strEditionIdFinal,*strZoneIdFinal;
    NSString *strEditionNameFinal,*strZoneNameFinal;
    
    // Single Selection Picker
    SLPickerView *_pickerView;
    NSMutableArray *_pickerData;
    
    NSInteger _currentPick;
    
    NSString *strType;
    
    UIPopoverController *popoverController;
    
    int EditionIndex,ZoneIndex;
    
    UIButton *btnFrame;
    
    IBOutlet UIView *viewBack;
    
    int flagOrientation;
}
@property(nonatomic,strong)UIPopoverController *popoverController;


//Push Notification
-(IBAction)ClickedBtnPushOnOff:(id)sender;

//AdMob
-(IBAction)ClickedBtnAdMobOnOff:(id)sender;

-(void)CallWebServices;


@end
