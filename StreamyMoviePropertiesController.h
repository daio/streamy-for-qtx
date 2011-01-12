// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>
#import <QuickTime/QuickTime.h>
#import "StreamyMovieDatasource.h"

@interface StreamyMoviePropertiesController : NSWindowController {
@private
	NSMutableArray * tracksArray;
	QTMovie * movie;
	NSButton * buttonExtract;
	NSButton * buttonDelete;
	NSTableView * tracksTable;
	NSTableView * annotationsTable;
	NSTableView * resourcesTable;
}

+ (void) showMoviePropertiesFor: (QTMovie *) qtMovie;

- (id) initWithMovie: (QTMovie *) qtMovie;

@property (nonatomic, retain) QTMovie * movie;
@property (nonatomic, retain) IBOutlet NSButton * buttonExtract;
@property (nonatomic, retain) IBOutlet NSButton * buttonDelete;
@property (nonatomic, retain) IBOutlet NSTableView * tracksTable;
@property (nonatomic, retain) IBOutlet NSTableView * annotationsTable;
@property (nonatomic, retain) IBOutlet NSTableView * resourcesTable;
@end
