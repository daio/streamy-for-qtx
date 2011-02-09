// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import "StreamyMenuController.h"
#import <QuickTime/QuickTime.h>
#import <QTKit/QTKit.h>
#import "StreamySettingsController.h"
#import "StreamyMoviePropertiesController.h"

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
#pragma unused(sender)
	[[NSNotificationCenter defaultCenter] postNotificationName:StreamyNeedsRefresh object:self];
}


- (void) addMenuItem: (NSString *)menu_title:(SEL) menu_action:(id) menuTarget:(id) representedObject {
	NSMenuItem *newItem;
	
	newItem = [[NSMenuItem alloc] initWithTitle:menu_title action:menu_action keyEquivalent:@""];
	[newItem setTarget:menuTarget];
	if (representedObject != nil)
		[newItem setRepresentedObject:representedObject];
	[topMenu addItem:newItem];
	[newItem release];
}


- (void) showMovieProperties: (id) sender {
	QTMovie *qtMovie = (QTMovie *)[sender representedObject];
    [StreamyMoviePropertiesController showMoviePropertiesFor: qtMovie];
}


- (void) addMovieBanner: (QTMovie *) qtMovie :(NSWindow *) curWindow {
	[topMenu addItem:[NSMenuItem separatorItem]];
	[self addMenuItem: [curWindow title]: @selector(showMovieProperties:) : self : qtMovie];
}


- (NSMenu *) createCategoryMenu: (NSString *) title {
	NSMenu *new_menu = [[[NSMenu alloc] initWithTitle:title] autorelease];
	
	[new_menu setAutoenablesItems:NO];
	
	return new_menu;
}


- (void) addCategoryMenu:(NSMenu *) menu {
	NSMenuItem *newItem = [[NSMenuItem alloc] initWithTitle:[menu title] action:NULL keyEquivalent:@""];
	
	[newItem setHidden: ([menu numberOfItems] == 0)];
	[newItem setSubmenu:menu];
	[topMenu addItem:newItem];
	[newItem release];
}


- (int) getTrackType: (QTTrack *) track {
	int type = 0;
	short layer = [[track attributeForKey:QTTrackLayerAttribute] shortValue];
	NSString *mediaType = [track attributeForKey:QTTrackMediaTypeAttribute];
	if (([mediaType isEqualToString:QTMediaTypeSubtitle])||
		([mediaType isEqualToString:QTMediaTypeClosedCaption]))
		type = StreamySubtitleTrack;
	else if (([mediaType isEqualToString:QTMediaTypeSound])||
			 ([mediaType isEqualToString:QTMediaTypeMusic]))
		type = StreamyAudioTrack;
	else if ([mediaType isEqualToString:QTMediaTypeVideo]) {
		if (layer == -1) // Perian puts mkv subs on layer -1
			type = StreamySubtitleTrack;
		else
			type = StreamyVideoTrack;
	}
	else if (([mediaType isEqualToString:QTMediaTypeMovie])||
			 ([mediaType isEqualToString:QTMediaTypeFlash])||
			 ([mediaType isEqualToString:QTMediaTypeSprite])||
			 ([mediaType isEqualToString:QTMediaTypeMPEG])||
			 ([mediaType isEqualToString:QTMediaType3D])||
			 ([mediaType isEqualToString:QTMediaTypeMuxed]))
		type = StreamyVideoTrack;
	else 	
		type = StreamyOtherTrack;
	return type;
}


- (IBAction) toggleTrack: (id) sender {
	QTTrack *track = [sender representedObject];
	long trackType = [sender tag];
	BOOL trackEnabled = [track isEnabled];
	NSArray	*trackNeighbourItems = [[[sender parentItem] submenu] itemArray];
	NSMenuItem *trackNeighbour;
	
	#ifdef DEBUG
	NSLog(@"Toggled track: %@", track);		
	#endif
	
	if (!trackEnabled)
		if (([settingsController allowOnlyOneAudio] && (trackType == StreamyAudioTrack)) || 
			([settingsController allowOnlyOneSubtitle] && (trackType == StreamySubtitleTrack))) {
			for (trackNeighbour in trackNeighbourItems)
				[[trackNeighbour representedObject] setEnabled:NO];
		}

	[track setEnabled:!trackEnabled];
	
	[self postRefresh:sender];
}


- (void) addMovieMenu: (QTMovie *) qtMovie: (NSWindow *) curWindow {
	NSMenuItem *newItem;
	NSMenu *videoSubMenu;
	NSMenu *audioSubMenu;
	NSMenu *subtitleSubMenu;
	NSMenu *otherSubMenu;
	QTTrack *track;
	QTMovieLoadState loadState;
	NSAutoreleasePool *autoreleasePool;
	BOOL movieLoaded;
	int trackType;
	
	if (qtMovie != nil) {
		loadState = [[qtMovie attributeForKey:QTMovieLoadStateAttribute] integerValue];
		movieLoaded = loadState >= QTMovieLoadStatePlaythroughOK;
		if (loadState >= QTMovieLoadStateLoaded) {
			[self addMovieBanner:qtMovie:curWindow];
			autoreleasePool = [[NSAutoreleasePool alloc] init];
			
			videoSubMenu = [self createCategoryMenu: @"Video"];
			audioSubMenu = [self createCategoryMenu: @"Audio"];
			subtitleSubMenu = [self createCategoryMenu: @"Subtitles"];
			otherSubMenu = [self createCategoryMenu: @"Other"];
			
			for (track in [qtMovie tracks]) {
				newItem = [[NSMenuItem alloc] initWithTitle:[track attributeForKey:QTTrackDisplayNameAttribute]
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
						[newItem setTag:StreamyVideoTrack];
						[videoSubMenu addItem:newItem];
						break;
					case StreamyAudioTrack:
						[newItem setTag:StreamyAudioTrack];
						[audioSubMenu addItem:newItem];
						break;
					case StreamySubtitleTrack:
						[newItem setTag:StreamySubtitleTrack];
						[subtitleSubMenu addItem:newItem];
						break;
					default:
						[newItem setTag:StreamyOtherTrack];
						[otherSubMenu addItem:newItem];
						break;
				}
				
				#ifdef DEBUG
				NSLog(@"Media: %@", [track attributeForKey:QTTrackMediaTypeAttribute]);		
				#endif
				
				[newItem release];
			}
			
			[self addCategoryMenu: videoSubMenu];
			[self addCategoryMenu: audioSubMenu];
			[self addCategoryMenu: subtitleSubMenu];
			[self addCategoryMenu: otherSubMenu];
			[autoreleasePool drain];
		}
	}
	
}


- (IBAction) orderFrontAboutPanel: (id) sender {
#pragma unused(sender)
	NSImage* icon = [[NSWorkspace sharedWorkspace] iconForFileType: @"bundle"];
	[icon setSize: NSMakeSize(128, 128)];
	NSDictionary* options;
	
	options = [NSDictionary dictionaryWithObjectsAndKeys:
			   @"Streamy", @"ApplicationName",
			   icon, @"ApplicationIcon",
			   @"0.3",@"Version",
			   @"",@"ApplicationVersion",
			   @"Get the source code at GitHub!\nhttps://github.com/Daio/Streamy-for-QTX\nDaio <daioptych@gmail.com>",@"Copyright",
			   nil];
	
	[NSApp orderFrontStandardAboutPanelWithOptions: options];
}

- (void) callSettings: (id) sender {
#pragma unused(sender)
	[settingsController showSettings:self];
}

- (void) resetMenuToDefault {
	[topMenu removeAllItems];
	[topMenu setTitle: @"Streamy"];
	[topMenu setAutoenablesItems:NO];
	
	if ([settingsController showAboutInMenu])
		[self addMenuItem: @"About": @selector(orderFrontAboutPanel:) : self:nil];
	if ([settingsController showRefreshInMenu])
		[self addMenuItem: @"Refresh": @selector(postRefresh:) : self:nil];
	[self addMenuItem: @"Settings" : @selector(callSettings:) :self:nil];
}


- (void) awakeFromNib {		
	NSMenuItem* item;
	
	item = [[NSMenuItem alloc] init];
	[item setSubmenu: topMenu];
	[[NSApp mainMenu] addItem: item];
	[item release];
}

@synthesize topMenu;
@synthesize settingsController;
@end
