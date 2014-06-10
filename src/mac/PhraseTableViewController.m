#import "PhraseTableViewController.h"
#import "PhraseTableViewDataSource.h"
#import "PhraseTableViewDelegate.h"
#import "Constants.h"

@implementation PhraseTableViewController {
	NSWindow *_window;
	NSSplitView *_mainView;
	NSScrollView *_scrollView;
	NSTableView *_tableView;
	NSSearchField *_searchBar;
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

- (void)reloadNoticeReceived {
	[_tableView reloadData];
}

// TODO: make the view look nicer
- (id)initWithWindow:(NSWindow *)window {
	if(self = [super init]) {
		_window = window;

		_tableView = [[NSTableView alloc] init];
		[_tableView addTableColumn:[PhraseTableViewController createTableColumn:@"offsets"]];
		[_tableView addTableColumn:[PhraseTableViewController createTableColumn:@"phrases"]];
		_source = [[PhraseTableViewDataSource alloc] initWithData:[NSData dataWithContentsOfFile:[LANG_FILE stringByExpandingTildeInPath]]];
		_delegate = [[PhraseTableViewDelegate alloc] init];
		_tableView.dataSource = _source;
		_tableView.delegate = _delegate;
		[_tableView reloadData];

		_scrollView = [[NSScrollView alloc] init];
		_scrollView.documentView = _tableView;
		_scrollView.hasVerticalScroller = YES;

		_searchBar = [[NSSearchField alloc] init];
		[_searchBar.cell setPlaceholderString:@"Search..."];
		[_searchBar setDelegate:_source];
		[_searchBar.cell setSendsSearchStringImmediately:YES];
		_source.searchBar = _searchBar;

		_mainView = [[NSSplitView alloc] init];
		_mainView.dividerStyle = NSSplitViewDividerStyleThin;
		[_mainView addSubview:_searchBar];
		[_mainView addSubview:_scrollView];

		self.view = _mainView;

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNoticeReceived) name:@"phrases_reloaded" object:nil];
	}
	return self;
}

- (void)loadView {
	_window.contentView = self.view;
}

- (void)dealloc {
	[_scrollView release];
	[_searchBar release];
	[_mainView release];
	[_tableView release];
	[_source release];
	[_delegate release];
	[super dealloc];
}

@end
