//
//  ImageCell.m
//  HuntingApp
//
//  Created by Habib Ali on 10/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell
@synthesize btn1,btn2,btn3,btn4;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       
    }
    return self;
}
//
//-(id)initWithIdentifier :(NSString *)identifier{
//    
//    
////    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    
//    
//    self = [super initWithIdentifier:identifier];
//    
//    if (self) {
//        // Initialization code
//        
//    }
//    return self;
//    
//    
//}

- (NSString *)reuseIdentifier
{
    return [super reuseIdentifier];
}

- (void)dealloc
{
    RELEASE_SAFELY(btn1);
    RELEASE_SAFELY(btn2);
    RELEASE_SAFELY(btn3);
    RELEASE_SAFELY(btn4);
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
