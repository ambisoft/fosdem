/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Adam Ziolkowski <adam@adsized.com> and Leon Handreke <leon.handreke@gmail.com>
 * wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy us a beer in return.
 * ----------------------------------------------------------------------------
 */

#import "LAEventDetailViewController.h"
#import "VDLViewController.h"

@implementation LAEventDetailViewController

@synthesize event;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  // add
  [[NSNotificationCenter defaultCenter] addObserver: self
                                           selector: @selector(eventUpdated:)
                                               name: @"LAEventUpdated"
                                             object: nil];

  [self fillEvent];
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (BOOL)hidesBottomBarWhenPushed {
  return TRUE;
}


- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

-(IBAction) toggleStarred: (id) sender {
  if ([[self event] isStarred]) {
    [[self event] setStarred: NO];
  }
  else {
    [[self event] setStarred: YES];
  }
  NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys: [event identifier], @"identifier", [NSNumber  numberWithBool: [[self event] isStarred]], @"starred", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName: @"LAEventUpdated"
                                                      object: nil
                                                    userInfo: infoDict];
  [self updateToolbar];
}

- (void) eventUpdated: (NSNotification *) notification {
  NSDictionary *infoDict = [notification userInfo];
  //[self fillEvent];

/*  NSMutableDictionary *userData = [self userDataForEventWithIdentifier: [infoDict objectForKey: @"identifier"]];
  
  if ([infoDict objectForKey: @"starred"]) {
    // Change in the starred property
    [userData setObject: [infoDict objectForKey: @"starred"] forKey: @"starred"];
  }
  
  [[NSFileManager defaultManager] createDirectoryAtPath: [[LAEventDatabase userDataFileLocation] stringByDeletingLastPathComponent] withIntermediateDirectories: NO attributes: nil error: nil];
  
  [[self eventsUserData] writeToFile: [LAEventDatabase userDataFileLocation] atomically: NO];
 */
}


-(IBAction) playVideo: (id) sender {
  
  VDLViewController *vdlViewController = [[VDLViewController alloc] initWithNibName: @"VDLViewController" bundle: [NSBundle mainBundle]];
  
  [vdlViewController setContentVideo: [[self event] contentVideo]];
  [[self navigationController] pushViewController: vdlViewController animated: YES];
  
  //  if ([[self event] isStarred]) {
  //    [[self event] setStarred: NO];
  //  }
  //  else {
  //    [[self event] setStarred: YES];
  //  }
  //  [self updateToolbar];
}

- (void) fillEvent{
  self.navigationController.navigationBar.translucent = NO;
  
  [theTitle setText: event.speakerString];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat: @"EEE"];
  [dateFormatter setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT: 3600]];
  NSString *dayString = [dateFormatter stringFromDate: [event startDate]];
  [dateFormatter setDateFormat: @"H:mm"];
  
  //NSLog(@"dayString: %@", dayString);
  NSString *timeString = [NSString stringWithFormat: @"%@ - %@", [dateFormatter stringFromDate: [event startDate]], [dateFormatter stringFromDate: [event endDate]]];
  
  [time setText: [NSString stringWithFormat: @"%@ %@", dayString, timeString]];
  
  [location setText: [event location]];
  [track setText:[event track]];
  
  NSString *resourcePath = [[NSBundle mainBundle] bundlePath];
  NSURL *resourceURL = [NSURL fileURLWithPath: resourcePath];
  
  // Define description incase is returns blank for the database
  
  NSString *description = @"";
  if ([event contentDescription]){
    description = [event contentDescription];
  } else {
    description = @"No description could be found!";
  }
  
  NSString *templateString = [NSString stringWithContentsOfFile: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"template.html"] encoding: NSUTF8StringEncoding error:nil];
  NSString *HTMLString = [NSString stringWithFormat: templateString, [event title], description, [[LAEventDatabase sharedEventDatabase] mapHTMLForEvent: event], [[LAEventDatabase sharedEventDatabase] mapHTMLForConference]];
  [webView loadHTMLString: HTMLString  baseURL: resourceURL];
  
  // Initialize the toolbar
  [self updateToolbar];

 
  }

- (void) updateToolbar {
  
  UIBarButtonItem *button;
  UIBarButtonItem *playbutton;
  UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
  
  playbutton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"video.png"] style:UIBarButtonItemStylePlain target: self action: @selector(playVideo:)];
  
  if([[self event] isStarred]) {
    button = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"starOn.png"] style:UIBarButtonItemStylePlain target: self action: @selector(toggleStarred:)];
  } else {
    button = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"starOff.png"] style: UIBarButtonItemStylePlain target: self action: @selector(toggleStarred:)];
  }
  // add a video toolbar if there is a video
  // do not use containsString: does not play well with 6.x
  // NSLog(@"event: %@, video: %@", event.title, event.contentVideo);
  // NSRange will give a positive answer if the string is null, so we check for that first
  NSRange textRange =[[event contentVideo] rangeOfString:@"video.fosdem.org"];
  if(event.contentVideo && textRange.location != NSNotFound) {
    NSArray *toolbarItems = [NSArray arrayWithObjects: flexibleSpace, button, flexibleSpace, playbutton, nil];
    [toolbar setItems: toolbarItems];
  } else {
    NSArray *toolbarItems = [NSArray arrayWithObjects: flexibleSpace, button, flexibleSpace, nil];
    [toolbar setItems: toolbarItems];
  }
  
}

@end
