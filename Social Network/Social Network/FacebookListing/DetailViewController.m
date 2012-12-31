//
//  DetailViewController.m
//  Social Network
//
//  Created by  on 12/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "DetailViewController.h"
#import "EGOCache.h"
#import "customCell.h"
#import <AddressBook/AddressBook.h>

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
    
    [self getContactsFromAddressBook];
    
    
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
    
    if(section==0)
    {
        return contacts_tableview_header_view;
    }
    else if(section==1)
    {
        return facebook_friends_tableview_header_view;
    }
    return nil;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(app_delegate.user_signed_in_with==2)
    {
        return 2;
    }
    else
    {
        return 1;
    }

}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // return flickrPhotos.count;
    
    switch (section)
    {
        case 0:
        {
            return [app_delegate.device_contact_user_array count];
            break;
        }
        case 1:
        {
            return [app_delegate.facebook_user_array count];
            break;
        }
        default:
        {
            break;
        }
    
    }
return  0;

    
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ExampleCell";
    
    
        
    
    customCell *cell = (customCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil)
    {
        cell = [[[customCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    if(indexPath.section==0)
    {
        
        cell.contact_imageView.image = [[app_delegate.device_contact_user_array objectAtIndex: indexPath.row] objectForKey:@"thumbImage"];
        
        cell.backgroundView =
        [[[UIImageView alloc] init] autorelease];
        
        ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"facebook_cell_background.png"];
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"facebook_cell_background.png"]];
        
        cell.name_label.backgroundColor = [UIColor clearColor];
        
        NSString*first_name = @"";
        NSString*last_name = @"";
        
        if([[app_delegate.device_contact_user_array objectAtIndex: indexPath.row] objectForKey:@"firstName"]!=nil)
        {
            first_name = [[app_delegate.device_contact_user_array objectAtIndex: indexPath.row] objectForKey:@"firstName"];
        }
        if([[app_delegate.device_contact_user_array objectAtIndex: indexPath.row] objectForKey:@"lastName"]!=nil)
        {
            last_name = [[app_delegate.device_contact_user_array objectAtIndex: indexPath.row] objectForKey:@"lastName"];
        }
        
        
        NSString*full_name = [NSString stringWithFormat:@"%@ %@",first_name,last_name];
         
        
        cell.name_label.text = full_name;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if(indexPath.section==1)
    {
        [cell setFlickrPhoto:[[app_delegate.facebook_user_array objectAtIndex:indexPath.row] objectForKey:@"pic_square"]];
        
        cell.backgroundView =
        [[[UIImageView alloc] init] autorelease];
        
        ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"facebook_cell_background.png"];
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"facebook_cell_background.png"]];
        
        cell.name_label.backgroundColor = [UIColor clearColor];
        cell.name_label.text = [[app_delegate.facebook_user_array objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
	// Configure the cell.
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NSLog(@"\n %@", [[[app_delegate.device_contact_user_array objectAtIndex:indexPath.row] objectForKey:@"phoneNumber"] objectAtIndex:0]);
    
    NSString*phone_number=@"";
    if([[[app_delegate.device_contact_user_array objectAtIndex:indexPath.row] objectForKey:@"phoneNumber"] objectAtIndex:0]!=nil)
    {
        phone_number = [[[app_delegate.device_contact_user_array objectAtIndex:indexPath.row] objectForKey:@"phoneNumber"] objectAtIndex:0];
    }
    
    if(indexPath.section ==0)
    {
        MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
        if([MFMessageComposeViewController canSendText])
        {
            controller.body = @"I am Using Social Network for IOS.";
            controller.recipients = [NSArray arrayWithObjects:phone_number, nil];
            controller.messageComposeDelegate = self;
            [self presentModalViewController:controller animated:YES];
        }
    }
    else if(indexPath.section ==1)
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
    
}




#pragma mark - isABAddressBookCreateWithOptionsAvailable
-(BOOL)isABAddressBookCreateWithOptionsAvailable
{
    return &ABAddressBookCreateWithOptions != NULL;
}

#pragma mark - getContactsFromAddressBook
-(void)getContactsFromAddressBook
{
    [app_delegate.device_contact_user_array removeAllObjects];
    
    
    
    ABAddressBookRef addressBook;
    if ([self isABAddressBookCreateWithOptionsAvailable])
    {
        
        CFErrorRef error_local = nil;
        addressBook = ABAddressBookCreateWithOptions(NULL,&error_local);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     // callback can occur in background, address book must be accessed on thread it was created on
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         if (error_local)
                                                         {
                                                             
                                                         } else if (!granted)
                                                         {
                                                             
                                                         }
                                                         else
                                                         {
                                                             // access granted
                                                             [self get_contacts_lists_from_addressBook];
                                                             
                                                         }
                                                     });
                                                 });
        
        
    }
    else
    {
        [self get_contacts_lists_from_addressBook];
        
    }
    

    
    
       
    
    
}
-(void)get_contacts_lists_from_addressBook
{
    ABAddressBookRef addressBook = ABAddressBookCreate( );
    //NSArray *allPeople = (NSArray *)ABAddressBookCopyPeopleWithName(addressBook, CFSTR("Appleseed"));
    
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    
    
    CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
    
    NSLog(@"\n allPeople = %@",allPeople);
    NSLog(@"\n nPeople = %ld",nPeople);
    
    
    NSMutableArray *data = [(NSArray *) allPeople mutableCopy];
    
    NSMutableDictionary*addressDictionary;
    for ( int i = 0; i < nPeople; i++ )
    {
        addressDictionary = [[NSMutableDictionary alloc] init];
        
        if((ABRecordCopyValue([data objectAtIndex:i], kABPersonFirstNameProperty))!=nil)
        {
            [addressDictionary setObject:(ABRecordCopyValue([data objectAtIndex:i], kABPersonFirstNameProperty)) forKey:@"firstName"];
        }
        
        if((ABRecordCopyValue([data objectAtIndex:i], kABPersonLastNameProperty))!=nil)
        {
            [addressDictionary setObject:(ABRecordCopyValue([data objectAtIndex:i], kABPersonLastNameProperty)) forKey:@"lastName"];
        }
        
        ABMultiValueRef phoneNumberProperty = (ABRecordCopyValue([data objectAtIndex:i], kABPersonPhoneProperty));
        NSArray* phoneNumbers = (NSArray*)ABMultiValueCopyArrayOfAllValues(phoneNumberProperty);
        CFRelease(phoneNumberProperty);
        
        // Do whatever you want with the phone numbers
        
        NSLog(@"Phone numbers = %@", phoneNumbers);
        if(phoneNumbers != nil)
        {
            [addressDictionary setObject:phoneNumbers forKey:@"phoneNumber"];
        }
        
        
        [phoneNumbers release];
        NSData  *imgData = (NSData *)ABPersonCopyImageData([data objectAtIndex:i]);
        UIImage  *img = [UIImage imageWithData:imgData];
        if(img != nil)
        {
            
            [addressDictionary setObject:img forKey:@"thumbImage"];
        }
        [app_delegate.device_contact_user_array addObject:addressDictionary];
        
        [addressDictionary release];
        
    }
    
    
    NSLog(@"allContactsArray  BEFORE == %@",app_delegate.device_contact_user_array);
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName"
																	 ascending:YES
																	comparator:^(id obj1, id obj2) {
																		return [obj1 compare:obj2 options:NSNumericSearch];
																	}];
	[app_delegate.device_contact_user_array sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSLog(@"allContactsArray  AFTER == %@",app_delegate.device_contact_user_array);
    [facebook_friends_tableview reloadData];

}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    [controller dismissModalViewControllerAnimated:TRUE];
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
