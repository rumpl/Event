#import "RootViewController.h"

@interface RootViewController ()
-(void)reloadEvents;
@end

@implementation RootViewController

@synthesize _events, _eventStore;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", @"") style:UIBarButtonItemStyleBordered  target:self action:@selector(addEvent:)];
    [[self navigationItem] setRightBarButtonItem:homeButton];
    
    UIBarButtonItem *calendarsButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Calendars", @"") style:UIBarButtonItemStyleBordered  target:self action:@selector(goToCalendars:)];
    [[self navigationItem] setLeftBarButtonItem:calendarsButton];
    
    _eventStore = [[EKEventStore alloc] init];
    
    [self reloadEvents];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)reloadEvents {
    CFGregorianDate gregorianStartDate, gregorianEndDate;
    CFGregorianUnits startUnits = {-1, 0, 0, 0, 0, 0};
    CFGregorianUnits endUnits = {1, 0, 0, 0, 0, 0};
    CFTimeZoneRef timeZone = CFTimeZoneCopySystem();
    
    gregorianStartDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeAddGregorianUnits(CFAbsoluteTimeGetCurrent(), timeZone, startUnits), timeZone);
    gregorianStartDate.hour = 0;
    gregorianStartDate.minute = 0;
    gregorianStartDate.second = 0;
    
    gregorianEndDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeAddGregorianUnits(CFAbsoluteTimeGetCurrent(), timeZone, endUnits), timeZone);
    gregorianEndDate.hour = 0;
    gregorianEndDate.minute = 0;
    gregorianEndDate.second = 0;
    
    NSDate* startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:CFGregorianDateGetAbsoluteTime(gregorianStartDate, timeZone)];
    NSDate* endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:CFGregorianDateGetAbsoluteTime(gregorianEndDate, timeZone)];
    
    CFRelease(timeZone);
    // calendars:nil == All calendars.
    NSPredicate* predicate = [_eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
    self._events = [_eventStore eventsMatchingPredicate:predicate];
}

- (void)addEvent: (id)sender {
    EKEventEditViewController* controller = [[EKEventEditViewController alloc] init];
    controller.eventStore = _eventStore;
    controller.editViewDelegate = self;
    
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void)goToCalendars: (id)sender {
    CalendarViewController *controller = [[CalendarViewController alloc] initWithNibName:@"CalendarsView" bundle:nil];
    controller.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)didFinish {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
    [self reloadEvents];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    id ev = _events[indexPath.row];
    cell.textLabel.text = [ev title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        id cell = _events[indexPath.row];
        NSError *error;
        
        if([[self _eventStore] removeEvent:cell span:EKSpanThisEvent error:&error] == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Huston" message:@"Whoops! Something went wrong..." 
                                                           delegate:nil cancelButtonTitle:@"Nevermind" otherButtonTitles:nil];
            [alert show];
        }
        else {
            [self reloadEvents];
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EKEventEditViewController* controller = [[EKEventEditViewController alloc] init];
    controller.eventStore = _eventStore;
    controller.event = [self _events][indexPath.row];
    controller.editViewDelegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

