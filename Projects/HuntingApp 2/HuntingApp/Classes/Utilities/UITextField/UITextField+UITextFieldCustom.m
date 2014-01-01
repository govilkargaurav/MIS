//
//  UITextField+UITextFieldCustom.m
//  Bridges
//
//  Created by Asim Ahmed on 4/20/12.
//  Copyright (c) 2012 Folio3 Private Ltd. All rights reserved.
//

#import "UITextField+UITextFieldCustom.h"

@implementation UITextField (UITextFieldCustom)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect theRect=CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width-10, bounds.size.height);
    return theRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
    return inset;
}

//To change the color of place holder text
- (void)drawPlaceholderInRect:(CGRect)rect
{
    [[UIColor colorWithRed:179/255.0 green:164/255.0 blue:134/355.0 alpha:1.0] setFill];
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:16]];
}

@end
