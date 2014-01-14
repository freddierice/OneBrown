//
//  LogInViewController.m
//  OneBrown
//
//  Created by Benjamin Murphy on 1/13/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "LogInViewController.h"
#import "LoginLogic.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

@synthesize logInOrRegister, logIn, registration, code;
@synthesize networkManager, userManager;

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        self.logInOrRegister = [NSMutableArray array];
        self.logIn = [NSMutableArray array];
        self.registration = [NSMutableArray array];
        self.code = [NSMutableArray array];

        
        self.passwordField.frame = CGRectMake(self.passwordField.frame.origin.x, self.passwordField.frame.origin.y, self.passwordField.frame.size.width, 44);
        
        self.usernameField.frame = CGRectMake(self.usernameField.frame.origin.x, self.usernameField.frame.origin.y, self.usernameField.frame.size.width, 44);
        
        for (NSInteger i = 1; i < 7; i++) {
            [self.logIn addObject:[self.view viewWithTag:i]];
        }
        
        for (NSInteger i = 6; i < 13; i++) {
            [self.registration addObject:[self.view viewWithTag:i]];
        }
        
        for (NSInteger i = 13; i < 20; i++) {
            [self.code addObject:[self.view viewWithTag:i]];
        }
        
        for (NSInteger i = 20; i < 24; i++) {
            [self.logInOrRegister addObject:[self.view viewWithTag:i]];
        }
        
    }
    
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createNetworkManager {
    
    NetworkManager *nManager = [NetworkManager networkManagerWithHost:(CFStringRef)@"54.200.186.84" port:20000];
    nManager.delegate = self;
    [nManager open];
    
    self.networkManager = nManager;
}

#pragma mark - screen animation

-(void)switchToLogin:(id)sender {
    
    [UIView animateWithDuration:0.3f animations:^{
        for (UIView *view in self.logIn) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x-320, frame.origin.y, frame.size.width, frame.size.height);
        }
        for (UIView *view in self.logInOrRegister) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x-320, frame.origin.y, frame.size.width, frame.size.height);
        }
    }];
    
}

-(void)switchToLoginOrRegister:(id)sender {
    
    [UIView animateWithDuration:0.3f animations:^{
        
        for (UIView *view in self.logIn) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(fmodf(frame.origin.x, 320.0f)+320, frame.origin.y, frame.size.width, frame.size.height);
        }
        for (UIView *view in self.logInOrRegister) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x+320, frame.origin.y, frame.size.width, frame.size.height);
        }
        for (UIView *view in self.registration) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(fmodf(frame.origin.x, 320.0f)+320, frame.origin.y, frame.size.width, frame.size.height);
        }
    }];
    self.passwordField.text = @"";
    self.enterPassword.text = @"";
    self.verifyPassword.text = @"";
    
}

-(void)switchToRegister:(id)sender {
    
    [UIView animateWithDuration:0.3f animations:^{
        
        for (UIView *view in self.registration) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x-320, frame.origin.y, frame.size.width, frame.size.height);
        }
        for (UIView *view in self.logInOrRegister) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x-320, frame.origin.y, frame.size.width, frame.size.height);
        }
    }];
    
}

-(void)switchToVerify {
    
    [UIView animateWithDuration:0.3f animations:^{
        
        for (UIView *view in self.code) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x-320, frame.origin.y, frame.size.width, frame.size.height);
        }
        for (UIView *view in self.registration) {
            CGRect frame = view.frame;
            view.frame = CGRectMake(frame.origin.x-320, frame.origin.y, frame.size.width, frame.size.height);
        }
    }];
    
}

#pragma mark - networking

-(void)signIn:(id)sender {
    
    self.usernameField.backgroundColor = [UIColor colorWithWhite:0.4f alpha:0.9f];
    self.passwordField.backgroundColor = [UIColor colorWithWhite:0.4f alpha:0.9f];
    self.signInButton.enabled = NO;
    [self.signInButton setTitle:@"" forState:UIControlStateNormal];
    [self.loginActivity startAnimating];
    
    NSError *e;
    NSData *loginRequest = [NSJSONSerialization dataWithJSONObject:@{@"message":@"login"} options:kNilOptions error:&e];
    NSDictionary *loginInformation = @{@"user":self.usernameField.text, @"pass":self.passwordField.text};
    NSData* information = [NSJSONSerialization dataWithJSONObject:loginInformation options:kNilOptions error:&e];
    
    if (e) {
        NSLog(@"%@", e);
    }
    
    BOOL success = [self.networkManager writeData:loginRequest];
    if (success) {
        [self.networkManager writeData:information];
    }
    else {
        NSLog(@"Error writing to server.");
    }
    
}

-(void)submitCode:(id)sender {
    
    CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 2.0f ;
    anim.duration = 0.07f ;
    
    if (self.enterCode.text.length < 6) {
        [self.enterCode.layer addAnimation:anim forKey:NULL];
        return;
    }
    
    self.enterCode.backgroundColor = [UIColor colorWithWhite:0.4f alpha:0.9f];
    self.submitCodeButton.enabled = NO;
    [self.submitCodeButton setTitle:@"" forState:UIControlStateNormal];
    [self.verifyActivity startAnimating];
    
    /*
     Test code
     */
    
    if ([self.enterCode.text isEqualToString:@"123456"]) {
        [self didReceiveJSON:@{@"message":@"verify_success"}];
    }
    else {
        [self didReceiveJSON:@{@"message":@"verify_failed"}];
    }
    
}

-(void)registerUser:(id)sender {
    
    CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 2.0f ;
    anim.duration = 0.07f ;
    
    BOOL didFail = NO;
    
    if (![self.verifyPassword.text isEqualToString: self.enterPassword.text] || self.enterPassword.text.length == 0 || ![LoginLogic validatePassword:self.enterPassword.text]) {
        [self.verifyPassword.layer addAnimation:anim forKey:NULL];
        [self.enterPassword.layer addAnimation:anim forKey:NULL];
        didFail = YES;
    }
    if (self.enterUsername.text.length == 0 || ![LoginLogic validateEmail:self.enterUsername.text]) {
        [self.enterUsername.layer addAnimation:anim forKey:NULL];
        didFail = YES;
    }
    
    if (didFail) {return;}
    
    self.enterPassword.backgroundColor = [UIColor colorWithWhite:0.4f alpha:0.9f];
    self.enterUsername.backgroundColor = [UIColor colorWithWhite:0.4f alpha:0.9f];
    self.verifyPassword.backgroundColor = [UIColor colorWithWhite:0.4f alpha:0.9f];
    self.registerButton.enabled = NO;
    [self.registerButton setTitle:@"" forState:UIControlStateNormal];
    [self.registerActivity startAnimating];
    
    NSError *e;
    NSData *registerRequest = [NSJSONSerialization dataWithJSONObject:@{@"message":@"register"} options:kNilOptions error:&e];
    NSDictionary *registerInformation = @{@"user":self.enterUsername.text, @"pass":self.enterPassword.text};
    NSData* information = [NSJSONSerialization dataWithJSONObject:registerInformation options:kNilOptions error:&e];
    
    if (e) {
        NSLog(@"%@", e);
    }
    
    BOOL success = [self.networkManager writeData:registerRequest];
    if (success) {
        [self.networkManager writeData:information];
    }
    else {
        NSLog(@"Error writing to server.");
    }
    
}

-(void)resendCode:(id)sender {
    
}

#pragma mark - UITextFieldDelegate protocol implementation

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.enterCode) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 6) ? NO : YES;
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.usernameField || textField == self.passwordField) {
        self.usernameField.textColor = [UIColor blackColor];
        self.passwordField.textColor = [UIColor blackColor];
    }
    else if (textField == self.enterUsername || textField == self.enterPassword || textField == self.verifyPassword) {
        [self.scrollView setFrame:CGRectMake(0, 140, 320, self.view.frame.size.height-140-216)];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.enterPassword || textField == self.verifyPassword) {
        
        if (![self.verifyPassword.text isEqualToString: self.enterPassword.text] && self.verifyPassword.text.length > 0 && self.enterPassword.text.length > 0) {
            
            self.enterPassword.textColor = [UIColor colorWithRed:211.0f/255.0f green:71.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
            self.verifyPassword.textColor = [UIColor colorWithRed:211.0f/255.0f green:71.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
        }
        else {
            self.enterPassword.textColor = [UIColor blackColor];
            self.verifyPassword.textColor = [UIColor blackColor];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - NetworkManagerDelegate protocol implementation

-(void)didReceiveJSON:(NSDictionary *)JSON {
    
    if ([[JSON objectForKey:@"message"] isEqualToString:@"auth_success"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"loggedIn"];
        [[NSUserDefaults standardUserDefaults] setObject:[JSON objectForKey:@"session"] forKey:@"sessionID"];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
    else if ([[JSON objectForKey:@"message"] isEqualToString:@"auth_failed"]) {
        self.usernameField.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.passwordField.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.signInButton.enabled = YES;
        [self.signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
        [self.loginActivity stopAnimating];
        
        CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
        anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
        anim.autoreverses = YES ;
        anim.repeatCount = 2.0f ;
        anim.duration = 0.07f ;
        
        [self.usernameField.layer addAnimation:anim forKey:nil];
        [self.passwordField.layer addAnimation:anim forKey:nil];
        
        self.usernameField.textColor = [UIColor colorWithRed:211.0f/255.0f green:71.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
        self.passwordField.textColor = [UIColor colorWithRed:211.0f/255.0f green:71.0f/255.0f blue:42.0f/255.0f alpha:1.0f];
    }
    else if ([[JSON objectForKey:@"message"] isEqualToString:@"reg_success"]) {
        
        [self switchToVerify];
        
    }
    else if ([[JSON objectForKey:@"message"] isEqualToString:@"reg_failed"]) {
        self.enterPassword.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.enterUsername.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.verifyPassword.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.registerButton.enabled = YES;
        [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
        [self.registerActivity stopAnimating];
        
        self.errorRegistering.hidden = NO;
        self.alreadyRegistered.hidden = YES;
    }
    
    else if ([[JSON objectForKey:@"message"] isEqualToString:@"reg_exists"]) {
        self.enterPassword.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.enterUsername.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.verifyPassword.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.registerButton.enabled = YES;
        [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
        [self.registerActivity stopAnimating];
        
        self.errorRegistering.hidden = YES;
        self.alreadyRegistered.hidden = NO;
    }
    
    else if ([[JSON objectForKey:@"message"] isEqualToString:@"verify_success"]) {
        
        NSLog(@"Verification succeeded! Now the code actually should do something.");
        [self performSegueWithIdentifier:@"goWelcome" sender:self];
        
    }
    
    else if ([[JSON objectForKey:@"message"] isEqualToString:@"verify_failed"]) {
        
        self.enterCode.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        self.submitCodeButton.enabled = YES;
        [self.submitCodeButton setTitle:@"Submit" forState:UIControlStateNormal];
        [self.verifyActivity stopAnimating];
        self.errorVerifying.hidden = NO;
    }
    
}


@end
