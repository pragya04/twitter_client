//
//  ProfileViewController.h
//  TwitterClient
//
//  Created by Pragya  Pherwani on 7/12/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetNums;
@property (weak, nonatomic) IBOutlet UILabel *followerNums;
@property (weak, nonatomic) IBOutlet UILabel *followingNums;
@property (strong, nonatomic) NSString *selectedUserScreenName;

@end
