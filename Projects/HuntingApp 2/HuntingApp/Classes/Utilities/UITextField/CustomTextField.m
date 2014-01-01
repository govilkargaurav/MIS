//
//  CustomTextField.m
//  Bridges
//
//  Created by Habib Ali on 6/15/12.
//  Copyright (c) 2012 Folio3 Private Ltd. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

//- (void)layoutSubviews
//{
//    self.keyboardAppearance = UIKeyboardAppearanceAlert;
//}

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
    [[UIColor colorWithRed:152/255.0 green:146/255.0 blue:131/255.0 alpha:1.0] setFill];
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:16]];
    [self setTextColor:[UIColor colorWithRed:152/255.0 green:146/255.0 blue:131/255.0 alpha:1.0]];
}


@end
