// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import "StreamySettingsController.h"

#define externalOneAudioKey		CFSTR("AllowOnlyOneAudio")
#define externalOneSubtitleKey	CFSTR("AllowOnlyOneSubtitle")
#define externalShowRefreshKey	CFSTR("ShowRefreshInMenu")
#define externalShowAboutKey	CFSTR("ShowAboutInMenu")

NSString * const StreamySettingsCouldChange = @"StreamySettingsCouldChange";

@implementation StreamySettingsController

- (id) init {
	self = [super initWithWindowNibName:@"StreamySettings"];
	
	if (self == nil) {
		return nil;
	}
	
	return self;
}

- (void) dealloc {
	[settingsWindow setReleasedWhenClosed:YES];
	[settingsWindow close];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}


- (void) syncSettings {
	CFPreferencesAppSynchronize(streamyAppID);
}


- (void) settingsChanged {
	[[NSNotificationCenter defaultCenter] postNotificationName:StreamySettingsCouldChange object:self];
}


- (BOOL)getBoolFromKey:(CFStringRef)key withDefault:(BOOL)defaultValue
{	
	Boolean exists = FALSE;
	BOOL ret;
	
    [self syncSettings];
	ret = (BOOL)CFPreferencesGetAppBooleanValue(key, streamyAppID, &exists);
	
	return exists ? ret : defaultValue;
}

- (void) refreshButtonsStates {
	[buttonAllowOnlyOneAudio setState:[self getBoolFromKey:externalOneAudioKey withDefault:YES]];
	[buttonAllowOnlyOneSubtitle setState:[self getBoolFromKey:externalOneSubtitleKey withDefault:YES]];
	[buttonShowRefreshInMenu setState:[self getBoolFromKey:externalShowRefreshKey withDefault:YES]];
	[buttonShowAboutInMenu setState:[self getBoolFromKey:externalShowAboutKey withDefault:YES]];
}

- (void) showSettings: (id) sender {
    [self syncSettings];
	[self refreshButtonsStates];
	
	[self showWindow:sender];
}


- (IBAction) setAllowOnlyOneAudio: (id) sender {
	CFPreferencesSetAppValue(externalOneAudioKey, [sender state] ? kCFBooleanTrue : kCFBooleanFalse, streamyAppID);
	
    [self syncSettings];
	[self settingsChanged];
}


- (IBAction) setAllowOnlyOneSubtitle: (id) sender {
	CFPreferencesSetAppValue(externalOneSubtitleKey, [sender state] ? kCFBooleanTrue : kCFBooleanFalse, streamyAppID);
	
    [self syncSettings];
	[self settingsChanged];
}


- (IBAction) setShowRefreshInMenu: (id) sender {
	CFPreferencesSetAppValue(externalShowRefreshKey, [sender state] ? kCFBooleanTrue : kCFBooleanFalse, streamyAppID);
	
    [self syncSettings];
	[self settingsChanged];
}

- (IBAction) setShowAboutInMenu: (id) sender {
	CFPreferencesSetAppValue(externalShowAboutKey, [sender state] ? kCFBooleanTrue : kCFBooleanFalse, streamyAppID);
	
    [self syncSettings];
	[self settingsChanged];
}


- (BOOL) allowOnlyOneAudio {
	[self syncSettings];
	
	return [self getBoolFromKey:externalOneAudioKey withDefault:YES];
}


- (BOOL) allowOnlyOneSubtitle {
	[self syncSettings];
	
	return [self getBoolFromKey:externalOneSubtitleKey withDefault:YES];
}


- (BOOL) showRefreshInMenu {
	[self syncSettings];
	
	return [self getBoolFromKey:externalShowRefreshKey withDefault:YES];
}


- (BOOL) showAboutInMenu {
	[self syncSettings];
	
	return [self getBoolFromKey:externalShowAboutKey withDefault:YES];
}


- (void) outOfSettings {
	[self syncSettings];
	[self settingsChanged];
}


- (void)awakeFromNib {
    [self syncSettings];

	[self setWindow:settingsWindow];
	[settingsWindow setWindowController:self];
	[settingsWindow setExcludedFromWindowsMenu:YES];
	
	[self refreshButtonsStates];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outOfSettings) name:NSWindowDidResignKeyNotification object:settingsWindow];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outOfSettings) name:NSWindowWillCloseNotification object:settingsWindow];
}

@synthesize buttonAllowOnlyOneAudio;
@synthesize buttonAllowOnlyOneSubtitle;
@synthesize buttonShowRefreshInMenu;
@synthesize buttonShowAboutInMenu;
@synthesize settingsWindow;
@end
