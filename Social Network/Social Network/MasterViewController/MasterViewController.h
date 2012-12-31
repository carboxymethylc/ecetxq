//
//  MasterViewController.h
//  Social Network
//
//  Created by  on 12/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "AppDelegate.h"
@class DetailViewController;


@interface MasterViewController : UIViewController<FBRequestDelegate,
FBDialogDelegate,
FBSessionDelegate>
{
    int requestType;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

-(IBAction)facebook_login_button_pressed:(id)sender;

@end
