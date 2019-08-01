//
//  UsersMenu.m
//  同安政务
//
//  Created by _ADY on 15/12/18.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "UsersMenu.h"

@implementation UsersMenu

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.User_Account forKey:@"User_Account"];
    [encoder encodeObject:self.User_DspName forKey:@"User_DspName"];
    [encoder encodeObject:self.User_Email forKey:@"User_Email"];
    [encoder encodeObject:self.User_Tel forKey:@"User_Tel"];
    [encoder encodeObject:self.User_Mb forKey:@"User_Mb"];
    [encoder encodeObject:self.User_Fax forKey:@"User_Fax"];
    [encoder encodeObject:self.User_Sex forKey:@"User_Sex"];
    [encoder encodeObject:self.User_Delete forKey:@"User_Delete"];
    [encoder encodeObject:self.USER_Title forKey:@"USER_Title"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        
        self.User_Account = [decoder decodeObjectForKey:@"User_Account"];
        self.User_DspName = [decoder decodeObjectForKey:@"User_DspName"];
        self.User_Email = [decoder decodeObjectForKey:@"User_Email"];
        self.User_Tel = [decoder decodeObjectForKey:@"User_Tel"];
        self.User_Mb = [decoder decodeObjectForKey:@"User_Mb"];
        self.User_Fax = [decoder decodeObjectForKey:@"User_Fax"];
        self.User_Sex = [decoder decodeObjectForKey:@"User_Sex"];
        self.User_Delete = [decoder decodeObjectForKey:@"User_Delete"];
        self.USER_Title = [decoder decodeObjectForKey:@"USER_Title"];
        
    }
    
    return self;
    
}
@end
