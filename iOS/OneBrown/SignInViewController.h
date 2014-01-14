//
//  SignInViewController.h
//  OneBrown
//
//  Created by Benjamin Murphy on 1/2/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"

@class UserManager;

@interface SignInViewController : UIViewController <UITextFieldDelegate, NetworkManagerDelegate> {

    UIView *overlayView;
    
    NetworkManager *manager;
    
    NSArray *loginScreen;
    NSArray *openingScreen;
    NSArray *registerScreen;
    NSArray *verifyScreen;
}

@property (nonatomic, retain) NetworkManager *manager;
@property (nonatomic, weak) UserManager *userManager;

@property (nonatomic, retain) UIView *overlayView;

@property (nonatomic, retain) NSArray *verifyScreen;
@property (nonatomic, retain) NSArray *loginScreen;
@property (nonatomic, retain) NSArray *openingScreen;
@property (nonatomic, retain) NSArray *registerScreen;

// clicking on this button will dismiss this sign up view
- (IBAction)clickedTemporaryButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *temporaryButton;

@end
