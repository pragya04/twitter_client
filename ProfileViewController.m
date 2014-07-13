//
//  ProfileViewController.m
//  TwitterClient
//
//  Created by Pragya  Pherwani on 7/12/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import "ProfileViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()
@property (nonatomic, strong) User *user;
@end

@implementation ProfileViewController

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
    [self loadProfileData];
}

-(void) loadProfileData {
    [[TwitterClient instance] getUserTimeline:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject error:nil];
        [self displayProfileData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error loading user profile %@", error);
    }];
}

-(void) displayProfileData {
    self.userName.text = self.user.userNameLabel;
    self.screenName.text = [NSString stringWithFormat:@"@%@", self.user.userScreenName];
    self.tweetNums.text = [NSString stringWithFormat:@"%@", self.user.numTweets];
    self.followerNums.text = [NSString stringWithFormat:@"%@", self.user.numFollowers];
    self.followingNums.text = [NSString stringWithFormat:@"%@", self.user.numFollowing];
    self.userProfileImage.layer.cornerRadius = 5;
    self.userProfileImage.clipsToBounds=YES;
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:self.user.userImage]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
