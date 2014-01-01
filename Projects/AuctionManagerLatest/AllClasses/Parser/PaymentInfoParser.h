//
//  PaymentInfoParser.h
//  PropertyInspector
//
//  Created by apple on 10/31/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentInfoModel.h"
@interface PaymentInfoParser : UIViewController<NSXMLParserDelegate>
{
    NSXMLParser *parser;
    int requestType;
    NSString *mCurrentTagName;
    NSMutableString *mCurrentTagValue;
    //GetVersionModel *versionModel;
    
}
@property(nonatomic,retain)PaymentInfoModel *versionModel;
@property(nonatomic,copy)	NSString *mCurrentTagName;
@property(nonatomic,retain)NSMutableString *mCurrentTagValue;
- (void)parseData:(NSData*)rawData :(int)reqType;

@end
