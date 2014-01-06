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
    
}

@property (nonatomic, retain) NetworkManager *manager;

@property (nonatomic, retain) UIView *overlayView;

@property (nonatomic, weak) UIButton *signInButton;
@property (nonatomic, weak) UITextField *userField;
@property (nonatomic, weak) UITextField *passField;

@property (nonatomic, weak) UIView *loginOrRegister;
@property (nonatomic, weak) UIView *login;
@property (nonatomic, weak) UIView *signup;

@end
