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
	NSWindow *cur_window;
	NSArray *allwindows = [NSApp windows];
	NSEnumerator *window_enum = [allwindows objectEnumerator];
	NSDocument *qt_view;
	QTMovie *qt_movie;
	NSDocumentController *documentController = [NSDocumentController sharedDocumentController];
	
	[menu_controller resetMenuToDefault];
	
	while ((cur_window = [window_enum nextObject]) != nil) {
		qt_view = [documentController documentForWindow:cur_window];
		
		if (qt_view != nil) {			
			qt_movie = nil;
			
			#ifdef DEBUG
			NSLog(@"%@",[[cur_window contentView] printJobTitle]);
			#endif
			
			if ([qt_view respondsToSelector:@selector(movie)]) {
				#ifdef DEBUG
				NSLog(@"Found a movie!");
				#endif
				[menu_controller addMovieMenu:[qt_view movie] :cur_window];
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

@end

