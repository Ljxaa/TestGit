//
//  DetialsItem.m
//  同安政务
//
//  Created by _ADY on 15/12/28.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "DetialsItem.h"

@implementation DetialsItem
- (void)encodeWithCoder:(NSCoder *)encoder

{
    
    [encoder encodeObject:self.Author forKey:@"Author"];
    
    [encoder encodeObject:self.ClassId forKey:@"ClassId"];
    
    [encoder encodeObject:self.Content forKey:@"Content"];
    
    [encoder encodeObject:self.Entity forKey:@"Entity"];
    
    [encoder encodeObject:self.PublishDate forKey:@"PublishDate"];
    
    [encoder encodeObject:self.Source forKey:@"Source"];
    
    [encoder encodeObject:self.RowID forKey:@"RowID"];
    
    [encoder encodeObject:self.Title forKey:@"Title"];
    
    [encoder encodeObject:self.Sumnary forKey:@"Sumnary"];
    
    [encoder encodeObject:self.OrderNo forKey:@"OrderNo"];
    
    [encoder encodeObject:self.IsScroll forKey:@"IsScroll"];
    
    [encoder encodeObject:self.PicDescription forKey:@"PicDescription"];
    
    [encoder encodeObject:self.PictureMain_id forKey:@"PictureMain_id"];
    
    [encoder encodeObject:self.PictureUrl forKey:@"PictureUrl"];
    
    [encoder encodeObject:self.PushMsg forKey:@"PushMsg"];
    
    [encoder encodeObject:self.VideoDesc forKey:@"VideoDesc"];
    
    [encoder encodeObject:self.VideoAddress forKey:@"VideoAddress"];
    
    [encoder encodeObject:self.Clicked forKey:@"Clicked"];
    
    [encoder encodeObject:self.Credits forKey:@"Credits"];
    
    [encoder encodeObject:self.CoverPhotoUrl forKey:@"CoverPhotoUrl"];
    
}

- (id)initWithCoder:(NSCoder *)decoder

{
    if ((self = [super init])) {
        
        self.Author = [decoder decodeObjectForKey:@"Author"];
        
        self.ClassId = [decoder decodeObjectForKey:@"ClassId"];
        
        self.Content = [decoder decodeObjectForKey:@"Content"];
        
        self.Entity = [decoder decodeObjectForKey:@"Entity"];
        
        self.PublishDate = [decoder decodeObjectForKey:@"PublishDate"];
        
        self.Source = [decoder
                       
                       decodeObjectForKey:@"Source"];
        
        self.RowID = [decoder decodeObjectForKey:@"RowID"];
        
        self.Title = [decoder decodeObjectForKey:@"Title"];
        
        self.Sumnary = [decoder decodeObjectForKey:@"Sumnary"];
        
        self.OrderNo = [decoder decodeObjectForKey:@"OrderNo"];
        
        self.IsScroll = [decoder decodeObjectForKey:@"IsScroll"];
        
        self.PicDescription = [decoder decodeObjectForKey:@"PicDescription"];
        
        self.PictureMain_id = [decoder decodeObjectForKey:@"PictureMain_id"];
        
        self.PictureUrl = [decoder decodeObjectForKey:@"PictureUrl"];
        
        self.PushMsg = [decoder decodeObjectForKey:@"PushMsg"];
        
        self.VideoDesc = [decoder decodeObjectForKey:@"VideoDesc"];
        
        self.VideoAddress = [decoder decodeObjectForKey:@"VideoAddress"];
        
        self.Clicked = [decoder decodeObjectForKey:@"Clicked"];
        
        self.Credits = [decoder decodeObjectForKey:@"Credits"];
        
        self.CoverPhotoUrl = [decoder decodeObjectForKey:@"CoverPhotoUrl"];

    }
    
    return self;
    
}
@end
