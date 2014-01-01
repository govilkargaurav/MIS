//
//  NSAttributedString+Extension.m
//  Suvi
//
//  Created by Gagan on 5/13/13.
//
//

#import "NSAttributedString+Extension.h"

@implementation NSAttributedString (Extension)

-(NSNumber *)heightforAttributedStringWithWidth:(float)lblwidth
{
    OHAttributedLabel *lblAttributed= [[OHAttributedLabel alloc] initWithFrame:CGRectMake(0.0f,0.0f,lblwidth,0.0)];
    lblAttributed.numberOfLines=0.0;
    lblAttributed.attributedText=self;
    [lblAttributed sizeToFit];
    NSNumber *theHeight=[NSNumber numberWithFloat:lblAttributed.frame.size.height];
    theHeight=([theHeight floatValue]==1.0)?0:theHeight;
    return theHeight;
}
-(NSNumber *)widthforAttributedStringWithHeight:(float)lblheight
{
    OHAttributedLabel *lblAttributed= [[OHAttributedLabel alloc] initWithFrame:CGRectMake(0.0f,0.0f,0.0f,lblheight)];
    lblAttributed.numberOfLines=0.0;
    lblAttributed.attributedText=self;
    [lblAttributed sizeToFit];
    NSNumber *theWidth=[NSNumber numberWithFloat:lblAttributed.frame.size.width];
    theWidth=([theWidth floatValue]==1.0)?0:theWidth;
    return theWidth;
}

@end
