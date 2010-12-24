//
//  StreamySIMBLLoader.m
//  QTStreamy
//
//  Created by Daio on 12/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StreamySIMBLLoader.h"
#import "StreamyController.h"
#import "StreamyMenuController.h"

@implementation StreamySIMBLLoader

+ (void) load {
	[[self alloc] init];
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
