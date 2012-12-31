//
//  RegistrationViewController.h
//  Social Network
//
//  Created by  on 12/27/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "AppDelegate.h"
#import "DetailViewController.h"

enum
{
    registration_email_address_textfield_tag = 2001,
    registration_password_textfield_tag = 2002,
};

@interface RegistrationViewController : UIViewController<UITextFieldDelegate,FBRequestDelegate,
FBDialogDelegate,
FBSessionDelegate>
{
    IBOutlet UITextField*first_name_textField;
    IBOutlet UITextField*last_name_textField;
    IBOutlet UITextField*email_address_name_textField;
    IBOutlet UITextField*contact_number_textField;
    IBOutlet UITextField*password_textField;
    
    IBOutlet UIButton*signUp_button;
    IBOutlet UIButton*signUp_using_fb_button;
    IBOutlet UIButton *back_button;
    IBOutlet UIScrollView *registration_scrollview;
    
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
    //NSMutableArray *responseDataArray;//May be needed
    
    IBOutlet UIActivityIndicatorView*process_activity_indicator;
    AppDelegate*app_delegate;
    
}

-(IBAction)signUp_button_clicked:(id)sender;
-(IBAction)signUp_using_fb_button_clicked:(id)sender;
-(IBAction)back_button_clicked:(id)sender;
@property(nonatomic,strong)NSMutableArray *responseDataArray;
@end
