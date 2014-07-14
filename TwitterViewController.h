//
//  TwitterViewController.h
//  TwitterClient
//
//  Created by Pragya  Pherwani on 6/28/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mantle.h>
@protocol TwitterViewControllerDelegate <NSObject>
@end
@interface TwitterViewController :UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) id<TwitterViewControllerDelegate> delegate;
@property (nonatomic) NSMutableArray *tweets;
@property (nonatomic, assign) BOOL isMentionsView;
@end