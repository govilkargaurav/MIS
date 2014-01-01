//
//  SelectFromPianoPass.h
//  PianoApp
//
//  Created by Imac 2 on 7/17/13.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol PassImageDelegate <NSObject>

@optional
-(void)ImagePassForEncrypt:(UIImage*)img;
@end

@interface SelectFromPianoPass : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIScrollView *Scl_Photo;
    IBOutlet UILabel *lblNoPhoto;
    int Xaxis,Yaxis;
    NSUInteger TagLast;
    
    id <PassImageDelegate> _delegate;
}
@property (nonatomic,strong) id <PassImageDelegate> _delegate;

@end
