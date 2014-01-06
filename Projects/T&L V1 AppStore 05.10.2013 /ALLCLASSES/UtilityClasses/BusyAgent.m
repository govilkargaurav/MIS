#import "BusyAgent.h"

static BusyAgent* agent;

@implementation BusyAgent
- (id)init{
	return nil;
}

- (id)myinit{
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	if([super init])
    {
		busyCount = 0;
		UIWindow* keywindow = [[UIApplication sharedApplication] keyWindow];
		view = [[UIView alloc] initWithFrame:[keywindow frame]];
		view.backgroundColor = [UIColor blackColor];
		view.alpha = 0.60;
		wait = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		wait.hidesWhenStopped = NO;
		wait.center = view.center;

		busyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100,30)];
            
		busyLabel.transform = CGAffineTransformMakeRotation(M_PI);
        busyLabel.center = view.center;
		busyLabel.textColor = [UIColor whiteColor];
		busyLabel.backgroundColor = [UIColor clearColor];
		busyLabel.shadowColor = [UIColor blackColor];
		busyLabel.textAlignment = NSTextAlignmentCenter;
		busyLabel.text = @"";
		busyLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
		[view addSubview:wait];
		[view addSubview:busyLabel];
		[wait startAnimating];
		
		return self;
	}
	
	return nil;
}

- (void) makeBusy:(BOOL)yesOrno showBusyIndicator:(BOOL)showIndicatorYesNo strLabel:(NSString *)strLabel
{
	if(showIndicatorYesNo){
		[wait setHidden:NO];
        [busyLabel setText:strLabel];
		[busyLabel setHidden:NO];
	}else{
		[wait setHidden:YES];
		[busyLabel setHidden:YES];
	}
	if(yesOrno){
		busyCount++;
	}else {
		busyCount--;
		if(busyCount<0){
			busyCount = 0;
		}
	}
	
	if(busyCount == 1){
		[[[UIApplication sharedApplication] keyWindow] addSubview:view];
		[[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:view];
	}else if(busyCount == 0) {
		[view removeFromSuperview];
	}else {
		[[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:view];
	}

}

- (void) queueBusy{
	[self makeBusy:YES showBusyIndicator:YES strLabel:@""];
}
- (void) dequeueBusy{
	[self makeBusy:NO showBusyIndicator:NO strLabel:@""];
}


- (void) forceRemoveBusyState{
	busyCount = 0;
	[view removeFromSuperview];
}

+ (BusyAgent*)defaultAgent{
	if(!agent){
		agent =[[BusyAgent alloc] myinit];
	}
	return agent;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}
@end
