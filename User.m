//
//  User.m
//  TwitterClient
//
//  Created by Pragya  Pherwani on 6/28/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import "User.h"

@implementation User
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userImage": @"profile_image_url",
             @"userNameLabel": @"name",
             @"userScreenName": @"screen_name",
             @"numFollowers": @"followers_count",
             @"numFollowing": @"friends_count",
             @"numTweets": @"statuses_count"
             };
}

@end
