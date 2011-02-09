// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import <Cocoa/Cocoa.h>

NSString * const StreamySettingsCouldChange;

@interface StreamySettingsController : NSWindowController {
@private
	NSButton *buttonAllowOnlyOneAudio;
	NSButton *buttonAllowOnlyOneSubtitle;
	NSButton *buttonShowRefreshInMenu;
	NSButton *buttonShowAboutInMenu;
	NSUserDefaults *userDefaults;
}

- (BOOL) allowOnlyOneAudio;
- (BOOL) allowOnlyOneSubtitle;
- (BOOL) showRefreshInMenu;
- (BOOL) showAboutInMenu;

- (void) showWindow:(id) sender;
- (void) showSettings:(id) sender;

- (IBAction) setAllowOnlyOneAudio: (id) sender;
- (IBAction) setAllowOnlyOneSubtitle: (id) sender;
- (IBAction) setShowRefreshInMenu: (id) sender;
- (IBAction) setShowAboutInMenu: (id) sender;

@property (nonatomic, retain, readonly) IBOutlet NSButton *buttonAllowOnlyOneAudio;
@property (nonatomic, retain, readonly) IBOutlet NSButton *buttonAllowOnlyOneSubtitle;
@property (nonatomic, retain, readonly) IBOutlet NSButton *buttonShowRefreshInMenu;
@property (nonatomic, retain, readonly) IBOutlet NSButton *buttonShowAboutInMenu;
@property (nonatomic, retain, readonly) NSUserDefaults *userDefaults;
@end
