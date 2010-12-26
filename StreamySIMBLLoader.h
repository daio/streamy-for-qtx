// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import <Cocoa/Cocoa.h>
#import "StreamyMenuController.h"
#import "StreamyController.h"

@interface StreamySIMBLLoader : NSObject {
@private
	StreamyController *streamyController;
}

@property (nonatomic, retain) StreamyController *streamyController;
@end
