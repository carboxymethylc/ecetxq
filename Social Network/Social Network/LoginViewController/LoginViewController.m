//
//  LoginViewController.m
//  Social Network
//
//  Created by  on 12/26/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "DetailViewController.h"
#import <AddressBook/AddressBook.h>
@interface LoginViewController ()

@end

@implementation LoginViewController

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
    app_delegate = [UIApplication sharedApplication].delegate;
    
    loginview_scrollview.contentSize = CGSizeMake(320,500);
    email_address_textfield.tag = email_address_textfield_tag;
    password_textfield.tag = password_textfield_tag;
    
    [process_activity_indicator stopAnimating];
    process_activity_indicator.hidden = TRUE;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - create_account_button_clicked 
-(IBAction) create_account_button_clicked:(id)sender
{
    RegistrationViewController*viewController = [[[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - sign_in_button_clicked

-(IBAction) sign_in_button_clicked:(id)sender
{
    
    if(![AppDelegate hasConnectivity])
    {
        UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please check your network connection and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alertView.tag = 5000;
        [alertView show];
        [alertView release];
        return;
    }

    
    NSString*error_string=@"";
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *email_address_check = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
    
    if([[email_address_textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || ([email_address_check evaluateWithObject:email_address_textfield.text] != YES))
    {
        error_string = @"Please enter valid email address.";
    }
   else if([[password_textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
    {
       error_string = @"Please enter password.";
    }

    if([error_string length]>0)
    {
        
        UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error_string delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        
        return;
    }

    
    loginview_scrollview.contentSize = CGSizeMake(320,500);
    loginview_scrollview.contentOffset = CGPointMake(0,0);
    
    
    requestObjects = [NSArray arrayWithObjects:@"login",email_address_textfield.text,password_textfield.text,nil];
    requestkeys = [NSArray arrayWithObjects:@"action",@"emailaddress",@"password",nil];
   
    
    requestJSONDict = [NSDictionary dictionaryWithObjects:requestObjects forKeys:requestkeys];
    //requestString = [NSString stringWithFormat:@"data=%@",[requestJSONDict JSONRepresentation]];
    requestString = [NSString stringWithFormat:@"%@",[requestJSONDict JSONRepresentation]];
    NSLog(@"\n \n \n \n \n \n ");
    
    NSLog(@"\n requestString = %@",requestString);
    
    requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
    urlString = [NSString stringWithFormat:@"%@Login",WEB_SERVICE_URL];
    
    request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]]; // set URL for the request
    [request setHTTPMethod:@"POST"]; // set method the request
    [request addValue: @"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestData];
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    process_activity_indicator.hidden = FALSE;
    [process_activity_indicator startAnimating];
    [self.view endEditing:TRUE];
    [self.view setUserInteractionEnabled:FALSE];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSLog(@"\n response we get = %@",response);
         returnData = data;
         NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
         NSLog(@"\n returnString == %@",returnString);
         json = [[SBJSON new] autorelease];
         
         
         responseDataDictionary = [json objectWithString:returnString error:&error];
         NSLog(@"\n responseDataDictionary = %@",responseDataDictionary);
         [responseDataDictionary retain];
         
         
         
         [self performSelectorOnMainThread:@selector(enable_user_interaction) withObject:nil waitUntilDone:TRUE];
         
         
         
         
         
         
         
     }];

    
    
    
}
-(void)enable_user_interaction
{
    NSLog(@"\n data = %@",[[responseDataDictionary objectForKey:@"d"] objectAtIndex:0]);
    
    [process_activity_indicator stopAnimating];
    process_activity_indicator.hidden = TRUE;
    
    if([[[[responseDataDictionary objectForKey:@"d"] objectAtIndex:0] objectForKey:@"status"] intValue]==1)
    {
        app_delegate.user_signed_in_with = 1;
        
        
        DetailViewController*view_controller = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        [self.navigationController pushViewController:view_controller animated:NO];
        [view_controller release];
    }
    else
    {
        UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:[[[responseDataDictionary objectForKey:@"d"] objectAtIndex:0] objectForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
    
    
    
    [self.view setUserInteractionEnabled:TRUE];
}
-(IBAction) sign_in_using_fb_button_clicked:(id)sender
{
    if(![AppDelegate hasConnectivity])
    {
        UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please check your network connection and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alertView.tag = 5000;
        [alertView show];
        [alertView release];
        return;
    }
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[delegate facebook] isSessionValid])
    {
        //[self showLoggedOut];
        //Not logged in...
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", nil];
        [[delegate facebook] authorize:permissions];
        [permissions release];
        
    }
    else
    {
        // [self requestFaceBookUserFriends];
        
        app_delegate.user_signed_in_with = 2;
        
        
        DetailViewController*view_controller = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        [self.navigationController pushViewController:view_controller animated:NO];
        [view_controller release];

        
    }

}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //if(textField.tag == password_textfield_tag)
    {
        loginview_scrollview.contentSize = CGSizeMake(320,600);
        loginview_scrollview.contentOffset = CGPointMake(0,100);
    }
    
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
    
    loginview_scrollview.contentSize = CGSizeMake(320,500);
    loginview_scrollview.contentOffset = CGPointMake(0,0);

    [textField resignFirstResponder];
    return TRUE;
}

#pragma mark - FACEBOOK


#pragma mark - apiFQLIMe Methods //Get current user info.
- (void)apiFQLIMe
{
    
    NSLog(@"\n comes in apiFQLIMe");
    // Using the "pic" picture since this currently has a maximum width of 100 pixels
    // and since the minimum profile picture size is 180 pixels wide we should be able
    // to get a 100 pixel wide version of the profile picture
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid,name,email,pic FROM user WHERE uid=me()", @"query",
                                   nil];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithMethodName:@"fql.query"
                                     andParams:params
                                 andHttpMethod:@"POST"
                                   andDelegate:self];
    
    
}



#pragma mark - storeAuthData

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

#pragma mark - FBSessionDelegate Methods
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin
{
    
    NSLog(@"\n fbDidLogin");
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self storeAuthData:[[delegate facebook] accessToken] expiresAt:[[delegate facebook] expirationDate]];
    
    //Now we need to get user data here..
    [self apiFQLIMe];
   
    
    
   
    
    
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt
{
    NSLog(@"token extended");
    [self storeAuthData:accessToken expiresAt:expiresAt];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled
{
    NSLog(@"\n fbDidNotLogin");
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout
{
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

/**
 * Called when the session has expired.
 */
- (void)fbSessionInvalidated {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [alertView release];
    
}


#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result
{
   
        if ([result isKindOfClass:[NSArray class]])
        {
            result = [result objectAtIndex:0];
        }
        // This callback can be a result of getting the user's basic
        // information or getting the user's permissions.
        NSLog(@"\n user registered/signup using fb..now we need to ");
        NSLog(@"\n resutl for user = %@",result);
    
    app_delegate.user_signed_in_with = 2;
    
    
    DetailViewController*view_controller = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    [self.navigationController pushViewController:view_controller animated:NO];
    [view_controller release];
    
    /*
        NSUserDefaults*defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:result forKey:@"currentUserFBDetail"];
     */
    
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    
    [self.view setUserInteractionEnabled:TRUE];
    
    
    NSLog(@"Err message: comes here.. %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: comes here.. %d", [error code]);
}

#pragma mark -




@end
