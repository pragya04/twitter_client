//
//  ComposeViewController.m
//  TwitterClient
//
//  Created by Pragya  Pherwani on 6/29/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import "ComposeViewController.h"
#import "TwitterViewController.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"

@interface ComposeViewController ()
@property (nonatomic, strong) TwitterClient *client;
@property (nonatomic, strong) User *user;
@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Compose";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.client = [TwitterClient instance];
    [self.client verifyCurrentUserWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.user =  [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject error:nil];
        NSLog(@"user object, %@", responseObject);
        [self populateUserInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"No user %@", error);
    }];
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Tweet"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(tweetButtonTap:)];
    
    self.navigationItem.rightBarButtonItem = tweetButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) populateUserInfo {
    [self.userImage setImageWithURL:[NSURL URLWithString:self.user.userImage]];
    self.userNameLabel.text = self.user.userNameLabel;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.userScreenName];
}

- (void)tweetButtonTap:(id)sender {
    [[TwitterClient instance] tweetMessage:self.tweetText.text success:^(Tweet *tweet) {
        NSLog(@"Tweeted");
    }];
    [self.tweetText resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
