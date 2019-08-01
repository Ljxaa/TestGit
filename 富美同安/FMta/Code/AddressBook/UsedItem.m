//
//  UsedItem.h
//  厦门信息集团
//
//  Created by _ADY on 15-3-31.
//  Copyright (c) 2015年 _ADY. All rights reserved.
//

#import "UsedItem.h"

@implementation UsedItem


- (void)encodeWithCoder:(NSCoder *)encoder

{
    
    [encoder encodeObject:self.SelectValue forKey:@"GPLD_User"];
    
    [encoder encodeObject:self.SelectText forKey:@"GPLD_UserDspName"];
    
    [encoder encodeObject:self.SetName forKey:@"SetName"];
    
    [encoder encodeObject:self.UserTitle forKey:@"USER_Title"];

}

- (id)initWithCoder:(NSCoder *)decoder

{
    if ((self = [super init])) {
        
        self.SelectValue = [decoder decodeObjectForKey:@"GPLD_User"];
        
        self.SelectText = [decoder decodeObjectForKey:@"GPLD_UserDspName"];
        
        self.SetName = [decoder decodeObjectForKey:@"SetName"];
        
        self.UserTitle = [decoder decodeObjectForKey:@"USER_Title"];

    }
    
    return self;
    
}

@end
