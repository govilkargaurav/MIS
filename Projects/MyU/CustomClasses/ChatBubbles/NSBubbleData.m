//
//  NSBubbleData.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import "NSBubbleData.h"
#import <QuartzCore/QuartzCore.h>
#import <OHAttributedLabel/OHAttributedLabel.h>
#import <OHAttributedLabel/NSAttributedString+Attributes.h>
#import <OHAttributedLabel/OHASBasicHTMLParser.h>
#import <OHAttributedLabel/OHASBasicMarkupParser.h>
#import "UIButton+WebCache.h"
#import "NSString+Utilities.h"

@implementation NSBubbleData

#pragma mark - Properties

@synthesize date = _date;
@synthesize strUserName=_strUserName;
@synthesize type = _type;
@synthesize datatype = _datatype;
@synthesize view = _view;
@synthesize insets = _insets;
@synthesize avatar = _avatar;
@synthesize lblattributed=_lblattributed;
@synthesize strmessage=_strmessage;
@synthesize shouldShowAvtar=_shouldShowAvtar;
@synthesize dateActualSynth= _dateActualSynth;

#pragma mark - Text bubble
const UIEdgeInsets textInsetsMine={5.0,10.0,6.0, 15.0};
const UIEdgeInsets textInsetsSomeone={5.0,15.0,8.0,10.0};

+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type linkdelegate:(id)lnkdelegate username:(NSString *)username showAvtar:(BOOL)showsAvtar dateActual:(NSDate *)DateActual
{
    return [[NSBubbleData alloc] initWithText:text date:date type:type linkdelegate:lnkdelegate username:username showAvtar:showsAvtar dateActual:DateActual];
}

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type linkdelegate:(id)lnkdelegate username:(NSString *)username showAvtar:(BOOL)showsAvtar dateActual:(NSDate *)DateActual
{
    self.lblattributed = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(0.0f,0.0f,195.0,60.0f)];
    
    self.lblattributed.backgroundColor=[UIColor clearColor];
    self.lblattributed.numberOfLines=0.0;
    self.lblattributed.opaque=YES;
    self.lblattributed.delegate=lnkdelegate;
    
    
    
    self.lblattributed.lineBreakMode=NSLineBreakByWordWrapping;
    _lblattributed.catchTouchesOnLinksOnTouchBegan = YES;
    
    NSData *strMessageData = [[text removeNull] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *strTheMessage = [[NSString alloc] initWithData:strMessageData encoding:NSNonLossyASCIIStringEncoding];
    
    if ([[strTheMessage removeNull]length]==0)
    {
        NSMutableAttributedString *attrStrFull = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[text removeNull]]];
        [attrStrFull setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        self.lblattributed.attributedText=attrStrFull;
    }
    else
    {
        NSMutableAttributedString *attrStrFull = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",strTheMessage]];
        [attrStrFull setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        self.lblattributed.attributedText=attrStrFull;
    }

    
    
//    NSMutableAttributedString *attrStrFull=[[NSMutableAttributedString alloc]initWithString:text];
//    [attrStrFull setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
//    self.lblattributed.attributedText=attrStrFull;
    self.strmessage=[NSString stringWithFormat:@"%@",[text removeNull]];
    
    float theHeight=[[self.lblattributed.attributedText heightforAttributedStringWithWidth:195.0]floatValue];
    float theWidth=195.0;
    if (theHeight<25.0)
    {
        theWidth=[[self.lblattributed.attributedText widthforAttributedStringWithHeight:theHeight]floatValue];
    }
    
    CGRect rectAttrib=CGRectMake(0,0,theWidth,theHeight);
    self.lblattributed.frame=rectAttrib;

    UITapGestureRecognizer *tapGest=[[UITapGestureRecognizer alloc]initWithTarget:lnkdelegate action:@selector(lblChatTapped:)];
    tapGest.numberOfTapsRequired=2;
    [self.lblattributed addGestureRecognizer:tapGest];

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:lnkdelegate action:@selector(lblChatPressed:)];
    longPress.minimumPressDuration = 0.5;
    [self.lblattributed addGestureRecognizer:longPress];

    
    UIEdgeInsets insets = (type==BubbleTypeMine?textInsetsMine:textInsetsSomeone);
    return [self initWithView:self.lblattributed date:date type:type insets:insets username:username showAvtar:showsAvtar dateActual:DateActual];
}

-(void)lblChatPressed:(UILongPressGestureRecognizer *)sender
{
    NSLog(@"Hiiiii");
}
-(void)lblChatTapped:(UITapGestureRecognizer *)sender
{
    NSLog(@"Hiiiii 2");
}

#pragma mark - Image bubble
const UIEdgeInsets imageInsetsMine = {2.0,2.5,2.5,7.0};
const UIEdgeInsets imageInsetsSomeone = {2.0,7.0,2.5,2.5};

+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type imglink:(NSString *)imglink  linkdelegate:(id)lnkdelegate  username:(NSString *)username imagetag:(NSInteger)imagetag imagesize:(CGSize)imagesize showAvtar:(BOOL)showsAvtar dateActual:(NSDate *)DateActual
{
    return [[NSBubbleData alloc] initWithImage:image date:date type:type imglink:imglink  linkdelegate:lnkdelegate username:username imagetag:imagetag imagesize:imagesize showAvtar:showsAvtar dateActual:DateActual];
}

- (id)initWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type imglink:(NSString *)imglink  linkdelegate:(id)lnkdelegate username:(NSString *)username imagetag:(NSInteger)imagetag imagesize:(CGSize)imagesize showAvtar:(BOOL)showsAvtar dateActual:(NSDate *)DateActual
{
    CGSize size = imagesize;
//    if (size.width>size.height)
//    {
//        if (size.width>207.0)
//        {
//            size.height*=(207.0/size.width);
//            size.width=207.0;
//        }
//    }
//    else
//    {
//        if (size.height>207.0)
//        {
//            size.width*=(207.0/size.height);
//            size.height=207.0;
//        }
//    }
    
    if (size.width>size.height)
    {
        if (size.width>100.0)
        {
            size.height*=(100.0/size.width);
            size.width=100.0;
        }
    }
    else
    {
        if (size.height>100.0)
        {
            size.width*=(100.0/size.height);
            size.height=100.0;
        }
    }

    
    NSLog(@"Hii the:%@",imglink);
    
    UIButton *btnImageView = [[UIButton alloc] initWithFrame:CGRectMake(0,0,size.width,size.height)];
    [btnImageView setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@",imglink] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageProgressiveDownload];
    if ([[imglink removeNull] length]==0)
    {
        [btnImageView setImage:image forState:UIControlStateNormal];
    }
    
    btnImageView.layer.cornerRadius =4.0;
    btnImageView.layer.masksToBounds = YES;
    btnImageView.tag=imagetag;
    [btnImageView addTarget:lnkdelegate action:@selector(btnImageZoomClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.strmessage=[NSString stringWithFormat:@"photo-encoded"];

    self.datatype=BubbleDataTypeImage;
    UIEdgeInsets insets = (type == BubbleTypeMine ? imageInsetsMine : imageInsetsSomeone);
    return [self initWithView:btnImageView date:date type:type insets:insets username:username showAvtar:showsAvtar dateActual:DateActual];
}

#pragma mark - Custom view bubble

+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets  username:(NSString *)username showAvtar:(BOOL)showsAvtar dateActual:(NSDate *)DateActual
{
    return [[NSBubbleData alloc] initWithView:view date:date type:type insets:insets username:username showAvtar:showsAvtar dateActual:DateActual];
}

- (id)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets username:(NSString *)username showAvtar:(BOOL)showsAvtar dateActual:(NSDate *)DateActual
{
    self = [super init];
    if (self)
    {
        _view = view;
        _date = date;
        _type = type;
        _insets = insets;
        _strUserName=username;
        _shouldShowAvtar=showsAvtar;
        _dateActualSynth =DateActual;
        
    }
    return self;
}

@end
