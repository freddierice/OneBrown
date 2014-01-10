//
//  UserProfileViewController.m
//  OneBrown
//
//  Created by Valentin Perez on 1/7/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UserManager.h"

@interface UserProfileViewController ()
{
    UserManager *sharedUserManager;
}

@end

@implementation UserProfileViewController

@synthesize nameLabel, userImageView;


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

    sharedUserManager = [UserManager sharedUserManager];
    
    nameLabel.text = sharedUserManager.stalkedUserName;
    
    userImageView.layer.cornerRadius = 80;
    userImageView.clipsToBounds = YES;
    userImageView.layer.borderWidth = 2;
    userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
   [userImageView setImage: sharedUserManager.stalkedUserImage];
    
    
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

- (IBAction)clickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
