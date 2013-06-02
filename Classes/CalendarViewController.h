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

