#import "AlertManger.h"


@implementation AlertManger

static AlertManger* agent;

- (id)init{
	return self;
}

+ (AlertManger *) defaultAgent {
	if (!agent) {
		agent = [[AlertManger alloc] init];
	}
	return agent;
}


/** 
 This method is responsible for display alert with ok and cancel button and also delegate for self.
 @param:    
 @return: void 
 @throws:
 */


-(void) showAlertForDelegateWithTitle:(NSString *)title
				   message:(NSString *)message
		 cancelButtonTitle:(NSString *)cancelButtonTitle
			 okButtonTitle:(NSString*)okButtonTitle
		  parentController: (id) delegateAdd {
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message
												   delegate:delegateAdd cancelButtonTitle:cancelButtonTitle otherButtonTitles:okButtonTitle,nil];
	[alert show];
	
}

/** 
 This method is responsible for display simple alert with Ok button without delegate.
 @param:    
 @return: void 
 @throws:
 */

-(void) showAlertWithTitle:(NSString *)title
				   message:(NSString *)message
		 cancelButtonTitle:(NSString *)cancelButtonTitle  {
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message
												   delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles: nil];
	[alert show];
}


/** 
 This method is responsible for display  alert with number of buttons and delagte.
 @param:    
 @return: void 
 @throws:
 */

-(void)showAlertWithTitle:(NSString *)title
				  message:(NSString *)message
		cancelButtonTitle:(NSString *)cancelButtonTitle
		otherButtonTitles:(NSString *)otherButtonTitles
		 parentController: (id) delegateAdd {
	
	UIAlertView *av=[[UIAlertView alloc] initWithTitle:title message:message delegate:delegateAdd cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
	
	if (otherButtonTitles!=nil)
		/*for(NSString *t in otherButtonTitles)
			[av addButtonWithTitle:t];*/
	
	[av show];
	
}


		 

@end
