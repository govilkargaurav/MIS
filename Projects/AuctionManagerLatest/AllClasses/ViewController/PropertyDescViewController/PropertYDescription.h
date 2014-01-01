//
//  PropertYDescription.h
//  PropertyInspector
//
//  Created by apple on 10/26/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdaePropertyModel.h"
@interface PropertYDescription : UIViewController
{
    
    IBOutlet UIButton *noBidButton;
    IBOutlet UIButton *bidButton;
    IBOutlet UIButton *wonButton;
    IBOutlet UIButton *lossButton;
    IBOutlet UIButton *maxBid;
    IBOutlet UILabel *criedBy;
    IBOutlet UILabel *wonPrice;
    IBOutlet UILabel *loanDate;
    IBOutlet UILabel *loanAmount;
}
@property(nonatomic,strong)NSString *propertyID;
@property (nonatomic,strong)IBOutlet UILabel *AddressLable;
@property (nonatomic,strong)IBOutlet UILabel *cityState;
@property (nonatomic,strong)IBOutlet UILabel *legalDescription;
@property (nonatomic,strong)IBOutlet UILabel *borrowerLastNameFirstName;
@property (nonatomic,strong)IBOutlet UILabel *fileNo;
@property (nonatomic,strong)IBOutlet UILabel *auctionDate;
@property (nonatomic,strong)IBOutlet UILabel *openingBid;
@property (nonatomic,strong)IBOutlet UILabel *trusteeNo;

@end
