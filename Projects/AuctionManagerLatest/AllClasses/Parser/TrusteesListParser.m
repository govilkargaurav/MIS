//
//  TrusteesListParser.m
//  PropertyInspector
//
//  Created by apple on 10/22/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "TrusteesListParser.h"

@interface TrusteesListParser ()

@end

@implementation TrusteesListParser


@synthesize versionModel,mCurrentTagName,mCurrentTagValue;

- (id) init
{
	self = [super init];
    
	if (self != nil) {
        
        if (_arrTrusees!=nil) {
            _arrTrusees=nil;
            [_arrTrusees removeAllObjects];
        }
        _arrTrusees=[[NSMutableArray alloc] init];
        
        
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
        
        
        
        if ([elementName isEqualToString:@"property"]) {
        
        
        
        _dictTrusatees=[NSDictionary dictionaryWithObjectsAndKeys:[attributeDict objectForKey:@"id"],@"ID",[attributeDict objectForKey:@"address"],@"ADDRESS",[attributeDict objectForKey:@"city"],@"CITY",[attributeDict objectForKey:@"state"],@"STATE",[attributeDict objectForKey:@"zip"],@"ZIP",[attributeDict objectForKey:@"lat"],@"LATTI",[attributeDict objectForKey:@"long"],@"LONGI",[attributeDict objectForKey:@"borrower"],@"BROOWER_NAME",[attributeDict objectForKey:@"trustee"],@"TRUSTEE_NAME",[attributeDict objectForKey:@"trusteeId"],@"TRUSTEE_ID",[attributeDict objectForKey:@"bidderLastName"],@"BIDDER_LAST_NAME",[attributeDict objectForKey:@"bidderFirstName"],@"BIDDER_FIRST_NAME",[attributeDict objectForKey:@"bidderMiddleName"],@"BIDDER_MIDDLE_NAME",[attributeDict objectForKey:@"maxBid"],@"MAX_BID",[attributeDict objectForKey:@"openingBid"],@"OPENING_BID",[attributeDict objectForKey:@"bidStatus"],@"STATUS",[attributeDict objectForKey:@"updatedBy"],@"UPDATED_BY",[attributeDict objectForKey:@"updatedDate"],@"UPDATED_DATE",[attributeDict objectForKey:@"bidderId"],@"BIDDER_ID",[attributeDict objectForKey:@"wonPrice"],@"WON_PRIZE",[attributeDict objectForKey:@"auctionDateTime"],@"AUCTION_DATE_TIME",[attributeDict objectForKey:@"auctionNotes"],@"AUCTION_NOTES",[attributeDict objectForKey:@"auctionId"],@"AUCTION_ID",[attributeDict objectForKey:@"legalDescription"],@"LEGAL_DESCRIPTION",[attributeDict objectForKey:@"auctionNo"],@"AUCTION_NO",[attributeDict valueForKey:@"crier"],@"CRIER",[attributeDict valueForKey:@"settleStatus"],@"SETTLE_STATUS",
                        [attributeDict valueForKey:@"loanedDate"],@"LOANDATE",[attributeDict valueForKey:@"loanedAmt"],@"LOANAMOUNT",nil];
        
        
        [_arrTrusees addObject:_dictTrusatees];
        
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
	
    
	[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GET_TRUSTEES_LIST object:nil];
}


- (void)parserDidEndDocument:(NSXMLParser *)parse
{
    
	[[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_GET_TRUSTEES_LIST object:nil];
	
	
}

@end
