//
//  NewMenuItem.m
//  港务移动信息
//
//  Created by _ADY on 14-11-14.
//  Copyright (c) 2014年 _ADY. All rights reserved.
//

#import "NewMenuItem.h"

@implementation NewMenuItem


- (void)encodeWithCoder:(NSCoder *)encoder

{
    
    [encoder encodeObject:self.RowID forKey:@"RowID"];
    
    [encoder encodeObject:self.ClassName forKey:@"ClassName"];
    
    [encoder encodeObject:self.ParentId forKey:@"ParentId"];
    
    [encoder encodeObject:self.OrderNo forKey:@"OrderNo"];
    
    [encoder encodeObject:self.ClassLevel forKey:@"ClassLevel"];
    
    [encoder encodeObject:self.Entity forKey:@"Entity"];
    
    [encoder encodeObject:self.CreateDate forKey:@"CreateDate"];
    
    [encoder encodeObject:self.Title forKey:@"Title"];
    
}

- (id)initWithCoder:(NSCoder *)decoder

{
    if ((self = [super init])) {
        
        self.RowID = [decoder decodeObjectForKey:@"RowID"];
        
        self.ClassName = [decoder decodeObjectForKey:@"ClassName"];
        
        self.ParentId = [decoder decodeObjectForKey:@"ParentId"];
        
        self.OrderNo = [decoder decodeObjectForKey:@"OrderNo"];
        
        self.ClassLevel = [decoder decodeObjectForKey:@"ClassLevel"];
        
        self.Entity = [decoder decodeObjectForKey:@"Entity"];
        
        self.CreateDate = [decoder decodeObjectForKey:@"CreateDate"];
        
        self.Title = [decoder decodeObjectForKey:@"Title"];
        

        
    }
    
    return self;
    
}

@end
