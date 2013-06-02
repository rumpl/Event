#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

#import "CalendarViewController.h"

@interface RootViewController : UITableViewController <EKEventEditViewDelegate, CalendarViewControllerDelegate> {
  NSArray* _events;
  EKEventStore* _eventStore;
}

@property (nonatomic, strong) NSArray* _events;
@property (nonatomic, strong) EKEventStore* _eventStore;

- (void)addEvent: (id)sender;
- (void)goToCalendars: (id)sender;
    
@end
