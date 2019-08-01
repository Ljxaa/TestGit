//
//  GroupsMenu.m
//  同安政务
//
//  Created by _ADY on 15/12/18.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "GroupsMenu.h"

@implementation GroupsMenu


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.Group_Code forKey:@"Group_Code"];
    [encoder encodeObject:self.Group_ID forKey:@"Group_ID"];
    [encoder encodeObject:self.Group_IsShow forKey:@"Group_IsShow"];
    [encoder encodeObject:self.Group_Level forKey:@"Group_Level"];
    [encoder encodeObject:self.Group_Name forKey:@"Group_Name"];
    [encoder encodeObject:self.Group_Parent forKey:@"Group_Parent"];
    [encoder encodeObject:self.Group_ParentID forKey:@"Group_ParentID"];
    [encoder encodeObject:self.Group_Type forKey:@"Group_Type"];

}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        
        self.Group_Code = [decoder decodeObjectForKey:@"Group_Code"];
        self.Group_ID = [decoder decodeObjectForKey:@"Group_ID"];
        self.Group_IsShow = [decoder decodeObjectForKey:@"Group_IsShow"];
        self.Group_Level = [decoder decodeObjectForKey:@"Group_Level"];
        self.Group_Name = [decoder decodeObjectForKey:@"Group_Name"];
        self.Group_Parent = [decoder decodeObjectForKey:@"Group_Parent"];
        self.Group_ParentID = [decoder decodeObjectForKey:@"Group_ParentID"];
        self.Group_Type = [decoder decodeObjectForKey:@"Group_Type"];

        
    }
    
    return self;
    
}

@end
