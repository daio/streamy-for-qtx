// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import "StreamyMenuController.h"
#import <QuickTime/QuickTime.h>
#import <QTKit/QTKit.h>

@implementation StreamyMenuController
- (id) init : (NSString *) nibName {
	self = [super init];
	
	if (!self) {
		return nil;
	}
	
	[NSBundle loadNibNamed:nibName owner: self];
	
	#ifdef DEBUG
	NSLog(@"Menu controller initialized!");
	#endif
	
	return self;
}

- (void) postRefresh: (id) sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:QTMovieEditedNotification object:self];
}

- (void) addMenuItem: (NSString *)menu_title:(SEL) menu_action:(id) menu_target {
	NSMenuItem *new_item;
	
	new_item = [[NSMenuItem allocWithZone:[self zone]] initWithTitle:menu_title action:menu_action keyEquivalent:@""];
	[new_item setTarget:menu_target];
	[topMenu addItem:new_item];
	[new_item release];
}

- (void) addMovieBanner: (QTMovie *) qt_movie: (NSWindow *) cur_window {
	NSMenuItem *new_item;
	
	[topMenu addItem:[NSMenuItem separatorItem]];
	[self addMenuItem: [cur_window title]: @selector(orderFront:) : cur_window];
}

- (NSMenu *) createCategoryMenu: (NSString *) title {
	NSMenu *new_menu = [[NSMenu allocWithZone:[self zone]] initWithTitle:title];
	
	[new_menu setAutoenablesItems:NO];
	
	return new_menu;
}

- (void) addCategoryMenu:(NSMenu *) menu {
	NSMenuItem *new_item = [[NSMenuItem allocWithZone:[self zone]] initWithTitle:[menu title] action:NULL keyEquivalent:@""];
	
	[new_item setSubmenu:menu];
	[topMenu addItem:new_item];
	[new_item release];
}
- (IBAction) toggleTrack: (id) sender {
	QTTrack *track = [sender representedObject];
	#ifdef DEBUG
	NSLog(@"Toggled track: %@", [track description]);		
	#endif
	if (track != nil) {
		[track setEnabled:![track isEnabled]];
	}
	[self postRefresh:sender];
}

- (void) addMovieMenu: (QTMovie *) qt_movie: (NSWindow *) cur_window {
	NSEnumerator *tracks_enum;
	NSMenuItem *new_item;
	NSMenu *video_submenu;
	NSMenu *audio_submenu;
	NSMenu *other_submenu;
	QTTrack *track;
	
	if (qt_movie != nil) {
		tracks_enum = [[qt_movie tracks] objectEnumerator];
		[self addMovieBanner:qt_movie:cur_window];
		video_submenu = [self createCategoryMenu: @"Video"];
		audio_submenu = [self createCategoryMenu: @"Audio"];
		other_submenu = [self createCategoryMenu: @"Other"];
		while ((track = [tracks_enum nextObject]) != nil) {
			new_item = [[NSMenuItem allocWithZone:[self zone]] initWithTitle:[track attributeForKey:QTTrackDisplayNameAttribute]
																	  action:NULL keyEquivalent:@""];
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
				[video_submenu addItem:new_item];
			} else if ([[track attributeForKey:QTTrackMediaTypeAttribute] isEqualToString:@"soun"]) {
				[audio_submenu addItem:new_item];
			}
			else {		
				[other_submenu addItem:new_item];
			}
			#ifdef DEBUG
			NSLog(@"Media: %@", [track attributeForKey:QTTrackMediaTypeAttribute]);		
			#endif
			[new_item release];
		}
		[self addCategoryMenu: video_submenu];
		[self addCategoryMenu: audio_submenu];
		[self addCategoryMenu: other_submenu];
		
		[video_submenu release];
		[audio_submenu release];
		[other_submenu release];
	}
	
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

- (void) resetMenuToDefault {
	NSMenuItem* item;
	[topMenu removeAllItems];
	[topMenu setTitle: @"Streamy"];
	[topMenu setAutoenablesItems:NO];
	[self addMenuItem: @"About": @selector(orderFrontAboutPanel:) : self];
	[self addMenuItem: @"Refresh": @selector(postRefresh:) : self];
}

- (void) awakeFromNib {		
	NSMenuItem* item;
	
	item = [[NSMenuItem allocWithZone:[self zone]] init];
	[item setSubmenu: topMenu];
	[self resetMenuToDefault];
	[[NSApp mainMenu] addItem: item];
	[item release];
}


@end
