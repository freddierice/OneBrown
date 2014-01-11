//
//  ProfileViewController.m
//  OneBrown
//
//  Created by Valentin Perez on 1/6/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "ProfileViewController.h"
#import "SignInViewController.h"
#import "CAPopupWindow.h"

@interface ProfileViewController ()
{
    NSUserDefaults *defaults;
    
}
@end

@implementation ProfileViewController

@synthesize profileImageView, profileNameLabel;

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
	// Do any additional setup after loading the view.
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    profileImageView.layer.cornerRadius = 80;
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.borderWidth = 2;
    //UIColor *brownColor = [UIColor colorWithRed:89 green:38 blue:11 alpha:1];
    profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.addButton addTarget:self action:@selector(buttonPress) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)buttonPress {
    
    CAPopupWindow* popView = [[CAPopupWindow alloc] initWithObjectList:@[[CAWindowObject windowObject:@"Save" image:nil target:self action:@selector(say)],
                                                                         [CAWindowObject windowObject:@"Share" image:nil target:nil action:nil],
                                                                         [CAWindowObject windowObject:@"Delete" image:nil target:nil action:nil],
                                                                         [CAWindowObject windowObject:@"Undo" image:nil target:nil action:nil],
                                                                         [CAWindowObject windowObject:@"Redo" image:nil target:nil action:nil],
                                                                         [CAWindowObject windowObject:@"New" image:nil target:nil action:nil]]];
    [popView presentInView:self.view];
    
}

-(void) say {
    NSLog(@"Hi!");
}


- (IBAction)clickedLogOut:(id)sender
{
    [defaults setBool:NO forKey:@"loggedIn"];
    
    SignInViewController *signIn = [[SignInViewController alloc] init];
    signIn = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInController"];
    [self presentViewController:signIn animated:YES completion:nil];

}
@end
