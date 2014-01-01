//
//  NSObject+XMLParser.m
//  TpSynergy
//
//  Created by Apple-Openxcell on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSObject+XMLParser.h"

@implementation XMLParser

@synthesize delegate;



-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parseStartElement:attributes:)]){
		[self.delegate performSelector:@selector(parseStartElement:attributes:) withObject:elementName withObject:attributeDict];
	}
    
    
    
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parseCharacters:)])
    {
		[self.delegate performSelector:@selector(parseCharacters:) withObject:string];
    }
    
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(parseEndElement:)])
    {
		[self.delegate performSelector:@selector(parseEndElement:) withObject:elementName];
    }
}    

- (void)parserDidStartDocument:(NSXMLParser *)parser 
{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(startParseXML:)])
    {
        [self.delegate performSelector:@selector(startParseXML:) withObject:parser];
    }		
    
}


- (void)parserDidEndDocument:(NSXMLParser *)parser 

{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(endParseXML:)]){
        [self.delegate performSelector:@selector(endParseXML:) withObject:parser];
    }	
    
    currParser=nil;
}   


-(void)ParsingDataFromurl:(NSData *)url
{
    @synchronized(self)
    {
        currParser = [[NSXMLParser alloc] initWithData:url];
        
        [currParser setDelegate:self];
        [currParser setShouldProcessNamespaces:YES];
        [currParser setShouldReportNamespacePrefixes:NO];
        [currParser setShouldResolveExternalEntities:NO];
        
        
        BOOL success=[currParser parse];
        
        if(success)
        {
            ////NSLog(@"sucess1");
            
        }
        else
        {
            ////NSLog(@"fail");
        }
    }
    
}


@end
