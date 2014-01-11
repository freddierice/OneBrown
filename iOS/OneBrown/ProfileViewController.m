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
    
    CAPopupWindow* popView = [[CAPopupWindow alloc] initWithObjectList:@[
                                                                         [CAWindowObject windowObject:@"Facebook" image:[UIImage imageNamed:@"facebookIcon"] target:nil action:nil],
                                                                         [CAWindowObject windowObject:@"Twitter" image:[UIImage imageNamed:@"twitterIcon"] target:nil action:nil],
                                                                         [CAWindowObject windowObject:@"Instagram" image:[UIImage imageNamed:@"instagramIcon"] target:nil action:nil],
                                                                         [CAWindowObject windowObject:@"Snapchat" image:[UIImage imageNamed:@"snapchatIcon"] target:nil action:nil],
                                                                         [CAWindowObject windowObject:@"Vine" image:[UIImage imageNamed:@"vineIcon"] target:nil action:nil],
                                                                         [CAWindowObject windowObject:@"LinkedIn" image:[UIImage imageNamed:@"linkedinIcon"] target:nil action:nil]]];
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
