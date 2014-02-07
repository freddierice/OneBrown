//
//  ProfileViewController.m
//  OneBrown
//
//  Created by Valentin Perez on 1/6/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "ProfileViewController.h"
#import "LogInViewController.h"
#import "CAPopupWindow.h"
#import "UserManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

static NSString *TableViewCellIdentifier = @"SNCells";

@interface ProfileViewController ()
{
    NSUserDefaults *defaults;
    UserManager *sharedUserManager;
    NSMutableArray *addedSocialNetworks;
    AppDelegate* appDelegate;
    int socNetIndex;
    FBProfilePictureView *profilePictureView;
    
}
@end

@implementation ProfileViewController

@synthesize profileImageView, profileNameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    sharedUserManager = [UserManager sharedUserManager];
    
    profileImageView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(self.view.center.x - (profileImageView.frame.size.width / 2),156-profileImageView.frame.size.height/2, 165, 165)];
    
    //profileImageView.frame = CGRectOffset(profileImageView.frame, (self.view.center.x - (profileImageView.frame.size.width / 2)), 5);
    
    [self.view addSubview:profileImageView];
    
    
    _facebookLogInView.delegate = self;
    _facebookLogInView.readPermissions = @[@"basic_info"];
    
    //_getFacebookInfoButton
    profileImageView.layer.cornerRadius = 80;
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.borderWidth = 2;
    //UIColor *brownColor = [UIColor colorWithRed:89 green:38 blue:11 alpha:1];
    profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.addButton addTarget:self action:@selector(addSNButtonPress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.settingsButton addTarget:self action:@selector(gearSettingsPress) forControlEvents:UIControlEventTouchUpInside];
    
    // Setting up the tableView
    [self.networksTableView setDelegate:self];
    [self.networksTableView setDataSource:self];
    
    self.networksTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    self.networksTableView.separatorInset =  UIEdgeInsetsMake(5, 3, 5, 5);
    [self.networksTableView registerClass:[ UITableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    
    
    /* Make sure our table view resizes correctly */
    self.networksTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    addedSocialNetworks = [[NSMutableArray alloc]init];
    
    
   // AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSLog(@"facebook results 1: %@", [appDelegate facebookInfo]);
}

- (void) viewWillAppear:(BOOL)animated
{
    //sharedUserManager.
    //profileImageView.profileID = user.id;
    
    NSLog(@"facebook results 2: %@", [appDelegate facebookInfo]);

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)addSNButtonPress {
    
    CAPopupWindow* popView = [[CAPopupWindow alloc] initWithObjectList:@[
                                                                         [CAWindowObject windowObject:sharedUserManager.socialNetworks[0] image:sharedUserManager.socialNetworkImages[sharedUserManager.socialNetworks[0]] target:self action:@selector(addFacebook)],
                                                                         [CAWindowObject windowObject:sharedUserManager.socialNetworks[1] image:sharedUserManager.socialNetworkImages[sharedUserManager.socialNetworks[1]] target:self action:@selector(addTwitter)],
                                                                         [CAWindowObject windowObject:sharedUserManager.socialNetworks[2] image:sharedUserManager.socialNetworkImages[sharedUserManager.socialNetworks[2]] target:self action:@selector(addInstagram)],
                                                                         [CAWindowObject windowObject:sharedUserManager.socialNetworks[3] image:sharedUserManager.socialNetworkImages[sharedUserManager.socialNetworks[3]] target:self action:@selector(addSnapchat)]]];
    
    
    [popView presentInView:self.view];
    
}

- (void) gearSettingsPress
{
    CAPopupWindow *settingsView = [[CAPopupWindow alloc] initWithObjectList:@[ [CAWindowObject windowObject: @"Log Out" image:nil target:self action:@selector(logOut)]]];
    [settingsView presentInView:self.view];
}

- (void) logOut
{
    [defaults setBool:NO forKey:@"loggedIn"];
    
    LogInViewController *signIn = [[LogInViewController alloc] init];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_1" bundle: nil];
    signIn = [mainStoryboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
    [self presentViewController:signIn animated:YES completion:nil];
}


- (void) addFacebook
{
    NSLog(@"adding facebook");
 //   [self getFacebookSession];
}

- (void) addTwitter
{
    NSLog(@"adding twitt");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter your Twitter username:"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Done", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 1;
    
    [alertView show];
}

- (void) addInstagram
{
    NSLog(@"adding insta");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter your Instagram username:"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Done", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 2;
    
    [alertView show];
    
}

- (void) addSnapchat
{
    NSLog(@"adding snap");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter your Snapchat username:"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Done", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 3;
    
    [alertView show];
    
}

- (void) alertView: (UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *userNameWritten = [alertView textFieldAtIndex:0].text;
    
    // If clicked the Done button.
    if (buttonIndex == 1)
    {
        NSLog(@"in clicked button");
        switch ((int) alertView.tag)
        {
            case 0:
                [sharedUserManager.userNetworks setObject:@"facebookName" forKey:@"Facebook"];
                break;
            case 1:
                [sharedUserManager.userNetworks setObject:userNameWritten forKey:@"Twitter"];
                break;
            case 2:
                [sharedUserManager.userNetworks setObject:userNameWritten forKey:@"Instagram"];
                break;
            case 3:
                [sharedUserManager.userNetworks setObject:userNameWritten forKey:@"Snapchat"];
                break;
            default:
                break;
        }
        
        socNetIndex = (int) alertView.tag;
        
        if ([addedSocialNetworks containsObject:[UserManager socialNetworkForIndex:socNetIndex]])
        {
            int indexToBeChanged = (int)[addedSocialNetworks indexOfObject:[UserManager socialNetworkForIndex:socNetIndex]];
            [addedSocialNetworks setObject:[UserManager socialNetworkForIndex:socNetIndex] atIndexedSubscript:indexToBeChanged];
        }
        else
            [addedSocialNetworks insertObject:[UserManager socialNetworkForIndex:socNetIndex] atIndex:0];
        
        [self.networksTableView reloadData];
        NSLog(@"sn added: %@", sharedUserManager.userNetworks);
        
        NSLog(@"username: %@  tag: %d", userNameWritten, (int)alertView.tag);
    }
    
}

# pragma mark TableView Delegate Methods
- (NSInteger) numberOfSectionsInTableView:( UITableView *) tableView
{
    if ([ tableView isEqual:self.networksTableView] && [defaults objectForKey:@"loggedIn"])
    {
        return 1;
    }
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([tableView isEqual:self.networksTableView] && [defaults objectForKey:@"loggedIn"])
    {
        if ([sharedUserManager.userNetworks count]!=0)
            return [sharedUserManager.userNetworks  count];
        
        NSLog(@"sn for rows: %@", sharedUserManager.userNetworks);
    }
    
    return 0;
}

- (UITableViewCell *) tableView:( UITableView *) tableView cellForRowAtIndexPath:( NSIndexPath *) indexPath
{
    UITableViewCell *cell = nil;
    if ([tableView isEqual:self.networksTableView] && [defaults objectForKey:@"loggedIn"])
    {
        
        
        cell = [tableView dequeueReusableCellWithIdentifier: TableViewCellIdentifier forIndexPath:indexPath];
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        NSString *socialNetwork = [[NSString alloc]init];
        // socialNetwork = [UserManager socialNetworkForIndex: [sharedUserManager.socialNetworks objectAtIndex:0]];
        
        socialNetwork = addedSocialNetworks[indexPath.row];
        
        cell.imageView.image = sharedUserManager.socialNetworkImages[socialNetwork];
        cell.textLabel.text = sharedUserManager.userNetworks[socialNetwork];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        /*
         UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
         [button setImage:[UIImage imageNamed:@"IconProfile"] forState:UIControlStateNormal];
         [button addTarget:self action:@selector(tappedButton) forControlEvents:UIControlEventTouchUpInside];
         button.tag = indexPath.row;
         cell.accessoryView = button;
         */
        [cell.textLabel setFont: [UIFont fontWithName:@"Helvetica" size:12]];
        [cell.textLabel setTextColor: [UIColor whiteColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        
        
        
    }
    return cell;
}

/*
 * This is just to hide the separators of the empty cells.
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (IBAction)clickedLogOut:(id)sender
{
    [defaults setBool:NO forKey:@"loggedIn"];
    
    LogInViewController *signIn = [[LogInViewController alloc] init];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_1" bundle: nil];
    signIn = [mainStoryboard instantiateViewControllerWithIdentifier:@"InitialViewController"];
    [self presentViewController:signIn animated:YES completion:nil];
    
}

/*
- (void)getFacebookSession
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
            // AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
        NSLog(@"got into Facebook bitch");
        NSLog(@"facebook results 3: %@", [appDelegate facebookInfo]);

        
    }
}*/

#pragma mark facebookLogInView Delegate Methods
// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"user day quon: %@", user);
    NSLog(@"user id %@", [user objectForKey:@"id"]);
   profileImageView.profileID = user.id;
   profileNameLabel.text = user.name;
}

// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog (@"You're logged in as shit");
}
// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    //self.profileImageView.profileID = nil;
    //self.profileNameLabel.text = @"";
    NSLog(@"You're not logged in!");
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

                                                                                                                                                              
@end


