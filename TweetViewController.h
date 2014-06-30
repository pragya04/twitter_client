//
//  TweetViewController.h
//  TwitterClient
//
//  Created by Pragya  Pherwani on 6/30/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *retweetByName;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *tweetTimestamp;
@property (weak, nonatomic) IBOutlet UILabel *rewteetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCount;
@property (nonatomic, strong) Tweet *singleTweet;

@end
