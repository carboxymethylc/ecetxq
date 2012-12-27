//
//  MasterViewController.h
//  Social Network
//
//  Created by LD.Chirag on 12/16/12.
//  Copyright (c) 2012 LD.Chirag. All rights reserved.
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
