#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char *argv[]) {
	[NSApplication sharedApplication];
	[NSApp setDelegate:[[AppDelegate alloc] init]];
	[NSApp run];
	return 0;
}
