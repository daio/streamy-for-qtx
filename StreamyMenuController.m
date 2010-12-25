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

- (void) addMenuItem: (NSString *)menu_title:(SEL) menu_action:(id) menuTarget {
	NSMenuItem *newItem;
	
	newItem = [[NSMenuItem allocWithZone:[self zone]] initWithTitle:menu_title action:menu_action keyEquivalent:@""];
	[newItem setTarget:menuTarget];
	[topMenu addItem:newItem];
	[newItem release];
}

- (void) addMovieBanner: (QTMovie *) qtMovie: (NSWindow *) curWindow {
	NSMenuItem *newItem;
	
	[topMenu addItem:[NSMenuItem separatorItem]];
	[self addMenuItem: [curWindow title]: @selector(orderFront:) : curWindow];
}

- (NSMenu *) createCategoryMenu: (NSString *) title {
	NSMenu *new_menu = [[NSMenu allocWithZone:[self zone]] initWithTitle:title];
	
	[new_menu setAutoenablesItems:NO];
	
	return new_menu;
}

- (void) addCategoryMenu:(NSMenu *) menu {
	NSMenuItem *newItem = [[NSMenuItem allocWithZone:[self zone]] initWithTitle:[menu title] action:NULL keyEquivalent:@""];
	
	[newItem setSubmenu:menu];
	[topMenu addItem:newItem];
	[newItem release];
	[menu release];
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

- (void) addMovieMenu: (QTMovie *) qtMovie: (NSWindow *) curWindow {
	NSEnumerator *tracksEnum;
	NSMenuItem *newItem;
	NSMenu *videoSubMenu;
	NSMenu *audioSubMenu;
	NSMenu *otherSubMenu;
	QTTrack *track;
	QTMovieLoadState loadState;
	BOOL movieLoaded;
	
	if (qtMovie != nil) {
		tracksEnum = [[qtMovie tracks] objectEnumerator];
		loadState = [[qtMovie attributeForKey:QTMovieLoadStateAttribute] integerValue];
		movieLoaded = loadState >= QTMovieLoadStatePlaythroughOK;
		
		[self addMovieBanner:qtMovie:curWindow];
		
		videoSubMenu = [self createCategoryMenu: @"Video"];
		audioSubMenu = [self createCategoryMenu: @"Audio"];
		otherSubMenu = [self createCategoryMenu: @"Other"];
		
		while ((track = [tracksEnum nextObject]) != nil) {
			newItem = [[NSMenuItem allocWithZone:[self zone]] initWithTitle:[track attributeForKey:QTTrackDisplayNameAttribute]
																	  action:NULL keyEquivalent:@""];
			[newItem setRepresentedObject:track];
			[newItem setTarget:self];
			[newItem setAction:@selector(toggleTrack:)];
			
			if ([track isEnabled])
				[newItem setState:NSOnState];
			else
				[newItem setState:NSOffState];
			
			[newItem setEnabled:movieLoaded];
			
			if ([[track attributeForKey:QTTrackMediaTypeAttribute] isEqualToString:@"vide" ])
				[videoSubMenu addItem:newItem];
			else if ([[track attributeForKey:QTTrackMediaTypeAttribute] isEqualToString:@"soun"])
				[audioSubMenu addItem:newItem];
			else 	
				[otherSubMenu addItem:newItem];
			
			#ifdef DEBUG
			NSLog(@"Media: %@", [track attributeForKey:QTTrackMediaTypeAttribute]);		
			#endif
			
			[newItem release];
		}
		
		[self addCategoryMenu: videoSubMenu];
		[self addCategoryMenu: audioSubMenu];
		[self addCategoryMenu: otherSubMenu];
	}
	
}

- (IBAction) orderFrontAboutPanel: (id) sender {
	NSImage* icon = [[NSWorkspace sharedWorkspace] iconForFileType: @"bundle"];
	[icon setSize: NSMakeSize(128, 128)];
	NSDictionary* options;
	
	options = [NSDictionary dictionaryWithObjectsAndKeys:
			   @"Streamy", @"ApplicationName",
			   icon, @"ApplicationIcon",
			   @"0.2",@"Version",
			   @"",@"ApplicationVersion",
			   @"Daio <daioptych@gmail.com>",@"Copyright",
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


@synthesize topMenu;
@end
