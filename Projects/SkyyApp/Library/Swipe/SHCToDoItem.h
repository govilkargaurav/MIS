//
//  SHCToDoItem.h
//  ClearStyle
//
//  Created by Fahim Farook on 22/9/12.
//  Copyright (c) 2012 RookSoft Pte. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHCToDoItem : NSObject

// A text description of this item.
@property (nonatomic, copy) NSString *text;

// A boolean value that determines the completed state of this item.
@property (nonatomic) BOOL completed;

// Returns an SHCToDoItem item initialised with the given text.
-(id)initWithText:(NSString*)text;

// Returns an SHCToDoItem item initialised with the given text.
+(id)toDoItemWithText:(NSString*)text;

@end
