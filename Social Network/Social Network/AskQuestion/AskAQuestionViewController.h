//
//  AskAQuestionViewController.h
//  Social Network
//
//  Created by LD.Chirag on 1/24/13.
//  Copyright (c) 2013 LD.Chirag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AskQueCustomCell.h"
@interface AskAQuestionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView*ask_question_tblView;
    IBOutlet UIView*ask_que_header_view;
    IBOutlet UIView*tbl_headerView;
    
    IBOutlet AskQueCustomCell*ask_que_custom_cell;
    
}

@property (nonatomic, retain) IBOutlet AskQueCustomCell*ask_que_custom_cell;
@property (nonatomic, retain) UINib *cellNib;
@end
