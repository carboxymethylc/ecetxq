//
//  LoginViewController.m
//  Social Network
//
//  Created by LD.Chirag on 12/26/12.
//  Copyright (c) 2012 LD.Chirag. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistrationViewController.h"
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) create_account_button_clicked:(id)sender
{
    RegistrationViewController*viewController = [[[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(IBAction) sign_in_button_clicked:(id)sender
{
    
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
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"", nil];
        [[delegate facebook] authorize:permissions];
        [permissions release];
        
    }
    else
    {
        // [self requestFaceBookUserFriends];
    }

}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
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
        NSUserDefaults*defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:result forKey:@"currentUserFBDetail"];
    
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
