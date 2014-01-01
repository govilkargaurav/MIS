//
//  NSObject+XMLParser.h
//  TpSynergy
//
//  Created by Apple-Openxcell on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@class AppDelegate;
@protocol XMLParseEventHandler

@optional
- (void)startParseXML:(NSXMLParser*) parser;
- (void)endParseXML:(NSXMLParser*) parser;
- (void)parseStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict;
- (void)parseEndElement:(NSString *)elementName;
- (void)parseCharacters:(NSString *)string;
- (void)occurrParseError:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError;

@end




@interface XMLParser:NSObject<NSXMLParserDelegate>
{
    AppDelegate *app;
NSMutableString *CurrentElementValues;
NSXMLParser *currParser;
BOOL elementsfound;
NSString *elementname;
}


@property (unsafe_unretained, nonatomic) id delegate;

-(void)ParsingDataFromurl:(NSData *)url;


@end
