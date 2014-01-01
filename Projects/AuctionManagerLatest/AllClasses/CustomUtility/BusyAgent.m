#import "BusyAgent.h"

static BusyAgent* agent;

@implementation BusyAgent
- (id)init{
	return nil;
}

- (id)myinit{
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	if( (self ==[super init])){
		busyCount = 0;
		UIWindow* keywindow = [[UIApplication sharedApplication] keyWindow];
		view = [[UIView alloc] initWithFrame:[keywindow frame]];
		view.backgroundColor = [UIColor blackColor];
		view.alpha = 0.60;
		wait = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		wait.hidesWhenStopped = NO;
		wait.center = view.center;

		busyLabel = [[UILabel alloc] initWithFrame:CGRectMake(wait.frame.origin.x-20,wait.frame.origin.y-60,150,150)];
		
		busyLabel.transform = CGAffineTransformMakeRotation(M_PI);

		busyLabel.textColor = [UIColor whiteColor];
		busyLabel.backgroundColor = [UIColor clearColor];
		busyLabel.shadowColor = [UIColor blackColor];
		busyLabel.textAlignment = UITextAlignmentCenter;
		//busyLabel.text = @"Yükleniyor, lütfen bekleyin...";
		busyLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
		[view addSubview:wait];
		[view addSubview:busyLabel];
		[wait startAnimating];
		
		return self;
	}
	
	return nil;
}

- (void) makeBusy:(BOOL)yesOrno showBusyIndicator:(BOOL)showIndicatorYesNo{
	if(showIndicatorYesNo){
		[wait setHidden:NO];
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
	[self makeBusy:YES showBusyIndicator:YES];
}
- (void) dequeueBusy{
	[self makeBusy:NO showBusyIndicator:NO];
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
