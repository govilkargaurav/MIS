//
//  StateTableCellView.m
//  States
//
//  Created by Julio Barros on 1/26/09.
//  Copyright 2009 E-String Technologies, Inc.. All rights reserved.
//

#import "CustomCell.h"


@implementation CustomCell

@synthesize detailLabl,nameLbl,titleLbl;

@synthesize dsiclouserbutton1;
@synthesize lblDate;
@synthesize lblLegalDescription;
@synthesize AddressLable;
@synthesize cityState;
@synthesize legalDescription;
@synthesize borrowerLastNameFirstName;
@synthesize fileNo;
@synthesize auctionDate;
@synthesize openingBid;
@synthesize trusteeNo;
@synthesize checkAmountLbl;
@synthesize chequeNumberLbl;
@synthesize removeButton;
@synthesize trusteeName;
@synthesize bidStatus;
@synthesize recieptImage;
@synthesize checkImage;
@synthesize auctionLable;
@synthesize statusLable;
@synthesize totalAmount;
@synthesize totalNumber;
@synthesize realStatus;
@synthesize titleStatus;
@synthesize cellTextField;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
