//
//  LogInViewController.h
//  OneBrown
//
//  Created by Benjamin Murphy on 1/13/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"

@class UserManager;

@interface LogInViewController : UIViewController <UITextFieldDelegate, NetworkManagerDelegate> {
    NSMutableArray *logInOrRegister;
    NSMutableArray *logIn;
    NSMutableArray *registration;
    NSMutableArray *code;
    
    NetworkManager *networkManager;
    UserManager *userManager;
}

@property (nonatomic, assign) NSInteger activeScreen;

@property (nonatomic, retain) CAKeyframeAnimation *shakeAnimation;

@property (nonatomic, retain) NetworkManager *networkManager;
@property (nonatomic, retain) UserManager *userManager;

@property (nonatomic, retain) NSMutableArray *logInOrRegister;
@property (nonatomic, retain) NSMutableArray *logIn;
@property (nonatomic, retain) NSMutableArray *registration;
@property (nonatomic, retain) NSMutableArray *code;

@property (nonatomic, retain) IBOutlet UITextField *usernameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UITextField *enterUsername;
@property (nonatomic, retain) IBOutlet UITextField *enterPassword;
@property (nonatomic, retain) IBOutlet UITextField *verifyPassword;
@property (nonatomic, retain) IBOutlet UITextField *enterCode;

@property (nonatomic, retain) IBOutlet UIButton *signInButton;
@property (nonatomic, retain) IBOutlet UIButton *registerButton;
@property (nonatomic, retain) IBOutlet UIButton *submitCodeButton;
@property (nonatomic, retain) IBOutlet UIButton *resendCodeButton;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IBOutlet UILabel *alreadyRegistered;
@property (nonatomic, retain) IBOutlet UILabel *errorRegistering;
@property (nonatomic, retain) IBOutlet UILabel *errorVerifying;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loginActivity;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *registerActivity;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *verifyActivity;

-(IBAction)signIn: (id)sender;
-(IBAction)submitCode: (id)sender;
-(IBAction)resendCode: (id)sender;
-(IBAction)registerUser: (id)sender;

-(IBAction)switchToLoginOrRegister: (id)sender;
-(IBAction)switchToLogin: (id)sender;
-(IBAction)switchToRegister: (id)sender;
-(void)switchToVerify;

-(void)createNetworkManager;

@end
