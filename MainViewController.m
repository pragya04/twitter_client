//
//  MainViewController.m
//  TwitterClient
//
//  Created by Pragya  Pherwani on 7/13/14.
//  Copyright (c) 2014 Pragya  Pherwani. All rights reserved.
//

#import "MainViewController.h"
#import "MenuViewController.h"
#import "TwitterViewController.h"
#import "TwitterClient.h"
#import <QuartzCore/QuartzCore.h>
#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 60

@interface MainViewController () <TwitterViewControllerDelegate>
//@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, assign) BOOL showingMenuPanel;
@property (strong, nonatomic) UIBarButtonItem *menuPanelButton;
@property (strong, nonatomic) TwitterViewController *twitterVC;
@property (strong, nonatomic) MenuViewController *menuVC;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.twitterVC = [[TwitterViewController alloc]init];
//        self.menuVC = [[MenuViewController alloc]init];
//        if ([[TwitterClient instance] isAuthorized]) {
//            [self showTimeline];
//        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

-(void)setUpView {
    self.menuPanelButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(btnMovePanelRight:)];
    
    self.navigationItem.leftBarButtonItem = self.menuPanelButton;
    self.menuPanelButton.tag = 1;
    self.twitterVC = [[TwitterViewController alloc] initWithNibName:@"TwitterViewController" bundle:nil];
    self.twitterVC.view.tag = CENTER_TAG;
    self.twitterVC.delegate = self;
    [self.view addSubview:self.twitterVC.view];
    [self addChildViewController:_twitterVC];
    
    [_twitterVC didMoveToParentViewController:self];
}

- (void)btnMovePanelRight:(id)sender {
    UIButton *button = sender;
    NSLog(@"button tag %d", button.tag);
    switch (button.tag){
        case 0: {
            [self movePanelToOriginalPosition];
            break;
        }
        case 1: {
            [self movePanelRight];
            break;
        }
        default:
            break;
    }
    
}

- (void)movePanelToOriginalPosition
{
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _twitterVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             [self resetMainView];
                         }
                     }];
}
- (void)movePanelRight
{
    UIView *childView = [self getMenuView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _twitterVC.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.menuPanelButton.tag = 0;
                         }
                     }];
}

- (void)resetMainView
{
    // remove left view and reset variables, if needed
    if (_menuVC != nil)
    {
        [self.menuVC.view removeFromSuperview];
        self.menuVC = nil;
        
        self.menuPanelButton.tag = 1;
        self.showingMenuPanel = NO;
    }
    
    // remove view shadows
    [self showCenterViewWithShadow:NO withOffset:0];
}

-(UIView *) getMenuView {
    // init view if it doesn't already exist
    if (_menuVC == nil)
    {
        // this is where you define the view for the left panel
        self.menuVC = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        self.menuVC.view.tag = LEFT_PANEL_TAG;
        
        [self.view addSubview:self.menuVC.view];
        
        [self addChildViewController:_menuVC];
        [_menuVC didMoveToParentViewController:self];
        
        _menuVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingMenuPanel = YES;
    
    // set up view shadows
//    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.menuVC.view;
    return view;
}

- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    if(value){
        [_twitterVC.view.layer setCornerRadius:CORNER_RADIUS];
        [_twitterVC.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_twitterVC.view.layer setShadowOpacity:0.8];
        [_twitterVC.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }else {
        [_twitterVC.view.layer setCornerRadius:0.0f];
        [_twitterVC.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showTimeline {
    
    TwitterViewController *tvc = [[TwitterViewController alloc] initWithNibName:@"TwitterViewController" bundle:nil];
    [self.navigationController pushViewController:tvc animated:YES];
}


@end
