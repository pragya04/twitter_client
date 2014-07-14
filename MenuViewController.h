//
//  MenuViewController.h
//  TwitterClient
//
//  Created by Pragya  Pherwani on 7/11/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@protocol MenuViewControllerDelegate <NSObject>
@end
@interface MenuViewController : UIViewController
@property (nonatomic, assign) id<MenuViewControllerDelegate> delegate;
@end
