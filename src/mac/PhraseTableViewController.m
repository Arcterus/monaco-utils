#import "PhraseTableViewController.h"
#import "PhraseTableViewDataSource.h"
#import "PhraseTableViewDelegate.h"

#define LANG_FILE @"~/Library/Application Support/Steam/SteamApps/common/Monaco/MONACO.app/Contents/Resources/Lang/eng/Strings/All.lang"  // TODO: portability

@implementation PhraseTableViewController {
	NSWindow *_window;
	NSScrollView *_scrollView;
	NSTableView *_tableView;
	PhraseTableViewDataSource *_source;
	PhraseTableViewDelegate *_delegate;
}

+ (NSCell *)createHeaderCell:(NSString *)name {
	NSCell *header = [[NSCell alloc] initTextCell:name];
	header.backgroundStyle = NSBackgroundStyleRaised;
	return header;
}

+ (NSTableColumn *)createTableColumn:(NSString *)ident {
	NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:ident];
	column.headerCell = [PhraseTableViewController createHeaderCell:[ident capitalizedString]];
	return column;
}

// TODO: make the view look nicer
// TODO: change column title
- (id)initWithWindow:(NSWindow *)window {
	if(self = [super init]) {
		_window = window;

		_tableView = [[NSTableView alloc] init];
		NSTableColumn *offsets = [PhraseTableViewController createTableColumn:@"offsets"];
		offsets.editable = NO;
		[_tableView addTableColumn:offsets];
		[offsets release];
		[_tableView addTableColumn:[PhraseTableViewController createTableColumn:@"phrases"]];
		_source = [[PhraseTableViewDataSource alloc] initWithData:[NSData dataWithContentsOfFile:[LANG_FILE stringByExpandingTildeInPath]]];
		_delegate = [[PhraseTableViewDelegate alloc] init];
		_tableView.dataSource = _source;
		_tableView.delegate = _delegate;
		[_tableView reloadData];

		_scrollView = [[NSScrollView alloc] init];
		_scrollView.documentView = _tableView;
		_scrollView.hasVerticalScroller = YES;

		self.view = _scrollView;
	}
	return self;
}

- (void)loadView {
	_window.contentView = [self view];
}

- (void)dealloc {
	[_scrollView release];
	[_tableView release];
	[_source release];
	[_delegate release];
	[super dealloc];
}

@end
