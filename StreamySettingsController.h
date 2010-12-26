// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import <Cocoa/Cocoa.h>

#define streamyAppID CFSTR("org.daio.Streamy")

NSString * const StreamySettingsCouldChange;

@interface StreamySettingsController : NSWindowController {
	IBOutlet NSButton *buttonAllowOnlyOneAudio;
	IBOutlet NSButton *buttonAllowOnlyOneSubtitle;
	IBOutlet NSButton *buttonShowRefreshInMenu;
	IBOutlet NSButton *buttonShowAboutInMenu;
@private
	IBOutlet NSWindow *settingsWindow;
}

- (BOOL) allowOnlyOneAudio;
- (BOOL) allowOnlyOneSubtitle;
- (BOOL) showRefreshInMenu;
- (BOOL) showAboutInMenu;

- (void) showSettings:(id) sender;

- (IBAction) setAllowOnlyOneAudio: (id) sender;
- (IBAction) setAllowOnlyOneSubtitle: (id) sender;
- (IBAction) setShowRefreshInMenu: (id) sender;
- (IBAction) setShowAboutInMenu: (id) sender;

@property (retain) NSButton *buttonAllowOnlyOneAudio;
@property (retain) NSButton *buttonAllowOnlyOneSubtitle;
@property (retain) NSButton *buttonShowRefreshInMenu;
@property (retain) NSButton *buttonShowAboutInMenu;
@property (retain) NSWindow *settingsWindow;
@end
