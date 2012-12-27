//
//  MasterViewController.m
//  Social Network
//
//  Created by LD.Chirag on 12/16/12.
//  Copyright (c) 2012 LD.Chirag. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController ()
{
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)dealloc
{
    [_detailViewController release];
    [_objects release];
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[delegate facebook] isSessionValid])
    {
        
         DetailViewController*detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:detailViewController animated:NO];
    }

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /*
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)] autorelease];
    self.navigationItem.rightBarButtonItem = addButton;
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - facebook_login_button_pressed

-(IBAction)facebook_login_button_pressed:(id)sender
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


#pragma mark - requestFaceBookUserFriends //Get current user's friend list
-(void)requestFaceBookUserFriends
{
    requestType = requestGetFaceBookFriend;
    NSString *query = @"SELECT uid,name,first_name,last_name,pic_square FROM user WHERE uid IN (";
    query = [query stringByAppendingFormat:@"SELECT uid2 FROM friend WHERE uid1 = me())"];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    query, @"query",
                                    nil];
    
    AppDelegate*appDelegate = [UIApplication sharedApplication].delegate;
    [[appDelegate facebook]  requestWithMethodName: @"fql.query"
                                         andParams: params
                                     andHttpMethod: @"POST"
                                       andDelegate:self];
}


#pragma mark - apiFQLIMe Methods //Get current user info.
- (void)apiFQLIMe
{
    
    NSLog(@"\n comes in apiFQLIMe");
    // Using the "pic" picture since this currently has a maximum width of 100 pixels
    // and since the minimum profile picture size is 180 pixels wide we should be able
    // to get a 100 pixel wide version of the profile picture
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name, pic FROM user WHERE uid=me()", @"query",
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
    
    
    DetailViewController*detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil] autorelease];
    
    [self.navigationController pushViewController:detailViewController animated:NO];

    
    /*
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(apiFQLIMe) userInfo:nil repeats:FALSE];
     */
    
    
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
    
    
    if(requestType == requestGetFaceBookFriend)
    {
        if ([result isKindOfClass:[NSArray class]])
        {
            //result = [result objectAtIndex:0];
            NSLog(@"\n resutl = %@",result);
            
            
            
            NSMutableArray*sortingArray = [[NSMutableArray alloc] init];
            sortingArray = [NSMutableArray arrayWithArray:result];
            
            for(int x = 0; x < [sortingArray count]; x++)
            {
                for(int y = x + 1; y < [sortingArray count]; y++)
                {
                    
                    if([[[sortingArray objectAtIndex:x] objectForKey:@"name"] compare:
                        [[sortingArray objectAtIndex:y] objectForKey:@"name"] options:NSCaseInsensitiveSearch]
                       == NSOrderedDescending
                       )
                    {
                        NSArray *temp = [sortingArray objectAtIndex:x];
                        [sortingArray replaceObjectAtIndex:x withObject:[sortingArray objectAtIndex:y]];
                        [sortingArray replaceObjectAtIndex:y withObject:temp];
                    }
                }
            }
            
            
            NSLog(@"\n allUserArray = %@",sortingArray);
            
                      
        }
        // This callback can be a result of getting the user's basic
        // information or getting the user's permissions.
        
        [self.view setUserInteractionEnabled:TRUE];
        
    }
    else
    {
        if ([result isKindOfClass:[NSArray class]])
        {
            result = [result objectAtIndex:0];
        }
        // This callback can be a result of getting the user's basic
        // information or getting the user's permissions.
        NSLog(@"\n resutl for user = %@",result);
        [self requestFaceBookUserFriends];
        
        NSUserDefaults*defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:result forKey:@"currentUserFBDetail"];

        
        //[self getUserListing:[result objectForKey:@"uid"]];
    }
    
    
    
    
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


@end
