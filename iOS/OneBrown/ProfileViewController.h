//
//  ProfileViewController.h
//  OneBrown
//
//  Created by Valentin Perez on 1/6/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FBLoginViewDelegate>
{
    UILabel *profileNameLabel;
    FBProfilePictureView *profileImageView;
}

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (strong, nonatomic) IBOutlet UITableView *networksTableView;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;
@property (strong, nonatomic) IBOutlet UIButton *getFacebookInfoButton;
@property (strong, nonatomic) IBOutlet FBLoginView *facebookLogInView;

@end
