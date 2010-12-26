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
	IBOutlet NSMenu *topMenu;
	IBOutlet StreamySettingsController *settingsController;
}

- (id) init : (NSString *) title;

- (void) postRefresh: (id) sender;
- (void) addMovieMenu: (QTMovie *) qtMovie : (NSWindow *) curWindow;
- (void) resetMenuToDefault;

@property (retain) NSMenu* topMenu;
@property (retain) StreamySettingsController *settingsController;
@end
