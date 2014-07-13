//
//  TwitterClient.m
//  TwitterClient
//
//  Created by Pragya  Pherwani on 6/27/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import "TwitterClient.h"

@implementation TwitterClient

+(TwitterClient *)instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:@"WwqInOMlSBA2lhXiX3llZftuv" consumerSecret:@"aehiPLn38iz7b48aiQap4ueOLbFg8d84Zl9FCe00NgkkPSIP7z"];
    });
    return instance;
}

-(void) login {
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"cptwitter://oauth"]  scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Got the req token");
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } failure:^(NSError *error) {
         NSLog(@"Failure!");
    }];
}

-(AFHTTPRequestOperation *)homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil
             success:success failure:failure];
}

- (void)favoriteWithTweet:(Tweet *)tweet success:(void (^)())success
{
    [self POST:@"https://api.twitter.com/1.1/favorites/create.json"
       parameters:@{@"id": tweet.id}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           success();
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"Fav Fail, %@", error);
       }];
    
}


- (void)retweetWithTweet:(Tweet *)tweet success:(void (^)())success
{
    
    NSString *url = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json", tweet.id];
    [self POST:url
    parameters:nil
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           NSLog(@"Retweeted!");
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"Retweet Fail, %@", error);
       }];
}

- (AFHTTPRequestOperation *)verifyCurrentUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

- (void)tweetMessage:(NSString *)message success:(void (^)(Tweet *tweet))success
{
    [self POST:@"https://api.twitter.com/1.1/statuses/update.json"
    parameters:@{@"status": message}
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           NSLog(@"Tweeted!");
       }
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"Tweet Fail, %@", error);
       }];
}

-(AFHTTPRequestOperation *)getUserTimeline:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    return [self GET:@"1.1/users/show.json?screen_name=pragyapherwani" parameters:nil
             success:success failure:failure];
}


@end
