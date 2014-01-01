//
//  CustomCellTarget.h
//  AIS
//
//  Created by ankit patel on 4/5/12.
//  Copyright 2012 koenxcell. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCellTarget : UITableViewCell {
    
        IBOutlet UILabel *lbl1;
        IBOutlet UILabel *lbl2;
        IBOutlet UILabel *lbl3;
    
}

@property(nonatomic, retain)IBOutlet UILabel *lbl1;
@property(nonatomic, retain)IBOutlet UILabel *lbl2;
@property(nonatomic, retain)IBOutlet UILabel *lbl3;

@end
