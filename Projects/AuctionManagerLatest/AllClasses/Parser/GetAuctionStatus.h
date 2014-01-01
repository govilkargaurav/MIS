//
//  GetAuctionStatus.h
//  PropertyInspector
//
//  Created by apple on 11/9/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetAuctionStatusModel.h"

@interface GetAuctionStatus : UIViewController<NSXMLParserDelegate>
{
    NSXMLParser *parser;
    int requestType;
    NSString *mCurrentTagName;
    NSMutableString *mCurrentTagValue;
    //GetVersionModel *versionModel;
    
}
@property(nonatomic,retain)GetAuctionStatusModel *versionModel;
@property(nonatomic,copy)	NSString *mCurrentTagName;
@property(nonatomic,retain)NSMutableString *mCurrentTagValue;
- (void)parseData:(NSData*)rawData :(int)reqType;

@end
