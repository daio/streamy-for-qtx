// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import "StreamyMoviePropertiesController.h"
#import <QTKit/QTKit.h>
#import <QuickTime/QuickTime.h>

@implementation StreamyMoviePropertiesController

- (void) buildTracksArray {
	QTTrack *track;
	
	if (movie != nil)
		for (track in [movie tracks])
			[tracksArray insertObject:[track description]
							  atIndex:(NSUInteger)[track attributeForKey:QTTrackIDAttribute]]; 
}

- (void) refreshTracksTable {
	[self buildTracksArray];
}


+ (void) showMoviePropertiesFor: (QTMovie *) qtMovie {
    [[self alloc] initWithMovie: qtMovie];
}

- (id) initWithMovie: (QTMovie *) qtMovie {
	self = [super initWithWindowNibName:@"StreamyMovieProperties"];
	
	if (self == nil)
		return nil;
	
	movie = qtMovie;
	
	[self refreshTracksTable];
	
    [self showWindow: nil];
	return self;
}

@synthesize movie;
@synthesize buttonExtract;
@synthesize buttonDelete;
@synthesize tracksTable;
@synthesize annotationsTable;
@synthesize resourcesTable;
@end
