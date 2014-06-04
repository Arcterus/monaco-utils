#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	NSSize size = [NSScreen mainScreen].frame.size;
	_window = [[NSWindow alloc] initWithContentRect:NSMakeRect(size.width / 2 - 320, size.height / 2 - 240, 640, 480)
	                            styleMask:(NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask)
	                            backing:NSBackingStoreBuffered
	                            defer:NO];
	[_window orderFrontRegardless];
	[_window makeMainWindow];
}

- (void)dealloc {
	if(_window) {
		[_window dealloc];
	}
	[super dealloc];
}

@end
