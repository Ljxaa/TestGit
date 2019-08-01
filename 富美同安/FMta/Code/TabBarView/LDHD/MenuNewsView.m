//
//  MenuNewsView.m
//  同安政务
//
//  Created by _ADY on 15/12/25.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "MenuNewsView.h"
#import "Global.h"
@implementation MenuNewsView
@synthesize MenuLArray,delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = bgColor;
        
        vFrame = frame;
        
        UIImage *image = [[UIImage imageNamed:@"ShopsDDK"] stretchableImageWithLeftCapWidth:80 topCapHeight:50/2];
        UIImageView *bgImage = [[UIImageView alloc] initWithFrame:frame];
        [bgImage setImage:image];
        [self addSubview:bgImage];
        
        myTableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x+1, frame.origin.y+10, frame.size.width-2, frame.size.height-11)];
        myTableView.delegate = self;
        myTableView.dataSource = self;
//        [myTableView.layer setBorderWidth:1];
        [myTableView.layer setCornerRadius:7];
        [myTableView.layer setBorderColor:[UIColor grayColor].CGColor];
        myTableView.backgroundColor = bgColor;
        [self addSubview:myTableView];
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];//清除多余分割线
        [myTableView setTableFooterView:v];
        
    }
    
    return self;
}

-(void)reloadDataView
{
    [myTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return MenuLArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"search";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        aTableView.showsVerticalScrollIndicator = NO;
    }
    cell.backgroundColor = bgColor;
    int i = (int)[[cell.contentView subviews] count] - 1;
    for(;i >= 0 ; i--)
    {
        [[[cell.contentView subviews] objectAtIndex:i] removeFromSuperview];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"全部";
    }
    else
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[MenuLArray objectAtIndex:indexPath.row-1] objectForKey:@"ClassName"]];
    cell.textLabel.textAlignment = 1;
    
    UIImageView *_line1ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
    [_line1ImageView setFrame:CGRectMake(10, 30-2, vFrame.size.width-20, 2)];
    [cell.contentView addSubview:_line1ImageView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.delegate setIntPath:(int)indexPath.row];
}


@end

