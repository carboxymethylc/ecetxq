//
//  AppDelegate.h
//  Social Network
//
//  Created by  on 12/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Facebook *facebook;
    NSUserDefaults *user_defaults;
    
    NSMutableArray*facebook_user_array;
    NSMutableArray*device_contact_user_array;
    
    int user_signed_in_with;//1 db 2 = Facebook.
    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *userPermissions;
@property(nonatomic,retain) NSMutableArray*facebook_user_array;
@property(nonatomic,retain) NSMutableArray*device_contact_user_array;
@property(nonatomic,readwrite) int user_signed_in_with;




+(BOOL)hasConnectivity;
@end
