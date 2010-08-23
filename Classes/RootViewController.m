// Event, calendar management for the iphone simulator
// Copyright (C) 2010  Djordje LUKIC

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
    
    UIBarButtonItem *homeButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", @"") style:UIBarButtonItemStyleBordered  target:self action:@selector(addEvent:)] autorelease];
    [[self navigationItem] setRightBarButtonItem:homeButton];
    
    UIBarButtonItem *calendarsButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Calendars", @"") style:UIBarButtonItemStyleBordered  target:self action:@selector(goToCalendars:)] autorelease];
    [[self navigationItem] setLeftBarButtonItem:calendarsButton];

    _eventStore = [[EKEventStore alloc] init];
    
    [self reloadEvents];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
    
    [self presentModalViewController: controller animated:YES];
    
    [controller release]; 
}

- (void)goToCalendars: (id)sender {
    CalendarViewController *controller = [[CalendarViewController alloc] initWithNibName:@"CalendarsView" bundle:nil];
    controller.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentModalViewController:nav animated:YES];
    
    [controller release];
    [nav release];
}

- (void)didFinish {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
    [self reloadEvents];
    [self.tableView reloadData];
    [self dismissModalViewControllerAnimated:YES];
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    id ev = [_events objectAtIndex:indexPath.row];
    cell.textLabel.text = [ev title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [_events objectAtIndex:indexPath.row];
    NSError *error;
    
    [[self _eventStore] removeEvent:cell span:EKSpanThisEvent error:&error];
    [self reloadEvents];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
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
    controller.event = [[self _events] objectAtIndex:indexPath.row];
    controller.editViewDelegate = self;
    [self presentModalViewController: controller animated:YES];
    [controller release];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
    [_events release];
    [_eventStore release];
    
    [super dealloc];
}

@end

