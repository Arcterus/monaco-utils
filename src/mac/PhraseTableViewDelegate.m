#import "PhraseTableViewDelegate.h"

@implementation PhraseTableViewDelegate

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)column row:(NSInteger)rowIndex {
	return [column.identifier isEqualTo:@"phrases"];
}

@end
