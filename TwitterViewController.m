//
//  TwitterViewController.m
//  TwitterClient
//
//  Created by Pragya  Pherwani on 6/28/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import "TwitterViewController.h"
#import "ComposeViewController.h"
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
    
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Compose"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(composeButtonTap:)];
    
    self.navigationItem.rightBarButtonItem = composeButton;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil]
        forCellReuseIdentifier:@"TweetCell"];
//    _stubCell = [[UINib nibWithNibName:@"TweetCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    self.tableView.rowHeight = 120;
    self.client = [TwitterClient instance];
    [self loadData];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:@"FavoriteTapped" object:nil queue:nil usingBlock:^(NSNotification *notification)
     {
         [self favoriteTweet: (Tweet *)notification.userInfo];
     }];
    [center addObserverForName:@"RetweetTapped" object:nil queue:nil usingBlock:^(NSNotification *notification)
     {
         [self reTweet: (Tweet *)notification.userInfo];
     }];

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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    Tweet *t = self.tweets[indexPath.row];
//    _stubCell.tweet = t;
//    [_stubCell layoutSubviews];
//    
//    CGFloat height = [_stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    return height + 1;
//}
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 130.f;
//}

- (void)favoriteTweet:(Tweet*)tweet {
    
    [[TwitterClient instance] favoriteWithTweet:tweet success:^{
        NSLog(@"Favorited!");
    }];
}

- (void)reTweet:(Tweet*)tweet {
    
    [[TwitterClient instance] retweetWithTweet:tweet success:^{
        NSLog(@"Retweeted!");
    }];
}

- (void)composeButtonTap:(id)sender {
    ComposeViewController *cvc = [[ComposeViewController alloc] init];

    self.navigationItem.backBarButtonItem.title = @"Cancel";
    [self.navigationController pushViewController:cvc animated:YES];
}


@end