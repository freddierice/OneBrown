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
#import "UserManager.h"

@interface ProfileViewController ()
{
    NSUserDefaults *defaults;
    UserManager *sharedUserManager;
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
    
    sharedUserManager = [UserManager sharedUserManager];
    
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
    
    CAPopupWindow* popView = [[CAPopupWindow alloc] initWithObjectList:@[
                                                                         [CAWindowObject windowObject:sharedUserManager.socialNetworks[0]
                                                                                                image:sharedUserManager.socialNetworkImages[0]target:nil action:nil],
                                                                         [CAWindowObject windowObject:sharedUserManager.socialNetworks[1] image:sharedUserManager.socialNetworkImages[1] target:nil action:nil],
                                                                         [CAWindowObject windowObject:sharedUserManager.socialNetworks[2] image:sharedUserManager.socialNetworkImages[2] target:nil action:nil],
                                                                         [CAWindowObject windowObject:sharedUserManager.socialNetworks[3] image:sharedUserManager.socialNetworkImages[3]target:nil action:nil],
                                                                         [CAWindowObject windowObject:sharedUserManager.socialNetworks[4] image:sharedUserManager.socialNetworkImages[4] target:nil action:nil],
                                                                         [CAWindowObject windowObject:sharedUserManager.socialNetworks[5] image:sharedUserManager.socialNetworkImages[5] target:nil action:nil]]];
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
