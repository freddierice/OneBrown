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
                                                        image:sharedUserManager.socialNetworkImages[0]target:self action:@selector(addFacebook)],
                                                                         [CAWindowObject windowObject:sharedUserManager.socialNetworks[1] image:sharedUserManager.socialNetworkImages[1] target:self action:@selector(addTwitter)],
                                                                         [CAWindowObject windowObject:sharedUserManager.socialNetworks[2] image:sharedUserManager.socialNetworkImages[2] target:self action:@selector(addInstagram)],
                                                                         [CAWindowObject windowObject:sharedUserManager.socialNetworks[3] image:sharedUserManager.socialNetworkImages[3]target:self action:@selector(addSnapchat)]]];
    [popView presentInView:self.view];
    
}

- (void) addFacebook
{
    NSLog(@"adding facebook");
}

- (void) addTwitter
{
    NSLog(@"adding twitt");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter your Twitter username:"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Done", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 1;
    
    [alertView show];
}

- (void) addInstagram
{
    NSLog(@"adding insta");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter your Instagram username:"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Done", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 2;
    
    [alertView show];

}

- (void) addSnapchat
{
    NSLog(@"adding snap");

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter your Snapchat username:"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Done", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 3;
    
    [alertView show];

}

- (void) alertView: (UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *userNameWritten = [alertView textFieldAtIndex:0].text;

    // If clicked the Done button. 
    if (buttonIndex == 1)
    {
        switch ((int) alertView.tag)
        {
            case 0:
                NSLog(@"facebook");
                break;
            case 1:
                [sharedUserManager.userNetworks setObject:userNameWritten forKey:@"twitter"];
                break;
            case 2:
                [sharedUserManager.userNetworks setObject:userNameWritten forKey:@"instagram"];
                break;
            case 3:
                [sharedUserManager.userNetworks setObject:userNameWritten forKey:@"snapchat"];
                break;
            default:
                break;
        }
        
        
        NSLog(@"username: %@  tag: %d", userNameWritten, (int)alertView.tag);
    }
    
}



- (IBAction)clickedLogOut:(id)sender
{
    [defaults setBool:NO forKey:@"loggedIn"];
    
    SignInViewController *signIn = [[SignInViewController alloc] init];
    signIn = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInController"];
    [self presentViewController:signIn animated:YES completion:nil];

}
@end
