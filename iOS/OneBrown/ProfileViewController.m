//
//  ProfileViewController.m
//  OneBrown
//
//  Created by Valentin Perez on 1/6/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "ProfileViewController.h"
#import "SignInViewController.h"
#import "CAPopupWindow.h"
#import "UserManager.h"

static NSString *TableViewCellIdentifier = @"SNCells";

@interface ProfileViewController ()
{
    NSUserDefaults *defaults;
    UserManager *sharedUserManager;
    NSMutableArray *addedSocialNetworks;
    int socNetIndex;
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
    
    profileImageView.layer.cornerRadius = 80;
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.borderWidth = 2;
    //UIColor *brownColor = [UIColor colorWithRed:89 green:38 blue:11 alpha:1];
    profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.addButton addTarget:self action:@selector(buttonPress) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Setting up the tableView
    [self.networksTableView setDelegate:self];
    [self.networksTableView setDataSource:self];
    
    self.networksTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    self.networksTableView.separatorInset =  UIEdgeInsetsMake(5, 3, 5, 5);
    [self.networksTableView registerClass:[ UITableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    
    
    /* Make sure our table view resizes correctly */
    self.networksTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    addedSocialNetworks = [[NSMutableArray alloc]init];
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

- (void)buttonPress {
    
    CAPopupWindow* popView = [[CAPopupWindow alloc] initWithObjectList:@[
                                                                         [CAWindowObject windowObject:sharedUserManager.socialNetworks[0] image:sharedUserManager.socialNetworkImages[sharedUserManager.socialNetworks[0]] target:self action:@selector(addFacebook)],
                                                                         [CAWindowObject windowObject:sharedUserManager.socialNetworks[1] image:sharedUserManager.socialNetworkImages[sharedUserManager.socialNetworks[1]] target:self action:@selector(addTwitter)],
                                                                         [CAWindowObject windowObject:sharedUserManager.socialNetworks[2] image:sharedUserManager.socialNetworkImages[sharedUserManager.socialNetworks[2]] target:self action:@selector(addInstagram)],
                                                                         [CAWindowObject windowObject:sharedUserManager.socialNetworks[3] image:sharedUserManager.socialNetworkImages[sharedUserManager.socialNetworks[3]] target:self action:@selector(addSnapchat)]]];
    [popView presentInView:self.view];
    
}

- (void) addFacebook
{
    NSLog(@"adding facebook");
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

- (IBAction)clickedLogOut:(id)sender
{
    [defaults setBool:NO forKey:@"loggedIn"];
    
    SignInViewController *signIn = [[SignInViewController alloc] init];
    signIn = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInController"];
    [self presentViewController:signIn animated:YES completion:nil];

}
@end
