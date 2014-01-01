//
//  FJSwitch.h
//
//  Created by Francisco Jimenez on 3/7/12.
//
//  Copyright (c) 2012 Francisco Jimenez
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import "BorderView.h"

@interface FJSwitch : UIControl {
    UILabel *onLabel;
    UILabel *offLabel;
    UIImageView *borderImageView;
    
    CGFloat onWidth;
    CGFloat offWidth;
    
    BorderView *borderView;
    
    CGRect borderlessFrame;
    
    int onPosition;
}

@property(nonatomic, getter=isOn, readonly) BOOL on;
@property(nonatomic) CGFloat onWidth;
@property(nonatomic) CGFloat offWidth;

@property(nonatomic) int borderWidth;
@property(nonatomic, assign) UIColor *borderColor;

#if __has_feature(objc_arc)
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *onLabel;
@property(nonatomic, strong) UILabel *offLabel;
@property(nonatomic, strong) BorderView *borderView;
#else
@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, retain) UILabel *onLabel;
@property(nonatomic, retain) UILabel *offLabel;
@property(nonatomic, retain) BorderView *borderView;
#endif

- (id) initWithImage:(UIImage *)image frame:(CGRect)frame onWidth:(CGFloat)onWidth offWidth:(CGFloat)offWidth;

- (void) setOn:(BOOL)on animated:(BOOL)animated;
- (void) toggleOn;

@end
