//
//  LoginViewController.h
//  Social Network
//
//  Created by  on 12/26/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "AppDelegate.h"
#import "SBJSON.h"
enum
{
    login_requestGetFaceBookFriend = 10000,
    login_requestGetUserInfotmation = 10001,
    
};

enum
{
    email_address_textfield_tag = 2001,
    password_textfield_tag = 2002,
};

@interface LoginViewController : UIViewController<UITextFieldDelegate,FBRequestDelegate,
FBDialogDelegate,
FBSessionDelegate>
{
    IBOutlet UIButton*create_account_button;
    IBOutlet UIButton*sign_in_button;
    IBOutlet UIButton*sign_in_using_fb_button;
    
    IBOutlet UITextField*email_address_textfield;
    IBOutlet UITextField*password_textfield;
    
    int requestType;
    
    IBOutlet UIScrollView*loginview_scrollview;
    
    //Webservie Part
    
    NSArray *requestObjects;
	NSArray *requestkeys;
	NSDictionary *requestJSONDict;
	NSMutableDictionary *finalJSONDictionary;
	NSString *jsonRequest;
	NSString *requestString;
	NSData *requestData;
	NSString *urlString;
	NSMutableURLRequest *request;
	NSData *returnData;
	NSError *error;
	SBJSON *json;
	NSDictionary *responseDataDictionary;
    //NSMutableArray *responseDataArray;
    
    
    IBOutlet UIActivityIndicatorView*process_activity_indicator;
    
    AppDelegate*app_delegate;
    
}


-(IBAction) create_account_button_clicked:(id)sender;
-(IBAction) sign_in_button_clicked:(id)sender;
-(IBAction) sign_in_using_fb_button_clicked:(id)sender;

@end
