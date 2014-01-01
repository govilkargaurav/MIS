//
//  ViewController.h
//  OrganiseMee_iPad
//
//  Created by Imac 2 on 8/21/13.
//  Copyright (c) 2013 OpenXcellTechnolabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UINavigationControllerDelegate>
{
    int OrientationFlag;
    UINavigationController *leftController;
    UINavigationController *centerController;
    UINavigationController *rightController;
}
@end
