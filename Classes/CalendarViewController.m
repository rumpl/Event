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

#import "CalendarViewController.h"

@implementation CalendarViewController

@synthesize _eventStore, _localCalendars, _otherCalendars, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"Calendars"];
    
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"") style:UIBarButtonItemStyleDone  target:self action:@selector(done)] autorelease];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    
    self._eventStore = [[EKEventStore alloc] init];
    self._localCalendars = [[NSMutableArray alloc] init];
    self._otherCalendars = [[NSMutableArray alloc] init];
    
    for(id cal in [self._eventStore calendars]) {
        if([cal type] == EKCalendarTypeLocal) {
            [self._localCalendars addObject:[cal title]];
        }
        else {
            [self._otherCalendars addObject:[cal title]];
        }
    }
}

- (void) done {
    [[self delegate] didFinish];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    id calendars = indexPath.section == 0 ? self._localCalendars : self._otherCalendars;
    id ev = [calendars objectAtIndex:indexPath.row];
    cell.textLabel.text = ev;
    
    return cell;
}

- (void)dealloc {
    [self._eventStore release];
    [self._localCalendars release];
    [self._otherCalendars release];
    
    [super dealloc];
}

@end
