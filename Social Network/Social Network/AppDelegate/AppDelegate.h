//
//  AppDelegate.h
//  Social Network
//
//  Created by LD.Chirag on 12/16/12.
//  Copyright (c) 2012 LD.Chirag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Facebook *facebook;
    NSUserDefaults *user_defaults;
    
    NSMutableArray*facebook_user_array;
    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *userPermissions;
@property(nonatomic,retain) NSMutableArray*facebook_user_array;

+(BOOL)hasConnectivity;
@end