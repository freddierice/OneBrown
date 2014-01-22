//
//  ProfileViewController.h
//  OneBrown
//
//  Created by Valentin Perez on 1/6/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UILabel *profileNameLabel;
    UIImageView *profileImageView;
}

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (strong, nonatomic) IBOutlet UITableView *networksTableView;
@property (strong, nonatomic) IBOutlet UIButton *addButton;


- (IBAction)clickedLogOut:(id)sender;

@end
