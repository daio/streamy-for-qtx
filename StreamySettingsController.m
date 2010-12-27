// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import "StreamySettingsController.h"

#define externalOneAudioKey		@"AllowOnlyOneAudio"
#define externalOneSubtitleKey	@"AllowOnlyOneSubtitle"
#define externalShowRefreshKey	@"ShowRefreshInMenu"
#define externalShowAboutKey	@"ShowAboutInMenu"

NSString * const StreamySettingsCouldChange = @"StreamySettingsCouldChange";

@implementation StreamySettingsController

- (id) init {
	self = [super initWithWindowNibName:@"StreamySettings"];
	
	if (self == nil) {
		return nil;
	}
	
	userDefaults = [NSUserDefaults standardUserDefaults];
	
	return self;
}

- (void) dealloc {
	[settingsWindow setReleasedWhenClosed:YES];
	[settingsWindow close];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}


- (void) syncSettings {
	[userDefaults synchronize];
}


- (void) settingsChanged {
	[[NSNotificationCenter defaultCenter] postNotificationName:StreamySettingsCouldChange object:self];
}


- (BOOL)boolForKey:(NSString *)key
{
	return [userDefaults boolForKey:key];
}

- (void) refreshButtonsStates {
	[buttonAllowOnlyOneAudio setState:[self boolForKey:externalOneAudioKey]];
	[buttonAllowOnlyOneSubtitle setState:[self boolForKey:externalOneSubtitleKey]];
	[buttonShowRefreshInMenu setState:[self boolForKey:externalShowRefreshKey]];
	[buttonShowAboutInMenu setState:[self boolForKey:externalShowAboutKey]];
}

- (void) showSettings: (id) sender {
    [self syncSettings];
	[self refreshButtonsStates];
	
	[self showWindow:sender];
}


- (IBAction) setAllowOnlyOneAudio: (id) sender {
	[userDefaults setBool:(BOOL)[sender state] forKey:externalOneAudioKey];
    [self syncSettings];
}


- (IBAction) setAllowOnlyOneSubtitle: (id) sender {
	[userDefaults setBool:(BOOL)[sender state] forKey:externalOneSubtitleKey];
    [self syncSettings];
}


- (IBAction) setShowRefreshInMenu: (id) sender {
	[userDefaults setBool:(BOOL)[sender state] forKey:externalShowRefreshKey];
    [self syncSettings];
}

- (IBAction) setShowAboutInMenu: (id) sender {
	[userDefaults setBool:(BOOL)[sender state] forKey:externalShowAboutKey];
    [self syncSettings];
}


- (BOOL) allowOnlyOneAudio {
	[self syncSettings];	
	return [self boolForKey:externalOneAudioKey];
}


- (BOOL) allowOnlyOneSubtitle {
	[self syncSettings];	
	return [self boolForKey:externalOneSubtitleKey];
}


- (BOOL) showRefreshInMenu {
	[self syncSettings];	
	return [self boolForKey:externalShowRefreshKey];
}


- (BOOL) showAboutInMenu {
	[self syncSettings];	
	return [self boolForKey:externalShowAboutKey];
}


- (void)awakeFromNib {
    [self syncSettings];

	[self setWindow:settingsWindow];
	[settingsWindow setWindowController:self];
	[settingsWindow setExcludedFromWindowsMenu:YES];
	
	[self refreshButtonsStates];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChanged) name:NSUserDefaultsDidChangeNotification object:userDefaults];
}

@synthesize buttonAllowOnlyOneAudio;
@synthesize buttonAllowOnlyOneSubtitle;
@synthesize buttonShowRefreshInMenu;
@synthesize buttonShowAboutInMenu;
@synthesize settingsWindow;
@synthesize userDefaults;
@end
