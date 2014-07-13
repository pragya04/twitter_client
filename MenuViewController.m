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

@interface MenuViewController ()
- (IBAction)onProfileTap:(id)sender;
- (IBAction)onTimelineTap:(id)sender;
- (IBAction)onMentionsTap:(id)sender;
- (IBAction)onLogoutTap:(id)sender;

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onProfileTap:(id)sender {
    ProfileViewController *pvc = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    pvc.selectedUserScreenName = @"pragyapherwani";
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
        NSLog(@"logout tapped");
}
@end
