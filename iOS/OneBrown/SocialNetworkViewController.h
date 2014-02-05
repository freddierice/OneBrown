//
//  SocialNetworkViewController.h
//  OneBrown
//
//  Created by Valentin Perez on 2/3/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialNetworkViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIImageView *networkImageView;
    UILabel *networkNameLabel;
}

@property (strong, nonatomic) IBOutlet UIImageView *networkImageView;
@property (strong, nonatomic) IBOutlet UILabel *networkNameLabel;
@property (strong, nonatomic) IBOutlet UITableView *usersInNetworkTableView;

- (IBAction)clickedBack:(id)sender;


@end
