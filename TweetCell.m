//
//  TweetCell.m
//  TwitterClient
//
//  Created by Pragya  Pherwani on 6/28/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "MHPrettyDate.h"
#import "ComposeViewController.h"

@implementation TweetCell
static NSDateFormatter *formatter = nil;
NSString * const FavoriteTapped = @"FavoriteTapped";
NSString * const RetweetTapped = @"RetweetTapped";
NSString * const ReplyTapped = @"ReplyTapped";

- (void)awakeFromNib {

    [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"retweet.png"]
                            forState:UIControlStateNormal];
    [self.replyButton setBackgroundImage:[UIImage imageNamed:@"reply.png"]
                         forState:UIControlStateNormal];
    [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"fav.png"]
                         forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    
    _tweet = tweet;
    self.userTweetLabel.text = tweet.tweetContent;
    self.userNameLabel.text = tweet.name;
    self.userScreenName.text = [NSString stringWithFormat:@"@%@", tweet.screenName];
    self.userImage.layer.cornerRadius = 5;
    self.userImage.clipsToBounds = YES;
    [self.userImage setImageWithURL:[NSURL URLWithString:tweet.userImageUrl]];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    self.userTweetTimestamp.text = [MHPrettyDate prettyDateFromDate:[formatter dateFromString:tweet.createdAt] withFormat:MHPrettyDateShortRelativeTime];
    if(tweet.retweeted == YES) {
        UIImage *RetweetImage = [UIImage imageNamed:@"retweet_done.png"];
        [self.retweetButton setBackgroundImage:RetweetImage forState:UIControlStateNormal];
    }
    
    if(tweet.favorited == YES) {
        UIImage *FavImage = [UIImage imageNamed:@"isFav.png"];
        [self.favoriteButton setBackgroundImage:FavImage forState:UIControlStateNormal];
    }

}

- (IBAction)onReplyTap:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:ReplyTapped object:self userInfo: @{@"tweet":(Tweet *)_tweet}];
}

- (IBAction)onRetweetTap:(id)sender {
    UIImage *RetweetImage = [UIImage imageNamed:@"retweet_done.png"];
    [self.retweetButton setBackgroundImage:RetweetImage forState:UIControlStateNormal];

    [[NSNotificationCenter defaultCenter] postNotificationName:RetweetTapped object:self userInfo: @{@"tweet":(Tweet *)_tweet}];
}

- (IBAction)onStarTap:(id)sender {
    UIImage *FavImage = [UIImage imageNamed:@"isFav.png"];
    [self.favoriteButton setBackgroundImage:FavImage forState:UIControlStateNormal];

  [[NSNotificationCenter defaultCenter] postNotificationName:FavoriteTapped object:self userInfo: @{@"tweet":(Tweet *)_tweet}];
}
@end
