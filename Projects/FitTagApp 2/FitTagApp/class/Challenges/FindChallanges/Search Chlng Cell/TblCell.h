
#import <UIKit/UIKit.h>

@interface TblCell : UIView {
	UIActivityIndicatorView *loader;
	UIImageView *imageView;
	NSString *imgUrl;
	
}
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSString *imgUrl;
@property (nonatomic, retain) UIActivityIndicatorView *loader;

- (id)initWithFrame:(CGRect) frame withImageUrl:(NSString *)url withFlag:(int)flag isDownload:(BOOL)_download;
- (void) downloadData;
- (void) reloadImg:(NSString *)url;
- (NSString *) encodeUrl:(NSString *)str;
@end