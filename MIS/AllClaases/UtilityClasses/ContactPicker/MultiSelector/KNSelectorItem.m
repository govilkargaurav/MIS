//
//  KNSelectorItem.m
//  KNFBFriendSelectorDemo
//
//  Created by Kent Nguyen on 4/6/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#import "KNSelectorItem.h"

@implementation KNSelectorItem

@synthesize displayValue = _displayValue,
            selectValue = _selectValue,
            imageUrl = _imageUrl,
            image = _image,
            selected = _selected,
            ID = _ID,
            emailID = _emailID;

-(id)initWithDisplayValue:(NSString*)displayVal {
  return [self initWithDisplayValue:displayVal selectValue:displayVal imageUrl:nil primaryKey:0 personEmail:nil];
}

-(id)initWithDisplayValue:(NSString*)displayVal
              selectValue:(NSString*)selectVal
                 imageUrl:(NSString*)image
               primaryKey:(int)PrimaryID
              personEmail:(NSString *)emailID{
    
  if ((self=[super init])) {
    self.displayValue = displayVal;
    self.selectValue = selectVal;
    self.imageUrl = image;
      self.ID = PrimaryID;
      self.emailID=emailID;
  }
  return self;
}

-(id)initWithDisplayValue:(NSString*)displayVal
              selectValue:(NSString*)selectVal
                    image:(UIImage*)image
                    ID:(int)PrimaryKey
                    personEmail:(NSString *)emailID{
    
    self = [self initWithDisplayValue:displayVal selectValue:selectVal imageUrl:nil primaryKey:PrimaryKey personEmail:emailID];
    if (self) {
        self.image = image;
    }
    return self;
}

#pragma mark - Sort comparison

-(NSComparisonResult)compareByDisplayValue:(KNSelectorItem*)other {
  return [self.displayValue compare:other.displayValue];
}
-(NSComparisonResult)compareBySelectedValue:(KNSelectorItem*)other {
  return [self.selectValue compare:other.selectValue];
}
@end
