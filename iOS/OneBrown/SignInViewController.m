//
//  SignInViewController.m
//  OneBrown
//
//  Created by Benjamin Murphy on 1/2/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "SignInViewController.h"
#import "LoginLogic.h"
#import <Foundation/Foundation.h>

@interface SignInViewController ()

@end

@implementation SignInViewController

@synthesize manager, userField, passField, signInButton, overlayView, loginOrRegister, login, signup;



- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *overlay = [[UIView alloc] initWithFrame:self.view.frame];
    overlay.backgroundColor = [UIColor clearColor];
    self.overlayView = overlay;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayViewActivated)];
    gestureRecognizer.numberOfTapsRequired = 1;
    gestureRecognizer.numberOfTouchesRequired = 1;
    [self.overlayView addGestureRecognizer:gestureRecognizer];
    
    self.overlayView.hidden = YES;
    
    [self configureBackground];
    [self configureUsernameAndPassword];
    [self configureSignInAndRegister];
    [self configureRegistration];
    [self createNetworkManager];
    
    [self.view addSubview:self.overlayView];
    
    
    // Brings the temporaryButton to the front so that it can be clicked.
    [self.view bringSubviewToFront:_temporaryButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void)animateToLogin {
    [UIView animateWithDuration:0.3f animations:^{
        [self.loginOrRegister setFrame:CGRectMake(-320, 170, 320, 132)];
        [self.login setFrame:CGRectMake(0, 150, 320, 382)];
    }];
}

- (void)animateToChoice {
    [UIView animateWithDuration:0.3f animations:^{
        [self.loginOrRegister setFrame:CGRectMake(0, 170, 320, 132)];
        [self.login setFrame:CGRectMake(320, 150, 320, 382)];
    }];
}

- (void)animateToRegister {
    
    // Animate to display registration screen
    
}



- (void)signIn: (id)sender {
    
    NSError *e;
    
    NSData *loginRequest = [NSJSONSerialization dataWithJSONObject:@{@"message":@"login"} options:kNilOptions error:&e];
    
    NSDictionary *loginInformation = @{@"user":self.userField.text, @"pass":self.passField.text};
    
    NSData* information = [NSJSONSerialization dataWithJSONObject:loginInformation options:kNilOptions error:&e];

    BOOL success = [self.manager writeData:loginRequest];
    if (success) {
        [self.manager writeData:information];
    }
    else {
        NSLog(@"Error writing to server.");
    }
}

- (void)overlayViewActivated {
    [self.userField resignFirstResponder];
    [self.passField resignFirstResponder];
}

#pragma mark - configuration

- (void)configureRegistration {
    
    // Set up registration screen
    
}

- (void)configureBackground {
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame: self.view.frame];
    
    [backgroundView setImage:[UIImage imageNamed:@"background"]];
    
    [self.view addSubview: backgroundView];
    
    UIView *shadingView = [[UIView alloc] initWithFrame: self.view.frame];
    
    shadingView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
    
    [self.view addSubview:shadingView];
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 320, 75)];
    [titleView setImage:[UIImage imageNamed:@"oneBrown"]];
    
    [self.view addSubview:titleView];
    
}

- (void)configureUsernameAndPassword {
    
    UIView *loginView = [[UIView alloc] initWithFrame:CGRectMake(320, 150, 320, self.view.frame.size.height-150)];
    
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 250, 20)];
    usernameLabel.font = [UIFont systemFontOfSize:16.0f];
    usernameLabel.textColor = [UIColor whiteColor];
    
    usernameLabel.text = @"Username";
    
    [loginView addSubview:usernameLabel];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 74, 250, 20)];
    passwordLabel.font = [UIFont systemFontOfSize:16.0f];
    passwordLabel.textColor = [UIColor whiteColor];
    
    passwordLabel.text = @"Password";
    
    [loginView addSubview:passwordLabel];
    
    UITextField *usernameField = [[UITextField alloc] initWithFrame: CGRectMake(35, 20, 250, 44)];
    UITextField *passwordField = [[UITextField alloc] initWithFrame: CGRectMake(35, 94, 250, 44)];
    
    usernameField.font = [UIFont systemFontOfSize:20.0f];
    passwordField.font = [UIFont systemFontOfSize:20.0f];
    
    usernameField.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    passwordField.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    
    usernameField.textColor = [UIColor whiteColor];
    passwordField.textColor = [UIColor whiteColor];
    
    usernameField.borderStyle = UITextBorderStyleRoundedRect;
    passwordField.borderStyle = UITextBorderStyleRoundedRect;
    
    usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    usernameField.placeholder = @"Username or Email";
    passwordField.placeholder = @"Password";
    
    passwordField.secureTextEntry = YES;
    
    usernameField.delegate = self;
    passwordField.delegate = self;
    
    self.userField = usernameField;
    self.passField = passwordField;
    
    [loginView addSubview: usernameField];
    [loginView addSubview: passwordField];
    
    UIButton *signIn = [UIButton buttonWithType:UIButtonTypeCustom];
    [signIn setFrame:CGRectMake(35, 188, 250, 44)];
    [signIn setTitle:@"Sign In" forState:UIControlStateNormal];
    [signIn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8f]];
    [signIn.titleLabel setTextColor:[UIColor whiteColor]];
    [signIn.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    signIn.layer.cornerRadius = 5.0f;
    
    [signIn addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.signInButton = signIn;
    
    [loginView addSubview:signIn];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(35, self.view.frame.size.height-214, 250, 44)];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8f]];
    [back.titleLabel setTextColor:[UIColor whiteColor]];
    [back.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    back.layer.cornerRadius = 5.0f;
    
    [back addTarget:self action:@selector(animateToChoice) forControlEvents:UIControlEventTouchUpInside];
    
    [loginView addSubview:back];
    
    self.login = loginView;
    
    [self.view addSubview:self.login];
    
}

- (void)createNetworkManager {
    
    NetworkManager *nManager = [NetworkManager networkManagerWithHost:(CFStringRef)@"54.200.186.84" port:20000];
    
    nManager.delegate = self;
    
    [nManager open];
    
    self.manager = nManager;
    
}

- (void)configureSignInAndRegister {
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 170, 320, 132)];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(35, 0, 250, 44)];
    [loginButton setTitle:@"Log In" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8f]];
    [loginButton.titleLabel setTextColor:[UIColor whiteColor]];
    [loginButton.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    loginButton.layer.cornerRadius = 5.0f;
    
    [loginButton addTarget:self action:@selector(animateToLogin) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:loginButton];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setFrame:CGRectMake(35, 74, 250, 44)];
    [registerButton setTitle:@"Register" forState:UIControlStateNormal];
    [registerButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8f]];
    [registerButton.titleLabel setTextColor:[UIColor whiteColor]];
    [registerButton.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    registerButton.layer.cornerRadius = 5.0f;
    
    [registerButton addTarget:self action:@selector(animateToRegister) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:registerButton];
    
    [self.view addSubview:buttonView];
    
    self.loginOrRegister = buttonView;
    
}

#pragma mark - UITextFieldDelegate protocol implementation

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.overlayView.hidden = YES;
    
    BOOL valid = [LoginLogic validateUsername:self.userField.text] && [LoginLogic validatePassword:self.passField.text];
    
    self.signInButton.enabled = (valid) ? YES : NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.overlayView.hidden = NO;
}

#pragma mark - NetworkManagerDelegate protocol implementation

-(void)didReceiveJSON:(NSDictionary *)JSON {
    NSLog(@"%@", JSON); 
}

- (IBAction)clickedTemporaryButton:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIn"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
