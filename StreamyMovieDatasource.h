// Made by Daio <daioptych@gmail.com>
// Some rights reserved: <http://opensource.org/licenses/mit-license.php>

#import <Cocoa/Cocoa.h>
#import <QuickTime/QuickTime.h>
#import <QTKit/QTKit.h>

@interface StreamyMovieDatasource : NSObject <NSTableViewDataSource> {
@private
	QTMovie *movie;

}

@property (nonatomic, retain) QTMovie *movie;

@end
