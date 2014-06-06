#import <AppKit/AppKit.h>

@interface PhraseTableViewDataSource : NSObject <NSTableViewDataSource>

- (id)initWithData:(NSData *)data;

@end
