//
//  ParticipantTypeViewController.h
//  TLISC
//
//  Created by KPIteng on 4/30/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NewParticipentController.h"
#import "ImportParticipants.h"
#import "GlobleClass.h"
@interface ParticipantTypeViewController : UIViewController{
    
    ImportParticipants *objImportParticipants;
    NewParticipentController *objNewParticipentController;
    
    IBOutlet UILabel *lblUnitName,*lblUnitInfo,*lblIconName;
    IBOutlet UIImageView *ivIcon;
    
    AppDelegate *appDel;
    
    //---TopBar Selected
    IBOutlet UIImageView *ivTopBarSelected;
}
- (IBAction)btnNewParticipantTapped:(id)sender;
- (IBAction)btnExistingParticipantTapped:(id)sender;
- (IBAction)btnBackTapped:(id)sender;
@end
