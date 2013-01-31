//
//  SetupCustomCell.h
//  VPNDemo
//
//  Created by LD.Chirag on 1/15/13.
//  Copyright (c) 2013 SunshineInfotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskQueCustomCell : UITableViewCell
{
    IBOutlet UIView*row1_view;
    IBOutlet UIView*row2_view;
    IBOutlet UIView*row3_view;
    IBOutlet UIView*row4_view;
    IBOutlet UIView*row5_view;
    
    IBOutlet UIButton*create_poll_button;
    
    
    
    IBOutlet UITextField*poll_textfield_1;//Tag starting from 2001
    IBOutlet UITextField*poll_textfield_2;//2002
    IBOutlet UITextField*poll_textfield_3;//2003
    IBOutlet UITextField*poll_textfield_4;//2004
    IBOutlet UITextField*poll_textfield_5;//2005
    
    
    IBOutlet UIButton*ask_publicly;//Tag 4001
    IBOutlet UIButton*ask_friend;//4002
    
    
 
}



@property(nonatomic,retain)   IBOutlet UIButton* create_poll_button;

@property(nonatomic,retain)   IBOutlet UIView*row1_view;
@property(nonatomic,retain)   IBOutlet UIView*row2_view;
@property(nonatomic,retain)   IBOutlet UIView*row3_view;
@property(nonatomic,retain)   IBOutlet UIView*row4_view;
@property(nonatomic,retain)   IBOutlet UIView*row5_view;

@property(nonatomic,retain)IBOutlet UITextField*poll_textfield_1;
@property(nonatomic,retain)IBOutlet UITextField*poll_textfield_2;
@property(nonatomic,retain)IBOutlet UITextField*poll_textfield_3;
@property(nonatomic,retain)IBOutlet UITextField*poll_textfield_4;
@property(nonatomic,retain)IBOutlet UITextField*poll_textfield_5;


@property(nonatomic,retain)IBOutlet UIButton*ask_publicly;
@property(nonatomic,retain)IBOutlet UIButton*ask_friend;



@end
