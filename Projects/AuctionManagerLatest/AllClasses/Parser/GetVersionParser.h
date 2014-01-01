//
//  GetVersionParser.h
//  PropertyInspector
//
//  Created by apple on 10/16/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetVersionModel.h"
@interface GetVersionParser : UIViewController<NSXMLParserDelegate>
{
    NSXMLParser *parser;
    int requestType;
    NSString *mCurrentTagName;
    NSMutableString *mCurrentTagValue;
    GetVersionModel *versionModel;
    
}
@property(nonatomic,retain)GetVersionModel *versionModel;
@property(nonatomic,copy)	NSString *mCurrentTagName;
@property(nonatomic,retain)NSMutableString *mCurrentTagValue;
- (void)parseData:(NSData*)rawData :(int)reqType;

@end
