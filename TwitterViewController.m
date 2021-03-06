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
#import "ProfileViewController.h"
#import "TweetCell.h"
#import "TwitterClient.h"
#import "Tweet.h"

@interface TwitterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TwitterClient *client;
@property (nonatomic, strong) Tweet *selectedTweet;

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
        
    return self;
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
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"twitter_menu.png"];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"twitter_menu.png"];
    self.navigationController.navigationBar.topItem.title = @"";
    
    /* For refresh control*/
    UITableViewController *tvc = [[UITableViewController alloc] init];
    tvc.tableView = self.tableView;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshControl addTarget:self
                       action:@selector(refresh:)
             forControlEvents:UIControlEventValueChanged];
    tvc.refreshControl = refreshControl;
    if(self.isMentionsView) {
        [self loadMentionsData];
    } else {
        [self loadData];
    }
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

- (void)loadMentionsData {
    [self.client mentionsTimeLine:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.tweets = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < [responseObject count]; i++) {
            [self.tweets addObject:[MTLJSONAdapter modelOfClass:[Tweet class] fromJSONDictionary:responseObject[i] error:nil]];
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error loading mentions timeline %@", error);
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
    cell.userImage.userInteractionEnabled = YES;
    cell.userImage.tag = indexPath.row;
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserProfile:)];
    tapped.numberOfTapsRequired = 1;
    [cell.userImage addGestureRecognizer:tapped];
    
    return cell;
}

- (void)showUserProfile: (UITapGestureRecognizer *)sender
{
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    
    Tweet *selectedTweet = self.tweets[sender.view.tag];
    
    pvc.selectedUserScreenName = selectedTweet.screenName;
    [self.navigationController pushViewController:pvc animated:YES];
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

- (void)showMenuAction:(id)sender {

    
//    MenuViewController *mvc = [[MenuViewController alloc] init];
//    [self.navigationController pushViewController:mvc animated:YES];
}


@end
