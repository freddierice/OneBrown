//
//  SignInViewController.h
//  OneBrown
//
//  Created by Benjamin Murphy on 1/2/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"

@interface SignInViewController : UIViewController <UITextFieldDelegate, NetworkManagerDelegate> {

    UIView *overlayView;
    
    NetworkManager *manager;
    
    NSArray *loginScreen;
    NSArray *openingScreen;
    NSArray *registerScreen;
    
}

@property (nonatomic, retain) NetworkManager *manager;

@property (nonatomic, retain) UIView *overlayView;

@property (nonatomic, weak) UITextField *userField;
@property (nonatomic, weak) UITextField *passField;

@property (nonatomic, weak) UITextField *enterPassword;
@property (nonatomic, weak) UITextField *confirmPassword;
@property (nonatomic, weak) UITextField *enterEmail;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *registrationButton;

@property (nonatomic, retain) NSArray *loginScreen;
@property (nonatomic, retain) NSArray *openingScreen;
@property (nonatomic, retain) NSArray *registerScreen;

@property (nonatomic, weak) UIView *tintView;

@property (nonatomic, weak) UIActivityIndicatorView *activity;
@property (nonatomic, weak) UIButton *signInButton;

// clicking on this button will dismiss this sign up view
- (IBAction)clickedTemporaryButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *temporaryButton;

@end
