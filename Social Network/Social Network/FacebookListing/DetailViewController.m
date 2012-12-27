//
//  DetailViewController.m
//  Social Network
//
//  Created by LD.Chirag on 12/16/12.
//  Copyright (c) 2012 LD.Chirag. All rights reserved.
//

#import "DetailViewController.h"
#import "EGOCache.h"
#import "customCell.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

- (void)dealloc
{
   
    [super dealloc];
}

#pragma mark - Managing the detail item


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    app_delegate = [UIApplication sharedApplication].delegate;
    
   // facebook_friends_tableview.tableHeaderView = facebook_friends_tableview_header_view;
    [app_delegate facebook].sessionDelegate = self;
    facebook_friends_tableview_header_view.backgroundColor = [UIColor clearColor];
    [self apiFQLIMe];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

#pragma mark Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return facebook_friends_tableview_header_view;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // return flickrPhotos.count;
    
    return [app_delegate.facebook_user_array count];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ExampleCell";
    
    
    
    customCell *cell = (customCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil)
    {
        cell = [[[customCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	[cell setFlickrPhoto:[[app_delegate.facebook_user_array objectAtIndex:indexPath.row] objectForKey:@"pic_square"]];
    
    cell.backgroundView =
    [[[UIImageView alloc] init] autorelease];
    
    ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"facebook_cell_background.png"];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"facebook_cell_background.png"]];
    
    cell.name_label.backgroundColor = [UIColor clearColor];
    cell.name_label.text = [[app_delegate.facebook_user_array objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NSString* fb_user_id = [NSString stringWithFormat:@"%@",[[app_delegate.facebook_user_array objectAtIndex:indexPath.row] objectForKey:@"uid"]];
    
    NSLog(@"\n fb_user_id = %@",fb_user_id);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   fb_user_id, @"to",
                                   @"I am Using Social Network for IOS", @"name",
                                   @"Social Network for iOS.", @"caption",
                                   @"Let's use Social Network to communicate...", @"description",
                                   @"http://www.google.co.in/",@"link",
                                   @"http://mascotp.com/temp_upload/social_network/logo_75.png", @"picture",
                                   nil];
    
    
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] dialog:@"feed"
                      andParams:params
                    andDelegate:self];
}

//Facebook starts


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
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(apiFQLIMe) userInfo:nil repeats:FALSE];
    
    
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
            
            app_delegate.facebook_user_array = [NSMutableArray arrayWithArray:sortingArray];
            NSLog(@"\n allUserArray = %@",sortingArray);
            [facebook_friends_tableview reloadData];
            
            
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