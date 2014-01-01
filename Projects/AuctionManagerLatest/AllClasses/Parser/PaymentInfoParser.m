//
//  PaymentInfoParser.m
//  PropertyInspector
//
//  Created by apple on 10/31/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "PaymentInfoParser.h"

@interface PaymentInfoParser ()

@end

@implementation PaymentInfoParser

@synthesize versionModel,mCurrentTagName,mCurrentTagValue;

- (id) init
{
	self = [super init];
    
	if (self != nil) {
        
        
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
    
   
    
    if ([elementName isEqualToString:@"response"]) {
        
        statuspaymentInfo=[attributeDict valueForKey:@"success"];
        
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



- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	
    
	[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_POST_PAYMENT_LIST object:nil];
}


- (void)parserDidEndDocument:(NSXMLParser *)parse
{
 
	[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_POST_PAYMENT_LIST object:nil];
	
	
}


@end
