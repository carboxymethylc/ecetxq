//
//  AskAQuestionViewController.h
//  Social Network
//
//  Created by LD.Chirag on 1/24/13.
//  Copyright (c) 2013 LD.Chirag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AskQueCustomCell.h"
#import <MediaPlayer/MediaPlayer.h>
@interface AskAQuestionViewController : UIViewController<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    IBOutlet UITableView*ask_question_tblView;
    IBOutlet UIView*ask_que_header_view;
    IBOutlet UIView*tbl_headerView;
    IBOutlet AskQueCustomCell*ask_que_custom_cell;
    NSMutableDictionary*ask_question_dictionary;
    
    IBOutlet UIToolbar*toolBar;
    IBOutlet UIButton*button_choose_image_video;
    
    
    UIImagePickerController *imagePicker;
    
    
}

@property (nonatomic, retain) IBOutlet AskQueCustomCell*ask_que_custom_cell;
@property (nonatomic, retain) UINib *cellNib;

-(IBAction)btn_createPoll_clicked:(id)sender;
-(IBAction)btn_choose_photo_video_clicked:(id)sender;
-(IBAction)toolBar_donePressed:(id)sender;

-(IBAction)ask_friend_public_pressed:(id)sender;




@end
