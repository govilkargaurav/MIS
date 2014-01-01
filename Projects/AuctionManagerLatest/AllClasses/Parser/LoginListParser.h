//
//  LoginListParser.h
//  PropertyInspector
//
//  Created by apple on 10/15/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"
@interface LoginListParser : UIViewController<NSXMLParserDelegate>
{
    NSXMLParser *parser;
    int requestType;
    NSString *mCurrentTagName;
    NSMutableString *mCurrentTagValue;
    LoginModel *tagMdlObj;
    
}
@property(nonatomic,retain)LoginModel *tagMdlObj;
@property(nonatomic,copy)	NSString *mCurrentTagName;
@property(nonatomic,retain)NSMutableString *mCurrentTagValue;
- (void)parseData:(NSData*)rawData :(int)reqType;


@end
