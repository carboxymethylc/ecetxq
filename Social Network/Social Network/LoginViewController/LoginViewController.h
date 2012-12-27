//
//  LoginViewController.h
//  Social Network
//
//  Created by LD.Chirag on 12/26/12.
//  Copyright (c) 2012 LD.Chirag. All rights reserved.
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
    
}


-(IBAction) create_account_button_clicked:(id)sender;
-(IBAction) sign_in_button_clicked:(id)sender;
-(IBAction) sign_in_using_fb_button_clicked:(id)sender;

@end
