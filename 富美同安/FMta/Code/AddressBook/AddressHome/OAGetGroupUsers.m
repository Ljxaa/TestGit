//
//  OAGetGroupUsers.m
//  同安政务
//
//  Created by _ADY on 16/1/20.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "OAGetGroupUsers.h"

@implementation OAGetGroupUsers

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.Guid forKey:@"Guid"];
    [encoder encodeObject:self.Id forKey:@"Id"];
    [encoder encodeObject:self.ContactId forKey:@"ContactId"];
    [encoder encodeObject:self.Account forKey:@"Account"];
    [encoder encodeObject:self.DspName forKey:@"DspName"];
    [encoder encodeObject:self.Tel forKey:@"Tel"];
    [encoder encodeObject:self.Phone forKey:@"Phone"];
    [encoder encodeObject:self.Job forKey:@"Job"];
    
    [encoder encodeObject:self.Source forKey:@"Source"];
    [encoder encodeObject:self.AState forKey:@"AState"];
    [encoder encodeObject:self.A_Type1Ids forKey:@"A_Type1Ids"];
    [encoder encodeObject:self.HomeTel forKey:@"HomeTel"];
    [encoder encodeObject:self.Fax forKey:@"Fax"];
    [encoder encodeObject:self.IsLinkMan forKey:@"IsLinkMan"];
    [encoder encodeObject:self.GroupID forKey:@"GroupID"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
       
        self.Source = [decoder decodeObjectForKey:@"Source"];
        self.AState = [decoder decodeObjectForKey:@"AState"];
        self.A_Type1Ids = [decoder decodeObjectForKey:@"A_Type1Ids"];
        self.HomeTel = [decoder decodeObjectForKey:@"HomeTel"];
        self.Fax = [decoder decodeObjectForKey:@"Fax"];
        self.IsLinkMan = [decoder decodeObjectForKey:@"IsLinkMan"];
        self.GroupID = [decoder decodeObjectForKey:@"GroupID"];
        
        self.Guid = [decoder decodeObjectForKey:@"Guid"];
        self.Id = [decoder decodeObjectForKey:@"Id"];
        self.ContactId = [decoder decodeObjectForKey:@"ContactId"];
        self.Account = [decoder decodeObjectForKey:@"Account"];
        self.DspName = [decoder decodeObjectForKey:@"DspName"];
        self.Tel = [decoder decodeObjectForKey:@"Tel"];
        self.Phone = [decoder decodeObjectForKey:@"Phone"];
        self.Job = [decoder decodeObjectForKey:@"Job"];
        
    }
    
    return self;
    
}
@end
