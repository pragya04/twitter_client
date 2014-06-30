//
//  twitterAppDelegate.h
//  TwitterClient
//
//  Created by Pragya  Pherwani on 6/26/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterViewController.h"
#import "LoginViewController.h"

@interface twitterAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) TwitterViewController *tvc;
@property (strong, nonatomic) LoginViewController *lvc;
@property (strong, nonatomic) UINavigationController *nc;
extern NSString *const FavoriteTapped;
@property (strong, nonatomic) UIWindow *window;

@end
