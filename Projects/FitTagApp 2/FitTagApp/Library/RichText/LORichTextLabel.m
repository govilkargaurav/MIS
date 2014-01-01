//
//  LORichTextLabel.m
//  RichTextLabel
//
//  Created by Locassa on 19/06/2011.
//  Copyright 2011 Locassa Ltd. All rights reserved.
//

#import "LORichTextLabel.h"
#import "UIView+Layout.h"


@implementation LORichTextLabel
@synthesize isCommentView,isLikeUser,likerCount;
- (id)initWithWidth:(CGFloat)aWidth {
	self = [super initWithFrame:CGRectMake(0.0, 0.0, aWidth, 0.0)];
	
	if(self != nil) {
        
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
		highlightStyles = [[NSMutableDictionary alloc] init];
		elements = [[NSMutableArray alloc] init];
        
		font = [UIFont fontWithName:@"Helvetica" size:12.0];
		[font retain];
		
		textColor = [UIColor blackColor];
		[textColor retain];
	}
	
	return self;
}

- (void)dealloc {
	[highlightStyles release];
	[elements release];
	[font release];
	[textColor release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Mutators

- (void)addStyle:(LORichTextLabelStyle *)aStyle forPrefix:(NSString *)aPrefix {
	if((aPrefix == nil) || (aPrefix.length == 0)) {
		[NSException raise:NSInternalInconsistencyException
                    format:@"Prefix must be specified in %@", NSStringFromSelector(_cmd)];
	}
	
	[highlightStyles setObject:aStyle forKey:aPrefix];
}

- (void)setFont:(UIFont *)value {
	if([font isEqual:value]) {
		return;
	}
	
	[font release];
	font = value;
	[font retain];
	
	[self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)value {
	if([textColor isEqual:value]) {
		return;
	}
	
	[textColor release];
	textColor = value;
	[textColor retain];
	
	[self setNeedsLayout];
}

-(void)setText:(NSString *)value {
	[elements release];
	elements = [value componentsSeparatedByString:@" "];
	[elements retain];
    
	[self setNeedsLayout];
    [self layoutSubviews];
}

#pragma mark -
#pragma mark Drawing Methods

- (void)layoutSubviews {
	[self removeSubviews];
	
	NSUInteger maxHeight;
    if (self.isCommentView == TRUE){
        maxHeight = 99999;
    }
	else{
        maxHeight = 21;
    }
    
	CGPoint position = CGPointZero;
	CGSize measureSize = CGSizeMake(self.size.width, maxHeight);
	
	for(int i = 0; i < [elements count]; i++){
        
        NSString *element = [elements objectAtIndex:i];
		LORichTextLabelStyle *style = nil;
		
		// Find suitable style
		for(NSString *prefix in [highlightStyles allKeys]){
			if([element hasPrefix:prefix]) {
				style = [highlightStyles objectForKey:prefix];
				break;
			}
		}
        
		UIFont *styleFont = style.font == nil ? font : style.font;
		UIColor *styleColor = style.color == nil ? textColor : style.color;
		
		// Get size of content (check current line before starting new one)
		CGSize remainingSize = CGSizeMake(measureSize.width - position.x, maxHeight);
		CGSize singleLineSize = CGSizeMake(remainingSize.width, 0.0);
		
		CGSize controlSize = [element sizeWithFont:styleFont constrainedToSize:singleLineSize lineBreakMode:NSLineBreakByWordWrapping];
		CGSize elementSize = [element sizeWithFont:styleFont constrainedToSize:remainingSize];
        
		if(elementSize.height > controlSize.height){
			position.y += controlSize.height;
			position.x = 0.0;
		}
        
		elementSize = [element sizeWithFont:styleFont constrainedToSize:measureSize];
		CGRect elementFrame = CGRectMake(position.x, position.y, elementSize.width, elementSize.height);
		
		// Add button or label depending on whether we have a target
		if(style.target != nil) {
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
           // button.backgroundColor = [UIColor redColor];
            
            
			[button addTarget:style.target action:style.action forControlEvents:UIControlEventTouchUpInside];
            if (self.isLikeUser==TRUE) {
                
                if (i==0) {
                    
                    NSString *string=@"#";
                    
                    CGSize stringSize = [string sizeWithFont:[UIFont boldSystemFontOfSize:5] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
                    position.x=position.x+stringSize.width-7;
                    
                    [button setTitle:[element substringFromIndex:1] forState:UIControlStateNormal];
                     
                }else{
                    
                    [button setTitle:[element stringByReplacingOccurrencesOfString:@"#"withString:@","] forState:UIControlStateNormal];
                    NSString *string=@"#";
                    
                    CGSize stringSize = [string sizeWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
                    position.x = position.x-stringSize.width;
                }
                
                if (i == 2){
                    NSString *string=@"#";
                    
                    CGSize stringSize = [string sizeWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
                    position.x=position.x+stringSize.width;
                }
            }
            else{
                [button setTitle:element forState:UIControlStateNormal];
            }
            
            button.titleLabel.textAlignment = NSTextAlignmentLeft;
			[button setTitleColor:styleColor forState:UIControlStateNormal];
			[button setFrame:elementFrame];
			[button.titleLabel setFont:styleFont];
            
			[self addSubview:button];
		}else{
			UILabel *label = [[UILabel alloc] initWithFrame:elementFrame];
			[label setBackgroundColor:[UIColor clearColor]];
			[label setNumberOfLines:maxHeight];
			[label setFont:styleFont];
			[label setTextColor:styleColor];
            
            if (self.isLikeUser == TRUE) {
                
                if (likerCount>=4) {
                    if (i==[elements count]-4 ) {
                        label.textColor=[UIColor redColor];
                    }
                    else if (i==[elements count]-3){
                        label.textColor=[UIColor redColor];
                    }
                    //                    else if (i==[elements count]-2 ) {
                    //                        label.textColor=[UIColor redColor];
                    //                    }
                    //                    else if (i==[elements count]-1 ) {
                    //                        label.textColor=[UIColor redColor];
                    //                    }
                }
                
                else{
                    
                    label.textColor=[UIColor blackColor];
                }
                
            }else{
                label.textColor = [UIColor blackColor];
            }
            
            [label setText:element];
            
			[self addSubview:label];
		}
		CGSize spaceSize;
        if (self.isLikeUser == TRUE){
            spaceSize = [@" " sizeWithFont:styleFont];
        }else{
            spaceSize = [@" " sizeWithFont:styleFont];
        }
        
		position.x += elementSize.width + spaceSize.width;
		
        if (position.x > 199) {
            position.x = 0.0;
            position.y=position.y+15;
        }
        
        /*
		if([element isEqual:[elements lastObject]]) {
			position.y += controlSize.height;	
		}*/
	}
	
	[self setSize:CGSizeMake(self.size.width, position.y)];
    appDelegate.richLabelHeight=self.size.height;
}

@end