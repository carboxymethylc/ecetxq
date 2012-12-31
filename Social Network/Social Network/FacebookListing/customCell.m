//
//  ExampleCell.m
//  EGOImageLoadingDemo
//
//  Created by Shaun Harrison on 10/19/09.
//  Copyright 2009 enormego. All rights reserved.
//

#import "customCell.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation customCell
@synthesize name_label,contact_imageView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
		imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
		imageView.frame = CGRectMake(4.0f, 4.0f, 36.0f, 36.0f);
       
        contact_imageView = [[UIImageView alloc] init];
        contact_imageView.frame = CGRectMake(4.0f, 4.0f, 36.0f, 36.0f);
        
        
        name_label = [[UILabel alloc] initWithFrame:CGRectMake(45,4,250,36)];
        name_label.lineBreakMode = NSLineBreakByTruncatingTail;
        [name_label setFont:[UIFont fontWithName:@"Arial" size:14]];
		
        [self.contentView addSubview:contact_imageView];
        [self.contentView addSubview:imageView];
        [self.contentView addSubview:name_label];
	}
	
    return self;
}

- (void)setFlickrPhoto:(NSString*)flickrPhoto
{
	imageView.imageURL = [NSURL URLWithString:flickrPhoto];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview)
    {
		[imageView cancelImageLoad];
	}
}

- (void)dealloc
{
    [contact_imageView release];
	[imageView release];
    [name_label release];
    [super dealloc];
}


@end
