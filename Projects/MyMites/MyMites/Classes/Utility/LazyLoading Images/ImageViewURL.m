//
//  ImageViewURL.m
//  LibXml2P
//
//  Created by DIGICORP on 16/03/10.
//  Copyright 2010 DIGICORP. All rights reserved.
//

#import "ImageViewURL.h"


@implementation ImageViewURL
@synthesize strUrl,imgV;
@synthesize img;

-(void)setStrUrl:(NSURL *)u {
	NSURLRequest *req=[NSURLRequest requestWithURL:u cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:40];
	NSURLConnection *con=[[NSURLConnection alloc] initWithRequest:req delegate:self];
	if(con){
		myWebData=[NSMutableData data];
	} else {
	}
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[myWebData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[myWebData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
	imgV.image=[UIImage imageWithData:myWebData];
    img=[UIImage imageWithData:myWebData];
	 connection=nil;
}


@end
