// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import <Cocoa/Cocoa.h>

#define streamyAppID CFSTR("org.daio.Streamy")

@interface StreamySettingsController : NSWindowController {
	IBOutlet NSButton *buttonAllowOnlyOneAudio;
	IBOutlet NSButton *buttonAllowOnlyOneSubtitle;
@private
	IBOutlet NSWindow *settingsWindow;
}

- (void) showSettings:(id) sender;
- (IBAction) setAllowOnlyOneAudio: (id) sender;
- (IBAction) setAllowOnlyOneSubtitle: (id) sender;

@property (retain) NSButton *buttonAllowOnlyOneAudio;
@property (retain) NSButton *buttonAllowOnlyOneSubtitle;
@end
