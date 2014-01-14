//
//  ProfileViewController.m
//  OneBrown
//
//  Created by Valentin Perez on 1/6/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "ProfileViewController.h"
#import "LogInViewController.h"
#import "SignInViewController.h"

@interface ProfileViewController ()
{
    NSUserDefaults *defaults;
}
@end

@implementation ProfileViewController

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

- (IBAction)clickedLogOut:(id)sender
{
    [defaults setObject:@"" forKey:@"sessionID"];
    
    LogInViewController *signIn = [[LogInViewController alloc] init];
    signIn = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInController"];
    [self presentViewController:signIn animated:YES completion:nil];

}
@end
