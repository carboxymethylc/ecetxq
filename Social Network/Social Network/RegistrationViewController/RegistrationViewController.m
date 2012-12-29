//
//  RegistrationViewController.m
//  Social Network
//
//  Created by LD.Chirag on 12/27/12.
//  Copyright (c) 2012 LD.Chirag. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
@synthesize responseDataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    registration_scrollview.contentSize = CGSizeMake(320,500);
    [process_activity_indicator stopAnimating];
    process_activity_indicator.hidden = TRUE;

    
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)signUp_button_clicked:(id)sender
{
    NSString*error_string=@"";
    
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *email_address_check = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
    
    if([[first_name_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
    {
        error_string = @"Please enter first name.";
    }
    else if([[last_name_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
    {
         error_string = @"Please enter last name.";
    }
    else if([[email_address_name_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || ([email_address_check evaluateWithObject:email_address_name_textField.text] != YES))
    {
        error_string = @"Please enter valid email address.";
    }
    else if([[password_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
    {
        error_string = @"Please enter password.";
    }
    else if([[contact_number_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
    {
        error_string = @"Please enter contact number.";
    }
    
    if([error_string length]>0)
    {
    
        UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error_string delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        
        return;
    }
    
    
    registration_scrollview.contentSize = CGSizeMake(320,500);
    registration_scrollview.contentOffset = CGPointMake(0,0);

    
    //user_registration
    requestObjects = [NSArray arrayWithObjects:first_name_textField.text,last_name_textField.text,email_address_name_textField.text,password_textField.text,contact_number_textField.text,nil];
    requestkeys = [NSArray arrayWithObjects:@"firstname",@"lastname",@"emailaddress",@"password",@"contactno",nil];
    
    
    requestJSONDict = [NSDictionary dictionaryWithObjects:requestObjects forKeys:requestkeys];
   //requestString = [NSString stringWithFormat:@"data=%@",[requestJSONDict JSONRepresentation]];
    requestString = [NSString stringWithFormat:@"%@",[requestJSONDict JSONRepresentation]];
    NSLog(@"\n \n \n \n \n \n ");
    
    NSLog(@"\n requestString = %@",requestString);
    
    requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
    urlString = [NSString stringWithFormat:@"%@%@",WEB_SERVICE_URL,@"Signup"];
    NSLog(@"\n urlString = %@",urlString);
    request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]]; // set URL for the request
    [request setHTTPMethod:@"POST"]; // set method the request
     [request addValue: @"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:requestData];
    
    
    
    process_activity_indicator.hidden = FALSE;
    [process_activity_indicator startAnimating];
    [self.view endEditing:TRUE];
    [self.view setUserInteractionEnabled:FALSE];

    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSLog(@"\n response we get = %@",response);
         returnData = data;
         NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
         NSLog(@"\n returnString == %@",returnString);
         json = [[SBJSON new] autorelease];
         
         
         responseDataDictionary = [json objectWithString:returnString error:&error];
         [responseDataDictionary retain];
         
         NSLog(@"\n responseDataDictionary = %@",responseDataDictionary);
         
          NSLog(@"\n data = %@",[[responseDataDictionary objectForKey:@"d"] objectAtIndex:0]);
         [self performSelectorOnMainThread:@selector(enable_user_interaction) withObject:nil waitUntilDone:TRUE];

         
         
     }];
    
    
    
}

-(void)enable_user_interaction
{
    
    [process_activity_indicator stopAnimating];
    process_activity_indicator.hidden = TRUE;

    
    NSLog(@"\n data = %@",[[responseDataDictionary objectForKey:@"d"] objectAtIndex:0]);
    
    UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:[[[responseDataDictionary objectForKey:@"d"] objectAtIndex:0] objectForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
    
    [self.view setUserInteractionEnabled:TRUE];
}


-(IBAction)signUp_using_fb_button_clicked:(id)sender
{
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    registration_scrollview.contentSize = CGSizeMake(320,700);
    registration_scrollview.contentOffset = CGPointMake(0,120);
    return TRUE;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return TRUE;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    registration_scrollview.contentSize = CGSizeMake(320,500);
    registration_scrollview.contentOffset = CGPointMake(0,0);
    
    [textField resignFirstResponder];
    return TRUE;
}

-(IBAction)back_button_clicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}

@end
