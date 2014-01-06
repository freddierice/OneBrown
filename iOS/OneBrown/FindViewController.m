//
//  FindViewController.m
//  OneBrown
//
//  Created by Valentin Perez on 1/6/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "FindViewController.h"
#import "SignInViewController.h"

@interface FindViewController ()
{
    
    NSUserDefaults *defaults;
}

@end

@implementation FindViewController

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

-(void)viewDidAppear:(BOOL)animated
{
    // Show the sign up/log in view if the user is not loggedIn
    if(![defaults boolForKey:@"loggedIn"])
    {
        SignInViewController *signIn = [[SignInViewController alloc] init];
        signIn = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInController"];
        [self presentViewController:signIn animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
