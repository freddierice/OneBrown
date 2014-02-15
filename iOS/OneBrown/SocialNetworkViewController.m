//
//  SocialNetworkViewController.m
//  OneBrown
//
//  Created by Valentin Perez on 2/3/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "SocialNetworkViewController.h"
#import "UserManager.h"
#import "UserProfileViewController.h"

static NSString *TableViewCellIdentifier = @"SNCells";

@interface SocialNetworkViewController ()
{
    UserManager *sharedUserManager;
    NSUserDefaults *defaults;
    NSMutableArray *userPictures;
    NSMutableArray *userPictureNames;
}
@end

@implementation SocialNetworkViewController

@synthesize networkImageView, networkNameLabel;

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
    
    networkNameLabel.text = sharedUserManager.stalkedNetworkName;
    networkImageView.image = sharedUserManager.stalkedNetworkImage;
    
    [self.usersInNetworkTableView setDataSource:self];
    [self.usersInNetworkTableView setDelegate:self];
    
    self.usersInNetworkTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    self.usersInNetworkTableView.separatorInset =  UIEdgeInsetsMake(5, 3, 5, 5);
    [self.usersInNetworkTableView registerClass:[ UITableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    
    /* Make sure our table view resizes correctly */
    self.usersInNetworkTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    userPictureNames = [[NSMutableArray alloc]init];
    userPictures = [[NSMutableArray alloc]init];
    
    userPictureNames = [NSMutableArray arrayWithObjects: @"Valentin Perez", @"Ben Murphy", @"sara", nil];
    
    for (NSString *name in userPictureNames)
        [userPictures addObject:[UIImage imageNamed: name]];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark TableView Delegate Methods
- (NSInteger) numberOfSectionsInTableView:( UITableView *) tableView
{
    if ([ tableView isEqual: self.usersInNetworkTableView] && [defaults objectForKey:@"loggedIn"])
    {
        return 1;
    }
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([tableView isEqual:self.usersInNetworkTableView] && [defaults objectForKey:@"loggedIn"])
    {
        if ([sharedUserManager.stalkedNetworkUsers count]!=0)
            return [sharedUserManager.stalkedNetworkUsers  count];
    }
    
    return 0;
}

- (UITableViewCell *) tableView:( UITableView *) tableView cellForRowAtIndexPath:( NSIndexPath *) indexPath
{
    UITableViewCell *cell = nil;
    if ([tableView isEqual:self.usersInNetworkTableView] && [defaults objectForKey:@"loggedIn"])
    {
        
        //NSString *user = [[NSString alloc]init];
        
        //user = [UserManager socialNetworkForIndex:(int)indexPath.row];
        
        cell = [tableView dequeueReusableCellWithIdentifier: TableViewCellIdentifier forIndexPath:indexPath];
        
        //cell.imageView.image = sharedUserManager.socialNetworkImages[socialNetwork];
        
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        cell.textLabel.text = [sharedUserManager.stalkedNetworkUsers objectAtIndex: indexPath.row];
        
        //cell.imageView.image = sharedUserManager.stalkedUserImage;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        /*
         UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
         [button setImage:[UIImage imageNamed:@"IconProfile"] forState:UIControlStateNormal];
         [button addTarget:self action:@selector(tappedButton) forControlEvents:UIControlEventTouchUpInside];
         button.tag = indexPath.row;
         cell.accessoryView = button;
         */
        [cell.textLabel setFont: [UIFont fontWithName:@"Helvetica" size:14]];
        
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

-(void) tappedButton
{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    sharedUserManager.stalkedUserName = userPictureNames[indexPath.row];
    sharedUserManager.stalkedUserImage  = userPictures[indexPath.row];
    sharedUserManager.stalkedUserNetworks = [NSMutableArray arrayWithObjects:@"Facebook", @"Twitter", @"Instagram", @"Snapchat", nil];
    
    UserProfileViewController *uPViewController = (UserProfileViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileController"];
    [self presentViewController:uPViewController animated:YES completion:nil];
    
    NSLog(@"selected ");
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tapped disclosure");

}


// Returns a UILabel with the given NSString.
- (UILabel *) newLabelWithTitle:( NSString *) paramTitle
{
    UILabel *label = [[ UILabel alloc] initWithFrame:CGRectZero];
    label.text = paramTitle;
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit]; return label;
}


- (IBAction)clickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
