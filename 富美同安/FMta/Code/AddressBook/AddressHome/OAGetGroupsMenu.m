//
//  OAGetGroupsMenu.m
//  同安政务
//
//  Created by _ADY on 16/1/20.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "OAGetGroupsMenu.h"

@implementation OAGetGroupsMenu



- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.Guid forKey:@"Guid"];
    [encoder encodeObject:self.Id forKey:@"Id"];
    [encoder encodeObject:self.PId forKey:@"PId"];
    [encoder encodeObject:self.Name forKey:@"Name"];
    [encoder encodeObject:self.IsShow forKey:@"IsShow"];
    [encoder encodeObject:self.OrderNo forKey:@"OrderNo"];
    [encoder encodeObject:self.Type forKey:@"Type"];
    [encoder encodeObject:self.TreeLevel forKey:@"TreeLevel"];
    [encoder encodeObject:self.GroupId forKey:@"GroupId"];
    [encoder encodeObject:self.UserAccount forKey:@"UserAccount"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        
        self.Guid = [decoder decodeObjectForKey:@"Guid"];
        self.Id = [decoder decodeObjectForKey:@"Id"];
        self.PId = [decoder decodeObjectForKey:@"PId"];
        self.Name = [decoder decodeObjectForKey:@"Name"];
        self.IsShow = [decoder decodeObjectForKey:@"IsShow"];
        self.OrderNo = [decoder decodeObjectForKey:@"OrderNo"];
        self.Type = [decoder decodeObjectForKey:@"Type"];
        self.TreeLevel = [decoder decodeObjectForKey:@"TreeLevel"];
        self.GroupId = [decoder decodeObjectForKey:@"GroupId"];
        self.UserAccount = [decoder decodeObjectForKey:@"UserAccount"];
        
    }
    
    return self;
    
}

@end
