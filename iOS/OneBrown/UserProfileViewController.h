//
//  UserProfileViewController.h
//  OneBrown
//
//  Created by Valentin Perez on 1/7/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserProfileViewController : UIViewController
{
    UILabel *nameLabel;
    UIImageView *userImageView;
    
}

    

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;

- (IBAction)clickedBack:(id)sender;

@end

