/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Adam Ziolkowski <adam@adsized.com> and Leon Handreke <leon.handreke@gmail.com>
 * wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy us a beer in return.
 * ----------------------------------------------------------------------------
 */

#import <UIKit/UIKit.h>

#import "LAEventsTableViewController.h"
#import "LAEventDatabase.h"
#import "LAEvent.h"


@interface LAVideoTableViewController : LAEventsTableViewController

- (void)eventDatabaseUpdated;
@end
