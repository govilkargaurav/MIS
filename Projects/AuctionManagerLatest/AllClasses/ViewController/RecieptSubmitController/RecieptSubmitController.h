//
//  RecieptSubmitController.h
//  PropertyInspector
//
//  Created by apple on 11/3/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+XMLParser.h"

@interface RecieptSubmitController : UIViewController<UIImagePickerControllerDelegate,XMLParseEventHandler>{
    
    XMLParser *parser;
    UIImage *img;
    UIImage *reducedImg;
    
}
@property(nonatomic,strong)NSData *dataImage;
@property(nonatomic,strong)NSString *propertyID;
@property (nonatomic, retain) UIImage *img;
@property (nonatomic, retain) UIImage *reducedImg;

@end
