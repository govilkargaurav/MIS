//
//  SubNoteViewController.m
//  SkyyApp
//
//  Created by Vishal Jani on 9/10/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.1;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
#import "SubNoteViewController.h"

@interface SubNoteViewController ()

@end

@implementation SubNoteViewController
@synthesize delegate;
@synthesize index,isEditSubNote,strSubNote;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    newView.layer.borderWidth=2;
    newView.layer.borderColor=[[UIColor colorWithRed:245.0/255.0 green:179.0/255.0 blue:51.0/255.0 alpha:1.0]CGColor];
    
    [self.view bringSubviewToFront:btnCancel];
    [lblTextCount setFont:CustomfontSemibold(15)];
    btnSend.titleLabel.font=CustomfontSemibold(15);
    if (self.isEditSubNote==TRUE) {
    
        txtSubNoteView.text=self.strSubNote;
    }
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    recognizer.delegate = self;
    [btnSend addGestureRecognizer:recognizer];
    
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)sendPressed:(id)sender{
    [txtSubNoteView resignFirstResponder];
    if (self.isEditSubNote==TRUE) {
        [self.delegate sendEditSubnote:txtSubNoteView.text selectIndex:self.index];
    }else{
        [self.delegate sendSubnote:txtSubNoteView.text selectIndex:self.index];
    }

}
-(IBAction)btnCanclePressed:(id)sender{
    [txtSubNoteView resignFirstResponder];
    [self.delegate cancelSubNote];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{

    CGRect textFieldRect =[self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect =[self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 1.0 * textFieldRect.size.height;
    CGFloat numerator =midline - viewRect.origin.y- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)* viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    animatedDistance = floor(100.0 * heightFraction);
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    
    if(newLength <= 25){
        lblTextCount.text = [NSString stringWithFormat:@"%d/25",newLength];
    }
    else{
        return NO;
    }
    return YES;
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
    //    if (recognizer.state ==UIGestureRecognizerStateEnded || recognizer.state==UIGestureRecognizerStateFailed) {
    //        return;
    //    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _originalCenter = btnSend.center;
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:btnSend];
        btnSend.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        _markCompleteOnDragRelease = btnSend.frame.origin.x > btnSend.frame.size.width / 2;
        _deleteOnDragRelease = btnSend.frame.origin.x < -btnSend.frame.size.width / 2;
		
		float cueAlpha = fabsf(btnSend.frame.origin.x) / (btnSend.frame.size.width / 2);
		_tickLabel.alpha = cueAlpha;
		_crossLabel.alpha = cueAlpha;
        
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGRect originalFrame = CGRectMake(9, btnSend.frame.origin.y,
                                          btnSend.bounds.size.width, btnSend.bounds.size.height);
        
        if (!_deleteOnDragRelease) {
            [UIView animateWithDuration:0.2
                             animations:^{
                                 btnSend.frame = originalFrame;
                             }
             ];
        }
		if (_deleteOnDragRelease) {
            
            [UIView animateWithDuration:0.2
                             animations:^{
                                 btnSend.frame = originalFrame;
                             }
             ];
            [txtSubNoteView resignFirstResponder];
            if (self.isEditSubNote==TRUE) {
                [self.delegate sendEditSubnote:txtSubNoteView.text selectIndex:self.index];
            }else{
                [self.delegate sendSubnote:txtSubNoteView.text selectIndex:self.index];
            }

        }
        if (_markCompleteOnDragRelease) {
            [txtSubNoteView resignFirstResponder];
            if (self.isEditSubNote==TRUE) {
                [self.delegate sendEditSubnote:txtSubNoteView.text selectIndex:self.index];
            }else{
                [self.delegate sendSubnote:txtSubNoteView.text selectIndex:self.index];
            }

        }
    }
}


@end
