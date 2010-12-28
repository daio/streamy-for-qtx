// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import <Cocoa/Cocoa.h>


@interface StreamyMoviePropertiesController : NSWindowController {
@private
	NSButton * buttonExtract;
	NSButton * buttonDelete;
	NSTableView * tracksTable;
	NSTableView * annotationsTable;
	NSTableView * resourcesTable;
}



@property (nonatomic, retain) IBOutlet NSButton * buttonExtract;
@property (nonatomic, retain) IBOutlet NSButton * buttonDelete;
@property (nonatomic, retain) IBOutlet NSTableView * tracksTable;
@property (nonatomic, retain) IBOutlet NSTableView * annotationsTable;
@property (nonatomic, retain) IBOutlet NSTableView * resourcesTable;
@end
