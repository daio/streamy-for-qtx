// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import <Cocoa/Cocoa.h>
#include <QuickTime/QuickTime.h>
#import "QTKit/QTKit.h"
#import "StreamyMenuController.h"

@interface StreamyController : NSObject {
	StreamyMenuController *menu_controller;
}
- (id) init;
- (IBAction) refreshInfo: (id) sender;
@end
