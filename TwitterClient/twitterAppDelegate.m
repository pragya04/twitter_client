//
//  twitterAppDelegate.m
//  TwitterClient
//
//  Created by Pragya  Pherwani on 6/26/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import "twitterAppDelegate.h"
#import "LoginViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import <Mantle.h>

@implementation NSURL (dictionaryFromQueryString)

- (NSDictionary *)dictionaryFromQueryString
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];
    
    for(NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dictionary setObject:val forKey:key];
    }
    
    return dictionary;
}

@end

@implementation twitterAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.lvc = [[LoginViewController alloc] init];
    self.tvc = [[TwitterViewController alloc] init];
    
    self.nc = [[UINavigationController alloc] initWithRootViewController:self.lvc];
    self.window.rootViewController = self.nc;
    
    self.nc.navigationBar.translucent = NO;
    self.nc.navigationBar.barTintColor = [UIColor blueColor];
    self.nc.navigationBar.tintColor = [UIColor whiteColor];
    [self.nc.navigationBar setBarStyle:UIBarStyleBlack];

    if ([[TwitterClient instance] isAuthorized]) {
        [self showTimeline];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"cptwitter"])
    {
        if ([url.host isEqualToString:@"oauth"])
        {
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                TwitterClient *client = [TwitterClient instance];
                [client fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
                    NSLog(@"Access token");
                    [client.requestSerializer saveAccessToken:accessToken];
                    
                    [client homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                            //NSLog(@"response: %@", responseObject);
                        [self showTimeline];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"responseerror");
                    }];
                } failure:^(NSError *error) {
                    NSLog(@"Access token error");
                }];
            }
        }
        return YES;
    }
    return NO;
}

-(void) showTimeline {
    TwitterViewController *tvc = [[TwitterViewController alloc] initWithNibName:@"TwitterViewController" bundle:nil];
    [self.nc pushViewController:tvc animated:YES];
}
@end