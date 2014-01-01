//
//  DatePickerViewCtr.h
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/26/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IIViewDeckController.h"

@protocol DatePickerDelegate <NSObject>

-(void)DeleteExisteingDate;
-(void)Done:(NSString*)strDate str:(NSString*)StrDueDateSave;


@end

@interface DatePickerViewCtr : UIViewController <IIViewDeckControllerDelegate>
{
    //DatePicker
    
    IBOutlet UIDatePicker *DatepickerView;
    
    id <DatePickerDelegate> _delegate; 
}
@property (nonatomic,strong) id <DatePickerDelegate> _delegate;

@end
