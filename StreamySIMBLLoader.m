// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import "StreamySIMBLLoader.h"
#import "StreamyController.h"
#import "StreamyMenuController.h"

@implementation StreamySIMBLLoader

+ (void) load {
    static StreamySIMBLLoader *plugin = nil;
    
    if (plugin == nil)
        plugin = [[self alloc] init];
}

- (void) dealloc {
	[streamyController release];
	[super dealloc];
}

- (id) init {
	self = [super init];
	
	if (!self) {
		return nil;
	}
	
	#ifdef DEBUG
	NSLog(@"Streamy loaded!");
	#endif
	
	streamyController = [[StreamyController alloc] init];

	return self;
}
@synthesize streamyController;
@end
