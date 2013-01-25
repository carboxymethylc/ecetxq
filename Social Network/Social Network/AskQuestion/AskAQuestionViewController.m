//
//  AskAQuestionViewController.m
//  Social Network
//
//  Created by LD.Chirag on 1/24/13.
//  Copyright (c) 2013 LD.Chirag. All rights reserved.
//

#import "AskAQuestionViewController.h"

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
    ask_question_tblView.tableHeaderView = tbl_headerView;
    self.cellNib = [UINib nibWithNibName:@"AskQueCustomCell" bundle:nil];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark Table view methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            return 26.0f;
            break;
            
        }
        case 1:
        {
            return 300.0f;
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
    
        return  2;
    
    
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ExampleCell";
    
    
    AskQueCustomCell *cell = (AskQueCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    [self.cellNib instantiateWithOwner:self options:nil];
    cell = ask_que_custom_cell;
    self.ask_que_custom_cell = nil;

    switch (indexPath.row)
    {
        case 0:
        {
            cell.row2_view.hidden = TRUE;
            break;
        }
        case 1:
        {
            cell.row1_view.hidden = TRUE;

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





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
