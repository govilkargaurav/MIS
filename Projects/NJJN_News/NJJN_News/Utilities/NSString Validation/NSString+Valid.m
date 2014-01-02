//
//  NSString+Valid.m
//  ValidationProject
//
//  Created by Dhaval on 2/16/13.
//  Copyright (c) 2013 i-phone. All rights reserved.
//

#import "NSString+Valid.h"

@implementation NSString (Valid)


#pragma mark - Not Null String

-(NSString *)StringNotNullValidation
{
    if(self == nil)
    {
        return @"";
    }
    else if(self == (id)[NSNull null] || [self caseInsensitiveCompare:@"(null)"] == NSOrderedSame || [self caseInsensitiveCompare:@"<null>"] == NSOrderedSame || [self caseInsensitiveCompare:@""] == NSOrderedSame || [self caseInsensitiveCompare:@"<nil>"] == NSOrderedSame || [self length]==0)
    {
        return @"";
    }
    else
    {
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}


#pragma mark - Validate Email 

-(BOOL)StringIsValidEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
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

-(BOOL)StringIsFloarNumber
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

@end
