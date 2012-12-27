//
//  DetailViewController.h
//  Social Network
//
//  Created by LD.Chirag on 12/16/12.
//  Copyright (c) 2012 LD.Chirag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "AppDelegate.h"


enum
{
    requestGetFaceBookFriend = 10000,
    requestGetUserInfotmation = 10001,
    
};

@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FBRequestDelegate,
FBDialogDelegate,
FBSessionDelegate>
{
    
    IBOutlet UITableView*facebook_friends_tableview;
    int requestType;
    AppDelegate*app_delegate;
    
    IBOutlet UIView*facebook_friends_tableview_header_view;
    
}
-(void)requestFaceBookUserFriends;


@end
