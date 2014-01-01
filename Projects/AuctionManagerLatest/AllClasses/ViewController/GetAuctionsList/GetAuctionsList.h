//
//  GetAuctionsList.h
//  PropertyInspector
//
//  Created by apple on 10/22/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetAuctionsList : UIViewController{
    
    NSInteger selectedIndex;
    NSIndexPath *rowPath;
    NSString *propID;
    NSString *auctID;
    NSString *WONPRIZE;
    IBOutlet UITextField *searchTwo;
    IBOutlet UIButton *cancleSearchButtonOne;
    IBOutlet UIButton *cancleSearchButtonTwo;
    UIButton *doneButton;
    BOOL phoneTagOrNot;
    
    NSMutableDictionary *propertyID_Dict;
    NSMutableArray *propertyID_Arr;
    
    IBOutlet UIBarButtonItem *statusBar;
    
    
    IBOutlet UIView *globalSearchView;
    IBOutlet UIButton *globalSearchCancleButton;
    IBOutlet UITextField *_globalSearchTextField;
    
    NSString *trusteeIDBadExcess;
    
    IBOutlet UIBarButtonItem *searchGlobal;
    
    int search1,search2,search3,search4,search5,search6,search7;
    BOOL keyboardBOOL;
    
    BOOL identfyKeyBoard;
    
}
@property(nonatomic,strong)NSMutableArray *propertyIDARR;
@property(nonatomic,strong)NSString *countyID;

@end
