//
//  RegistrationViewController.h
//  Social Network
//
//  Created by LD.Chirag on 12/27/12.
//  Copyright (c) 2012 LD.Chirag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
@interface RegistrationViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField*first_name_textField;
    IBOutlet UITextField*last_name_textField;
    IBOutlet UITextField*email_address_name_textField;
    IBOutlet UITextField*contact_number_textField;
    IBOutlet UITextField*password_textField;
    
    IBOutlet UIButton*signUp_button;
    IBOutlet UIButton*signUp_using_fb_button;
    
    
    
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
	//NSDictionary *responseDataDictionary;
    NSMutableArray *responseDataArray;
    
}

-(IBAction)signUp_button_clicked:(id)sender;
-(IBAction)signUp_using_fb_button_clicked:(id)sender;
@property(nonatomic,strong)NSMutableArray *responseDataArray;
@end
