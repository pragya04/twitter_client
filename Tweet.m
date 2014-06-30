//
//  Tweet.m
//  TwitterClient
//
//  Created by Pragya  Pherwani on 6/28/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
    @"id": @"id",
    @"userImageUrl": @"user.profile_image_url",
    @"name": @"user.name",
    @"screenName": @"user.screen_name",
    @"tweetContent": @"text",
    @"createdAt": @"created_at",
    @"favorited": @"favorited",
    @"retweeted": @"retweeted"
    };
}

@end
