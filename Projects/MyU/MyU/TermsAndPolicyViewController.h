//
//  TermsAndPolicyViewController.h
//  MyU
//
//  Created by Vijay on 7/9/13.
//  Copyright (c) 2013 Vijay Hirpara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    TermsPage,
    PrivacyPage
} PageType;

@interface TermsAndPolicyViewController : UIViewController

@property (nonatomic,readwrite) PageType pagetype;

@end
