//
//  ProductiivyViewCtr.m
//  OrganiseMee_iPhone
//
//  Created by Mac-i7 on 1/16/13.
//  Copyright (c) 2013 Mac-i7. All rights reserved.
//

#import "ProductivityViewCtr.h"
#import "ProductivityWebViewCtr.h"
#import "AppDelegate.h"
#import "GlobalMethods.h"

@interface ProductivityViewCtr ()

@end

@implementation ProductivityViewCtr

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
    if ([GlobalMethods CheckPhoneVersionisiOS7])
    {
        scl_bg.frame = CGRectMake(scl_bg.frame.origin.x, scl_bg.frame.origin.y + 20, scl_bg.frame.size.width, scl_bg.frame.size.height  - 20);
    }
    NSAttributedString* attrStr2 =[[NSAttributedString alloc] initWithString:@"Organizing tips on our website" attributes: @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    lblLink2.attributedText = attrStr2;

    NSAttributedString* attrStr =
    [[NSAttributedString alloc] initWithString:@"Organizing tips and conversation about organisemee on Twitter"
                                    attributes: @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    lblLink1.attributedText = attrStr;
}
- (void)viewWillAppear:(BOOL)animated
{
    // Lang Data Get n Display
    mainDict = [ NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"language" ofType:@"plist"]];
    UserLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageSetting"];
    if([UserLanguage isEqualToString:@"de"])
    {
        AppDel.langDict = [mainDict objectForKey:@"de"];
        localizationDict = [AppDel.langDict objectForKey:@"ProductivityVC"];
        lblTitle.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lbltitle"]];
        lblSubTitle.text = [NSString stringWithFormat:@"%@",[localizationDict valueForKey:@"lblproductivitysubtitle"]];
        NSAttributedString* attrStr =
        [[NSAttributedString alloc] initWithString:@"Tipp zum Organisieren sowie Informationen zu Organisemee bei Twitter"
                                        attributes: @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
        lblLink1.attributedText = attrStr;
        NSAttributedString* attrStr2 =
        [[NSAttributedString alloc] initWithString:@"Tipp zum Organisieren auf unserer Webseite"
                                        attributes: @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
        lblLink2.attributedText = attrStr2;
    }
    
    [self updateui];
}

#pragma mark - IBAction Methods

-(IBAction)btnWebViewPressed:(id)sender
{
    ProductivityWebViewCtr *obj_ProductivityWebViewCtr = [[ProductivityWebViewCtr alloc]initWithNibName:@"ProductivityWebViewCtr" bundle:nil];
    if ([sender tag] == 1)
    {
        obj_ProductivityWebViewCtr.strLink = @"http://www.Twitter.com";
    }
    else if ([sender tag] == 2)
    {
        obj_ProductivityWebViewCtr.strLink = @"http://organisemee.com/";
    }
    [self.navigationController pushViewController:obj_ProductivityWebViewCtr animated:YES];
}

#pragma mark - UIInterfaceOrientation For iOS < 6

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}
#pragma mark - UIInterfaceOrientation For iOS 6

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
-(BOOL)shouldAutorotate
{
    return YES;
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateui];
}
#pragma mark - Set Landscape Frame

-(void)updateui
{
    if ((self.interfaceOrientation==UIInterfaceOrientationPortrait) || (self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown))
    {
        lbllineLink11.frame = CGRectMake(20, 157, 280, 1);
        lbllineLink12.frame = CGRectMake(20, 177, 167, 1);
        lbllineLink12.hidden = NO;
        if([UserLanguage isEqualToString:@"de"])
            lbllineLink2.frame = CGRectMake(20, 238, 280, 1);
        else
            lbllineLink2.frame = CGRectMake(20, 238, 216, 1);
    }
    else if((self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (self.interfaceOrientation==UIInterfaceOrientationLandscapeRight))
    {
        if([UserLanguage isEqualToString:@"de"])
        {
            if (isiPhone5)
            {
                lbllineLink11.frame = CGRectMake(20, 167, 450, 1);
                lbllineLink12.hidden = YES;
                lbllineLink2.frame = CGRectMake(20, lbllineLink2.frame.origin.y, 280, 1);
            }
            else
            {
                lbllineLink11.frame = CGRectMake(20, 157, 400, 1);
                lbllineLink12.frame = CGRectMake(20, lbllineLink12.frame.origin.y, 45, 1);
                lbllineLink2.frame = CGRectMake(20, lbllineLink2.frame.origin.y, 280, 1);
            }
        }
        else
        {
            if (isiPhone5)
            {
                lbllineLink11.frame = CGRectMake(20, 167, 450, 1);
                lbllineLink12.hidden = YES;
            }
            else
            {
                lbllineLink11.frame = CGRectMake(20, 157, 400, 1);
                lbllineLink12.frame = CGRectMake(20, lbllineLink12.frame.origin.y, 45, 1);
                lbllineLink2.frame = CGRectMake(20, lbllineLink2.frame.origin.y, 216, 1);
            }
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UILabel *)setLabelUnderline:(UILabel *)label{
    CGSize expectedLabelSize = [label.text sizeWithFont:label.font constrainedToSize:label.frame.size lineBreakMode:label.lineBreakMode];
    UIView *viewUnderline=[[UIView alloc] init];
    CGFloat xOrigin=0;
    switch (label.textAlignment) {
        case NSTextAlignmentCenter:
            xOrigin=(label.frame.size.width - expectedLabelSize.width)/2;
            break;
        case NSTextAlignmentLeft:
            xOrigin=0;
            break;
        case NSTextAlignmentRight:
            xOrigin=label.frame.size.width - expectedLabelSize.width;
            break;
        default:
            break;
    }
    viewUnderline.frame=CGRectMake(xOrigin,
                                   expectedLabelSize.height-1,
                                   expectedLabelSize.width,
                                   1);
    viewUnderline.backgroundColor=label.textColor;
    [label addSubview:viewUnderline];
    return label;
}

@end
