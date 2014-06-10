#import "PhraseTableViewDataSource.h"
#import "Constants.h"
#include "../monamod.h"

#define STRING_TABLE_END 0x662c

@implementation PhraseTableViewDataSource {
	NSSearchField *_searchBar;
	NSMutableArray *_phrases;
	NSMutableArray *_visible;
}

@synthesize searchBar = _searchBar;

- (void)filterPhrases {
	[_visible removeAllObjects];
	NSString *filterStr = [_searchBar stringValue];
	if(filterStr == nil || [filterStr isEqualTo:@""]) {
		[_visible addObjectsFromArray:_phrases];
	} else {
		for(NSArray *arr in _phrases) {
			if([[arr objectAtIndex:1] rangeOfString:filterStr].location != NSNotFound) {
				[_visible addObject:[arr copy]];
			}
		}
	}
}

- (void)reloadPhrases {
	[self filterPhrases];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"phrases_reloaded" object:self];
}

- (void)reloadData:(NSData *)data {
	[_phrases removeAllObjects];
	uint8_t zeros[] = {0, 0, 0, 0, 0, 0, 0};
	NSData *sep = [NSData dataWithBytes:zeros length:sizeof(zeros)];
	NSMutableData *msg = [[NSMutableData alloc] init];
	for(int i = STRING_TABLE_END; i < [data length]; i++) {
		NSRange range = [data rangeOfData:sep options:0 range:NSMakeRange(i, [data length] - i)];
		if(range.location == NSNotFound) {
			break;
		}
		const void *bytes = [[data subdataWithRange:NSMakeRange(i, range.location - i)] bytes];
		for(int x = 0; x < range.location - i; x += 4) {
			[msg appendBytes:(bytes + x) length:1];
		}
		[_phrases addObject:[NSArray arrayWithObjects:[NSNumber numberWithInteger:i], [[NSString alloc] initWithData:msg encoding:NSISOLatin1StringEncoding], nil]];
		[msg setLength:0];
		i = range.location + sizeof(zeros) - 1;
	}
	[msg release];
	[self reloadPhrases];
}

- (id)initWithData:(NSData *)data {
	if(self = [super init]) {
		_phrases = [[NSMutableArray alloc] init];
		_visible = [[NSMutableArray alloc] init];
		[self reloadData:data];
	}
	return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [_visible count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex {
	if(rowIndex >= [_visible count]) {
		return nil;
	} else {
		NSArray *data = [_visible objectAtIndex:rowIndex];
		if([tableColumn.identifier isEqualTo:@"offsets"]) {
			return [data objectAtIndex:0];
		} else {
			return [data objectAtIndex:1];
		}
	}
}

// TODO: make a commit button?
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex {
	NSArray *data = [_visible objectAtIndex:rowIndex];
	monamod_sub_word([[data objectAtIndex:1] cStringUsingEncoding:NSISOLatin1StringEncoding], [object cStringUsingEncoding:NSISOLatin1StringEncoding]);
	[self reloadData:[NSData dataWithContentsOfFile:[LANG_FILE stringByExpandingTildeInPath]]];
}

- (void)controlTextDidChange:(NSNotification *)notification {
	[self reloadPhrases];
}

- (void)controlTextDidEndEditing:(NSNotification *)notification {
	[self reloadPhrases];
}

- (void)dealloc {
	[_phrases release];
	[_visible release];
	[super dealloc];
}

@end
