// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import <Cocoa/Cocoa.h>
#import <QuickTime/QuickTime.h>
#import "QTKit/QTKit.h"
#import "StreamyMenuController.h"

@interface StreamyController : NSObject {
@private
	StreamyMenuController *menuController;
}
- (id) init;
- (IBAction) refreshInfo: (id) sender;
@property (nonatomic, retain) StreamyMenuController *menuController;
@end
