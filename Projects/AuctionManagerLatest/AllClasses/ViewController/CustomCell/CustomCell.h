//
//  StateTableCellView.h
//  States
//
//  Created by Julio Barros on 1/26/09.
//  Copyright 2009 E-String Technologies, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCell : UITableViewCell {
    
	IBOutlet UILabel *titleLbl;
    IBOutlet UILabel *detailLabl;
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *auctionLable;
    
    
    
}
@property(nonatomic,strong)IBOutlet UILabel *lblDate;
@property(nonatomic,strong)IBOutlet UILabel *lblLegalDescription;
@property(nonatomic,strong)UILabel *auctionLable;
@property(nonatomic,strong)IBOutlet UIImageView *recieptImage;
@property(nonatomic,strong)IBOutlet UIImageView *checkImage;

@property(nonatomic,strong)IBOutlet UILabel *bidStatus;
@property(nonatomic,strong)IBOutlet UILabel *trusteeName;
@property(nonatomic,strong)IBOutlet UIButton *removeButton;
@property(nonatomic,strong)IBOutlet UIButton *dsiclouserbutton1;

@property(nonatomic,strong)IBOutlet UILabel *checkAmountLbl;
@property(nonatomic,strong)IBOutlet UILabel *chequeNumberLbl;

@property (nonatomic,strong)IBOutlet UILabel *AddressLable;
@property (nonatomic,strong)IBOutlet UILabel *cityState;
@property (nonatomic,strong)IBOutlet UILabel *legalDescription;
@property (nonatomic,strong)IBOutlet UILabel *borrowerLastNameFirstName;
@property (nonatomic,strong)IBOutlet UILabel *fileNo;
@property (nonatomic,strong)IBOutlet UILabel *auctionDate;
@property (nonatomic,strong)IBOutlet UILabel *openingBid;
@property (nonatomic,strong)IBOutlet UILabel *trusteeNo;

@property (nonatomic,strong)IBOutlet UILabel *detailLabl;
@property (nonatomic,strong)IBOutlet UILabel *nameLbl;
@property (nonatomic,strong) IBOutlet UILabel *titleLbl;

@property(nonatomic,strong)IBOutlet UILabel *statusLable;
@property(nonatomic,strong)IBOutlet UILabel *totalAmount;
@property(nonatomic,strong)IBOutlet UILabel *totalNumber;
@property(nonatomic,strong)IBOutlet UILabel *realStatus;

@property(nonatomic,strong)IBOutlet UILabel *titleStatus;
@property(nonatomic,strong)IBOutlet UITextField *cellTextField;




@end
