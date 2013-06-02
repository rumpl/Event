#import "CalendarViewController.h"

@implementation CalendarViewController

@synthesize _eventStore, _localCalendars, _otherCalendars, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"Calendars"];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"") style:UIBarButtonItemStyleDone  target:self action:@selector(done)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    
    self._eventStore = [[EKEventStore alloc] init];
    self._localCalendars = [[NSMutableArray alloc] init];
    self._otherCalendars = [[NSMutableArray alloc] init];
    
    
    for(EKCalendar *cal in [self._eventStore calendarsForEntityType:EKEntityTypeEvent]) {
        if([cal type] == EKCalendarTypeLocal) {
            [self._localCalendars addObject:[cal title]];
        } else {
            [self._otherCalendars addObject:[cal title]];
        }
    }
}

- (void) done {
    [[self delegate] didFinish];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"Local" : @"Other";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? [self._localCalendars count] : [self._otherCalendars count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CalendarCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    id calendars = indexPath.section == 0 ? self._localCalendars : self._otherCalendars;
    id ev = calendars[indexPath.row];
    cell.textLabel.text = ev;
    
    return cell;
}

@end
