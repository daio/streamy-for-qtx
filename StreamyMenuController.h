// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import <Cocoa/Cocoa.h>
#import <QuickTime/QuickTime.h>
#import <QTKit/QTKit.h>

#ifndef DEBUG
//#define DEBUG 1
#endif
@interface StreamyMenuController : NSObject {
	IBOutlet NSMenu* topMenu;
}
- (id) init : (NSString *) title;
- (void) addMovieMenu: (QTMovie *) qtMovie : (NSWindow *) curWindow;
- (void) resetMenuToDefault;
@end
