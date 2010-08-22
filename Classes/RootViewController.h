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

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

#import "CalendarViewController.h"

@interface RootViewController : UITableViewController <EKEventEditViewDelegate, CalendarViewControllerDelegate> {
  NSArray* _events;
  EKEventStore* _eventStore;
}

@property (nonatomic, retain) NSArray* _events;
@property (nonatomic, retain) EKEventStore* _eventStore;

- (void)addEvent: (id)sender;
- (void)goToCalendars: (id)sender;
    
@end
