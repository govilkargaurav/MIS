//
//  AuctionStatusController.h
//  PropertyInspector
//
//  Created by apple on 11/8/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuctionStatusController : UIViewController

{
    
    NSMutableArray *typeArray;
    NSMutableArray *statusArray;
    NSMutableArray *statusSendingArray;
    
}
@property(nonatomic,strong)NSMutableArray *typeArray;
@property(nonatomic,strong)NSMutableArray *statusArray;
@end
