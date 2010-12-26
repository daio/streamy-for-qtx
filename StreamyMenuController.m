// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import "StreamyMenuController.h"
#import <QuickTime/QuickTime.h>
#import <QTKit/QTKit.h>
#import "StreamySettingsController.h"

NSString * const StreamyNeedsRefresh = @"StreamyNeedsRefresh";

#define StreamyVideoTrack (int)1
#define StreamySubtitleTrack (int)2
#define StreamyAudioTrack (int)4
#define StreamyOtherTrack (int)8

@implementation StreamyMenuController

- (id) init : (NSString *) nibName {
	self = [super init];
	
	if (!self) {
		return nil;
	}
	
	[NSBundle loadNibNamed:nibName owner: self];
	
	settingsController = [[StreamySettingsController alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postRefresh:) name:StreamySettingsCouldChange object:settingsController];
	
	[self resetMenuToDefault];
	
	#ifdef DEBUG
	NSLog(@"Menu controller initialized!");
	#endif
	
	return self;
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[settingsController release];
	
	[super dealloc];	
}

- (void) postRefresh: (id) sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:StreamyNeedsRefresh object:self];
}


- (void) addMenuItem: (NSString *)menu_title:(SEL) menu_action:(id) menuTarget {
	NSMenuItem *newItem;
	
	newItem = [[NSMenuItem allocWithZone:[self zone]] initWithTitle:menu_title action:menu_action keyEquivalent:@""];
	[newItem setTarget:menuTarget];
	[topMenu addItem:newItem];
	[newItem release];
}


- (void) addMovieBanner: (QTMovie *) qtMovie: (NSWindow *) curWindow {
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


- (int) getTrackType: (QTTrack *) track {
	int type = 0;
	short layer = [[track attributeForKey:QTTrackLayerAttribute] shortValue];
	NSString *mediaType = [track attributeForKey:QTTrackMediaTypeAttribute];
	if ([mediaType isEqualToString:QTMediaTypeSubtitle])
		type = StreamySubtitleTrack;
	else if ([mediaType isEqualToString:QTMediaTypeSound])
		type = StreamyAudioTrack;
	else if ([mediaType isEqualToString:QTMediaTypeVideo ]) {
		if (layer == -1) // Perian puts mkv subs on layer -1
			type = StreamySubtitleTrack;
		else
			type = StreamyVideoTrack;
	}	
	else 	
		type = StreamyOtherTrack;
	return type;
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
	NSMenu *subtitleSubMenu;
	NSMenu *audioSubMenu;
	NSMenu *otherSubMenu;
	QTTrack *track;
	QTMovieLoadState loadState;
	BOOL movieLoaded;
	int trackType;
	
	if (qtMovie != nil) {
		tracksEnum = [[qtMovie tracks] objectEnumerator];
		loadState = [[qtMovie attributeForKey:QTMovieLoadStateAttribute] integerValue];
		movieLoaded = loadState >= QTMovieLoadStatePlaythroughOK;
		if (loadState >= QTMovieLoadStateLoaded) {
			[self addMovieBanner:qtMovie:curWindow];
			
			videoSubMenu = [self createCategoryMenu: @"Video"];
			subtitleSubMenu = [self createCategoryMenu: @"Subtitles"];
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

				trackType = [self getTrackType:track];
				switch (trackType) {
					case StreamyVideoTrack:
						[videoSubMenu addItem:newItem];
						break;
					case StreamySubtitleTrack:
						[subtitleSubMenu addItem:newItem];
						break;
					case StreamyAudioTrack:
						[audioSubMenu addItem:newItem];
						break;
					default:
						[otherSubMenu addItem:newItem];
						break;
				}
				
				#ifdef DEBUG
				NSLog(@"Media: %@", [track attributeForKey:QTTrackMediaTypeAttribute]);		
				#endif
				
				[newItem release];
			}
			
			[self addCategoryMenu: videoSubMenu];
			[self addCategoryMenu: subtitleSubMenu];
			[self addCategoryMenu: audioSubMenu];
			[self addCategoryMenu: otherSubMenu];
		}
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

- (void) callSettings: (id) sender {
	[settingsController showSettings:self];
}

- (void) resetMenuToDefault {
	[topMenu removeAllItems];
	[topMenu setTitle: @"Streamy"];
	[topMenu setAutoenablesItems:NO];
	
	if ([settingsController showAboutInMenu])
		[self addMenuItem: @"About": @selector(orderFrontAboutPanel:) : self];
	if ([settingsController showRefreshInMenu])
		[self addMenuItem: @"Refresh": @selector(postRefresh:) : self];
	[self addMenuItem: @"Settings" : @selector(callSettings:) :self];
}


- (void) awakeFromNib {		
	NSMenuItem* item;
	
	item = [[NSMenuItem allocWithZone:[self zone]] init];
	[item setSubmenu: topMenu];
	[[NSApp mainMenu] addItem: item];
	[item release];
}

@synthesize topMenu;
@synthesize settingsController;
@end
