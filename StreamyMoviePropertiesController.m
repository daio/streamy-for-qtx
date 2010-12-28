// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import "StreamyMoviePropertiesController.h"
#import <QTKit/QTKit.h>
#import <QuickTime/QuickTime.h>

@implementation StreamyMoviePropertiesController


- (void) showWindow:(id)sender {
	[self showProperties:sender];
}


- (void) showProperties:(id)sender {
	
	[super showWindow:sender];
}


@synthesize buttonExtract;
@synthesize buttonDelete;
@synthesize tracksTable;
@synthesize annotationsTable;
@synthesize resourcesTable;
@end
