// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import <Cocoa/Cocoa.h>
#import <QuickTime/QuickTime.h>
#import <QTKit/QTKit.h>
#import "StreamySettingsController.h"

#ifndef DEBUG
//#define DEBUG 1
#endif

NSString * const StreamyNeedsRefresh;

@interface StreamyMenuController : NSObject {
@private
	NSMenu *topMenu;
	StreamySettingsController *settingsController;
}

- (id) init : (NSString *) title;

- (void) postRefresh: (id) sender;
- (void) addMovieMenu: (QTMovie *) qtMovie : (NSWindow *) curWindow;
- (void) resetMenuToDefault;

@property (nonatomic, retain, readonly) IBOutlet NSMenu* topMenu;
@property (nonatomic, retain, readonly) IBOutlet StreamySettingsController *settingsController;
@end
