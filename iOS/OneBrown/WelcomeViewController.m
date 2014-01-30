//
//  WelcomeViewController.m
//  OneBrown
//
//  Created by Benjamin Murphy on 1/10/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "WelcomeViewController.h"
#import "FindViewController.h"
#import "LogInViewController.h"
#import "UserManager.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.getStartedButton.layer.cornerRadius = 5.0f;
    
    [self.getStartedButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissView {    
    [(UserManager *)[(LogInViewController *)[self presentingViewController] userManager] setManager: [(LogInViewController *)[self presentingViewController] networkManager]];
    
    
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
