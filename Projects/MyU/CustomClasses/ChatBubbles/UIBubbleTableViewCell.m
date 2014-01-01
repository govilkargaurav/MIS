//
//  UIBubbleTableViewCell.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <QuartzCore/QuartzCore.h>
#import "UIBubbleTableViewCell.h"
#import "NSBubbleData.h"

static const CFTimeInterval kLongPressMinimumDurationSeconds = 0.3;

@interface UIBubbleTableViewCell(Private)
- (void) initialize;
- (void) menuWillHide:(NSNotification *)notification;
- (void) menuWillShow:(NSNotification *)notification;
- (void) handleLongPress:(UILongPressGestureRecognizer *)longPressRecognizer;
@end

@interface UIBubbleTableViewCell ()
@property (nonatomic, retain) UIImageView *bubbleImage;
@property (nonatomic, retain) UIImageView *avatarImage;
@property (nonatomic, retain) UILabel *lblTime;
@property (nonatomic, retain) UILabel *lblUserName;

-(void)setupInternalData;

@end

@implementation UIBubbleTableViewCell
@synthesize data = _data;
@synthesize customView = _customView;
@synthesize bubbleImage = _bubbleImage;
@synthesize showAvatar = _showAvatar;
@synthesize avatarImage = _avatarImage;
@synthesize lblTime=_lblTime;
@synthesize lblUserName=_lblUserName;
@synthesize strCopy=_strCopy;

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
	[self setupInternalData];
}

- (void)setDataInternal:(NSBubbleData *)value
{
	self.data = value;
	[self setupInternalData];
}

- (void) setupInternalData
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    if (!self.bubbleImage)
    {
        self.bubbleImage = [[UIImageView alloc] init];
        [self addSubview:self.bubbleImage];
    }
    
    NSBubbleType type = self.data.type;
    NSBubbleDataType datatype=self.data.datatype;
    
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;

    CGFloat x = (type == BubbleTypeSomeoneElse) ? 0 : self.frame.size.width - width - self.data.insets.left - self.data.insets.right;
    CGFloat y = 0;
    
    //self.showAvatar;
    // Adjusting the x coordinate for avatar
    if (self.showAvatar)
    {
        [self.avatarImage removeFromSuperview];
        self.avatarImage = [[UIImageView alloc] init];
                            
        if ([[self.data.avatar removeNull] length]==0) {
            self.avatarImage.image = [UIImage imageNamed:@"default_user"];
        }
        else
        {
            self.avatarImage.tag=107;
            [self.avatarImage setImageWithURL:[NSURL URLWithString:[[[NSString stringWithFormat:@"%@",self.data.avatar] removeNull] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_user"] options:SDWebImageRefreshCached];
        }
        
        self.avatarImage.layer.cornerRadius = 4.0;
        self.avatarImage.layer.masksToBounds = YES;
        self.avatarImage.layer.borderColor = [UIColor grayColor].CGColor;
        self.avatarImage.layer.borderWidth = 1.0;
        
        CGFloat avatarX = (type==BubbleTypeSomeoneElse)?5.0:self.frame.size.width-46.0;
        CGFloat avatarY = self.frame.size.height-41.0;
        self.avatarImage.frame = CGRectMake(avatarX, avatarY-iOS7ExHeight,41.0,41.0);
        [self addSubview:self.avatarImage];
        
        CGRect rectName=self.avatarImage.frame;
        rectName.origin.y+=rectName.size.height;
        rectName.size.height=MIN([self.data.strUserName sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:9.0] constrainedToSize:CGSizeMake(rectName.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByTruncatingTail].height,22.0);
        
        [self.lblUserName removeFromSuperview];
        self.lblUserName = [[UILabel alloc] initWithFrame:rectName];
        self.lblUserName.text = self.data.strUserName;
        self.lblUserName.numberOfLines=2.0;
        self.lblUserName.font = [UIFont fontWithName:@"Helvetica-Bold" size:9.0];
        self.lblUserName.textAlignment = (type==BubbleTypeSomeoneElse)?NSTextAlignmentLeft:NSTextAlignmentRight;
        //self.lblUserName.shadowOffset = CGSizeMake(0,1);
        //self.lblUserName.shadowColor = [UIColor whiteColor];
        self.lblUserName.textColor = RGBCOLOR(96.0, 116.0, 128.0);
        self.lblUserName.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.lblUserName];
        
        self.avatarImage.alpha=(self.data.shouldShowAvtar)?1.0:0.0;
        self.lblUserName.alpha=(self.data.shouldShowAvtar)?1.0:0.0;
        
        if (self.data.shouldShowAvtar)
        {
            CGFloat delta = self.frame.size.height-(self.data.insets.top+self.data.insets.bottom+self.data.view.frame.size.height);
            if(delta>0)y=delta;
        }
  
        if(type==BubbleTypeSomeoneElse)x+=49.0;
        if(type==BubbleTypeMine)x-=49.0;
    }

    [self.customView removeFromSuperview];
    self.customView = self.data.view;
    self.customView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top-iOS7ExHeight, width, height);
    [self.contentView addSubview:self.customView];

    [self.lblTime removeFromSuperview];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSString *text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:self.data.dateActualSynth]];
    CGRect rectImageCell=CGRectMake(((type==BubbleTypeSomeoneElse)?(self.customView.frame.origin.x+self.customView.frame.size.width+4.0):(self.customView.frame.origin.x-63.0)),self.customView.frame.origin.y+self.customView.frame.size.height-15.0,58.0,15.0);
    CGRect rectTextCell=CGRectMake(((type==BubbleTypeSomeoneElse)?(self.customView.frame.origin.x+self.customView.frame.size.width+12.0):(self.customView.frame.origin.x-72.0)),self.customView.frame.origin.y+self.customView.frame.size.height-9.0,58.0,15.0);
    
    self.lblTime = [[UILabel alloc] initWithFrame:(datatype==BubbleDataTypeImage)?rectImageCell:rectTextCell];
    self.lblTime.text = text;
    self.lblTime.font = [UIFont fontWithName:@"Helvetica-Light" size:8.0];
    self.lblTime.textAlignment = (type==BubbleTypeSomeoneElse)?NSTextAlignmentLeft:NSTextAlignmentRight;
    self.lblTime.shadowOffset = CGSizeMake(0,1);
    self.lblTime.shadowColor = [UIColor whiteColor];
    self.lblTime.textColor = [UIColor blackColor];
    self.lblTime.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.lblTime];
    
    if (type==BubbleTypeSomeoneElse)
    {
        self.bubbleImage.image = [ [UIImage imageNamed:@"bubbleSomeone.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0,15.0, 18.0, 15.0)];
    }
    else
    {
        self.bubbleImage.image = [ [UIImage imageNamed:@"bubbleMine.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0,15.0, 18.0, 15.0)];
    }

    self.bubbleImage.frame = CGRectMake(x, y-iOS7ExHeight, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom);
    
    delegate = nil;
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.strCopy=[NSString stringWithFormat:@"%@",self.data.strmessage];
    
    if (![self.strCopy isEqualToString:@"photo-encoded"])
    {
        UILongPressGestureRecognizer *recognizer =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [recognizer setMinimumPressDuration:kLongPressMinimumDurationSeconds];
        [self addGestureRecognizer:recognizer];
    }
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:))
    {
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}
-(void)copy:(id)sender
{
//    if ((delegate!=nil) && [delegate respondsToSelector:@selector(copyableCell:dataForCellAtIndexPath:)]) {
//        //NSString *dataText = [delegate copyableCell:self dataForCellAtIndexPath:self.indexPath];
//        [[UIPasteboard generalPasteboard] setString:@"Sample text..."];
//    }
    
    if (self.strCopy != nil) {
        [[UIPasteboard generalPasteboard] setString:self.strCopy];
    }
    
    [self resignFirstResponder];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}
-(BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self isFirstResponder] == NO)
    {
        return;
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
    [menu update];
    [self resignFirstResponder];
}

- (void) menuWillHide:(NSNotification *)notification
{
    if ((delegate != nil) && [delegate respondsToSelector:@selector(copyableCell:deselectCellAtIndexPath:)]) {
        //[delegate copyableCell:self deselectCellAtIndexPath:self.indexPath];
    }
    
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
}

- (void) menuWillShow:(NSNotification *)notification
{
    //self.selectionStyle = UITableViewCellSelectionStyleBlue;
    if ((delegate != nil) && [delegate respondsToSelector:@selector(copyableCell:selectCellAtIndexPath:)]) {
        //[delegate copyableCell:self selectCellAtIndexPath:self.indexPath];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuWillHide:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}


#pragma mark -
#pragma mark UILongPressGestureRecognizer Handler Methods

- (void) handleLongPress:(UILongPressGestureRecognizer *)longPressRecognizer
{
    if (longPressRecognizer.state != UIGestureRecognizerStateBegan)
    {
        return;
    }
    
    if ([self becomeFirstResponder] == NO)
    {
        return;
    }
    
    if (![self.strCopy isEqualToString:@"photo-encoded"])
    {
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:CGRectMake(self.bounds.origin.x, self.bounds.origin.y+12.0, self.bounds.size.width, self.bounds.size.height-20.0) inView:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(menuWillShow:)
                                                     name:UIMenuControllerWillShowMenuNotification
                                                   object:nil];
        [menu setMenuVisible:YES animated:YES];
    }
}


@end
