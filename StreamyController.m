// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import "StreamyController.h"
#import <QuickTime/QuickTime.h>
#import <QuickTime/Movies.h>
#import "QTKit/QTKit.h"


@implementation StreamyController

- (id) init {
	self = [super init];
	
	if (!self) {
		return nil;
	}
	
	#ifdef DEBUG
	NSLog(@"Streamy controller initialized!");
	#endif
	
	menuController = [[StreamyMenuController alloc] init:@"StreamyMenu"];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInfo:) name:QTMovieLoadStateDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInfo:) name:QTMovieEditedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInfo:) name:StreamyNeedsRefresh object:menuController];
	
	return self;
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[menuController release];
	[super dealloc];
}

- (IBAction) refreshInfo: (id) sender {
#pragma unused(sender)
	NSWindow *curWindow;
	NSArray *allWindows = [NSApp windows];
	id qtView;
	NSDocumentController *documentController = [NSDocumentController sharedDocumentController];
	
	[menuController resetMenuToDefault];
	
	for (curWindow in allWindows) {
		qtView = [documentController documentForWindow:curWindow];
		
		if (qtView != nil) {			
			#ifdef DEBUG
			NSLog(@"%@",[[curWindow contentView] printJobTitle]);
			#endif
			
			if ([qtView respondsToSelector:@selector(movie)]) {
				#ifdef DEBUG
				NSLog(@"Found a movie!");
				#endif
				
				[menuController addMovieMenu:[qtView movie] :curWindow];
			}
		}
	}
}


- (void) loadStateChanged: (NSNotification *) notification {
#pragma unused(notification)
	#ifdef DEBUG
	NSLog(@"Load state changed");
	#endif
	
	[self refreshInfo:nil];
}

@synthesize menuController;
@end

