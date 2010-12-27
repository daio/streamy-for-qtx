// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import <Cocoa/Cocoa.h>

#define streamyAppID CFSTR("org.daio.Streamy")

NSString * const StreamySettingsCouldChange;

@interface StreamySettingsController : NSWindowController {
@private
	NSButton *buttonAllowOnlyOneAudio;
	NSButton *buttonAllowOnlyOneSubtitle;
	NSButton *buttonShowRefreshInMenu;
	NSButton *buttonShowAboutInMenu;
	NSWindow *settingsWindow;
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

@property (nonatomic, retain) IBOutlet NSButton *buttonAllowOnlyOneAudio;
@property (nonatomic, retain) IBOutlet NSButton *buttonAllowOnlyOneSubtitle;
@property (nonatomic, retain) IBOutlet NSButton *buttonShowRefreshInMenu;
@property (nonatomic, retain) IBOutlet NSButton *buttonShowAboutInMenu;
@property (nonatomic, retain) IBOutlet NSWindow *settingsWindow;
@end
