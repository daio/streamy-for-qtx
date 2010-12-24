// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import "StreamyController.h"
#import <objc/runtime.h>
#import <QuickTime/QuickTime.h>
#import <QuickTime/Movies.h>
#import "QTKit/QTKit.h"

#ifndef DEBUG
//#define DEBUG 1
#endif

@implementation StreamyController

- (id) init {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	[NSBundle loadNibNamed: @"StreamyMenu" owner: self];
	return self;
}

- (void) dealloc {
	CFRelease(self);
	[super dealloc];
}

- (IBAction) orderFrontAboutPanel: (id) sender {
	NSImage* icon = [[NSWorkspace sharedWorkspace] iconForFileType: @"bundle"];
	[icon setSize: NSMakeSize(128, 128)];
	NSDictionary* options;
	options = [NSDictionary dictionaryWithObjectsAndKeys:
			   @"Streamy", @"ApplicationName",
			   icon, @"ApplicationIcon",
			   @"0.1",@"Version",
			   @"",@"ApplicationVersion",
			   @"daioptych@gmail.com",@"Copyright",
			   nil];
	[NSApp orderFrontStandardAboutPanelWithOptions: options];
}

- (IBAction) refreshInfo: (id) sender {
	NSWindow *cur_window;
	NSArray *allwindows = [NSApp windows];
	NSEnumerator *window_enum = [allwindows objectEnumerator];
	NSMenuItem *new_item;	
	NSMenu *video_submenu;
	NSMenu *audio_submenu;
	NSMenu *other_submenu;
	NSDocument *qt_view;
	QTMovie *qt_movie;
	NSArray *tracks;
	QTTrack *track;
	QTMedia *media;
	NSEnumerator *tracks_enum;
	NSString *title;
	NSDocumentController *documentController = [NSDocumentController sharedDocumentController];
	while ([topMenu numberOfItems] > 2) {
		[topMenu removeItemAtIndex:2];
	}
	while ((cur_window = [window_enum nextObject]) != nil) {
		if ([cur_window canBecomeMainWindow]) {
			qt_view = [documentController documentForWindow:cur_window];
			if (qt_view != nil) {
				#ifdef DEBUG
				NSLog(@"%@",[[cur_window contentView] printJobTitle]);
				#endif
				qt_movie = nil;
				if ([qt_view respondsToSelector:@selector(movie)]) {
					#ifdef DEBUG
					NSLog(@"Found a movie!");
					#endif
					qt_movie = [qt_view movie];
				}
				if (qt_movie != nil) {
					tracks = [qt_movie tracks];
					tracks_enum = [tracks objectEnumerator];
					[topMenu addItem:[NSMenuItem separatorItem]];
					new_item = [[NSMenuItem allocWithZone:[self zone]] initWithTitle:[cur_window title] action:NULL keyEquivalent:@""];
					[new_item setTarget:cur_window];
					[new_item setAction:@selector(orderFront:)];
					[topMenu addItem:new_item];
					[new_item release];	
					video_submenu = [[NSMenu allocWithZone:[self zone]] initWithTitle:@"Video"];
					[video_submenu setAutoenablesItems:NO];
					audio_submenu = [[NSMenu allocWithZone:[self zone]] initWithTitle:@"Audio"];
					[audio_submenu setAutoenablesItems:NO];
					other_submenu = [[NSMenu allocWithZone:[self zone]] initWithTitle:@"Other"];
					[other_submenu setAutoenablesItems:NO];
					while ((track = [tracks_enum nextObject]) != nil) {
						media = [track media];
						title = [track attributeForKey:QTTrackDisplayNameAttribute];
						new_item = [[NSMenuItem allocWithZone:[self zone]] initWithTitle:title action:NULL keyEquivalent:@""];
						[new_item setRepresentedObject:track];
						[new_item setTarget:self];
						[new_item setAction:@selector(toggleTrack:)];
						if ([track isEnabled]) {
							[new_item setState:NSOnState];
						}
						else {
							[new_item setState:NSOffState];
						}
						[new_item setEnabled:YES];
						if ([[track attributeForKey:QTTrackMediaTypeAttribute] isEqualToString:@"vide" ]) {
							#ifdef DEBUG
							NSLog(@"Visual track: %@", [track attributeForKey:QTTrackMediaTypeAttribute]);
							#endif
							[video_submenu addItem:new_item];
						} else if ([[track attributeForKey:QTTrackMediaTypeAttribute] isEqualToString:@"soun"]) {
							#ifdef DEBUG
							NSLog(@"Audio track: %@",[track attributeForKey:QTTrackMediaTypeAttribute]);
							#endif
							[audio_submenu addItem:new_item];
						}
						else {
							#ifdef DEBUG
							NSLog(@"Other media: %@", [track attributeForKey:QTTrackMediaTypeAttribute]);
							#endif
							[other_submenu addItem:new_item];
						}
						[new_item release];
					}
					new_item = [[NSMenuItem allocWithZone:[self zone]] initWithTitle:@"Video" action:NULL keyEquivalent:@""];
					[new_item setSubmenu:video_submenu];
					[topMenu addItem:new_item];
					[new_item release];
					new_item = [[NSMenuItem allocWithZone:[self zone]] initWithTitle:@"Audio" action:NULL keyEquivalent:@""];
					[new_item setSubmenu:audio_submenu];
					[topMenu addItem:new_item];
					[new_item release];
					new_item = [[NSMenuItem allocWithZone:[self zone]] initWithTitle:@"Other" action:NULL keyEquivalent:@""];
					[new_item setSubmenu:other_submenu];
					[topMenu addItem:new_item];
					[new_item release];

					[video_submenu release];
					[audio_submenu release];
					[other_submenu release];
				}
			}
		}
	}
}

- (IBAction) toggleTrack: (id) sender {
	QTTrack *track = [sender representedObject];
	if (track != nil)
		if ([track isEnabled]) {
			[track setEnabled:NO];
		}
		else {
			[track setEnabled:YES];
		}
	[self refreshInfo:nil];
}

- (void) awakeFromNib {
	CFRetain(self);
	
    NSMenuItem* item;
	
    item = [[NSMenuItem alloc] init];
    [item setSubmenu: topMenu];
	
    [topMenu setTitle: @"Streamy"];
	[self refreshInfo:nil];
	
    [[NSApp mainMenu] addItem: item];
	[topMenu setAutoenablesItems:NO];
    [item release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateChanged:) name:QTMovieLoadStateDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateChanged:) name:QTMovieEditedNotification object:nil];
}

- (void) loadStateChanged: (NSNotification *) notification {
	#ifdef DEBUG
	NSLog(@"Load state changed");
	#endif
	[self refreshInfo:nil];
}

+ (void) load {
	[[self alloc] init];
	#ifdef DEBUG
	NSLog(@"Streamy loaded!");
	#endif
}

@end

