// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import "StreamySettingsController.h"

#define externalOneAudioKey	CFSTR("AllowOnlyOneAudio")
#define externalOneSubtitleKey	CFSTR("AllowOnlyOneSubtitle")

@implementation StreamySettingsController

- (id) init {
	self = [super initWithWindowNibName:@"StreamySettings"];
	
	if (self == nil) {
		return nil;
	}
	
	return self;
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[settingsWindow close];
	
	[super dealloc];
}
- (void) syncSettings {
	CFPreferencesAppSynchronize(streamyAppID);
}


- (BOOL)getBoolFromKey:(CFStringRef)key forAppID:(CFStringRef)appID withDefault:(BOOL)defaultValue
{	
	Boolean exists = FALSE;
	BOOL ret;
	
    [self syncSettings];
	ret = (BOOL)CFPreferencesGetAppBooleanValue(key, appID, &exists);
	
	return exists ? ret : defaultValue;
}


- (void) showSettings: (id) sender {
    [self syncSettings];
	
	[buttonAllowOnlyOneAudio setState:[self getBoolFromKey:externalOneAudioKey forAppID:streamyAppID withDefault:YES]];
	[buttonAllowOnlyOneSubtitle setState:[self getBoolFromKey:externalOneSubtitleKey forAppID:streamyAppID withDefault:YES]];
	
	[self showWindow:sender];
}


- (IBAction) setAllowOnlyOneAudio: (id) sender {
    [self syncSettings];
	
	CFPreferencesSetAppValue(externalOneAudioKey, [sender state] ? kCFBooleanTrue : kCFBooleanFalse, streamyAppID);
	
    [self syncSettings];
}


- (IBAction) setAllowOnlyOneSubtitle: (id) sender {
    [self syncSettings];
	
	CFPreferencesSetAppValue(externalOneSubtitleKey, [sender state] ? kCFBooleanTrue : kCFBooleanFalse, streamyAppID);
	
    [self syncSettings];
}


- (void)awakeFromNib {
    [self syncSettings];

	[self setWindow:settingsWindow];
	[settingsWindow setWindowController:self];
	[settingsWindow setExcludedFromWindowsMenu:YES];
	
	[buttonAllowOnlyOneAudio setState:[self getBoolFromKey:externalOneAudioKey forAppID:streamyAppID withDefault:YES]];
	[buttonAllowOnlyOneSubtitle setState:[self getBoolFromKey:externalOneSubtitleKey forAppID:streamyAppID withDefault:YES]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncSettings) name:NSWindowDidResignKeyNotification object:settingsWindow];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncSettings) name:NSWindowWillCloseNotification object:settingsWindow];
}

@synthesize buttonAllowOnlyOneAudio;
@synthesize buttonAllowOnlyOneSubtitle;
@end
