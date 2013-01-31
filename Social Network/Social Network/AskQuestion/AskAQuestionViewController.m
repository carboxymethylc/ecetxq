//
//  AskAQuestionViewController.m
//  Social Network
//
//  Created by LD.Chirag on 1/24/13.
//  Copyright (c) 2013 LD.Chirag. All rights reserved.
//

#import "AskAQuestionViewController.h"


#import "UIImage+Resize.h"

@interface AskAQuestionViewController ()

@end

@implementation AskAQuestionViewController
@synthesize ask_que_custom_cell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ask_question_dictionary = [[NSMutableDictionary alloc] init];
    ask_question_tblView.tableHeaderView = tbl_headerView;
    ask_question_tblView.tableHeaderView.backgroundColor = [UIColor clearColor];
    self.cellNib = [UINib nibWithNibName:@"AskQueCustomCell" bundle:nil];
    // Do any additional setup after loading the view from its nib.
    toolBar.hidden = TRUE;
    category_picker.hidden = TRUE;
    
    
    imagePicker = [[UIImagePickerController alloc]init];
	imagePicker.delegate = self;

    
    [ask_question_dictionary setObject:@""forKey:@"2001"];
    [ask_question_dictionary setObject:@""forKey:@"2002"];
    [ask_question_dictionary setObject:@""forKey:@"2003"];
    [ask_question_dictionary setObject:@""forKey:@"2004"];
    [ask_question_dictionary setObject:@""forKey:@"2005"];
    
    [ask_question_dictionary setObject:[NSString stringWithFormat:@"%d",0] forKey:@"ask_public_friend"];
    
    
    category_array = [[NSMutableArray alloc] init];
    
    [category_array addObject:@"Category-1"];
    [category_array addObject:@"Category-2"];
    [category_array addObject:@"Category-3"];
    [category_array addObject:@"Category-4"];
    [category_array addObject:@"Category-5"];
    [category_array addObject:@"Category-6"];
    
    
    selected_category = -1;
    
    NSLog(@"\n tableview content size = %@",NSStringFromCGSize(ask_question_tblView.contentSize));
    
    
     [ask_question_dictionary setObject:[NSNumber numberWithInt:0] forKey:@"ask_anonymously"];
    
}


#pragma mark Table view methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            return 30.0f;
            break;
            
        }
        case 1:
        {
            if([[ask_question_dictionary objectForKey:@"create_poll"] intValue]==0)
            {
                return 0;
            }
            
            return 180.0f;
        }
        case 2:
        {
             return 30.0f;
        }
        case 3:
        {
            return 44.0f;
        }
        case 4:
        {
            return 38.0f;
        }
        default:
            break;
    }
    
    return 0.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return flickrPhotos.count;
    
        return  5;
    
    
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ExampleCell";
    
    
    AskQueCustomCell *cell = (AskQueCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    [self.cellNib instantiateWithOwner:self options:nil];
    cell = ask_que_custom_cell;
    self.ask_que_custom_cell = nil;

     cell.row1_view.hidden = TRUE;
     cell.row2_view.hidden = TRUE;
     cell.row3_view.hidden = TRUE;
    cell.row4_view.hidden = TRUE;
    cell.row5_view.hidden = TRUE;
    
    
   
    
    
    switch (indexPath.row)
    {
        case 0:
        {
            
            
            
            if([[ask_question_dictionary objectForKey:@"create_poll"] intValue]==0)
            {
                
                
                [cell.create_poll_button setImage:[UIImage imageNamed:@"checkbox_unselected.png"] forState:UIControlStateNormal];
                
            }
            else
            {
                
                [cell.create_poll_button setImage:[UIImage imageNamed:@"checkbox_selected.png"] forState:UIControlStateNormal];
                
            }

            
            cell.row1_view.hidden = FALSE;
            break;
        }
        case 1:
        {
            
            NSLog(@"\n cell.create_poll_button = %@",cell.create_poll_button);
            
            if([[ask_question_dictionary objectForKey:@"create_poll"] intValue]==0)
            {
                
                
                cell.row2_view.hidden = TRUE;
                
            }
            else
            {
                
                
                cell.poll_textfield_1.text =[ask_question_dictionary objectForKey:@"2001"];
                cell.poll_textfield_2.text =[ask_question_dictionary objectForKey:@"2002"];
                cell.poll_textfield_3.text =[ask_question_dictionary objectForKey:@"2003"];
                cell.poll_textfield_4.text =[ask_question_dictionary objectForKey:@"2004"];
                cell.poll_textfield_5.text =[ask_question_dictionary objectForKey:@"2005"];
                
                
               cell.row2_view.hidden = FALSE;
            }
            

            break;

        }
        case 2:
        {

            if(selected_category == -1)
            {
                [cell.choose_category setTitle:@"Select Category" forState:UIControlStateNormal];
            }
            else
            {
                
              [cell.choose_category setTitle:[category_array objectAtIndex:selected_category] forState:UIControlStateNormal];
            }
            
             cell.row3_view.hidden = FALSE;
             break;
            
        }
        case 3:
        {
            
            [cell.ask_friend setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [cell.ask_publicly setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            
            if([[ask_question_dictionary objectForKey:@"ask_public_friend"] intValue]==4002)
            {
                [cell.ask_friend setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            }
            else if([[ask_question_dictionary objectForKey:@"ask_public_friend"] intValue]==4001)
            {
                [cell.ask_publicly setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            }
            
            cell.row4_view.hidden = FALSE;
             break;
            
        }

        case 4:
        {
            
            cell.row5_view.hidden = FALSE;
             break;
            
        }

        default:
        {
            break;
        }
    
    }
        
    
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
   

    
}

#pragma mark -
#pragma mark btn_createPoll_clicked

-(IBAction)btn_createPoll_clicked:(id)sender
{
   // UIButton*tempButton = (UIButton*)sender;
    
    
    if([[ask_question_dictionary objectForKey:@"create_poll"] intValue]==0)
    {
        [ask_question_dictionary setObject:@"1" forKey:@"create_poll"];
       
    }
    else
    {
        [ask_question_dictionary setObject:@"0" forKey:@"create_poll"];
        
    }
    [ask_question_tblView reloadData];
}

#pragma mark -

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"\n textFieldDidBeginEditing");
    ask_question_tblView.contentSize = CGSizeMake(277,600);
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return TRUE;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [ask_question_dictionary setObject:textField.text forKey:[NSString stringWithFormat:@"%d",textField.tag]];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [ask_question_dictionary setObject:textField.text forKey:[NSString stringWithFormat:@"%d",textField.tag]];
    ask_question_tblView.contentSize = CGSizeMake(277,400);
    [textField resignFirstResponder];
    return TRUE;
    
}


#pragma mark -

#pragma mark btn_choose_photo_video_clicked

-(IBAction)btn_choose_photo_video_clicked:(id)sender
{
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Select Image/Video" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Gallery",@"Camera",nil];
    sheet.delegate = self;
    [sheet showInView:self.view];
   
    [sheet release];

    
    
}

#pragma mark -
#pragma mark ACTION SHEET METHOD

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
	if (buttonIndex == 0)
    {
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        
        NSArray *mediaTypesAllowed = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePicker setMediaTypes:mediaTypesAllowed];
        
        [self presentModalViewController:imagePicker animated:YES];
        
        
        
    }
    else if (buttonIndex == 1)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
		{
            [imagePicker setAllowsEditing:NO];
			imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
			imagePicker.delegate = self;
            [self presentModalViewController:imagePicker animated:YES];
			
		}
		else
		{
			UIAlertView *showalert = [[UIAlertView alloc]initWithTitle:nil message:@"No camera device found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[showalert show];
			[showalert release];
		}
        
    }
}


#pragma mark -
#pragma mark Image Picker Methods


-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissModalViewControllerAnimated:YES];
	//secondPieceView.image = [UIImage imageNamed:@"images.jpg"];
	
}
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    
    NSLog(@"\n info = %@",info);
    
    NSLog(@"\n mediaType = %@",mediaType);
    
    if([mediaType isEqualToString:@"public.movie"])
    {
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
        
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
        UIImage *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        
        
        thumbnail =[thumbnail resizedImage:CGSizeMake(52,64) interpolationQuality:kCGInterpolationHigh];
        [button_choose_image_video setImage:thumbnail forState:UIControlStateNormal];
        
        
        /*
        NSData*imgData =    UIImagePNGRepresentation(thumbnail);
        //Player autoplays audio on init
        [player stop];
        [player release];
        */
        
        
        
                
        
        
    }
    else
    {
        
        
        UIImage *tempImage = (UIImage *)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage* miniTumbImage = [tempImage resizedImage:CGSizeMake(52,64) interpolationQuality:kCGInterpolationHigh];
        [button_choose_image_video setImage:miniTumbImage forState:UIControlStateNormal];
        
        /*
         tempImage= [ tempImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(100,100) interpolationQuality:kCGInterpolationHigh];
         
         miniTumbImage = [tempImage scaleToSize:CGSizeMake(40, 40)];
         */
        
        
        
    }
    
	
	[picker dismissModalViewControllerAnimated:YES];
}

#pragma mark -



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TextView

#pragma mark -

#pragma mark  TextView Methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    toolBar.hidden = FALSE;
    ask_question_tblView.contentSize = CGSizeMake(277,450);
    return TRUE;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSLog(@"\n textViewShouldEndEditing");
    return TRUE;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"\n textViewDidBeginEditing");
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    toolBar.hidden = TRUE;
    ask_question_tblView.contentSize = CGSizeMake(277,300);
    NSLog(@"\n textViewDidEndEditing");
}

#pragma mark -

#pragma mark -
#pragma mark toolBar_donePressed
-(IBAction)toolBar_donePressed:(id)sender
{
    toolBar.hidden = TRUE;
    category_picker.hidden = TRUE;
    [self.view endEditing:TRUE];
}

#pragma mark -
#pragma mark ask_friend_public_pressed

-(IBAction)ask_friend_public_pressed:(id)sender
{
    UIButton*temp_button = (UIButton*)sender;
    
    [ask_question_dictionary setObject:[NSString stringWithFormat:@"%d",temp_button.tag] forKey:@"ask_public_friend"];
    [ask_question_tblView reloadData];
    
    
}

#pragma mark -
#pragma mark choose_category_pressed
-(IBAction)choose_category_pressed:(id)sender
{
    toolBar.hidden = FALSE;
    category_picker.hidden = FALSE;
    
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [category_array count] ;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [category_array objectAtIndex:row];
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"\n row = %d",row);
    selected_category = row;
    
    [ask_question_tblView reloadData];
    

    
}

#pragma mark - ask_anonymously_pressed
#pragma mark -

-(IBAction)ask_anonymously_pressed:(id)sender
{
    [ask_question_dictionary setObject:[NSNumber numberWithInt:0] forKey:@"ask_anonymously"];
    if([[ask_question_dictionary objectForKey:@"ask_anonymously"] intValue]==0)
    {
        [ask_question_dictionary setObject:[NSNumber numberWithInt:1] forKey:@"ask_anonymously"];
    }
    else
    {
        [ask_question_dictionary setObject:[NSNumber numberWithInt:0] forKey:@"ask_anonymously"];
    }
    
    [ask_question_tblView reloadData];
}

#pragma mark -
-(void)dealloc
{
    [imagePicker release];
    [ask_question_dictionary release];
    [super dealloc];
}

@end
