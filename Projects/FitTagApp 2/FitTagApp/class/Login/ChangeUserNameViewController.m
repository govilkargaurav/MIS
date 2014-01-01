//
//  ChangeUserNameViewController.m
//  FitTag
//
//  Created by Vishal Jani on 10/3/13.
//
//

#import "ChangeUserNameViewController.h"
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.1;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
@interface ChangeUserNameViewController ()

@end

@implementation ChangeUserNameViewController
@synthesize delegate,btnDone,txtUserName;
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtUserName:nil];
    [self setBtnDone:nil];
    [super viewDidUnload];
}
- (IBAction)btnDonePressed:(id)sender {
    NSRange range = [[txtUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] rangeOfString:@" "];
    
    if ([[txtUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ) {
        DisplayAlertWithTitle(@"FitTag", @"Please enter username")
        
    }else if(range.length > 0){
        DisplayAlertWithTitle(@"FitTag", @"Space is not allowed in username.")
        
    }
    else if ([txtUserName.text length] > 12){
        DisplayAlertWithTitle(@"FitTag", @"User name should not exceed 12 Character")
    }
    else{
        [self.delegate userName:self.txtUserName.text];
    }
}

/* To prevent redundancy of Username at login */ 

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField==txtUserName) {
        
        NSRange range = [[txtUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] rangeOfString:@" "];
        
        if ([[txtUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ) {
            DisplayAlertWithTitle(@"FitTag", @"Please enter username")
            
        }else if(range.length > 0){
            DisplayAlertWithTitle(@"FitTag", @"Space is not allowed in username.")
            
        }
        else if ([txtUserName.text length] > 12){
            DisplayAlertWithTitle(@"FitTag", @"User name should not exceed 12 Character")
        }
        else{
            [txtUserName resignFirstResponder];
            [self.delegate userName:self.txtUserName.text];
        }
    }
    return YES;
}
#pragma mark TextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect textFieldRect =[self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =[self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 1.0 * textFieldRect.size.height;
    CGFloat numerator =midline - viewRect.origin.y- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)* viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    animatedDistance = floor(110.0 * heightFraction);
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
@end
