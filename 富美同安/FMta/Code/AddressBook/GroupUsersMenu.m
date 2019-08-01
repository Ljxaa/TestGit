//
//  GroupUsersMenu.m
//  同安政务
//
//  Created by _ADY on 15/12/18.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "GroupUsersMenu.h"

@implementation GroupUsersMenu

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.GroupName forKey:@"GroupName"];
    [encoder encodeObject:self.GPLD_GroupID forKey:@"GPLD_GroupID"];
    [encoder encodeObject:self.GPLD_Group forKey:@"GPLD_Group"];
    [encoder encodeObject:self.GPLD_User forKey:@"GPLD_User"];
    [encoder encodeObject:self.GPLD_UserDspName forKey:@"GPLD_UserDspName"];
    [encoder encodeObject:self.GPLD_JobTitle forKey:@"GPLD_JobTitle"];
    [encoder encodeObject:self.IsLeader forKey:@"IsLeader"];
    [encoder encodeObject:self.GPLD_Ord forKey:@"GPLD_Ord"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        
        self.GroupName = [decoder decodeObjectForKey:@"GroupName"];
        self.GPLD_GroupID = [decoder decodeObjectForKey:@"GPLD_GroupID"];
        self.GPLD_Group = [decoder decodeObjectForKey:@"GPLD_Group"];
        self.GPLD_User = [decoder decodeObjectForKey:@"GPLD_User"];
        self.GPLD_UserDspName = [decoder decodeObjectForKey:@"GPLD_UserDspName"];
        self.GPLD_JobTitle = [decoder decodeObjectForKey:@"GPLD_JobTitle"];
        self.IsLeader = [decoder decodeObjectForKey:@"IsLeader"];
        self.GPLD_Ord = [decoder decodeObjectForKey:@"GPLD_Ord"];
        
    }
    
    return self;
    
}
@end
