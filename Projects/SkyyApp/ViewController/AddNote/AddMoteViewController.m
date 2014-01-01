//
//  AddMoteViewController.m
//  SkyyApp
//
//  Created by Vishal Jani on 9/5/13.
//  Copyright (c) 2013 openxcell. All rights reserved.
//
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.1;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
#import "AddMoteViewController.h"

@interface AddMoteViewController ()
{
    UIToolbar *toolBar;
    UIDatePicker *pickerDateTime;
    
}
@end

@implementation AddMoteViewController
@synthesize delegate,isEdit,strEdit;
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
    self.navigationController.navigationBarHidden=NO;
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    recognizer.delegate = self;
    newView.layer.borderWidth=2;
    newView.layer.borderColor=[[UIColor colorWithRed:245.0/255.0 green:179.0/255.0 blue:51.0/255.0 alpha:1.0]CGColor];
    //Add
    //
    if (self.isEdit==TRUE) {
        txtNoteView.text=self.strEdit;
    }
    [self.view bringSubviewToFront:btnClose];
    [btnSave addGestureRecognizer:recognizer];
    [lblTextCount setFont:CustomfontSemibold(15)];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /* TOOLBAR IS FOR SEARCHING PICKER'S TOOLBAR */
    
    toolBar=[[UIToolbar alloc] init];
    toolBar.frame=CGRectMake(30,568, 282, 44);
    toolBar.barStyle=UIBarStyleBlack;
    //toolBar.barTintColor=[UIColor blackColor];
    toolBar.backgroundColor=[UIColor blackColor];
	[self.view addSubview:toolBar];
    
    UIBarButtonItem *item11 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CanclePressed)];
    UIBarButtonItem *itemSaprator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *item12 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(DonePressed)];
	NSArray *buttons1 = [NSArray arrayWithObjects: item11,itemSaprator, item12, nil];
    [toolBar setItems: buttons1 animated:NO];
    
    pickerDateTime = [[UIDatePicker alloc] init];
    pickerDateTime.frame=CGRectMake(30, 568, 282, 216);
    pickerDateTime.backgroundColor=[UIColor whiteColor];
    pickerDateTime.backgroundColor=[UIColor grayColor];
    pickerDateTime.datePickerMode = UIDatePickerModeDateAndTime;
    [self.view addSubview:pickerDateTime];
    /************************************************************************************************************************************/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)btnCanclePressed:(id)sender{
    [txtNoteView resignFirstResponder];
    [self.delegate cancelSendNote];
}

-(IBAction) setNotificationValue:(id)sender{
    [txtNoteView resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    if ([UIScreen mainScreen].bounds.size.height == 568.0) {
        toolBar.frame=CGRectMake(30,[UIScreen mainScreen].bounds.size.height-250, 282, 44);
    }else{
        toolBar.frame=CGRectMake(30,[UIScreen mainScreen].bounds.size.height-200, 282, 44);
    }
    pickerDateTime.frame=CGRectMake(30,toolBar.frame.origin.y+44, 282, 216);
    [pickerDateTime setBackgroundColor:[UIColor whiteColor]];
    [UIView commitAnimations];
}

-(void)CanclePressed
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    toolBar.frame=CGRectMake(30,568, 282, 44);
    toolBar.frame=CGRectMake(30,568, 282, 44);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    pickerDateTime.frame=CGRectMake(30,568, 282, 216);
    [UIView commitAnimations];
}

-(void)DonePressed
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    
    toolBar.frame=CGRectMake(30,568, 282, 44);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    
    pickerDateTime.frame=CGRectMake(30,toolBar.frame.origin.y+44, 282, 216);
    [UIView commitAnimations];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-yyyy hh:mm:ss a"];
    strDateTime=[NSString stringWithFormat:@"%@",
                       [df stringFromDate:pickerDateTime.date]];
    
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _originalCenter = btnSave.center;
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:btnSave];
        btnSave.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        _markCompleteOnDragRelease = btnSave.frame.origin.x > btnSave.frame.size.width / 2;
        _deleteOnDragRelease = btnSave.frame.origin.x < -btnSave.frame.size.width / 2;
		
		float cueAlpha = fabsf(btnSave.frame.origin.x) / (btnSave.frame.size.width / 2);
		_tickLabel.alpha = cueAlpha;
		_crossLabel.alpha = cueAlpha;
     }
  
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGRect originalFrame = CGRectMake(9, btnSave.frame.origin.y,
                                          btnSave.bounds.size.width, btnSave.bounds.size.height);
      
        if (!_deleteOnDragRelease) {
            [UIView animateWithDuration:0.2
                             animations:^{
                                 btnSave.frame = originalFrame;
                             }
             ];
        }
		if (_deleteOnDragRelease) {
		  
            [UIView animateWithDuration:0.2
                             animations:^{
                                 btnSave.frame = originalFrame;
                             }
             ];
            [txtNoteView resignFirstResponder];
            if (self.isEdit==TRUE) {
                [self.delegate swipwToEditNote:txtNoteView.text];

            }else{
                [self.delegate swipwToSaveNote:txtNoteView.text];

            }
        }
        if (_markCompleteOnDragRelease) {
            [txtNoteView resignFirstResponder];
            if (self.isEdit==TRUE) {
                 [self.delegate swipwToEditNote:txtNoteView.text];
            }else{
                [self.delegate swipeToRightToSaveOnlyHome:txtNoteView.text];
                
            }
        }
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
 /*   CGRect textFieldRect =[self.view.window convertRect:textView.bounds fromView:textView];
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
    [UIView commitAnimations];*/
}

- (void)textViewDidEndEditing:(UITextView *)textView{
   /* CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];*/
    
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
@end
