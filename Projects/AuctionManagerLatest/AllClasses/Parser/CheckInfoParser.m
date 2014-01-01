//
//  CheckInfoParser.m
//  PropertyInspector
//
//  Created by apple on 12/4/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "CheckInfoParser.h"

@interface CheckInfoParser ()

@end

@implementation CheckInfoParser

@synthesize versionModel,mCurrentTagName,mCurrentTagValue;

- (id) init
{
	self = [super init];
    
	if (self != nil) {
        
        checkNumberAMOUNT=[[NSMutableDictionary alloc] init];
        checkNumber_amount=[[NSMutableArray alloc]init];
        
	}
	return self;
}



- (void)parseData:(NSData*)rawData :(int)reqType
{
	
        
    
    requestType=reqType;
	parser = [[NSXMLParser alloc] initWithData: rawData];
	[parser setDelegate: self];
	[parser setShouldResolveExternalEntities: YES];
	[parser parse];
    
}

#pragma mark ParserDelegate Methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	
    self.mCurrentTagName = elementName;
    
    if ([elementName isEqualToString:@"check"]) {
        
        checkNumberAMOUNT=[NSMutableDictionary dictionaryWithObjectsAndKeys:[attributeDict valueForKey:@"number"],@"CHECKNUMBER",[attributeDict valueForKey:@"amount"],@"CHECKAMOUNT", nil];
        
        [checkNumber_amount addObject:checkNumberAMOUNT];

        
        self.mCurrentTagValue=[[NSMutableString alloc]init];
        
    }
    
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if([self.mCurrentTagName  isEqualToString:@"response"]){
        
		[self.mCurrentTagValue appendString:string];
        
	}
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
    if([elementName isEqualToString:@"response"]){
        
        
	}
	
    self.mCurrentTagName=nil;
	self.mCurrentTagValue=nil;
}



-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    
	[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GET_CHECK_AMOUNT_BY_NUMBER object:nil];
    
}



- (void)parserDidEndDocument:(NSXMLParser *)parse
{
    
    
	[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GET_CHECK_AMOUNT_BY_NUMBER object:nil];
	
	
}

@end
