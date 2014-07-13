//
//  TwitterViewController.m
//  TwitterClient
//
//  Created by Pragya  Pherwani on 6/28/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import "TwitterViewController.h"
#import "ComposeViewController.h"
#import "TweetViewController.h"
#import "MenuViewController.h"
#import "TweetCell.h"
#import "TwitterClient.h"
#import "Tweet.h"

@interface TwitterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TwitterClient *client;

@end

@implementation TwitterViewController {
    TweetCell *_stubCell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Home";
    }
//    UIBarButtonItem *logOutButton = [[UIBarButtonItem alloc]
//                                      initWithTitle:@"Log Out"
//                                      style:UIBarButtonItemStylePlain
//                                      target:self
//                                      action:@selector(logOut:)];
//    
//    self.navigationItem.leftBarButtonItem = logOutButton;
    
    UIBarButtonItem *showMenu = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Menu"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(showMenuAction:)];
    
    self.navigationItem.leftBarButtonItem = showMenu;
    
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Compose"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(composeButtonTap:)];
    
    self.navigationItem.rightBarButtonItem = composeButton;

    return self;
}

- (void)logOut:(id)sender {
    [[TwitterClient instance].requestSerializer removeAccessToken];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil]
        forCellReuseIdentifier:@"TweetCell"];
    _stubCell = [[UINib nibWithNibName:@"TweetCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    self.client = [TwitterClient instance];
    
    
    /* For refresh control*/
    UITableViewController *tvc = [[UITableViewController alloc] init];
    tvc.tableView = self.tableView;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshControl addTarget:self
                       action:@selector(refresh:)
             forControlEvents:UIControlEventValueChanged];
    tvc.refreshControl = refreshControl;
    
    [self loadData];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:@"FavoriteTapped" object:nil queue:nil usingBlock:^(NSNotification *notification)
     {
         [self favoriteTweet: (NSDictionary *)notification.userInfo];
     }];
    [center addObserverForName:@"RetweetTapped" object:nil queue:nil usingBlock:^(NSNotification *notification)
     {
         [self reTweet: (NSDictionary *)notification.userInfo];
     }];

    [center addObserverForName:@"ReplyTapped" object:nil queue:nil usingBlock:^(NSNotification *notification)
     {
         [self replyTweet: (NSDictionary *)notification.userInfo];
     }];

}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadData];
    [refreshControl endRefreshing];
}

-(void)loadData {
    [self.client homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.tweets = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < [responseObject count]; i++) {
            [self.tweets addObject:[MTLJSONAdapter modelOfClass:[Tweet class] fromJSONDictionary:responseObject[i] error:nil]];
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error loading timeline %@", error);
    }];
}

-(void)viewDidAppear{
    NSLog(@"here1");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma-mark table view methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetViewController *tweetvc = [[TweetViewController alloc] init];
    tweetvc.singleTweet = ((Tweet *)self.tweets[indexPath.row]);
    self.navigationItem.backBarButtonItem.title = @"Home";
    [self.navigationController pushViewController:tweetvc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tweet *t = self.tweets[indexPath.row];
    _stubCell.tweet = t;
    [_stubCell layoutSubviews];
    
    CGFloat height = [_stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height + 1;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.f;
}
#pragma-mark user actions
- (void)favoriteTweet:(NSDictionary*)tweet {
    [[TwitterClient instance] favoriteWithTweet:tweet[@"tweet"] success:^{
        NSLog(@"Favorited!");
    }];
}

- (void)reTweet:(NSDictionary*)tweet {
//    TweetCell *cell = [[TweetCell alloc]init];
    [[TwitterClient instance] retweetWithTweet:tweet[@"tweet"] success:^{
        NSLog(@"Retweeted!");
    }];
}

- (void)replyTweet:(NSDictionary*)tweet {
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    Tweet *tweetModel = tweet[@"tweet"];
    cvc.defaultText = [NSString stringWithFormat:@"@%@", tweetModel.screenName];
    self.navigationItem.backBarButtonItem.title = @"Cancel";
    [self.navigationController pushViewController:cvc animated:YES];

}

- (void)composeButtonTap:(id)sender {
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    self.navigationItem.backBarButtonItem.title = @"Cancel";
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)showMenuAction:(id)sender {
    MenuViewController *mvc = [[MenuViewController alloc] init];
    [self.navigationController pushViewController:mvc animated:YES];
}


@end
