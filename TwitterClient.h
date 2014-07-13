//
//  TwitterClient.h
//  TwitterClient
//
//  Created by Pragya  Pherwani on 6/27/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+(TwitterClient *)instance;

-(void)login;

- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)verifyCurrentUserWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (void)favoriteWithTweet:(Tweet *)Tweet success:(void (^)())success;
- (void)retweetWithTweet:(Tweet *)Tweet success:(void (^)())success;
- (void)tweetMessage:(NSString *)message success:(void (^)(Tweet *tweet))success;
- (AFHTTPRequestOperation *)getUserTimeline:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
