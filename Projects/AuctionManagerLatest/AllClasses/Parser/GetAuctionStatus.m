//
//  GetAuctionStatus.m
//  PropertyInspector
//
//  Created by apple on 11/9/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "GetAuctionStatus.h"

@interface GetAuctionStatus ()

@end

@implementation GetAuctionStatus

@synthesize versionModel,mCurrentTagName,mCurrentTagValue;

- (id) init
{
	self = [super init];
    
	if (self != nil) {
        
        statusDictAuction=[[NSMutableDictionary alloc] init];
        statusArrayAuction=[[NSMutableArray alloc] init];
        
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
    
    if ([elementName isEqualToString:@"auctionStatus"]) {
        
        statusDictAuction=[NSMutableDictionary dictionaryWithObjectsAndKeys:[attributeDict valueForKey:@"type"],@"TYPE",[attributeDict valueForKey:@"propertyCount"],@"COUNT",[attributeDict valueForKey:@"amount"],@"AMOUNT", nil];
        
        [statusArrayAuction addObject:statusDictAuction];
        
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

	[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GET_AUCTION_STATUS object:nil];
    
}


- (void)parserDidEndDocument:(NSXMLParser *)parse
{
    
    
	[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GET_AUCTION_STATUS object:nil];
	
	
}

@end
