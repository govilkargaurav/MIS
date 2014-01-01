//
//  TrusteesListParser.h
//  PropertyInspector
//
//  Created by apple on 10/22/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "ViewController.h"
#import "GetTrusteesListModel.h"
@interface TrusteesListParser : ViewController<NSXMLParserDelegate>
{
    NSXMLParser *parser;
    int requestType;
    NSString *mCurrentTagName;
    NSMutableString *mCurrentTagValue;
    //GetVersionModel *versionModel;
    
}
@property(nonatomic,retain)GetTrusteesListModel *versionModel;
@property(nonatomic,copy)	NSString *mCurrentTagName;
@property(nonatomic,retain)NSMutableString *mCurrentTagValue;
- (void)parseData:(NSData*)rawData :(int)reqType;

@end
