#import <AppKit/AppKit.h>

@interface PhraseTableViewDataSource : NSObject <NSTableViewDataSource> {
	NSArray *_phrases;
}

- (id)initWithData:(NSData *)data;

@end
