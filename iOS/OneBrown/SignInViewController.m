//
//  SignInViewController.m
//  OneBrown
//
//  Created by Benjamin Murphy on 1/2/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "SignInViewController.h"
#import "LoginLogic.h"
#import "TabController.h"
#import <Foundation/Foundation.h>

@interface SignInViewController ()

@end

@implementation SignInViewController

@synthesize manager, userField, passField, overlayView, openingScreen, loginScreen, registerScreen;

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
    
    [self configureBackground];

    self.overlayView.hidden = YES;
    
    [self configureUsernameAndPassword];
    [self configureSignInAndRegister];
    [self configureRegistration];
    [self createNetworkManager];
    // Brings the temporaryButton to the front so that it can be clicked.
    //[self.view bringSubviewToFront:_temporaryButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void)animateToLogin {
    [UIView animateWithDuration:0.3f animations:^{
        for (UIView *view in self.loginScreen) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x-320, frame.origin.y, frame.size.width, frame.size.height);
        }
        for (UIView *view in self.openingScreen) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x+320, frame.origin.y, frame.size.width, frame.size.height);
        }
    }];
}

- (void)animateToChoice {
    [UIView animateWithDuration:0.3f animations:^{
        for (UIView *view in self.loginScreen) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(fmodf(frame.origin.x, 320.0f)+320, frame.origin.y, frame.size.width, frame.size.height);
        }
        for (UIView *view in self.openingScreen) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x-320, frame.origin.y, frame.size.width, frame.size.height);
        }
        for (UIView *view in self.registerScreen) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(fmodf(frame.origin.x, 320.0f)+320, frame.origin.y, frame.size.width, frame.size.height);
        }
    }];
    self.passField.text = @"";
}

- (void)animateToRegister {
    [UIView animateWithDuration:0.3f animations:^{
        for (UIView *view in self.registerScreen) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x-320, frame.origin.y, frame.size.width, frame.size.height);
        }
        for (UIView *view in self.openingScreen) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x+320, frame.origin.y, frame.size.width, frame.size.height);
        }
    }];
}

- (void)signIn {
    NSLog(@"Sign in");
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
    backgroundView.image = [UIImage imageNamed:@"background"];
    [self.view addSubview: backgroundView];
    
    UIView *shadingView = [[UIView alloc] initWithFrame: self.view.frame];
    shadingView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    [self.view addSubview:shadingView];
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(32.5, 30, 255, 75)];
    titleView.image = [UIImage imageNamed:@"one brown logo"];
    [self.view addSubview:titleView];
}

- (void)configureUsernameAndPassword {
    
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35+320, 120, 250, 20)];
    usernameLabel.font = [UIFont systemFontOfSize:16.0f];
    usernameLabel.textColor = [UIColor whiteColor];
    usernameLabel.text = @"Username";
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(35+320, 194, 250, 20)];
    passwordLabel.font = [UIFont systemFontOfSize:16.0f];
    passwordLabel.textColor = [UIColor whiteColor];
    passwordLabel.text = @"Password";
    
    UITextField *usernameField = [[UITextField alloc] initWithFrame: CGRectMake(35+320, 140, 250, 44)];
    usernameField.font = [UIFont systemFontOfSize:20.0f];
    usernameField.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    usernameField.textColor = [UIColor whiteColor];
    usernameField.borderStyle = UITextBorderStyleRoundedRect;
    usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameField.delegate = self;

    UITextField *passwordField = [[UITextField alloc] initWithFrame: CGRectMake(35+320, 214, 250, 44)];
    passwordField.font = [UIFont systemFontOfSize:20.0f];
    passwordField.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    passwordField.textColor = [UIColor whiteColor];
    passwordField.borderStyle = UITextBorderStyleRoundedRect;
    passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordField.secureTextEntry = YES;
    passwordField.delegate = self;
    
    self.userField = usernameField;
    self.passField = passwordField;
    
    UIButton *signIn = [UIButton buttonWithType:UIButtonTypeCustom];
    signIn.frame = CGRectMake(35+320, 338, 250, 44);
    signIn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8f];
    signIn.titleLabel.textColor = [UIColor whiteColor];
    signIn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    signIn.layer.cornerRadius = 5.0f;
    
    [signIn setTitle:@"Sign In" forState:UIControlStateNormal];
    [signIn addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(35+320, self.view.frame.size.height-64, 250, 44);
    back.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8f];
    back.titleLabel.textColor = [UIColor whiteColor];
    back.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    back.layer.cornerRadius = 5.0f;
    
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(animateToChoice) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *error = [[UILabel alloc] initWithFrame:CGRectMake(35+320, 325, 250, 100)];
    error.lineBreakMode = NSLineBreakByWordWrapping;
    error.numberOfLines = 0;
    error.text = @"We couldn't sign you in. Check your username and password and try again.";
    error.textColor = [UIColor redColor];
    error.font = [UIFont systemFontOfSize:18.0f];
    error.hidden = YES;
    self.loginIssue = error;
    
    UIButton *resetPassword = [UIButton buttonWithType:UIButtonTypeSystem];
    resetPassword.frame = CGRectMake(35+320, 275, 250, 44);
    resetPassword.tintColor = [UIColor whiteColor];
    [resetPassword setTitle:@"Forgot your password?" forState:UIControlStateNormal];
    
    [self.view addSubview:usernameLabel];
    [self.view addSubview:passwordLabel];
    [self.view addSubview:signIn];
    [self.view addSubview:back];
    [self.view addSubview:resetPassword];
    [self.view addSubview:error];
    [self.view addSubview:usernameField];
    [self.view addSubview:passwordField];
    
    [self.view insertSubview:self.overlayView belowSubview:usernameField];
    
    self.loginScreen = @[usernameLabel, passwordLabel, usernameField, passwordField, error, resetPassword, signIn, back];
}

- (void)createNetworkManager {
    
    NetworkManager *nManager = [NetworkManager networkManagerWithHost:(CFStringRef)@"54.200.186.84" port:20000];
    nManager.delegate = self;
    [nManager open];
    
    self.manager = nManager;
}

- (void)configureSignInAndRegister {
    
    UIImageView *loginCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginCircle"]];
    loginCircle.frame = CGRectMake(102.5, 269, 115, 115);
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(121.5, 314, 77, 25);
    loginButton.backgroundColor = [UIColor clearColor];
    
    [loginButton setImage:[UIImage imageNamed:@"loginText"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(animateToLogin) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *registerCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registerCircle"]];
    registerCircle.frame = CGRectMake(102.5, 355, 115, 115);
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(114, 400, 92, 25);
    registerButton.backgroundColor = [UIColor clearColor];
    
    [registerButton setImage:[UIImage imageNamed:@"registerText"] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(animateToRegister) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginCircle];
    [self.view addSubview:loginButton];
    [self.view addSubview:registerCircle];
    [self.view addSubview:registerButton];
    
    self.openingScreen = @[loginCircle, loginButton, registerCircle, registerButton];
}

#pragma mark - UITextFieldDelegate protocol implementation

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.overlayView.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.overlayView.hidden = NO;
}

#pragma mark - NetworkManagerDelegate protocol implementation

-(void)didReceiveJSON:(NSDictionary *)JSON {
    NSLog(@"%@", JSON);
    if ([[JSON objectForKey:@"message"] isEqualToString:@"login_or_register"]) {
        NSLog(@"Login or register");
    }
    else if ([[JSON objectForKey:@"message"] isEqualToString:@"auth_success"]) {
        NSLog(@"auth_success");
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"loggedIn"];
        [(TabController *)[self presentingViewController] setManager: self.manager];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
    else if ([[JSON objectForKey:@"message"] isEqualToString:@"auth_failed"]) {
        NSLog(@"auth_failed");
        self.loginIssue.hidden = NO;
    }
}

- (IBAction)clickedTemporaryButton:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIn"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
