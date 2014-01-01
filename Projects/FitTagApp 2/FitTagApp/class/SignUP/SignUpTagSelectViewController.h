//
//  SignUpTagSelectViewController.h
//  FitTagApp
//
//  Created by apple on 2/26/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"
#import "MBProgressHUD.h"

@interface SignUpTagSelectViewController : UIViewController{
    MBProgressHUD *HUD;
    
    // Variabls for Event tags search and suggest firends according to Tag matches
    NSMutableArray *mutArrAllEventTag,*arrSearchDisplay;
    __block NSMutableArray *mutArrEventTagResponse;
    NSMutableArray *mutArrSuggestedFriends;
    
}

@property (strong, nonatomic) IBOutlet GCPlaceholderTextView *txtViewTags;
@property (strong, nonatomic) IBOutlet UITableView *tblTags;

-(void)showHUD;
-(void)hideHUD;
-(void)setUserTags;

@end
