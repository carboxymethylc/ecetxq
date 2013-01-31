//
//  SetupCustomCell.m
//  VPNDemo
//
//  Created by LD.Chirag on 1/15/13.
//  Copyright (c) 2013 SunshineInfotech. All rights reserved.
//

#import "AskQueCustomCell.h"

@implementation AskQueCustomCell
@synthesize row1_view,row2_view,row3_view,row4_view,row5_view;
@synthesize poll_textfield_1,poll_textfield_2,poll_textfield_3,poll_textfield_4,poll_textfield_5;
@synthesize create_poll_button;
@synthesize ask_publicly,ask_friend;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc
{
    [poll_textfield_1 release];
    [poll_textfield_2 release];
    [poll_textfield_3 release];
    [poll_textfield_4 release];
    [poll_textfield_5 release];
    
    [row1_view release];
    [row2_view release];
    
    [ask_friend release];
    [ask_publicly release];
    
    [create_poll_button release];
    
    [super dealloc];
}

@end
