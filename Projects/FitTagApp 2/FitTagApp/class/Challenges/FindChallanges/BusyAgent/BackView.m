#import "BackView.h"

static BackView* agent;

@implementation BackView

+ (BackView*)defaultAgent{
	if(!agent){
		agent =[[BackView alloc] init];
	}
	return agent;
}
- (void) addBackView:(UIView *)_view{
	if(view!=nil){
		view=nil;
		[view release];
	}
	view=[[UIView alloc] initWithFrame:_view.frame];
	view.backgroundColor = [UIColor blackColor];
	view.alpha = 0.60;
	[_view addSubview:view];
}

- (void) removeBackView{
	if(view!=nil){
		[view removeFromSuperview];
	}
	view=nil;
	[view release];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}
- (void)dealloc{
	[view release];
	[super dealloc];
}
@end
