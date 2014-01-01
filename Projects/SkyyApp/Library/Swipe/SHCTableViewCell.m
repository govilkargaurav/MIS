//
//  SHCTableViewCell.m
//  ClearStyle
//
//  Created by Fahim Farook on 23/9/12.
//  Copyright (c) 2012 RookSoft Pte. Ltd. All rights reserved.
//

#import "SHCTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SHCStrikethroughLabel.h"

@implementation SHCTableViewCell {
    CAGradientLayer* _gradientLayer;
	CGPoint _originalCenter;
	BOOL _deleteOnDragRelease;
	
	CALayer *_itemCompleteLayer;
	BOOL _markCompleteOnDragRelease;
	UILabel *_tickLabel;
	
}

const float UI_CUES_MARGIN = 10.0f;
const float UI_CUES_WIDTH = 50.0f;
@synthesize contentViews,arrow,actionViews,doubleTapView,_crossLabel,_label;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // add a tick and cross
        
    
        
        AppDelegate *appDelegate=(AppDelegate *) [[UIApplication sharedApplication]delegate];
    
        doubleTapView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        _tickLabel = [self createCueLabel];
        _tickLabel.text = appDelegate.currentRightClass;
       // _tickLabel.font=CustomfontSemibold(20);
        _tickLabel.font=CustomfontLight(20);
        _tickLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_tickLabel];
        _crossLabel = [self createCueLabel];
        _crossLabel.text = appDelegate.currentLeftClass;
       // _crossLabel.font=CustomfontSemibold(20);
        _crossLabel.font=CustomfontLight(20);
        
        _crossLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_crossLabel];
		// create a label that renders the todo item text
		_label = [[SHCStrikethroughLabel alloc] initWithFrame:CGRectNull];
		_label.textColor = [UIColor darkGrayColor];
        
     
		//_label.font = CustomfontSemibold(18);
        _label.font ==CustomfontLight(18);
		_label.backgroundColor = [UIColor clearColor];
        [self addSubview:doubleTapView];
		[doubleTapView addSubview:_label];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        // add a layer that overlays the cell adding a subtle gradient effect
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
      //  _gradientLayer.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
        _gradientLayer.locations = @[@0.00f, @0.01f, @0.95f, @1.00f];
        [self.layer insertSublayer:_gradientLayer atIndex:0];
		// add a layer that renders a green background when an item is complete
		_itemCompleteLayer = [CALayer layer];
		_itemCompleteLayer.hidden = YES;
		[self.layer insertSublayer:_itemCompleteLayer atIndex:0];
		// add a pan recognizer
		UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
		recognizer.delegate = self;
		[self addGestureRecognizer:recognizer];
    }
    return self;
}

const float LABEL_LEFT_MARGIN = 15.0f;

-(void)layoutSubviews {
    [super layoutSubviews];
    // ensure the gradient layers occupies the full bounds
    _gradientLayer.frame = self.bounds;
    _itemCompleteLayer.frame = self.bounds;
//    _label.frame = CGRectMake(LABEL_LEFT_MARGIN, 0,self.bounds.size.width - LABEL_LEFT_MARGIN,self.bounds.size.height);
  
    _label.frame = CGRectMake(10, 5, 280, 30);
    _tickLabel.frame = CGRectMake(-UI_CUES_WIDTH - UI_CUES_MARGIN, 0,UI_CUES_WIDTH, 44);
    _crossLabel.frame = CGRectMake(self.bounds.size.width + UI_CUES_MARGIN, 0,100, 44);
}

-(void)setTodoItem:(SHCToDoItem *)todoItem {
    _todoItem = todoItem;
    // we must update all the visual state associated with the model item
    _label.text = todoItem.text;
   // _label.strikethrough = todoItem.completed;
    //_itemCompleteLayer.hidden = !todoItem.completed;
}

// utility method for creating the contextual cues
-(UILabel*) createCueLabel {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 21)];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont boldSystemFontOfSize:16.0];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

#pragma mark - horizontal pan gesture methods
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
   // CGPoint translation = [gestureRecognizer locationInView:[self superview]];
    // Check for horizontal gesture
    //CGPoint velocity = [gestureRecognizer locationInView:[self superview]];
    CGPoint velocity = [gestureRecognizer locationOfTouch:0 inView:[self superview]];

    if(velocity.x < 70 || velocity.x > 150)
    {
         return YES;
    }
    else if (velocity.x >70 && velocity.x <150)
    {
        return NO;
    }
    return NO;
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//          // NSLog(@"gestureRecognizer.view==%@",gestureRecognizer.view);
//   
//      //  NSLog(@"otherGestureRecognizer.view==%@",otherGestureRecognizer);
//   
//    
//    return YES; //otherGestureRecognizer is your custom pan gesture
//}

/*-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
        
    CGPoint translation = [gestureRecognizer locationInView:[self superview]];
    // Check for horizontal gesture
    if (fabsf(translation.x) > fabsf(translation.y)) {
        return YES;
    }
    return NO;
}*/


-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
		// if the gesture has just started, record the current centre location
        _originalCenter = self.center;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        // translate the center
        CGPoint translation = [recognizer translationInView:self];
        self.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        // determine whether the item has been dragged far enough to initiate a delete / complete
        _markCompleteOnDragRelease = self.frame.origin.x > self.frame.size.width / 2;
        _deleteOnDragRelease = self.frame.origin.x < -self.frame.size.width / 2;
		// Context cues
		// fade the contextual cues
		float cueAlpha = fabsf(self.frame.origin.x) / (self.frame.size.width / 2);
		_tickLabel.alpha = cueAlpha;
		_crossLabel.alpha = cueAlpha;
        
		// indicate when the item have been pulled far enough to invoke the given action
	//	_tickLabel.textColor = _markCompleteOnDragRelease ?
     //   [UIColor greenColor] : [UIColor whiteColor];
	//	_crossLabel.textColor = _deleteOnDragRelease ?
    //    [UIColor redColor] : [UIColor whiteColor];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // the frame this cell would have had before being dragged
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y,
                                          self.bounds.size.width, self.bounds.size.height);
        if (!_deleteOnDragRelease) {
            // if the item is not being deleted, snap back to the original location
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
             ];
        }
		if (_deleteOnDragRelease) {
			// notify the delegate that this item should be deleted
			[self.delegate toDoItemDeleted:self.todoItem];
		}
        if (_markCompleteOnDragRelease) {
            // mark the item as complete and update the UI state
            self.todoItem.completed = YES;
//            _itemCompleteLayer.hidden = NO;
//            _label.strikethrough = YES;
            [self.delegate toDoItemDeleted:self.todoItem];
        }
    }
}

- (void) expandActionView
{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, contentViews.frame.size.height + actionViews.frame.size.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2];
    
    [actionViews setFrame:CGRectMake(actionViews.frame.origin.x, contentViews.frame.size.height, actionViews.frame.size.width, actionViews.frame.size.height)];
    
    [arrow setFrame:CGRectMake((self.frame.size.width - arrow.frame.size.width)/2, (contentViews.frame.size.height - arrow.frame.size.height), arrow.frame.size.width, arrow.frame.size.height)];
    [arrow setAlpha:1.0f];
    
    [UIView commitAnimations];
}
- (void) collapseActionViews
{
    
}


@end
