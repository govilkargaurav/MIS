
#import "TblCell.h"
#import "CacheManager.h"

@implementation TblCell

@synthesize imageView, imgUrl, loader;

- (id)initWithFrame:(CGRect) frame withImageUrl:(NSString *)url withFlag:(int)flag isDownload:(BOOL)_download {
	@try {
		if (self = [super initWithFrame:frame]) {
			imgUrl = url;
			int x = 4;
			int y = 4;
			if(frame.size.height > 46) {
				y = y + (frame.size.height - 46)/2;
			}
			
			if(frame.size.width > 46) {
				x = x + (frame.size.width - 46)/2;
			}
			if(_download){
				if (flag == 1)
					loader = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(x, y, 10, 10)];
				else
					loader = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(x, y, 30, 30)];
				
				[loader startAnimating];
				[loader setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
				[self addSubview:loader];
				
			}
					
			[self setBackgroundColor:[UIColor clearColor]];

			imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
			[imageView setBackgroundColor:[UIColor clearColor]];
			[imageView setOpaque:NO];
			
			[self addSubview:imageView];
		}
		if(_download){
			NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(downloadData) object:nil];
			[t start];
			[t release];	
		}
	}@catch (NSException* e) {
		
	}@finally {
		return self;
	}
    
}

- (NSString *) encodeUrl:(NSString *)str {
	NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("#[]!$’()*+,; "), kCFStringEncodingUTF8);
	return [result autorelease];
}

- (void) downloadData {
	@try {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
		if(imgUrl != nil && [imgUrl length] >0) {
            NSLog(@"New URL showing %@",imgUrl);
            
			NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self encodeUrl:imgUrl]]];
		
			if(imageData==nil){
				imageView.image = [UIImage imageNamed:@"default_img.png"];
				[loader stopAnimating];
				[self.loader setHidden:YES];
			}else{
				imageView.image = [[UIImage alloc] initWithData:imageData];
				[[CacheManager sharedCacheManager]._dictImages setObject:imageData forKey:imgUrl]; 
				[loader stopAnimating];
				[self.loader setHidden:YES];
			}
			 
		}
		
		

		
		[pool release];
	}@catch (NSException* e) {
		
	}
}

- (void) reloadImg:(NSString *)url {
	@try {
	   self.imgUrl = url;
	   [self downloadData];
	}@catch (NSException* e) {
		
	}
}


- (void) dealloc {
	[loader release];
	[imageView release];
	[imgUrl release];
	[super dealloc];
}

@end
