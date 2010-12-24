// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import <Cocoa/Cocoa.h>
#include <QuickTime/QuickTime.h>
#import "QTKit/QTKit.h"


@interface StreamyController : NSObject {
	IBOutlet NSMenu* topMenu;
}
- (void) loadStateChanged: (NSNotification *) notification;
- (IBAction) orderFrontAboutPanel: (id) sender;
- (IBAction) refreshInfo: (id) sender;
- (IBAction) toggleTrack: (id) sender;
@end
