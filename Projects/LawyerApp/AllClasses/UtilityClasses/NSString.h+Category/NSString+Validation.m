//
//  NSString+URLEncoding.m
//
//  Created by Jon Crosby on 10/19/07.
//  Copyright 2007 Kaboomerang LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "NSString+Validation.h"


@implementation NSString (OAURLEncodingAdditions)

- (NSString *)encodedURLString {
	NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,
                                                                                             NULL,                   // characters to leave unescaped (NULL = all escaped sequences are replaced)
                                                                           CFSTR("?=&+"),          // legal URL characters to be escaped (NULL = all legal characters are replaced)
                                                                           kCFStringEncodingUTF8)); // encoding
	return result ;
}

- (NSString *)encodedURLParameterString {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR(":/=,!$&'()*+;[]@#?"),kCFStringEncodingUTF8));
	return result;
}

- (NSString *)decodedURLString
{
	NSString *result = (NSString*)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)self,CFSTR(""),kCFStringEncodingUTF8));
	return result;
}

-(NSString *)removeQuotes
{
	NSUInteger length = [self length];
	NSString *ret = self;
	if ([self characterAtIndex:0] == '"') {
		ret = [ret substringFromIndex:1];
	}
	if ([self characterAtIndex:length - 1] == '"') {
		ret = [ret substringToIndex:length - 2];
	}
	
	return ret;
}
#pragma mark - Not Null String
-(NSString *)RemoveNull
{
    if(self == nil)
    {
        return @"";
    }
    else if(self == (id)[NSNull null] || [self caseInsensitiveCompare:@"(null)"] == NSOrderedSame || [self caseInsensitiveCompare:@"<null>"] == NSOrderedSame || [self caseInsensitiveCompare:@""] == NSOrderedSame || [self length]==0)
    {
        return @"";
    }
    else
    {
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}


//#pragma mark - Validate Email
//-(BOOL)StringIsValidEmail
//{
//    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    return [emailTest evaluateWithObject:self];
//}


#pragma mark -
#pragma mark EMAIL VALIDATION

- (BOOL)validateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z][A-Z0-9a-z._%+-]*@[A-Za-z0-9][A-Za-z0-9.-]*\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSRange aRange;
    if([emailTest evaluateWithObject:self]) {
        aRange = [self rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, [self length])];
        int indexOfDot = aRange.location;
        //NSLog(@"aRange.location:%d - %d",aRange.location, indexOfDot);
        if(aRange.location != NSNotFound) {
            NSString *topLevelDomain = [self substringFromIndex:indexOfDot];
            topLevelDomain = [topLevelDomain lowercaseString];
            //NSLog(@"topleveldomains:%@",topLevelDomain);
            NSSet *TLD;
            TLD = [NSSet setWithObjects:@".aero", @".asia", @".biz", @".cat", @".com", @".coop", @".edu", @".gov", @".info", @".int", @".jobs", @".mil", @".mobi", @".museum", @".name", @".net", @".org", @".pro", @".tel", @".travel", @".ac", @".ad", @".ae", @".af", @".ag", @".ai", @".al", @".am", @".an", @".ao", @".aq", @".ar", @".as", @".at", @".au", @".aw", @".ax", @".az", @".ba", @".bb", @".bd", @".be", @".bf", @".bg", @".bh", @".bi", @".bj", @".bm", @".bn", @".bo", @".br", @".bs", @".bt", @".bv", @".bw", @".by", @".bz", @".ca", @".cc", @".cd", @".cf", @".cg", @".ch", @".ci", @".ck", @".cl", @".cm", @".cn", @".co", @".cr", @".cu", @".cv", @".cx", @".cy", @".cz", @".de", @".dj", @".dk", @".dm", @".do", @".dz", @".ec", @".ee", @".eg", @".er", @".es", @".et", @".eu", @".fi", @".fj", @".fk", @".fm", @".fo", @".fr", @".ga", @".gb", @".gd", @".ge", @".gf", @".gg", @".gh", @".gi", @".gl", @".gm", @".gn", @".gp", @".gq", @".gr", @".gs", @".gt", @".gu", @".gw", @".gy", @".hk", @".hm", @".hn", @".hr", @".ht", @".hu", @".id", @".ie", @" No", @".il", @".im", @".in", @".io", @".iq", @".ir", @".is", @".it", @".je", @".jm", @".jo", @".jp", @".ke", @".kg", @".kh", @".ki", @".km", @".kn", @".kp", @".kr", @".kw", @".ky", @".kz", @".la", @".lb", @".lc", @".li", @".lk", @".lr", @".ls", @".lt", @".lu", @".lv", @".ly", @".ma", @".mc", @".md", @".me", @".mg", @".mh", @".mk", @".ml", @".mm", @".mn", @".mo", @".mp", @".mq", @".mr", @".ms", @".mt", @".mu", @".mv", @".mw", @".mx", @".my", @".mz", @".na", @".nc", @".ne", @".nf", @".ng", @".ni", @".nl", @".no", @".np", @".nr", @".nu", @".nz", @".om", @".pa", @".pe", @".pf", @".pg", @".ph", @".pk", @".pl", @".pm", @".pn", @".pr", @".ps", @".pt", @".pw", @".py", @".qa", @".re", @".ro", @".rs", @".ru", @".rw", @".sa", @".sb", @".sc", @".sd", @".se", @".sg", @".sh", @".si", @".sj", @".sk", @".sl", @".sm", @".sn", @".so", @".sr", @".st", @".su", @".sv", @".sy", @".sz", @".tc", @".td", @".tf", @".tg", @".th", @".tj", @".tk", @".tl", @".tm", @".tn", @".to", @".tp", @".tr", @".tt", @".tv", @".tw", @".tz", @".ua", @".ug", @".uk", @".us", @".uy", @".uz", @".va", @".vc", @".ve", @".vg", @".vi", @".vn", @".vu", @".wf", @".ws", @".ye", @".yt", @".za", @".zm", @".zw", nil];
            if(topLevelDomain != nil && ([TLD containsObject:topLevelDomain])) {
                //NSLog(@"TLD contains topLevelDomain:%@",topLevelDomain);
                return TRUE;
            }
            /*else {
             NSLog(@"TLD DOEST NOT contains topLevelDomain:%@",topLevelDomain);
             }*/
            
        }
    }
    return FALSE;
}

#pragma mark - Validate for Integer Number string
-(BOOL)StringIsIntigerNumber
{
    NSRegularExpression *regex = [[NSRegularExpression alloc]
                                  initWithPattern:@"[0-9]" options:0 error:NULL];
    NSUInteger matches = [regex numberOfMatchesInString:self options:0
                                                  range:NSMakeRange(0, [self length])];
    if (matches == [self length])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


#pragma mark - Validate for Float Number string
-(BOOL)StringIsFloatNumber
{
    if([self rangeOfString:@"."].location == NSNotFound)
    {
        return NO;
    }
    else
    {
        
        NSString *regx = @"(-){0,1}(([0-9]+)(.)){0,1}([0-9]+)";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regx];
        return [test evaluateWithObject:self];
    }
}


#pragma mark - Complete Number string
-(BOOL)StringIsComplteNumber
{
    NSString *regx = @"(-){0,1}(([0-9]+)(.)){0,1}([0-9]+)";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regx];
    return [test evaluateWithObject:self];
}


#pragma mark - alpha numeric string
-(BOOL)StringIsAlphaNumeric
{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"] invertedSet];
    
    if ([self rangeOfCharacterFromSet:set].location != NSNotFound)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


#pragma mark - illegal char in string
-(BOOL)StringWithIlligalChar
{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"] invertedSet];
    if ([self rangeOfCharacterFromSet:set].location != NSNotFound)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark -Strong Password
-(BOOL)StringWithStrongPassword:(int)minimumLength
{
    if([self length] <minimumLength)
    {
        return NO;
    }
    BOOL isCaps = FALSE;
    BOOL isNum = FALSE;
    BOOL isSymbol = FALSE;
    
    NSRegularExpression *regexCaps = [[NSRegularExpression alloc]
                                      initWithPattern:@"[A-Z]" options:0 error:NULL];
    NSUInteger intMatchesCaps = [regexCaps numberOfMatchesInString:self options:0
                                                             range:NSMakeRange(0, [self length])];
    if (intMatchesCaps > 0)
    {
        isCaps = TRUE;
    }
    
    NSRegularExpression *regexNum = [[NSRegularExpression alloc]
                                     initWithPattern:@"[0-9]" options:0 error:NULL];
    NSUInteger intMatchesNum = [regexNum numberOfMatchesInString:self options:0
                                                           range:NSMakeRange(0, [self length])];
    if (intMatchesNum > 0)
    {
        isNum = TRUE;
    }
    
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"] invertedSet];
    if ([self rangeOfCharacterFromSet:set].location != NSNotFound)
    {
        isSymbol = TRUE;
    }
    
    if(isCaps == TRUE && isNum == TRUE && isSymbol == TRUE)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

-(float)getHeight_withFont:(UIFont *)myFont widht:(float)myWidth
{
    CGSize textSize= [self sizeWithFont:myFont constrainedToSize:CGSizeMake(myWidth,CGFLOAT_MAX)lineBreakMode:UILineBreakModeWordWrap];
    return textSize.height;
}
-(NSString *)FormateDate_withCurrentFormate:(NSString *)currentFormate newFormate:(NSString *)dateFormatter
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:currentFormate];
    NSDate *date = [df dateFromString:self];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:dateFormatter];
    return [df stringFromDate:date];
}

-(NSString *)infoNotAvailable{
    
    if ([self isEqualToString:@""]) {
        
        return @"Info not available";
        
    }else{
        
        return self;
    }
    
    return @"";
    
}


@end
