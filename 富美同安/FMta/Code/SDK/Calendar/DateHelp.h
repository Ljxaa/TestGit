//
//  DateHelp.h
//  特房移动OA
//
//  Created by guo ghw on 13-9-23.
//  Copyright (c) 2013年 yiyihulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelp : NSObject {
    int year;
    int month; //1 to 12 inclusive
    int day; //1 to [self monthLength] inclusive
}

- (id) initWithMonth: (int) m day: (int) d year: (int) y;
- (int) monthLength; //Return the number of days in the month

//The following 3 methods are "getters"
- (int) year;
- (int) month;
- (int) day;

//These 3 are "setters"
- (void) setYear: (int) y;
- (void) setMonth: (int) m;
- (void) setDay: (int) d;

- (void) next; //Advance the Date one day into the future
- (void) next: (int) distance; //Advance the dates DISTANCE days into the future
+ (int) yearLength; //Return the number of days in the year

@end
