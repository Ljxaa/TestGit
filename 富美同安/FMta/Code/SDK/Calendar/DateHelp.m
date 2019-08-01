//
//  DateHelp.m
//  特房移动OA
//
//  Created by guo ghw on 13-9-23.
//  Copyright (c) 2013年 yiyihulian. All rights reserved.
//

#import "DateHelp.h"

@implementation DateHelp

- (id) initWithMonth:(int)m day:(int)d year:(int)y {
    //Send the init message to the superclass object in myself
    self = [super init];
    if (self != nil) {
        year = y;
        month = m;
        day = d;
    }
    
    return self;
}

//Put today's date into the newborn Date object.

- (id) init {
    self = [super init];
    if (self != nil) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
        
        NSDate *today = [[NSDate alloc] init];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *components = [calendar components: unitFlags fromDate: today];
        year = (int)components.year;
        month = (int)components.month;
        day = (int)components.day;
    }
    return self;
}

//Return the number of days in the month instance variable (1-31 inclusive)

- (int) monthLength {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    
    NSRange range = [calendar
                     rangeOfUnit:NSDayCalendarUnit
                     inUnit:NSMonthCalendarUnit
                     forDate:[calendar dateFromComponents:components]];
    
    return (int)range.length;
}

- (NSString *) description {
    return [NSString stringWithFormat: @"%d/%d/%d", month, day, year];
}

- (int) year {
    return year;
}

- (int) month {
    return month;
}

- (int) day {
    return day;
}

- (void) setYear: (int) y {
    year = y;
}

- (void) setMonth: (int) m {
    if (m < 1 || m > 12) {
        NSLog(@"setMonth: bad month %d", m);
        return;
    }
    month = m;
}

- (void) setDay: (int) d {
    if (d < 1 || d > [self monthLength]) {
        NSLog(@"setDay: bad day %d with month %d", d, month);
        return;
    }
    
    day = d;
}

//Return YES if this Date is equal to the other Date, NO otherwise.

- (BOOL) isEqual: (DateHelp *) another {
    return year == another.year
    && month == another.month
    && day == another.day;
}

//Advance the Date on day into the future.
//This method accepts no arguments

- (void) next {
    if (day < [self monthLength]) {
        ++day;
        return;
    }
    
    day = 1;
    if (month < [DateHelp yearLength]) {
        ++month;
        return;
    }
    
    month = 1;
    ++year;
}

/* Advance the Date many days into the future.
 This method accepts one argument.
 It does the bulk of its work by calling the above method over and over
 */

- (void) next: (int) distance {
    if (distance < 0) {
        NSLog(@"argument %d of next: must be non-negative", distance);
        return;
    }
    
    for (int i = 1; i <= distance; ++i) {
        [self next];
    }
}

// Return the number of months in a year. A class method is marked with a +

+ (int) yearLength {
    return 12;
}

@end
