// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import "StreamyController.h"
#import <objc/runtime.h>
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
	
	menu_controller = [[StreamyMenuController alloc] init:@"StreamyMenu"];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInfo:) name:QTMovieLoadStateDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInfo:) name:QTMovieEditedNotification object:nil];
	
	return self;
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[menu_controller release];
	[super dealloc];
}

- (IBAction) refreshInfo: (id) sender {
	NSWindow *curWindow;
	NSArray *allWindows = [NSApp windows];
	NSDocument *qtView;
	QTMovie *qtMovie;
	NSDocumentController *documentController = [NSDocumentController sharedDocumentController];
	
	[menu_controller resetMenuToDefault];
	
	for (curWindow in allWindows) {
		qtView = [documentController documentForWindow:curWindow];
		
		if (qtView != nil) {			
			qtMovie = nil;
			
			#ifdef DEBUG
			NSLog(@"%@",[[curWindow contentView] printJobTitle]);
			#endif
			
			if ([qtView respondsToSelector:@selector(movie)]) {
				#ifdef DEBUG
				NSLog(@"Found a movie!");
				#endif
				[menu_controller addMovieMenu:[qtView movie] :curWindow];
			}
		}
	}
}


- (void) loadStateChanged: (NSNotification *) notification {
	#ifdef DEBUG
	NSLog(@"Load state changed");
	#endif
	
	[self refreshInfo:nil];
}

@synthesize menu_controller;
@end

