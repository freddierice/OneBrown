//
//  AppDelegate.m
//  OneBrown
//
//  Created by Benjamin Murphy on 1/2/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "AppDelegate.h"
#import "LogInViewController.h"
#import "UserManager.h"

@implementation AppDelegate
{
    NSUserDefaults *defaults;
    UserManager *sharedUserManager;
    id facebookResults;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //[FBLoginView class];
    //[FBProfilePictureView class];

    sharedUserManager = [UserManager sharedUserManager];
    defaults = [NSUserDefaults standardUserDefaults];
    // Create an NSDictionary with the default settings (for the first time the user enters the app)
    NSDictionary *defaultSettings = @{@"sessionID":@""};
    
    // register these defaults and synchronize
    [defaults registerDefaults: defaultSettings];
    [defaults synchronize];
    
    if (![defaults objectForKey:@"loggedIn"])
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_1" bundle: nil];
        LogInViewController *signInViewController = (LogInViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
        
        // Set the root controller to the signInVC so that there is no glimpse of the findVC
        self.window.rootViewController = signInViewController;
    }
    
    /*
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }*/
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}
*/

/*
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}*/

// If we have a valid session at the time of openURL call, we handle Facebook transitions
// by passing the url argument to handleOpenURL; see the "Just Login" sample application for
// a more detailed discussion of handleOpenURL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"In fallback handler");
                    }];
}
/*
// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}
- (void) userLoggedIn
{
    [self showMessage:@"You're now logged in" withTitle:@""];
    [self connectToFacebook];
}

- (void) connectToFacebook
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"user info: %@", result);
            [self handleFacebookResults:result];
            //sharedUserManager.userName = [NSString stringWithFormat:@"%@ %@", [result data], result['last_name']];
            
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
}

- (void) handleFacebookResults: (id) result
{
    NSLog(@"%@",result);
    NSLog(@"%@", [result data]);
    NSLog(@"%@", [result dictionary]);
    NSLog(@"Name:  %@ %@", [[result dictionary] objectForKey:@"name"], [[result dictionary] objectForKey:@"id"]);
    
    facebookResults = result;
}
*/
- (id) facebookInfo
{
    return facebookResults;
}

- (void) userLoggedOut
{
    [self showMessage:@"You're now logged out bitch" withTitle:@""];

    
}

-(void) showMessage: alertText withTitle: alertTitle
{
    [[[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertText
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil]
     show];
    
}

@end
