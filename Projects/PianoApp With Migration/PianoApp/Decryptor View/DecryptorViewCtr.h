//
//  DecryptorViewCtr.h
//  PianoApp
//
//  Created by Imac 2 on 6/1/13.
//
//

#import <UIKit/UIKit.h>

@interface DecryptorViewCtr : UIViewController
{
    IBOutlet UITextView *txtOrifinalText;
    NSString *strText;
    UIImage *imgDecoded;
    IBOutlet UIImageView *imgView;
    IBOutlet UIButton *btnSave;
}
@property(nonatomic,strong)NSString *strText;
@property(nonatomic,strong)UIImage *imgDecoded;

@end
