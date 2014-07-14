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
#import "ComposeViewController.h"
#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 60

@interface MainViewController () <TwitterViewControllerDelegate>
//@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, assign) BOOL showingMenuPanel;
@property (strong, nonatomic) UIBarButtonItem *menuPanelButton;
@property (strong, nonatomic) UIBarButtonItem *composeButton;
@property (strong, nonatomic) TwitterViewController *twitterVC;
@property (strong, nonatomic) MenuViewController *menuVC;
@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    [self setupGestures];
}

-(void)setUpView {
    self.menuPanelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"twitter_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(btnMovePanelRight:)];
    
    self.navigationItem.leftBarButtonItem = self.menuPanelButton;
    
    self.composeButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Compose"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(composeButtonTap:)];
    
    self.navigationItem.rightBarButtonItem = self.composeButton;

    self.menuPanelButton.tag = 1;
    self.twitterVC = [[TwitterViewController alloc] initWithNibName:@"TwitterViewController" bundle:nil];
    self.twitterVC.view.tag = CENTER_TAG;
    self.twitterVC.delegate = self;
    [self.view addSubview:self.twitterVC.view];
    [self addChildViewController:_twitterVC];
    
    [_twitterVC didMoveToParentViewController:self];
}


- (void)composeButtonTap:(id)sender {
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    self.navigationItem.backBarButtonItem.title = @"Cancel";
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)btnMovePanelRight:(id)sender {
    UIButton *button = sender;
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


-(void)setupGestures {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
//    [panRecognizer setDelegate:self];
    
    [_twitterVC.view addGestureRecognizer:panRecognizer];
}

-(void)movePanel:(id)sender {
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        UIView *childView = nil;
        
        if(velocity.x > 0){
            childView = [self getMenuView];
        }
        // Make sure the view you're working with is front and center.
        [self.view sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        
        if (!_showPanel) {
            [self movePanelToOriginalPosition];
        } else {
            if (_showingMenuPanel) {
                [self movePanelRight];
            }
        }
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        
        // Are you more than halfway? If so, show the panel when done dragging by setting this value to YES (1).
        _showPanel = abs([sender view].center.x - _twitterVC.view.frame.size.width/2) > _twitterVC.view.frame.size.width/2;
        
        // Allow dragging only in x-coordinates by only updating the x-coordinate with translation position.
        [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
        [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        
        // If you needed to check for a change in direction, you could use this code to do so.
        if(velocity.x*_preVelocity.x + velocity.y*_preVelocity.y > 0) {
            // NSLog(@"same direction");
        } else {
            // NSLog(@"opposite direction");
        }
        
        _preVelocity = velocity;
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
