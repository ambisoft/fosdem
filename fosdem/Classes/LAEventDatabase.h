/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Adam Ziolkowski <adam@adsized.com> and Leon Handreke <leon.handreke@gmail.com>
 * wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy us a beer in return.
 * ----------------------------------------------------------------------------
 */

#import <Foundation/Foundation.h>

#import "NSDate+Between.h"

#import "LAEvent.h"
#import "LAEventsXMLParser.h"

@interface LAEventDatabase : NSObject {
  
  NSMutableArray *events;
  
  NSMutableDictionary *eventsUserData;
  
  //Caching CPU-intensive operations
  NSArray *cachedUniqueDays;
  NSMutableDictionary *eventsOnDayCache;
  NSArray *tracksCache;
}

+ (NSString *) eventDatabaseLocation;
+ (NSString *) userDataFileLocation;
+ (NSString* ) cachedDatabaseLocation;

+ (LAEventDatabase *) sharedEventDatabase;

//- (LAEventDatabase*) initWithDictionary: (NSDictionary *) dictionary;

- (LAEventDatabase *) initWithContentsOfFile: (NSString *) filePath;
- (void) parser: (LAEventsXMLParser *) parser foundEvent: (LAEvent *) event;
- (void) parserFinishedParsing:(LAEventsXMLParser *)parser;

- (NSArray *) uniqueDays;
- (NSArray *) eventsOnDay: (NSDate *) dayDate;

- (NSArray *) tracks;
- (NSArray *) eventsForTrack: (NSString*) trackName;
- (NSMutableArray *) starredEvents;
- (NSMutableArray *) videoEvents;

- (NSMutableDictionary *) userDataForEventWithIdentifier: (NSString *) identifier;
- (void) eventUpdated: (NSNotification *) notification;
- (void) updateEventWithUserData: (LAEvent *) event;

- (NSArray *) eventsWhile:(NSDate *)whileDate;
- (NSArray *)eventsInTimeInterval:(NSTimeInterval) timeInterval afterDate:(NSDate *)startDate;

// Clear out the caches
- (void) eventDatabaseUpdated: (NSNotification *) notification;

+ (void) resetMainEventDatabase;

- (NSString*) mapHTMLForEvent: (LAEvent*) event;
- (NSString*) mapHTMLForConference;

@property (retain) NSMutableArray *events;
@property (retain) NSMutableDictionary *eventsUserData;

@end
