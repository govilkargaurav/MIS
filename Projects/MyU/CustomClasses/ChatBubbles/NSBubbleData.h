//
//  NSBubbleData.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <Foundation/Foundation.h>
#import <OHAttributedLabel/OHAttributedLabel.h>

typedef enum _NSBubbleType
{
    BubbleTypeMine = 0,
    BubbleTypeSomeoneElse = 1
} NSBubbleType;

typedef enum _NSBubbleDataType
{
    BubbleDataTypeText = 0,
    BubbleDataTypeImage = 1
} NSBubbleDataType;

@interface NSBubbleData : NSObject

@property (readonly, nonatomic, strong) NSDate *date;
@property (readonly, nonatomic) NSBubbleType type;
@property (readwrite, nonatomic) NSBubbleDataType datatype;
@property (nonatomic,strong) NSString *strUserName;
@property (readonly, nonatomic, strong) UIView *view;
@property (readonly, nonatomic) UIEdgeInsets insets;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic,strong) OHAttributedLabel *lblattributed;
@property (nonatomic,strong) NSString *strmessage;
@property (nonatomic,readwrite) BOOL shouldShowAvtar;
@property (nonatomic,strong)NSDate *dateActualSynth;

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type linkdelegate:(id)lnkdelegate username:(NSString *)username showAvtar:(BOOL)showsAvtar dateActual:(NSDate *)DateActual;
+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type linkdelegate:(id)lnkdelegate username:(NSString *)username showAvtar:(BOOL)showsAvtar dateActual:(NSDate *)DateActual;
- (id)initWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type imglink:(NSString *)imglink  linkdelegate:(id)lnkdelegate username:(NSString *)username imagetag:(NSInteger)imagetag imagesize:(CGSize)imagesize showAvtar:(BOOL)showsAvtar dateActual:(NSDate *)DateActual;
+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type imglink:(NSString *)imglink  linkdelegate:(id)lnkdelegate username:(NSString *)username imagetag:(NSInteger)imagetag imagesize:(CGSize)imagesize showAvtar:(BOOL)showsAvtar dateActual:(NSDate *)DateActual;
- (id)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets username:(NSString *)username showAvtar:(BOOL)showsAvtar dateActual:(NSDate *)DateActual;
+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets username:(NSString *)username showAvtar:(BOOL)showsAvtar dateActual:(NSDate *)DateActual;

@end
