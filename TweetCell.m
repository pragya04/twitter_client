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

@implementation TweetCell
static NSDateFormatter *formatter = nil;
NSString * const FavoriteTapped = @"FavoriteTapped";
NSString * const RetweetTapped = @"RetweetTapped";

- (void)awakeFromNib {

    [self.retweetButton setImage:[UIImage imageNamed:@"retweet.png"]
                            forState:UIControlStateNormal];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet_done.png"]
                        forState:UIControlStateNormal];
    [self.replyButton setImage:[UIImage imageNamed:@"reply.png"]
                         forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"fav.png"]
                         forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"isFav.png"]
                         forState:UIControlStateSelected];
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
    self.userImage.clipsToBounds=YES;
    [self.userImage setImageWithURL:[NSURL URLWithString:tweet.userImageUrl]];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
//    if (tweet.retweetedByName) {
//        self.lblSomeoneRetweeted.text = [NSString stringWithFormat:@"%@ retweeted", tweet.retweetedByName];
//    }else {
//        self.viewRetweet.hidden = YES;
//        self.constraintRetweet.constant -= 30;
//    }
    self.userTweetTimestamp.text = [MHPrettyDate prettyDateFromDate:[formatter dateFromString:tweet.createdAt] withFormat:MHPrettyDateShortRelativeTime];
    [self.favoriteButton setSelected:tweet.favorited];
    [self.retweetButton setSelected:tweet.retweeted];
}


- (IBAction)onReplyTap:(id)sender {
}

- (IBAction)onRetweetTap:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:RetweetTapped object:self userInfo: @{@"sender": sender, @"tweet":(Tweet *)_tweet}];
}

- (IBAction)onStarTap:(id)sender {
  [[NSNotificationCenter defaultCenter] postNotificationName:FavoriteTapped object:self userInfo: @{@"sender": sender, @"tweet":(Tweet *)_tweet}];
}
@end
