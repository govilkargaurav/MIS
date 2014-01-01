//
//  CustomTextField.m
//  Bridges
//
//  Created by Habib Ali on 6/15/12.
//  Copyright (c) 2012 Folio3 Private Ltd. All rights reserved.
//

#import "CustomTextField2.h"

@implementation CustomTextField2

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



@end
