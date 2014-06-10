#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

void objc_main() {
	[NSApplication sharedApplication];
	[NSApp setDelegate:[[AppDelegate alloc] init]];
	[NSApp run];
}
