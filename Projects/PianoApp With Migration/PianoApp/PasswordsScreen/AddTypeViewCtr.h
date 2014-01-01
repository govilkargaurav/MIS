//
//  AddTypeViewCtr.h
//  PianoApp
//
//  Created by Apple-Openxcell on 8/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
@interface AddTypeViewCtr : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *tftype;
    NSString *strSet;
    IBOutlet UIButton *btnSave;
}
@property(nonatomic,strong)NSString *strSet;
@end
