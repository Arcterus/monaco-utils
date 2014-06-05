#import "AppDelegate.h"
#import "PhraseTableViewController.h"

@implementation AppDelegate {
	PhraseTableViewController *_phraseController;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	// Make main window
	NSSize size = [NSScreen mainScreen].frame.size;
	_window = [[NSWindow alloc] initWithContentRect:NSMakeRect(size.width / 2 - 320, size.height / 2 - 240, 640, 480)
	                            styleMask:(NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask)
	                            backing:NSBackingStoreBuffered
	                            defer:NO];
	[_window orderFrontRegardless];
	[_window makeMainWindow];
	[_window makeKeyWindow];

	// Make controller for table view with phrases
	_phraseController = [[PhraseTableViewController alloc] initWithWindow:_window];

	// load table view with phrases into main window
	[_phraseController loadView];
}

- (void)dealloc {
	[_window release];
	[_phraseController release];
	[super dealloc];
}

@end
