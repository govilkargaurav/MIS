//
//  addEquipmentViewController.h
//  FitTag
//
//  Created by Shivam on 3/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol addEquipmentInStepSecondView <NSObject>

-(void)sendEquipmentListToParentView:(NSMutableArray *)mutArrEqpList;
-(void)deleteEquipmentFromModelClass:(NSString *)equpmentName;

@end

@interface addEquipmentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>{
    NSMutableArray *mutArrEquipmentList;
    UITextField *txtfldEquipment;
}
@property(strong, nonatomic) IBOutlet UITableView *tblViewEquipmen;
@property(nonatomic,retain)id <addEquipmentInStepSecondView> delegate;
@property(nonatomic,strong)NSMutableArray *mutArrPreviouseAddedEquipment;

-(void)addQeuipmentInTableView;
-(void)doneButtonPressed:(id)sender;
@end
