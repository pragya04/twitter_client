//
//  TweetViewController.m
//  TwitterClient
//
//  Created by Pragya  Pherwani on 6/30/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"

@interface TweetViewController ()

@end

@implementation TweetViewController

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
    [self displayTweetData];
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Reply"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(replyButtonTap:)];
    
    self.navigationItem.rightBarButtonItem = replyButton;

    [self.favButton setImage:[UIImage imageNamed:@"fav.png"]
                    forState:UIControlStateNormal];

    [self.retweetButton setImage:[UIImage imageNamed:@"retweet.png"]
                    forState:UIControlStateNormal];
    
    [self.replyButton setImage:[UIImage imageNamed:@"reply.png"]
                    forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) displayTweetData{
    
    self.userNameLabel.text = self.singleTweet.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.singleTweet.screenName];
    self.userProfileImage.layer.cornerRadius = 5;
    self.userProfileImage.clipsToBounds=YES;
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:self.singleTweet.userImageUrl]];
    self.tweetText.text = self.singleTweet.tweetContent;
    if(self.singleTweet.favorites) {
        self.favoritesCount.text = [NSString stringWithFormat:@"%@", self.singleTweet.favorites ];
    } else {
        self.favoritesCount.text = @"0";
    }
    self.retweetCount.text = [NSString stringWithFormat:@"%@", self.singleTweet.retweets];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *tweetDate = [dateFormatter dateFromString:self.singleTweet.createdAt];
    static NSDateFormatter *formatter = nil;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d/yy, h:mm a"];
    self.tweetTimestamp.text = [formatter stringFromDate:tweetDate];
    
}
- (void)replyButtonTap:(id)sender {
    [self replyToTweet];
}

- (IBAction)onFavoriteTap:(id)sender {
    [[TwitterClient instance] favoriteWithTweet:self.singleTweet success:^{
        UIImage *FavImage = [UIImage imageNamed:@"isFav.png"];
        [self.favButton setBackgroundImage:FavImage forState:UIControlStateNormal];
    }];
}
- (IBAction)onRetweetButton:(id)sender {
    [[TwitterClient instance] retweetWithTweet:self.singleTweet success:^{
        UIImage *RetweetImage = [UIImage imageNamed:@"retweet_done.png"];
        [self.retweetButton setBackgroundImage:RetweetImage forState:UIControlStateNormal];
    }];

}

- (IBAction)onReplyButton:(id)sender {
    [self replyToTweet];
}

-(void) replyToTweet {
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    self.navigationItem.backBarButtonItem.title = @"Cancel";
    cvc.defaultText = [NSString stringWithFormat:@"@%@", self.singleTweet.screenName];
    [self.navigationController pushViewController:cvc animated:NO];
}
@end
