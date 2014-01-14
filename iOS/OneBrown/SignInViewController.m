//
//  SignInViewController.m
//  OneBrown
//
//  Created by Benjamin Murphy on 1/2/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "SignInViewController.h"
#import "LoginLogic.h"
#import "ResizedTextField.h"
#import "FindViewController.h"
#import <Foundation/Foundation.h>

@interface SignInViewController ()

@property (nonatomic, weak) UITextField *userField;
@property (nonatomic, weak) UITextField *passField;

@property (nonatomic, weak) UITextField *enterPassword;
@property (nonatomic, weak) UITextField *confirmPassword;
@property (nonatomic, weak) UITextField *enterEmail;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *registrationButton;
@property (nonatomic, weak) UIActivityIndicatorView *rActivity;
@property (nonatomic, weak) UILabel *registrationError;
@property (nonatomic, weak) UITextField *codeField;
@property (nonatomic, weak) UIButton *enterCode;
@property (nonatomic, weak) UILabel *codeError;
@property (nonatomic, weak) UIButton *resend;
@property (nonatomic, weak) UIActivityIndicatorView *vActivity;

@property (nonatomic, weak) UILabel *userExistsError;

@property (nonatomic, weak) UIView *tintView;

@property (nonatomic, weak) UILabel *vError;

@property (nonatomic, weak) UIActivityIndicatorView *activity;
@property (nonatomic, weak) UIButton *signInButton;

@end

@implementation SignInViewController

@synthesize manager, userField, passField, overlayView, openingScreen, loginScreen, registerScreen, tintView, activity, signInButton, enterEmail, enterPassword, confirmPassword, scrollView, registrationButton, rActivity, registrationError, verifyScreen, codeField, codeError, enterCode, resend, vActivity, userExistsError, userManager;

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
    [self configureVerifyEmail];
    [self createNetworkManager];
    // Brings the temporaryButton to the front so that it can be clicked.
    //[self.view bringSubviewToFront:_temporaryButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)overlayViewActivated {
    [self.userField resignFirstResponder];
    [self.passField resignFirstResponder];
    [self.enterEmail resignFirstResponder];
    [self.enterPassword resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
    [self.codeField resignFirstResponder];
}

- (void)segueToWelcome {
    
    //Testing purposes
    
    [self performSegueWithIdentifier:@"goWelcome" sender:self];
    
}

#pragma mark - animation implementation

- (void)animateToVerify {
    
    [self.overlayView removeFromSuperview];
    [self.view insertSubview:self.overlayView belowSubview:self.codeField];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        [self.overlayView removeFromSuperview];
        [self.view insertSubview:self.overlayView belowSubview:self.codeField];
        
        for (UIView *view in self.verifyScreen) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x-320, frame.origin.y, frame.size.width, frame.size.height);
        }
        for (UIView *view in self.registerScreen) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x-320, frame.origin.y, frame.size.width, frame.size.height);
        }
    }];
    
}

- (void)animateToLogin {
    
    [self.overlayView removeFromSuperview];
    [self.view insertSubview:self.overlayView belowSubview:self.userField];
    
    [UIView animateWithDuration:0.3f animations:^{
        for (UIView *view in self.loginScreen) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x-320, frame.origin.y, frame.size.width, frame.size.height);
        }
        for (UIView *view in self.openingScreen) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x-320, frame.origin.y, frame.size.width, frame.size.height);
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
            view.frame = CGRectMake(frame.origin.x+320, frame.origin.y, frame.size.width, frame.size.height);
        }
        for (UIView *view in self.registerScreen) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(fmodf(frame.origin.x, 320.0f)+320, frame.origin.y, frame.size.width, frame.size.height);
        }
    }];
    self.passField.text = @"";
    self.enterPassword.text = @"";
    self.confirmPassword.text = @"";
}

- (void)animateToRegister {
    
    [self.overlayView removeFromSuperview];
    [self.view insertSubview:self.overlayView belowSubview:self.scrollView];
    
    [UIView animateWithDuration:0.3f animations:^{
        for (UIView *view in self.registerScreen) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x-320, frame.origin.y, frame.size.width, frame.size.height);
        }
        for (UIView *view in self.openingScreen) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x-320, frame.origin.y, frame.size.width, frame.size.height);
        }
    }];
}

#pragma mark - server communications

- (void)signIn {
    NSLog(@"Sign in");
    self.userField.backgroundColor = [UIColor colorWithWhite:0.4f alpha:0.9f];
    self.passField.backgroundColor = [UIColor colorWithWhite:0.4f alpha:0.9f];
    self.signInButton.enabled = NO;
    [self.signInButton setTitle:@"" forState:UIControlStateNormal];
    [self.activity startAnimating];
    
    NSError *e;
    NSData *loginRequest = [NSJSONSerialization dataWithJSONObject:@{@"message":@"login"} options:kNilOptions error:&e];
    NSDictionary *loginInformation = @{@"user":self.userField.text, @"pass":self.passField.text};
    NSData* information = [NSJSONSerialization dataWithJSONObject:loginInformation options:kNilOptions error:&e];

    if (e) {
        NSLog(@"%@", e);
    }
    
    BOOL success = [self.manager writeData:loginRequest];
    if (success) {
        [self.manager writeData:information];
    }
    else {
        NSLog(@"Error writing to server.");
    }
}

- (void)submitCode {
    NSLog(@"Submit Code");
    
    CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 2.0f ;
    anim.duration = 0.07f ;
    
    if (self.codeField.text.length < 6) {
        [self.codeField.layer addAnimation:anim forKey:NULL];
        return;
    }
    
    self.codeField.backgroundColor = [UIColor colorWithWhite:0.4f alpha:0.9f];
    self.enterCode.enabled = NO;
    [self.enterCode setTitle:@"" forState:UIControlStateNormal];
    [self.vActivity startAnimating];
    
    /*
     Test code
    */
    
    if ([self.codeField.text isEqualToString:@"123456"]) {
        [self didReceiveJSON:@{@"message":@"verify_success"}];
    }
    else {
        [self didReceiveJSON:@{@"message":@"verify_failed"}];
    }
}

- (void)resendCode {
    
}

- (void)registerUser {
    NSLog(@"Register");
    
    CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 2.0f ;
    anim.duration = 0.07f ;
    
    BOOL didFail = NO;
    
    if (![self.confirmPassword.text isEqualToString: self.enterPassword.text] || self.enterPassword.text.length == 0 || ![LoginLogic validatePassword:self.enterPassword.text]) {
        [self.confirmPassword.layer addAnimation:anim forKey:NULL];
        [self.enterPassword.layer addAnimation:anim forKey:NULL];
        didFail = YES;
    }
    if (self.enterEmail.text.length == 0 || ![LoginLogic validateEmail:self.enterEmail.text]) {
        [self.enterEmail.layer addAnimation:anim forKey:NULL];
        didFail = YES;
    }
    
    if (didFail) {return;}
    
    self.enterPassword.backgroundColor = [UIColor colorWithWhite:0.4f alpha:0.9f];
    self.enterEmail.backgroundColor = [UIColor colorWithWhite:0.4f alpha:0.9f];
    self.confirmPassword.backgroundColor = [UIColor colorWithWhite:0.4f alpha:0.9f];
    self.registrationButton.enabled = NO;
    [self.registrationButton setTitle:@"" forState:UIControlStateNormal];
    [self.rActivity startAnimating];
    
    NSError *e;
    NSData *registerRequest = [NSJSONSerialization dataWithJSONObject:@{@"message":@"register"} options:kNilOptions error:&e];
    NSDictionary *registerInformation = @{@"user":self.enterEmail.text, @"pass":self.enterPassword.text};
    NSData* information = [NSJSONSerialization dataWithJSONObject:registerInformation options:kNilOptions error:&e];
    
    if (e) {
        NSLog(@"%@", e);
    }
    
    BOOL success = [self.manager writeData:registerRequest];
    if (success) {
        [self.manager writeData:information];
    }
    else {
        NSLog(@"Error writing to server.");
    }

}

#pragma mark - configuration

- (void)configureRegistration {
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0+320, 140, 320, 113)];
    scroll.contentSize = CGSizeMake(320, 113);
    self.scrollView = scroll;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayViewActivated)];
    recognizer.numberOfTapsRequired = 1;
    recognizer.numberOfTouchesRequired = 1;
    [scroll addGestureRecognizer:recognizer];
    
    ResizedTextField *emailField = [[ResizedTextField alloc] initWithFrame: CGRectMake(35, 0, 250, 31)];
    emailField.font = [UIFont systemFontOfSize:16.0f];
    emailField.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.9f];
    emailField.borderStyle = UITextBorderStyleRoundedRect;
    emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    emailField.placeholder = @"Email";
    emailField.layer.cornerRadius = 5.0f;
    emailField.delegate = self;
    self.enterEmail = emailField;
    
    UILabel *brown = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 100, 31)];
    brown.textColor = [UIColor blackColor];
    [brown setText:@"@brown.edu"];
    
    UITextField *password = [[UITextField alloc] initWithFrame: CGRectMake(35, 41, 250, 31)];
    password.font = [UIFont systemFontOfSize:16.0f];
    password.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.9f];
    password.borderStyle = UITextBorderStyleRoundedRect;
    password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    password.autocorrectionType = UITextAutocorrectionTypeNo;
    password.placeholder = @"Password";
    password.secureTextEntry = YES;
    password.layer.cornerRadius = 5.0f;
    password.delegate = self;
    self.enterPassword = password;
    
    UITextField *confirm = [[UITextField alloc] initWithFrame: CGRectMake(35, 82, 250, 31)];
    confirm.font = [UIFont systemFontOfSize:16.0f];
    confirm.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.9f];
    confirm.borderStyle = UITextBorderStyleRoundedRect;
    confirm.autocapitalizationType = UITextAutocapitalizationTypeNone;
    confirm.autocorrectionType = UITextAutocorrectionTypeNo;
    confirm.placeholder = @"Confirm Password";
    confirm.secureTextEntry = YES;
    confirm.layer.cornerRadius = 5.0f;
    confirm.delegate = self;
    self.confirmPassword = confirm;
    
    UIActivityIndicatorView *registerActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(141.5+320, 274.5, 21, 21)];
    registerActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [registerActivity setHidesWhenStopped:YES];
    self.rActivity = registerActivity;
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(35+320, 263, 250, 44);
    registerButton.backgroundColor = [UIColor colorWithRed:211.0f/255.0f green:71.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
    registerButton.titleLabel.textColor = [UIColor blackColor];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    registerButton.layer.cornerRadius = 5.0f;
    [registerButton setTitle:@"Register" forState:UIControlStateNormal];
    self.registrationButton = registerButton;
    
    [registerButton addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    
 //   [registerButton addTarget:self action:@selector(segueToValidate) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *agreement = [[UILabel alloc] initWithFrame:CGRectMake(74+320, self.view.frame.size.height-64, 211, 44)];
    agreement.text = @"By continuing, you are indicating that you have read and agree to the Terms of Service and Privacy Policy.";
    agreement.lineBreakMode = NSLineBreakByWordWrapping;
    agreement.font = [UIFont systemFontOfSize:12.0f];
    agreement.textAlignment = NSTextAlignmentCenter;
    agreement.textColor = [UIColor whiteColor];
    agreement.numberOfLines = 0;
    agreement.layer.cornerRadius = 5.0f;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(20+320, self.view.frame.size.height-64, 44, 44);
    [back setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(animateToChoice) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *error = [[UILabel alloc] initWithFrame:CGRectMake(35+320, 361, 250, 44)];
    error.text = @"We were unable to register you at this time. Please try again later.";
    error.lineBreakMode = NSLineBreakByWordWrapping;
    error.textAlignment = NSTextAlignmentCenter;
    error.textColor = [UIColor colorWithRed:211.0f/255.0f green:71.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
    error.numberOfLines = 0;
    error.hidden = YES;
    self.registrationError = error;
    
    UILabel *exists = [[UILabel alloc] initWithFrame:CGRectMake(35+320, 361, 250, 44)];
    exists.text = [NSString stringWithFormat:@"%@@brown.edu has already been registered with oneBrown. Do you need help signing in?", self.enterEmail.text];
    exists.lineBreakMode = NSLineBreakByWordWrapping;
    exists.textAlignment = NSTextAlignmentCenter;
    exists.textColor = [UIColor colorWithRed:211.0f/255.0f green:71.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
    exists.numberOfLines = 0;
    exists.hidden = YES;
    self.userExistsError = error;
    
    [self.view addSubview:scroll];
    [self.view addSubview:agreement];
    [self.view addSubview:back];
    [self.view addSubview:registerButton];
    [self.view addSubview:registerActivity];
    [self.view addSubview:error];
    [self.view addSubview:exists];
    [scroll addSubview:confirm];
    [scroll addSubview:password];
    [scroll addSubview:emailField];
    [scroll addSubview:brown];
    
    self.registerScreen = @[scroll, agreement, back, registerButton, registerActivity, error, exists];
}

- (void)configureBackground {
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame: self.view.frame];
    backgroundView.image = [UIImage imageNamed:@"background"];
    [self.view addSubview: backgroundView];
    
    UIView *shadingView = [[UIView alloc] initWithFrame: self.view.frame];
    shadingView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    [self.view addSubview:shadingView];
    
    self.tintView = shadingView;
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(32.5, 30, 255, 75)];
    titleView.image = [UIImage imageNamed:@"one brown logo"];
    [self.view addSubview:titleView];
}

- (void)configureVerifyEmail {
    
    UILabel *informationLabel = [[UILabel alloc] initWithFrame: CGRectMake(35+320, 140, 250, 44)];
    informationLabel.text = @"Enter the six-digit verification code we just emailed you:";
    informationLabel.textAlignment = NSTextAlignmentCenter;
    informationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    informationLabel.numberOfLines = 0;
    informationLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    informationLabel.textColor = [UIColor whiteColor];
    informationLabel.layer.cornerRadius = 5.0f;
    
    UITextField *code = [[UITextField alloc] initWithFrame: CGRectMake(35+320, 190, 250, 44)];
    code.font = [UIFont boldSystemFontOfSize:25.0f];
    code.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.9f];
    code.borderStyle = UITextBorderStyleRoundedRect;
    code.autocapitalizationType = UITextAutocapitalizationTypeNone;
    code.autocorrectionType = UITextAutocorrectionTypeNo;
    code.layer.cornerRadius = 5.0f;
    code.keyboardType = UIKeyboardTypeNumberPad;
    code.textAlignment = NSTextAlignmentCenter;
    code.delegate = self;
    self.codeField = code;
    
    UIButton *submitCode = [UIButton buttonWithType:UIButtonTypeCustom];
    submitCode.frame = CGRectMake(35+320, 242, 250, 44);
    submitCode.backgroundColor = [UIColor colorWithRed:211.0f/255.0f green:71.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
    submitCode.titleLabel.textColor = [UIColor blackColor];
    submitCode.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    submitCode.layer.cornerRadius = 5.0f;
    [submitCode setTitle:@"Submit" forState:UIControlStateNormal];
    self.enterCode = submitCode;
    
    [submitCode addTarget:self action:@selector(segueToWelcome) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *resendCode = [[UILabel alloc] initWithFrame:CGRectMake(85+320, 295, 150, 75)];
    resendCode.text = @"Can't find the code? It may take a few minutes to arrive. You can also resend it:";
    resendCode.lineBreakMode = NSLineBreakByWordWrapping;
    resendCode.numberOfLines = 0;
    resendCode.textAlignment = NSTextAlignmentCenter;
    resendCode.textColor = [UIColor whiteColor];
    
    UIButton *resendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    resendButton.frame = CGRectMake(35+320, 380, 250, 44);
    resendButton.backgroundColor = [UIColor colorWithRed:211.0f/255.0f green:71.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
    resendButton.titleLabel.textColor = [UIColor blackColor];
    resendButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    resendButton.layer.cornerRadius = 5.0f;
    [resendButton setTitle:@"Resend" forState:UIControlStateNormal];
    self.resend = submitCode;
    
    UILabel *error = [[UILabel alloc] initWithFrame: CGRectMake(35+320, 430, 320, 44)];
    error.text = @"We couldn't verify you.";
    error.hidden = YES;
    self.vError = error;
    
    UIActivityIndicatorView *verifyIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(141.5+320, 253.5, 21, 21)];
    verifyIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [verifyIndicator setHidesWhenStopped:YES];
    self.vActivity = verifyIndicator;
    
    [self.view addSubview:error];
    [self.view addSubview:informationLabel];
    [self.view addSubview:code];
    [self.view addSubview:submitCode];
    [self.view addSubview:resendCode];
    [self.view addSubview:resendButton];
    [self.view addSubview:verifyIndicator];
    
    self.verifyScreen = @[informationLabel, code, submitCode, resendCode, resendButton, error, verifyIndicator];
}

- (void)configureUsernameAndPassword {
    
    UITextField *usernameField = [[UITextField alloc] initWithFrame: CGRectMake(35+320, 140, 250, 44)];
    usernameField.font = [UIFont systemFontOfSize:20.0f];
    usernameField.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.9f];
    usernameField.borderStyle = UITextBorderStyleRoundedRect;
    usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameField.placeholder = @"Email";
    usernameField.layer.cornerRadius = 5.0f;
    usernameField.delegate = self;

    UITextField *passwordField = [[UITextField alloc] initWithFrame: CGRectMake(35+320, 214, 250, 44)];
    passwordField.font = [UIFont systemFontOfSize:20.0f];
    passwordField.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.9f];
    passwordField.borderStyle = UITextBorderStyleRoundedRect;
    passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordField.placeholder = @"Password";
    passwordField.secureTextEntry = YES;
    passwordField.layer.cornerRadius = 5.0f;
    passwordField.delegate = self;
    
    self.userField = usernameField;
    self.passField = passwordField;
    
    UIButton *signIn = [UIButton buttonWithType:UIButtonTypeCustom];
    signIn.frame = CGRectMake(35+320, 302, 250, 44);
    signIn.backgroundColor = [UIColor colorWithRed:211.0f/255.0f green:71.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
    signIn.titleLabel.textColor = [UIColor blackColor];
    signIn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    signIn.layer.cornerRadius = 5.0f;
    self.signInButton = signIn;
    
    [signIn setTitle:@"Sign In" forState:UIControlStateNormal];
    [signIn addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(20+320, self.view.frame.size.height-64, 44, 44);
    [back setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(animateToChoice) forControlEvents:UIControlEventTouchUpInside];

    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(141.5+320, 313.5, 21, 21)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [activityIndicator setHidesWhenStopped:YES];
    self.activity = activityIndicator;
    
    UIButton *resetPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    resetPassword.frame = CGRectMake(72.5+320, 265, 175, 30);
    resetPassword.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    resetPassword.titleLabel.textColor = [UIColor whiteColor];
    [resetPassword setTitle:@"Need Help?" forState:UIControlStateNormal];
    
    [self.view addSubview:signIn];
    [self.view addSubview:back];
    [self.view addSubview:activityIndicator];
    [self.view addSubview:resetPassword];
    [self.view addSubview:usernameField];
    [self.view addSubview:passwordField];
    
    self.loginScreen = @[usernameField, passwordField, activityIndicator, resetPassword, signIn, back];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.codeField) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 6) ? NO : YES;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.overlayView.hidden = YES;
    
    if (textField == self.enterPassword || textField == self.confirmPassword) {
        
        if (![self.confirmPassword.text isEqualToString: self.enterPassword.text] && self.confirmPassword.text.length > 0 && self.enterPassword.text.length > 0) {
         
            self.enterPassword.textColor = [UIColor colorWithRed:211.0f/255.0f green:71.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
            self.confirmPassword.textColor = [UIColor colorWithRed:211.0f/255.0f green:71.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
        }
        else {
            self.enterPassword.textColor = [UIColor blackColor];
            self.confirmPassword.textColor = [UIColor blackColor];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.userField || textField == self.passField) {
        self.userField.textColor = [UIColor blackColor];
        self.passField.textColor = [UIColor blackColor];
    }
    else if (textField == self.enterEmail || textField == self.enterPassword || textField == self.confirmPassword) {
        [self.scrollView setFrame:CGRectMake(0, 140, 320, self.view.frame.size.height-140-216)];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.overlayView.hidden = NO;
}

#pragma mark - NetworkManagerDelegate protocol implementation

-(void)didReceiveJSON:(NSDictionary *)JSON {
    NSLog(@"%@", JSON);
    if ([[JSON objectForKey:@"message"] isEqualToString:@"auth_success"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"loggedIn"];
        [[NSUserDefaults standardUserDefaults] setObject:[JSON objectForKey:@"session"] forKey:@"sessionID"];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
    else if ([[JSON objectForKey:@"message"] isEqualToString:@"auth_failed"]) {
        self.userField.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.passField.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.signInButton.enabled = YES;
        [self.signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
        [self.activity stopAnimating];

        CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
        anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
        anim.autoreverses = YES ;
        anim.repeatCount = 2.0f ;
        anim.duration = 0.07f ;
        
        [self.userField.layer addAnimation:anim forKey:nil];
        [self.passField.layer addAnimation:anim forKey:nil];
        
        self.userField.textColor = [UIColor colorWithRed:211.0f/255.0f green:71.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
        self.passField.textColor = [UIColor colorWithRed:211.0f/255.0f green:71.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
    }
    else if ([[JSON objectForKey:@"message"] isEqualToString:@"reg_success"]) {
        
        [self animateToVerify];
        
    }
    else if ([[JSON objectForKey:@"message"] isEqualToString:@"reg_failed"]) {
        self.enterPassword.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.enterEmail.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.confirmPassword.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.registrationButton.enabled = YES;
        [self.registrationButton setTitle:@"Register" forState:UIControlStateNormal];
        [self.rActivity stopAnimating];
        
        self.registrationError.hidden = NO;
        self.userExistsError.hidden = YES;
    }
    
    else if ([[JSON objectForKey:@"message"] isEqualToString:@"reg_exists"]) {
        self.enterPassword.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.enterEmail.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.confirmPassword.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.registrationButton.enabled = YES;
        [self.registrationButton setTitle:@"Register" forState:UIControlStateNormal];
        [self.rActivity stopAnimating];
        
        self.registrationError.hidden = YES;
        self.userExistsError.hidden = NO;
    }
    
    else if ([[JSON objectForKey:@"message"] isEqualToString:@"verify_success"]) {
        
        NSLog(@"Verification succeeded! Now the code actually should do something.");
        [self performSegueWithIdentifier:@"goWelcome" sender:self];
        
    }
    
    else if ([[JSON objectForKey:@"message"] isEqualToString:@"verify_failed"]) {
        
        self.codeField.backgroundColor = [UIColor colorWithWhite:0.4f alpha:0.9f];
        self.enterCode.enabled = NO;
        [self.enterCode setTitle:@"" forState:UIControlStateNormal];
        [self.vActivity startAnimating];
        self.vError.hidden = NO;
    }
}

- (IBAction)clickedTemporaryButton:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIn"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
