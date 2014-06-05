#import "PhraseTableViewDataSource.h"

#define STRING_TABLE_END 0x662c

@implementation PhraseTableViewDataSource

- (id)initWithData:(NSData *)data {
	if(self = [super init]) {
		uint8_t zeros[] = {0, 0, 0, 0, 0, 0, 0};
		NSMutableArray *phrases = [[NSMutableArray alloc] init];
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
			[msg appendBytes:zeros length:1];
			[phrases addObject:[[NSString alloc] initWithData:msg encoding:NSISOLatin1StringEncoding]];
			[msg setLength:0];
			i = range.location + sizeof(zeros) - 1;
		}
		[msg release];
		_phrases = phrases;
	}
	return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [_phrases count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex {
	if(rowIndex >= [_phrases count]) {
		return nil;
	} else {
		return [_phrases objectAtIndex:rowIndex];
	}
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	// TODO: allow changing data
}

- (void)dealloc {
	[_phrases release];
	[super dealloc];
}

@end
