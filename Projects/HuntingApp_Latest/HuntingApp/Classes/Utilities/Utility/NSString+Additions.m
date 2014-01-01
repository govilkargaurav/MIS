//
//  NSString+Additions.m
//  Hiplink
//
//  Created by Kabir Khan on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

/*
 *  Note: method check if string is part of string.
 */
- (BOOL)containsString:(NSString*)substring {
    
    NSRange range = [self rangeOfString : substring];
    return  (range.location != NSNotFound);
    
}

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
	return (NSString *)CFURLCreateStringByAddingPercentEscapes
    (NULL,(CFStringRef)self,NULL,
     (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
     CFStringConvertNSStringEncodingToEncoding(encoding));
}
@end
