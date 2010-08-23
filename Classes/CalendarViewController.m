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

@synthesize _calendars, _eventStore, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"Calendars"];
    
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"") style:UIBarButtonItemStyleDone  target:self action:@selector(done)] autorelease];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    
    self._eventStore = [[EKEventStore alloc] init];
    self._calendars = [self._eventStore calendars];
}

- (void) done {
    if([[self delegate] respondsToSelector:@selector(didFinish)]) {
        [[self delegate] didFinish];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self._calendars count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id cal = [self._calendars objectAtIndex:section];
    
    if([cal type] ==  EKCalendarTypeLocal) {
        return @"Local";
    }
    
    return @"Other";
}

// This one needs a rewrite.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CalendarCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    id ev = [self._calendars objectAtIndex:(indexPath.section + indexPath.row)];
    cell.textLabel.text = [ev title];
    
    return cell;
}

- (void)dealloc {
    [self._eventStore release];
    
    [super dealloc];
}

@end
