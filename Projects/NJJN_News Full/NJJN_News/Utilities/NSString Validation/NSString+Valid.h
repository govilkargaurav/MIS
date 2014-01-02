//
//  NSString+Valid.h
//  ValidationProject
//
//  Created by Dhaval on 2/16/13.
//  Copyright (c) 2013 i-phone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Valid)

//return, @"" in result if null of nil string found
-(NSString *)StringNotNullValidation;

//return, 1 if valid email, else 0
-(BOOL)StringIsValidEmail;

//return, 1 if number string else 0  for 0 to 9
-(BOOL)StringIsIntigerNumber;

//return, 1 if number string else 0 for 0 to 9 with float
-(BOOL)StringIsFloarNumber;

//return, 1 if string is complete number i.e 1, 1.0, -1.0, -1 etc, or return 0
-(BOOL)StringIsComplteNumber;

//return, 1 if string is alpha numeric, else 0
-(BOOL)StringIsAlphaNumeric;

//return, 1 if illegal char exist, else 0
-(BOOL)StringWithIlligalChar;

//return 1, for strong password else 0, it require one Caps later, one symbol and at lease one number with minimum length of value of minimumLength.
-(BOOL)StringWithStrongPassword:(int)minimumLength;

@end
