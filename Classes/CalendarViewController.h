#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@protocol CalendarViewControllerDelegate;

@interface CalendarViewController : UITableViewController {
@private
    NSMutableArray *_localCalendars;
    NSMutableArray *_otherCalendars;
    EKEventStore *_eventStore;
    
@public
    id <CalendarViewControllerDelegate> __weak delegate;
}

@property (nonatomic, strong) EKEventStore *_eventStore;
@property (nonatomic, strong) NSMutableArray *_localCalendars;
@property (nonatomic, strong) NSMutableArray *_otherCalendars;

@property (nonatomic, weak) id delegate;
@end

@protocol CalendarViewControllerDelegate
- (void)didFinish;
@end

