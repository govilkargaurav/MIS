//
//  NSString+Additions.h
//  Hiplink
//
//  Created by Kabir Khan on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

/*
 *  Note: method check if string is part of string.
 */
- (BOOL)containsString:(NSString*)substring;

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
@end
