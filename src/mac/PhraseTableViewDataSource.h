#import <AppKit/AppKit.h>

@interface PhraseTableViewDataSource : NSControl <NSTableViewDataSource, NSTextFieldDelegate>

@property (nonatomic, assign) NSSearchField *searchBar;  // XXX: dunno if assign is correct

- (id)initWithData:(NSData *)data;

@end
