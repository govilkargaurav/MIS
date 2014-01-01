//
//  SHCToDoItem.m
//  ClearStyle
//
//  Created by Fahim Farook on 22/9/12.
//  Copyright (c) 2012 RookSoft Pte. Ltd. All rights reserved.
//

#import "SHCToDoItem.h"

@implementation SHCToDoItem

-(id)initWithText:(NSString*)text {
    if (self = [super init]) {
		self.text = text;
    }
    return self;
}

+(id)toDoItemWithText:(NSString *)text {
    return [[SHCToDoItem alloc] initWithText:text];
}

@end
