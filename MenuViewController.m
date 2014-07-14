//
//  MenuViewController.m
//  TwitterClient
//
//  Created by Pragya  Pherwani on 7/11/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import "MenuViewController.h"
#import "TwitterViewController.h"
#import "ProfileViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "LoginViewController.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *menuUserImg;
@property (weak, nonatomic) IBOutlet UILabel *menuUserName;
@property (weak, nonatomic) IBOutlet UILabel *menuScreenName;

- (IBAction)onProfileTap:(id)sender;
- (IBAction)onTimelineTap:(id)sender;
- (IBAction)onMentionsTap:(id)sender;
- (IBAction)onLogoutTap:(id)sender;
@property (nonatomic, strong) User *user;

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Menu";
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
        
    [[TwitterClient instance] verifyCurrentUserWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.user =  [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject error:nil];
        [self displayUserInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"No user %@", error);
    }];

}

-(void) displayUserInfo {
    self.menuUserName.text = self.user.userNameLabel;
    self.menuScreenName.text = [NSString stringWithFormat:@"@%@", self.user.userScreenName];
    self.menuUserImg.layer.cornerRadius = 5;
    self.menuUserImg.clipsToBounds=YES;
    [self.menuUserImg setImageWithURL:[NSURL URLWithString:self.user.userImage]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onProfileTap:(id)sender {
    ProfileViewController *pvc = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    pvc.selectedUserScreenName = self.user.userScreenName;
    [self.navigationController pushViewController:pvc animated:YES];

}

- (IBAction)onTimelineTap:(id)sender {
    TwitterViewController *tvc = [[TwitterViewController alloc] initWithNibName:@"TwitterViewController" bundle:nil];
    [self.navigationController pushViewController:tvc animated:YES];

}
- (IBAction)onMentionsTap:(id)sender {
    TwitterViewController *tvc = [[TwitterViewController alloc] initWithNibName:@"TwitterViewController" bundle:nil];
        tvc.isMentionsView = YES;
    [self.navigationController pushViewController:tvc animated:YES];
}

- (IBAction)onLogoutTap:(id)sender {
    LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [[TwitterClient instance].requestSerializer removeAccessToken];
    [self.navigationController pushViewController:lvc animated:YES];
}
@end
