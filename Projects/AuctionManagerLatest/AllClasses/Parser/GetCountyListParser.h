//
//  GetCountyListParser.h
//  PropertyInspector
//
//  Created by apple on 10/18/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetCountyListModel.h"
@interface GetCountyListParser : UIViewController<NSXMLParserDelegate>
{
    NSXMLParser *parser;
    int requestType;
    NSString *mCurrentTagName;
    NSMutableString *mCurrentTagValue;
    //GetVersionModel *versionModel;
    
}
@property(nonatomic,retain)GetCountyListModel *versionModel;
@property(nonatomic,copy)	NSString *mCurrentTagName;
@property(nonatomic,retain)NSMutableString *mCurrentTagValue;
- (void)parseData:(NSData*)rawData :(int)reqType;

@end
