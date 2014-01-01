//
//  MasterViewController.m
//  PianoApp
//
//  Created by Apple-Openxcell on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "HomeScreenViewCtr.h"
#import "GlobalMethods.h"

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.view setMultipleTouchEnabled:YES];

    ArrySetPasscode=[[NSMutableArray alloc]init];
    settag1=settag2=settag3=settag4=settag5=settag6=settag7=0;
    settag11=settag12=settag13=settag14=settag15=settag16=settag17=settag18=settag19=settag20=settag21=settag22=0;
    ReVerifySet=0;

    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"EnablLbl"] == 0)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"EnablLbl"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"EnablSound"] == 0) 
    {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"EnablSound"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self CallSetImgEnable];
    TimerImg.transform = CGAffineTransformMakeRotation (-(3.14)/2);
    lblA.transform = CGAffineTransformMakeRotation (-(3.14)/2);
    lblB.transform = CGAffineTransformMakeRotation (-(3.14)/2);
    lblC.transform = CGAffineTransformMakeRotation (-(3.14)/2);
    lblD.transform = CGAffineTransformMakeRotation (-(3.14)/2);
    lblE.transform = CGAffineTransformMakeRotation (-(3.14)/2);
    lblF.transform = CGAffineTransformMakeRotation (-(3.14)/2);
    lblG.transform = CGAffineTransformMakeRotation (-(3.14)/2);
    lblA1.transform = CGAffineTransformMakeRotation (-(3.14)/2);
    lblC1.transform = CGAffineTransformMakeRotation (-(3.14)/2);
    lblD1.transform = CGAffineTransformMakeRotation (-(3.14)/2);
    lblF1.transform = CGAffineTransformMakeRotation (-(3.14)/2);
    lblG1.transform = CGAffineTransformMakeRotation (-(3.14)/2);

    btnOldPass.hidden=YES;
    imgOldPass.hidden=YES;

    [self setshadowOnKeys:C1];
    [self setshadowOnKeys:D1];
    [self setshadowOnKeys:F1];
    [self setshadowOnKeys:G1];
    [self setshadowOnKeys:A1];

    
    //PAssword Recovery
    ArryInstruction = [[NSMutableArray alloc]initWithObjects:@"We are introducing a way to recover your password incase you every forget it.",@"You will be asked to create a backup question and enter a text-based password.",@"If you ever forget your password, just hold down any key on the piano for 10 seconds and you will be prompted to enter your text-based backup password.", nil];
    
    
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"RecoveryAns"] && [[[NSUserDefaults standardUserDefaults] stringForKey:@"SetStatus"] isEqualToString:@"YES"])
    {
        strFromGoToHomeScreen = @"Viewdidload";
        [self PasswordRecoveryViewOpen];
    }

    [self LongPressToChangePassword:C];
    [self LongPressToChangePassword:C1];
    [self LongPressToChangePassword:D];
    [self LongPressToChangePassword:D1];
    [self LongPressToChangePassword:E];
    [self LongPressToChangePassword:F];
    [self LongPressToChangePassword:F1];
    [self LongPressToChangePassword:G];
    [self LongPressToChangePassword:G1];
    [self LongPressToChangePassword:A];
    [self LongPressToChangePassword:A1];
    [self LongPressToChangePassword:B];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)setshadowOnKeys:(UIImageView*)imgName
{
    imgName.layer.shadowColor = [[UIColor blackColor] CGColor];
    imgName.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    imgName.layer.shadowRadius = 10.0;
    imgName.layer.shadowOpacity = 0.8;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self CallSetImgEnable];
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"SetStatus"] isEqualToString:@"Reset"])
    {
        ReVerifySet=0;
        btnOldPass.hidden=NO;
        imgOldPass.hidden=NO;
        btnPlay.hidden=YES;
        imgStartRec.hidden=YES;
    }
    else if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"SetStatus"] isEqualToString:@"YES"])
    {
        ReVerifySet=0;
        i=0;
        [ArrySetPasscode removeAllObjects];
        settag=22;
        btnLight.hidden=YES;
        btnPlay.hidden=YES;
        imgStartRec.hidden=YES;
    }
    btnVerify.hidden=YES;
    btnRedo.hidden=YES;
    imgVerify.hidden=YES;
    self.navigationController.navigationBarHidden=YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
-(void)CallSetImgEnable
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"EnablSound"] == 2)
    {
        [btnSoundEnble setImage:[UIImage imageNamed:@"VolumeDisabledButton.png"] forState:UIControlStateNormal];
    }
    else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"EnablSound"] == 1)
    {
        [btnSoundEnble setImage:[UIImage imageNamed:@"Volume.png"] forState:UIControlStateNormal];
    }
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"EnablLbl"] == 2)
    {
        [btnLablEn setImage:[UIImage imageNamed:@"LabelsDisabledButton.png"] forState:UIControlStateNormal];
        [self SetLabelBoolValue:YES];
    }
    else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"EnablLbl"] == 1)
    {
        [btnLablEn setImage:[UIImage imageNamed:@"LabelsEnabledButton.png"] forState:UIControlStateNormal];
        [self SetLabelBoolValue:NO];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view == viewPassQuesAns || touch.view == viewPassInstr || touch.view == ViewPassRecovery || touch.view == viewForgotPass || touch.view == viewWriteAns)
        return;

    NSSet *allTouches = [event allTouches];
    NSMutableArray *ArryTag = [[NSMutableArray alloc]init];
    for (int j = 0; j<[allTouches count]; j++)
    {
        UITouch *touch1 = [[allTouches allObjects] objectAtIndex:j];
        [ArryTag addObject:[NSString stringWithFormat:@"%d",touch1.view.tag]];
    }
    
    NSArray *sortedArray = [ArryTag sortedArrayUsingComparator:^(id firstObject, id secondObject) {
        return [((NSString *)firstObject) compare:((NSString *)secondObject) options:NSNumericSearch];
    }];

    CGPoint currentPoint = [touch locationInView:self.view];
     if (CGRectContainsPoint(C1.frame,currentPoint)==YES)
    {
        [self PlaySound:@"C# Long"];
        
        settag12=1;
        if (settag == 22)
        {
            if ([allTouches count] > 1)
            {
                [self CallVerify:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [self CallVerify:@"C#"];
            }
        }
        else
        {
            if ([allTouches count] > 1)
            {
                [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [ArrySetPasscode addObject:@"C#"];
            }
        }
        [C1 setImage:[UIImage imageNamed:@"LittleKeyPressed.png"]];
    }
    else if (CGRectContainsPoint(D1.frame,currentPoint)==YES)
    {
        [self PlaySound:@"D# Long"];
        
        settag14=1;
        if (settag == 22)
        {
            if ([allTouches count] > 1)
            {
                [self CallVerify:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [self CallVerify:@"D#"];
            }
        }
        else
        {
            if ([allTouches count] > 1)
            {
                [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [ArrySetPasscode addObject:@"D#"];
            }
        }
        [D1 setImage:[UIImage imageNamed:@"LittleKeyPressed.png"]];
    }
    else if (CGRectContainsPoint(F1.frame,currentPoint)==YES)
    {
        [self PlaySound:@"F# Long"];
        
        settag17=1;
        if (settag == 22)
        {
            if ([allTouches count] > 1)
            {
                [self CallVerify:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [self CallVerify:@"F#"];
            }
        }
        else
        {
            if ([allTouches count] > 1)
            {
                [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [ArrySetPasscode addObject:@"F#"];
            }
        }
        [F1 setImage:[UIImage imageNamed:@"LittleKeyPressed.png"]];
    }
    else if (CGRectContainsPoint(G1.frame,currentPoint)==YES)
    {
        [self PlaySound:@"G# Long"];
        
        settag19=1;
        if (settag == 22)
        {
            if ([allTouches count] > 1)
            {
                [self CallVerify:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [self CallVerify:@"G#"];
            }
        }
        else
        {
            if ([allTouches count] > 1)
            {
                [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [ArrySetPasscode addObject:@"G#"];
            }
        }
        [G1 setImage:[UIImage imageNamed:@"LittleKeyPressed.png"]];
    }
    else if (CGRectContainsPoint(A1.frame,currentPoint)==YES)
    {
        [self PlaySound:@"A# Long"];
        
        settag21=1;
        if (settag == 22)
        {
            if ([allTouches count] > 1)
            {
                [self CallVerify:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [self CallVerify:@"A#"];
            }
        }
        else
        {
            if ([allTouches count] > 1)
            {
                [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [ArrySetPasscode addObject:@"A#"];
            }
        }
        [A1 setImage:[UIImage imageNamed:@"LittleKeyPressed.png"]];
    }
    else if (CGRectContainsPoint(C.frame,currentPoint)==YES) 
    {
        [self PlaySound:@"C Long"];
        
        settag1=1;
        settag11=1;
        [C setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
        if (settag == 22)
        {
            if ([allTouches count] > 1)
            {
                [self CallVerify:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [self CallVerify:@"C"];
            }
        }
        else
        {
            if ([allTouches count] > 1)
            {
                [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [ArrySetPasscode addObject:@"C"];
            }
        }
    }
    else if (CGRectContainsPoint(D.frame,currentPoint)==YES)
    {
        [self PlaySound:@"D Long"];
        
        settag2=1;
        settag13=1;
        [D setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
        if (settag == 22)
        {
            if ([allTouches count] > 1)
            {
                [self CallVerify:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [self CallVerify:@"D"];
            }
        }
        else
        {
            if ([allTouches count] > 1)
            {
                [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [ArrySetPasscode addObject:@"D"];
            }
        }
    }
    else if (CGRectContainsPoint(E.frame,currentPoint)==YES)
    {
        [self PlaySound:@"E Long"];
        
        settag3=1;
        settag15=1;
        [E setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
        if (settag == 22)
        {
            if ([allTouches count] > 1)
            {
                [self CallVerify:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [self CallVerify:@"E"];
            }
        }
        else
        {
            if ([allTouches count] > 1)
            {
                [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [ArrySetPasscode addObject:@"E"];
            }
        }
    }
    else if (CGRectContainsPoint(F.frame,currentPoint)==YES)
    {
        [self PlaySound:@"F Long"];
        
        settag4=1;
        settag16=1;
        [F setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
        if (settag == 22)
        {
            if ([allTouches count] > 1)
            {
                [self CallVerify:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [self CallVerify:@"F"];
            }
        }
        else
        {
            if ([allTouches count] > 1)
            {
                [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [ArrySetPasscode addObject:@"F"];
            }
        }
    }
    else if (CGRectContainsPoint(G.frame,currentPoint)==YES)
    {
        [self PlaySound:@"G Long"];
        
        settag5=1;
        settag18=1;
        [G setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
        if (settag == 22)
        {
            if ([allTouches count] > 1)
            {
                [self CallVerify:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [self CallVerify:@"G"];
            }
        }
        else
        {
            if ([allTouches count] > 1)
            {
                [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [ArrySetPasscode addObject:@"G"];
            }
        }
    }
    else if (CGRectContainsPoint(A.frame,currentPoint)==YES)
    {
        [self PlaySound:@"A Long"];
        
        settag6=1;
        settag20=1;
        [A setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
        if (settag == 22)
        {
            if ([allTouches count] > 1)
            {
                [self CallVerify:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [self CallVerify:@"A"];
            }
        }
        else
        {
            if ([allTouches count] > 1)
            {
                [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [ArrySetPasscode addObject:@"A"];
            }
        }
    }
    else if (CGRectContainsPoint(B.frame,currentPoint)==YES)
    {
        [self PlaySound:@"B Long"];
        
        settag7=1;
        settag22=1;
        [B setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
        if (settag == 22)
        {
            if ([allTouches count] > 1)
            {
                [self CallVerify:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [self CallVerify:@"B"];
            }
        }
        else
        {
            if ([allTouches count] > 1)
            {
                [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
            }
            else
            {
                [ArrySetPasscode addObject:@"B"];
            }
        }
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view == viewPassQuesAns || touch.view == viewPassInstr || touch.view == ViewPassRecovery || touch.view == viewForgotPass || touch.view == viewWriteAns)
        return;
    
    NSSet *allTouches = [event allTouches];
    NSMutableArray *ArryTag = [[NSMutableArray alloc]init];
    for (int j = 0; j<[allTouches count]; j++)
    {
        UITouch *touch1 = [[allTouches allObjects] objectAtIndex:j];
        [ArryTag addObject:[NSString stringWithFormat:@"%d",touch1.view.tag]];
    }
    
    NSArray *sortedArray = [ArryTag sortedArrayUsingComparator:^(id firstObject, id secondObject) {
        return [((NSString *)firstObject) compare:((NSString *)secondObject) options:NSNumericSearch];
    }];
    
    
    CGPoint location = [touch locationInView:self.view];
   
    if (location.x >200)
    {
        if(location.y >410 && location.y <480 && settag1==0)
        {
            [self PlaySound:@"C Long"];
            
            settag1=1;
                settag2=settag3=settag4=settag5=settag6=settag7=0;
            [C setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"C"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"C"];
                }
            }
        }
        else if (location.y >342 && location.y <410 && settag2==0)
        {
            [self PlaySound:@"D Long"];
            
            settag2=1;
                settag1=settag3=settag4=settag5=settag6=settag7=0;
            [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"D"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"D"];
                }
            }
        }
        else if (location.y >274 && location.y <342 && settag3==0)
        {
            [self PlaySound:@"E Long"];
            
            settag3=1;
                settag1=settag2=settag4=settag5=settag6=settag7=0;
            [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"E"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"E"];
                }
            }
            
        }
        else if (location.y >206 && location.y <274 && settag4==0)
        {
            [self PlaySound:@"F Long"];
            
            settag4=1;
                settag1=settag2=settag3=settag5=settag6=settag7=0;
            [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"F"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"F"];
                }
            }
        }
        else if (location.y >138 && location.y <206 && settag5==0)
        {
            [self PlaySound:@"G Long"];
            
            settag5=1;
                settag1=settag2=settag3=settag4=settag6=settag7=0;
            [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"G"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"G"];
                }
            }
        }
        else if (location.y >69 && location.y <138 && settag6==0)
        {
            [self PlaySound:@"A Long"];
            
            settag6=1;
                settag1=settag2=settag3=settag4=settag5=settag7=0;
            [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"A"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"A"];
                }
            }
        }
        else if (location.y >0 && location.y <69 && settag7==0)
        {
            [self PlaySound:@"B Long"];
            
            settag7=1;
                settag1=settag2=settag3=settag4=settag5=settag6=0;
            [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"B"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"B"];
                }
            }
        }
    }
    else if (location.x >48 && location.x < 200)
    {
        if(location.y >431 && location.y <480 && settag11==0)
        {
            [self PlaySound:@"C Long"];
            
            settag11=1;
                settag12=settag13=settag14=settag15=settag16=settag17=settag18=settag19=settag20=settag21=settag22=0;
            [C setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [C1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [D1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [F1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [G1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [A1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"C"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"C"];
                }
            }
        }
        else if (location.y >388 && location.y <431 && settag12==0)
        {
            [self PlaySound:@"C# Long"];
            
            settag12=1;
                settag11=settag13=settag14=settag15=settag16=settag17=settag18=settag19=settag20=settag21=settag22=0;
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"C#"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"C#"];
                }
            }
            [C1 setImage:[UIImage imageNamed:@"LittleKeyPressed.png"]];
            [D1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [F1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [G1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [A1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
        }
        else if (location.y >363 && location.y <388 && settag13==0)
        {
            [self PlaySound:@"D Long"];
            
            settag13=1;
                settag11=settag12=settag14=settag15=settag16=settag17=settag18=settag19=settag20=settag21=settag22=0;
            [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [C1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [D1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [F1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [G1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [A1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"D"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"D"];
                }
            }
        }
        else if (location.y >320 && location.y <363 && settag14==0)
        {
            [self PlaySound:@"D# Long"];
            
            settag14=1;
                settag11=settag12=settag13=settag15=settag16=settag17=settag18=settag19=settag20=settag21=settag22=0;
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"D#"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"D#"];
                }
            }
            [C1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [D1 setImage:[UIImage imageNamed:@"LittleKeyPressed.png"]];
            [F1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [G1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [A1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
        }
        else if (location.y >273 && location.y <320 && settag15==0)
        {
            [self PlaySound:@"E Long"];
            
            settag15=1;
                settag11=settag12=settag13=settag14=settag16=settag17=settag18=settag19=settag20=settag21=settag22=0;
            [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [C1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [D1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [F1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [G1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [A1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"E"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"E"];
                }
            }
        }
        else if (location.y >229 && location.y <273 && settag16==0)
        {
            [self PlaySound:@"F Long"];
            
            settag16=1;
                settag11=settag12=settag13=settag14=settag15=settag17=settag18=settag19=settag20=settag21=settag22=0;
            [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [C1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [D1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [F1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [G1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [A1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"F"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"F"];
                }
            }
        }
        else if (location.y >186 && location.y <229 && settag17==0)
        {
            [self PlaySound:@"F# Long"];
            
            settag17=1;
                settag11=settag12=settag13=settag14=settag15=settag16=settag18=settag19=settag20=settag21=settag22=0;
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"F#"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"F#"];
                }
            }
            [C1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [D1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [F1 setImage:[UIImage imageNamed:@"LittleKeyPressed.png"]];
            [G1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [A1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
        }
        else if (location.y >159 && location.y <186 && settag18==0)
        {
            [self PlaySound:@"G Long"];
            
            settag18=1;
                settag11=settag12=settag13=settag14=settag15=settag16=settag17=settag19=settag20=settag21=settag22=0;
             [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
             [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
             [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
             [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
             [G setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
             [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
             [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [C1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [D1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [F1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [G1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [A1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"G"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"G"];
                }
            }
        }
        else if (location.y >116 && location.y <159 && settag19==0)
        {
            [self PlaySound:@"G# Long"];
            
            settag19=1;
                settag11=settag12=settag13=settag14=settag15=settag16=settag17=settag18=settag20=settag21=settag22=0;
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"G#"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"G#"];
                }
            }
            [C1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [D1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [F1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [G1 setImage:[UIImage imageNamed:@"LittleKeyPressed.png"]];
            [A1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
        }
        else if (location.y >91 && location.y <116 && settag20==0)
        {
            [self PlaySound:@"A Long"];
            
            settag20=1;
                settag11=settag12=settag13=settag14=settag15=settag16=settag17=settag18=settag19=settag21=settag22=0;
            [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [C1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [D1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [F1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [G1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [A1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"A"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"A"];
                }
            }
        }
        else if (location.y >48 && location.y <91 && settag21==0)
        {
            [self PlaySound:@"A# Long"];
            
            settag21=1;
                settag11=settag12=settag13=settag14=settag15=settag16=settag17=settag18=settag19=settag20=settag22=0;
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"A#"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"A#"];
                }
            }
            [C1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [D1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [F1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [G1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [A1 setImage:[UIImage imageNamed:@"LittleKeyPressed.png"]];
            [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
        }
        else if (location.y >0 && location.y <48 && settag22==0)
        {
            [self PlaySound:@"B Long"];
            
            settag22=1;
                settag11=settag12=settag13=settag14=settag15=settag16=settag17=settag18=settag19=settag20=settag21=0;
            [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
            [B setImage:[UIImage imageNamed:@"BigKeyPressedVertc.png"]];
            [C1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [D1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [F1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [G1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            [A1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
            if (settag == 22)
            {
                if ([allTouches count] > 1)
                {
                    [self CallVerify:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [self CallVerify:@"B"];
                }
            }
            else
            {
                if ([allTouches count] > 1)
                {
                    [ArrySetPasscode addObject:[sortedArray componentsJoinedByString:@""]];
                }
                else
                {
                    [ArrySetPasscode addObject:@"B"];
                }
            }
        }
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view == viewPassQuesAns || touch.view == viewPassInstr || touch.view == ViewPassRecovery || touch.view == viewForgotPass || touch.view == viewWriteAns)
        return;
    
    [self CallImgSet];
    NSSet *touch1 = [event allTouches];
    int touchCounts = [touch1 count];
    if (touchCounts == 1)
    {
        settag1=settag2=settag3=settag4=settag5=settag6=settag7=0;
        settag11=settag12=settag13=settag14=settag15=settag16=settag17=settag18=settag19=settag20=settag21=settag22=0;   
    }
}
-(void)PlaySound:(NSString*)strSoundName
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"EnablSound"] == 1)
    {
        NSURL *tapSound   = [[NSBundle mainBundle] URLForResource:strSoundName withExtension: @"wav"];
        CFURLRef        soundFile = (__bridge CFURLRef)tapSound;
        SystemSoundID    soundFileObj;
        AudioServicesCreateSystemSoundID (soundFile,&soundFileObj);
        AudioServicesPlaySystemSound (soundFileObj);
    }
}
-(void)CallImgSet
{
    [C setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
    [D setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
    [E setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
    [F setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
    [G setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
    [A setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
    [B setImage:[UIImage imageNamed:@"BigKeyVertc.png"]];
    
    [C1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
    [D1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
    [F1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
    [G1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
    [A1 setImage:[UIImage imageNamed:@"LittleKey.png"]];
}
-(IBAction)btnStartRecoPressed:(id)sender
{
    ReVerifySet=0;
    imgVerify.image=[UIImage imageNamed:@"PostRecordingBox.png"];
    imgVerify.frame=CGRectMake(131, 115, 104, 249);
    [ArrySetPasscode removeAllObjects];
    TimerImg.hidden=NO;
    settag=[sender tag];
    [self countdownTimer];
    secondsLeft = 7;
    NSString *strimg=[NSString stringWithFormat:@"Countdown-%d.png",secondsLeft];
    TimerImg.image=[UIImage imageNamed:strimg];
    btnLight.hidden=YES;
    btnPlay.hidden=YES;
    imgStartRec.hidden=YES;
    
}
-(void)updateCounter:(NSTimer *)theTimer
{
    if(secondsLeft > 0){
        secondsLeft -- ;
        NSString *strimg=[NSString stringWithFormat:@"Countdown-%d.png",secondsLeft];
        TimerImg.image=[UIImage imageNamed:strimg];
    }
    else
    {
            if ([ArrySetPasscode count] == 0)
            {
                UIAlertView* alertVerify = [[UIAlertView alloc] initWithTitle:APP_NAME message:@"You can not set Passcode blank" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertVerify show];
                btnLight.hidden=NO;
                btnPlay.hidden=NO;
                imgStartRec.hidden=NO;
                [timerCountdown invalidate];
                [TimerImg stopAnimating];
            }
            else
            {
                [timerCountdown invalidate];
                [TimerImg stopAnimating];
                if (settag == 11)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:ArrySetPasscode forKey:@"setPasscode"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    btnLight.hidden=NO;
                    btnVerify.hidden=NO;
                    btnRedo.hidden=NO;
                    imgVerify.hidden=NO;
                }
            }
    }
}
-(void)countdownTimer
{
    timerCountdown = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
} 
-(IBAction)btnVerifyPressed:(id)sender
{
    if (ReVerifySet==0)
    {
        ReVerifySet=1;
    }
    
    if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"SetStatus"] isEqualToString:@"YES"])
    {
        imgVerify.image=[UIImage imageNamed:@"IncorrectVerificationPopUp.png"];
        imgVerify.frame=CGRectMake(93, 115, 142, 249);
    }
    
    i=0;
    setold=00;
    settag=[sender tag];
    [ArrySetPasscode removeAllObjects];
    btnLight.hidden=YES;
    btnRedo.hidden=YES;
    btnVerify.hidden=YES;
    imgVerify.hidden=YES;
    TimerImg.hidden=YES;
}
-(void)CallVerify:(NSString*)strpass
{
    NSMutableArray *array=[[NSUserDefaults standardUserDefaults] objectForKey:@"setPasscode"];
    if ([[array objectAtIndex:i]isEqualToString:strpass])
    {
        i++;
        if (i == [array count])
        {
            [self CallImgSet];
            if (setold==14) 
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"setPasscode"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SetStatus"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                btnPlay.hidden=NO;
                imgStartRec.hidden=NO;
                btnLight.hidden=NO;
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"SetStatus"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if ([[NSUserDefaults standardUserDefaults] stringForKey:@"RecoveryAns"])
                {
                    [self GoToHomeScreen];
                }
                else
                {
                    strFromGoToHomeScreen = @"Verify";
                    [self PasswordRecoveryViewOpen];
                }
            }
        }
    }
    else
    {
        i=0;
        if (setold==14) 
        {
            btnLight.hidden=NO;
            btnOldPass.hidden=NO;
            imgOldPass.hidden=NO;
        }
        else
        {
            if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"SetStatus"] isEqualToString:@"YES"])
            {
                btnRedo.hidden=NO;
                btnLight.hidden=NO;
                btnVerify.hidden=NO;
                imgVerify.hidden=NO;
            }
        }
            
    }

}
-(IBAction)btnRedoPressed:(id)sender
{
    ReVerifySet=0;
    imgVerify.image=[UIImage imageNamed:@"PostRecordingBox.png"];
    imgVerify.frame=CGRectMake(131, 115, 104, 249);
    TimerImg.hidden=NO;
    settag=[sender tag];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"setPasscode"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SetStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [ArrySetPasscode removeAllObjects];
    btnLight.hidden=YES;
    btnRedo.hidden=YES;
    btnVerify.hidden=YES;
    imgVerify.hidden=YES;
    [self countdownTimer];
    secondsLeft = 7;
    NSString *strimg=[NSString stringWithFormat:@"Countdown-%d.png",secondsLeft];
    TimerImg.image=[UIImage imageNamed:strimg];
}
-(IBAction)btnOldPass:(id)sender
{
    i=0;
    setold=14;
    settag=[sender tag];
    btnLight.hidden=YES;
    btnOldPass.hidden=YES;
    imgOldPass.hidden=YES;
    [ArrySetPasscode removeAllObjects];
}
-(IBAction)btnEnableLablPressed:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"EnablLbl"] == 2)
    {
        [btnLablEn setImage:[UIImage imageNamed:@"LabelsEnabledButton.png"] forState:UIControlStateNormal];
  
        [self SetLabelBoolValue:NO];
        
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"EnablLbl"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"EnablLbl"] == 1)
    {
        [btnLablEn setImage:[UIImage imageNamed:@"LabelsDisabledButton.png"] forState:UIControlStateNormal];
        
        [self SetLabelBoolValue:YES];
        
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"EnablLbl"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
         
}
-(void)SetLabelBoolValue:(BOOL)yesno
{
    lblA.hidden = yesno;
    lblB.hidden = yesno;
    lblC.hidden = yesno;
    lblD.hidden = yesno;
    lblE.hidden = yesno;
    lblF.hidden = yesno;
    lblG.hidden = yesno;
    lblC1.hidden = yesno;
    lblD1.hidden = yesno;
    lblA1.hidden = yesno;
    lblF1.hidden = yesno;
    lblG1.hidden = yesno;
}
-(IBAction)btnSoundEnablePressed:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"EnablSound"] == 2)
    {
        [btnSoundEnble setImage:[UIImage imageNamed:@"Volume.png"] forState:UIControlStateNormal];
        
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"EnablSound"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"EnablSound"] == 1)
    {
        [btnSoundEnble setImage:[UIImage imageNamed:@"VolumeDisabledButton.png"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"EnablSound"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
-(void)PasswordRecoveryViewOpen
{
    ViewPassRecovery.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:ViewPassRecovery];
    [GlobalMethods SetViewShadow:viewPassInstr];
    [GlobalMethods SetViewShadow:viewPassQuesAns];
    [GlobalMethods SetTfShadow:tfPassRecovery];
    [GlobalMethods SetInsetToTextField:tfPassRecovery];
    viewPassQuesAns.hidden = YES;
    viewPassInstr.hidden = NO;
    IndexArry = 0;
    
    lblInst.text = [NSString stringWithFormat:@"%@",[ArryInstruction objectAtIndex:IndexArry]];
}
-(IBAction)btnNextInstructionPressed:(id)sender
{
     IndexArry = IndexArry + 1;
     if (IndexArry >= 3)
     {
         [self EnterQueAns];
     }
     else
     {
         lblInst.text = [NSString stringWithFormat:@"%@",[ArryInstruction objectAtIndex:IndexArry]];
     }
}
-(IBAction)btnRemovePasswordRecoveryPressed:(id)sender
{
    if ([sender tag] == 111)
    {
        [tfPassRecovery resignFirstResponder];
        if ([[NSUserDefaults standardUserDefaults] stringForKey:@"RecoveryAns"])
        {
            [ViewPassRecovery removeFromSuperview];
        }
    }
    else if ([sender tag] == 222)
    {
        [tfAns resignFirstResponder];
        [viewForgotPass removeFromSuperview];
    }
   
}
-(IBAction)btnQuesAnsSavePressed:(id)sender
{
    NSString *strString = [tfPassRecovery.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (strString.length > 0 && [lblPassTitle.text isEqualToString:@"Create recovery question"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:strString forKey:@"RecoveryQue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        lblPassTitle.text = @"Enter recovery password";
        tfPassRecovery.text = @"";
    }
    else if (strString.length > 0 && [lblPassTitle.text isEqualToString:@"Enter recovery password"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:strString forKey:@"RecoveryAns"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [tfPassRecovery resignFirstResponder];
        [ViewPassRecovery removeFromSuperview];
        
        if ([strFromGoToHomeScreen isEqualToString:@"Verify"])
        {
            strFromGoToHomeScreen = @"";
            [self GoToHomeScreen];
        }
    }
    else
    {
        [GlobalMethods animateIncorrectPassword:viewPassQuesAns];
    }
}
-(void)EnterQueAns
{
    [tfPassRecovery becomeFirstResponder];
    viewPassInstr.hidden = YES;
    viewPassQuesAns.hidden = NO;
    tfPassRecovery.text = @"";
}

-(void)GoToHomeScreen
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.80];
    
    HomeScreenViewCtr *obj_HomeScreenViewCtr=[[HomeScreenViewCtr alloc]initWithNibName:@"HomeScreenViewCtr" bundle:nil];
    [self.navigationController pushViewController:obj_HomeScreenViewCtr animated:YES];
    obj_HomeScreenViewCtr=nil;
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    btnLight.hidden=NO;
    btnPlay.hidden=NO;
    imgStartRec.hidden=NO;
}

-(IBAction)CheckAnsForForgotPassPressed:(id)sender
{
    NSString *strString = [tfAns.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (strString.length > 0 && [strString isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"RecoveryAns"]])
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"setPasscode"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SetStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        btnPlay.hidden=NO;
        imgStartRec.hidden=NO;
        btnLight.hidden=NO;
        tfAns.text = @"";
        [tfAns resignFirstResponder];
        [viewForgotPass removeFromSuperview];
    }
    else
    {
        [GlobalMethods animateIncorrectPassword:viewWriteAns];
    }
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)LongPressToChangePassword:(UIImageView*)imgViewName
{
    UILongPressGestureRecognizer *obj_longGest = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressChangePass:)];
    obj_longGest.numberOfTouchesRequired = 1.0;
    obj_longGest.minimumPressDuration = 10.0;
    [imgViewName addGestureRecognizer:obj_longGest];
}
-(void)longPressChangePass:(UIGestureRecognizer*)gest
{
    if (gest.state == UIGestureRecognizerStateBegan)
    {
        if ([[NSUserDefaults standardUserDefaults] stringForKey:@"RecoveryAns"])
        {
            [self CallImgSet];
            [self.view addSubview:viewForgotPass];
            viewForgotPass.frame = CGRectMake(0, 0, 320, 480);
            [tfAns becomeFirstResponder];
            [GlobalMethods SetViewShadow:viewWriteAns];
            [GlobalMethods SetTfShadow:tfAns];
            [GlobalMethods SetInsetToTextField:tfAns];
            
            lblQuestion.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"RecoveryQue"]];
        }
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
@end
