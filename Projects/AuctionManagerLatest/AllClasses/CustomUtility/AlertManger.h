#import <Foundation/Foundation.h>

/**
 * Simple class to show alert view
 */

@interface AlertManger : NSObject <UIAlertViewDelegate> {

}
+ (AlertManger*)defaultAgent;

-(void) showAlertForDelegateWithTitle:(NSString *)title
				   message:(NSString *)message
		 cancelButtonTitle:(NSString *)cancelButtonTitle
			 okButtonTitle:(NSString*)okButtonTitle
		  parentController: (id) delegateAdd;


-(void) showAlertWithTitle:(NSString *)title
				   message:(NSString *)message
		 cancelButtonTitle:(NSString *)cancelButtonTitle;


-(void)showAlertWithTitle:(NSString *)title
				  message:(NSString *)message
		cancelButtonTitle:(NSString *)cancelButtonTitle
	 otherButtonTitles:(NSString *)otherButtonTitles
    parentController: (id) delegateAdd;

@end
