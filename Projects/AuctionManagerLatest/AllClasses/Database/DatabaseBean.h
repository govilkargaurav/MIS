//
//  DatabaseBean.h
//  Coloplast iPAD
//
//  Created by freedom passion on 29/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatabaseBean : UIViewController{
    
    NSString *propertyID;
    NSString *addressStr;
    NSString *cityStr;
    NSString *zipStr;
    NSString *stateStr;
    NSString *latitudeStr;
    NSString *longitudeStr;
    NSString *borrowerFirstName;
    NSString *borrowerName;
    NSString *trusteeFirstNameStr;
    NSString *truseeId;
    NSString *bidderlastName;
    NSString *bidderFirstName;
    NSString *biddermiddleName;
    NSString *maxBidStr;
    NSString *openingbidStr;
    NSString *statusStr;
    NSString *updatedbyStr;
    NSString *updatedateStr;
    NSString *bidderidStr;
    NSString *wonpriceStr;
    NSString *AuctionId;
    NSString *AuctionDateTime;
    NSString *AuctionNote;
    NSString *legalDescription;
    NSString *countyID;
    NSString *auctionNumber;
    NSString *crierName;
    NSString *settleStatus;
    NSString *loanDate;
    NSString *loanAmount;
    NSString *checkNumber;
    NSString *checkAmount;
}
@property(nonatomic,retain)NSString *checkAmount;
@property(nonatomic,retain)NSString *checkNumber;
@property(nonatomic,retain)NSString *loanDate;
@property(nonatomic,retain)NSString *loanAmount;
@property(nonatomic,retain)NSString *settleStatus;
@property(nonatomic,retain)NSString *crierName;
@property(nonatomic,retain)NSString *auctionNumber;
@property(nonatomic,retain)NSString *countyID;
@property(nonatomic,retain)NSString *legalDescription;
@property(nonatomic,retain)NSString *borrowerName;
@property(nonatomic,retain)NSString *propertyID;
@property(nonatomic,retain)NSString *addressStr;
@property(nonatomic,retain)NSString *cityStr;
@property(nonatomic,retain)NSString *zipStr;
@property(nonatomic,retain)NSString *stateStr;
@property(nonatomic,retain)NSString *latitudeStr;
@property(nonatomic,retain)NSString *longitudeStr;
@property(nonatomic,retain)NSString *borrowerFirstName;
@property(nonatomic,retain)NSString *AuctionId;
@property(nonatomic,retain)NSString *AuctionDateTime;
@property(nonatomic,retain)NSString *AuctionNote;
@property(nonatomic,retain)NSString *truseeId;
@property(nonatomic,retain)NSString *trusteeFirstNameStr;
@property(nonatomic,retain)NSString *bidderlastName;
@property(nonatomic,retain)NSString *bidderFirstName;
@property(nonatomic,retain)NSString *biddermiddleName;
@property(nonatomic,retain)NSString *maxBidStr;
@property(nonatomic,retain)NSString *openingbidStr;
@property(nonatomic,retain)NSString *statusStr;
@property(nonatomic,retain)NSString *updatedbyStr;
@property(nonatomic,retain)NSString *updatedateStr;
@property(nonatomic,retain)NSString *bidderidStr;
@property(nonatomic,retain)NSString *wonpriceStr;


@end
