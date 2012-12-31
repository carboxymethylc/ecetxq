//
//  ExampleCell.h
//  EGOImageLoadingDemo
//
//  Created by Shaun Harrison on 10/19/09.
//  Copyright 2009 enormego. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGOImageView;
@interface customCell : UITableViewCell
{
    UILabel*name_label;
    UIImageView*contact_imageView;
@private
	EGOImageView* imageView;
    
}

- (void)setFlickrPhoto:(NSString*)flickrPhoto;
@property(nonatomic,retain)UILabel*name_label;
@property(nonatomic,retain)UIImageView*contact_imageView;

@end
